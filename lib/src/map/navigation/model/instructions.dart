class Instructions {
  double? _distance;
  double? _heading;
  int? _sign;
  List<int>? _interval;
  String? _text;
  int? _time;
  String? _streetName;
  double? _lastHeading;

  Instructions({double? distance, double? heading, int? sign, List<int>? interval, String? text, int? time, String? streetName, double? lastHeading}) {
    if (distance != null) {
      this._distance = distance;
    }
    if (heading != null) {
      this._heading = heading;
    }
    if (sign != null) {
      this._sign = sign;
    }
    if (interval != null) {
      this._interval = interval;
    }
    if (text != null) {
      this._text = text;
    }
    if (time != null) {
      this._time = time;
    }
    if (streetName != null) {
      this._streetName = streetName;
    }
    if (lastHeading != null) {
      this._lastHeading = lastHeading;
    }
  }

  double? get distance => _distance;
  set distance(double? distance) => _distance = distance;
  double? get heading => _heading;
  set heading(double? heading) => _heading = heading;
  int? get sign => _sign;
  set sign(int? sign) => _sign = sign;
  List<int>? get interval => _interval;
  set interval(List<int>? interval) => _interval = interval;
  String? get text => _text;
  set text(String? text) => _text = text;
  int? get time => _time;
  set time(int? time) => _time = time;
  String? get streetName => _streetName;
  set streetName(String? streetName) => _streetName = streetName;
  double? get lastHeading => _lastHeading;
  set lastHeading(double? lastHeading) => _lastHeading = lastHeading;

  Instructions.fromJson(Map<String, dynamic> json) {
    _distance = json['distance'];
    _heading = json['heading'];
    _sign = json['sign'];
    _interval = json['interval'].cast<int>();
    _text = json['text'];
    _time = json['time'];
    _streetName = json['street_name'];
    _lastHeading = json['last_heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this._distance;
    data['heading'] = this._heading;
    data['sign'] = this._sign;
    data['interval'] = this._interval;
    data['text'] = this._text;
    data['time'] = this._time;
    data['street_name'] = this._streetName;
    data['last_heading'] = this._lastHeading;
    return data;
  }
}