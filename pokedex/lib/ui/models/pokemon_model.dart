class PokemonModel {
  final int id;
  final String name;
  final String image;
  final double height;
  final double weight;
  final String cryUrl;
  final List<String> types;
  final Map<String, int> stats;

  PokemonModel({
    required this.id,
    required this.name,
    required this.image,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats, required this.cryUrl,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    var typesList = (json['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    Map<String, int> statsMap = {};

    for (var s in json['stats']) {
      statsMap[s['stat']['name']] = s['base_stat'] as int;
    }

    return PokemonModel(
      id: json['id'],
      name: json['name'],
      image:
          json['sprites']['other']['official-artwork']['front_default'] ?? "",
      height: (json['height'] as int) / 10.0,
      weight: (json['weight'] as int) / 10.0,
      types: typesList,
      stats: statsMap,
      cryUrl: json['cries']['latest'] ?? "",
    );
  }
}
