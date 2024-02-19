/// Log message wrapper allowing to add new parameters
class LogMessageWrapper {
  LogMessageWrapper({
    required this.message,
    required this.showToast,
  });

  dynamic message;
  bool showToast;
}
