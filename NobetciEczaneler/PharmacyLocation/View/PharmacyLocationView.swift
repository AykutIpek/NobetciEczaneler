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
        GeometryReader { containingGeometry in
            ZStack {
                mapView
            }
            .onAppear {
                viewModel.setupInitialRegion()
            }
            .coordinateSpace(name: Consts.sheetCoordinateSpacer)
            .sheet(isPresented: $isBottomSheetPresented) {
                handleSheetView(containingGeometry)
            }
        }
    }
    
    private var mapView: some View {
        Map(
            coordinateRegion: $viewModel.region,
            showsUserLocation: true,
            annotationItems: viewModel.mapAnnotationItems,
            annotationContent: { (coordinateWrapper: IdentifiableCoordinate) in
                annotationContent(coordinateWrapper: coordinateWrapper)
            }
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private func annotationContent(
        coordinateWrapper: IdentifiableCoordinate
    ) -> MapAnnotation<(some View)?> {
        MapAnnotation(coordinate: coordinateWrapper.coordinate) {
            if let pinCoordinate = viewModel.pinCoordinate, viewModel.areCoordinatesEqual(
                coordinateWrapper.coordinate,
                pinCoordinate
            ) {
                mapPinView
            }
        }
    }
    
    private var mapPinView: some View {
        Image(systemName: SystemImages.mappinCircleFill.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: viewModel.pinTapped ? 60 : 40, height: viewModel.pinTapped ? 60 : 40)
            .foregroundColor(.red)
            .scaleEffect(viewModel.pinTapped ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: viewModel.pinTapped)
            .onTapGesture {
                withAnimation {
                    viewModel.pinTapped.toggle()
                    isBottomSheetPresented = true
                }
            }
    }
    
    private func handleSheetView(_ containingGeometry: GeometryProxy) -> some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .named(Consts.sheetCoordinateSpacer))
            let globalFrame = containingGeometry.frame(in: .global)
            let buffer = 5.0
            
            BottomSheetView(
                pharmacy: viewModel.selectedPharmacy ?? PharmacyModel(
                    name: .empty,
                    dist: .empty,
                    address: .empty,
                    phone: .empty,
                    loc: .empty
                ),
                onDismiss: {
                    didDismissAction()
                },
                onGetDirections: {
                    viewModel.openInAppleMaps()
                    isBottomSheetPresented = false
                }
            )
            .presentationDetents([.height(globalFrame.size.height * 0.5)])
            .presentationDragIndicator(.visible)
            .onChange(of: frame.origin.y) { newValue in
                if newValue > globalFrame.maxY + buffer {
                    didDismissAction()
                }
            }
        }
    }
    
    private func didDismissAction() {
        isBottomSheetPresented = false
        withAnimation {
            viewModel.pinTapped = false
        }
    }
}

#Preview {
    PharmacyLocationView(
        viewModel: PharmacyLocationViewModel(
            pharmacy: PharmacyModel(
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
