
# A technical task to build out the app architecture for a messaging client:

## Task Definition
- Build a basic messaging app for iOS.
- Fetch data from a JSON file, which you may bundle with your application rather than fetching remotely.
- Spend no more than 3 hours.
- Build a Conversation List screen and a Message List screen.
	-   Tapping on a conversation should take you to the Message List screen.
- Conversations should be ordered so that the most recent is at the top.
- Messages should be ordered so that the most recent ones are at the bottom.
- Build the application so that it is 'offline first' - e.g. If the JSON cannot be fetched, the previously fetched messages are stored locally and shown instead.

## Constraints and assumptions:

- Your simulator/device is set to Light mode (light/dark could be handled by updating the Style object with more time).
 - Data is loaded from bundled json, and overwrites the existing chats on launch. Chats are persisted with SwiftData.
    New chats are persisted, but on launch they will be overridden.  With more time I would implement update-or-insert functionality.
    In a real-world scenario the API would return updates to chats past a certain timestamp, which would be used to update records selectively.
 - Scrolling to the bottom of the message list automatically is not easily (or quickly, rather) implemented - there is an attempt to work around it, but I ran out of time before I could get it working properly.
 - Not a lot of time was left for UI tweaks and making it look especially pretty. The Style environment object demonstrates how UI theming and consistency of design can be achieved.
 - There is no pull to refresh - only loading on app launch. In a real world scenario you'd also need to implement push notifications to trigger an update as well as some other real-time mechanism to push to device.
 - I'm taking advantage of SwiftData working with SwiftUI so that the UI can hook directly into model updates.
 - In a real world scenario I'd probably prefer to have my MessageService publish chats and have my view model listen for updates so I have more control of when the UI updates from model changes.
