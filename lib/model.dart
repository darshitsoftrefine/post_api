class Post{
  final String name;
  final String title;
  final String college;
  final int? id;

  Post({required this.name, required this.title, required this.college, required this.id});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        name: json['name'] as String,
        title: json['title'] as String,
        college: json['college'] as String,
        id: json['id']);
  }
}