import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});


  static const rose     = Color(0xFFE8A0BF);
  static const lightBg  = Color(0xFFFFF8F9);
  static const ivory    = Color(0xFFFFF8F0);
  static const card     = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.6,
        backgroundColor: card,
        surfaceTintColor: card,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            children: [
            
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFE2EE), Color(0xFFF8CFE1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: rose.withOpacity(.20),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 62,
                  backgroundColor: card,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.jpg',
                      width: 116,
                      height: 116,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

            
              const Text(
                'Dea Pamelia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  letterSpacing: .2,
                ),
              ),

              const SizedBox(height: 6),

              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  _InfoChip(
                    icon: Icons.credit_card_rounded,
                    label: 'NIM 124230149',
                  ),
                  _InfoChip(
                    icon: Icons.alternate_email_rounded,
                    label: 'pamelia17yk@gmail.com',
                  ),
                ],
              ),

              const SizedBox(height: 16),

            
              _ThinCard(
                child: Row(
                  children: const [
                    Icon(Icons.camera_alt_rounded, color: rose),
                    SizedBox(width: 10),
                    Text(
                      '@deaapamell',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 15.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

            
              _ThinCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionTitle('Hobi'),
                    SizedBox(height: 10),
                    _HobbyWrap(items: ['Cooking', 'Singing', 'Hiking']),
                  ],
                ),
              ),

              const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }
}


class _ThinCard extends StatelessWidget {
  const _ThinCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: ProfileView.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ProfileView.rose.withOpacity(.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ProfileView.rose),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
        color: Colors.black87,
      ),
    );
  }
}

class _HobbyWrap extends StatelessWidget {
  const _HobbyWrap({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ProfileView.rose.withOpacity(.22)),
              ),
              child: Text(
                e,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
