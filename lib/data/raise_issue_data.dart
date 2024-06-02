class RaiseIssueData {
  String? ticketId;
  String? issueType;
  String? comment;
  String? mobile;
  String? status;
  String? createdOn;
  String? resolvedOn;

  RaiseIssueData(
      {this.ticketId,
        this.issueType,
        this.comment,
        this.mobile,
        this.status,
        this.createdOn,
        this.resolvedOn});

  RaiseIssueData.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    issueType = json['issue_type'];
    comment = json['comment'];
    mobile = json['mobile'];
    status = json['status'];
    createdOn = json['created_on'];
    resolvedOn = json['resolved_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['issue_type'] = this.issueType;
    data['comment'] = this.comment;
    data['mobile'] = this.mobile;
    data['status'] = this.status;
    data['created_on'] = this.createdOn;
    data['resolved_on'] = this.resolvedOn;
    return data;
  }
}
