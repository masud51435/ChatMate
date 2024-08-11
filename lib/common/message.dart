class Message {
  Message({
    required this.text,
    required this.isUser,
    this.isLoading = false
  });
  final String text;
  final bool isUser;
  final bool isLoading;
}
