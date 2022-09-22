class Faq {
  String id;
  String question;
  String answer;
  Faq({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Faq.fromJSON(Map<String, dynamic> jsonMap) {
    return Faq(
        id: jsonMap['id'].toString(),
        question: jsonMap['question'] != null ? jsonMap['question'] : '',
        answer: jsonMap['answer'] != null ? jsonMap['answer'] : '');
  }
}
