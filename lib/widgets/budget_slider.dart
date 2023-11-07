import 'package:cooptourism/providers/market_page_provider.dart';
import 'package:cooptourism/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetSlider extends ConsumerStatefulWidget {
  const BudgetSlider({
    super.key,
  });

  @override
  ConsumerState<BudgetSlider> createState() => _BudgetSliderState();
}

num currentStart = 10000.0;
num currentEnd = 20000.0;

class _BudgetSliderState extends ConsumerState<BudgetSlider> {

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        valueIndicatorTextStyle: const TextStyle(
          fontSize: 12, // Adjust the font size here
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          DisplayText(
            text: "What's your budget?",
            lines: 1,
            style: Theme.of(context).textTheme.headlineMedium!,
          ),
          RangeSlider(
            values: RangeValues(currentStart as double, currentEnd as double),
            min: 0.0, // Minimum value of the slider
            max: 30000.0, // Maximum value of the slider
            divisions: 100, // The number of divisions in the slider (optional)
            labels: RangeLabels(
              '₱${currentStart.toStringAsFixed(0)}',
              '₱${currentEnd.toStringAsFixed(0)}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                currentStart = values.start;
                currentEnd = values.end;
              });
              ref.watch(marketCurrentStartProvider.notifier).setCurrentStart(values.start);
              ref.watch(marketCurrentEndProvider.notifier).setCurrentEnd(values.end);
            },
          )
        ],
      ),
    );
  }
}
