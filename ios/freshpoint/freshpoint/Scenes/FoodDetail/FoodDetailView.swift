//
//  FoodListView.swift
//  freshpoint
//
//  Created by Michal Marhan on 12.05.2023.
//

import SwiftUI

struct FoodDetailView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @State var foodItem: FoodItem
    var body: some View {
        VStack {
            AsyncImage(url: foodItem.imageURL).background(Color.white)
            Text(foodItem.name).font(.largeTitle)
            Text(foodItem.info)
            Text(foodItem.price.description)
            Spacer()
            Button(
                "Zpět na přehled produktů",
                action: { dismiss() }
            )
        }
    }
    
}

#if DEBUG
struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(foodItem: FoodItem.mockedFoodProducts[0])
    }
}
#endif
