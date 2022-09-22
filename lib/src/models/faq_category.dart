import '../models/faq.dart';

class FaqCategory {
  String id;
  String name;
  List<Faq>? faqs;
  FaqCategory({
    required this.id,
    required this.name,
    required this.faqs,
  });

 factory FaqCategory.fromJSON(Map<String, dynamic> jsonMap) {
    return FaqCategory(
        id: jsonMap['id'].toString(),
        name: jsonMap['name'] != null ? jsonMap['name'].toString() : '',
        faqs: jsonMap['faqs'] != null
            ? List.from(jsonMap['faqs'])
                .map((element) => Faq.fromJSON(element))
                .toList()
            : null);
  }
}
