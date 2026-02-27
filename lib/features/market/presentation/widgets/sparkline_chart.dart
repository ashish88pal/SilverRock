import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_demo_app/features/market/presentation/bloc/market_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/market_state.dart';

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
    required this.height,
    required this.width,
  });

  final List<double> data;
  final bool isGain;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height, width: width);

    final color = isGain ? AppColors.chartLineGain : AppColors.chartLineLoss;
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
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(
              show: true,
              // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineTouchData: const LineTouchData(enabled: true),
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
          // Disable fl_chart's internal animation — the chart updates at 2 Hz
          // and animating between frames would cause unnecessary repaints.
          duration: Duration.zero,
        ),
      ),
    );
  }
}

class SparklineDialogContent extends StatelessWidget {
  final String assetId;
  const SparklineDialogContent({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        if (state is MarketLoaded) {
          final asset = state.filteredAssets.firstWhere((a) => a.id == assetId);

          return SparklineChart(
            data: asset.sparklineData,
            isGain: asset.isGain,
            height: MediaQuery.sizeOf(context).height * 0.4,
            width: MediaQuery.sizeOf(context).width * 0.8,
          );
        }

        return const SizedBox();
      },
    );
  }
}
