class CityData{
  String? city_name,open_time,close_time,city_image;
  CityData.fromJson(Map<String, dynamic> json){
    city_name=json['city_name'];
    open_time=json['open_time'];
    close_time=json['close_time'];
    city_image=json['city_image'];
  }
}