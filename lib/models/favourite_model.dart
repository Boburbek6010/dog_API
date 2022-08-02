import 'dart:convert';

List<FavouriteModel> parseListFav(String str) {
  List list = jsonDecode(str);
  List<FavouriteModel> favs = (list.map((item) => FavouriteModel.fromJson(item))).toList();

  // for (var item in list) {
  //   favs.add(FavouriteModel.fromJson(item));
  // }
  return favs;
}


FavouriteModel favouriteModelFromJson(String str) => FavouriteModel.fromJson(json.decode(str));
String favouriteModelToJson(FavouriteModel data) => json.encode(data.toJson());
class FavouriteModel {
  FavouriteModel({
      this.id,
      this.userId,
      this.imageId,
      this.subId,
      this.createdAt,
      this.image,});

  FavouriteModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    imageId = json['image_id'];
    subId = json['sub_id'];
    createdAt = json['created_at'];
    image = json['image'];
  }
  int? id;
  String? userId;
  String? imageId;
  String? subId;
  String? createdAt;
  dynamic image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['image_id'] = imageId;
    map['sub_id'] = subId;
    map['created_at'] = createdAt;
    map['image'] = image;
    return map;
  }

}