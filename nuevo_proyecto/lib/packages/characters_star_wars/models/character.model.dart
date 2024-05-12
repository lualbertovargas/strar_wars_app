class Character {
  final String name;
  final List<String> movies;
  final String gender;

  Character({
    required this.name,
    required this.movies,
    required this.gender,
  });
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      movies: (json['films'] as List)
          .map((url) {
            final parts = url.split('/');
            return parts[parts.length - 2];
          })
          .cast<String>()
          .toList(), // Convertir explícitamente a una lista de cadenas
      gender: json['gender'],
    );
  }
}
