import 'package:e_commerce_app/src/features/profile/application/user_provider.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/category_chip.dart'
    show kPrimaryOrange;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // ─── Titre de page ───
            const Text(
              'Mon profil',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F1F1F),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gérez vos informations personnelles',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),

            // ─── Carte identité ───
            _ProfileHeaderCard(
              name: user.name,
              email: user.email,
              avatarUrl: user.avatarUrl,
            ),

            const SizedBox(height: 24),

            // ─── Stats rapides ───
            const _QuickStatsRow(),

            const SizedBox(height: 24),

            // ─── Informations personnelles ───
            const _SectionTitle(title: 'Informations personnelles'),
            const SizedBox(height: 10),
            Container(
              decoration: _cardDecoration,
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Nom complet',
                    value: user.name,
                  ),
                  _divider,
                  _InfoTile(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email',
                    value: user.email,
                  ),
                  _divider,
                  const _InfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Téléphone',
                    value: '+33 6 12 34 56 78',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Paramètres ───
            const _SectionTitle(title: 'Paramètres'),
            const SizedBox(height: 10),
            Container(
              decoration: _cardDecoration,
              child: Column(
                children: [
                  _ActionTile(
                    icon: Icons.location_on_outlined,
                    label: 'Adresses de livraison',
                    onTap: () {},
                  ),
                  _divider,
                  _ActionTile(
                    icon: Icons.credit_card_rounded,
                    label: 'Moyens de paiement',
                    onTap: () {},
                  ),
                  _divider,
                  _ActionTile(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  _divider,
                  _ActionTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Sécurité',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Déconnexion ───
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: logique de déconnexion
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade200, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.5,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Styles partagés
// ─────────────────────────────────────────────
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: Colors.grey.shade200, width: 1),
);

Widget get _divider =>
    Divider(height: 1, thickness: 1, color: Colors.grey.shade100);

class _ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;

  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryOrange.withValues(alpha: 0.12),
              border: Border.all(
                color: kPrimaryOrange.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, a, b) => _avatarInitials(),
                  )
                : _avatarInitials(),
          ),
          const SizedBox(width: 16),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Client fidèle',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Édition
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarInitials() {
    final initials = name.trim().isEmpty
        ? '?'
        : name
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((p) => p[0].toUpperCase())
              .join();
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: kPrimaryOrange,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats rapides
// ─────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            icon: Icons.shopping_bag_outlined,
            label: 'Commandes',
            value: '12',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.favorite_border_rounded,
            label: 'Favoris',
            value: '8',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_shipping_outlined,
            label: 'Livraisons',
            value: '5',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: _cardDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryOrange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: kPrimaryOrange),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Titre de section
// ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: kPrimaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Ligne d'information (label + valeur)
// ─────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryOrange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: kPrimaryOrange),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Ligne cliquable (paramètres)
// ─────────────────────────────────────────────
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kPrimaryOrange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: kPrimaryOrange),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
