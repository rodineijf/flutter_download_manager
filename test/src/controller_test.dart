import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_download_manager/src/data_loader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataLoader extends Mock implements DataLoader {}

class FakeCancelToken extends Fake implements DataLoaderCancelToken {}

void main() {
  late FlutterDownloadManagerController controller;
  late MockDataLoader dataLoader;
  late StreamController<FileResponse> downloadStreamController;

  setUp(() {
    downloadStreamController = StreamController.broadcast();
    dataLoader = MockDataLoader();
    registerFallbackValue(FakeCancelToken());
    when(() => dataLoader.download(any(), any(), any()))
        .thenAnswer((i) => downloadStreamController.stream);
    controller =
        FlutterDownloadManagerController('some url', dataLoader: dataLoader);
  });

  test('initial state should be idle', () {
    assert(controller.status == FlutterDownloadManagerStatus.idle);
  });

  test('state should be downloading', () {
    controller.start();
    assert(controller.status == FlutterDownloadManagerStatus.downloading);
  });

  test('state should be cancelled', () {
    controller.cancel();
    assert(controller.status == FlutterDownloadManagerStatus.cancelled);
  });

  test('state should be success', () async {
    controller.start();
    var fileResponse = SuccessFileResponse(XFile(''));
    downloadStreamController.add(fileResponse);
    await Future.delayed(const Duration(seconds: 1));
    assert(controller.status == FlutterDownloadManagerStatus.success);
  });

  test('state should be error', () async {
    controller.start();
    var fileResponse = ErrorFileResponse(XFile(''));
    downloadStreamController.add(fileResponse);
    await Future.delayed(const Duration(seconds: 1));
    assert(controller.status == FlutterDownloadManagerStatus.error);
  });
}
