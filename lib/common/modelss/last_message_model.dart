class LastMessageModel {
  final String username;
  final String profileImageUrl;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  LastMessageModel({
    required this.username,
    required this.profileImageUrl,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'imageLink2': profileImageUrl,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    print(map);
    return LastMessageModel(
      username: map['username'] ?? '',
      profileImageUrl: map['imageLink2'] ?? '',
      contactId: map['contactId'] ??
          'https://cdn.create.vista.com/api/media/small/10866205/stock-photo-labrador-retriever-cream',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
