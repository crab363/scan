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
    TechnicianCase(
      id: 'tech_305',
      caseCode: 'CASE 305',
      title: 'MRI Specific Absorption Rate (SAR) Limit Warning',
      modality: ModalityType.mri,
      examName: '3.0T MRI LUMBAR SPINE (FSE T2 & T1)',
      patientAge: 52,
      patientGender: 'Female',
      clinicalIndication: 'Severe sciatica, radicular pain. Patient body weight: 102 kg.',
      positioningStatus: 'Supine in 3.0 Tesla magnet. Spine phased-array coil active.',
      initialImageQuality: 70.0,
      detectedArtifact: 'WORKSTATION HARD INTERLOCK: PREDICTED SAR EXCEEDS 4.0 W/kg',
      artifactDescription:
          'High RF power deposition from fast spin echo (FSE) 180-degree refocusing pulse train pushing whole-body SAR into first-level controlled operating mode.',
      workstationAlert: 'SAR LIMIT EXCEEDED: Cannot start sequence. Patient thermal heating risk.',
      dilemmaQuestion:
          'The 3.0T scanner locks out the protocol due to excessive RF power deposition (SAR). How do you adjust sequence physics to reduce SAR without sacrificing diagnostic slices?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'REDUCE REFOCUSING FLIP ANGLE, INCREASE TR, & DECREASE ECHO TRAIN LENGTH (ETL)',
          actionDescription:
              'Lower the refocusing pulse from 180° to 140° (hyperecho/SPACE), increase Repetition Time (TR), and slightly decrease turbo factor/ETL to disperse RF power.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'RF power deposition scales quadratically with flip angle (SAR ∝ B1² · θ² · DutyCycle). Dropping the flip angle to 140° reduces RF power by over 40% while preserving T2 contrast.',
          educationalTakeaway:
              'SAR management in 3T MRI requires RF pulse engineering: lowering flip angles and lengthening TR are the most effective ways to avoid patient thermal burns.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'OVERRIDE THE SAFETY SYSTEM AND FORCE SCAN AT MAXIMUM POWER',
          actionDescription: 'Bypass manufacturer safety limits in service mode and execute the scan.',
          isOptimal: false,
          scoreDelta: -100,
          outcomeExplanation:
              'Bypassing SAR limits can cause severe internal tissue heating, skin blisters, and core body hyperthermia, violating medical device safety regulations.',
          educationalTakeaway:
              'Never attempt to bypass FDA/IEC SAR safety interlocks. Patient thermal safety is paramount.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'TURN SCANNER AIR CONDITIONING DOWN TO 14°C TO COOL THE BORE',
          actionDescription: 'Assume ambient room air cooling will compensate for internal tissue dielectric heating.',
          isOptimal: false,
          scoreDelta: -40,
          outcomeExplanation:
              'External air cooling does not cool deep vascular or internal organs where RF dielectric energy is deposited.',
          educationalTakeaway:
              'RF energy is absorbed in deep tissues. Room temperature adjustment does not resolve sequence-induced SAR.',
        ),
      ],
      radTechCompetenciesTested: [
        'RF Deposition & SAR Physics (B1² scaling)',
        'FSE Flip Angle Modulation',
        'Thermal Burn Prevention',
        '3.0T High-Field Parameter Optimization',
      ],
    ),
    TechnicianCase(
      id: 'tech_312',
      caseCode: 'CASE 312',
      title: 'Pediatric CT Abdomen - Radiation Dose Modulation (ALARA)',
      modality: ModalityType.ct,
      examName: 'CT ABDOMEN & PELVIS WITH IV CONTRAST',
      patientAge: 6,
      patientGender: 'Female',
      clinicalIndication: 'Suspected perforated appendicitis with high fever and RLQ guarding. Weight: 20 kg.',
      positioningStatus: 'Supine on CT couch with pediatric immobilization cradle.',
      initialImageQuality: 88.0,
      detectedArtifact: 'ADULT PROTOCOL LOADED BY DEFAULT (CTDIvol: 16.5 mGy)',
      artifactDescription:
          'Default scanner protocol set to standard 120 kVp / 250 mAs adult protocol, which would severely over-irradiate this 20 kg child.',
      workstationAlert: 'DOSE ALERT: High CTDIvol for pediatric patient habitus (SSDE exceeds DRL threshold).',
      dilemmaQuestion:
          'A 6-year-old child needs an urgent CT abdomen. The console loaded the adult protocol. How do you optimize technical factors for pediatric ALARA?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'LOWER TO 80 kVp, ACTIVATE PEDIATRIC ATCM & ITERATIVE RECONSTRUCTION (ASIR-V)',
          actionDescription:
              'Reduce tube voltage to 80 kVp (which increases iodine k-edge contrast), activate weight-based automatic tube current modulation, and enable high-level Model-Based Iterative Reconstruction.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              '80 kVp brings the photon energy closer to iodine k-edge (33.2 keV), dramatically boosting vascular and parenchymal contrast while reducing radiation dose by >60% (CTDIvol < 3.5 mGy).',
          educationalTakeaway:
              'Image Gently: Children are up to 10x more radiosensitive than adults. Lower kVp (70-80 kVp) and iterative reconstruction provide exceptional diagnostic quality at minimal dose.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'PROCEED WITH 120 kVp TO ENSURE ABSOLUTE ZERO NOISE IN IMAGES',
          actionDescription: 'Run the adult 120 kVp protocol to make the images look cosmetically smooth.',
          isOptimal: false,
          scoreDelta: -80,
          outcomeExplanation:
              'Cosmetic smoothness is not the clinical goal. Exposing a 6-year-old child to adult doses dramatically increases lifetime attributable cancer risk.',
          educationalTakeaway:
              'ALARA principle: The goal of diagnostic radiography is diagnostic quality, not noiseless overexposure.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'DOUBLE THE SCAN LENGTH TO INCLUDE CHEST AND LOWER EXTREMITIES JUST IN CASE',
          actionDescription: 'Scan from chin to toes to avoid any possibility of missing incidental findings.',
          isOptimal: false,
          scoreDelta: -90,
          outcomeExplanation:
              'Scanning outside the clinically indicated anatomical region violates ALARA and exposes thyroid and gonads to unnecessary primary radiation.',
          educationalTakeaway:
              'Strict collimation to the indicated clinical region is a mandatory radiation protection duty.',
        ),
      ],
      radTechCompetenciesTested: [
        'Pediatric Radiation Protection (Image Gently)',
        'Iodine K-Edge Physics at 80 kVp',
        'Size-Specific Dose Estimate (SSDE)',
        'Iterative Reconstruction Algorithms',
      ],
    ),
    TechnicianCase(
      id: 'tech_318',
      caseCode: 'CASE 318',
      title: 'MRI Phase Wrap-Around (Aliasing) Artifact in Shoulder',
      modality: ModalityType.mri,
      examName: 'MRI RIGHT SHOULDER (CORONAL OBLIQUE T2 FS)',
      patientAge: 38,
      patientGender: 'Male',
      clinicalIndication: 'Rotator cuff supraspinatus tear after weightlifting injury.',
      positioningStatus: 'Dedicated shoulder coil; arm in slight external rotation.',
      initialImageQuality: 58.0,
      detectedArtifact: 'PHASE-ENCODING ALIASING (WRAP-AROUND)',
      artifactDescription:
          'The patient’s contralateral chest and neck tissues outside the small Field of View (FOV 16cm) wrap around and superimpose directly over the glenohumeral joint.',
      workstationAlert: 'WARNING: Sub-Nyquist sampling detected along phase-encoding gradient direction.',
      dilemmaQuestion:
          'The torso is wrapping across the rotator cuff on the small FOV image. How do you eliminate this aliasing artifact without sacrificing high resolution?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'ENABLE PHASE OVERSAMPLING (NO PHASE WRAP) OR SWAP PHASE/FREQ AXIS',
          actionDescription:
              'Activate 100% Phase Oversampling (extends sampling window in phase direction outside FOV without changing spatial resolution) and verify phase encoding is Superoinferior or Anteroposterior.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Phase oversampling samples k-space beyond the visible display matrix, completely filtering out tissue outside FOV without altering in-plane spatial resolution.',
          educationalTakeaway:
              'Aliasing occurs when anatomy exceeds FOV along the phase-encoding axis. Phase oversampling (No Phase Wrap) is the gold-standard fix in musculoskeletal MRI.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'INCREASE FIELD OF VIEW (FOV) TO 45 CM TO FIT THE ENTIRE UPPER BODY',
          actionDescription: 'Expand FOV from 16cm to 45cm to encompass the whole chest.',
          isOptimal: false,
          scoreDelta: 10,
          outcomeExplanation:
              'Expanding FOV to 45cm stops wrapping, but drastically degrades in-plane spatial resolution (pixel size = FOV/Matrix), making subtle tendon tears invisible.',
          educationalTakeaway:
              'Large FOV kills MSK resolution. Maintain small FOV (14-16 cm) and use phase oversampling instead.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'CUT OFF THE PATIENT CONTRALATERAL ARM ON THE SCANNER CONSOLE POST-SCAN',
          actionDescription: 'Crop the image in PACS viewer after acquisition.',
          isOptimal: false,
          scoreDelta: -50,
          outcomeExplanation:
              'Cropping cannot remove data that has already wrapped and overwritten the glenohumeral voxels during Fourier transformation.',
          educationalTakeaway:
              'Aliasing happens in k-space during acquisition; it cannot be removed by post-acquisition cropping.',
        ),
      ],
      radTechCompetenciesTested: [
        'Nyquist Sampling Limit & Aliasing Physics',
        'Phase Oversampling (No Phase Wrap)',
        'Frequency vs Phase Gradient Orientation',
        'MSK High-Resolution FOV Optimization',
      ],
    ),
    TechnicianCase(
      id: 'tech_324',
      caseCode: 'CASE 324',
      title: 'CT Metal Artifact Reduction - Bilateral Hip Prostheses',
      modality: ModalityType.ct,
      examName: 'CT PELVIS WITH CONTRAST',
      patientAge: 74,
      patientGender: 'Male',
      clinicalIndication: 'Pelvic trauma / hematoma rule out. Patient has bilateral titanium total hip replacements.',
      positioningStatus: 'Supine in 64-slice CT gantry.',
      initialImageQuality: 42.0,
      detectedArtifact: 'SEVERE BEAM HARDENING & PHOTON STARVATION STREAK ARTIFACT',
      artifactDescription:
          'Dark streaks and bright starburst artifacts radiating across the bladder, prostate, and iliac vessels due to dense metallic femoral stems absorbing X-ray photons.',
      workstationAlert: 'WARNING: Total photon starvation across central pelvic soft tissues.',
      dilemmaQuestion:
          'Massive beam hardening streaks from the metal hip implants obliterate pelvic soft tissue visualization. How do you configure acquisition & reconstruction to restore diagnostic quality?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'APPLY DEDICATED ORTHOPEDIC METAL ARTIFACT REDUCTION (SEMAR/iMAR) & INCREASE kVp',
          actionDescription:
              'Enable projection-space Metal Artifact Reduction software (MARS/iMAR/SEMAR), increase tube voltage to 140 kVp for beam penetration, and reconstruct with high-energy virtual monochromatic cuts (Dual Energy / Spectral).',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Higher beam energy (140 kVp / 130 keV virtual monochromatic) minimizes photon starvation, while projection-interpolation MAR algorithms replace corrupted detector rays, restoring clear pelvic soft tissue margins.',
          educationalTakeaway:
              'Metal artifacts combine photon starvation and beam hardening. Modern RadTechs combine higher photon energy (140 kVp) with iterative metal artifact reduction (O-MAR/iMAR) for pelvic orthopedic imaging.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'LOWER kVp TO 70 TO MINIMIZE RADIATION DOSE',
          actionDescription: 'Reduce kVp to 70 kVp.',
          isOptimal: false,
          scoreDelta: -70,
          outcomeExplanation:
              'Low-energy photons cannot penetrate titanium/cobalt-chrome metal, leading to total photon starvation and 100% blacked-out streak artifacts.',
          educationalTakeaway:
              'Dense metal requires penetrating photon beam energy. Low kVp exacerbates metal streak artifact catastrophically.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'SEND PATIENT TO MRI INSTEAD WITHOUT VERIFYING IMPLANTS',
          actionDescription: 'Switch immediately to 3.0T MRI.',
          isOptimal: false,
          scoreDelta: -60,
          outcomeExplanation:
              'Large bilateral metallic hips create even larger geometric distortion voids on MRI (up to 10cm susceptibility loss) unless specialized MAVRIC/WARP sequences are available.',
          educationalTakeaway:
              'Metal creates severe susceptibility voids on MRI. CT with iMAR/SEMAR is generally superior for pelvic soft tissues around extensive bilateral prostheses.',
        ),
      ],
      radTechCompetenciesTested: [
        'Photon Starvation & Beam Hardening Physics',
        'Metal Artifact Reduction Software (iMAR/SEMAR)',
        'Dual-Energy & Monochromatic Reconstruction',
        'Orthopedic Imaging Protocol Governance',
      ],
    ),
    TechnicianCase(
      id: 'tech_330',
      caseCode: 'CASE 330',
      title: 'Digital X-Ray Cervical Spine - C7-T1 Swimmer\'s Lateral View',
      modality: ModalityType.xray,
      examName: 'LATERAL CERVICAL SPINE (TRAUMA SERIES)',
      patientAge: 29,
      patientGender: 'Male',
      clinicalIndication: 'High-speed motor vehicle collision with rigid cervical collar. Must visualize C1 through T1.',
      positioningStatus: 'Supine on trauma backboard with Philadelphia collar locked in place.',
      initialImageQuality: 50.0,
      detectedArtifact: 'ANATOMICAL CUT-OFF / SHOULDER SHADOW SUPERIMPOSITION',
      artifactDescription:
          'Dense musculature and humeral heads of both shoulders completely obscure the C7 vertebral body, C7-T1 disc space, and upper thoracic junction.',
      workstationAlert: 'INCOMPLETE TRAUMA EXAM: C7-T1 cervicothoracic junction not cleared for c-spine clearance.',
      dilemmaQuestion:
          'On the initial cross-table lateral c-spine, C7-T1 is obscured by broad muscular shoulders. The trauma team needs cervical clearance. What is the standard radiologic technologist projection?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'PERFORM TWINING / SWIMMER\'S LATERAL PROJECTION (OR CAUDAL CENTRAL RAY TILT)',
          actionDescription:
              'Elevate the arm closest to the bucky above the head, depress the opposite shoulder, and angle the central ray 3-5° caudad toward C7-T1 to project humeral heads apart.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'The Swimmer\'s (Twining) projection separates the two shoulder girdles vertically, projecting the distal shoulder below T1 and the proximal shoulder above C7, clearly uncovering the C7-T1 junction.',
          educationalTakeaway:
              'A trauma c-spine is non-diagnostic until the C7-T1 junction is clearly seen. The Swimmer\'s view (or rapid CT reformats) is a vital competency for trauma technologists.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'REMOVE THE CERVICAL COLLAR AND FORCE PATIENT TO SIT ERECT',
          actionDescription: 'Take off the neck collar and force the injured trauma patient to sit up.',
          isOptimal: false,
          scoreDelta: -100,
          outcomeExplanation:
              'Removing cervical spinal precautions before radiographic clearance in acute trauma risks permanent spinal cord transection and quadriplegia.',
          educationalTakeaway:
              'Never remove cervical immobilization in uncleared trauma without direct written order from the attending trauma surgeon.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'SIGN OFF THE STUDY AS COMPLETED WITH ONLY C1-C5 VISIBLE',
          actionDescription: 'Send the image to PACS and state that C7-T1 could not be seen due to body habitus.',
          isOptimal: false,
          scoreDelta: -80,
          outcomeExplanation:
              'Over 20% of traumatic cervical spine subluxations and jumped facets occur at the C7-T1 junction. Missing this junction leads to missed spinal instability.',
          educationalTakeaway:
              'C7-T1 visualization is non-negotiable in cervical clearance protocols.',
        ),
      ],
      radTechCompetenciesTested: [
        'Trauma Radiography Positioning (Swimmer’s / Twining)',
        'Spinal Clearance Anatomy & Protocols',
        'Immobilization Safety & Medicolegal Standards',
        'Central Ray Angulation & Beam Geometry',
      ],
    ),
    TechnicianCase(
      id: 'tech_336',
      caseCode: 'CASE 336',
      title: 'MRI RF Burn Prevention - ECG Leads & Body Contact Loops',
      modality: ModalityType.mri,
      examName: 'CARDIAC MRI WITH CINÉ & LATE GADOLINIUM ENHANCEMENT',
      patientAge: 49,
      patientGender: 'Female',
      clinicalIndication: 'Suspected acute myocarditis; patient prepped with MR-conditional wireless ECG telemetry.',
      positioningStatus: 'Supine in bore. Arms resting against lateral bore walls; bare calves crossed over each other.',
      initialImageQuality: 92.0,
      detectedArtifact: 'CRITICAL PRE-ACQUISITION THERMAL BURN HAZARD',
      artifactDescription:
          'Patient has legs crossed (skin-to-skin closed conductive loop) and right forearm in direct contact with the RF transmit body coil bore cover.',
      workstationAlert: 'SAFETY CHECK: Conductive loops and bore touchpoints detected on positioning camera.',
      dilemmaQuestion:
          'During cardiac MRI setup, the patient has crossed ankles and bare arms touching the magnet inner bore. What action must you take before running the high-SAR SSFP sequence?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'PLACE 10mm FOAM PADS BETWEEN SKIN CONTACTS AND BORE WALL TO PREVENT CLOSED LOOPS',
          actionDescription:
              'Uncross patient legs, place a foam pad between knees/calves, ensure at least 1-2 cm of foam insulation between arms and scanner bore walls, and verify ECG lead cables run straight with no loops.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'RF transmit pulses induce eddy currents in conductive tissue loops and capacitive coupling at skin-to-skin or skin-to-bore touchpoints. Proper foam insulation prevents high-voltage capacitive RF arc burns.',
          educationalTakeaway:
              'RF burns are the #1 most common MRI patient safety incident. Always enforce the "No skin-to-skin contact, no skin-to-bore contact, no looped cables" rule with minimum 10mm padding.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'PROCEED WITH SCAN BECAUSE THE PATIENT IS NOT WEARING JEWELRY',
          actionDescription: 'Start the scan since no external metallic jewelry was found.',
          isOptimal: false,
          scoreDelta: -90,
          outcomeExplanation:
              'Skin-to-skin conductive loops (crossed legs/fingers) conduct RF currents without any metal present, causing 2nd and 3rd-degree contact burns at the touchpoint.',
          educationalTakeaway:
              'Skin is an electrical conductor. Crossing legs creates a closed conductive circuit for RF induction heating.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'TIE ECG MONITOR CABLES IN A TIGHT BUNDLE TO KEEP THEM NEAT',
          actionDescription: 'Loop ECG cables into concentric rings with rubber bands.',
          isOptimal: false,
          scoreDelta: -100,
          outcomeExplanation:
              'Coiling or looping ECG cables acts as an induction transformer, concentrating massive RF electromagnetic energy and creating catastrophic wire burns.',
          educationalTakeaway:
              'Never loop monitor cables. All cables must run straight down the center of the table without crossover.',
        ),
      ],
      radTechCompetenciesTested: [
        'MRI RF Burn Mechanisms & Capacitive Coupling',
        'Conductive Loop Prevention & Insulation Padding',
        'ECG Lead Cable Management',
        'Patient Safety Incident Prevention',
      ],
    ),
    TechnicianCase(
      id: 'tech_342',
      caseCode: 'CASE 342',
      title: 'CT High-Pressure Contrast Extravasation Emergency',
      modality: ModalityType.ct,
      examName: 'CT ABDOMEN/PELVIS TRI-PHASIC LIVER',
      patientAge: 61,
      patientGender: 'Female',
      clinicalIndication: 'Cirrhosis, hepatocellular carcinoma surveillance. Injection rate: 4.5 mL/s.',
      positioningStatus: 'Supine in 128-slice CT. 20G IV placed in dorsal hand connected to dual power injector.',
      initialImageQuality: 40.0,
      detectedArtifact: 'POWER INJECTOR PRESSURE SPIKE (>300 PSI) & SUDDEN ARM SWELLING',
      artifactDescription:
          '15 seconds into 4.5 mL/s injection, power injector detects resistance spike; patient screams of severe burning and swelling in dorsal hand.',
      workstationAlert: 'EMERGENCY INJECTOR SHUTDOWN: Contrast extravasation suspected in peripheral IV site.',
      dilemmaQuestion:
          'A high-pressure contrast injection has extravasated 70 mL of hyperosmolar iodinated contrast into the patient\'s hand soft tissues. What is the immediate RadTech emergency protocol?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'STOP INJECTION, REMOVE NEEDLE, ELEVATE LIMB, APPLY COLD COMPRESS, & NOTIFY MD FOR COMPARTMENT SYNDROME EVALUATION',
          actionDescription:
              'Instantly halt injector, aspirate residual contrast if possible, gently remove catheter, elevate the affected extremity above heart level, apply cold packs to reduce swelling, document extravasation volume, and request immediate physician exam for distal neurovascular pulse check.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'High-volume (>50 mL) contrast extravasation into small fascial compartments (like the dorsal hand) carries severe risk of skin necrosis and acute Compartment Syndrome. Elevation, cold compress, and surgical/physician consultation are mandatory.',
          educationalTakeaway:
              'Power injection at >3 mL/s should ideally utilize an 18-20G IV in the antecubital fossa, not fragile hand veins. Rapid response to extravasation prevents surgical compartment fasciotomy emergencies.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'RE-START INJECTOR AT 6.0 mL/s TO BLOW THROUGH THE VEIN OBSTRUCTION',
          actionDescription: 'Increase injection pressure to force contrast into the vein.',
          isOptimal: false,
          scoreDelta: -100,
          outcomeExplanation:
              'Pumping more contrast into extravasated subcutaneous space causes total tissue necrosis and limb-threatening compartment ischemia.',
          educationalTakeaway:
              'Never re-inject into an extravasated line. Immediate cessation is critical.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'MASSAGE THE HAND VIGOROUSLY WITH HOT OIL AND DISMISS PATIENT HOME',
          actionDescription: 'Rub the swollen hand vigorously and send the patient home with no medical notification.',
          isOptimal: false,
          scoreDelta: -90,
          outcomeExplanation:
              'Vigorous massage ruptures fragile capillary beds and worsens tissue maceration. Failing to document and assess for compartment syndrome is severe malpractice.',
          educationalTakeaway:
              'Extravasation requires elevation, cold/warm pack protocol per hospital policy, volume documentation, and physician assessment.',
        ),
      ],
      radTechCompetenciesTested: [
        'Contrast Power Injection Site Selection',
        'Extravasation Emergency Protocol',
        'Compartment Syndrome Recognition',
        'Patient Care & Risk Governance',
      ],
    ),
    TechnicianCase(
      id: 'tech_348',
      caseCode: 'CASE 348',
      title: 'Digital Radiography - Exposure Creep & AEC Sensor Selection',
      modality: ModalityType.xray,
      examName: 'PA CHEST RADIOGRAPH (HIGH kVp TECHNIQUE)',
      patientAge: 32,
      patientGender: 'Male',
      clinicalIndication: 'Pre-operative clearance for elective knee arthroscopy. Healthy non-smoker.',
      positioningStatus: 'Erect PA at 180cm SID against upright detector.',
      initialImageQuality: 98.0,
      detectedArtifact: 'EXPOSURE CREEP (EXPOSURE INDEX EI: 850 vs TARGET EI: 250)',
      artifactDescription:
          'Digital image looks crisp on the monitor, but Exposure Index indicates the patient received 3.4x the necessary diagnostic radiation dose due to manual over-technique.',
      workstationAlert: 'QA ALERT: DI (Deviation Index) = +5.3 (Extreme Gross Overexposure).',
      dilemmaQuestion:
          'Digital detector post-processing automatically masks overexposure by rescaling brightness, hiding the fact that the patient received 340% excess radiation. What is the correct quality assurance corrective action?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'CALIBRATE AEC DETECTOR CHAMBERS (LEFT & RIGHT) WITH 110-120 kVp HIGH-kVp TECHNIQUE',
          actionDescription:
              'Select both peripheral AEC ionization chambers over the lung fields (deselecting center spine chamber), set 110-120 kVp, and rely on AEC termination to maintain Target Exposure Index (EI ~ 250, DI within -0.5 to +0.5).',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Digital radiography systems feature wide dynamic range, automatically scaling overexposed images to look visually "perfect." Monitoring Deviation Index (DI) and utilizing correct AEC chambers prevents unethical "Exposure Creep."',
          educationalTakeaway:
              'Exposure Creep is the silent hazard of digital radiography. Technologists must monitor EI/DI numbers on every single exposure, not just visual monitor appearance.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'IGNORE EXPOSURE INDEX SINCE THE PICTURE LOOKS VERY CLEAR ON PACS',
          actionDescription: 'Disregard the EI readout as long as the radiologist does not complain.',
          isOptimal: false,
          scoreDelta: -70,
          outcomeExplanation:
              'Ignoring DI numbers systematically overdoses hundreds of patients over time, violating radiation protection laws and ALARA tenets.',
          educationalTakeaway:
              'EI and DI are mandatory quality control telemetry. High DI indicates unjustified patient dose.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'USE CENTER AEC CHAMBER ONLY OVER THE DENSE THORACIC SPINE',
          actionDescription: 'Activate the middle spine AEC cell for a routine PA chest.',
          isOptimal: false,
          scoreDelta: -40,
          outcomeExplanation:
              'The center cell will wait for dense thoracic vertebrae to receive adequate exposure, severely over-penetrating and burning out both lung parenchyma.',
          educationalTakeaway:
              'PA chest requires the two outer lung chambers. Center chamber is reserved for lateral chest or spine imaging.',
        ),
      ],
      radTechCompetenciesTested: [
        'Exposure Creep & Digital Dynamic Range',
        'Exposure Index (EI) & Deviation Index (DI)',
        'Automatic Exposure Control (AEC) Chamber Selection',
        'ALARA Radiation Ethics',
      ],
    ),
    TechnicianCase(
      id: 'tech_354',
      caseCode: 'CASE 354',
      title: 'Fluoroscopy / C-Arm - Radiation Dose & Scatter Geometry',
      modality: ModalityType.xray,
      examName: 'INTRAOPERATIVE C-ARM FLUOROSCOPY (FEMORAL NAILING)',
      patientAge: 41,
      patientGender: 'Male',
      clinicalIndication: 'Orthopedic surgical fixation of mid-shaft femur fracture.',
      positioningStatus: 'Operating Room table. C-arm positioned in lateral projection.',
      initialImageQuality: 75.0,
      detectedArtifact: 'HIGH SURGICAL SCATTER RADIATION TO OPERATOR & STAFF',
      artifactDescription:
          'X-ray tube positioned above the patient table directing primary beam downward with Image Intensifier below, causing maximum backscatter radiation toward surgeon and tech eyes/thyroid.',
      workstationAlert: 'WARNING: Cumulative Air Kerma Rate high. High scatter field around OR table.',
      dilemmaQuestion:
          'During C-arm fluoroscopy, where should the X-ray tube and Image Intensifier / Flat Panel Detector be oriented to minimize scatter dose to the surgical team?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'POSITION X-RAY TUBE UNDER THE PATIENT & DETECTOR AS CLOSE AS POSSIBLE TO PATIENT TOP',
          actionDescription:
              'Orient the C-arm with the X-ray tube below the table (scattering radiation down into floor/lead aprons) and bring the Flat Panel Detector down directly onto patient skin surface, reducing pulse rate to 7.5 fps.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Backscatter radiation is greatest on the tube side. Keeping the tube under the table directs scatter toward the floor and lower lead shielding, while keeping the detector close to the patient reduces dose and magnification blur.',
          educationalTakeaway:
              'Fluoroscopy golden rules: Tube under the table, detector close to patient, pulse rate minimized (7.5 fps vs continuous 30 fps cuts dose by 75%), and step back (Inverse Square Law).',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'PUT X-RAY TUBE AT EYE LEVEL 30 CM FROM SURGEON WITH 30 FPS CONTINUOUS BEAM',
          actionDescription: 'Position tube high and run maximum framerate.',
          isOptimal: false,
          scoreDelta: -100,
          outcomeExplanation:
              'Directs massive secondary scatter straight into eyes (cataract risk) and thyroid, while continuous fluoroscopy delivers 4x unnecessary dose.',
          educationalTakeaway:
              'Tube above table exposes operator head and neck to intense scatter radiation.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'REMOVE LEAD DRAPES UNDER TABLE TO SAVE WEIGHT ON C-ARM',
          actionDescription: 'Take off all table-side lead shielding skirts.',
          isOptimal: false,
          scoreDelta: -80,
          outcomeExplanation:
              'Removing under-table lead skirts allows full scatter radiation to strike the lower body and gonads of operating room staff.',
          educationalTakeaway:
              'Under-table lead shielding attenuates over 90% of scatter radiation in surgical suites.',
        ),
      ],
      radTechCompetenciesTested: [
        'C-Arm Geometry & Scatter Radiation Distribution',
        'Inverse Square Law & Distance Protection',
        'Pulsed Fluoroscopy Rate Management (7.5 fps)',
        'Occupational Radiation Protection in Operating Suites',
      ],
    ),
    TechnicianCase(
      id: 'tech_360',
      caseCode: 'CASE 360',
      title: 'MRI Cervical Spine - Truncation (Gibbs Ringing) vs True Syrinx',
      modality: ModalityType.mri,
      examName: 'MRI CERVICAL SPINE SAGITTAL T1 & T2',
      patientAge: 36,
      patientGender: 'Female',
      clinicalIndication: 'Upper extremity numbness and parasthesia. Rule out post-traumatic syrinx.',
      positioningStatus: 'Head/Neck neurovascular array coil.',
      initialImageQuality: 60.0,
      detectedArtifact: 'GIBBS TRUNCATION ARTIFACT SIMULATING SYRINGOMYELIA',
      artifactDescription:
          'Alternate bright and dark parallel ringing bands traversing the central spinal cord at cord-CSF boundary on a low-resolution 128x128 matrix.',
      workstationAlert: 'DIAGNOSTIC AMBIGUITY: High-contrast boundary ringing mimics central canal cavitation.',
      dilemmaQuestion:
          'A linear high-signal line is seen inside the spinal cord on a 128x128 Sagittal T1 image. Is it a true syrinx or a Gibbs truncation artifact, and how do you prove it technically?',
      options: [
        TechnicianDecisionOption(
          id: 'opt_1',
          title: 'INCREASE PHASE-ENCODING MATRIX TO 256 OR 384 TO ELIMINATE TRUNCATION OSCILLATIONS',
          actionDescription:
              'Increase acquisition matrix from 128 to 256x256 (or 384x256), which samples higher spatial frequencies at the cord-CSF interface and eliminates Gibbs mathematical ripple.',
          isOptimal: true,
          scoreDelta: 100,
          outcomeExplanation:
              'Truncation artifact occurs when finite Fourier series cannot approximate a sharp step-function contrast jump (e.g. dark cord to bright CSF). Increasing the acquisition matrix samples higher frequencies, smoothing out the false "pseudo-syrinx" ripple.',
          educationalTakeaway:
              'A low phase matrix (128) in sagittal spine MRI frequently creates a fake "syrinx" due to Gibbs ringing. Increasing the phase matrix to ≥256 resolves the artifact immediately.',
        ),
        TechnicianDecisionOption(
          id: 'opt_2',
          title: 'DECREASE MATRIX TO 64x64 TO SPEED UP ACQUISITION',
          actionDescription: 'Make pixel size larger to finish the scan faster.',
          isOptimal: false,
          scoreDelta: -70,
          outcomeExplanation:
              'Dropping to 64x64 matrix drastically amplifies truncation ripples across the entire spinal cord, completely destroying diagnostic utility.',
          educationalTakeaway:
              'Low matrix exacerbates truncation ringing exponentially.',
        ),
        TechnicianDecisionOption(
          id: 'opt_3',
          title: 'ACCEPT THE FINDING AS A DEFINITIVE 10cm SYRINX REQUIRING IMMEDIATE SURGERY',
          actionDescription: 'Call the neurosurgeon immediately without verifying acquisition parameters.',
          isOptimal: false,
          scoreDelta: -80,
          outcomeExplanation:
              'Misdiagnosing a mathematical Gibbs artifact as a true syrinx could subject an asymptomatic patient to unnecessary invasive neurosurgery.',
          educationalTakeaway:
              'Technologists must recognize technical artifacts to protect patients from misdiagnosis.',
        ),
      ],
      radTechCompetenciesTested: [
        'Fourier Truncation / Gibbs Ringing Physics',
        'Acquisition Matrix vs Spatial Resolution',
        'Spinal Cord Pseudopathology Remediation',
        'Quality Assurance Verification',
      ],
    ),
  ];
}
