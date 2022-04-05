import 'package:cr_logger/cr_logger.dart';
import 'package:flutter/material.dart';

class ProxyInputDialog extends StatefulWidget {
  const ProxyInputDialog({Key? key}) : super(key: key);

  @override
  _ProxyInputDialogState createState() => _ProxyInputDialogState();
}

class _ProxyInputDialogState extends State<ProxyInputDialog> {
  late TextEditingController iPCtrl;
  late TextEditingController portCtrl;

  @override
  void initState() {
    String? ip;
    String? port;

    final proxyModel = CRLoggerInitializer.instance.onGetProxyFromDB?.call();
    if (proxyModel != null) {
      ip = proxyModel.ip;
      port = proxyModel.port;
    }

    iPCtrl = TextEditingController(text: ip ?? '');
    portCtrl = TextEditingController(text: port ?? '8888');
    super.initState();
  }

  @override
  void dispose() {
    iPCtrl.dispose();
    portCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Proxy settings for Charles'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              // ignore: no-empty-block
              onChanged: (_) => setState(() {}),
              controller: iPCtrl,
              decoration:
                  const InputDecoration(hintText: 'Enter new IP address'),
            ),
            TextField(
              // ignore: no-empty-block
              onChanged: (_) => setState(() {}),
              controller: portCtrl,
              decoration: const InputDecoration(hintText: 'Enter port'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _clearProxy,
            child: const Text('CLEAR'),
          ),
          TextButton(
            onPressed: iPCtrl.text.isEmpty || portCtrl.text.isEmpty
                ? null
                : _saveAndApplyProxy,
            child: const Text('SAVE'),
          ),
        ],
      );

  void _saveAndApplyProxy() {
    final ip = iPCtrl.text.trim();
    final port = portCtrl.text.trim();

    if (ip.isNotEmpty && port.isNotEmpty) {
      final proxy = ProxyModel(ip, port);
      CRLoggerInitializer.instance.onProxyChanged?.call(proxy);
    }

    Navigator.of(context).pop();
  }

  void _clearProxy() {
    iPCtrl.clear();
    portCtrl.clear();
    _saveAndApplyProxy();
  }
}
