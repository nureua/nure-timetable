// NureTimetable is an app for viewing schedule for groups or teachers of Kharkiv National University of Radio Electronics.
// Copyright (C) 2023  music-soul1-1

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/models/update_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class CustomAboutDialog extends StatelessWidget {
  final PackageInfo packageInfo;

  const CustomAboutDialog({
    super.key,
    required this.packageInfo
  });

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: packageInfo.appName,
      applicationVersion: '${packageInfo.version}. Version code: ${packageInfo.buildNumber}',
      applicationIcon: const Icon(Icons.info_outline),
      applicationLegalese: "© 2023 music-soul1-1",
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              const Text(
                "NureTimetable is an app for viewing schedule for groups or teachers of \n"
                "Kharkiv National University of Radio Electronics.\n"
                "Copyright (C) 2023  music-soul1-1\n\n"

                "This program is free software: you can redistribute it and/or modify\n"
                "it under the terms of the GNU General Public License as published by\n"
                "the Free Software Foundation, either version 3 of the License, or\n"
                "(at your option) any later version.\n\n"

                "This program is distributed in the hope that it will be useful,\n"
                "but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
                "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
                "GNU General Public License for more details.\n\n"

                "You should have received a copy of the GNU General Public License\n"
                "along with this program.  If not, see <https://www.gnu.org/licenses/>.\n",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Source code: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _launchUrl('https://github.com/music-soul1-1/nure-timetable');
                    },
                    child: const Text("GitHub"),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "License: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _launchUrl('https://github.com/music-soul1-1/nure-timetable/blob/main/LICENSE');
                    },
                    child: const Text("MIT")
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "API: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: const Text("Mindenit team"),
                    onPressed: () => _launchUrl('https://github.com/mindenit'),
                  ),
                  TextButton(
                    child: const Text("GitHub"),
                    onPressed: () => _launchUrl('https://github.com/mindenit/nure-api'),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}


Future<dynamic> showRemoveSettingsDialog(BuildContext context) {
  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Ви дійсно хочете скинути налаштування?"),
        actions: [
          TextButton(
            onPressed: () {
              removeSettings(removeSchedule: true);
              Navigator.of(context).pop();
            },
            child: const Text("Так"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ні"),
          ),
        ],
      );
    }
  );
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}


Future<dynamic> showUpdateDialog(BuildContext context, PackageInfo packageInfo, UpdateInfo updateInfo) {
  bool needsUpdate = compareVersions("v.${packageInfo.version}", updateInfo.version);
  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return needsUpdate ? 
      AlertDialog(
        title: const Text("Доступна нова версія"),
        content: Text("Ваша версія: v.${packageInfo.version}\n"
          "Остання версія: ${updateInfo.version}\n\n"
          "Завантажити оновлення?",
        ),
        actions: [
          TextButton(
            child: const Text("Так"),
            onPressed: () {
              _launchUrl(Platform.isAndroid
                      ? updateInfo.apkDownloadUrl
                      : (Platform.isWindows
                          ? updateInfo.zipDownloadUrl
                          : updateInfo.url));
            }
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ні"),
          ),
        ],
      ) : 
      AlertDialog(
        title: const Text("Ви використовуєте останню версію"),
        content: Text("Ваша версія: v.${packageInfo.version}\n"),
        actions: [
          TextButton(
            onPressed: () => _launchUrl(updateInfo.url),
            child: const Text("Перейти на GitHub")
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Закрити"),
          ),
        ],
      );
    }
  );
}