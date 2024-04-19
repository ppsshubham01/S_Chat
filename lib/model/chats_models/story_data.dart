import 'package:flutter/material.dart';

@immutable //meaning that Your can't updated that
class StoryData {
  final String name;
  final String url;

  const StoryData({
    required this.name,
    required this.url,
  });
}
