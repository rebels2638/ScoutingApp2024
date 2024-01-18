# Usage

## Prerequisites
- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/en/)

## Installation
First we need to download the repository! Open `cmd`, and run this command!

```cmd
git clone https://github.com/rebels2638/ScoutingApp2023.git
cd ScoutingApp2023
```

Great! Now we need to install the dependencies our project relies on. Be warned, this will take a LONG time. It will also take lots of storage. As I'm writing this, `node_modules` takes ~300 MB, mostly from `expo-cli` and `react-native`.

```cmd
npm install
npm install -g expo-cli
```

Running the app

```cmd
npx expo start --tunnel
```

Great job! It should open a tab saying something about "(1) Scouting App on Expo Developer Tools", or "Metro Bundler".

Click on "Run in web browser", and wait for the app to pop up.
