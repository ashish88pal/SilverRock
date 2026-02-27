import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/constants/app_constants.dart';

class AnimatedPriceText extends StatefulWidget {
  final double price;
  final double? previousPrice;
  final TextStyle style;
  // Set to false for tiles that are already inside a RepaintBoundary and
  // update at high frequency — avoids per-frame raster uploads.
  final bool animate;

  const AnimatedPriceText({
    super.key,
    required this.price,
    this.previousPrice,
    required this.style,
    this.animate = true,
  });

  @override
  State<AnimatedPriceText> createState() => AnimatedPriceTextState();
}

class AnimatedPriceTextState extends State<AnimatedPriceText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  // Pre-baked "neutral" animation — avoids allocating a new ColorTween when
  // animate:false or when the price genuinely hasn't changed.
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
    _colorAnimation = _neutral.animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedPriceText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Fast-path: animation disabled or price unchanged → nothing to do.
    if (!widget.animate) return;
    if (widget.price == oldWidget.price) return;
    if (widget.previousPrice == null) return;

    final isUp = widget.price >= widget.previousPrice!;
    final flashColor = isUp ? AppColors.gainColor : AppColors.lossColor;
    final baseColor = widget.style.color ?? AppColors.textPrimary;

    _colorAnimation = ColorTween(
      begin: flashColor,
      end: baseColor,
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
      // No animation — plain Text, zero animator overhead.
      return Text(
        PriceFormatter.formatPrice(widget.price),
        style: widget.style,
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (_, _) => Text(
          PriceFormatter.formatPrice(widget.price),
          style: widget.style.copyWith(color: _colorAnimation.value),
        ),
      ),
    );
  }
}
