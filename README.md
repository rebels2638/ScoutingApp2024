<div align="center">
<img src="repo/assets/logo.png" width=88 />
<br/>
<h1>Rebel Robotics Scouting App</h1>
    <img alt="img" src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" />
<h3><em>CRESCENDO</em> 2024</h3>
</div>

Scouting App for the 2024 year built using the **Flutter Framework**.

**You check can out an unstable web build [here](https://rebels2638.github.io/ScoutingApp2024/)!**

## Building

**Prerequisite**
* Make sure you have the Flutter SDK downloaded, you can find how to install it for your platform [here](https://docs.flutter.dev/get-started/install)
* If you want to test the App in a web browser, you must have either **Microsoft Edge**, **Google Chrome**, or **Apple Safari** installed
* If you want to test the App in a mobile environment, make sure you have set up either **Android Studio** or **XCode** for development on those platforms.

1. Clone this repository either through GitHub or using `git clone https://github.com/rebels2638/ScoutingApp2024.git`
2. `cd ScoutingApp2024`
3. `flutter pub get`
> [!WARNING]
> If Flutter prompts you with an upgrade notification, please run the respective upgrade command: `flutter upgrade`
4. Run `flutter build web --web-renderer html` to build for web.

If you would like to build for a different platform like iOS, please make sure you meet the prerequisites for that platform. For example, to test on iOS, you need XCode on an Apple device. For more information, check https://docs.flutter.dev/platform-integration

## Testing

First, follow the steps in [Building](#building), then just run `flutter run web --web-renderer html` to run in debug mode.

If you want to run in *Release Mode*, run `flutter run --release web --web-renderer html`.


## Our Team

**Lead Developer** 
    
* Jack Meng (exoad)

**Developers** 

* Chiming Wang (2bf)

**Helpers** 

* Aiden Pan
* Aarav Minocha

## Building Remarks

* [`/web/`](./web/) - Please reserve for development purposes only.
* [`/legals/`](/legals/) - Do not modify unless you know what you are doing. This directory preserves external licenses that cannot be tracked by pub.
* [`/repo/`](./repo/) - Strictly for the repository's display purposes, should NOT be linked to the base app in any way

## Resources

**Flutter & Dart**

1. [flutter.dev](https://flutter.dev)
2. [Flutter API Docs](https://api.flutter.dev/)
3. [Pub Package Repository](https://pub.dev/)
4. [dart.dev](https://dart.dev)

**FRC 2024 CRESCENDO**

1. [Game Arena Manual PDF](http://firstfrc.blob.core.windows.net/frc2024/Manual/Sections/2024GameManual-05ARENA.pdf)
2. [Game Overview PDF](http://firstfrc.blob.core.windows.net/frc2024/Manual/Sections/2024GameManual-04GameOverview.pdf)
3. [Library](https://www.firstinspires.org/resource-library/frc/competition-manual-qa-system)

**Tools**

1. [Image Background Remover](https://www.remove.bg/)
2. [Material 3 Theme Builder](https://m3.material.io/theme-builder)
