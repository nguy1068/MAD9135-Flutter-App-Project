// Models.dart
// Data models (Movie, Session, User)

// Define Movie class
class Movie {
  // Properties: id, title, posterPath, overview
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  // Constructor with required parameters
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });
}

// Define Session class
class Session {
  // Properties: sessionId, code
  final String sessionId;
  final String code;

  // Constructor with required parameters
  Session({
    required this.sessionId,
    required this.code,
  });
}

// Define User class
class User {
  // Property: deviceId
  final String deviceId;

  // Constructor with required parameters
  User({
    required this.deviceId,
  });
}
