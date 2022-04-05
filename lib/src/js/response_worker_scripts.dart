const responseWorkerScript = '''
self.onmessage = function (e) {
  let responseBean = JSON.parse(e.data)
 
  printResponse(responseBean)
};
''';

const createResponseWorkerScript = '''
  var responseBlob = new Blob([
    document.querySelector('#responseWorker').textContent
  ], { type: "text/javascript" })

  var responseWorker = new Worker(window.URL.createObjectURL(responseBlob));
''';

const printResponseLogScript = '''
function printResponseLog(responseBean) {
  responseWorker.postMessage(responseBean); 
}
''';
