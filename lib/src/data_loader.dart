import 'dart:async';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dio_http/dio_http.dart';

abstract class FileResponse {}

class ProgressFileResponse implements FileResponse {
  final int progress;

  ProgressFileResponse(this.progress);
}

class SuccessFileResponse implements FileResponse {
  final XFile file;

  SuccessFileResponse(this.file);
}

class ErrorFileResponse implements FileResponse {
  final dynamic error;

  ErrorFileResponse(this.error);
}

class DownloadOptions {
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;

  /// Timeout in seconds for downloading url.
  final int? connectTimeOut;

  DownloadOptions({
    this.headers,
    this.queryParameters,
    this.connectTimeOut,
  });
}

class DataLoaderCancelToken {
  final CancelToken token = CancelToken();

  void cancel() {
    token.cancel();
  }
}

class DataLoader {
  const DataLoader();

  Stream<FileResponse> download(String url, DownloadOptions? options,
      DataLoaderCancelToken cancelToken) async* {
    StreamController<FileResponse> streamController = StreamController();

    final dioOptions = BaseOptions(
      connectTimeout: options?.connectTimeOut ?? 0 * 1000,
      headers: options?.headers,
    );

    Dio(dioOptions).get<Uint8List>(
      url,
      cancelToken: cancelToken.token,
      queryParameters: options?.queryParameters,
      options: Options(responseType: ResponseType.bytes),
      onReceiveProgress: (int received, int total) {
        var progress = (received * 100) ~/ total;
        streamController.add(ProgressFileResponse(progress));
      },
    ).then((response) {
      if (response.data != null) {
        final eTag = response.headers.value('etag');
        streamController
            .add(SuccessFileResponse(XFile.fromData(response.data!)));
      } else {
        streamController.add(ErrorFileResponse(null));
      }
    }).catchError((e) {
      streamController.add(ErrorFileResponse(e));
    }).whenComplete(() {
      streamController.close();
    });

    yield* streamController.stream;
  }
}
