package apns

type Alert struct {
	Title    string `json:"title"`
	Subtitle string `json:"subtitle"`
	Body     string `json:"body"`
}
