//
//  FoodListView.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import SwiftUI

struct FoodListView: View {
    @StateObject var viewModel = FoodListViewModel()
    @Environment(\.scenePhase) var scenePhase
    @State private var currentCategory: String = "Nápoje"
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading, .failed, .initial:
                ProgressView()
            case .fetched:
                makeList(from: viewModel.catalog.categories)
                    .overlay(alignment: .top) {
                        makeHeader(from: viewModel.catalog.categories)
                    }
            }
        }
        .overlay(alignment: .top, content: {
            Color.clear // Or any view or color
                .background(.regularMaterial) // I put clear here because I prefer to put a blur in this case. This modifier and the material it contains are optional.
                .edgesIgnoringSafeArea(.top)
                .frame(height: 0) // This will constrain the overlay to only go above the top safe area and not under.
        })
        .task {
            await viewModel.fetch()
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task { @MainActor in
                    await viewModel.fetch()
                }
            }
        }
    }
    
    func makeHeader(from categories: [CategoryItem]) -> some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(categories) { category in
                        Text(category.name)
                            .fontWeight(category.name == currentCategory ? .bold : .regular)
                            .foregroundColor(category.name == currentCategory ? .accentColor : .primary)
                            .padding()
                            .tag(category.name)
                    }
                }
                .background(Color.clear)
                .listRowInsets(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 0,
                    trailing: 0))
            }
            .background(.thinMaterial)
            .onChange(of: currentCategory) { newCategory in
                withAnimation(.easeInOut) {
                    reader.scrollTo(newCategory)
                    
                }
            }
        }
        
    }
    
    func makeList(from categories: [CategoryItem]) -> some View {
        List(categories) { category in
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    EmptyView().onChange(of: geometry.frame(in: .global)) { globalFrame in
                        let offset = globalFrame.minY
                        print("\(category.name): \(offset)")
                        let height = UIApplication.shared.windows.first!.safeAreaInsets.top + 100
                        if offset < height {
                            currentCategory = category.name
                        }
                    }
                }.frame(width: 0,height: 0)
                Text(category.name).padding().font(.title)
                ForEach(category.products) { item in
                    HStack {
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text("\(item.price),- Kč")
                                .foregroundColor(item.discount ? .red : .gray)
                            Text("Kusů: \(item.quantity)")
                                .foregroundColor(.gray)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .tag(category.name)
            }
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView(viewModel: FoodListViewModel())
    }
}
