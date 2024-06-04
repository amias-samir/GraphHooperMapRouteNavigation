class Instructions {
  double? distance;
  double? heading;
  int? sign;
  List<int>? interval;
  String? text;
  int? time;
  String? streetName;
  double? lastHeading;

  Instructions({double? distance, double? heading, int? sign, List<int>? interval, String? text, int? time, String? streetName, double? lastHeading}) {
    if (distance != null) {
      this.distance = distance;
    }
    if (heading != null) {
      this.heading = heading;
    }
    if (sign != null) {
      this.sign = sign;
    }
    if (interval != null) {
      this.interval = interval;
    }
    if (text != null) {
      this.text = text;
    }
    if (time != null) {
      this.time = time;
    }
    if (streetName != null) {
      this.streetName = streetName;
    }
    if (lastHeading != null) {
      this.lastHeading = lastHeading;
    }
  }


  Instructions.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    heading = json['heading'];
    sign = json['sign'];
    interval = json['interval'].cast<int>();
    text = json['text'];
    time = json['time'];
    streetName = json['street_name'];
    lastHeading = json['last_heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['heading'] = heading;
    data['sign'] = sign;
    data['interval'] = interval;
    data['text'] = text;
    data['time'] = time;
    data['street_name'] = streetName;
    data['last_heading'] = lastHeading;
    return data;
  }
}