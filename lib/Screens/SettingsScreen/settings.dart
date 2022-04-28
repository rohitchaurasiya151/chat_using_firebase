import 'package:chat_using_firebase/AppTheme/wcTheme.dart';
import 'package:chat_using_firebase/Screens/SettingsScreen/widgets/WidgetProfileIconWithQRCode.dart';
import 'package:chat_using_firebase/Screens/SettingsScreen/widgets/WidgetSettingsListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Settings",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children:  [
          const WidgetProfileIconWithQRCode(),
          const WidgetSettingsListTile(
              settingTitle: "Account",
              settingSubTitle: "Privacy,security,change number",
              settingIIconData: Icons.key,
              iconQuarterTurns: 1),
          const WidgetSettingsListTile(
            settingTitle: "Chats",
            settingSubTitle: "Theme, wallpapers, chat history",
            settingIIconData: Icons.message_rounded,
          ),
          const WidgetSettingsListTile(
            settingTitle: "Notifications",
            settingSubTitle: "Message, group & call tones",
            settingIIconData: Icons.notifications,
          ),
          const WidgetSettingsListTile(
            settingTitle: "Storage and data",
            settingSubTitle: "Network Usage, auto-download",
            settingIIconData: Icons.sd_storage_outlined,
          ),
          const WidgetSettingsListTile(
            settingTitle: "Help",
            settingSubTitle: "Help center, contact us, privacy policy",
            settingIIconData: Icons.help_outline,
          ),
          const WidgetSettingsListTile(
            settingTitle: "Invite a friend",
            settingIIconData: Icons.people,
          ),
          const SizedBox(height: 30,),
          Text(
            "from",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 22,
                color: Colors.black54),
          ),
          Text(
            "Rohit Chaurasiya",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 22,
                color: Colors.black),
          ),

        ],
      ),
    );
  }
}
