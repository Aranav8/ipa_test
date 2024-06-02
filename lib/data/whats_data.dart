class WhatsData {
  String? title;
  String? content;
  String? imageUrl;
  String? adUrl;

  WhatsData({this.title, this.content, this.imageUrl, this.adUrl});

  WhatsData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    imageUrl = json['image_url'];
    adUrl = json['ad_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['content'] = content;
    data['image_url'] = imageUrl;
    data['ad_url'] = adUrl;
    return data;
  }
}

class WhatsDataCache {
  static WhatsData? _cachedData;

  static void cacheData(WhatsData newData) {
    _cachedData = newData;
  }

  static WhatsData? getCachedData() {
    return _cachedData;
  }
}
