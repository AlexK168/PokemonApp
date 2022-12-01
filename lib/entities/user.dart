class User {
  final String? email;
  final String id;

  const User({
    required this.id,
    this.email,
  });
  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;
}
