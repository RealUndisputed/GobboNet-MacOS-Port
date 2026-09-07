# Structural index of chat.html

## Views
- **Main View**: The primary interface for user interaction.
- **Character Modal**: Displays character options and settings.
- **Settings Modal**: Allows users to configure application settings.
- **Thread Sidebar**: Lists active threads for quick navigation.

## Modals
- **Character Editor**: Interface for editing character details.
- **Lore View**: Displays lore and context for ongoing conversations.

## Functions
- **render()**: Main rendering function that updates the UI.
- **renderSidebar()**: Renders the sidebar with active threads.
- **renderMessages()**: Displays messages in the chat view.
- **goHome()**: Resets the view to the main landing page.

## CSS Classes
- **.chat-container**: Main container for chat interface.
- **.modal**: Base class for all modal dialogs.
- **.active-thread**: Highlights the currently active thread in the sidebar.
- **.character-card**: Styles for character selection cards.

## JavaScript Modules
- **01-config.js**: Configuration settings for the application.
- **02-model.js**: Handles model interactions and API calls.
- **03-state.js**: Manages application state and persistence.
- **24-boot.js**: Initializes the application and starts the main loop.