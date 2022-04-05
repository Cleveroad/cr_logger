# cr_logger

<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/banner.png" width="100%">

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

## Getting Started

1. Add plugin to the project:
    ```yaml
    dependencies:
        cr_logger: ^0.9.12
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
            isPrintingLogs: true,
        );
        }
    ```
   `isPrintingLogs` - Prints all logs while [isPrintingLogs] true

   `theme` - Custom logger theme

   `levelColors` - Colors for message types levelColors (debug, verbose, info, warning, error, wtf)

   `hiddenFields` - List of hidden fields that do not need to be shown in headers & body, for example: token
   
   `logFileName` - File name when sharing logs

   `maxCountHttpLogs` - Maximum number of http logs, default = 50

   `maxCountOtherLogs` - Maximum number of other logs, default = 50

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

   5.1 `GetIPAndPortFromDBCallback` - return stored Charles IP:PORT settings. Example:
   ```  
      CRLoggerInitializer.instance.onGetProxyFromDB = () {
         return DBProvider.instance.iPAndPort;
      };
   ```
   5.2 `ProxySettingsChangeCallback` - when need to store new Charles IP:PORT settings. Example:
   ```  
      CRLoggerInitializer.instance.onProxyChanged = (ip, port) {
         DBProvider.instance.iPAndPort = '$ip:$port';
      };
   ```
   5.3 `LogoutCallback` - when needed to log out from app
   ```  
      CRLoggerInitializer.instance.onLogout = () async {
         // logout simulation
         await Future.delayed(const Duration(seconds: 1));
      };
   ```


6. Define the variables:

   6.1 `buildType` - e.g. ```CRLoggerInitializer.instance.buildType = buildType.toString();```

   6.2 `logFileName` - file name when exporting logs
   
   6.3 `hiddenFields` - list of keys for headers to hide when showing network logs

   6.4 `endpoints`


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

## Usage
If the logger is enabled, a floating button appears on the screen; it also indicates the project build number.
It's quite easy to use, just click on the floating button to show the main screen of the logger
You can also `double tap` on the button to invoke **Quick Actions**.

## Quick actions
Using this popup menu, you can **quickly access** the desired CRLogger options.
Called by a **long press** or **double tap** on the debug button.
#####
##### App info
Allows you to view **Build type**, also **Endpoint**, **Package name**, **app version** and **build version**
##### Clear logs
**Clears** application logs
##### Show Inspector
If the **inspector** is enabled, then a panel appears on the right side of the screen, with buttons to toggle size inspection and the color picker.
##### Set Charles proxy
Needed to set **proxy settings** for Charles
##### Search
Provides **search by logs** (Debug, Info, Error)
##### Share logs
Share logs with your team
##### Import logs
Import logs from file
##### Value notifiers
Helps to track changes in values in variables of the **ValueNotifier** type, the value can be either a **simple type** or a **Widget** and etc.
1. Type notifiers:

    ```dart
    ...
    final integerNotifier = ValueNotifier<int>(0);
    final doubleNotifier = ValueNotifier<double>(0);
    final boolNotifier = ValueNotifier<bool>(false);
    final stringNotifier = ValueNotifier<String>('integer: ');
    final iconNotifier = ValueNotifier<Icon>(Icon(Icons.clear));
    final textNotifier = ValueNotifier<Text>(Text('Widget text'));
    ```
2. Add notifiers:

    ```dart
    ...
    CRLoggerInitializer.instance.popupItemAddNotifier('Integer', integerNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Double', doubleNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Bool', boolNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('String', stringNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Icon', iconNotifier);
    CRLoggerInitializer.instance.popupItemAddNotifier('Text', textNotifier);
    ```
##### Actions
Allows you to add **different callbacks** for testing
1. Add actions:

    ```dart
    ...
    CRLoggerInitializer.instance.popupItemAddAction('Log Hi', () => log.i('Hi'));
    CRLoggerInitializer.instance.popupItemAddAction('Log By', () => log.i('By'));
    ```

##### App settings
Opens application settings

## Setup
In IntelliJ/Studio you can collapse the request/response body:

![Gif showing collapsible body][show_body]

Set up this is by going to `Preferences -> Editor -> General -> Console`
and under `Fold console lines that contain` add these 2 rules: `║`, `╟`
and under `Exceptions` add 1 rule: `╔╣`

![Settings][settings]

## Examples
<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-1.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-2.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-3.png" height="500">

<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-4.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-5.png" height="500">  <img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-6.png" height="500">
<img src="https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/screenshot-web.png" height="500">

[show_body]: https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/http-logs-example.gif
[settings]: https://raw.githubusercontent.com/Cleveroad/cr_logger/master/screenshots/settings-screenshot.png
