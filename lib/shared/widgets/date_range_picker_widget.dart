import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/theme/theme.dart';
import 'package:intl/intl.dart';

class DateRangePickerWidget extends ConsumerWidget {
  const DateRangePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(Icons.date_range, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${dateFormat.format(dateRange.start)} - ${dateFormat.format(dateRange.end)}',
                      style: AppTextStyles.labelLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final now = DateTime.now();
                final clampedRange = dateRange.end.isAfter(now)
                    ? DateTimeRange(start: dateRange.start, end: now)
                    : dateRange;
                final newRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: now,
                  initialDateRange: clampedRange,
                );
                if (newRange != null) {
                  ref.read(dateRangeProvider.notifier).setRange(newRange);
                }
              },
              child: Text('Change Date'),
            ),
          ],
        ),
      ),
    );
  }
}
