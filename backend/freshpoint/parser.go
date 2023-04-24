package freshpoint

import (
	"log"
	"net/http"
	"net/url"
	"strconv"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

func FetchProducts() FreshPointCatalog {
	res, err := http.Get("https://my.freshpoint.cz/device/product-list/298")
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

	categories := make([]string, 0)
	products := make([]FoodItem, 0)

	doc.Find("a.nav-link").Each(func(i int, link *goquery.Selection) {
		category := link.Text()
		categories = append(categories, category)
	})

	for _, category := range categories {
		selector := "#" + escapeID(category)
		doc.Find(selector).Each(func(i int, div *goquery.Selection) {
			// For each item found, get the food products
			div.Find(".col-12.col-sm-6.col-lg-4.mb-5.mb-sm-3").Each(func(i int, productEl *goquery.Selection) {
				product := parseFoodProduct(category, productEl)
				products = append(products, product)
			})
		})
	}

	return FreshPointCatalog{
		Categories: categories,
		Products:   products,
	}
}

func parseFoodProduct(category string, product *goquery.Selection) FoodItem {
	// Get the name
	name := product.Find(".col-12.mb-2 > .font-weight-bold").Text()

	// Get the image
	imageURL, _ := product.Find(".w-auto.img-fluid").Attr("src")

	// Get the info
	info := product.Find(".product-info").Text()

	// Get the price
	priceString := product.Find(".price").Text()
	if len(priceString) == 0 {
		priceString = product.Find(".text-danger.font-weight-bold").Text()
	}
	price, err := strconv.Atoi(strings.Split(priceString, ".")[0])
	if err != nil {
		log.Println("Error parsing price for: " + name)
		price = 0
	}

	// Get the quantity
	quantityString := strings.Fields(product.Find(".col-6.pr-md-3 > .px-2.font-italic.font-weight-bold").Text())
	quantity, err := strconv.Atoi(quantityString[0])

	if err != nil {
		switch quantityString[0] {
		case "Poslední":
			quantity = 1
		default:
			log.Println("Error parsing quantity for: " + name)
			quantity = -1
		}
	}
	return FoodItem{category, name, imageURL, info, price, quantity}
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
