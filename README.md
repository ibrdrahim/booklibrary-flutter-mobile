# Book Library Flutter App

This Flutter application is a mobile book library management system. It allows users to add, edit, and delete books, as well as search and filter books by author, year, or genre. The app utilizes Firebase authentication for user authentication and Firebase Firestore for storing book data.

## Features

- User authentication using Firebase Auth (email/password)
- CRUD operations for managing books
- Search and filter books by author, year, or genre
- Lazy loading for efficient loading of large book lists
- Responsive design for different screen sizes

## Getting Started

To run this application locally, follow these steps:

1. Clone this repository:

```shell
git clone https://github.com/ibrdrahim/booklibrary-flutter-mobile.git
```

2. Navigate to the project directory:

```shell
cd booklibrary-flutter-mobile
```

3. Install dependencies:

```shell
flutter pub get
```

4. Set up Firebase:

   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Enable Firebase Authentication and Firestore.
   - Add your Firebase configuration to `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`.
   - Enable Email/Password authentication in Firebase Auth.

5. Run the app:

```shell
flutter run
```

## Contributing

Contributions are welcome! If you find any bugs or have suggestions for new features, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
