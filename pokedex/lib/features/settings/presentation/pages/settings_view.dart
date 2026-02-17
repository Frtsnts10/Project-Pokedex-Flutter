import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Enable dark theme'),
            value: false,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: Text('Push Notifications'),
            subtitle: Text('Receive updates about wild Pokemon'),
            value: true,
            onChanged: (val) {},
          ),
          ListTile(
            title: Text('Account'),
            subtitle: Text('Manage your profile'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: Text('About'),
            subtitle: Text('Pokedex v1.0.0'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
