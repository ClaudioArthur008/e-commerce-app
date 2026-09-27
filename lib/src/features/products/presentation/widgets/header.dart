import 'package:e_commerce_app/src/features/profile/domain/user_model.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final User user;
  final VoidCallback? onNotificationTap;

  const Header({super.key, required this.user, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
              ? NetworkImage(user.avatarUrl!) as ImageProvider
              : const AssetImage('assets/images/avatar.png'),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ravi de vous revoir,',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              user.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const Spacer(),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: onNotificationTap ?? () {},
          ),
        ),
      ],
    );
  }
}
