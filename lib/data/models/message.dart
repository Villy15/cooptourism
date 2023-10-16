class Message{
  final String senderId;
  final String receiverId;
  final String content;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
  });
}