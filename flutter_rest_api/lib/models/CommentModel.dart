class Commentmodel {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Commentmodel({
    this.userId,
    this.id,
    this.title,
    this.body
  }
  );

  factory Commentmodel.fromJson(Map<String,dynamic> json){
    return Commentmodel(
        userId : json['userId'],
        id : json['id'],
        title: json['title'],
        body : json['body']
    );
  }
}