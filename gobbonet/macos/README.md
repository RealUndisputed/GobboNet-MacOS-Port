# macOS Build and Run Instructions for Gobbonet

This document provides instructions for building and running the Gobbonet application natively on macOS for Apple Silicon (ARM64).

## Prerequisites

Before you begin, ensure you have the following installed on your macOS system:

- Homebrew (for package management)
- Go (`brew install go`)
- llama.cpp (`brew install llama.cpp`)

GGUF models are stored in `~/.local/share/gobbonet/models`. The macOS launcher
uses Homebrew's native Apple Silicon `llama-server` automatically. Copy at
least one `.gguf` model into that directory before starting local inference.

## Build Instructions

1. Open your terminal and navigate to the Gobbonet project directory:

   ```bash
   cd gobbonet
   ```

2. Make the build script executable:

   ```bash
   chmod +x macos/build.sh
   ```

3. Run the build script to compile the application:

   ```bash
   ./macos/build.sh
   ```

To create the native app bundle for Finder or the Dock:

```bash
./macos/build-app.sh
```

The finished bundle is `build/GobboNet.app`. Drag it into `/Applications`.
It contains the native Swift/WKWebView window and the GobboNet backend runtime.

## Run Instructions

After successfully building the application, you can run it using the following steps:

1. Make the run script executable:

   ```bash
   chmod +x macos/run.sh
   ```

2. Execute the run script to start the application:

   ```bash
   ./macos/run.sh
   ```

## Notes

- Ensure that any platform-specific configurations are set in the build script.
- If you encounter any issues, refer to the main README.md for troubleshooting tips or check the logs generated during the build and run processes.