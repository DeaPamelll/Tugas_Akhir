import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'widgets/header_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return FutureBuilder<Map<String, String?>>(
      future: () async {
        final name = await auth.currentName();
        final email = await auth.currentEmail();
        return {'name': name, 'email': email};
      }(),
      builder: (context, snap) {
        final name = snap.data?['name'] ?? '-';
        final email = snap.data?['email'] ?? '-';
        return Scaffold(
          appBar: const HeaderWidget(title: 'Profil Saya'),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: $name', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Email: $email', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }
}
