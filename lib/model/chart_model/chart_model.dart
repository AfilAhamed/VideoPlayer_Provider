import 'package:hive/hive.dart';
part 'chart_model.g.dart';

@HiveType(typeId: 2)
class VideoStatistics extends HiveObject {
  @HiveField(0)
  late String period; // 'Day', 'Week', 'Month'

  @HiveField(1)
  late int addedCount;

  @HiveField(2)
  late int deletedCount;

  VideoStatistics({
    required this.period,
    required this.addedCount,
    required this.deletedCount,
  });
}
