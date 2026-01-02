import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContactCard(
            context,
            'Mom',
            '+91 98765 43210',
            Icons.favorite,
            Colors.pink,
          ),
          _buildContactCard(
            context,
            'Dad',
            '+91 98765 43211',
            Icons.shield,
            Colors.blue,
          ),
          _buildContactCard(
            context,
            'Best Friend',
            '+91 98765 43212',
            Icons.people,
            Colors.purple,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new contact')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Emergency Contact'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String name,
    String phone,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(name),
        subtitle: Text(phone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calling $name...')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.blue),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Messaging $name...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
