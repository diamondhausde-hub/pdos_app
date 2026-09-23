import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../../features/rep/screens/visit_detail_screen.dart';

class MentionHandler {
  static final mentionRegex = RegExp(r'#(VST|APT)-\d+');

  /// Parses text into InlineSpans. Mentions become clickable links.
  static List<InlineSpan> buildSpans(
    BuildContext context, 
    String text, 
    WidgetRef ref, 
    {TextStyle? defaultStyle, TextStyle? linkStyle}
  ) {
    if (text.isEmpty) return [TextSpan(text: text, style: defaultStyle)];

    final spans = <InlineSpan>[];
    int currentPosition = 0;

    for (final match in mentionRegex.allMatches(text)) {
      if (match.start > currentPosition) {
        spans.add(TextSpan(text: text.substring(currentPosition, match.start), style: defaultStyle));
      }

      final mentionText = match.group(0)!;
      final type = match.group(1)!;

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: InkWell(
            onTap: () => _handleMentionTap(context, ref, mentionText, type),
            child: Text(
              mentionText,
              style: linkStyle ?? const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ),
      );
      currentPosition = match.end;
    }

    if (currentPosition < text.length) {
      spans.add(TextSpan(text: text.substring(currentPosition), style: defaultStyle));
    }

    return spans;
  }

  static Future<void> _handleMentionTap(BuildContext context, WidgetRef ref, String mention, String type) async {
    try {
      if (type == 'VST') {
        final visitRepo = ref.read(visitRepositoryProvider);
        // Find visit by reference code locally
        final allVisits = await visitRepo.getAllVisits();
        final visit = allVisits.firstWhere((v) => v.referenceCode == mention.substring(1), orElse: () => throw Exception('Not found'));
        
        if (context.mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => VisitDetailScreen(visitId: visit.id)));
        }
      } else if (type == 'APT') {
        final apptRepo = ref.read(appointmentRepositoryProvider);
        final stream = apptRepo.watchAppointments();
        final allAppts = await stream.first;
        final appt = allAppts.firstWhere((a) => a.referenceCode == mention.substring(1), orElse: () => throw Exception('Not found'));
        
        if (context.mounted) {
          // You might not have an AppointmentDetailScreen, replace with a dialog or appropriate action
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Found Appointment: ${appt.apptDate}')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unavailable Offline: $mention not found locally.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
