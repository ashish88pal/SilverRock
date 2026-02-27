import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';

// Displays a formatted price and flashes green/red when the value changes.
// Set animate: false for tiles that update at high frequency to avoid
// per-frame raster uploads.
class AnimatedPriceText extends StatefulWidget {
  const AnimatedPriceText({
    super.key,
    required this.price,
    this.previousPrice,
    required this.style,
    this.animate = true,
  });

  final double price;
  final double? previousPrice;
  final TextStyle style;
  final bool animate;

  @override
  State<AnimatedPriceText> createState() => _AnimatedPriceTextState();
}

class _AnimatedPriceTextState extends State<AnimatedPriceText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Color?> _colorAnim;

  // Neutral animation reused when no flash is needed — avoids allocating a
  // new ColorTween every tick.
  static final _neutral = ColorTween(
    begin: AppColors.textPrimary,
    end: AppColors.textPrimary,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: AppConstants.priceAnimationMs),
      vsync: this,
    );
    _colorAnim = _neutral.animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedPriceText old) {
    super.didUpdateWidget(old);

    if (!widget.animate) return;
    if (widget.price == old.price) return;
    if (widget.previousPrice == null) return;

    final isUp = widget.price >= widget.previousPrice!;
    final flash = isUp ? AppColors.gainColor : AppColors.lossColor;
    final base = widget.style.color ?? AppColors.textPrimary;

    _colorAnim = ColorTween(
      begin: flash,
      end: base,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return Text(
        PriceFormatter.formatPrice(widget.price),
        style: widget.style,
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _colorAnim,
        builder: (_, _) => Text(
          PriceFormatter.formatPrice(widget.price),
          style: widget.style.copyWith(color: _colorAnim.value),
        ),
      ),
    );
  }
}
