class Info {
  List<String>? _copyrights;
  int? _took;

  Info({List<String>? copyrights, int? took}) {
    if (copyrights != null) {
      this._copyrights = copyrights;
    }
    if (took != null) {
      this._took = took;
    }
  }

  List<String>? get copyrights => _copyrights;
  set copyrights(List<String>? copyrights) => _copyrights = copyrights;
  int? get took => _took;
  set took(int? took) => _took = took;

  Info.fromJson(Map<String, dynamic> json) {
    _copyrights = json['copyrights'].cast<String>();
    _took = json['took'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['copyrights'] = this._copyrights;
    data['took'] = this._took;
    return data;
  }
}