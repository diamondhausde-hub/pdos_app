import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.helpSupport),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Contact Us ──
            _SectionHeader(title: AppStrings.contactUs, icon: Icons.headset_mic_rounded),
            const SizedBox(height: 16),
            _ContactCard(
              icon: Icons.email_rounded,
              label: AppStrings.emailSupport,
              value: 'support@pdos.com',
              onTap: () => _launch('mailto:support@pdos.com'),
            ),
            const SizedBox(height: 12),
            _ContactCard(
              icon: Icons.phone_rounded,
              label: AppStrings.phoneSupport,
              value: '+20 100 123 4567',
              onTap: () => _launch('tel:+201001234567'),
            ),
            const SizedBox(height: 12),
            _ContactCard(
              icon: Icons.chat_rounded,
              label: AppStrings.whatsapp,
              value: '+20 100 123 4567',
              onTap: () => _launch('https://wa.me/201001234567'),
            ),
            const SizedBox(height: 32),

            // ── FAQ ──
            _SectionHeader(title: AppStrings.frequentlyAskedQuestions, icon: Icons.help_outline_rounded),
            const SizedBox(height: 16),
            _FaqTile(
              question: 'How do I sync my data?',
              answer: 'Pull down on any screen to manually sync, or enable auto-sync in Settings. A green checkmark confirms your data is up to date.',
            ),
            _FaqTile(
              question: 'My location is not updating?',
              answer: 'Ensure GPS is enabled and PDOS has location permission. Go to Settings > Apps > PDOS > Permissions and allow location access.',
            ),
            _FaqTile(
              question: 'How do I reset my password?',
              answer: 'Go to your Profile > Edit, then enter your current password and a new password meeting the requirements (8+ chars, uppercase, number).',
            ),
            _FaqTile(
              question: 'Who can see my profile?',
              answer: 'Your brand, role, and achievements are visible to everyone in the system. Financial data (sales, expenses) remain private.',
            ),
            const SizedBox(height: 32),

            // ── Quick Links ──
            _SectionHeader(title: AppStrings.quickHelp, icon: Icons.link_rounded),
            const SizedBox(height: 16),
            _LinkTile(
              icon: Icons.info_outline_rounded,
              label: AppStrings.aboutPdos,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _AboutMiniScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

// ── Section Header ──

class _SectionHeader extends StatelessWidget {
  final String title; final IconData icon;
  const _SectionHeader({required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      const SizedBox(width: 12),
      Text(title, style: AppTextStyles.headlineSm.copyWith(
        color: AppColors.onSurface, fontWeight: FontWeight.w700)),
    ]);
  }
}

// ── Contact Card ──

class _ContactCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final VoidCallback onTap;
  const _ContactCard({required this.icon, required this.label, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
              ],
            )),
            Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.onSurfaceVariant),
          ]),
        ),
      ),
    );
  }
}

// ── FAQ Tile ──

class _FaqTile extends StatefulWidget {
  final String question; final String answer;
  const _FaqTile({required this.question, required this.answer});
  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(widget.question, style: AppTextStyles.bodyMd.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.onSurface))),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: AppColors.onSurfaceVariant),
                ]),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  Text(widget.answer, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Link Tile ──

class _LinkTile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _LinkTile({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.onSurface))),
            Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
          ]),
        ),
      ),
    );
  }
}

// ── Mini About Screen (inline) ──

class _AboutMiniScreen extends StatelessWidget {
  const _AboutMiniScreen();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.about),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.glowShadow,
                ),
                child: Icon(Icons.local_pharmacy_rounded, color: AppColors.onPrimary, size: 52),
              ),
              const SizedBox(height: 24),
              Text(AppStrings.pdos, style: AppTextStyles.displayLg.copyWith(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(AppStrings.version100, style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 32),
              Text(AppStrings.pharmaceuticalDistributionOperatingSystem,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 24),
              Text(AppStrings.u00a92026PdosAll,
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
