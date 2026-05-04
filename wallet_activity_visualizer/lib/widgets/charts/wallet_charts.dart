import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/wallet_info.dart';
import '../../theme.dart';

class TxFrequencyChart extends StatelessWidget {
  final WalletInfo wallet;

  const TxFrequencyChart({super.key, required this.wallet});

  List<FlSpot> _buildSpots() {
    final freq = wallet.txFrequencyByDay;
    if (freq.isEmpty) return [const FlSpot(0, 0)];

    final sorted = freq.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sorted
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = _buildSpots();
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TX FREQUENCY',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppTheme.border,
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.accent,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.accent.withOpacity(0.08),
                    ),
                  ),
                ],
                minY: 0,
                maxY: maxY + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TokenDistributionChart extends StatefulWidget {
  final WalletInfo wallet;

  const TokenDistributionChart({super.key, required this.wallet});

  @override
  State<TokenDistributionChart> createState() => _TokenDistributionChartState();
}

class _TokenDistributionChartState extends State<TokenDistributionChart> {
  int _touched = -1;

  static const _colors = [
    AppTheme.accent,
    AppTheme.accentBlue,
    AppTheme.accentPurple,
    AppTheme.accentGold,
    AppTheme.accentRed,
    Color(0xFF5DCAA5),
    Color(0xFF627EEA),
  ];

  @override
  Widget build(BuildContext context) {
    final dist = widget.wallet.tokenDistribution;
    if (dist.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Center(
          child: Text(
            'No token data',
            style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 12),
          ),
        ),
      );
    }

    final entries = dist.entries.take(7).toList();
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOKEN DISTRIBUTION',
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (_, response) {
                          setState(() {
                            _touched = response?.touchedSection?.touchedSectionIndex ?? -1;
                          });
                        },
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: entries.asMap().entries.map((e) {
                        final isTouched = e.key == _touched;
                        return PieChartSectionData(
                          color: _colors[e.key % _colors.length],
                          value: e.value.value,
                          title: isTouched
                              ? '${(e.value.value / total * 100).toStringAsFixed(1)}%'
                              : '',
                          radius: isTouched ? 55 : 48,
                          titleStyle: GoogleFonts.jetBrainsMono(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _colors[e.key % _colors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            e.value.key,
                            style: GoogleFonts.jetBrainsMono(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
