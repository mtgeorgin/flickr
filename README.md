# flickr
Flickr search application written in Swift, with SwiftUI and Combine. This project searches for images using Flickr API and displays in 3 column grid with endless scrolling.

<img width="294" height="640" alt="WelcomeM" src="https://github.com/user-attachments/assets/99af71bb-1900-4d17-8d57-70089e117ea3" />
<img width="294" height="640" alt="FlickrImageSearchM" src="https://github.com/user-attachments/assets/1ae229a4-732f-43ec-8f6a-b2804bdbba3a" />
<img width="294" height="640" alt="DetailsM" src="https://github.com/user-attachments/assets/76be422d-b9d0-444c-a077-4f2e410ba7bf" />

## Getting Started

- Clone the repo and run FlickrSearch.xcodeproj
- Run the project and search for any keyword like "kittens".
- The application uses the ViewInspector package for Unit Testing.

## Application Details
The application is built as a pure SwiftUI app utilising Combine to coordinate image fetching. The Flickr search API returns a list of thumbnail image urls and additional data for more detailed image fetching.

### Views
- **ImageGridView**: The main SwiftUI view that lays out the image thumbnails in a grid three images wide. It includes text input for search term entry and validation. It incorporates endless scrolling.
- **ThumbnailView**: A component used in ImageGridView that encapulates the thumbnail image, which is fetched and cached using **AsyncImage** via the thumbnail URL
- **DetailView**: This SwiftUI view displays the full resolution image after clicking on a thumbnail on the ImageGridView.
- **InitialView**: This provides a landing page to instruct the user.
- **LoadingView**: This provides a spinning loader while the API call is made.
- **ErrorView**: This provide error information should there be a problem with a given search.
- **NoImagedFoundView**: This is shown when there are no images returned for a given search text, for example "@@"

### ViewModels
- **FlickrImageViewModel**: This class represents data to be rendered in the SwiftUI views via the published viewState. 

### Models
- **FlickrSearchResult**: This class represents the structure of response of request from flicker service for the searched text. This class uses codable protocal and used for parsing.
- **Photo**: This model contains the data structure for the images details. It contains the thumbnail image URL and a getter method that generates URLs for fetching full resolution images. This class uses codable protocal used for parsing.

### Services
- **FlickrAPIService**: This service class is responsible for preparing the request, fetching and parsing response for consecutive pages. It internally uses Combine's **dataTaskPublisher** to perform the request. 

