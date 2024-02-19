const kLoggerPackage = 'package:logger';
const kLogFileName = 'log';

const kMethodPost = 'POST';
const kHidden = 'Hidden';

const kMaxDuration = 3000;
const kAverageDuration = 2000;
const kMinDuration = 1000;
const kWorkerId = 'worker1';
const kRequestWorkerId = 'requestWorker';
const kResponseWorkerId = 'responseWorker';
const kErrorWorkerId = 'errorWorker';
const kMs = 'ms';
const kSending = 'Sending';

/// Maximum number of each type of logs (http, debug, info, error) by default
const kDefaultMaxLogsCount = 50;

const kDefaultOfUrlCount = 4;

/// Used to stop updating log list (if logs come too often)
const kIndentForLoadingLogs = 100;

final patternOfParamsRegex = RegExp(r'\{\{|\}\}');
