const printRequestHeaderScript = r'''
function printRequestHeader(requestBean) {
  let uri = requestBean["url"]
  let method = requestBean["method"]

  printBoxed(`Request ║ ${method} `, uri.toString())
}
''';

const printResponseScript = '''
function printResponse(responseBean) {
  printResponseHeader(responseBean);
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
}
''';

const printResponseHeaderScript = r'''
function printResponseHeader(responseBean) {
  let uri = responseBean["url"]
  let method = responseBean["method"]

  printBoxed(`Response ║ ${method} ║ Status: ${responseBean["statusCode"]} ${responseBean["statusMessage"]}`,
    uri.toString(),
  );
}
''';

const printBoxedScript = r'''
function printBoxed(header, text) {
  console.log('')
  console.log(`╔╣ ${header}`)
  console.log(`║  ${text}`)
  printLine('╚')
}
''';

const printKVScript = r'''
function printKV(key, value) {
  let maxWidth = 60;
  let pre = `╟ ${key}: `
  let msg = (value == null) ? "null" : value.toString()

  if (pre.length + msg.length > maxWidth) {
    console.log(pre);
    printBlock(msg);
  } else {
    console.log(`${pre}${msg}`);
  }
}
''';

const printBlockScript = '''
function printBlock(msg) {
  let maxWidth = 90;
  let lines = Math.ceil(msg.length / maxWidth);
  for (var i = 0; i < lines; ++i) {
    console.log(
      (i >= 0 ? '║ ' : '') +
          msg.substring(
            i * maxWidth,
            Math.min([
              i * maxWidth + maxWidth,
              msg.length,
              ]
            ),
          ),
    );
  }
}
''';

const printLineScript = r'''
function printLine(pre, suf = '╝') {
  let maxWidth = 60
  console.log(`${pre}${'═'.repeat(maxWidth)}${suf}`)
}
''';

const printMapAsTableScript = r'''
function printMapAsTable(map, header) {
  if (map == null || map.isEmpty) {
    return;
  }
  console.log(`╔ ${header} `);
  let keys = Array.from(map.keys())
  for(var i = 0; i < keys.length; i++) {
   printKV(keys[i], map.get(keys[i]))
  }
  printLine('╚');
}
''';

const printListScript = r'''
function printList(list, tabs = 1) {
  for(var i = 0; i < list.length; i++) {
      let isLast = i == list.length - 1;
      if (list[i] instanceof Object) {
          printPrettyMap(
            new Map(Object.entries(list[i])),
            tabs + 1,
            true,
            isLast,
          );
      } else {
        console.log(`║${indent(tabs + 2)} ${list[i]}${isLast ? '' : ","}`);
      }
  }
}
''';

const canFlattenMapScript = '''
function canFlattenMap(map) {
  let maxWidth = 60

  return Array.from(map.values()).filter((val) => { 
  return val instanceof Object || val instanceof Array
  }).length == 0 &&
      map.toString().length < maxWidth;
}
''';

const canFlattenListScript = '''
function canFlattenList(list) {
  let maxWidth = 60
  
  return list.length < 10 && list.toString().length < maxWidth;
}
''';

const indentScript = '''
function indent(tabCount = 1) {
  return '    '.repeat(tabCount);
}
''';

const printPrettyMapScript = r'''
function printPrettyMap(data, tabs = 1, isListItem = false, isLast = false) {
  var _tabs = tabs;
  let maxWidth = 60;
  let isRoot = _tabs == 1;
  let initialIndent = indent(_tabs);
  _tabs++;

  if (isRoot || isListItem) {
    console.log(`║${initialIndent}{`);
  }
  let keys = Array.from(data.keys())
  for(var index = 0; index < keys.length; index++) {
      let isLast = index == data.length - 1;
      let value = data.get(keys[index]);
      if (value instanceof String) {
        value = `"${value.toString().replaceAll(RegExp(r`(\r|\n)+`), " ")}"`;
      }
      else if (value instanceof Array) {
          console.log(`║${indent(_tabs)} ${keys[index]}: [`);
          printList(value, _tabs);
          console.log(`║${indent(_tabs)} ]${isLast ? '' : ','}`);
      } else if (value instanceof Object) {
          console.log(`║${indent(_tabs)} ${keys[index]}: {`);
          printPrettyMap(new Map(Object.entries(value)), _tabs);
      } else {
        let msg = value.toString().replaceAll('\n', '');
        
          console.log(
            `║${indent(_tabs)} ${keys[index]}: ${msg}${!isLast ? ',' : ''}`,
          );
     
      }
  }
 
  console.log(
    `║${initialIndent}}${isListItem && !isLast ? ',' : ''}`,
  );
}
''';
