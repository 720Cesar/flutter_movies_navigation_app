class MovieMovideDB {
    final bool adult;
    final String backdropPath;
    final List<int> genreIds;
    final int id;
    final String originalLanguage;
    final String originalTitle;
    final String overview;
    final double popularity;
    final String posterPath;
    final DateTime? releaseDate; //Se agrega "?" porque el dato puede venir nulo
    final String title;
    final bool video;
    final double voteAverage;
    final int voteCount;

    MovieMovideDB({
        required this.adult,
        required this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        required this.posterPath,
        required this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    factory MovieMovideDB.fromJson(Map<String, dynamic> json) => MovieMovideDB(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] ?? "",
        genreIds: json["genre_ids"] != null
          ? List<int>.from(json["genre_ids"].map((x) => x))
          : <int>[],
        id: json["id"],
        originalLanguage: json["original_language"], //Se cambia a String para obtener solo el valor
        originalTitle: json["original_title"],
        overview: json["overview"] ?? "",
        popularity: json["popularity"]?.toDouble() ?? 0.0,
        posterPath: json["poster_path"] ?? "",
        releaseDate: json["release_date"]  != null && json["release_date"].toString().isNotEmpty //Si hay datos, los envía. Si no hay datos manda nulo
          ? DateTime.parse(json["release_date"])
          : null,
        title: json["title"],
        video: json["video"] ?? false,
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": (releaseDate != null) 
          ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
          : null,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

enum OriginalLanguage {
    EN,
    ES,
    FR,
    PL
}

final originalLanguageValues = EnumValues({
    "en": OriginalLanguage.EN,
    "es": OriginalLanguage.ES,
    "fr": OriginalLanguage.FR,
    "pl": OriginalLanguage.PL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
