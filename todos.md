- Place a set of dice on the interface. When a die is clicked, its value will change, providing a quick dice rolling solution.
- Check if there are any logical issues with the new UI for the dice bag.
- Consider how proficiency bonus is calculated in the case of multiclassing.
- A better way to modify temporary hit points.


flutter pub run build_runner build

flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk


Generate icon: flutter pub run flutter_launcher_icons:main

Change name and icon:
https://juejin.cn/post/7220688635142455356

Dice icon:
https://pixabay.com/zh/vectors/d20-dice-game-nat20-dnd-d-d-7136921/


open ios/Runner.xcworkspace
flutter build ios --release