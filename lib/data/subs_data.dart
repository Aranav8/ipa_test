class SubsData {
  String? vendorEmailId;
  String? bikeId;
  String? bikeBrand;
  String? bikeName;
  String? bikeImage;
  String? rent1Month;
  String? rent2Month;
  String? rent3Month;
  String? rent6Month;
  String? rent12Month;
  String? status;
  String? pickup;
  String? drop;
  String? start;
  String? end;
  String? deposit;
  String? kmLimitMonth;
  String? speedLimit;
  String? locality;
  String? homeDelivery;
  String? helmetAdditional;
  String? helmetCharge;
  String? available;

  SubsData(
      {this.vendorEmailId,
        this.bikeId,
        this.bikeBrand,
        this.bikeName,
        this.bikeImage,
        this.rent1Month,
        this.rent2Month,
        this.rent3Month,
        this.rent6Month,
        this.rent12Month,
        this.status,
        this.pickup,
        this.drop,
        this.start,
        this.end,
        this.deposit,
        this.kmLimitMonth,
        this.speedLimit,
        this.locality,
        this.homeDelivery,
        this.helmetAdditional,
        this.helmetCharge,
        this.available});

  SubsData.fromJson(Map<String, dynamic> json) {
    vendorEmailId = json['vendor_email_id'];
    bikeId = json['bike_id'];
    bikeBrand = json['bike_brand'];
    bikeName = json['bike_name'];
    bikeImage = json['bike_image'];
    rent1Month = json['rent_1_month']==''?'0':json['rent_1_month'];
    rent2Month = json['rent_2_month']==''?'0':json['rent_2_month'];
    rent3Month = json['rent_3_month']==''?'0':json['rent_3_month'];
    rent6Month = json['rent_6_month']==''?'0':json['rent_6_month'];
    rent12Month = json['rent_12_month']==''?'0':json['rent_12_month'];
    status = json['status'];
    pickup = json['pickup'];
    drop = json['drop'];
    start = json['start'];
    end = json['end'];
    deposit = json['deposit'];
    kmLimitMonth = json['km_limit_month']??"NA";
    speedLimit = json['speed_limit'];
    locality = json['locality'];
    homeDelivery = json['home_delivery'];
    helmetAdditional = json['helmet_additional'];
    helmetCharge = json['helmet_charge'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_email_id'] = this.vendorEmailId;
    data['bike_id'] = this.bikeId;
    data['bike_brand'] = this.bikeBrand;
    data['bike_name'] = this.bikeName;
    data['bike_image'] = this.bikeImage;
    data['rent_1_month'] = this.rent1Month;
    data['rent_2_month'] = this.rent2Month;
    data['rent_3_month'] = this.rent3Month;
    data['rent_6_month'] = this.rent6Month;
    data['rent_12_month'] = this.rent12Month;
    data['status'] = this.status;
    data['pickup'] = this.pickup;
    data['drop'] = this.drop;
    data['start'] = this.start;
    data['end'] = this.end;
    data['deposit'] = this.deposit;
    data['km_limit_month'] = this.kmLimitMonth;
    data['speed_limit'] = this.speedLimit;
    data['locality'] = this.locality;
    data['home_delivery'] = this.homeDelivery;
    data['helmet_additional'] = this.helmetAdditional;
    data['helmet_charge'] = this.helmetCharge;
    data['available'] = this.available;
    return data;
  }
}
