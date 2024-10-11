import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart'; // Import your ThemeProvider

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Define a custom theme for the Settings screen
    final customTheme = ThemeData(
      primaryColor: Color(0xFF7ed957), // Custom green for buttons, icons
      scaffoldBackgroundColor: Color(0xFFccffb6), // Background color
      appBarTheme: AppBarTheme(
        color: Color(0xFF7ed957), // Green app bar
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF7ed957), // Green button color
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // Text color
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF7ed957), // Green icons
      ),
    );

    return Theme(
      data: customTheme, // Apply the custom theme
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
                // Handle navigation to edit profile
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                // Handle navigation to change password
              },
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Theme'),
              trailing: Switch(
                value: themeProvider.isDarkMode, // Current theme state
                onChanged: (value) {
                  themeProvider.toggleTheme(); // Toggle the theme
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification Settings'),
              onTap: () {
                // Handle navigation to notification settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
