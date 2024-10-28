class TrelloMembers {
  final String id;
  final String fullName;
  final String username;

  TrelloMembers({
    required this.id,
    required this.fullName,
    required this.username,
  });

  factory TrelloMembers.fromJson(Map<String, dynamic> json) {
    return TrelloMembers(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
    };
  }
}
