extension MapExt<T> on Map<T, dynamic> {
  // ignore: avoid_annotating_with_dynamic
  void putIfNotNull(dynamic value, T key) {
    if (value != null) {
      this[key] = value;
    }
  }

  void clearAllNull() {
    removeWhere((key, value) => value == null);
  }
}
