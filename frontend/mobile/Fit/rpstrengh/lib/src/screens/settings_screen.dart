import 'package:flutter/material.dart';
import '../services/secure_storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: () {
              // TODO: Implement notifications settings
            },
          ),
          _SettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // TODO: Implement language settings
            },
          ),
          const _SectionHeader(title: 'Privacy'),
          _SettingsTile(
            icon: Icons.security,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
          _SettingsTile(
            icon: Icons.description,
            title: 'Terms of Service',
            onTap: () {
              // TODO: Show terms of service
            },
          ),
          const _SectionHeader(title: 'Account Actions'),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            textColor: Colors.red,
            onTap: () async {
              await SecureStorage.deleteToken();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
