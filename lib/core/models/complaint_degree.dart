enum ComplaintDegree {
  low('Low'),
  medium('Medium'),
  high('High'),
  urgent('Urgent');

  const ComplaintDegree(this.label);
  final String label;

  static ComplaintDegree fromLabel(String label) {
    return ComplaintDegree.values.firstWhere(
      (degree) => degree.label == label,
      orElse: () => ComplaintDegree.low,
    );
  }

  String toJson() => label;

  static ComplaintDegree fromJson(String json) {
    return ComplaintDegree.fromLabel(json);
  }
}
