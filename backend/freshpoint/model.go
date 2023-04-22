package freshpoint

type FoodItem struct {
	Category string `json:"category"`
	Name     string `json:"name"`
	ImageURL string `json:"imageURL"`
	Info     string `json:"info"`
	Price    int    `json:"price"`
	Quantity int    `json:"quantity"`
}

type FreshPointCatalog struct {
	Categories []string   `json:"categories"`
	Products   []FoodItem `json:"products"`
}
