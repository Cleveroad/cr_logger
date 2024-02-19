enum LogsMode {
  fromCurrentSession('Current logs'),
  fromDB('DB logs');

  const LogsMode(this.appBarTitle);

  final String appBarTitle;
}
