import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme_provider.dart'; // Import your ThemeProvider

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: themeProvider.isDarkMode, // Get the current theme state
            onChanged: (bool value) {
              themeProvider
                  .toggleTheme(); // Call toggleTheme to switch the theme
            },
            secondary: Icon(Icons.color_lens),
          ),
          // You can add more settings options here
        ],
      ),
    );
  }
}
