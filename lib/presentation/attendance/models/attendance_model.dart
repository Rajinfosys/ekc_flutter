import 'package:qr_code_scanner/core/utils/log_util.dart';

class AttendanceModel {
  int? attendedId;
  int? locationId;
  String? tableType;
  String? userName;
  String? supervisorName;
  String? supervisorPic;
  String? visitPic;
  String? cityName;
  String? areaName;
  String? unitName;
  String? regNo;
  String? attendDate;
  String? startTime;
  String? endTime;
  String? startKms;
  String? endKms;
  String? odoStartPic;
  String? odoEndPic;
  String? supervisorRemarks;
  String? startPic;
  String? endPic;
  String? latitude;
  String? longitude;
  String? geolocation;
  String? altitude;
  String? endLatitude;
  String? endLongitude;
  String? endGeolocation;
  String? endAltitude;

  AttendanceModel({
    this.tableType,
    this.attendedId,
    this.locationId,
    this.userName,
    this.supervisorName,
    this.supervisorPic,
    this.visitPic,
    this.cityName,
    this.areaName,
    this.unitName,
    this.regNo,
    this.attendDate,
    this.startTime,
    this.endTime,
    this.startKms,
    this.endKms,
    this.odoStartPic,
    this.odoEndPic,
    this.supervisorRemarks,
    this.startPic,
    this.endPic,
    this.latitude,
    this.longitude,
    this.geolocation,
    this.altitude,
    this.endLatitude,
    this.endLongitude,
    this.endGeolocation,
    this.endAltitude,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    LogUtil.warning(json);
    int? attendedId = json['attend_id'];
    int? locationId = json['company_id'];
    String? userName = json['user_name'];
    String? supervisorName = json['supervisorname'];
    String? supervisorPic = json['supervisorpic'];
    String? visitPic = json['visitpic'];
    String? cityName = json['cityname'];
    String? areaName = json['areaname'];
    String? unitName = json['unitname'];
    String? regNo = json['regno'];
    String? attendDate = json['attenddate'];
    String? startTime = json['starttime'] != '' ? json['starttime'] : null;
    String? endTime = json['endtime'] != '' ? json['endtime'] : null;
    String? startKms = json['startkms'];
    String? endKms = json['endkms'];
    String? odoStartPic = json['odostartpic'];
    String? odoEndPic = json['odoendpic'];
    String? supervisorRemarks = json['supervisorremarks'];
    String? startPic = json['startPic'];
    String? endPic = json['endPic'];
    String? latitude = json['latitude'];
    String? longitude = json['longitude'];
    String? geolocation = json['geolocation'];
    String? altitude = json['altitude'];
    String? endLatitude = json['endlatitude'];
    String? endLongitude = json['endLongitude'];
    String? endGeolocation = json['endgeolocation'];
    String? endAltitude = json['endaltitude'];
    return AttendanceModel(
      attendedId: attendedId,
      userName: userName,
      locationId: locationId,
      supervisorName: supervisorName,
      supervisorPic: supervisorPic,
      visitPic: visitPic,
      cityName: cityName,
      areaName: areaName,
      unitName: unitName,
      regNo: regNo,
      attendDate: attendDate,
      startTime: startTime,
      endTime: endTime,
      startKms: startKms,
      endKms: endKms,
      odoStartPic: odoStartPic,
      odoEndPic: odoEndPic,
      supervisorRemarks: supervisorRemarks,
      startPic: startPic,
      endPic: endPic,
      latitude: latitude,
      longitude: longitude,
      geolocation: geolocation,
      altitude: altitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
      endGeolocation: endGeolocation,
      endAltitude: endAltitude,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["dbtype"] = tableType;
    data['attend_id'] = attendedId;
    data['company_id'] = locationId;
    data['user_name'] = userName;
    data['supervisorname'] = supervisorName;
    data['supervisorpic'] = supervisorPic;
    data['visitpic'] = visitPic;
    data['cityname'] = cityName;
    data['areaname'] = areaName;
    data['unitname'] = unitName;
    data['regno'] = regNo;
    data['attenddate'] = attendDate;
    data['starttime'] = startTime;
    data['endtime'] = endTime;
    data['startkms'] = startKms;
    data['endkms'] = endKms;
    data['odostartpic'] = odoStartPic;
    data['odoendpic'] = odoEndPic;
    data['supervisorremarks'] = supervisorRemarks;
    data['startPic'] = startPic;
    data['endPic'] = endPic;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['geolocation'] = geolocation;
    data['altitude'] = altitude;
    data['endlatitude'] = endLatitude;
    data['endlongitude'] = endLongitude;
    data['endgeolocation'] = endGeolocation;
    data['endaltitude'] = endAltitude;
    return data;
  }
}
