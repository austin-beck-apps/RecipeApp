# Recipe App

## Summary

This Recipe App is a single-screen SwiftUI application that fetches and displays a list of recipes from a remote JSON endpoint. Each recipe shows its name, cuisine type, and a photo. The app includes several key features:

- **Swift Concurrency:** All asynchronous operations (data fetching and image loading) are implemented using async/await.
- **Custom Image Caching:** Images are loaded on demand and cached to disk using a custom actor-based solution, ensuring thread safety and minimizing repeated network requests.
- **Dynamic UI Layouts:** Users can switch between two view modes:
  - **Small View:** A compact layout using the small image.
  - **Large View:** A more detailed layout using the large image, with a more spacious design.
- **YouTube Integration:** If a recipe has an associated YouTube link, a clickable link is displayed for users to open the video.
- **Robust Error Handling:** The app gracefully handles errors, including malformed data and empty responses, and provides the option to refresh or retry fetching recipes.
- **Pull-to-Refresh & Toolbar Controls:** Users can refresh the list using pull-to-refresh or a toolbar button. A segmented control in the navigation bar lets users toggle between the small and large view layouts.

## Focus Areas

- **Modern Concurrency & SwiftUI:** Emphasis was placed on leveraging Swift’s async/await and SwiftUI for a responsive, declarative UI.
- **Efficient Networking & Caching:** A custom actor-based image cache ensures that images are downloaded only when needed and then stored on disk to minimize redundant network activity.
- **Flexible UI & User Experience:** Added a toggle to switch between a compact and a detailed recipe view, and integrated YouTube links when available.
- **Error Resilience:** The app gracefully handles errors such as malformed data, empty responses, and network issues, providing users with feedback and retry options.

## Time Spent

Approximately 3 hours were spent on this project:
- **30 minutes:** Planning the project structure and features.
- **1 hours:** Implementing the core networking, image caching, and SwiftUI UI elements.
- **1 hours:** Enhancing the UI with multiple view modes and YouTube link integration.
- **30 minutes:** Writing and updating unit tests, debugging, and documentation.

## Trade-offs and Decisions

- **Custom Image Caching:** Instead of relying on URLSession’s built‑in caching or a third‑party library, a custom actor-based image cache was implemented. This provides complete control over caching behavior at the expense of more code.
- **View Mode Toggle:** Offering both a small and a large view increases UI complexity but gives users flexibility in how they view recipes.
- **Error Handling:** The app discards the entire recipe list if any data is malformed, keeping error handling simple while potentially ignoring some valid data.
- **Live Endpoint Testing:** Unit tests use live endpoints for simplicity; a more robust solution might include dependency injection or URL protocol stubs for isolation.

## Weakest Part of the Project

The custom image caching solution, while functional and thread-safe thanks to the actor, is relatively basic.

## Additional Information

- The app uses no external dependencies and relies solely on Apple frameworks.
- All asynchronous operations are implemented with Swift Concurrency (async/await).
- The UI is built entirely in SwiftUI and includes support for pull-to-refresh and a view mode toggle.
- If a recipe includes a YouTube link, a clickable "Watch on YouTube" link is displayed, opening the link in the user's default browser.
- The project includes unit tests for the core networking and image caching logic.
