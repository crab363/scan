import '../models/imaging_modality.dart';
import '../models/technician_case.dart';

class TechnicianCasesData {
  static const List<TechnicianCase> cases = [
    TechnicianCase(
      id: 'tech_024',
      caseCode: 'CASE 024',
      title: 'MRI Brain - Severe Motion Ghosting Artifact',
      modality: ModalityType.mri,
      examName: 'MRI BRAIN NON-CONTRAST (T2 & FLAIR)',
      patientAge: 17,
      patientGender: 'Male',
      clinicalIndication: 'Severe post-concussion headache & vertigo following sports collision. Restless in scanner.',
      positioningStatus: 'Head coil locked; laser isocenter at nasion. Patient shifting during long sequences.',
      initialImageQuality: 62.0,
      detectedArtifact: 'PHASE-ENCODING MOTION GHOSTING',
      artifactDescription:
          'Periodic ghost artifacts propagating across the phase-encoding axis, blurring gray-white junction and sulcal details.',
      workstationAlert: 'WARNING: Signal-to-Noise degraded. Motion vectors corrupting k-space phase lines.',
      dilemmaQuestion:
          'Patient is restless and moving during the standard 5-minute T2 sequence. Image quality is 62%. What is the most effective RadTech action?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'REPOSITION PATIENT & APPLY PROPELLER / BLADE SEQUENCE',
          actionDescription:
              'Comfort patient via intercom, adjust foam head padding, and switch from Cartesian to radial k-space trajectory (PROPELLER/BLADE motion correction).',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Radial k-space sampling continuously oversamples the center of k-space, allowing mathematical phase correction that eliminates motion ghosting without needing sedation.',
          educationalTakeaway:
              'RadTechs use patient communication, stabilization pads, and advanced sequence engineering (PROPELLER/MultiVane) to achieve diagnostic quality in restless patients.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'REPEAT EXACT SAME SEQUENCE WITH NO PARAMETER CHANGES',
          actionDescription: 'Simply click re-scan on the workstation and hope the patient remains still for another 5 minutes.',
          isOptimal: false,
          scoreDelta: 20,
          outcomeExplanation:
              'Without addressing patient discomfort, anxiety, or sequence parameters, repeating the scan will likely produce identical motion artifacts, wasting scanner time.',
          educationalTakeaway:
              'Repeating an identical scan without intervention rarely fixes motion. Technologists must intervene with immobilization, sequence adaptation, or patient reassurance.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'CONTINUE SCAN AND SEND SUBOPTIMAL IMAGES TO RADIOLOGIST',
          actionDescription: 'Accept the 62% quality scan, mark study as completed, and dismiss the patient.',
          isOptimal: false,
          scoreDelta: -50,
          outcomeExplanation:
              'Suboptimal images may obscure subtle cortical contusions or subdural hygromas, requiring the patient to be recalled and delaying critical medical care.',
          educationalTakeaway:
              'A core competency of a Radiologic Technologist is quality assurance: never release non-diagnostic images without attempting remediation.',
        ),
      ],
      radTechCompetenciesTested: [
        'Artifact Recognition (Phase Ghosting)',
        'K-Space Trajectory Selection',
        'Patient Psychology & Immobilization',
        'Image Quality Governance',
      ],
    ),
    TechnicianCase(
      id: 'tech_108',
      caseCode: 'CASE 108',
      title: 'CT Pulmonary Angiography - Contrast Timing Failure',
      modality: ModalityType.ct,
      examName: 'CT PULMONARY ANGIOGRAPHY (CTPA)',
      patientAge: 58,
      patientGender: 'Female',
      clinicalIndication: 'Sudden onset pleuritic chest pain, tachycardia (HR 125 bpm), suspected acute Pulmonary Embolism.',
      positioningStatus: 'Supine, arms elevated above head, 18G IV in right antecubital fossa connected to dual injector.',
      initialImageQuality: 48.0,
      detectedArtifact: 'INSUFFICIENT MAIN PULMONARY ARTERY OPACIFICATION (HU < 180)',
      artifactDescription:
          'Scan triggered prematurely before contrast bolus peaked in pulmonary trunk; severe transient interruption of contrast by deep unguided inspiration.',
      workstationAlert: 'ALERT: ROI Hounsfield Unit attenuation measured at only 95 HU (Diagnostic threshold ≥ 210 HU).',
      dilemmaQuestion:
          'The test bolus trigger fired too early, resulting in inadequate pulmonary arterial opacification. Suspected PE cannot be ruled out. What is your protocol action?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'RE-CALCULATE BOLUS PEAK WITH TIMED SALINE CHASER & COACH BREATHING',
          actionDescription:
              'Review contrast injection rate (4.0 mL/s), implement automated bolus tracking over pulmonary trunk with 10s delay, and instruct patient on gentle breath-hold without Valsalva.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'A tight contrast bolus followed by saline chaser, combined with precise bolus tracking and avoiding deep inspiration (which draws unopacified IVC blood into the right heart), yields flawless >300 HU pulmonary enhancement.',
          educationalTakeaway:
              'CTPA timing is ultra-precise: deep Valsalva maneuvers ruin contrast density. Clear breathing coaching and bolus tracking are fundamental RadTech skills.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'INCREASE TUBE CURRENT (mAs) TO MAXIMUM WITHOUT CONTRAST ADJUSTMENT',
          actionDescription: 'Increase radiation dose in hopes that brighter pixels compensate for lack of intravascular iodine contrast.',
          isOptimal: false,
          scoreDelta: -30,
          outcomeExplanation:
              'Radiation dose does not increase iodine attenuation. You expose the patient to unnecessary ionizing radiation without solving the lack of vascular contrast.',
          educationalTakeaway:
              'Violates ALARA (As Low As Reasonably Achievable). Higher mAs improves signal-to-noise ratio but cannot create vascular contrast where iodine is absent.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'PERFORM CHEST X-RAY INSTEAD AND CANCEL CT SCAN',
          actionDescription: 'Give up on CT and take a portable AP chest radiograph.',
          isOptimal: false,
          scoreDelta: -80,
          outcomeExplanation:
              'Chest X-Ray cannot visualize intravascular pulmonary emboli and is not a substitute for diagnostic CTPA in acute life-threatening PE.',
          educationalTakeaway:
              'Modality selection must match clinical urgency. Technologists must master technical execution rather than downgrading indicated imaging studies.',
        ),
      ],
      radTechCompetenciesTested: [
        'Automated Bolus Tracking & Power Injection',
        'Physiology of Contrast Transit Time',
        'Patient Breathing Instructions',
        'Radiation Safety (ALARA Principles)',
      ],
    ),
    TechnicianCase(
      id: 'tech_042',
      caseCode: 'CASE 042',
      title: 'Digital X-Ray Lumbar Spine - Grid Cut-off & Underexposure',
      modality: ModalityType.xray,
      examName: 'AP & LATERAL LUMBAR SPINE (WEIGHT-BEARING)',
      patientAge: 45,
      patientGender: 'Male',
      clinicalIndication: 'Chronic severe lower back pain radiating to L5 dermatome. Rule out spondylolisthesis.',
      positioningStatus: 'Erect against vertical bucky stand. Central ray aimed at L3-L4 level.',
      initialImageQuality: 54.0,
      detectedArtifact: 'GRID CUT-OFF ARTIFACT (LATERAL DENSITY FALL-OFF)',
      artifactDescription:
          'Pronounced unilateral density loss across the periphery of the image due to central ray angulation misaligned with focused anti-scatter grid lead strips.',
      workstationAlert: 'WARNING: Exposure Index (EI) out of target range. Quantum mottle detected in bone cortex.',
      dilemmaQuestion:
          'The lateral lumbar image shows severe grid cut-off with quantum mottle on the vertebral bodies. How do you rectify the acquisition setup?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'ALIGN CENTRAL RAY PERPENDICULAR TO GRID & ADJUST mAs / SID',
          actionDescription:
              'Verify Source-to-Image Distance (SID 100cm), center the X-ray tube strictly perpendicular to the focal line of the anti-scatter grid, and use AEC center detector chamber.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Precise beam alignment prevents X-ray photons from being absorbed by the angled lead strips of the focused grid, restoring uniform optical density and sharp trabecular detail.',
          educationalTakeaway:
              'Understanding anti-scatter grid focal distance and perpendicular centering is critical to prevent grid cut-off and unnecessary patient re-exposures.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'REMOVE ANTI-SCATTER GRID COMPLETELY AND DOUBLE EXPOSURE TIME',
          actionDescription: 'Take the lateral lumbar spine without a grid and increase mAs.',
          isOptimal: false,
          scoreDelta: -40,
          outcomeExplanation:
              'In adult lumbar spine imaging, the thick tissue generates massive Compton scatter. Removing the grid causes total scatter fogging and loss of bony contrast.',
          educationalTakeaway:
              'Anatomy thicker than 10-12 cm requires an anti-scatter grid (typically 8:1 to 12:1 ratio) to absorb secondary scatter radiation.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'APPLY DIGITAL SHARPENING FILTER VIA POST-PROCESSING SOFTWARE ONLY',
          actionDescription: 'Digitally boost brightness and contrast on the console monitor without repeating the projection.',
          isOptimal: false,
          scoreDelta: 10,
          outcomeExplanation:
              'Digital post-processing cannot recover signal lost to grid absorption; it merely amplifies quantum noise and artifactual grain.',
          educationalTakeaway:
              'Software post-processing cannot fix underlying physics and geometric acquisition flaws. "Garbage in, garbage out" applies to digital radiography.',
        ),
      ],
      radTechCompetenciesTested: [
        'Beam Geometry & Grid Alignment',
        'Anti-Scatter Physics & Compton Management',
        'Automatic Exposure Control (AEC) Chambers',
        'Exposure Index (EI) Target Calibration',
      ],
    ),
    TechnicianCase(
      id: 'tech_073',
      caseCode: 'CASE 073',
      title: 'MRI Safety Screening - Undisclosed Metallic Implant',
      modality: ModalityType.mri,
      examName: 'MRI KNEE WITH 3.0 TESLA HIGH-FIELD SYSTEM',
      patientAge: 64,
      patientGender: 'Male',
      clinicalIndication: 'Suspected medial meniscus tear. Patient referred from outpatient orthopedic clinic.',
      positioningStatus: 'Patient seated on gurney outside Zone IV scanner room door.',
      initialImageQuality: 95.0,
      detectedArtifact: 'CRITICAL SAFETY CONTRAINDICATION (PRE-SCAN DISCOVERY)',
      artifactDescription:
          'During secondary ferromagnetic screening, ferromagnetic wand beeps near patient upper chest; patient mentions receiving a cardiac pacemaker 12 years ago.',
      workstationAlert: 'EMERGENCY SAFETY ALERT: Potential non-MR conditional cardiac implant identified!',
      dilemmaQuestion:
          'Patient states: "It is only my knee being scanned, not my chest, so the magnet won\'t affect my heart device, right?" How do you respond?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'HALT ENTRANCE TO ZONE IV, VERIFY DEVICE MAKE/MODEL & CARDIAC CLEARANCE',
          actionDescription:
              'Immediately hold the patient outside Zone IV. Explain that the 3.0T magnetic field is active 24/7 throughout the entire bore and room. Obtain exact device ID card and verify MR Conditional parameters.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'The static magnetic field (B0) is ALWAYS ON and does not stop at the knee. Non-conditional pacemakers can experience torque, reed-switch failure, thermal lead heating, or fatal arrhythmias in Zone IV.',
          educationalTakeaway:
              'Rule #1 of MRI Safety: The magnet is ALWAYS ON. MRI Technologists are the last line of defense protecting patients from lethal projectile and electromagnetic hazards.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'PROCEED WITH KNEE SCAN BUT KEEP SCAN TIME AS SHORT AS POSSIBLE',
          actionDescription: 'Bring patient into Zone IV, put knee in coil quickly, and run a fast 5-minute protocol.',
          isOptimal: false,
          scoreDelta: -100,
          outcomeExplanation:
              'Catastrophic error: entering Zone IV with an unverified pacemaker can induce ventricular fibrillation or lead displacement within seconds of entering the fringe magnetic field.',
          educationalTakeaway:
              'Never compromise MRI safety for speed. Zone IV access without verified MR Conditional status is a critical medical negligence violation.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'WRAP PATIENT CHEST IN LEAD APRON TO BLOCK THE MAGNETIC FIELD',
          actionDescription: 'Put two lead aprons over the patient’s chest and proceed with scan.',
          isOptimal: false,
          scoreDelta: -90,
          outcomeExplanation:
              'Lead blocks X-rays (ionizing radiation), but has ZERO effect on static magnetic fields or RF waves. It provides no protection in an MRI environment.',
          educationalTakeaway:
              'Common misconception: Lead shields ionizing radiation (X-ray/CT), not magnetism. MRI shielding requires copper/aluminum Faraday cages and passive steel shimming.',
        ),
      ],
      radTechCompetenciesTested: [
        'MRI Safety Zones (Zone I to IV)',
        'Implant & Device Screening Governance',
        'Electromagnetic Physics vs Ionizing Shielding',
        'Patient Advocacy & Crisis Prevention',
      ],
    ),
    TechnicianCase(
      id: 'tech_201',
      caseCode: 'CASE 201',
      title: 'Hyperacute Stroke Code - Protocol Speed vs Quality Optimization',
      modality: ModalityType.mri,
      examName: 'CODE STROKE RAPID MRI BRAIN',
      patientAge: 71,
      patientGender: 'Male',
      clinicalIndication: 'Last seen normal 75 minutes ago. Right-sided hemiplegia and acute expressive aphasia (NIHSS 16).',
      positioningStatus: 'Emergency stretcher dock. Time is brain: Door-to-Needle window closing fast.',
      initialImageQuality: 78.0,
      detectedArtifact: 'TIME-CRITICAL PROTOCOL EXECUTION',
      artifactDescription:
          'Need to rapidly verify salvageable ischemic penumbra and rule out intracranial hemorrhage within 6 minutes total table time.',
      workstationAlert: 'STROKE ALERT: Rapid assessment protocol activated for thrombolytic / thrombectomy candidate.',
      dilemmaQuestion:
          'What is the most clinically vital sequence priority for acute stroke protocol triage?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'RUN ULTRAFAST DWI/ADC + GRE/SWI + TOF-MRA (TOTAL TABLE TIME < 6 MIN)',
          actionDescription:
              'Execute DWI/ADC to detect cytotoxic ischemic core, T2*/SWI to rule out hemorrhage, and Time-of-Flight MRA of Circle of Willis to pinpoint large vessel occlusion (LVO).',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'DWI shows acute ischemia in <2 minutes, SWI rules out hemorrhage, and TOF-MRA identifies LVO (e.g. M1 segment MCA clot) for immediate mechanical thrombectomy triage.',
          educationalTakeaway:
              'In neurovascular emergencies, "Time is Brain" (1.9 million neurons lost per minute). RadTechs must execute streamlined, high-yield protocols with extreme speed.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'RUN A 45-MINUTE HIGH-RESOLUTION 3D ISOTROPIC T1/T2 ANATOMICAL STUDY',
          actionDescription: 'Perform full comprehensive routine brain imaging with ultra-thin 0.5mm slices.',
          isOptimal: false,
          scoreDelta: -70,
          outcomeExplanation:
              'A 45-minute scan exhausts the therapeutic window for IV thrombolysis (tPA/TNK) and endovascular thrombectomy, causing irreversible neuronal death.',
          educationalTakeaway:
              'Protocols must be tailored to clinical urgency. Emergency code protocols prioritize life-saving speed over cosmetic resolution.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'ADMINISTER IV GADOLINIUM CONTRAST IMMEDIATELY BEFORE ANY SEQUENCE',
          actionDescription: 'Inject contrast agent right away without running non-contrast baseline sequences.',
          isOptimal: false,
          scoreDelta: -60,
          outcomeExplanation:
              'Acute stroke core does not enhance immediately on early contrast sequences, and contrast delays emergency imaging while obscuring baseline hemorrhage.',
          educationalTakeaway:
              'Non-contrast DWI and T2*/SWI are the primary diagnostic drivers in acute stroke triage.',
        ),
      ],
      radTechCompetenciesTested: [
        'Stroke Protocol Prioritization',
        'Diffusion-Weighted Physics (DWI / ADC)',
        'Vascular MRA Time-of-Flight Acquisition',
        'Emergency Clinical Time-Critical Workflow',
      ],
    ),
  ];
}
