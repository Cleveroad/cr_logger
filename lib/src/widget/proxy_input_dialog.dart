import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class ProxyInputDialog extends StatefulWidget {
  const ProxyInputDialog({super.key});

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

    final proxy = CRLoggerHelper.instance.getProxyFromSharedPref();
    if (proxy != null) {
      final items = proxy.split(':');
      ip = items.first;
      port = items[1];
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Proxy settings for Charles'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Changes will be applied after restarting the app',
            style: CRStyle.captionGreyMedium12,
          ),
          TextField(
            // ignore: no-empty-block
            onChanged: (_) => setState(() {}),
            controller: iPCtrl,
            decoration: const InputDecoration(hintText: 'Enter new IP address'),
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
          child: const DefaultTextStyle(
            style: TextStyle(color: CRLoggerColors.red),
            child: Text('CLEAR'),
          ),
        ),
        TextButton(
          onPressed: _closeDialog,
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed:
              iPCtrl.text.isEmpty || portCtrl.text.isEmpty ? null : _saveProxy,
          child: const Text('SAVE'),
        ),
      ],
    );
  }

  void _closeDialog() => Navigator.of(context).pop();

  Future<void> _saveProxy() async {
    final ip = iPCtrl.text.trim();
    final port = portCtrl.text.trim();

    if (ip.isNotEmpty && port.isNotEmpty) {
      final proxy = '$ip:$port';
      await CRLoggerHelper.instance.setProxyToSharedPref(proxy);
    }
    _closeDialog();
  }

  Future<void> _clearProxy() async {
    await CRLoggerHelper.instance.setProxyToSharedPref(null);
    _closeDialog();
  }
}
