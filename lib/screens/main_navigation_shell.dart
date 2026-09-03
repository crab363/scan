import 'package:flutter/material.dart';
import '../services/app_state_service.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/audio_equalizer_hud.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'scan_simulation_screen.dart';
import 'technician_mode_screen.dart';
import 'case_files_screen.dart';
import 'visual_art_mode_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  @override

  void initState() {
    super.initState();
    SoundService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateService();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final currentIndex = appState.currentNavigationIndex;

        // If Visual Mode (Index 5) is selected, present fullscreen stage view
        if (currentIndex == 5) {
          return VisualArtModeScreen(
            onExit: () {
              appState.setNavigationIndex(0);
            },
          );
        }

        final size = MediaQuery.of(context).size;
        final isDesktop = size.width > 850;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // Desktop Cyberpunk Glass Side Navigation
              if (isDesktop) _buildSideNav(currentIndex, appState),

              // Main Active Screen
              Expanded(
                child: IndexedStack(
                  index: currentIndex,
                  children: [
                    HomeScreen(
                      onEnterScanverse: () => appState.setNavigationIndex(1),
                    ),
                    ExploreScreen(
                      onNavigateToScan: () => appState.setNavigationIndex(2),
                    ),
                    ScanSimulationScreen(
                      onEnterVisualMode: () => appState.setNavigationIndex(5),
                    ),
                    const CaseFilesScreen(),
                    const TechnicianModeScreen(),
                  ],
                ),
              ),
            ],
          ),

          // Mobile Modern Glass Bottom Navigation Bar
          bottomNavigationBar: isDesktop ? null : _buildMobileBottomNav(currentIndex, appState),
        );
      },
    );
  }

  Widget _buildSideNav(int currentIndex, AppStateService appState) {
    final navItems = [
      {'index': 0, 'label': 'HOME', 'icon': Icons.home_filled, 'color': AppColors.cyan},
      {'index': 1, 'label': 'EXPLORE', 'icon': Icons.accessibility_new_rounded, 'color': AppColors.emerald},
      {'index': 2, 'label': 'SCAN LAB', 'icon': Icons.view_in_ar_rounded, 'color': AppColors.mriElectric},
      {'index': 3, 'label': 'CASE FILES', 'icon': Icons.find_in_page_rounded, 'color': AppColors.violet},
      {'index': 4, 'label': 'RADTECH MODE', 'icon': Icons.psychology_rounded, 'color': AppColors.amber},
      {'index': 5, 'label': 'VISUAL MODE', 'icon': Icons.auto_awesome_motion_rounded, 'color': AppColors.magenta},
    ];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
        border: const Border(
          right: BorderSide(color: AppColors.cardGlassBorder, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Logo & Brand
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cyan),
                    boxShadow: [
                      BoxShadow(color: AppColors.cyan.withOpacity(0.4), blurRadius: 10),
                    ],
                  ),
                  child: const Icon(Icons.blur_on_rounded, color: AppColors.cyan, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SCANVERSE',
                      style: AppTypography.displaySmall.copyWith(
                        fontSize: 16,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'RADIOLOGY OS',
                      style: AppTypography.hudLabel.copyWith(
                        fontSize: 8,
                        color: AppColors.cyan,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Nav Items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, i) {
                final item = navItems[i];
                final idx = item['index'] as int;
                final label = item['label'] as String;
                final icon = item['icon'] as IconData;
                final color = item['color'] as Color;
                final isSelected = currentIndex == idx;

                return InkWell(
                  onTap: () => appState.setNavigationIndex(idx),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 1.2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 12,
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: isSelected ? color : AppColors.textSecondary, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.hudLabel.copyWith(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              boxShadow: [BoxShadow(color: color, blurRadius: 4)],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Equalizer Widget
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: AudioEqualizerHUD(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomNav(int currentIndex, AppStateService appState) {
    final navItems = [
      {'index': 0, 'label': 'HOME', 'icon': Icons.home_filled, 'color': AppColors.cyan},
      {'index': 1, 'label': 'EXPLORE', 'icon': Icons.accessibility_new_rounded, 'color': AppColors.emerald},
      {'index': 2, 'label': 'SCAN', 'icon': Icons.view_in_ar_rounded, 'color': AppColors.mriElectric},
      {'index': 3, 'label': 'CASES', 'icon': Icons.find_in_page_rounded, 'color': AppColors.violet},
      {'index': 4, 'label': 'TECH', 'icon': Icons.psychology_rounded, 'color': AppColors.amber},
      {'index': 5, 'label': 'VISUAL', 'icon': Icons.auto_awesome_motion_rounded, 'color': AppColors.magenta},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: AppColors.cardGlassBorder, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final idx = item['index'] as int;
          final label = item['label'] as String;
          final icon = item['icon'] as IconData;
          final color = item['color'] as Color;
          final isSelected = currentIndex == idx;

          return InkWell(
            onTap: () => appState.setNavigationIndex(idx),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: isSelected ? color : AppColors.textMuted, size: 20),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: AppTypography.hudLabel.copyWith(
                      color: isSelected ? color : AppColors.textMuted,
                      fontSize: 8,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
