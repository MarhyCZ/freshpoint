package freshpoint

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"net/url"
	"regexp"
	"strconv"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

const (
	// https://my.freshpoint.cz/device/product-list/298
	fridgeURL = "https://my.freshpoint.cz/device/product-list/"
)

func FetchProducts(fridge Fridge) FridgeCatalog {
	res, err := http.Get(fridgeURL + strconv.Itoa(fridge.Prop.Id))
	if err != nil {
		log.Fatal(err)
	}
	defer res.Body.Close()
	if res.StatusCode != 200 {
		log.Fatalf("Fetching Freshpoint error: %d %s", res.StatusCode, res.Status)
	}

	// Load the HTML document
	doc, err := goquery.NewDocumentFromReader(res.Body)
	if err != nil {
		log.Fatal(err)
	}

	categories := make([]CategoryItem, 0)
	products := make([]FoodItem, 0)

	doc.Find("a.nav-link").Each(func(i int, link *goquery.Selection) {
		catName := link.Text()
		categories = append(categories, CategoryItem{
			Name:     catName,
			Products: make([]FoodItem, 0),
		})
	})

	for index, category := range categories {
		selector := "#" + escapeID(category.Name)
		doc.Find(selector).Each(func(i int, div *goquery.Selection) {
			// For each item found, get the food products
			div.Find(".col-12.col-sm-6.col-lg-4.mb-5.mb-sm-3").Each(func(i int, productEl *goquery.Selection) {
				product := parseFoodProduct(category.Name, productEl)
				if product.Quantity > 0 {
					products = append(products, product)
					categories[index].Products = append(categories[index].Products, product)
				}
			})
		})
	}

	return FridgeCatalog{
		Categories: categories,
		Products:   products,
	}
}

func parseFoodProduct(category string, product *goquery.Selection) FoodItem {
	// Get the name
	name := product.Find(".col-12.mb-2 > .font-weight-bold").Text()

	// Get the image
	imageURL, _ := product.Find(".img-fluid").Attr("src")

	// Get the info
	info := product.Find(".product-info").Text()

	// Get the price
	discount := false
	priceString := product.Find(".price").Text()
	if len(priceString) == 0 {
		discount = true
		priceString = product.Find(".text-danger.font-weight-bold").Text()
	}
	price, err := strconv.Atoi(strings.Split(priceString, ".")[0])
	if err != nil {
		log.Println("Error parsing price for: " + name)
		price = 0
	}

	// Get the quantity
	quantity := 0
	quantityString := strings.Fields(product.Find(".col-6.pr-md-3 > .px-2.font-italic.font-weight-bold").Text())
	if len(quantityString) > 0 {
		quantity, err = strconv.Atoi(quantityString[0])
		if err != nil {
			switch quantityString[0] {
			case "Poslední":
				quantity = 1
			default:
				log.Println("Error parsing quantity for: " + name)
				quantity = 0
			}
		}
	}
	return FoodItem{category, name, imageURL, info, price, quantity, discount}
}

// Because Freshpoint uses czech labels for div IDs...
func escapeID(id string) string {

	// Escape any special characters in the ID
	escapedID := url.QueryEscape(id)

	// Replace "+" with "\+" to escape it in GoQuery selectors
	escapedID = strings.ReplaceAll(escapedID, "+", "\\+")
	escapedID = strings.ReplaceAll(escapedID, "%", "\\%")

	return escapedID
}

func FetchFridges() []Fridge {
	res, err := http.Get("https://my.freshpoint.cz")
	log.Println("Fetching Fridges list")
	if err != nil {
		log.Fatal(err)
	}
	defer res.Body.Close()
	if res.StatusCode != 200 {
		log.Fatalf("Fetching Freshpoint Fridges list error: %d %s", res.StatusCode, res.Status)
	}
	body, err := io.ReadAll(res.Body)
	if err != nil {
		log.Println("Error in parsing body response to text in Freshpoint devices list")
	}

	var exp, _ = regexp.Compile(`devices = "(.+)";`)
	matches := exp.FindStringSubmatch(string(body))
	jsString := strings.ReplaceAll(matches[1], "\\", "")
	println(jsString)
	var fridges []Fridge
	err = json.Unmarshal([]byte(jsString), &fridges)
	if err != nil {
		log.Print("Error while parsing fridge list JSON into struct: ")
		log.Println(err.Error())
	}
	return fridges
}
