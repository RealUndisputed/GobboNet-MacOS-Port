# Gobbonet — Developer Guide

Gobbonet is a self-hosted, offline AI chat frontend designed for local GGUF models, running seamlessly on macOS, specifically optimized for Apple Silicon (ARM64). This project requires no build step, external dependencies, or accounts, making it easy to set up and use.

## Project Structure

The project consists of the following key components:

- **chat.html**: The frontend shell that loads JavaScript modules and stylesheets.
- **js/**: A directory containing 24 JavaScript modules that manage various functionalities, including configuration, model handling, state management, and rendering.
- **css/**: A directory with 15 stylesheets that define the visual styles for the application, covering layout, components, and responsive design.
- **default-characters.json**: Contains definitions for four built-in character presets, including names, descriptions, and personality traits.
- **granite.jinja**: A custom Jinja template for Granite 3.x models, handling specific formatting and reasoning modes.
- **fileserver.ps1**: A PowerShell script that acts as a web server and reverse proxy, serving static files and handling requests to the model server.
- **launch.bat**: The entry point for the application, managing password setup, hardware probing, model downloading, and health monitoring.
- **setup-lan.bat**: A batch script for setting up firewall rules for LAN access, typically run once.
- **hardware-probe.ps1**: Detects hardware specifications such as GPU and RAM for model recommendations.
- **hw-recommend.ps1**: Generates recommendations for model usage based on hardware specifications.
- **identify-model.ps1**: Extracts metadata from models, including family and context limits.
- **macos/**: Contains macOS-specific scripts and documentation.
  - **build.sh**: A shell script for building the application on macOS.
  - **run.sh**: A shell script for running the application on macOS.
  - **README.md**: Documentation specific to the macOS build and run process.
- **models/**: Intended for user-downloaded model files in .gguf format.
- **INDEX.md**: A structural index of the chat.html file, detailing views, modals, functions, and CSS classes.
- **README.md**: This documentation file, providing setup instructions and usage guidelines.
- **.gitignore**: Specifies files and directories to be ignored by version control.

## Quick Start for macOS

To get started with Gobbonet on macOS, follow these steps:

1. Open a terminal and navigate to the project directory:
   ```
   cd gobbonet
   ```

2. Make the macOS scripts executable:
   ```
   chmod +x macos/build.sh
   chmod +x macos/run.sh
   ```

3. Build the application:
   ```
   ./macos/build.sh
   ```

4. Run the application:
   ```
   ./macos/run.sh
   ```

## Features

- **Offline Functionality**: Operates entirely offline, ensuring privacy and security.
- **Customizable Characters**: Users can define and customize character presets.
- **Cross-Device Sync**: State is synced across devices for a seamless experience.
- **User-Friendly Interface**: Intuitive design for easy navigation and interaction.

## Contributing

Gobbonet is an open-source project. Contributions are welcome! Please refer to the contributing guidelines for more information.

## License

This project is licensed under the MIT License. See the LICENSE file for details.