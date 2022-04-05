const requestWorkerScript = '''
self.onmessage = function (e) {
  let requestBean = JSON.parse(e.data)

  printRequestHeader(requestBean)
  printMapAsTable(new Map(Object.entries(requestBean["params"])), 'Query Parameters');
  printMapAsTable(new Map(Object.entries(requestBean["headers"])), 'Headers');
  
   if (requestBean["method"] != 'GET') {
    let data = requestBean["body"];
    if (data != null) {
      if (data instanceof Object) {
        printMapAsTable(new Map(Object.entries(data)), 'Body');
      }
      else {
        printBlock(data.toString());
      }
    }
  }
};
''';

const createRequestWorkerScript = '''
  var requestBlob = new Blob([
    document.querySelector('#requestWorker').textContent
  ], { type: "text/javascript" })

  var requestWorker = new Worker(window.URL.createObjectURL(requestBlob));
''';

const printRequestLogScript = '''
function printRequestLog(requestBean) {
  requestWorker.postMessage(requestBean);
}
''';
