class Film {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final int voteCount;
  final String date;
  final bool isMovie;

  const Film(
      {this.id = -1,
      this.title = '',
      this.description = '',
      this.thumbnail = '',
      this.voteCount = 0,
      this.date = '',
      this.isMovie = true});

  static List<Film> fromJson(Map<String, dynamic> json) {
    if (json['total_results'] > 0) {
      if (json['results'][0]['known_for'] != null) {
        return _buildList(json['results'][0]['known_for'],
            length: json['results'][0]['known_for'].length);
      }
      if (json['results'] != null) {
        return _buildList(json['results'], length: json['results'].length);
      }
    }
    throw Exception('Film.fromJson failed!');
  }

  static List<Film> _buildList(var data, {int length = 10}) {
    List<Film> result = List<Film>.generate(length, (i) {
      return _checkNoFieldNull(data[i])
          ? Film(
              id: data[i]['id'],
              title: data[i]['title'] ?? data[i]['name'],
              description: data[i]['overview'] ?? '',
              voteCount: data[i]['vote_count'] ?? 0,
              thumbnail:
                  'https://image.tmdb.org/t/p/w500' + data[i]['poster_path'],
              isMovie: (data[i]['media_type'] == 'movie'),
              date: data[i]['release_date'])
          : const Film();
    }, growable: true);
    result.removeWhere((element) => element.id == -1);
    return result;
  }

  static bool _checkNoFieldNull(var film) {
    return (film['id'] != null) &&
        (film['title'] != null || film['name'] != null) &&
        (film['poster_path'] != null) &&
        (film['release_date'] != null);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'vote_count': voteCount,
      'thumbnail': thumbnail,
      'date': date,
      'is_movie': isMovie ? 1 : 0
    };
  }

  @override
  String toString() {
    return 'Film{id: $id, title: $title, description: $description, vote_count: $voteCount, thumbnail: $thumbnail, is_movie: ${isMovie ? 1 : 0}, date: $date}';
  }
}
