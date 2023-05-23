class DisplayUsers {
  final String? name;
  final String? title;
  final String? college;
  final String? id;

  DisplayUsers({required this.name, required this.title, required this.college, required this.id});

  factory DisplayUsers.fromJson(Map<String, dynamic> json) =>
  DisplayUsers(name: json['name'] as String? ?? '',
  title: json['title'] as String? ?? '',
  college: json['college'] as String? ?? '',
  id: json['id'] as String? ?? '');
  }