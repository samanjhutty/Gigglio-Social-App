import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigglio/model/utils/string.dart';
import 'package:gigglio/services/theme_services.dart';
import '../../model/utils/dimens.dart';

class LoadingButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? loaderColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  const LoadingButton({
    super.key,
    this.style,
    this.padding,
    this.margin,
    this.loaderColor,
    required this.isLoading,
    required this.onPressed,
    required this.child,
  }) : assert(style == null || padding == null);

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
      child: ElevatedButton(
        style: style ??
            ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                padding: padding ??
                    const EdgeInsets.symmetric(vertical: Dimens.sizeDefault)),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: loaderColor ?? scheme.onPrimary))
            : child,
      ),
    );
  }
}

class LoadingIcon extends StatelessWidget {
  final IconButtonStyle buttonStyle;
  final Widget icon;
  final bool loading;
  final double? loaderSize;
  final ButtonStyle? style;
  final VoidCallback onPressed;
  const LoadingIcon({
    super.key,
    required this.buttonStyle,
    required this.icon,
    required this.loading,
    required this.onPressed,
    this.loaderSize,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = ThemeServices.of(context);

    switch (buttonStyle) {
      case IconButtonStyle.outlined:
        return IconButton.outlined(
          style: style ??
              IconButton.styleFrom(
                side: BorderSide(color: scheme.textColorLight, width: 2),
                padding: const EdgeInsets.all(Dimens.sizeMedSmall),
                foregroundColor: scheme.textColor,
              ),
          onPressed: onPressed,
          icon: loading
              ? SizedBox.square(
                  dimension: loaderSize ?? 24,
                  child: const CircularProgressIndicator())
              : icon,
        );
      case IconButtonStyle.filled:
        return IconButton.filled(
          style: style ??
              IconButton.styleFrom(
                side: BorderSide(color: scheme.textColorLight, width: 2),
                padding: const EdgeInsets.all(Dimens.sizeMedSmall),
                foregroundColor: scheme.textColor,
              ),
          onPressed: onPressed,
          icon: loading
              ? SizedBox.square(
                  dimension: loaderSize ?? 24,
                  child: const CircularProgressIndicator())
              : icon,
        );
    }
  }
}

enum IconButtonStyle { outlined, filled }

class MyAlertDialog extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onTap;

  const MyAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
    this.onTap,
    this.titleTextStyle,
  }) : assert(
            (actions != null || onTap != null) &&
                !(actions != null && onTap != null),
            'Provide either custom actions or provide onTap');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      titleTextStyle: titleTextStyle,
      content: content,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderRadiusDefault)),
      buttonPadding: const EdgeInsets.only(right: Dimens.sizeDefault),
      actions: actions ??
          [
            TextButton(
                onPressed: Get.back, child: const Text(StringRes.cancel)),
            TextButton(onPressed: onTap, child: const Text(StringRes.submit)),
          ],
    );
  }
}

class MyDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final double? margin;
  const MyDivider({super.key, this.width, this.thickness, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
        width: width,
        child: Divider(
          color: Colors.grey[300],
          thickness: thickness,
        ));
  }
}
