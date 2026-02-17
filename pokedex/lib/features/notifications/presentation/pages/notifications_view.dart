import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent.withOpacity(0.2),
                child: Icon(Icons.notifications, color: Colors.redAccent),
              ),
              title: Text('Wild Pokemon Appeared!'),
              subtitle: Text('A wild Pikachu was spotted near Pallet Town.'),
              trailing: Text('2m ago', style: TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}
