import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state_service.dart';
import '../../services/localization_service.dart';

/// Result of probing tissue density at an image coordinate
class TissueDensityInfo {
  final double hounsfieldUnits; // HU for CT or Signal Intensity for MRI
  final String tissueNameTh;
  final String tissueNameEn;
  final String clinicalSignificanceTh;
  final String clinicalSignificanceEn;
  final Color indicatorColor;

  const TissueDensityInfo({
    required this.hounsfieldUnits,
    required this.tissueNameTh,
    required this.tissueNameEn,
    required this.clinicalSignificanceTh,
    required this.clinicalSignificanceEn,
    required this.indicatorColor,
  });
}

class RealisticScanPainter extends CustomPainter {
  final int sliceIndex;
  final int totalSlices;
  final ModalityType modalityType;
  final ScanPlane scanPlane;
  final WindowPreset windowPreset;
  final double windowWidth;
  final double windowLevel;
  final bool isInverted;
  final Color accentColor;
  final Offset crosshairPos;
  final bool showCalipers;
  final bool showLandmarks;
  final bool isMotionArtifactActive;

  RealisticScanPainter({
    required this.sliceIndex,
    required this.totalSlices,
    required this.modalityType,
    this.scanPlane = ScanPlane.axial,
    this.windowPreset = WindowPreset.brain,
    this.windowWidth = 100.0,
    this.windowLevel = 50.0,
    this.isInverted = false,
    required this.accentColor,
    required this.crosshairPos,
    this.showCalipers = false,
    this.showLandmarks = true,
    this.isMotionArtifactActive = false,
  });

  /// Evaluates the tissue type & HU value at a normalized (0.0 - 1.0) canvas coordinate
  static TissueDensityInfo sampleTissueDensity({
    required Offset pos,
    required ModalityType modality,
    required ScanPlane plane,
    required int sliceIndex,
    required int totalSlices,
  }) {
    final depth = (sliceIndex / totalSlices).clamp(0.05, 0.95);
    final dx = pos.dx - 0.5;
    final dy = pos.dy - 0.5;
    final distFromCenter = math.sqrt(dx * dx + dy * dy);

    // Outside head / Ambient Air
    if (distFromCenter > 0.44) {
      return const TissueDensityInfo(
        hounsfieldUnits: -1000,
        tissueNameTh: 'อากาศภายนอก / โพรงไซนัส (Ambient Air)',
        tissueNameEn: 'Ambient Air / Sinuses',
        clinicalSignificanceTh: 'ความหนาแน่นต่ำสุด (-1000 HU) รังสีทะลุผ่านได้ 100%',
        clinicalSignificanceEn: 'Lowest radiodensity (-1000 HU), 100% X-ray transmission',
        indicatorColor: Colors.cyan,
      );
    }

    // Subcutaneous Fat / Scalp Rim
    if (distFromCenter > 0.40 && distFromCenter <= 0.44) {
      return const TissueDensityInfo(
        hounsfieldUnits: -85,
        tissueNameTh: 'ชั้นไขมันใต้หนังศีรษะ (Subcutaneous Fat)',
        tissueNameEn: 'Subcutaneous Scalp Fat',
        clinicalSignificanceTh: 'ไขมันให้สัญญาณสว่างใน T1 และมืดใน CT (-100 ถึง -50 HU)',
        clinicalSignificanceEn: 'Hyperintense on T1-WI, hypodense on CT (-100 to -50 HU)',
        indicatorColor: Colors.amber,
      );
    }

    // Skull Calvarium / Cortical Bone
    if (distFromCenter > 0.36 && distFromCenter <= 0.40) {
      return const TissueDensityInfo(
        hounsfieldUnits: 1250,
        tissueNameTh: 'กระดูกกะโหลกศีรษะ (Calvarium Cortical Bone)',
        tissueNameEn: 'Skull Calvarium (Cortical Bone)',
        clinicalSignificanceTh: 'ดูดกลืนรังสีสูงมาก (+1000 ถึง +2000 HU) ไร้สัญญาณใน MRI',
        clinicalSignificanceEn: 'High X-ray attenuation (+1000 to +2000 HU), signal void on MRI',
        indicatorColor: Colors.white,
      );
    }

    // Ventricular CSF (Center area depending on slice depth)
    final inVentricleArea = distFromCenter < 0.14 && depth > 0.3 && depth < 0.75;
    if (inVentricleArea) {
      return const TissueDensityInfo(
        hounsfieldUnits: 6,
        tissueNameTh: 'น้ำไขสันหลังในโพรงสมอง (Ventricular CSF)',
        tissueNameEn: 'Cerebrospinal Fluid (Lateral Ventricle)',
        clinicalSignificanceTh: 'น้ำ CSF สว่างใน T2 (Hyperintense) และมืดใน T1/FLAIR/CT (0-10 HU)',
        clinicalSignificanceEn: 'Hyperintense on T2-WI, suppressed on FLAIR, 0-10 HU on CT',
        indicatorColor: Colors.lightBlueAccent,
      );
    }

    // Pathological Region (Simulated frontal/parietal lesion around (0.35, 0.38))
    final distToLesion = math.sqrt(math.pow(pos.dx - 0.35, 2) + math.pow(pos.dy - 0.38, 2));
    if (distToLesion < 0.08) {
      if (modality == ModalityType.ct) {
        return const TissueDensityInfo(
          hounsfieldUnits: 76,
          tissueNameTh: 'ก้อนเลือดออกเฉียบพลัน (Acute Intracranial Hemorrhage)',
          tissueNameEn: 'Acute Intracranial Hematoma',
          clinicalSignificanceTh: 'ความหนาแน่นสูงจากเม็ดเลือดแดงฮีโมโกลบิน (+60 ถึง +85 HU)',
          clinicalSignificanceEn: 'Hyperdense due to globin protein concentration (+60 to +85 HU)',
          indicatorColor: Colors.redAccent,
        );
      } else {
        return const TissueDensityInfo(
          hounsfieldUnits: 190,
          tissueNameTh: 'ภาวะสมองขาดเลือด / การจำกัดการแพร่ของน้ำ (Cytotoxic Edema / Stroke)',
          tissueNameEn: 'Acute Infarction / Diffusion Restriction',
          clinicalSignificanceTh: 'เซลล์บวมน้ำ เกิด Hyperintensity สว่างจัดบนภาพ DWI',
          clinicalSignificanceEn: 'Cytotoxic edema causing bright diffusion restriction on DWI',
          indicatorColor: Colors.orangeAccent,
        );
      }
    }

    // Basal Ganglia / Thalamus (Mid-brain region)
    if (distFromCenter < 0.22 && depth >= 0.4 && depth <= 0.65) {
      return const TissueDensityInfo(
        hounsfieldUnits: 42,
        tissueNameTh: 'ปมประสาทฐานและทาลามัส (Basal Ganglia & Thalamus)',
        tissueNameEn: 'Basal Ganglia (Caudate / Putamen / Thalamus)',
        clinicalSignificanceTh: 'นิวเคลียสเซลล์ประสาทหนาแน่น (+40 ถึง +45 HU)',
        clinicalSignificanceEn: 'Deep gray matter relay stations (+40 to +45 HU)',
        indicatorColor: Colors.tealAccent,
      );
    }

    // White Matter / Centrum Semiovale
    if (distFromCenter < 0.28) {
      return const TissueDensityInfo(
        hounsfieldUnits: 30,
        tissueNameTh: 'เนื้อสมองส่วนขาว (Subcortical White Matter)',
        tissueNameEn: 'Subcortical White Matter (Centrum Semiovale)',
        clinicalSignificanceTh: 'ใยประสาทหุ้มปลอกไมอีลิน สว่างใน T1 และมืดกว่า Grey Matter ใน CT (+30 HU)',
        clinicalSignificanceEn: 'Myelinated axonal tracts, high signal on T1-WI, +30 HU on CT',
        indicatorColor: Colors.blueGrey,
      );
    }

    // Cerebral Cortex / Grey Matter Ribbon
    return const TissueDensityInfo(
      hounsfieldUnits: 38,
      tissueNameTh: 'เปลือกสมองส่วนเทา (Cerebral Cortex Grey Matter)',
      tissueNameEn: 'Cerebral Cortex (Grey Matter)',
      clinicalSignificanceTh: 'เซลล์ประสาทหนาแน่น (+36 ถึง +42 HU) มีรอยหยักซัลไค (Sulci) ชัดเจน',
      clinicalSignificanceEn: 'Dense neuronal cell bodies (+36 to +42 HU) with sulcal folds',
      indicatorColor: Colors.purpleAccent,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final isTh = LocalizationService().isThai;

    // Apply Window/Level contrast multipliers
    final contrastMult = (windowWidth / 100.0).clamp(0.2, 3.0);
    final brightnessBias = ((windowLevel - 50.0) / 100.0);

    // Background Canvas
    final bgPaint = Paint()..color = isInverted ? const Color(0xFFE8EEF5) : const Color(0xFF030509);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    if (scanPlane == ScanPlane.axial) {
      _paintAxialScan(canvas, size, cx, cy, contrastMult, brightnessBias);
    } else if (scanPlane == ScanPlane.sagittal) {
      _paintSagittalScan(canvas, size, cx, cy, contrastMult, brightnessBias);
    } else {
      _paintCoronalScan(canvas, size, cx, cy, contrastMult, brightnessBias);
    }

    // Motion Artifact Simulation Overlay
    if (isMotionArtifactActive) {
      _paintMotionArtifacts(canvas, size);
    }

    // Anatomical Landmarks Pinpoints
    if (showLandmarks) {
      _paintLandmarkPinpoints(canvas, size, cx, cy, isTh);
    }

    // Calipers Measurement Overlay
    if (showCalipers) {
      _paintCalipers(canvas, size, cx, cy);
    }

    // Interactive Crosshair Probe
    _paintCrosshairs(canvas, size);
  }

  void _paintAxialScan(Canvas canvas, Size size, double cx, double cy, double contrast, double brightness) {
    final depth = (sliceIndex / totalSlices).clamp(0.05, 0.95);
    final baseRadius = math.min(size.width, size.height) * 0.38;

    // Scaled anatomical skull size based on slice depth
    final skullWidth = (baseRadius * 2.05) * (0.78 + math.sin(depth * math.pi) * 0.26);
    final skullHeight = (baseRadius * 2.45) * (0.80 + math.sin(depth * math.pi) * 0.24);

    // 1. Scalp Fat Rim (Outer hyperintense on T1)
    if (modalityType == ModalityType.mri) {
      final scalpPaint = Paint()
        ..color = isInverted
            ? const Color(0xFF222831)
            : const Color(0xFF94A3B8).withOpacity((0.6 * contrast).clamp(0.1, 0.9))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: skullWidth + 10, height: skullHeight + 10), scalpPaint);
    }

    // 2. Skull Calvarium
    final skullPaint = Paint()
      ..color = isInverted
          ? const Color(0xFF0F172A)
          : (modalityType == ModalityType.ct
              ? Colors.white.withOpacity((0.95 * contrast).clamp(0.2, 1.0))
              : const Color(0xFF090D16))
      ..style = PaintingStyle.stroke
      ..strokeWidth = modalityType == ModalityType.ct ? (windowPreset == WindowPreset.bone ? 6.5 : 4.5) : 3.0;

    final skullRect = Rect.fromCenter(center: Offset(cx, cy), width: skullWidth, height: skullHeight);

    // 3. Brain Parenchyma Base Fill
    final parenchymaPaint = Paint()
      ..color = isInverted
          ? const Color(0xFFCBD5E1)
          : (modalityType == ModalityType.mri
              ? const Color(0xFF2B374A).withOpacity((0.9 * contrast + brightness).clamp(0.1, 1.0))
              : const Color(0xFF242E3D).withOpacity((0.85 * contrast + brightness).clamp(0.1, 1.0)))
      ..style = PaintingStyle.fill;

    canvas.drawOval(skullRect, parenchymaPaint);
    canvas.drawOval(skullRect, skullPaint);

    // 4. Subcortical White Matter Core (Centrum Semiovale)
    final wmWidth = skullWidth * 0.68;
    final wmHeight = skullHeight * 0.72;
    final wmPaint = Paint()
      ..color = isInverted
          ? const Color(0xFF94A3B8)
          : (modalityType == ModalityType.mri
              ? const Color(0xFF3B4860).withOpacity((0.85 * contrast).clamp(0.1, 1.0))
              : const Color(0xFF1B2330).withOpacity((0.85 * contrast).clamp(0.1, 1.0)))
      ..style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: wmWidth, height: wmHeight), wmPaint);

    // 5. Sulcal and Gyral Undulations
    final sulciPaint = Paint()
      ..color = isInverted
          ? const Color(0xFF475569)
          : (modalityType == ModalityType.mri
              ? const Color(0xFF141C2B).withOpacity(0.8)
              : const Color(0xFF101724).withOpacity(0.7))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final numSulci = 16;
    for (int i = 0; i < numSulci; i++) {
      final angle = (i / numSulci) * 2 * math.pi;
      final wave = math.sin(i * 3.0 + depth * 5.0) * 8.0;
      final startR = skullWidth * 0.46;
      final endR = skullWidth * 0.32 + wave;

      final sx = cx + math.cos(angle) * startR;
      final sy = cy + math.sin(angle) * (skullHeight / skullWidth * startR);
      final ex = cx + math.cos(angle) * endR;
      final ey = cy + math.sin(angle) * (skullHeight / skullWidth * endR);

      final path = Path()
        ..moveTo(sx, sy)
        ..quadraticBezierTo(
          (sx + ex) / 2 + math.sin(angle) * 6,
          (sy + ey) / 2 - math.cos(angle) * 6,
          ex,
          ey,
        );
      canvas.drawPath(path, sulciPaint);
    }

    // 6. Interhemispheric Falx Cerebri Fissure
    final falxPaint = Paint()
      ..color = isInverted ? const Color(0xFF0F172A) : const Color(0xFF0C1322)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(cx, cy - skullHeight * 0.46), Offset(cx, cy + skullHeight * 0.46), falxPaint);

    // 7. Ventricles & Deep Nuclei
    final ventScale = math.sin(depth * math.pi);
    if (ventScale > 0.25) {
      final ventFluidPaint = Paint()
        ..color = isInverted
            ? Colors.white
            : (modalityType == ModalityType.mri
                ? (windowPreset == WindowPreset.stroke ? Colors.white : const Color(0xFF050811))
                : const Color(0xFF090D16))
        ..style = PaintingStyle.fill;

      final ventBorderPaint = Paint()
        ..color = accentColor.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3;

      // Frontal & Occipital Horns (Left)
      final leftHorn = Path()
        ..moveTo(cx - 5, cy - (32 * ventScale))
        ..cubicTo(cx - (34 * ventScale), cy - (18 * ventScale), cx - (26 * ventScale), cy + (22 * ventScale), cx - 4, cy + (12 * ventScale))
        ..close();
      canvas.drawPath(leftHorn, ventFluidPaint);
      canvas.drawPath(leftHorn, ventBorderPaint);

      // Frontal & Occipital Horns (Right)
      final rightHorn = Path()
        ..moveTo(cx + 5, cy - (32 * ventScale))
        ..cubicTo(cx + (34 * ventScale), cy - (18 * ventScale), cx + (26 * ventScale), cy + (22 * ventScale), cx + 4, cy + (12 * ventScale))
        ..close();
      canvas.drawPath(rightHorn, ventFluidPaint);
      canvas.drawPath(rightHorn, ventBorderPaint);

      // Basal Ganglia & Thalamic Contours
      if (depth >= 0.35 && depth <= 0.65) {
        final bgPaint = Paint()
          ..color = isInverted ? const Color(0xFFA0AEC0) : const Color(0xFF334155).withOpacity(0.5)
          ..style = PaintingStyle.fill;

        // Left & Right Thalami
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 18, cy + 4), width: 16 * ventScale, height: 26 * ventScale), bgPaint);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 18, cy + 4), width: 16 * ventScale, height: 26 * ventScale), bgPaint);
      }
    }

    // 8. Pathology Simulation: Right Frontal/Temporal Hematoma or Stroke
    _paintPathologyLesion(canvas, size, cx, cy);
  }

  void _paintSagittalScan(Canvas canvas, Size size, double cx, double cy, double contrast, double brightness) {
    final depth = (sliceIndex / totalSlices).clamp(0.1, 0.9);
    final w = size.width * 0.72;
    final h = size.height * 0.78;

    // Outer Sagittal Calvarium
    final skullPath = Path()
      ..moveTo(cx - w * 0.45, cy + h * 0.25)
      ..cubicTo(cx - w * 0.48, cy - h * 0.45, cx + w * 0.35, cy - h * 0.48, cx + w * 0.45, cy - h * 0.10)
      ..cubicTo(cx + w * 0.48, cy + h * 0.25, cx + w * 0.20, cy + h * 0.42, cx - w * 0.10, cy + h * 0.38)
      ..close();

    final fillPaint = Paint()
      ..color = isInverted ? const Color(0xFFCBD5E1) : const Color(0xFF273344).withOpacity((0.9 * contrast + brightness).clamp(0.1, 1.0))
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = isInverted ? const Color(0xFF0F172A) : Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    canvas.drawPath(skullPath, fillPaint);
    canvas.drawPath(skullPath, strokePaint);

    // Midline Corpus Callosum (C-shape)
    if (depth >= 0.38 && depth <= 0.62) {
      final ccPath = Path()
        ..moveTo(cx - 30, cy - 8)
        ..cubicTo(cx - 38, cy - 36, cx + 36, cy - 38, cx + 38, cy - 10)
        ..cubicTo(cx + 28, cy - 26, cx - 26, cy - 24, cx - 30, cy - 8)
        ..close();

      final ccPaint = Paint()
        ..color = isInverted ? const Color(0xFF64748B) : Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      canvas.drawPath(ccPath, ccPaint);

      // Brainstem (Midbrain, Pons, Medulla)
      final brainstemPath = Path()
        ..moveTo(cx - 10, cy + 2)
        ..cubicTo(cx - 24, cy + 24, cx - 18, cy + 55, cx - 6, cy + 85)
        ..lineTo(cx + 14, cy + 85)
        ..cubicTo(cx + 8, cy + 45, cx + 12, cy + 18, cx + 8, cy + 2)
        ..close();

      final bsPaint = Paint()
        ..color = isInverted ? const Color(0xFF94A3B8) : const Color(0xFF38475C)
        ..style = PaintingStyle.fill;
      canvas.drawPath(brainstemPath, bsPaint);

      // Cerebellum & 4th Ventricle
      final cerebellumRect = Rect.fromCenter(center: Offset(cx + 32, cy + 48), width: 44, height: 42);
      final cerebPaint = Paint()
        ..color = isInverted ? const Color(0xFFA0AEC0) : const Color(0xFF2C394A)
        ..style = PaintingStyle.fill;
      canvas.drawOval(cerebellumRect, cerebPaint);

      // Cerebellar Horizontal Folia Striations
      final foliaPaint = Paint()
        ..color = isInverted ? const Color(0xFF475569) : const Color(0xFF1E293B)
        ..strokeWidth = 1.2;
      for (int f = -14; f <= 14; f += 5) {
        canvas.drawLine(Offset(cx + 18, cy + 48 + f.toDouble()), Offset(cx + 46, cy + 48 + f.toDouble()), foliaPaint);
      }
    }
  }

  void _paintCoronalScan(Canvas canvas, Size size, double cx, double cy, double contrast, double brightness) {
    final w = size.width * 0.74;
    final h = size.height * 0.76;

    // Coronal Skull Dome
    final skullPath = Path()
      ..moveTo(cx - w * 0.45, cy + h * 0.35)
      ..cubicTo(cx - w * 0.48, cy - h * 0.42, cx + w * 0.48, cy - h * 0.42, cx + w * 0.45, cy + h * 0.35)
      ..lineTo(cx + w * 0.25, cy + h * 0.42)
      ..lineTo(cx - w * 0.25, cy + h * 0.42)
      ..close();

    final fillPaint = Paint()
      ..color = isInverted ? const Color(0xFFCBD5E1) : const Color(0xFF263242).withOpacity((0.9 * contrast + brightness).clamp(0.1, 1.0))
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = isInverted ? const Color(0xFF0F172A) : Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    canvas.drawPath(skullPath, fillPaint);
    canvas.drawPath(skullPath, strokePaint);

    // Coronal Ventricles (Butterfly Wings)
    final ventPaint = Paint()
      ..color = isInverted ? Colors.white : const Color(0xFF080C16)
      ..style = PaintingStyle.fill;

    final leftWing = Path()
      ..moveTo(cx - 3, cy - 25)
      ..cubicTo(cx - 28, cy - 15, cx - 22, cy + 8, cx - 3, cy + 2)
      ..close();
    final rightWing = Path()
      ..moveTo(cx + 3, cy - 25)
      ..cubicTo(cx + 28, cy - 15, cx + 22, cy + 8, cx + 3, cy + 2)
      ..close();

    canvas.drawPath(leftWing, ventPaint);
    canvas.drawPath(rightWing, ventPaint);

    // Medial Temporal Lobes & Hippocampus
    final hipPaint = Paint()
      ..color = isInverted ? const Color(0xFF94A3B8) : const Color(0xFF38465A)
      ..style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 38, cy + 30), width: 22, height: 16), hipPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 38, cy + 30), width: 22, height: 16), hipPaint);
  }

  void _paintPathologyLesion(Canvas canvas, Size size, double cx, double cy) {
    final lx = cx - size.width * 0.14;
    final ly = cy - size.height * 0.12;

    if (modalityType == ModalityType.ct) {
      // Acute Hyperdense Hemorrhage (+75 HU)
      final bleedPaint = Paint()
        ..color = isInverted ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0).withOpacity(0.95)
        ..style = PaintingStyle.fill;

      final edemaPaint = Paint()
        ..color = isInverted ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A).withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0;

      // Surrounding Vasogenic Edema Ring
      canvas.drawCircle(Offset(lx, ly), 22, edemaPaint);
      // Dense Clot Core
      canvas.drawOval(Rect.fromCenter(center: Offset(lx, ly), width: 26, height: 19), bleedPaint);
    } else {
      // MRI Diffusion Restriction / MS Plaque / Contusion
      final mriLesionPaint = Paint()
        ..color = (windowPreset == WindowPreset.stroke
            ? Colors.white.withOpacity(0.95)
            : AppColors.cyan.withOpacity(0.85))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);

      canvas.drawCircle(Offset(lx, ly), 16, mriLesionPaint);
    }
  }

  void _paintMotionArtifacts(Canvas canvas, Size size) {
    final motionPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 2.0;

    for (double y = 0; y < size.height; y += 14) {
      final shift = math.sin(y * 0.1) * 20.0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + shift), motionPaint);
    }
  }

  void _paintLandmarkPinpoints(Canvas canvas, Size size, double cx, double cy, bool isTh) {
    final points = [
      {
        'pos': Offset(cx - size.width * 0.14, cy - size.height * 0.12),
        'labelTh': 'รอยโรคเฉียบพลัน (Lesion)',
        'labelEn': 'Acute Lesion Focus',
        'color': AppColors.amber,
      },
      {
        'pos': Offset(cx, cy - size.height * 0.08),
        'labelTh': 'โพรงสมองส่วนหน้า (Frontal Horn)',
        'labelEn': 'Frontal Horn (CSF)',
        'color': AppColors.cyan,
      },
      {
        'pos': Offset(cx - size.width * 0.28, cy),
        'labelTh': 'เปลือกสมอง (Cortex Sulci)',
        'labelEn': 'Cerebral Cortex',
        'color': AppColors.emerald,
      },
    ];

    for (final pt in points) {
      final pos = pt['pos'] as Offset;
      final label = (isTh ? pt['labelTh'] : pt['labelEn']) as String;
      final col = pt['color'] as Color;

      // Glow Dot
      final dotPaint = Paint()
        ..color = col
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, 4.0, dotPaint);

      final ringPaint = Paint()
        ..color = col.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(pos, 8.0, ringPaint);

      // Label Pin
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontFamily: 'Prompt',
            color: col,
            fontSize: 9.0,
            fontWeight: FontWeight.w600,
            backgroundColor: const Color(0xFF030712).withOpacity(0.85),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(pos.dx + 12, pos.dy - 6));
    }
  }

  void _paintCalipers(Canvas canvas, Size size, double cx, double cy) {
    final p1 = Offset(cx - 35, cy - 20);
    final p2 = Offset(cx + 35, cy - 20);

    final calPaint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 1.5;

    canvas.drawLine(p1, p2, calPaint);
    canvas.drawLine(Offset(p1.dx, p1.dy - 5), Offset(p1.dx, p1.dy + 5), calPaint);
    canvas.drawLine(Offset(p2.dx, p2.dy - 5), Offset(p2.dx, p2.dy + 5), calPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '28.4 mm (Dist)',
        style: TextStyle(
          color: AppColors.amber,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(cx - 28, cy - 38));
  }

  void _paintCrosshairs(Canvas canvas, Size size) {
    final chX = crosshairPos.dx * size.width;
    final chY = crosshairPos.dy * size.height;

    final crossPaint = Paint()
      ..color = accentColor.withOpacity(0.8)
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(chX - 12, chY), Offset(chX + 12, chY), crossPaint);
    canvas.drawLine(Offset(chX, chY - 12), Offset(chX, chY + 12), crossPaint);
    canvas.drawCircle(Offset(chX, chY), 2.5, crossPaint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant RealisticScanPainter oldDelegate) => true;
}
