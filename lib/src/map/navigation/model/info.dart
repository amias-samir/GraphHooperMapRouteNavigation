class Info {
  List<String>? copyrights;
  int? took;

  Info({List<String>? copyrights, int? took}) {
    if (copyrights != null) {
      this.copyrights = copyrights;
    }
    if (took != null) {
      this.took = took;
    }
  }

  Info.fromJson(Map<String, dynamic> json) {
    copyrights = json['copyrights'].cast<String>();
    took = json['took'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['copyrights'] = copyrights;
    data['took'] = took;
    return data;
  }
}