import 'package:app_settings/app_settings.dart';
import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/page/actions_and_values/actions_and_values_page.dart';
import 'package:cr_logger/src/page/app_info_page.dart';
import 'package:cr_logger/src/page/http_logs_page.dart';
import 'package:cr_logger/src/page/log_local_page.dart';
import 'package:cr_logger/src/page/log_search_page.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:cr_logger/src/utils/show_info_dialog.dart';
import 'package:cr_logger/src/widget/proxy_input_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({
    this.child,
    this.popupKey,
    this.onCanceled,
    super.key,
  });

  final Widget? child;
  final GlobalKey? popupKey;
  final VoidCallback? onCanceled;

  @override
  State<PopupMenu> createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {
  final crLoggerInitializer = CRLoggerInitializer.instance;
  final _httpLogKey = GlobalKey<HttpLogsPageState>();
  final _debugLogKey = GlobalKey<LocalLogsPageState>();
  final _infoLogKey = GlobalKey<LocalLogsPageState>();
  final _errorLogKey = GlobalKey<LocalLogsPageState>();

  late final List<GlobalKey> _keys;
  late final List<_PopupMenuItem> _menuItems = [
    _PopupMenuItem(
      title: const Text('App info'),
      icon: Icons.info,
      onTap: _openAppInfo,
    ),
    _PopupMenuItem(
      title: const Text('Clear logs'),
      icon: Icons.delete_sweep,
      onTap: _cleanAllLogs,
    ),
    _PopupMenuItem(
      title: ValueListenableBuilder<bool>(
        valueListenable: CRLoggerHelper.instance.inspectorNotifier,
        // ignore: prefer-trailing-comma
        builder: (_, value, __) =>
            Text(value ? 'Hide Inspector' : 'Show Inspector'),
      ),
      icon: Icons.design_services_outlined,
      onTap: _toggleInspector,
    ),
    if (!kIsWeb)
      _PopupMenuItem(
        title: const Text('Set Charles proxy'),
        icon: Icons.important_devices,
        onTap: _showIpInput,
      ),
    _PopupMenuItem(
      title: const Text('Search'),
      icon: Icons.search,
      onTap: _openSearchPage,
    ),
    _PopupMenuItem(
      title: const Text('Share logs'),
      icon: Icons.share,
      onTap: _shareLogs,
    ),
    _PopupMenuItem(
      title: const Text('Actions and values'),
      icon: Icons.add_to_home_screen,
      onTap: _openActionsAndValuesPage,
    ),
    // App Settings is not implemented on Web
    if (!kIsWeb)
      _PopupMenuItem(
        title: const Text('App settings'),
        icon: Icons.app_settings_alt,
        onTap: _openAppSettings,
      ),
    _PopupMenuItem(
      title: const Text('Logout from app'),
      icon: Icons.logout,
      onTap: _logOut,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _keys = [
      _httpLogKey,
      _debugLogKey,
      _infoLogKey,
      _errorLogKey,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VoidCallback>(
      key: widget.popupKey,
      itemBuilder: (_) => _menuItems,
      onSelected: _onSelected,
      onCanceled: _onCanceled,
      child: widget.child,
    );
  }

  Future<void> _cleanAllLogs() async {
    CRLoggerHelper.instance.hideLogger();
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return Theme(
          data: CRLoggerHelper.instance.theme,
          child: AlertDialog(
            title: const Text('Clear logs'),
            content: const Text('Do you want to clear all logs?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('YES'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
            ],
          ),
        );
      },
    ).then((deleteLogs) {
      if (deleteLogs ?? false) {
        LocalLogManager.instance.clean();
        HttpLogManager.instance.clear();
        for (final item in _keys) {
          // ignore: no-empty-block
          item.currentState?.setState(() {});
        }
      }
    });
  }

  Future<void> _logOut() async {
    if (crLoggerInitializer.onLogout == null) {
      CRLoggerHelper.instance.hideLogger();

      return showInfoDialog(
        context: context,
        title: const Text('Warning'),
        content: const Text(
          'onLogout callback is not defined in CRLoggerInitializer.\n\n'
          'Please, contact developer.',
        ),
      );
    }

    await crLoggerInitializer.onLogout?.call();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Logged out')));
  }

  Future<void> _shareLogs() async {
    if (crLoggerInitializer.onShareLogsFile == null) {
      CRLoggerHelper.instance.hideLogger();

      return showInfoDialog(
        context: context,
        title: const Text('Warning'),
        content: const Text(
          'onShareLogsFile callback is not defined in CRLoggerInitializer.\n\n'
          'Please, contact developer.',
        ),
      );
    }

    return LocalLogManager.instance.createJsonFileAndShare();
  }

  Future<void> _showIpInput() async {
    CRLoggerHelper.instance.hideLogger();
    await showDialog(
      context: context,
      builder: (_) => Theme(
        data: CRLoggerHelper.instance.theme,
        child: const ProxyInputDialog(),
      ),
    );
  }

  Future<void> _openActionsAndValuesPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ActionsAndValuesPage()),
    );
  }

  Future<void> _openAppSettings() async {
    await AppSettings.openAppSettings();
  }

  Future<void> _openSearchPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LogSearchPage()),
    );
  }

  Future<void> _openAppInfo() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AppInfoPage()),
    );
  }

  void _onSelected(VoidCallback menuItemCallback) {
    menuItemCallback();
    widget.onCanceled?.call();
  }

  void _onCanceled() {
    widget.onCanceled?.call();
  }

  Future<void> _toggleInspector() async {
    if (context.findAncestorWidgetOfExactType<CrInspector>() == null) {
      CRLoggerHelper.instance.hideLogger();

      return showInfoDialog(
        context: context,
        title: const Text('Warning'),
        content: const Text(
          'There is no CrInspector find in widget tree. '
          'Wrap your page with CrInspector.\n\n'
          'Please, contact developer.',
        ),
      );
    }

    setState(() {
      CRLoggerHelper.instance.inspectorNotifier.value =
          !CRLoggerHelper.instance.inspectorNotifier.value;
    });
  }
}

class _PopupMenuItem extends PopupMenuItem<VoidCallback> {
  _PopupMenuItem({
    Widget? title,
    IconData? icon,
    VoidCallback? onTap,
    super.key,
  }) : super(
          value: onTap,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              icon,
              color: CRLoggerHelper.instance.theme.iconTheme.color,
            ),
            title: title,
            key: key,
          ),
        );
}
