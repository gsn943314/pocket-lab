# Expo workflow on one Android phone

## Components

| Role | Tool |
|---|---|
| Terminal and filesystem | Termux |
| App framework | React Native with Expo |
| Development server | Metro through Expo CLI |
| Preview | Expo Go on the same phone |
| AI-assisted editing | Native Codex CLI in Termux |

## Start a project

```sh
pkg install -y nodejs git
npx create-expo-app@latest my-app
cd my-app
npx expo start --localhost
```

Open the resulting `exp://127.0.0.1:PORT` URL in Expo Go. Because Metro and Expo Go are on the same device, localhost works without a second computer or LAN address.

## Suggested loop

1. Open the project directory in Termux.
2. Start Metro and leave it running in one Termux session.
3. Open Expo Go and load the local `exp://` URL.
4. Run Codex from another Termux session in the project directory.
5. Describe or dictate a change, then inspect the Fast Refresh result in Expo Go.

## Expo Go limitations

Expo Go contains a fixed native runtime. JavaScript and supported Expo modules can update quickly, but new custom native modules, Android services, or special permissions require an Expo development build or another native build workflow.

This distinction matters for features such as drawing over other apps: the limitation is the prebuilt Expo Go container, not React Native itself.

