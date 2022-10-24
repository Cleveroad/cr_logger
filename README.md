# cr_logger

<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/plugin_banner.png" width="100%">

Web [example](https://cleveroad.github.io/cr_logger)

**Flutter plugin for logging**

* Simple logging to logcat.
* Network request intercepting.
* Log exporting (JSON format).
* Proxy settings for "Charles".
* Logs by level.

**Supported Dart http client plugins:**  
✔️ Dio  
✔️ Chopper  
✔️ Http from http/http package  
✔️ HttpClient from dart:io package

## Table of contents

- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Quick actions](#quick-actions)
- [Setup](#setup)

## Screenshots
<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-1.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-2.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-3.png" height="500">

<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-4.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-5.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-6.png" height="500">

<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-web.png" height="500">

## Getting Started

1. Add plugin to the project:
   ```yaml
   dependencies:
     cr_logger: ^1.1.0
   ```

2. Initialize the logger. main.dart:

   ```dart
   void main()  {
     ...
     CRLoggerInitializer.instance.init(
       theme: ThemeData.light(),
       levelColors: {
         Level.debug: Colors.grey.shade300,
         Level.warning: Colors.orange,
       },
       hiddenFields: [
         'token',
       ],
       logFileName: 'my_logs',
       shouldPrintLogs: true,
       shouldPrintInReleaseMode: false,
     );
   }
   ```
   `shouldPrintLogs` - Prints all logs while [shouldPrintLogs] is true

   `shouldPrintInReleaseMode` - Will all logs be printed when [kReleaseMode] is true

   `theme` - Custom logger theme

   `levelColors` - Colors for message types levelColors (debug, verbose, info, warning, error, wtf)

   `hiddenFields` - List of keys, whose value need to be replaced by string 'Hidden'

   `logFileName` - File name when sharing logs

   `maxLogsCount` - Maximum number of each type of logs (http, debug, info, error), by default = 50

   `logger` - Custom logger

3. Provide functions to handle cr_logger jobs in separate Isolates (e.g. printing logs or parsing jsons).
   When writing a lot of logs and printing it to the console UI may lag a lot. Isolates helps to improve
   performance for debug builds with cr_logger enabled. Example is using worker_manager package for
   convenient work with Dart Isolates:

   ```dart
   Future<void> main() async {
     // Call this first if main function is async
     WidgetsFlutterBinding.ensureInitialized();
     
     ...
     await Executor().warmUp();
     CRLoggerInitializer.instance.handleFunctionInIsolate = (fun, data) async {
       return await Executor().execute(
         arg1: data,
         fun1: fun,
       );
     };
     
     CRLoggerInitializer.instance.parseiOSJsonStringInIsolate = (fun, data) async {
       return await Executor().execute(
         arg1: data,
         fun1: fun,
       );
     };
     ...
   }
   ```

4. Initialize Inspector (optional):

   ```dart
   return MaterialApp(
     home: const MainPage(),
     builder: (context, child) => CrInspector(child: child!),
   );
   ```

5. Initialize the following callbacks (optional):

   5.1 `LogoutCallback` - when needed to log out from app
   ```dart
   CRLoggerInitializer.instance.onLogout = () async {
     // logout simulation
     await Future.delayed(const Duration(seconds: 1));
   };
   ```
   5.2 `ShareLogsFileCallback` - when needed to share logs file on the app's side
   ```dart
   CRLoggerInitializer.instance.onShareLogsFile = (path) async {
     await Share.shareFiles([path]);
   };
   ```

6. Define the variables:

   6.1 `appInfo` - you can provide custom information to be displayed on the AppInfo page 
   ```dart
   CRLoggerInitializer.instance.appInfo = {
     'Build type': buildType.toString(),
     'Endpoint': 'https/cr_logger/example/',
   };
   ```

   6.2 `logFileName` - file name when exporting logs

   6.3 `hiddenFields` - list of keys for headers to hide when showing network logs

7. Add the overlay button:

   ```dart
   CRLoggerInitializer.instance.showDebugButton(context);
   ```

   `button` - Custom floating button

   `left` - X-axis start position

   `top` - Y-axis start position

8. You can turn on/off the printing logs in the isolate, by default enabled:

   ```dart
   CRLoggerInitializer.instance.isIsolateHttpLogsPrinting = false;
   ```

9. Support for importing logs from json:

   ```dart
   await CRLoggerInitializer.instance.createLogsFromJson(json);
   ```

10. You can get the current proxy settings to initialise Charles:

   ```dart
   final proxy = CRLoggerInitializer.instance.getProxySettings();
   if (proxy != null) {
     RestClient.instance.init(proxy);
   }
   ```

## Usage
If the logger is enabled, a floating button appears on the screen; it also indicates the project build number.
It's quite easy to use, just click on the floating button to show the main screen of the logger
You can also `double tap` on the button to invoke **Quick Actions**.

## Quick actions
Using this popup menu, you can **quickly access** the desired CRLogger options.
Called by a **long press** or **double tap** on the debug button.
#####
#### App info
Allows you to view **Package name**, **app version**, **build version** and 
#### Clear logs
**Clears** application logs
#### Show Inspector
If the **inspector** is enabled, then a panel appears on the right side of the screen, with buttons to toggle size inspection and the color picker.
#### Set Charles proxy
Needed to set **proxy settings** for Charles
#### Search
Provides **search by logs** (Debug, Info, Error)
#### Share logs
Share logs with your team
#### Actions and values
Opens a page that contains action buttons and value notifiers.

**Action buttons** allows you to add **different callbacks** for testing
1. Add actions:

   ```dart
   CRLoggerInitializer.instance.addActionButton('Log Hi', () => log.i('Hi'));
   CRLoggerInitializer.instance.addActionButton(
     'Log By',
     () => log.i('By'),
     connectedWidgetId: 'some identifier',
   );
   ```

2. Remove actions by specified id:

   ```dart
   CRLoggerInitializer.instance.removeActionsById('some identifier');
   ```

**Value notifiers** help keep track of changes to variables of **ValueNotifier** type. The value can be either a **simple type** or a **Widget** and etc.
1. Type notifiers:

   ```dart
   final integerNotifier = ValueNotifier<int>(0);
   final doubleNotifier = ValueNotifier<double>(0);
   final boolNotifier = ValueNotifier<bool>(false);
   final stringNotifier = ValueNotifier<String>('integer: ');
   final iconNotifier = ValueNotifier<Icon>(Icon(Icons.clear));
   final textNotifier = ValueNotifier<Text>(Text('Widget text'));
   ```

2. Add notifiers:

   ```dart
   CRLoggerInitializer.instance.addValueNotifier('Integer', integerNotifier);
   CRLoggerInitializer.instance.addValueNotifier('Double', doubleNotifier);
   CRLoggerInitializer.instance.addValueNotifier('Bool', boolNotifier);
   CRLoggerInitializer.instance.addValueNotifier('String', stringNotifier);
   CRLoggerInitializer.instance.addValueNotifier('Icon', iconNotifier);
   CRLoggerInitializer.instance.addValueNotifier(
     'Text',
     textNotifier,
     connectedWidgetId: 'some identifier',
   );
   ```

3. Remove notifiers by specified id:

   ```dart
   CRLoggerInitializer.instance.removeNotifiersById('some identifier');
   ```

4. Clear all notifiers:

   ```dart
   CRLoggerInitializer.instance.notifierListClear();
   ```

#### App settings
Opens application settings
#### Logout from app
A quick way to quit your application by providing an **onLogout** callback

## Setup
In IntelliJ/Studio you can collapse the request/response body:

![Gif showing collapsible body][show_body]

Set up this is by going to `Preferences -> Editor -> General -> Console`
and under `Fold console lines that contain` add these 2 rules: `║`, `╟`
and under `Exceptions` add 1 rule: `╔╣`

![Settings][settings]

[show_body]: https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/http-logs-example.gif
[settings]: https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/settings-screenshot.png
