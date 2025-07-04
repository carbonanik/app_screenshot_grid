import 'package:app_screenshot_grid/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class SectionCard extends StatefulWidget {
  final String title;
  final Color accent;
  final List<Widget> children;
  final bool initiallyExpanded;
  final IconData? icon;
  final VoidCallback? onToggle;

  const SectionCard({
    required this.title,
    required this.accent,
    required this.children,
    this.initiallyExpanded = true,
    this.icon,
    this.onToggle,
    super.key,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(SectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // elevation: 0,
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      // color: Colors.white,
      // shape: RoundedRectangleBorder(
      // borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
      // ),
      decoration: AppTheme.sidePanelDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(
                AppConstants.largeBorderRadius,
              ),
              onTap: () {
                if (widget.onToggle != null) {
                  widget.onToggle!();
                } else {
                  setState(() => _expanded = !_expanded);
                }
              },
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.accent, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.0 : 0.5,
                    duration: AppConstants.expandAnimationDuration,
                    child: Icon(Icons.expand_more, color: widget.accent),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.children,
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: AppConstants.expandAnimationDuration,
            ),
          ],
        ),
      ),
    );
  }
}
