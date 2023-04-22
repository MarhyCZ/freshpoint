//
//  FoodListView.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import SwiftUI

struct FoodListView: View {
    @State var foodItems: [FoodItem] = FoodItem.mockedFoodProducts
    
    var body: some View {
        List(foodItems) { item in
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
        }
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
