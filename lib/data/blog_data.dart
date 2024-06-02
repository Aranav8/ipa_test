class Blog {
  String? title;
  String? link;
  String? category;
  String? postDate;
  String? postImg;

  Blog({this.title, this.link, this.category, this.postDate, this.postImg});

  Blog.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'];
    category = json['category'];
    postDate = json['post_date'];
    postImg = json['post_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['link'] = this.link;
    data['category'] = this.category;
    data['post_date'] = this.postDate;
    data['post_img'] = this.postImg;
    return data;
  }
}
