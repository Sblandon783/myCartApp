class ProfileModel {
  String name;
  String image;
  int countPosts;

  ProfileModel({
    required this.name,
    required this.image,
    required this.countPosts,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json["username"] ?? '',
        image: json["user_image"] ?? '',
        countPosts: json["count_posts"] ?? 0,
      );
}
