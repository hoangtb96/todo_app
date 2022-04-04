# todo_app

A Todo list app.

## Run Project

flutter run

## if gettting error because of lacking of package (For the first time running app)
flutter pub get

## Run test 

flutter test --coverage 

## Generate file html for displaying coverage info if needed 

genhtml coverage/lcov.info --output=coverage

## Run integration test 

flutter test integration_test

## Build file apk

flutter build apk 

## Build ios for release

flutter build ios