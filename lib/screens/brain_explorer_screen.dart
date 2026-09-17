import 'package:flutter/material.dart';
import '../models/brain_region_model.dart';
import '../data/brain_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/audio_service.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/explore/brain_canvas_3d.dart';

class BrainExplorerScreen extends StatefulWidget {
  const BrainExplorerScreen({super.key});

  @override
  State<BrainExplorerScreen> createState() => _BrainExplorerScreenState();
}

class _BrainExplorerScreenState extends State<BrainExplorerScreen> {
  BrainRegion _selectedRegion = BrainData.regions.first;
  BrainSlicePlane _activePlane = BrainSlicePlane.threeD;
  final double _sliceDepth = 0.5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Bar
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.cyan, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.cardGlassBorder),
                        ),
                        onPressed: () {
                          SoundService().playSound(SoundEffect.uiClick);
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ANATOMICAL DEEP DIVE', style: AppTypography.hudLabel.copyWith(color: AppColors.cyan, fontSize: 9.5)),
                          Text('3D BRAIN LOBES EXPLORER', style: AppTypography.displaySmall.copyWith(fontSize: 17)),
                        ],
                      ),
                    ],
                  ),

                  // Plane Selector Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPlaneChip('3D MESH', BrainSlicePlane.threeD),
                        _buildPlaneChip('AXIAL', BrainSlicePlane.axial),
                        _buildPlaneChip('SAGITTAL', BrainSlicePlane.sagittal),
                        _buildPlaneChip('CORONAL', BrainSlicePlane.coronal),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Main Responsive Layout
              Expanded(
                child: isDesktop
                    ? Row(
                        children: [
                          // 3D Canvas
                          Expanded(
                            flex: 6,
                            child: _buildCanvasBox(),
                          ),
                          const SizedBox(width: 20),
                          // Compact Storytelling Panel
                          Expanded(
                            flex: 4,
                            child: _buildRegionStoryPanel(),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 340,
                              child: _buildCanvasBox(),
                            ),
                            const SizedBox(height: 16),
                            _buildRegionStoryPanel(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasBox() {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      showCornerBrackets: true,
      child: Stack(
        children: [
          BrainCanvas3D(
            selectedRegion: _selectedRegion,
            onRegionSelected: (region) => setState(() => _selectedRegion = region),
            activePlane: _activePlane,
            sliceDepth: _sliceDepth,
          ),

          // Lobe Quick Selector Bottom Strip
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: BrainData.regions.map((region) {
                  final isSelected = region.id == _selectedRegion.id;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text(
                        region.name.split(' ').first,
                        style: AppTypography.hudLabel.copyWith(
                          color: isSelected ? AppColors.background : region.highlightColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: region.highlightColor,
                      backgroundColor: AppColors.surface.withOpacity(0.8),
                      side: BorderSide(color: isSelected ? region.highlightColor : AppColors.cardGlassBorder),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedRegion = region);
                          SoundService().playSound(SoundEffect.uiClick);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Interaction hint
          Positioned(
            top: 8,
            left: 12,
            child: Text(
              'Drag to rotate • Pinch to zoom • Tap lobe to select',
              style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionStoryPanel() {
    final color = _selectedRegion.highlightColor;

    return GlassPanel(
      borderColor: color.withOpacity(0.4),
      padding: const EdgeInsets.all(20),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_selectedRegion.latinName.toUpperCase(), style: AppTypography.hudLabel.copyWith(color: color, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(_selectedRegion.name, style: AppTypography.titleLarge.copyWith(fontSize: 22, color: Colors.white)),
                ],
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.8), blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Key Role
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              _selectedRegion.keyRole,
              style: AppTypography.hudLabel.copyWith(color: color, fontSize: 10),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            _selectedRegion.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.5, fontSize: 12),
          ),
          const SizedBox(height: 14),

          // Primary Functions
          Text('PRIMARY PHYSIOLOGICAL FUNCTIONS', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          ..._selectedRegion.primaryFunctions.map((fn) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fn,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),

          // Clinical Relevance
          Text('CLINICAL PATHOLOGIES', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          ..._selectedRegion.clinicalRelevance.map((pathology) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.amber),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pathology,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),

          // Imaging Tip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.camera_alt_outlined, color: color, size: 14),
                    const SizedBox(width: 6),
                    Text('RADIOLOGIC IMAGING TIP', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: color)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedRegion.imagingTip,
                  style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaneChip(String label, BrainSlicePlane plane) {
    final isSelected = _activePlane == plane;

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTypography.hudLabel.copyWith(
            color: isSelected ? AppColors.background : AppColors.cyan,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.cyan,
        backgroundColor: AppColors.surface,
        side: BorderSide(color: isSelected ? AppColors.cyan : AppColors.cardGlassBorder),
        onSelected: (selected) {
          if (selected) {
            setState(() => _activePlane = plane);
            SoundService().playSound(SoundEffect.uiClick);
          }
        },
      ),
    );
  }
}
