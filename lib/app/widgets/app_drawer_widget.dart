import 'package:flutter/material.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[900], // Background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text('Role Management', style: TextStyle(fontSize: 18)), // Traduzido
              accountEmail: const Text('Select or manage your roles', style: TextStyle(fontSize: 14)), // Traduzido e ajustei o tamanho da fonte para melhor visualização
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'D&D',
                  style: TextStyle(fontSize: 24.0, color: Colors.blueGrey[900]),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.switch_account, color: Colors.white),
              title: const Text('Switch Role', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/switch_character');
              },
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to settings
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/setting');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to about
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}