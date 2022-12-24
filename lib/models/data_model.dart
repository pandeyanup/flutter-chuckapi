import 'package:hive/hive.dart';

part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  final String joke;
  @HiveField(1)
  final bool isExpanded;

  DataModel({required this.joke, required this.isExpanded});
}
