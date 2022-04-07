class ScriptElement {
  late String text;
  late String id;
  late bool defer;

  // ignore: no-empty-block
  void remove() {}
}

late DocStub document;

class DocStub {
  BodyStub? body;
}

class BodyStub {
  // ignore: avoid-unused-parameters
  // ignore: no-empty-block
  void append(_) {}
}

class JS {
  const JS([this.name]);

  final String? name;
}
