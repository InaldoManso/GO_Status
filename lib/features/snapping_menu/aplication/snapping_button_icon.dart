import 'package:flutter/material.dart';

class SnappingButtonIcon {
  menuScreens(String? identifier) {
    return setIcon(identifier);
  }

  IconData setIcon(String? quickLink) {
    switch (quickLink) {
      case "postTimeline":
        return Icons.feed_outlined;

      case "classification":
        return Icons.list_alt_outlined;

      case "maps":
        return Icons.map_outlined;

      case "generalChat":
        return Icons.chat_outlined;

      case "profile":
        return Icons.account_circle_outlined;

      case "youtubeChannel":
        return Icons.video_collection_outlined;

      case "compareGun":
        return Icons.compare_outlined;

      case "groups":
        return Icons.group_outlined;

      case "settings":
        return Icons.settings_outlined;

      default:
        return Icons.error_outline;
    }
  }
}
