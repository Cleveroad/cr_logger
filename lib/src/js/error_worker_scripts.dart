const errorWorkerScript = r'''
self.onmessage = function (e) {
  let errorBean = JSON.parse(e.data)
  console.log(errorBean)
  if (errorBean["responseBean"] != null) {
    let uri = errorBean["url"];
    printBoxed(
      `Error ║ Status: ${errorBean["statusCode"]} ${errorBean["statusMessage"]}`,
      uri.toString(),
    );
    if (errorBean["errorMessage"] != null && errorBean["responseBean"] != null) {
      let responseBean = errorBean["responseBean"]
      printMapAsTable(new Map(Object.entries(responseBean["headers"])), 'Headers');
      console.log('╔ Body');
      console.log('║')
      if (responseBean["data"] != null) {
        if (responseBean["data"] instanceof Object) {
          printPrettyMap(new Map(Object.entries(responseBean["data"])));
        } else if (responseBean["data"] instanceof Array) {
          console.log(`║    [`);
          printList(responseBean["data"]);
          console.log(`║    [`);
        } else {
          printBlock(responseBean["data"].toString());
        }
      }
      console.log('║');
      printLine('╚');
    } else {
      printLine('╚');
      console.log('');
    }
  } else {
    printBoxed(
      'Error ║ ',
      errorBean["errorMessage"],
    );
  }
};
''';

const createErrorWorkerScript = '''
  var errorBlob = new Blob([
    document.querySelector('#errorWorker').textContent
  ], { type: "text/javascript" })

  var errorWorker = new Worker(window.URL.createObjectURL(errorBlob));
''';

const printErrorLogScript = '''
function printErrorLog(errorBean) {
  errorWorker.postMessage(errorBean); 
}
''';
