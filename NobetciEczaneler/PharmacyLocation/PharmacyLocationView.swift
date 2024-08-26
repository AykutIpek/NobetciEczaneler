//
//  PharmacyLocation.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 23.08.2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct PharmacyLocationView: View {
    @StateObject var viewModel: PharmacyLocationViewModel
    @State private var isBottomSheetPresented = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                mapView
            }
            .onAppear {
                viewModel.setupInitialRegion()
            }
            .sheet(isPresented: $isBottomSheetPresented) {
                BottomSheetView(
                    pharmacy: viewModel.selectedPharmacy ?? PharmacyModel(name: "", dist: "", address: "", phone: "", loc: ""),
                    onDismiss: {
                        isBottomSheetPresented = false
                    },
                    onGetDirections: {
                        viewModel.getDirections()
                        isBottomSheetPresented = false
                    }
                )
                .presentationDetents([.height(geometry.size.height * 0.5)])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private var mapView: some View {
        ZStack {
            Map(
                coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: [viewModel.pinCoordinate].compactMap { coordinate in
                    guard let coordinate = coordinate else { return nil }
                    return IdentifiableCoordinate(coordinate: coordinate)
                },
                annotationContent: { (coordinateWrapper: IdentifiableCoordinate) in
                    MapAnnotation(coordinate: coordinateWrapper.coordinate) {
                        Image(systemName: "pills.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: viewModel.pinTapped ? 80 : 40, height: viewModel.pinTapped ? 80 : 40)
                            .foregroundColor(.red)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: viewModel.pinTapped)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.pinTapped.toggle()
                                    viewModel.selectPharmacy()
                                    isBottomSheetPresented = true
                                }
                            }
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)

            if let route = viewModel.route {
                MapOverlay(route: route)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


struct MapOverlay: UIViewRepresentable {
    let route: MKRoute

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let region = MKCoordinateRegion(route.polyline.boundingMapRect)
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(route.polyline)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map view if necessary
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapOverlay

        init(_ parent: MapOverlay) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct MapPolyline: UIViewRepresentable {
    let polyline: MKPolyline

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addOverlay(polyline)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapPolyline

        init(_ parent: MapPolyline) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

#Preview {
    PharmacyLocationView(
        viewModel: PharmacyLocationViewModel(
            PharmacyModel(
                id: UUID(),
                name: "Akkaya Eczanesi",
                dist: "İzmir",
                address: "İzmir mahallesi bornova caddesi no:15/6 Bornova/İZMİR",
                phone: "2322456744",
                loc: "32,4442, 33,5542"
            )
        )
    )
}
