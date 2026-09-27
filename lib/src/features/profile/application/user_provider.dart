import 'package:e_commerce_app/src/features/profile/domain/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider<User>((ref) {
  return User(
    id: '1',
    name: 'Claudio Arthur',
    password: 'password123',
    email: 'claudio.arthur@example.com',
    avatarUrl: null,
  );
});
