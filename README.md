# SakhiPath - Women's Safety & Empowerment Platform

Smart safety navigation with AI-powered safe routes, legal awareness, self-defense training, and emergency SOS - all in one platform.

## 🎯 Problem Statement

Women need safe routes, not just fast ones. With 88% feeling unsafe during travel, 73% unaware of their legal rights, and limited access to self-defense training, no integrated platform exists to address safety, knowledge, and empowerment together.

## ✨ Key Features

- **🗺️ Smart Safe Navigation**: AI-powered routes based on lighting, crowd density, and safety data
- **🆘 Emergency SOS**: One-tap alerts to trusted contacts with live location tracking
- **📚 Legal Awareness Hub**: AI chatbot providing instant access to women's rights and laws
- **🎓 Self-Defense Training**: Free video tutorials accessible anytime
- **🌍 13 Languages**: Reaching 300M+ Indian women in their native language
- **🔐 Google Integration**: Firebase Auth, Cloud Messaging, Analytics, Maps API

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.16.0+
- Dart SDK 3.2.0+
- Android SDK (API 26+)

### Installation

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk --release
```

## 📱 Technology Stack

- **Frontend**: Flutter (Android, iOS, Web)
- **Backend**: Supabase (PostgreSQL, Auth, Real-time)
- **Maps**: Google Maps API with custom safety layers
- **Cloud**: Firebase (Auth, Messaging, Analytics)
- **AI/ML**: Safety scoring algorithms

  ```sh
  sudo dpkg -i <...>.deb
  ```

  ```sh
  sudo rpm -i <...>.rpm
  ```

  ```sh
  sudo pacman -U <...>.pkg.tar.zst
  ```
</details>

<details>
  <summary><b>Other Platforms</b></summary>

  You can also install the CLI via [go modules](https://go.dev/ref/mod#go-install) without the help of package managers.

  ```sh
  go install github.com/supabase/cli@latest
  ```

  Add a symlink to the binary in `$PATH` for easier access:

  ```sh
  ln -s "$(go env GOPATH)/bin/cli" /usr/bin/supabase
  ```

  This works on other non-standard Linux distros.
</details>

<details>
  <summary><b>Community Maintained Packages</b></summary>

  Available via [pkgx](https://pkgx.sh/). Package script [here](https://github.com/pkgxdev/pantry/blob/main/projects/supabase.com/cli/package.yml).
  To install in your working directory:

  ```bash
  pkgx install supabase
  ```

  Available via [Nixpkgs](https://nixos.org/). Package script [here](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/supabase-cli/default.nix).
</details>

### Run the CLI

```bash
supabase bootstrap
```

Or using npx:

```bash
npx supabase bootstrap
```

## 📖 Documentation

- [Language System Guide](LANGUAGE_SYSTEM.md) - 13 language support
- [Google Integration](GOOGLE_INTEGRATION.md) - Firebase & Google services
- [Presentation Guide](PRESENTATION_GUIDE.md) - Project overview & pitch deck
- [Setup Complete](SETUP_COMPLETE.md) - Configuration details

## 📄 License

See [LICENSE](LICENSE) file for details.

---

**SakhiPath** - Empowering women to navigate life safely and confidently.
