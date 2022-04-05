const workerScript = '''
  self.onmessage = function(e) {
  e.data.forEach(
  function(line) {
      console.log(line);
  }
  );
  };
''';

const createWorkerScript = '''
  var blob = new Blob([
    document.querySelector('#worker1').textContent
  ], { type: "text/javascript" })

  var worker = new Worker(window.URL.createObjectURL(blob));
''';

const printLogsScript = '''
function printLogs(lines) {
  worker.postMessage(lines); // Start the worker.
}
''';

const downloadLogsWebScript = '''
function downloadLogsWeb(fileName, text) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', fileName);

  element.style.display = 'none';
  document.body.appendChild(element);
  element.click()
  element.remove()
}
''';
