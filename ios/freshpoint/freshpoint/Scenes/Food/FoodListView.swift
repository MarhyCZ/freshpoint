//
//  FoodListView.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import SwiftUI

struct FoodListView: View {
    @ObservedObject var foodFetcher = FoodItemFetcher()
    var body: some View {
        List(foodFetcher.freshpointCatalog.products) { item in
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
                        .foregroundColor(.gray)
                    Text("Kusů: \(item.quantity)")
                        .foregroundColor(.gray)
                }
            }
        }.task {
            await foodFetcher.fetch()
        }
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
