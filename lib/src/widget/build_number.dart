import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BuildNumber extends StatelessWidget {
  const BuildNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context,
            AsyncSnapshot<PackageInfo> snapshot,) {
          final buildNumber =
          snapshot.hasData ? snapshot.data?.buildNumber : null;

          return Text(
            buildNumber ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
