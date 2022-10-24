## 1.1.0

- Small UI updates for headers, link and error preview
- Proxy settings are now stored in the logger. `onProxyChanged` and `onGetProxyFromDB` replaced
  with `getProxySettings` method
- Added custom variable `appInfo` as `Map<String, String>`. `buildType` and `endpoints` variables
  removed, and must be passed in `appInfo`
- Actions and Value notifiers pages are combined into Actions and values page
- Removed `maxCountHttpLogs` and `maxCountOtherLogs` parameters (use `maxLogsCount` instead)
- Chopper and regular http interceptors now depend on `shouldPrintLogs`
  and `shouldPrintInReleaseMode`
  parameters
- The `popupItemAddAction` method has been renamed to a `addActionButton`, and
  the `popupItemAddNotifier` to a `addValueNotifier`
- Fixed print of double http request to console in error case
- Fixed pop-ups under the logger
- Fixed slider reset in web when hovering over debug button
- Fixed error handling for http requests of dart:io library

## 1.0.2

- Hide "hidden" fields in shared file
- Number of logs of each type (http, debug, info, error) is now counted separately
- The `maxCountHttpLogs` and `maxCountOtherLogs` parameters in the logger's `Init` method have been
  replaced by `maxLogsCount`
- Requests that have not yet been responded to now have a "Sending" status
- Fixed error handling for regular http and chopper logs

## 1.0.1

- Added ability to hide fields in requests and responses and in query parameters
- Added ability to turn on/off printing logs in release mode
- Added ability to copy to clipboard headers values
- Fixed missing parameter key in http logs printed in console

## 1.0.0

- Support for Flutter 3.0.0

## 0.9.19

- Added ability to remove action buttons by specified id
- Added ability to remove notifiers by specified id
- Updated readme

## 0.9.18

- Сhanged debug button icon when logger is open
- Fixed debug button disappears after double tap
- Fixed time parsing when loading logs from json

## 0.9.17

- Fixed issue with inspector

## 0.9.16

- Added warning popup when selecting Share logs if `onShareLogsFile` callback was not defined
- ShareLogsFileCallback was described in the readme
- Added ability to minimize logger with saving state when you tap on overlay button again

## 0.9.15

- Changed display of link block on Error tab of Http logs details page to match other tabs

## 0.9.14

- Updated readme

## 0.9.13

- Fix pub.dev warnings

## 0.9.12

- Fix search issue for logs with not string message
- Fixed blank screen when redirect to log details after tap on search result item

## 0.9.11

- First public release