enum LayoutType {
  web,
  mobile,
}

extension LayoutTypeExt on LayoutType {
  bool get isWebLayout => this == LayoutType.web;
}
