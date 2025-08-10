import 'package:flutter/material.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  RangeValues _currentRange = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 11,
        inactiveTrackColor: const Color(0xFFD9D9D9),
        activeTrackColor: const Color(0xFF3F51F3),
        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 8,
        ),
      ),
      child: RangeSlider(
        values: _currentRange,
        min: 0,
        max: 100,
        divisions: 100,
        labels: RangeLabels(
          '\$${_currentRange.start.toInt()}',
          '\$${_currentRange.end.toInt()}',
        ),
        onChanged: (RangeValues newRange) {
          setState(() {
            _currentRange = newRange;
          });
        },
      ),
    );
  }
}
