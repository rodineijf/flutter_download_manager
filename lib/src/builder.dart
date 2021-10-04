import 'package:flutter/material.dart';
import 'package:flutter_download_manager/src/controller.dart';

import 'snapshot.dart';

typedef FlutterDownloadManagerWidgetBuilder = Widget Function(
  BuildContext context,
  FlutterDownloadManagerSnapshot snapshot,
  Widget? child,
);

class FlutterDownloadManagerBuilder extends StatefulWidget {
  final FlutterDownloadManagerController controller;
  final FlutterDownloadManagerWidgetBuilder builder;
  final Widget? child;
  final bool autoStart;

  const FlutterDownloadManagerBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.child,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<FlutterDownloadManagerBuilder> createState() =>
      _FlutterDownloadManagerBuilderState();
}

class _FlutterDownloadManagerBuilderState
    extends State<FlutterDownloadManagerBuilder> {
  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      widget.controller.start();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.removeListener(_update);
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = FlutterDownloadManagerSnapshot(
      error: widget.controller.error,
      progress: widget.controller.progress,
      status: widget.controller.status,
      file: widget.controller.file,
    );
    return widget.builder(context, snapshot, widget.child);
  }
}
