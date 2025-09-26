import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/core/theme/AppColors.dart';
import 'package:astro/generated/assets.dart';
import 'package:flutter/material.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isCloseable;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.isCloseable = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isCloseable,
      child: Dialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: getMediumStyle(
                          color: AppColors.textColor,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(Assets.assets404),
                      const SizedBox(height: 20),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: getRegularStyle(color: AppColors.textColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (isCloseable)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: onCancel ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, color: AppColors.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              "Not Now",
                              style: getMediumStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onConfirm,
                      child: Container(
                        width: 120,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: AppColors.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              "Yes",
                              style: getMediumStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else
                InkWell(
                  onTap: onConfirm,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Dismiss",
                        style: getMediumStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
