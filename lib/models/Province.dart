import 'dart:convert';

class Province{
  String id;
  String name;

  Province(
    {
      this.id,
      this.name
    }
  );

  factory Province.fromjson(Map<String, dynamic> json) => new Province(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name
  };
}