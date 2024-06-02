class SecurityDepositData {
  String? transId;
  String? ridobikoOrderId;
  String? amount;
  String? paymentMode;
  String? transDate;
  String? status;
  String? txnType;
  String? comment;
  String? modifiedOn;

  SecurityDepositData(
      {this.transId,
        this.ridobikoOrderId,
        this.amount,
        this.paymentMode,
        this.transDate,
        this.status,
        this.txnType,
        this.comment,
        this.modifiedOn});

  SecurityDepositData.fromJson(Map<String, dynamic> json) {
    transId = json['trans_id'];
    ridobikoOrderId = json['ridobiko_order_id'];
    amount = json['amount'];
    paymentMode = json['payment_mode'];
    transDate = json['trans_date'];
    status = json['status'];
    txnType = json['txn_type'];
    comment = json['comment'];
    modifiedOn = json['modified_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trans_id'] = this.transId;
    data['ridobiko_order_id'] = this.ridobikoOrderId;
    data['amount'] = this.amount;
    data['payment_mode'] = this.paymentMode;
    data['trans_date'] = this.transDate;
    data['status'] = this.status;
    data['txn_type'] = this.txnType;
    data['comment'] = this.comment;
    data['modified_on'] = this.modifiedOn;
    return data;
  }
}
