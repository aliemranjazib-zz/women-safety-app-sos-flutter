/// PopResult
class PopWithResults<T> {
  /// poped from this page
  final String fromPage;

  /// pop until this page
  final String toPage;

  /// results
  final Map<String, T>? results;

  /// constructor
  PopWithResults({required this.fromPage, required this.toPage, this.results});
}
