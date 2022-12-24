class Joke {
  final String value;

  Joke({required this.value});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      value: json['value'],
    );
  }
}
