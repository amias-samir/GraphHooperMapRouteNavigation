class Hints {
  int? _visitedNodesSum;
  int? _visitedNodesAverage;

  Hints({int? visitedNodesSum, int? visitedNodesAverage}) {
    if (visitedNodesSum != null) {
      this._visitedNodesSum = visitedNodesSum;
    }
    if (visitedNodesAverage != null) {
      this._visitedNodesAverage = visitedNodesAverage;
    }
  }

  int? get visitedNodesSum => _visitedNodesSum;
  set visitedNodesSum(int? visitedNodesSum) => _visitedNodesSum = visitedNodesSum;
  int? get visitedNodesAverage => _visitedNodesAverage;
  set visitedNodesAverage(int? visitedNodesAverage) => _visitedNodesAverage = visitedNodesAverage;

  Hints.fromJson(Map<String, dynamic> json) {
    _visitedNodesSum = json['visited_nodes.sum'].toInt();
    _visitedNodesAverage = json['visited_nodes.average'].toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visited_nodes.sum'] = this._visitedNodesSum;
    data['visited_nodes.average'] = this._visitedNodesAverage;
    return data;
  }
}