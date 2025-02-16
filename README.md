# ShoppingApp

**ShoppingApp** is an iOS application that allows users to browse and manage products, add them to a shopping list, and view detailed product information using **VIPER architecture** and the [Platzi Fake Store API](https://fakeapi.platzi.com).

## Features

### Main Screen
- Displays a list of products with pagination in a **grid layout** (2 products per row).
- Product cells include:
  - Product image
  - Title
  - "Add to Cart" button
- **Text-based search** functionality for easy product discovery.
- On-screen **filters** with a **Bottom Sheet UI** for applying multiple filters at once.
- **Empty state messages** for:
  - No results found
  - Errors (with retry option)
- Saves the last 5 search queries for quick access.

### Product Details Screen
- Displays detailed information for each product:
  - Product image (with a placeholder for loading errors)
  - Title
  - Description
  - Price
  - Category
- Ability to **share product details** via system sharing options.
- Back navigation to the **main screen**.
- Controls for adjusting **product quantity** (+/- buttons).

### Shopping List Screen
- Displays products added from the main screen or product details.
- Shows product images, prices, and selected quantities.
- Options to:
  - Increase/decrease quantity
  - Remove items
- Supports **persistent storage** (via UserDefaults) to retain shopping list after app relaunch.
- Ability to **share the shopping list** via messaging apps or notes.
- Keeps the shopping list synchronized with the main screen and product details.
- Clicking a product in the shopping list navigates to its **details page**.

## Architecture

The app follows the **VIPER architecture** for better maintainability and scalability:

- **View**: Renders UI and handles user interaction.
- **Interactor**: Contains business logic and communicates with APIs.
- **Presenter**: Acts as a mediator between the View and Interactor.
- **Entity**: Represents the data model (product).
- **Router**: Handles navigation between screens.

## API Integration

- Fetches product data from the [Platzi Fake Store API](https://fakeapi.platzi.com).
- Supports **filtering** and **pagination** of product data.
- Implements **error handling** and **retry mechanisms**.

## Persistent Storage

- Shopping list data is stored **locally** using **UserDefaults** to ensure persistence across app launches.

## Technologies Used

- **Swift**: The primary programming language for iOS development.
- **UIKit**: Framework for building the user interface.
- **VIPER Architecture**: Separates concerns into distinct layers to maintain code clarity.
- **UserDefaults**: For local storage of shopping list data.
- **Platzi Fake Store API**: Provides product data for the app.
- **GCD (Grand Central Dispatch)**: Handles asynchronous operations for network requests and UI updates.

## Installation

To run the project locally, follow these steps:

1. Clone the repository from GitHub:
    ```bash
    git clone https://github.com/irinadeeva/ShopMate.git
    ```

2. Open the project in **Xcode**.

3. Install dependencies if needed.

4. Build and run the app on a simulator or device.

---

## Version Control

The project is managed using **Git** for version control.

---

## Additional Notes

- The app follows modern **iOS design principles** to ensure a seamless user experience.
- **API response handling** ensures smooth interaction even during slow network conditions.

---

Enjoy coding and happy shopping! 🛒
