class Hints {
  int? visitedNodesSum;
  int? visitedNodesAverage;

  Hints({int? visitedNodesSum, int? visitedNodesAverage}) {
    if (visitedNodesSum != null) {
      this.visitedNodesSum = visitedNodesSum;
    }
    if (visitedNodesAverage != null) {
      this.visitedNodesAverage = visitedNodesAverage;
    }
  }

  Hints.fromJson(Map<String, dynamic> json) {
    visitedNodesSum = json['visited_nodes.sum'].toInt();
    visitedNodesAverage = json['visited_nodes.average'].toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visited_nodes.sum'] = visitedNodesSum;
    data['visited_nodes.average'] = visitedNodesAverage;
    return data;
  }
}