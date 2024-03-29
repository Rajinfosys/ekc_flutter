class PartyModel {
  int? partyid;
  String? fullname;

  PartyModel({this.partyid, this.fullname});

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    int? partyid = json['partyid'];
    String? fullname = json['fullname'];
    return PartyModel(partyid: partyid, fullname: fullname);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['partyid'] = partyid;
    data['fullname'] = fullname;
    return data;
  }
}
