package freshpoint

import (
	"log"
)

func GetChanges(old []FoodItem, new []FoodItem) CatalogChanges {
	oldMap := make(map[string]FoodItem)
	for key, item := range old {
		print(key)
		oldMap[item.Name] = item
	}

	return CatalogChanges{
		Discounts: getNewDiscounts(oldMap, new),
		New:       getAddedProducts(oldMap, new),
	}
}
func getAddedProducts(old map[string]FoodItem, new []FoodItem) []FoodItem {
	added := make([]FoodItem, 0)

	for _, candidate := range new {
		if _, ok := old[candidate.Name]; !ok {
			added = append(added, candidate)
			log.Println("New item found:", candidate)
		}
	}

	return added
}

func getNewDiscounts(old map[string]FoodItem, new []FoodItem) []FoodItem {
	newDiscounts := make([]FoodItem, 0)
	for _, candidate := range new {
		oldItem, exists := old[candidate.Name]
		// Newly added item and already discounted
		if !exists && candidate.Discounted {
			newDiscounts = append(newDiscounts, candidate)
			log.Println("Brand new item with discount found:", candidate.Name)
		}
		// Existing item discounted
		if exists && candidate.Discounted && !oldItem.Discounted {
			newDiscounts = append(newDiscounts, candidate)
			log.Println("Existing item discounted!:", candidate.Name)
		}

	}
	return newDiscounts
}
