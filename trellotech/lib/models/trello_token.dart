class TrelloToken {
  late String token;

  TrelloToken({
    required this.token,
  });

  factory TrelloToken.fromJson(Map<String, dynamic> json) {
    return TrelloToken(
      token: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
