import './promotion.dart';

class Gift {
  int? points;
  List<Promotion?>? promo;
  Gift({
    this.points,
    this.promo,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    print(json);
    return Gift(
        points: json['points'] as int,
        promo: (json['promo'] as List)
            .map((e) => e == null
                ? null
                : Promotion.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
