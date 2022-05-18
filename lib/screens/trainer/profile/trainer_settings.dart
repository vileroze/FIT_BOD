import 'package:fitness_app/screens/client/settings/profile_setting.dart';
import 'package:flutter/material.dart';

class TrainerSettings extends StatefulWidget {
  const TrainerSettings({Key? key}) : super(key: key);

  @override
  State<TrainerSettings> createState() => _TrainerSettingsState();
}

class _TrainerSettingsState extends State<TrainerSettings> {
  @override
  Widget build(BuildContext context) {
    return ProfileSettings();
  }
}
