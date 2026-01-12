import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<ShareResultStatus> shareData(BuildContext context, String text) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final shareInstance = SharePlus.instance;

  final result = await shareInstance.share(
    ShareParams(text: text, sharePositionOrigin: Offset.zero & overlay.size),
  );

  return result.status;
}
