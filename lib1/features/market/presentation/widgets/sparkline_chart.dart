import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// Pre-baked gradients for the two chart states — computed once at class-load
// time.  SparklineChart is rebuilt on every 500 ms price tick for every
// visible tile; eliminating the LinearGradient + withValues() allocations
// saves ~6 heap objects per tile per tick.
final _kGainGradient = LinearGradient(
  colors: [
    AppColors.chartLineGain.withValues(alpha: 0.25),
    AppColors.chartLineGain.withValues(alpha: 0.0),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
final _kLossGradient = LinearGradient(
  colors: [
    AppColors.chartLineLoss.withValues(alpha: 0.25),
    AppColors.chartLineLoss.withValues(alpha: 0.0),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// A miniature sparkline chart for use inside list tiles.
///
/// Single-Responsibility: renders one data series with a gradient fill.
/// Interface Segregation: callers pass only what they need (data + isGain)
/// — internal chart config is hidden.
class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.data,
    required this.isGain,
    this.height = 50,
    this.width = 80,
  });

  final List<double> data;
  final bool isGain;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height, width: width);

    final color = isGain ? AppColors.chartLineGain : AppColors.chartLineLoss;
    // Select between two pre-built gradients — no allocation per call.
    final gradient = isGain ? _kGainGradient : _kLossGradient;

    final spots = List<FlSpot>.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i]),
      growable: false,
    );

    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: width,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            clipData: const FlClipData.all(),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: color,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, gradient: gradient),
              ),
            ],
          ),
          // Duration.zero disables fl_chart's internal tween which would run
          // its own animation ticker on every price update.
          duration: Duration.zero,
        ),
      ),
    );
  }
}
