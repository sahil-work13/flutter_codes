class Usermodel {
  final int? userId ;
  final int? id;
  final String? title;
  final bool? completed;

  Usermodel(
      {
        this.userId,
        this.id,
        this.title,
        this.completed
      }
      );

  factory Usermodel.fromJson(Map<String,dynamic> json){
    return Usermodel(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        completed: json['completed']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
