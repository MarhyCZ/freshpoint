//
//  SettingsView.swift
//  freshpoint
//
//  Created by Michal Marhan on 11.05.2023.
//

import SwiftUI
import MapKit
import SwiftUIKit

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    @State private var presentSheet = true
#if os(iOS)
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
#elseif os(macOS)
    @NSApplicationDelegateAdaptor var delegate: NSAppDelegate
#endif
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.mapRegion, showsUserLocation: true, annotationItems: viewModel.fridges) {
                fridge in
                MapAnnotation(coordinate: fridge.corelocation.coordinate) {
                    Button(action: {
                        viewModel.selectFridge(fridge)
                        presentSheet = true
                    }) {
                        Image(systemName: "refrigerator.fill")
                            .foregroundColor(.white)
                            .frame(width: 15,height: 15)
                            .padding(10)
                            .background(fridge.id == viewModel.selectedFridge?.id ? Color.orange : Color.accentColor)
                            .clipShape(Circle())
                    }

                    
                }
            }.sheet(isPresented: $presentSheet) {
                makeSheet(from: viewModel)
            }
        }
        .ignoresSafeArea()
        .task {
            await viewModel.fetch()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task { @MainActor in
                    // Michaluv fix - Fixes bug when sheet becomes dimmed after resuming app
                    presentSheet = false
                }
            }
        }
    }
    
    func makeSheet(from viewModel: SettingsViewModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack {
                makeFridgeOverview()
            }
            Text("Nejbližší lednice od vás:")
            List {
                ForEach(viewModel.fridges.prefix(5)) { fridge in
                    Button {
                        viewModel.selectFridge(fridge)
                    } label: {
                        HStack(alignment: .center) {
                            Text(fridge.location.name)
                            Spacer()
                            Text(fridge.userDistance.formatted()).font(.caption)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
        .presentationDetents(undimmed: [.height(200), .medium])
        .presentationBackground(.thinMaterial)
        // .interactiveDismissDisabled()
        
    }
    
    @ViewBuilder
    func makeFridgeOverview() -> some View {
        if let fridge = viewModel.selectedFridge ?? viewModel.closestFridge {
            HStack {
                VStack(alignment: .leading) {
                    Text((viewModel.selectedFridge?.id == viewModel.closestFridge?.id) ? "Nejbližší lednice" : "Vybraná lednice").font(.subheadline)
                    Text(fridge.location.name).font(.headline)
                }
                Spacer()
                Text(fridge.userDistance.formatted())
            }
            HStack {
                FormActionButton(icon: Image(systemName: "takeoutbag.and.cup.and.straw.fill") , title: "Nastavit jako výchozí") {
                    viewModel.saveFridge()
                    dismiss()
                }
                FormActionButton(icon: Image(systemName: "bell.fill"), title: "Zapni si notifikace") {
                    viewModel.enableNotifications()
                }
            }
        }
    }
    
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
