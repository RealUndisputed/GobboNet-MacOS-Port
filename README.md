# GobboNet for macOS (Apple Silicon Port) 🍏⚡

[![Platform](https://img.shields.io/badge/Platform-macOS%20%28Apple%20Silicon%20ARM64%29-black?style=flat&logo=apple)](https://www.apple.com)
[![Architecture](https://img.shields.io/badge/Arch-arm64-blue.svg)](https://github.com/RealUndisputed/GobboNet-MacOS-Port)
[![Frontend](https://img.shields.io/badge/UI-Swift%20%2B%20WKWebView-orange?logo=swift)](https://developer.apple.com/swift/)
[![Backend](https://img.shields.io/badge/Backend-Go%20%2B%20Metal-00ADD8?logo=go)](https://go.dev/)

An unofficial, fully native macOS port of **GobboNet**. 

GobboNet was originally designed with Windows `.bat` and PowerShell scripts. This port re-engineers the runtime from the ground up for **macOS on Apple Silicon (M1/M2/M3/M4/M5)**, packaging everything into an isolated, standalone desktop app (`GobboNet.app`) with zero emulation overhead.

---

## 🙏 Credits & Original Creators

> **All original concept design, web interface, and foundational architecture belong to the creators of GobboNet.**
> 
> * **Original Concept & Showcase:** Check out the official [GobboNet YouTube Overview](https://www.youtube.com/watch?v=wxMB1OvJX2I).
> * Huge thanks to the original developers for creating such a lean, customizable, and local-first AI chat environment. This project is a community-driven tribute to make GobboNet accessible to Mac users natively.
> * Don't forget to also check out their [Original Repo](https://github.com/ElodineOfficial/gobbonet)
---

## ✨ Key Enhancements in this Port

* 🖥️ **Native Desktop Window (`GobboNet.app`):** Built with a custom Swift + `WKWebView` wrapper. Launches as a real macOS app with its own Dock icon—no browser clutter or address bar.
* 🚀 **100% Native ARM64 Go Backend:** Re-compiled for `darwin-arm64` to fully harness Apple Silicon Unified Memory and bandwidth.
* 🛑 **Zero Windows / PowerShell Overhead:** Completely eliminated all `.bat` and `.ps1` dependencies, replacing them with POSIX-compliant bash scripts (`build.sh`, `run.sh`, `stage-web.sh`).
* 🧹 **Clean Lifecycle & Memory Management:** Closing the app window or quitting via `Cmd + Q` cleanly terminates the underlying Go server and proxy processes. No background zombies consuming RAM.
* 📦 **Self-Contained Bundle:** Can be moved directly into `/Applications` and launched without keeping a terminal window open.

---

## 📋 Prerequisites

Make sure you have the standard Mac developer utilities installed:

1. **Xcode Command Line Tools:**
   ```bash
   xcode-select --install


2. Homebrew:
   /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
   
3. Inference Backend (llama.cpp with native Metal support):
   brew install llama.cpp
   

🚀 Building & Installation

1. Clone the repository

git clone [https://github.com/RealUndisputed/GobboNet-MacOS-Port.git](https://github.com/RealUndisputed/GobboNet-MacOS-Port.git)
cd GobboNet-MacOS-Port/gobbonet


2. Compile the native app bundle

Run the automated build script:

chmod +x macos/build-app.sh macos/build.sh macos/run.sh
./macos/build-app.sh


This stages the web assets, compiles the Go backend for darwin-arm64, builds the Swift window manager, and produces build/GobboNet.app.

3. Install to Applications

cp -R build/GobboNet.app /Applications/


First Launch Tip:
Since the app is compiled and ad-hoc signed locally, Right-Click (or Ctrl + Click) on GobboNet.app in your Applications folder on first launch and select Open \rightarrow Open. After that, it opens normally with a simple double-click or via Spotlight (Cmd + Space).

🧠 Setting Up Local AI Models (.gguf)

GobboNet searches for .gguf models in your user share directory:

mkdir -p ~/.local/share/gobbonet/models
open ~/.local/share/gobbonet/models


Simply drag-and-drop your downloaded .gguf model files into this folder.

## Recommended Models for Apple Silicon Unified Memory

System RAM	Recommended Model	Quantization	Performance Profile
8 GB - 16 GB	Llama-3.1-8B-Instruct or Qwen2.5-7B	Q5_K_M / Q6_K	Extremely fast (~40+ tok/s), battery friendly
24 GB	Qwen2.5-14B-Instruct (Sweet Spot)	Q4_K_M	High intelligence & coding power, buttery smooth
32 GB+	Qwen2.5-32B-Instruct or Command-R	Q4_K_M	Deep reasoning, max capability



⚖️ License

Distributed under the original project's terms. All rights to the original software belong to the upstream GobboNet authors.


Made with Love from Berlin <3
