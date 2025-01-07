import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        children: [
          _buildSearchBar(),
          _buildFAQSection(),
          _buildContactSection(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _FAQItem(
          question: 'How do I update my profile?',
          answer:
              'You can update your profile by going to the Profile tab and clicking on the "Edit Profile" button. There you can modify your personal information.',
        ),
        _FAQItem(
          question: 'How do I track my progress?',
          answer:
              'Your progress is automatically tracked based on your workouts and measurements. You can view your progress in the dashboard section.',
        ),
        _FAQItem(
          question: 'Can I change my fitness goal?',
          answer:
              'Yes, you can change your fitness goal at any time through the Edit Profile section.',
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _ContactOption(
          icon: Icons.email,
          title: 'Email Support',
          subtitle: 'support@example.com',
          onTap: () {
            // TODO: Implement email support
          },
        ),
        _ContactOption(
          icon: Icons.chat,
          title: 'Live Chat',
          subtitle: 'Available 24/7',
          onTap: () {
            // TODO: Implement live chat
          },
        ),
        _ContactOption(
          icon: Icons.phone,
          title: 'Phone Support',
          subtitle: '+1 (555) 123-4567',
          onTap: () {
            // TODO: Implement phone support
          },
        ),
      ],
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 243, 33, 44)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
