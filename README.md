## Rick and Morty App

This iOS application displays a list of Rick and Morty characters using the Rick and Morty API. It allows users to filter the list by character status (Alive, Dead, or Unknown), view character details, and handle pagination. 
The app is built using **UIKit** for the character list and integrates **SwiftUI** for the character card and character detail screen.

---

### Instructions for Building and Running the Application

#### Prerequisites

- **Xcode 13** or newer
- **iOS 15** or newer for deployment

#### Building the Project

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/atta-ahmed/RickAndMorty
   cd RickAndMorty
   ```

2. Open the Xcode project:

    ``` bash
    open RickAndMorty.xcodeproj
    ```

3. Select the appropriate scheme for your device or simulator.

4. Build and run the application by pressing Cmd + R in Xcode or selecting   Product > Run from the top menu.

### Running Tests
The project includes unit tests for the view models and networking logic. To run the tests:

- In Xcode, select Product > Test or press Cmd + U.
The test suite will execute and report the results in the Test Navigator panel.

---

## Assumptions and Decisions

- XIB files are used instead of Storyboards for more granular control over the view setup and to improve modularity.

- View models are injected into view controllers to improve testability and adhere to the MVVM architecture pattern.

- RequestProtocol & CharacterRequest: We use a RequestProtocol to standardize how network requests are structured across the app. The CharacterRequest enum encapsulates all API calls related to character data. This enum provides a clean and easy-to-read structure for handling different endpoints.

- The CharacterDetails view is implemented using SwiftUI to demonstrate SwiftUI integration in a UIKit-based project.
 
- Mocked API Clients were used in unit tests to simulate network responses without making actual API calls.

---

## Challenges & Solutions
1. Mixing SwiftUI with UIKit

    **Challenge**: Integrating SwiftUI views into a UIKit-based app.
    **Solution**: Used UIHostingController to wrap the SwiftUI views inside UIKit view controllers for navigation and dismissing.
    
2. Pagination 

    **Challenge**: While implementing pagination, I was initially unsure whether to use the next page URL that came with each API response or simply increment a page number with each request. This was further complicated by the need to prevent multiple requests from being sent at the same time, especially when filtering was active.

    **Solution**: After evaluating both options, I decided to use a page number approach, incrementing it after each successful fetch. This provided more control over the pagination logic and allowed me to better manage the app's state. Additionally, I implemented a mechanism to prevent duplicate fetches by ensuring that no new requests are sent while a previous one is still in progress or when the user is actively filtering the data. This ensures smoother user experience and avoids unnecessary API calls.

3. Filtering Characters by Status

    **Challenge**: Implementing filter functionality while maintaining the original data set.
    **Solution**: Used a two-array approach: one for the original character list and another for the filtered list. The filtering occurs on the secondary array.
    
    **Challenge**: Implementing a filter UI for character statuses required finding the right balance between complexity and simplicity. While initially considering using a collection view for the various filters, I realized that the number of statuses was limited to only 3.
    
    **Soultion**: Given the small number of statuses, I decided to use a button-based interface instead of a collection view. I utilized Outlet Collection and Action Collection to simplify the code and avoid unnecessary complexity. Additionally, the CharacterStatus enum was implemented to handle the filter logic for each status in a clean and structured manner, making it easy to manage the different states within the filter UI.
    
4. Unit Testing the ViewModel

    **Challenge**: Ensuring the ViewModel can be tested independently of the API layer.
    **Solution**: Created a MockedAPIClient that simulates different API responses for unit testing the CharacterListViewModel.
    
