import 'package:cross_file/cross_file.dart';

import 'package:flutter/material.dart';

import 'data_loader.dart';
import 'status.dart';

class FlutterDownloadManagerController extends ChangeNotifier {
  final DataLoader dataLoader;

  final String url;
  final DownloadOptions? options;

  FlutterDownloadManagerController(
    this.url, {
    this.options,
    this.dataLoader = const DataLoader(),
  });

  int progress = 0;
  FlutterDownloadManagerStatus status = FlutterDownloadManagerStatus.idle;
  dynamic error;
  XFile? file;

  DataLoaderCancelToken? _cancelToken;

  void start() async {
    _emitDownloading();
    _cancelToken = DataLoaderCancelToken();
    dataLoader.download(url, options, _cancelToken!).listen((response) {
      print('response incoming $response');
      if (response is ProgressFileResponse) {
        _emitProgress(response.progress);
      } else if (response is SuccessFileResponse) {
        _emitSuccess(response.file);
      } else if (response is ErrorFileResponse) {
        _emitError(response.error);
      }
    });
  }

  void cancel() {
    _cancelToken?.cancel();
    _emitCancellation();
  }

  _emitDownloading() {
    status = FlutterDownloadManagerStatus.downloading;
    progress = 0;
    error = null;
    notifyListeners();
  }

  _emitProgress(int _progress) {
    progress = _progress;
    notifyListeners();
  }

  _emitSuccess(XFile _file) {
    status = FlutterDownloadManagerStatus.success;
    file = _file;
    notifyListeners();
  }

  _emitError(dynamic _error) {
    status = FlutterDownloadManagerStatus.error;
    error = _error;
    notifyListeners();
  }

  _emitCancellation() {
    status = FlutterDownloadManagerStatus.cancelled;
    progress = 0;
    notifyListeners();
  }
}
