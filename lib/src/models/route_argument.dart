class RouteArgument {
  String? id;
  String? heroTag;
  dynamic param;
  String? deliveryDate;
  dynamic param2;
  dynamic param3;
  RouteArgument(
      {this.id, this.heroTag, this.param, this.deliveryDate, this.param2,this.param3});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
