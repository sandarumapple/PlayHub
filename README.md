# PlayHub

PlayHub is a simple iOS app made using Swift and SwiftUI. Users can choose a player profile, play three mini-games, and check their scores and game history.

## Architecture Overview

The app uses the MVVM structure to organise the code.

- Models: Store details about players, games, and scores.
- Views: Show the screens and buttons.
- ViewModels: Handle game rules, timers, scores, and screen data.
- Services: Handle saving data, loading quiz questions, location, and notifications.
- App: Starts the app and manages the main navigation.

Player details and game history are saved on the device using UserDefaults.

## Features

- Three mini-games: Tap Frenzy, Light It Up, and Quiz Rush.
- Easy, Medium, and Hard difficulty levels.
- Create and select player profiles.
- View scores, statistics, and game history.
- View player location on a map.
- Set daily game reminders.
- Clear saved history and player data.

## Known Limitations

- Quiz Rush needs an internet connection.
- Data is saved only on the current device.
- There is no online multiplayer or cloud backup.
- Location and reminders need user permission.


## Reflection

This project helped me learn how to build an app using SwiftUI and organise code using MVVM. I also learned how to save data, get questions from an API, and use maps and notifications.

Managing timers, updating scores, and keeping player data consistent were challenging parts of the project.

In the future, I would like to improve score tracking, add offline quiz questions, and test the app more.
