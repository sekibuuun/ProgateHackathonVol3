import 'package:flutter/material.dart' hide CloseButton;
import 'package:progate03/entity/user.dart';
import 'package:progate03/widget/user_detail.dart';
import 'package:progate03/widget/close_button.dart';

class UserDetailDialog extends StatelessWidget {
  const UserDetailDialog({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Dialog(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CloseButton(),
              UserDetail(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
