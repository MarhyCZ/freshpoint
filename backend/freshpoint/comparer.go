package freshpoint

import "fmt"

func GetNewProducts(old []FoodItem, current []FoodItem) []FoodItem {
	m := make(map[FoodItem]bool)
	for _, foodItem := range old {
		m[foodItem] = true
	}

	new := make([]FoodItem, 0)
	for _, foodItem := range current {
		if _, ok := m[foodItem]; !ok {
			new = append(new, foodItem)
			fmt.Println("New item found:", foodItem)
		}
	}
	return new
}
