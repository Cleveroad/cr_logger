extension IntExt on int {
  String toStringWithLeading([int width = 2, String symbol = '0']) =>
      toString().padLeft(width, symbol);

  String get leading => toStringWithLeading();

  String get leading3 => toStringWithLeading(3);
}
