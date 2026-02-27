import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// Pre-built gradients — created once at startup. SparklineChart rebuilds on
// every 500 ms tick for each visible tile; avoiding new LinearGradient objects
// in build() eliminates ~6 heap allocations per tile per tick.
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

// Miniature sparkline used inside list tiles and the watchlist.
// Callers only need to pass the raw data and whether the asset is up or down.
class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.data,
    required this.isGain,
    this.height = 50,
    this.width  = 80,
  });

  final List<double> data;
  final bool isGain;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height, width: width);

    final color    = isGain ? AppColors.chartLineGain : AppColors.chartLineLoss;
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
            gridData:      const FlGridData(show: false),
            titlesData:    const FlTitlesData(show: false),
            borderData:    FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            clipData:      const FlClipData.all(),
            lineBarsData: [
              LineChartBarData(
                spots:              spots,
                isCurved:           true,
                curveSmoothness:    0.35,
                color:              color,
                barWidth:           2,
                isStrokeCapRound:   true,
                dotData:            const FlDotData(show: false),
                belowBarData:       BarAreaData(show: true, gradient: gradient),
              ),
            ],
          ),
          // Disable fl_chart's internal animation — the chart updates at 2 Hz
          // and animating between frames would cause unnecessary repaints.
          duration: Duration.zero,
        ),
      ),
    );
  }
}
