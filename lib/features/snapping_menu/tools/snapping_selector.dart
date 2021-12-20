import 'package:go_status/features/classification/presentation/classification.dart';
import 'package:go_status/features/comparison/presentation/compare_gun.dart';
import 'package:go_status/features/group_message/presentation/general_chat.dart';
import 'package:go_status/features/groups/presentation/groups.dart';
import 'package:go_status/features/maps/presentation/maps.dart';
import 'package:go_status/features/profile/presentation/profile.dart';
import 'package:go_status/features/settings/presentation/settings.dart';
import 'package:go_status/features/snapping_menu/presentation/widgets/default_screen.dart';
import 'package:go_status/features/timeline/presentation/post_timeline.dart';
import 'package:go_status/features/video/presentation/videos.dart';
import 'package:flutter/material.dart';

class SnappingSelector {
  menuScreens(String? identifier, {var argument}) {
    return getScreen(identifier, args: argument);
  }

  Widget getScreen(String? quickLink, {var args}) {
    switch (quickLink) {
      case "postTimeline":
        return PostTimeline();

      case "classification":
        return Classification();

      case "maps":
        return Maps();

      case "generalChat":
        return GeneralChat();

      case "profile":
        return Profile();

      case "youtubeChannel":
        return Videos(args);

      case "compareGun":
        return CompareGun();

      case "groups":
        return Groups();

      case "settings":
        return Settings();

      default:
        return DefaultScreen();
    }
  }
}
