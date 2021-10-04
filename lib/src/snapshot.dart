import 'package:cross_file/cross_file.dart';

import 'status.dart';

class FlutterDownloadManagerSnapshot {
  final FlutterDownloadManagerStatus status;
  final int progress;
  final dynamic error;
  final XFile? file;

  FlutterDownloadManagerSnapshot({
    required this.status,
    required this.progress,
    this.error,
    this.file,
  });
}
