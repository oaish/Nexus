import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class ToastHelper {
  static void showToast(
    BuildContext context, {
    required String title,
    required String message,
    shadcn.ToastLocation location = shadcn.ToastLocation.bottomCenter,
  }) {
    shadcn.showToast(
      context: context,
      builder: (BuildContext context, shadcn.ToastOverlay overlay) {
        return shadcn.SurfaceCard(
          child: shadcn.Basic(
            title: Text(title),
            subtitle: Text(message),
            trailing: shadcn.PrimaryButton(
              size: shadcn.ButtonSize.small,
              onPressed: () {
                overlay.close();
              },
              child: const Text('Close'),
            ),
            trailingAlignment: Alignment.center,
          ),
        );
      },
      location: location,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    showToast(
      context,
      title: 'Error',
      message: message,
    );
  }

  static void showSuccessToast(BuildContext context, String message) {
    showToast(
      context,
      title: 'Success',
      message: message,
    );
  }
}
