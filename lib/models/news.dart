class News{
  String itemID;
  String id;
  String title;
  String link;
  String date;
  String content;
  String image;
  String thumbnail;

  News({
    this.itemID,
    this.id,
    this.title,
    this.link,
    this.date,
    this.content,
    this.image,
    this.thumbnail,
  });

  factory News.fromjson(Map<String, dynamic> json) => new News(
    itemID: json['itemID'],
    id: json['id'],
    title: json['title'],
    link: json ['link'],
    date: json['date'],
    content: json['content'],
    image: json['image'],
    thumbnail: json['thumbnail'],
  );
  Map<String, dynamic> toJson() => {

  };
}
