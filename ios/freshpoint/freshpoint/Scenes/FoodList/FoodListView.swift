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
        NavigationStack {
            switch viewModel.state {
            case .loading, .failed, .initial:
                ProgressView()
            case .fetched:
                makeList(from: viewModel.catalog.categories)
                    .padding(.top, 40)
                    .overlay(alignment: .top) {
                        makeHeader(from: viewModel.catalog.categories)
                    }
            }
        }
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
        VStack {
            HStack() {
                Text("O2 Czech republic")
                Spacer()
                Button {
                    print("Edit button was tapped")
                } label: {
                    Image(systemName: "location")
                }
            }
            .padding(.horizontal)
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
                    
                }
                .onChange(of: currentCategory) { newCategory in
                    withAnimation(.easeOut) {
                        reader.scrollTo(newCategory, anchor: .center)
                        
                    }
                }
            }
        }
        .background(.thinMaterial)
        
    }
    
    func makeList(from categories: [CategoryItem]) -> some View {
        List(categories) { category in
            VStack(alignment: .listRowSeparatorLeading) {
                GeometryReader { geometry in
                    EmptyView().onChange(of: geometry.frame(in: .global)) { globalFrame in
                        let offset = globalFrame.minY
                        print("\(category.name): \(offset)")
#if os(iOS)
                        let window = UIApplication.firstKeyWindowForConnectedScenes
                        let height = window?.safeAreaInsets.top
#elseif os(macOS)
                        let window = NSApplication.shared.keyWindow
                        let height = window?.contentView!.safeAreaInsets.top
#endif
                        
                        if let height {
                            if offset < height + 200 &&
                                currentCategory != category.name {
                                currentCategory = category.name
                            }
                        }
                    }
                }.frame(width: 0,height: 0)
                Text(category.name).padding().font(.title).bold()
                ForEach(category.products) { item in
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text("\(item.price),- Kč")
                                .foregroundColor(item.discount ? .red : .gray)
                            Text("Kusů: \(item.quantity)")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .background(.white)
                        .cornerRadius(10)
                        
                    }
                    .padding(.vertical, 10)
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
