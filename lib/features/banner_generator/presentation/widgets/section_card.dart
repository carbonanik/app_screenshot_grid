import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class SectionCard extends StatefulWidget {
  final String title;
  final Color accent;
  final List<Widget> children;
  final bool initiallyExpanded;

  const SectionCard({
    required this.title,
    required this.accent,
    required this.children,
    this.initiallyExpanded = true,
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppConstants.extraLargeBorderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(
                AppConstants.largeBorderRadius,
              ),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                padding: const EdgeInsets.only(top: 10),
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
