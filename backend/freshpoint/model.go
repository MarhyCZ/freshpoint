package freshpoint

type FoodItem struct {
	Category   string `json:"category"`
	Name       string `json:"name"`
	ImageURL   string `json:"imageURL"`
	Info       string `json:"info"`
	Price      int    `json:"price"`
	Quantity   int    `json:"quantity"`
	Discounted bool   `json:"discount"`
}

type CategoryItem struct {
	Name     string     `json:"name"`
	Products []FoodItem `json:"products"`
}

type FridgeCatalog struct {
	Categories []CategoryItem `json:"categories"`
	Products   []FoodItem     `json:"products"`
}

type CatalogChanges struct {
	Discounts []FoodItem
	New       []FoodItem
}

type Fridge struct {
	Prop     FridgeProp     `json:"prop"`
	Location FridgeLocation `json:"location"`
}
type FridgeProp struct {
	Id        int    `json:"id"`
	Username  string `json:"username"`
	Address   string `json:"address"`
	Lat       string `json:"lat"`
	Lon       string `json:"lon"`
	Active    int    `json:"active"`
	Discount  int    `json:"discount"`
	Suspended int    `json:"suspended"`
}

type FridgeLocation struct {
	Name    string `json:"name"`
	Address string `json:"address"`
	Lat     string `json:"lat"`
	Lon     string `json:"lon"`
}
