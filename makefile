format:
	dart format .


freezed:
	flutter clean
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs

buildRunner:
	flutter pub run build_runner build --delete-conflicting-outputs

buildProd:
	flutter clean
	flutter build apk --target-platform android-arm64 -t lib/main.dart

buildDev:
	flutter clean
	flutter build apk --target-platform android-arm64 --release  -t lib/main.dart

buildBeta:
	flutter clean
	flutter build apk --target-platform android-arm64 --release  -t lib/main.dart
 

buildBundle:
	flutter clean
	flutter build appbundle --target lib/main.dart

pubGet:
	del pubspec.lock
	flutter clean
	flutter pub get

