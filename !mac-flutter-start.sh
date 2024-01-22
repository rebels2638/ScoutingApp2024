#!/bin/bash

echo "Script started..."

echo "Downloading dependencies.."
flutter pub get

echo "Updating outdated dependencies..."
flutter pub outdated

echo "Finished."
