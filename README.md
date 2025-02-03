# devicevalidator

A Flutter project for POC purpose.

## Getting Started

1. Install required sdk (Android SDK, Flutter SDK)
2. Clone the repository
3. run `flutter pub get`
4. connect a device
5. run `flutter run`

## POC parameters

### App debugging

1. Install the app with `flutter run`
2. Launch the app and check the app debugging status

![](https://raw.githubusercontent.com/SRW2009/fazpass_validator_flutter_pub/main/.github/assets/POC_app_debugging.mp4)

#### Expected

App debugging status is true

### App cloning

1. Download cloning app in playstore (dualclone, etc.)
2. Clone the app
3. Launch the cloned app and check the app cloning status

#### Expected

App cloning status is true

### Screen sharing

1. Open google meet, start a meeting room (by yourself), then share your screen
2. Allow google meet to record your screen
3. Launch the app and check the screen sharing status

#### Expected

Screen sharing status is true

### VPN Usage

1. Download vpn app in playstore (hotspot shield, etc.)
2. Open the vpn app and start the vpn service
3. Allow your vpn app to register vpn profile
4. After vpn is running, launch the app and check the vpn status

#### Expected

VPN usage status is true
