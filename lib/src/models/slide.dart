import '../models/market.dart';
import '../models/media.dart';
import 'product.dart';

class Slide {
  String id;
  int order;
  String text;
  String button;
  String textPosition;
  String textColor;
  String buttonColor;
  String backgroundColor;
  String indicatorColor;
  Media? image;
  String imageFit;
  Product product;
  Market market;
  bool enabled;
  Slide({
    required this.id,
    required this.order,
    required this.text,
    required this.button,
    required this.textPosition,
    required this.textColor,
    required this.buttonColor,
    required this.backgroundColor,
    required this.indicatorColor,
    required this.image,
    required this.imageFit,
    required this.product,
    required this.market,
    required this.enabled,
  });

  factory Slide.fromJSON(Map<String, dynamic> jsonMap) {
    return Slide(
        id: jsonMap['id'].toString(),
        order: jsonMap['order'] != null ? jsonMap['order'] : 0,
        text: jsonMap['text'] != null ? jsonMap['text'].toString() : '',
        button: jsonMap['button'] != null ? jsonMap['button'].toString() : '',
        textPosition: jsonMap['text_position'] != null
            ? jsonMap['text_position'].toString()
            : '',
        textColor: jsonMap['text_color'] != null
            ? jsonMap['text_color'].toString()
            : '',
        buttonColor: jsonMap['button_color'] != null
            ? jsonMap['button_color'].toString()
            : '',
        backgroundColor: jsonMap['background_color'] != null
            ? jsonMap['background_color'].toString()
            : '',
        indicatorColor: jsonMap['indicator_color'] != null
            ? jsonMap['indicator_color'].toString()
            : '',
        image: jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
            ? Media.fromJSON(jsonMap['media'][0])
            : null,
        imageFit: jsonMap['image_fit'] != null
            ? jsonMap['image_fit'].toString()
            : 'cover',
        product: jsonMap['product'] != null
            ? Product.fromJSON(jsonMap['product'])
            : Product.fromJSON({}),
        market: jsonMap['market'] != null
            ? Market.fromJSON(jsonMap['market'])
            : Market.fromJSON({}),
        enabled: jsonMap['enabled'] ?? false);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["text"] = text;
    map["order"] = order;
    map["button"] = button;
    map["text_position"] = textPosition;
    map["text_color"] = textColor;
    map["button_color"] = buttonColor;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
