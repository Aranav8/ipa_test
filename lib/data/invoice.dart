// ignore_for_file: non_constant_identifier_names

class Invoice {
  final String? address;
  final String? invoicenumber;
  final String? orderID;
  final String? bookingdate;
  final String? pickupdate;
  final String? dropdate;
  final String? bookingstatus;
  final String? customerName;
  final String? customerContact;
  final String? customerMail;
  final String? description;
  final String? quantity;
  final String? unitPrice;
  final String? total;
  final String? amountleft;
  final String? vendorName;
  final String? vendorArea;
  final String? vendorCity;
  final String? vendorState;
  final String? vendorMobile;
  final String? securitydeposit;
  final String? balancedue;
  final String? remtopayvendor;
  final String? gst;
  final String? helmet_charge;
  final String? helmet;
  Invoice({
    required this.address,
    required this.invoicenumber,
    required this.bookingdate,
    required this.pickupdate,
    required this.orderID,
    required this.dropdate,
    required this.bookingstatus,
    required this.customerName,
    required this.customerContact,
    required this.customerMail,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.amountleft,
    required this.vendorName,
    required this.vendorArea,
    required this.vendorCity,
    required this.vendorState,
    required this.vendorMobile,
    required this.securitydeposit,
    required this.balancedue,
    required this.remtopayvendor,
    required this.gst,
    required this.helmet,
    required this.helmet_charge,
  });
}
