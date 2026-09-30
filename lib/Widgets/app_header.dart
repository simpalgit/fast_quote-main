import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Common top header used across all screens: hamburger menu, FastQuote
/// logo + tagline, notification bell with badge, and profile avatar.
class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  final int notificationCount;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    this.notificationCount = 5,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(66);
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: AppColors.cardWhite,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: widget.onMenuTap,
              child: const Icon(Icons.menu, color: AppColors.textDark, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Fast',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: 'Quote',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('Quote Faster. Close Faster.', style: AppText.small),
                ],
              ),
            ),
            InkWell(
              onTap: widget.onNotificationTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded,
                      color: AppColors.textDark, size: 26),
                  if (widget.notificationCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${widget.notificationCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            InkWell(
              onTap: widget.onProfileTap,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.blueBg,
                child: Icon(Icons.person, color: AppColors.primaryBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
