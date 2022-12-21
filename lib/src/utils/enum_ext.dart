extension EnumValueOf<T extends Enum> on Iterable<T> {
  T? valueOf(String? name) {
    if (name != null) {
      final lowerCase = name.toLowerCase();

      return firstWhere((value) => value.name == lowerCase);
    }

    return null;
  }
}
