import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SnsAccount {
  final Uri uri;
  final IconData icon;

  const SnsAccount({
    required this.uri,
    required this.icon,
  });

  factory SnsAccount.github(String url) {
    return SnsAccount(
      uri: Uri.parse(url),
      icon: FontAwesomeIcons.github,
    );
  }

  factory SnsAccount.x(String url) {
    return SnsAccount(
      uri: Uri.parse(url),
      icon: FontAwesomeIcons.xTwitter,
    );
  }
}
