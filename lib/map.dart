import 'package:stats/stats.dart';

centerPoint(lat,long) {
  final latStats = Stats.fromData(lat);
  final longStats = Stats.fromData(long);
  return [latStats,longStats];
}

