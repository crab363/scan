import 'package:flutter/material.dart';
import '../models/imaging_modality.dart';
import '../theme/app_colors.dart';

class ModalitiesData {
  static const List<ImagingModality> modalities = [
    ImagingModality(
      type: ModalityType.mri,
      name: 'MRI',
      tag: 'MAGNETIC RESONANCE',
      fullName: 'Magnetic Resonance Imaging',
      description:
          'Utilizes strong superconducting magnetic fields (1.5T - 3.0T) and radiofrequency (RF) pulses to excite hydrogen protons in bodily water molecules, capturing exquisite soft tissue contrast without ionizing radiation.',
      physicsPrinciple:
          'Larmor Precession & Fourier Transform: Hydrogen protons precess at resonance frequency ω = γB0. RF pulse tilts net magnetization vector into transverse plane; relaxation times (T1 longitudinal & T2 transverse) map distinct tissue types.',
      soundProfile: 'Rhythmic acoustic gradient switching, chirping RF pulses, knocking & buzzing thumps (up to 110 dB without hearing protection).',
      accentColor: AppColors.mriElectric,
      gradientColors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
      radiationLevel: '0 mSv (Non-Ionizing Magnetic & RF Fields)',
      acquisitionSpeed: '15 - 45 Minutes (High temporal sensitivity)',
      softTissueResolution: 'Gold Standard (Exceptional gray/white matter differentiation)',
      safetyChecklist: [
        'Mandatory Zone IV ferromagnetic screening (implants, pacemakers, metal fragments)',
        'Check for implanted aneurysm clips or cochlear implants',
        'Verify renal function (eGFR) if Gadolinium contrast is required',
        'Provide acoustic earplugs / noise-canceling headphones',
        'Check for patient claustrophobia and equip emergency squeeze bulb',
      ],
      availableSequences: [
        ScanSequenceInfo(
          code: 'T1-WI',
          name: 'T1-Weighted Spin Echo',
          physicsDescription: 'Short TR (<600ms), Short TE (<30ms). Fat appears bright (hyperintense), fluid/CSF appears dark (hypointense).',
          contrastType: 'Anatomy & Fat Highlighting',
          defaultTR: 500,
          defaultTE: 15,
          primaryApplication: 'Excellent anatomical structural fidelity and post-contrast tumor enhancement evaluation.',
        ),
        ScanSequenceInfo(
          code: 'T2-WI',
          name: 'T2-Weighted Fast Spin Echo',
          physicsDescription: 'Long TR (>2000ms), Long TE (>80ms). Fluid/CSF appears bright (hyperintense), fat appears intermediate.',
          contrastType: 'Pathology & Water Sensitive',
          defaultTR: 3500,
          defaultTE: 100,
          primaryApplication: 'Detecting edema, demyelination (Multiple Sclerosis plaques), inflammation, and joint effusion.',
        ),
        ScanSequenceInfo(
          code: 'FLAIR',
          name: 'Fluid Attenuated Inversion Recovery',
          physicsDescription: 'Inversion Recovery pulse nulls signal from free cerebrospinal fluid (CSF) while keeping T2 hyperintensity in edema.',
          contrastType: 'CSF Suppressed T2',
          defaultTR: 9000,
          defaultTE: 120,
          primaryApplication: 'Periventricular white matter lesions, subarachnoid hemorrhage, and cortical sulcal pathology.',
        ),
        ScanSequenceInfo(
          code: 'DWI / ADC',
          name: 'Diffusion Weighted Imaging',
          physicsDescription: 'Applies strong bipolar diffusion gradients to detect microscopic Brownian motion of water molecules.',
          contrastType: 'Cytotoxic Edema Diffusion Restriction',
          defaultTR: 4000,
          defaultTE: 70,
          primaryApplication: 'Hyperacute ischemic stroke diagnosis within minutes of onset and high-grade cellular tumors.',
        ),
      ],
      hardwareComponents: [
        'Superconducting Main Magnet Bore (Liquid Helium Cryostat)',
        'Gradient Coils (X, Y, Z spatial encoding axes)',
        'Radiofrequency (RF) Transmit & Phased-Array Receiver Coils',
        'Patient Patient Positioning Table with Laser Optical Isocenter',
        'Faraday Cage RF Shielding & Operator Workstation',
      ],
    ),
    ImagingModality(
      type: ModalityType.ct,
      name: 'CT',
      tag: 'COMPUTED TOMOGRAPHY',
      fullName: 'Computed Tomography (X-ray CT)',
      description:
          'Employs a high-speed rotating X-ray tube and multi-row detector array inside a circular gantry to reconstruct cross-sectional 2D/3D volumetric attenuation maps measured in Hounsfield Units (HU).',
      physicsPrinciple:
          'Beer-Lambert Law & Filtered Back Projection / Iterative Reconstruction: X-ray beam attenuation I = I0 * e^(-μx). Detectors measure ray line integrals across 360 degrees; Radon transform inversion yields voxel attenuation values.',
      soundProfile: 'Smooth high-speed gantry mechanical rotation hum, cooling fans, and automated breathing instruction audio prompts.',
      accentColor: AppColors.ctMatrix,
      gradientColors: [Color(0xFF00E599), Color(0xFF00B4D8)],
      radiationLevel: '2.0 - 10.0 mSv (Ionizing Radiation - ALARA principle optimized)',
      acquisitionSpeed: '5 - 30 Seconds (Ultrafast sub-second volumetric scans)',
      softTissueResolution: 'Moderate (Excellent for bone, acute hemorrhage, lungs & vascular CTA)',
      safetyChecklist: [
        'Verify pregnancy status in female patients of childbearing age',
        'Screen for IV Iodinated contrast allergy and pre-medicate if indicated',
        'Assess baseline renal function (Serum Creatinine / eGFR)',
        'Confirm IV cannula patency (18G-20G in antecubital fossa for high-flow power injection)',
        'Implement ALARA protocols: AEC (Automated Tube Current Modulation)',
      ],
      availableSequences: [
        ScanSequenceInfo(
          code: 'NCCT',
          name: 'Non-Contrast Computed Tomography',
          physicsDescription: 'Standard volumetric spiral scan without intravenous contrast agent. Evaluates density differences in HU.',
          contrastType: 'Intrinsic Tissue Density',
          defaultTR: 120, // kVp
          defaultTE: 250, // mA
          primaryApplication: 'Acute intracranial hemorrhage, calcifications, skull trauma, and renal stone detection.',
        ),
        ScanSequenceInfo(
          code: 'CTA',
          name: 'CT Angiography (Bolus Tracking)',
          physicsDescription: 'Triggered dynamic high-pressure contrast injection synchronized with volumetric arterial phase acquisition.',
          contrastType: 'Intravascular Iodinated Contrast (350 mg I/mL)',
          defaultTR: 100, // kVp
          defaultTE: 350, // mA
          primaryApplication: 'Arterial dissection, intracranial aneurysms, pulmonary embolism, and vascular stenosis.',
        ),
        ScanSequenceInfo(
          code: 'BONE-3D',
          name: 'High-Resolution Bone Window & 3D VRT',
          physicsDescription: 'Sharp reconstruction kernel algorithm optimized for high spatial frequency bone trabeculae.',
          contrastType: 'High Spatial Frequency Bone Kernel',
          defaultTR: 140, // kVp
          defaultTE: 200, // mA
          primaryApplication: 'Complex articular fracture mapping, pre-surgical orthopedic 3D modeling, and ossicular chain.',
        ),
      ],
      hardwareComponents: [
        'Slip-Ring High-Speed Gantry (Up to 4 rotations per second)',
        'Heavy-Duty Liquid-Metal Bearing X-Ray Tube',
        'Scintillator Photodiode Multi-Row Detector Array (64 - 320 slices)',
        'Dual-Syringe Automated Contrast Power Injector',
        'Reconstruction Array Processor Workstation',
      ],
    ),
    ImagingModality(
      type: ModalityType.xray,
      name: 'X-RAY',
      tag: 'DIGITAL RADIOGRAPHY',
      fullName: 'Digital Radiography (DR / CR)',
      description:
          'The foundational medical imaging modality. Projects an X-ray beam through target anatomy onto a flat-panel digital detector (amorphous silicon/selenium) to generate instantaneous 2D radiographic projection maps.',
      physicsPrinciple:
          'Differential Photoelectric Absorption & Compton Scatter: Bone (high calcium Z=20) absorbs X-rays (radiopaque/white), while air (low density) transmits X-rays (radiolucent/black).',
      soundProfile: 'Rotor acceleration whine, high-voltage contactor click, and instantaneous exposure termination tone.',
      accentColor: AppColors.xrayViolet,
      gradientColors: [Color(0xFFC77DFF), Color(0xFF7B2CBF)],
      radiationLevel: '0.001 - 1.5 mSv (Lowest per-exposure ionizing dose)',
      acquisitionSpeed: '< 1 Millisecond (Instant digital flat-panel capture)',
      softTissueResolution: 'Low (Ideal for skeletal fractures, lung aeration, and foreign bodies)',
      safetyChecklist: [
        'Apply 3 Fundamental Radiation Safety Principles: Time, Distance, Shielding',
        'Tight collimation to the anatomical region of interest to minimize scatter',
        'Use gonadal and thyroid lead shielding (0.5mm Pb equivalent) when appropriate',
        'Select optimal SID (Source-to-Image Distance: 100cm table / 180cm chest stand)',
        'Ensure correct anatomical lead marker placement (Right / Left)',
      ],
      availableSequences: [
        ScanSequenceInfo(
          code: 'PA-CHEST',
          name: 'Posteroanterior (PA) Projection',
          physicsDescription: 'X-ray beam enters patient’s back and exits anterior chest onto detector at 180cm SID.',
          contrastType: 'Air vs Soft Tissue Contrast',
          defaultTR: 120, // kVp
          defaultTE: 4, // mAs
          primaryApplication: 'Pneumothorax, pneumonia consolidation, pleural effusion, and cardiomegaly screening.',
        ),
        ScanSequenceInfo(
          code: 'LATERAL',
          name: 'Lateral Orthogonal Projection',
          physicsDescription: 'Perpendicular 90-degree view to clarify spatial depth and retrosternal / retrocardiac spaces.',
          contrastType: 'Depth Orthogonal Verification',
          defaultTR: 125, // kVp
          defaultTE: 8, // mAs
          primaryApplication: 'Vertebral alignment, retrocardiac lung lesions, and sternal fracture evaluation.',
        ),
        ScanSequenceInfo(
          code: 'OBLIQUE',
          name: 'Oblique & Stress Views',
          physicsDescription: 'Patient positioned at 45-degree angle to profile articular joints and overlapping bony cortex.',
          contrastType: 'Articular Profile',
          defaultTR: 65, // kVp
          defaultTE: 3, // mAs
          primaryApplication: 'Scaphoid occult fracture, cervical neural foramina, and rib detail.',
        ),
      ],
      hardwareComponents: [
        'Rotating Anode X-Ray Tube with Tungsten Target',
        'Variable Aperture Light-Beam Collimator',
        'Anti-Scatter Lead Grid (Bucky Mechanism)',
        'Cesium Iodide (CsI) Amorphous Silicon Flat-Panel Digital Detector',
        'Lead-Glass Shielded Technician Control Console',
      ],
    ),
  ];
}
