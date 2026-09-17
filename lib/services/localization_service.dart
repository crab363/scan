enum AppLanguage {
  th,
  en,
}

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  AppLanguage _currentLanguage = AppLanguage.th;

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isThai => _currentLanguage == AppLanguage.th;

  void setLanguage(AppLanguage lang) {
    _currentLanguage = lang;
  }

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == AppLanguage.th ? AppLanguage.en : AppLanguage.th;
  }

  String t(String key) {
    if (_currentLanguage == AppLanguage.th) {
      return _thDictionary[key] ?? _enDictionary[key] ?? key;
    }
    return _enDictionary[key] ?? _thDictionary[key] ?? key;
  }

  static const Map<String, String> _thDictionary = {
    // App & Nav
    'app_title': 'SCANVERSE — ระบบจำลองรังสีวิทยาทางการแพทย์เสมือนจริง',
    'app_subtitle': 'ระบบปฏิบัติการรังสีวินิจฉัยและการเรียนรู้ทางการแพทย์เชิงโต้ตอบ',
    'nav_home': 'หน้าหลัก',
    'nav_explore': 'สำรวจกายวิภาค',
    'nav_scan': 'ห้องจำลองสแกน',
    'nav_cases': 'คลังเคสผู้ป่วย',
    'nav_tech': 'โหมดนักรังสีเทคนิค',
    'nav_visual': 'โหมดทัศนศิลป์',
    'language_switch': 'ไทย / EN',
    'lang_th': 'ไทย',
    'lang_en': 'English',

    // Scan Simulation Lab
    'scan_lab_title': 'ห้องปฏิบัติการจำลองการสแกนทางการแพทย์',
    'scan_lab_subtitle': 'กระบวนการตรวจทางรังสีวิทยา 5 ขั้นตอนตามมาตรฐานคลินิก',
    'reset_lab': 'รีเซ็ตห้องแล็บ',
    'step_1_patient': '1. ผู้ป่วย',
    'step_2_prep': '2. ความปลอดภัย',
    'step_3_position': '3. จัดตำแหน่ง',
    'step_4_scan': '4. สแกนจริง',
    'step_5_image': '5. ภาพวินิจฉัย',

    // Patient Prep Card
    'patient_intake_title': 'ข้อมูลผู้ป่วยและการคัดกรองความปลอดภัย',
    'patient_id': 'รหัสผู้ป่วย',
    'patient_name': 'ชื่อ-นามสกุล',
    'patient_age_gender': 'อายุ / เพศ',
    'patient_indication': 'ข้อบ่งชี้ทางคลินิก',
    'patient_protocol': 'โปรโตคอลการตรวจ',
    'safety_checklist_header': 'แบบประเมินความปลอดภัยก่อนเข้าตรวจ (Safety Checklist)',
    'ferrous_metal_check': 'ไม่มีโลหะหรืออุปกรณ์อิเล็กทรอนิกส์ฝังในร่างกาย (Zone IV Safe)',
    'pacemaker_check': 'ไม่มีเครื่องกระตุ้นหัวใจ (Cardiac Pacemaker) หรือคลิปหนีบหลอดเลือดสมอง',
    'renal_function_check': 'ค่าการทำงานของไต (eGFR > 60 mL/min) พร้อมรับสารทึบรังสี',
    'claustrophobia_check': 'ผู้ป่วยไม่มีภาวะกลัวที่แคบขั้นรุนแรง (พร้อมลูกยางฉุกเฉิน)',
    'pregnancy_check': 'ได้รับการยืนยันว่าไม่ได้ตั้งครรภ์ (สำหรับ CT/X-Ray)',
    'prep_ready_btn': 'ยืนยันความปลอดภัยและเริ่มจัดตำแหน่งผู้ป่วย',
    'screening_status': 'สถานะการคัดกรอง',
    'screening_cleared': 'ผ่านการคัดกรองความปลอดภัย (Zone IV Cleared)',
    'screening_warning': 'กรุณาตรวจสอบรายการความปลอดภัยให้ครบถ้วน',

    // Laser Positioning HUD
    'laser_hud_title': 'การจัดตำแหน่งเลเซอร์และวางแผนแนวตัดภาพ (Scout Topogram)',
    'isocenter_alignment': 'จุดกึ่งกลางสนามแม่เหล็ก (Isocenter Alignment)',
    'laser_crosshair': 'เลเซอร์เล็งตำแหน่ง (Sagittal & Coronal Lasers)',
    'gantry_depth': 'ความลึกเตียงตรวจ (Gantry Depth)',
    'table_height': 'ระดับความสูงเตียง (Table Height)',
    'slice_thickness': 'ความหนาแผ่นตัด (Slice Thickness)',
    'slice_gap': 'ระยะห่างแผ่นตัด (Slice Gap)',
    'plane_angle': 'มุมเอียงระนาบสมอง (AC-PC Line Angle)',
    'lock_position_btn': 'ล็อกตำแหน่งและเริ่มกระบวนการสแกน (Lock & Proceed)',

    // Scan Acquisition HUD
    'acquisition_title': 'การปล่อยคลื่นวิทยุและการเหนี่ยวนำสนามแม่เหล็กไล่ระดับ (RF & Gradients)',
    'scanner_ready': 'เครื่องพร้อมสแกน',
    'acquiring_kspace': 'กำลังเก็บข้อมูล K-Space...',
    'sound_active': 'เสียงคลื่นแม่เหล็กไฟฟ้าทำงาน',
    'sar_level': 'อัตราการดูดกลืนพลังงานจำเพาะ (SAR)',
    'snr_ratio': 'อัตราส่วนสัญญาณต่อสัญญาณรบกวน (SNR)',
    'motion_simulation': 'จำลองการขยับตัวของผู้ป่วย (Motion Artifact)',
    'start_scan_btn': 'เริ่มปล่อยสัญญาณสแกน (Start Acquisition)',
    'view_recon_btn': 'ดูภาพที่สร้างเสร็จสมบูรณ์ (View Reconstructed PACS)',

    // K-Space Reconstruction
    'recon_title': 'การประมวลผลทางคณิตศาสตร์ 2D Fast Fourier Transform (FFT)',
    'kspace_raw': 'เมทริกซ์ความถี่ดิบ (K-Space Raw Domain)',
    'image_domain': 'ภาพรังสีวินิจฉัย (Diagnostic Image Domain)',
    'center_kspace_info': 'จุดกึ่งกลาง K-Space ให้ข้อมูลความเปรียบต่างของเนื้อเยื่อ (Tissue Contrast)',
    'periphery_kspace_info': 'ขอบนอก K-Space ให้ข้อมูลความคมชัดของขอบและรายละเอียด (Edge & Spatial Resolution)',
    'recon_complete_btn': 'เข้าสู่สถานีงานวินิจฉัยทางการแพทย์ (Open PACS Workstation)',

    // DICOM Workstation / Slice Viewer
    'workstation_title': 'สถานีงานรังสีวินิจฉัยทางการแพทย์ (Diagnostic PACS Workstation)',
    'slice_depth': 'ระดับความลึกของภาพตัดขวาง (Slice Depth)',
    'window_presets': 'พรีเซ็ตหน้าต่างภาพ (Window Presets):',
    'win_brain': 'สมอง (Brain)',
    'win_stroke': 'สโตรก (Stroke/Ischemia)',
    'win_subdural': 'เลือดออก (Subdural/Blood)',
    'win_bone': 'กระดูก (Bone)',
    'win_soft_tissue': 'เนื้อเยื่ออ่อน (Soft Tissue)',
    'win_lung': 'ปอด (Lung)',
    'plane_axial': 'แนวขวาง (Axial)',
    'plane_sagittal': 'แนวด้านข้าง (Sagittal)',
    'plane_coronal': 'แนวด้านหน้า (Coronal)',
    'hu_density_probe': 'หัววัดความหนาแน่นเนื้อเยื่อ (HU Density Probe)',
    'tissue_type': 'ชนิดเนื้อเยื่อที่ระบุได้:',
    'caliper_measure': 'เครื่องมือวัดระยะ (Caliper mm)',
    'cine_loop': 'เล่นภาพสไลซ์ต่อเนื่อง (Cine Loop)',
    'landmark_overlay': 'จุดระบุทางกายวิภาคและรอยโรค (Landmarks)',
    'invert_lut': 'กลับสีขาว-ดำ (Invert LUT)',
    'enter_visual_mode': 'เปิดโหมดทัศนศิลป์ทางการแพทย์ (Visual Art Mode)',

    // HU Tissue Types
    'hu_air': 'อากาศ (-1000 HU) — โพรงไซนัส / อากาศภายนอก',
    'hu_fat': 'เนื้อเยื่อไขมัน (-100 ถึง -50 HU) — ไขมันใต้ผิวหนัง',
    'hu_water': 'น้ำ / น้ำไขสันหลัง (0 ถึง +15 HU) — โพรงสมอง (Ventricles / CSF)',
    'hu_edema': 'ภาวะบวมน้ำของสมอง (+15 ถึง +25 HU) — Vasogenic / Cytotoxic Edema',
    'hu_white_matter': 'เนื้อสมองส่วนขาว (+28 ถึง +34 HU) — Subcortical White Matter',
    'hu_grey_matter': 'เนื้อสมองส่วนเทา (+35 ถึง +45 HU) — Cerebral Cortex',
    'hu_blood': 'เลือดออกเฉียบพลัน (+60 ถึง +85 HU) — Acute Hemorrhage / Hematoma',
    'hu_calcification': 'หินปูนเกาะ (+100 ถึง +300 HU) — Calcification / Dural Plaque',
    'hu_bone': 'กระดูกกะโหลก (+1000 ถึง +2500 HU) — Cortical Bone Calvarium',

    // Case Files PACS
    'case_files_title': 'คลังเคสผู้ป่วยรังสีวินิจฉัย (PACS Clinical Archive)',
    'case_files_subtitle': 'ประวัติผู้ป่วยจริง, ภาพสแกนหลายระนาบ และการตรวจพบความผิดปกติ',
    'pacs_repository': 'คลังข้อมูลภาพ PACS',
    'solved_cases': 'ทำแบบทดสอบแล้ว',
    'random_case': 'สุ่มเคสผู้ป่วย (Random Case)',
    'all_modalities': 'ทั้งหมด',
    'mri_cases': 'MRI สมองและกระดูกสันหลัง',
    'ct_cases': 'CT ปอด ทรวงอก และช่องท้อง',
    'xray_cases': 'ภาพเอกซเรย์ดิจิทัล (Digital X-Ray)',
    'patient_history_header': 'ประวัติและอาการสำคัญทางคลินิก (Clinical Presentation)',
    'symptoms_header': 'อาการแสดงสำคัญ (Key Symptoms)',
    'medical_history_header': 'ประวัติการเจ็บป่วยในอดีต (Medical History)',
    'quiz_header': 'คำถามทดสอบการสังเกตภาพรังสี (Radiologic Observation Quiz)',
    'findings_header': 'ผลการวินิจฉัยทางรังสีวิทยาขั้นสุดท้าย (Definitive Radiologic Findings)',
    'explanation_header': 'คำอธิบายเชิงฟิสิกส์และการวินิจฉัย (Radiologic & Pathological Explanation)',
    'pearls_header': 'ไข่มุกแห่งการเรียนรู้ทางคลินิก (Clinical Pearls & High-Yield Facts)',
    'disclaimer_note': 'ระบบนี้จัดทำขึ้นเพื่อการศึกษาและการเรียนรู้ทางการแพทย์เท่านั้น มิได้ใช้สำหรับการวินิจฉัยผู้ป่วยจริง',

    // RadTech Mode
    'radtech_title': 'สถานการณ์จำลองนักรังสีเทคนิค (RadTech Clinical Simulator)',
    'radtech_subtitle': 'แก้ไขปัญหาเครื่องสแกน อาร์ติแฟกต์ และการตัดสินใจตามมาตรฐานความปลอดภัย',
    'score_label': 'คะแนนการตัดสินใจ',
    'streak_label': 'สถิติถูกต้องต่อเนื่อง',
    'artifact_detected': 'อาร์ติแฟกต์ที่ตรวจพบ',
    'workstation_alert': 'การแจ้งเตือนจากระบบ',
    'dilemma_prompt': 'คำถามสถานการณ์จำลอง:',
    'options_header': 'ทางเลือกในการแก้ไขปัญหา:',
    'takeaways_header': 'ข้อคิดสำคัญสำหรับนักรังสีเทคนิค:',
    'competencies_header': 'ทักษะความรู้ที่ได้รับการประเมิน:',
    'random_scenario': 'สุ่มสถานการณ์ใหม่',
    'reset_score': 'รีเซ็ตคะแนน',

    // Modality Learning & Physics
    'physics_title': 'หลักการทางฟิสิกส์การเกิดภาพ (Imaging Physics Principle)',
    'sound_profile': 'ลักษณะเสียงขณะเครื่องทำงาน (Acoustic Profile)',
    'radiation_dose': 'ปริมาณรังสีที่ได้รับ (Radiation Dose)',
    'acquisition_time': 'ระยะเวลาในการตรวจ (Acquisition Time)',
    'tissue_contrast_level': 'ความละเอียดของเนื้อเยื่ออ่อน (Soft Tissue Contrast)',
    'sequences_header': 'ลำดับการสร้างภาพที่ใช้บ่อย (Clinical Pulse Sequences)',
    'hardware_header': 'ส่วนประกอบฮาร์ดแวร์สำคัญของเครื่อง (Key Hardware Subsystems)',
  };

  static const Map<String, String> _enDictionary = {
    // App & Nav
    'app_title': 'SCANVERSE — Interactive Medical Radiology Simulation',
    'app_subtitle': 'Interactive Radiologic Diagnostic OS & Clinical Learning Suite',
    'nav_home': 'HOME',
    'nav_explore': 'EXPLORE',
    'nav_scan': 'SCAN LAB',
    'nav_cases': 'CASE FILES',
    'nav_tech': 'RADTECH MODE',
    'nav_visual': 'VISUAL MODE',
    'language_switch': 'EN / ไทย',
    'lang_th': 'Thai',
    'lang_en': 'English',

    // Scan Simulation Lab
    'scan_lab_title': 'SCAN SIMULATION LAB',
    'scan_lab_subtitle': '5-Stage Clinical Radiologic Acquisition & Reconstruction Workflow',
    'reset_lab': 'RESET LAB',
    'step_1_patient': '1. PATIENT',
    'step_2_prep': '2. PREP',
    'step_3_position': '3. POSITION',
    'step_4_scan': '4. SCAN',
    'step_5_image': '5. IMAGE',

    // Patient Prep Card
    'patient_intake_title': 'PATIENT INTAKE & CLINICAL SCREENING',
    'patient_id': 'Patient Case ID',
    'patient_name': 'Patient Initials',
    'patient_age_gender': 'Age / Gender',
    'patient_indication': 'Clinical Indication',
    'patient_protocol': 'Exam Protocol',
    'safety_checklist_header': 'Safety Screening Checklist',
    'ferrous_metal_check': 'No metallic or electronic implants (Zone IV Ferromagnetic Safe)',
    'pacemaker_check': 'No cardiac pacemakers or intracranial aneurysm clips',
    'renal_function_check': 'Renal clearance verified (eGFR > 60 mL/min) for contrast',
    'claustrophobia_check': 'Patient screened for claustrophobia (Emergency bulb equipped)',
    'pregnancy_check': 'Pregnancy status verified negative (for ionizing modalities)',
    'prep_ready_btn': 'Confirm Safety & Proceed to Positioning',
    'screening_status': 'Screening Status',
    'screening_cleared': 'Zone IV Safety Cleared',
    'screening_warning': 'Complete safety checklist verification',

    // Laser Positioning HUD
    'laser_hud_title': 'LASER ALIGNMENT & SCOUT TOPOGRAM PLANNING',
    'isocenter_alignment': 'Isocenter Magnetic Alignment',
    'laser_crosshair': 'Optical Laser Crosshairs',
    'gantry_depth': 'Gantry Table Depth',
    'table_height': 'Table Height',
    'slice_thickness': 'Slice Thickness',
    'slice_gap': 'Slice Gap',
    'plane_angle': 'AC-PC Baseline Angle',
    'lock_position_btn': 'Lock Position & Proceed to Acquisition',

    // Scan Acquisition HUD
    'acquisition_title': 'REAL-TIME RF PULSE & GRADIENT ACQUISITION',
    'scanner_ready': 'SCANNER READY',
    'acquiring_kspace': 'ACQUIRING K-SPACE...',
    'sound_active': 'Acoustic Sound Synth Active',
    'sar_level': 'Specific Absorption Rate (SAR)',
    'snr_ratio': 'Signal-to-Noise Ratio (SNR)',
    'motion_simulation': 'Simulate Patient Motion Artifact',
    'start_scan_btn': 'START SCAN',
    'view_recon_btn': 'VIEW RECONSTRUCTED IMAGE',

    // K-Space Reconstruction
    'recon_title': '2D FAST FOURIER TRANSFORM (FFT) RECONSTRUCTION',
    'kspace_raw': 'K-Space Raw Frequency Domain',
    'image_domain': 'Diagnostic Image Domain',
    'center_kspace_info': 'K-Space Center controls overall image contrast and broad anatomical signal.',
    'periphery_kspace_info': 'K-Space Periphery controls spatial resolution, fine structural edges, and boundaries.',
    'recon_complete_btn': 'Open Diagnostic PACS Workstation',

    // DICOM Workstation / Slice Viewer
    'workstation_title': 'MULTI-SLICE DIAGNOSTIC PACS WORKSTATION',
    'slice_depth': 'SLICE DEPTH',
    'window_presets': 'Window Presets:',
    'win_brain': 'Brain',
    'win_stroke': 'Stroke/Ischemia',
    'win_subdural': 'Subdural/Blood',
    'win_bone': 'Bone',
    'win_soft_tissue': 'Soft Tissue',
    'win_lung': 'Lung',
    'plane_axial': 'Axial',
    'plane_sagittal': 'Sagittal',
    'plane_coronal': 'Coronal',
    'hu_density_probe': 'HU Tissue Density Probe',
    'tissue_type': 'Identified Tissue:',
    'caliper_measure': 'Measurement Caliper (mm)',
    'cine_loop': 'Cine Loop Auto-Play',
    'landmark_overlay': 'Anatomy & Pathology Landmarks',
    'invert_lut': 'Invert Grayscale LUT',
    'enter_visual_mode': 'ENTER CONCERT VISUAL MODE',

    // HU Tissue Types
    'hu_air': 'Air (-1000 HU) — Paranasal Sinuses / Ambient Air',
    'hu_fat': 'Adipose Tissue (-100 to -50 HU) — Subcutaneous Fat',
    'hu_water': 'Water / CSF (0 to +15 HU) — Ventricular Cerebrospinal Fluid',
    'hu_edema': 'Cerebral Edema (+15 to +25 HU) — Vasogenic / Cytotoxic Edema',
    'hu_white_matter': 'White Matter (+28 to +34 HU) — Subcortical Axonal Tracts',
    'hu_grey_matter': 'Grey Matter (+35 to +45 HU) — Cerebral Cortex',
    'hu_blood': 'Acute Hemorrhage (+60 to +85 HU) — Hyperdense Intracranial Hematoma',
    'hu_calcification': 'Calcification (+100 to +300 HU) — Dense Vascular / Dural Plaque',
    'hu_bone': 'Cortical Bone (+1000 to +2500 HU) — Skull Calvarium',

    // Case Files PACS
    'case_files_title': 'DIAGNOSTIC CASE FILES ARCHIVE',
    'case_files_subtitle': 'Clinical histories, multi-slice scans & diagnostic radiologic anomalies',
    'pacs_repository': 'PACS REPOSITORY',
    'solved_cases': 'Solved',
    'random_case': 'RANDOM CASE',
    'all_modalities': 'ALL',
    'mri_cases': 'MRI BRAIN & SPINE',
    'ct_cases': 'CT CHEST & ABDOMEN',
    'xray_cases': 'DIGITAL X-RAY',
    'patient_history_header': 'Clinical Presentation & History',
    'symptoms_header': 'Key Presenting Symptoms',
    'medical_history_header': 'Past Medical History',
    'quiz_header': 'Radiologic Observation Quiz',
    'findings_header': 'Definitive Radiologic Findings',
    'explanation_header': 'Physics & Pathological Explanation',
    'pearls_header': 'Clinical Pearls & High-Yield Facts',
    'disclaimer_note': 'Educational simulation only. Not for clinical diagnosis.',

    // RadTech Mode
    'radtech_title': 'RADTECH CLINICAL SIMULATOR',
    'radtech_subtitle': 'Solve clinical scan dilemmas, optimize parameters & eliminate artifacts',
    'score_label': 'Technician Score',
    'streak_label': 'Correct Streak',
    'artifact_detected': 'Detected Artifact',
    'workstation_alert': 'Workstation Alert',
    'dilemma_prompt': 'Clinical Dilemma Scenario:',
    'options_header': 'Select Correct Action Protocol:',
    'takeaways_header': 'Key RadTech Takeaway:',
    'competencies_header': 'Competencies Evaluated:',
    'random_scenario': 'Random Scenario',
    'reset_score': 'Reset Score',

    // Modality Learning & Physics
    'physics_title': 'Physics Principle & Signal Generation',
    'sound_profile': 'Acoustic Sound Profile',
    'radiation_dose': 'Radiation Dose Level',
    'acquisition_time': 'Acquisition Speed',
    'tissue_contrast_level': 'Soft Tissue Contrast',
    'sequences_header': 'Clinical Pulse Sequences',
    'hardware_header': 'Hardware Components',
  };
}

/// Global helper extension for easy translation access
extension StringLocalization on String {
  String get tr => LocalizationService().t(this);
}
