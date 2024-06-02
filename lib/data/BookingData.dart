// ignore_for_file: non_constant_identifier_names

import 'package:ridobiko/data/VehicleDocumentData.dart';

class BookingData {
  String? bookedon;
  String? pickupDate;
  String? dropDate;
  String? transId;
  String? vendorEmailId;
  String? invoice;
  String? customerEmailId;
  String? customerName;
  String? customerMobile;
  String? bikesId;
  String? bikeName;
  String? bikeImage;
  String? rent;
  String? paymentMode;
  String? amountPaid;
  String? amountLeft;
  String? ridoPointsUsed;
  String? discount;
  String? gst;
  String? helmet_charge;
  String? couponCode;
  String? booking;
  String? paidOn;
  String? adminStatus;
  String? securityDeposit;
  String? wallet_amount;
  String? latePayCharge;
  TripDetails? tripDetails;
  VendorDetails? vendorDetails;
  List<Subscription>? subscription;
  dynamic invoices;
  TripPictures? tripPictures;
  VehicleDocumentData? vehicleDocument;

  BookingData({
    this.bookedon,
    this.pickupDate,
    this.dropDate,
    this.transId,
    this.vendorEmailId,
    this.customerEmailId,
    this.customerName,
    this.customerMobile,
    this.bikesId,
    this.bikeName,
    this.bikeImage,
    this.rent,
    this.invoice,
    this.paymentMode,
    this.amountPaid,
    this.amountLeft,
    this.ridoPointsUsed,
    this.discount,
    this.couponCode,
    this.booking,
    this.paidOn,
    this.adminStatus,
    this.securityDeposit,
    this.wallet_amount,
    this.tripDetails,
    this.vendorDetails,
    this.subscription,
    this.tripPictures,
    this.vehicleDocument,
    this.invoices,
    this.latePayCharge,
    this.helmet_charge,
  });

  BookingData.fromJson(Map<String, dynamic> json) {
    bookedon = json['bookedon'];
    pickupDate = json['pickup_date'];
    dropDate = json['drop_date'];
    invoice = json['invoice_no'].toString();
    transId = json['trans_id'];
    vendorEmailId = json['vendor_email_id'];
    customerEmailId = json['customer_email_id'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
    bikesId = json['bikes_id'];
    bikeName = json['bike_name'];
    bikeImage = json['bike_image'];
    rent = json['rent'];
    gst = json['gst'] ?? '--';
    helmet_charge = json['helmet_charge'] ?? '--';
    latePayCharge = json['late_pay_charge'] ?? '';
    paymentMode = json['payment_mode'];
    amountPaid = json['amount_paid'];
    amountLeft = json['amount_left'];
    ridoPointsUsed = json['rido_points_used'];
    discount = json['discount'];
    couponCode = json['coupon_code'];
    booking = json['booking'];
    paidOn = json['paid_on'];
    adminStatus = json['admin_status'];
    securityDeposit = json['security_deposit'];
    wallet_amount = json['wallet_amount'].toString();
    tripDetails = TripDetails.fromJson(json['trip_details']);
    tripPictures = TripPictures.fromJson(json['trip_pictures']);
    if (json['subscription'].runtimeType == List) {
      subscription = <Subscription>[];
      json['subscription'].forEach((v) {
        subscription!.add(Subscription.fromJson(v));
      });
    }
    vendorDetails = VendorDetails.fromJson(json['vendor_details']);
    vehicleDocument = VehicleDocumentData.fromMap(json['vehicle_document']);
    invoices = json['invoices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookedon'] = bookedon;
    data['pickup_date'] = pickupDate;
    data['drop_date'] = dropDate;
    data['trans_id'] = transId;
    data['vendor_email_id'] = vendorEmailId;
    data['customer_email_id'] = customerEmailId;
    data['customer_name'] = customerName;
    data['customer_mobile'] = customerMobile;
    data['bikes_id'] = bikesId;
    data['bike_name'] = bikeName;
    data['invoice'] = invoice;
    data['bike_image'] = bikeImage;
    data['rent'] = rent;
    data['payment_mode'] = paymentMode;
    data['amount_paid'] = amountPaid;
    data['amount_left'] = amountLeft;
    data['rido_points_used'] = ridoPointsUsed;
    data['discount'] = discount;
    data['coupon_code'] = couponCode;
    data['booking'] = booking;
    data['paid_on'] = paidOn;
    data['admin_status'] = adminStatus;
    data['security_deposit'] = securityDeposit;
    data['wallet_amount'] = wallet_amount;
    data['invoices'] = invoices;
    data['late_pay_charge'] = latePayCharge;
    if (tripDetails != null) {
      data['trip_details'] = tripDetails!.toJson();
    }
    if (tripPictures != null) {
      data['trip_pictures'] = tripPictures!.toJson();
    }
    if (subscription != null) {
      data['subscription'] = subscription!.map((v) => v.toJson()).toList();
    }
    if (vendorDetails != null) {
      data['vendor_details'] = vendorDetails!.toJson();
    }
    if (vehicleDocument != null) {
      data['vehicle_document'] = vehicleDocument!.toJson();
    }
    return data;
  }
}

class VendorDetails {
  String? name;
  String? mobile;
  String? mapAddress;
  String? formArea;
  String? formCity;
  String? formLandmark;
  String? formState;
  String? formPincode;
  String? opening;
  String? closing;

  VendorDetails({
    this.name,
    this.mobile,
    this.mapAddress,
    this.formArea,
    this.formCity,
    this.formLandmark,
    this.formState,
    this.formPincode,
    this.opening,
    this.closing,
  });

  VendorDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    mapAddress = json['map_address'];
    formArea = json['form_area'];
    formCity = json['form_city'];
    formLandmark = json['form_landmark'];
    formState = json['form_state'];
    formPincode = json['form_pincode'];
    opening = json['opening_time'];
    closing = json['closing_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile'] = mobile;
    data['map_address'] = mapAddress;
    data['form_area'] = formArea;
    data['form_city'] = formCity;
    data['form_landmark'] = formLandmark;
    data['form_state'] = formState;
    data['form_pincode'] = formPincode;
    data['opening_time'] = opening;
    data['closing_time'] = closing;
    return data;
  }
}

class TripDetails {
  String? orderId;
  String? pickupDate;
  String? dropDate;
  String? bookingStatus;
  String? rentCollectedByVendor;
  String? rentPaymentMode;
  String? depositCollectedByVendor;
  String? depositPaymentMode;
  String? noOfHelmets;
  String? noOfHelmetsDrop;
  String? kMMeterPickup;
  String? fuelPickup;
  String? destination;
  String? purpose;
  String? idCollected;
  String? comment;
  String? kMMeterDrop;
  String? fuelDrop;
  String? petrolCharge;
  String? extraKmCharge;
  String? otherCharge;
  String? otherChargeReason;
  String? fuelChargeApply;
  String? kmChargeApply;
  String? maintenanceChargeApply;
  String? chargesConfirmed;

  TripDetails(
      {this.orderId,
      this.pickupDate,
      this.dropDate,
      this.bookingStatus,
      this.rentCollectedByVendor,
      this.rentPaymentMode,
      this.depositCollectedByVendor,
      this.depositPaymentMode,
      this.noOfHelmets,
      this.noOfHelmetsDrop,
      this.kMMeterPickup,
      this.fuelPickup,
      this.destination,
      this.purpose,
      this.idCollected,
      this.comment,
      this.kMMeterDrop,
      this.fuelDrop,
      this.petrolCharge,
      this.extraKmCharge,
      this.otherCharge,
      this.otherChargeReason,
      this.fuelChargeApply,
      this.kmChargeApply,
      this.maintenanceChargeApply,
      this.chargesConfirmed});

  TripDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'] ?? "";
    pickupDate = json['pickup_date'] ?? "";
    dropDate = json['drop_date'] ?? "";
    bookingStatus = json['booking_status'] ?? "";
    rentCollectedByVendor = json['rent_collected_by_vendor'] ?? "";
    rentPaymentMode = json['rent_payment_mode'] ?? "";
    depositCollectedByVendor = json['deposit_collected_by_vendor'] ?? "";
    depositPaymentMode = json['deposit_payment_mode'] ?? "";
    noOfHelmets = json['no_of_helmets'] ?? "";
    noOfHelmetsDrop = json['no_of_helmets_drop'] ?? "";
    kMMeterPickup = json['KM_meter_pickup'] ?? "";
    fuelPickup = json['fuel_pickup'] ?? "";
    destination = json['destination'] ?? "";
    purpose = json['purpose'] ?? "";
    idCollected = json['id_collected'] ?? "";
    comment = json['comment'] ?? "";
    kMMeterDrop = json['KM_meter_drop'] ?? "";
    fuelDrop = json['fuel_drop'] ?? "";
    petrolCharge = json['petrol_charge'] ?? "";
    extraKmCharge = json['extra_km_charge'] ?? "";
    otherCharge = json['other_charge'] ?? "";
    otherChargeReason = json['other_charge_reason'] ?? "";
    fuelChargeApply = json['fuel_charge_apply'] ?? "";
    kmChargeApply = json['km_charge_apply'] ?? "";
    maintenanceChargeApply = json['maintenance_charge_apply'] ?? "";
    chargesConfirmed = json['charges_confirmed'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['pickup_date'] = pickupDate;
    data['drop_date'] = dropDate;
    data['booking_status'] = bookingStatus;
    data['rent_collected_by_vendor'] = rentCollectedByVendor;
    data['rent_payment_mode'] = rentPaymentMode;
    data['deposit_collected_by_vendor'] = depositCollectedByVendor;
    data['deposit_payment_mode'] = depositPaymentMode;
    data['no_of_helmets'] = noOfHelmets;
    data['no_of_helmets_drop'] = noOfHelmetsDrop;
    data['KM_meter_pickup'] = kMMeterPickup;
    data['fuel_pickup'] = fuelPickup;
    data['destination'] = destination;
    data['purpose'] = purpose;
    data['id_collected'] = idCollected;
    data['comment'] = comment;
    data['KM_meter_drop'] = kMMeterDrop;
    data['fuel_drop'] = fuelDrop;
    data['petrol_charge'] = petrolCharge;
    data['extra_km_charge'] = extraKmCharge;
    data['other_charge'] = otherCharge;
    data['other_charge_reason'] = otherChargeReason;
    data['fuel_charge_apply'] = fuelChargeApply;
    data['km_charge_apply'] = kmChargeApply;
    data['maintenance_charge_apply'] = maintenanceChargeApply;
    data['charges_confirmed'] = chargesConfirmed;
    return data;
  }
}

class TripPictures {
  String? orderId;
  String? bikeLeft;
  String? bikeRight;
  String? bikeFront;
  String? bikeBack;
  String? bikeWithCustomer;
  String? bikeFuelMeter;
  String? helmetFront1;
  String? helmetBack1;
  String? helmetFront2;
  String? helmetBack2;
  String? bikeLeftDrop;
  String? bikeRightDrop;
  String? bikeFrontDrop;
  String? bikeBackDrop;
  String? bikeFuelMeterDrop;
  String? exchangedBikeId;
  String? exchangedBikeName;
  String? exchangedBikeImage;
  String? exchangedBikeFront;
  String? exchangedBikeBack;
  String? exchangedBikeWithCustomer;
  String? exchangedBikeFuel;
  String? exchangedBikeRight;
  String? exchangedBikeLeft;
  String? isExchanged;
  String? exchangedDate;

  TripPictures(
      {this.orderId,
      this.bikeLeft,
      this.bikeRight,
      this.bikeFront,
      this.bikeBack,
      this.bikeWithCustomer,
      this.bikeFuelMeter,
      this.helmetFront1,
      this.helmetBack1,
      this.helmetFront2,
      this.helmetBack2,
      this.bikeLeftDrop,
      this.bikeRightDrop,
      this.bikeFrontDrop,
      this.bikeBackDrop,
      this.bikeFuelMeterDrop,
      this.exchangedBikeId,
      this.exchangedBikeName,
      this.exchangedBikeImage,
      this.exchangedBikeFront,
      this.exchangedBikeBack,
      this.exchangedBikeWithCustomer,
      this.exchangedBikeFuel,
      this.exchangedBikeRight,
      this.exchangedBikeLeft,
      this.isExchanged,
      this.exchangedDate});

  TripPictures.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'] ?? "";
    bikeLeft = json['bike_left'] ?? "";
    bikeRight = json['bike_right'] ?? "";
    bikeFront = json['bike_front'] ?? "";
    bikeBack = json['bike_back'] ?? "";
    bikeWithCustomer = json['bike_with_customer'] ?? "";
    bikeFuelMeter = json['bike_fuel_meter'] ?? "";
    helmetFront1 = json['helmet_front_1'] ?? "";
    helmetBack1 = json['helmet_back_1'] ?? "";
    helmetFront2 = json['helmet_front_2'] ?? "";
    helmetBack2 = json['helmet_back_2'] ?? "";
    bikeLeftDrop = json['bike_left_drop'] ?? "";
    bikeRightDrop = json['bike_right_drop'] ?? "";
    bikeFrontDrop = json['bike_front_drop'] ?? "";
    bikeBackDrop = json['bike_back_drop'] ?? "";
    bikeFuelMeterDrop = json['bike_fuel_meter_drop'] ?? "";
    exchangedBikeId = json['exchanged_bike_id'] ?? "";
    exchangedBikeName = json['exchanged_bike_name'] ?? "";
    exchangedBikeImage = json['exchanged_bike_image'] ?? "";
    exchangedBikeFront = json['exchanged_bike_front'] ?? "";
    exchangedBikeBack = json['exchanged_bike_back'] ?? "";
    exchangedBikeWithCustomer = json['exchanged_bike_with_customer'] ?? "";
    exchangedBikeFuel = json['exchanged_bike_fuel'] ?? "";
    exchangedBikeRight = json['exchanged_bike_right'] ?? "";
    exchangedBikeLeft = json['exchanged_bike_left'] ?? "";
    isExchanged = json['is_exchanged'] ?? "";
    exchangedDate = json['exchanged_date'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['bike_left'] = bikeLeft;
    data['bike_right'] = bikeRight;
    data['bike_front'] = bikeFront;
    data['bike_back'] = bikeBack;
    data['bike_with_customer'] = bikeWithCustomer;
    data['bike_fuel_meter'] = bikeFuelMeter;
    data['helmet_front_1'] = helmetFront1;
    data['helmet_back_1'] = helmetBack1;
    data['helmet_front_2'] = helmetFront2;
    data['helmet_back_2'] = helmetBack2;
    data['bike_left_drop'] = bikeLeftDrop;
    data['bike_right_drop'] = bikeRightDrop;
    data['bike_front_drop'] = bikeFrontDrop;
    data['bike_back_drop'] = bikeBackDrop;
    data['bike_fuel_meter_drop'] = bikeFuelMeterDrop;
    data['exchanged_bike_id'] = exchangedBikeId;
    data['exchanged_bike_name'] = exchangedBikeName;
    data['exchanged_bike_image'] = exchangedBikeImage;
    data['exchanged_bike_front'] = exchangedBikeFront;
    data['exchanged_bike_back'] = exchangedBikeBack;
    data['exchanged_bike_with_customer'] = exchangedBikeWithCustomer;
    data['exchanged_bike_fuel'] = exchangedBikeFuel;
    data['exchanged_bike_right'] = exchangedBikeRight;
    data['exchanged_bike_left'] = exchangedBikeLeft;
    data['is_exchanged'] = isExchanged;
    data['exchanged_date'] = exchangedDate;
    return data;
  }
}

class Subscription {
  String? orderId;
  String? pickupDate;
  String? dropDate;
  String? rent;
  String? amountPaid;
  String? amountLeft;
  String? latePayCharge;
  String? helmetCharges;

  Subscription(
      {this.orderId,
      this.pickupDate,
      this.dropDate,
      this.rent,
      this.amountPaid,
      this.amountLeft,
      this.latePayCharge,
      this.helmetCharges});

  Subscription.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    pickupDate = json['pickup_date'];
    dropDate = json['drop_date'];
    rent = json['rent'];
    amountPaid = json['amount_paid'];
    amountLeft = json['amount_left'];
    latePayCharge = json['late_pay_charge'];
    helmetCharges = json['helmet_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['pickup_date'] = pickupDate;
    data['drop_date'] = dropDate;
    data['rent'] = rent;
    data['amount_paid'] = amountPaid;
    data['amount_left'] = amountLeft;
    data['late_pay_charge'] = latePayCharge;
    data['helmet_charge'] = helmetCharges;
    return data;
  }
}
