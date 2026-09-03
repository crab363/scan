import 'package:flutter/material.dart';
import '../models/anatomy_model.dart';
import '../theme/app_colors.dart';

class AnatomyData {
  static const List<AnatomyZone> zones = [
    AnatomyZone(
      id: 'brain',
      name: 'Neurocranium / Brain',
      category: 'Central Nervous System',
      description:
          'Cerebral hemispheres, basal ganglia, brainstem, ventricles, and neurovascular circulation (Circle of Willis).',
      coordinates: Offset(0.50, 0.12),
      accentColor: AppColors.cyan,
      primaryModalities: ['MRI (3.0T)', 'CT Angiography', 'PET Brain Metabolism'],
      commonExams: ['MRI Brain Stroke Protocol', 'CT Head Non-Contrast', 'MR Venography'],
      clinicalPearls:
          'MRI DWI/ADC reveals cytotoxic edema within minutes of ischemic onset. Non-contrast CT is fastest to rule out acute hemorrhage.',
      radiationSafetyNote: 'MRI: 0 mSv (Non-ionizing RF + Magnetism). CT Head: ~2.0 mSv.',
    ),
    AnatomyZone(
      id: 'chest',
      name: 'Thorax & Cardiopulmonary',
      category: 'Cardiovascular & Respiratory',
      description:
          'Lungs, airways, mediastinum, heart, thoracic aorta, coronary arteries, and pulmonary vasculature.',
      coordinates: Offset(0.50, 0.28),
      accentColor: AppColors.emerald,
      primaryModalities: ['High-Resolution CT (HRCT)', 'CT Pulmonary Angiography (CTPA)', 'Digital Chest X-Ray'],
      commonExams: ['PA & Lateral Chest Radiograph', 'CTA Thoracic Aorta', 'Cardiac MRI'],
      clinicalPearls:
          'PA chest radiograph minimizes cardiac magnification compared to AP portable. Full inspiration (10 posterior ribs visible) is essential for diagnostic quality.',
      radiationSafetyNote: 'Chest X-Ray: 0.1 mSv (10 days natural background). CTPA: ~7.0 mSv (High Iodine Contrast).',
    ),
    AnatomyZone(
      id: 'spine',
      name: 'Vertebral Column & Cord',
      category: 'Musculoskeletal & Neural Axis',
      description:
          'Cervical, thoracic, lumbar, and sacral vertebrae, intervertebral discs, thecal sac, and exiting nerve roots.',
      coordinates: Offset(0.50, 0.44),
      accentColor: AppColors.violet,
      primaryModalities: ['MRI Spine (T1/T2/STIR)', 'CT Spine Multiplanar', 'Digital X-Ray Flexion/Extension'],
      commonExams: ['MRI Lumbar Spine for Radiculopathy', 'CT Cervical Spine Trauma', 'X-Ray Scoliosis Series'],
      clinicalPearls:
          'STIR (Short Tau Inversion Recovery) suppresses fat signal to accentuate acute bone marrow edema in vertebral compression fractures.',
      radiationSafetyNote: 'MRI Spine: 0 mSv. Lumbar Spine X-Ray: ~1.5 mSv. CT Lumbar: ~6.0 mSv.',
    ),
    AnatomyZone(
      id: 'abdomen',
      name: 'Abdomen & Pelvis',
      category: 'Gastrointestinal & Genitourinary',
      description:
          'Liver, spleen, pancreas, kidneys, adrenal glands, bowel loops, bladder, and mesenteric vascular networks.',
      coordinates: Offset(0.50, 0.58),
      accentColor: AppColors.amber,
      primaryModalities: ['Multiphasic CT Abdomen', 'MRCP (Biliary MRI)', 'Ultrasound Doppler'],
      commonExams: ['CT Abdomen/Pelvis with IV/Oral Contrast', 'MRCP for Choledocholithiasis', 'Renal US'],
      clinicalPearls:
          'Triple-phase liver CT (Arterial, Portal Venous, Delayed) captures differential vascular wash-in/wash-out kinetics characteristic of hepatocellular carcinoma.',
      radiationSafetyNote: 'CT Abdomen/Pelvis: ~10.0 mSv. Ultrasound & MRCP: 0 mSv.',
    ),
    AnatomyZone(
      id: 'bones',
      name: 'Extremities & Skeletal',
      category: 'Musculoskeletal & Orthopedics',
      description:
          'Long bones, articular joints (knee, shoulder, hip, wrist), ligaments, fibrocartilage labrum, and tendons.',
      coordinates: Offset(0.28, 0.74),
      accentColor: AppColors.magenta,
      primaryModalities: ['Digital Radiography (X-Ray)', 'MR Arthrogram', '3D CT Orthopedic Reconstruction'],
      commonExams: ['Knee MRI for Meniscal/ACL Tear', 'Hand/Wrist 3-View X-Ray', 'CT Pelvis Fracture Mapping'],
      clinicalPearls:
          'Standard radiologic rule: "Always take at least two orthogonal projections at 90 degrees." One view is no view in trauma radiography.',
      radiationSafetyNote: 'Extremity X-Ray: ~0.001 mSv (Negligible). Shield gonads with lead apron whenever feasible.',
    ),
  ];
}
