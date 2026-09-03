import 'package:flutter/material.dart';
import '../models/brain_region_model.dart';
import '../theme/app_colors.dart';

class BrainData {
  static const List<BrainRegion> regions = [
    BrainRegion(
      id: 'frontal',
      name: 'Frontal Lobe',
      latinName: 'Lobus Frontalis',
      keyRole: 'Executive Function, Motor Control & Speech',
      description:
          'The command center of human cognition. Orchestrates decision making, personality expression, working memory, and voluntary movement execution.',
      primaryFunctions: [
        'Executive planning and logical reasoning',
        'Primary motor cortex voluntary movement control',
        'Broca’s area for speech production & syntax',
        'Social behavior regulation and inhibition',
      ],
      clinicalRelevance: [
        'Frontotemporal dementia causes early personality shifts',
        'Traumatic Brain Injury (TBI) contrecoup contusions',
        'Middle Cerebral Artery (MCA) superior branch infarction',
      ],
      imagingTip:
          'On Axial T2/FLAIR MRI, evaluate the precentral gyrus and look for subtle effacement of frontal sulci in acute stroke or intracranial hypertension.',
      highlightColor: AppColors.cyan,
      visualCenter: Offset(0.38, 0.32),
      radius: 0.18,
      anatomicalLandmarks: ['Precentral Gyrus', 'Superior Frontal Sulcus', 'Broca Area', 'Orbitofrontal Cortex'],
    ),
    BrainRegion(
      id: 'parietal',
      name: 'Parietal Lobe',
      latinName: 'Lobus Parietalis',
      keyRole: 'Somatosensory Integration & Spatial Mapping',
      description:
          'Processes sensory inputs including touch, temperature, nociception, and proprioception. Builds real-time 3D spatial awareness of body in space.',
      primaryFunctions: [
        'Primary somatosensory cortex tactile discrimination',
        'Visuospatial processing and coordinate transformation',
        'Mathematical calculation (angular gyrus)',
        'Sensory integration for tool handling & grasping',
      ],
      clinicalRelevance: [
        'Gerstmann Syndrome (agraphia, acalculia, finger agnosia)',
        'Hemispatial neglect syndrome from right parietal stroke',
        'Cortical sensory loss with preserved crude sensation',
      ],
      imagingTip:
          'Identify the Central Sulcus to differentiate the postcentral sensory strip from the precentral motor cortex on Sagittal T1 MRI.',
      highlightColor: AppColors.emerald,
      visualCenter: Offset(0.60, 0.28),
      radius: 0.16,
      anatomicalLandmarks: ['Postcentral Gyrus', 'Intraparietal Sulcus', 'Angular Gyrus', 'Supramarginal Gyrus'],
    ),
    BrainRegion(
      id: 'temporal',
      name: 'Temporal Lobe',
      latinName: 'Lobus Temporalis',
      keyRole: 'Auditory Processing, Language Comprehension & Memory',
      description:
          'Houses the hippocampus for episodic memory encoding and Wernicke’s area for receptive language. Plays a pivotal role in auditory decoding and emotional valence.',
      primaryFunctions: [
        'Receptive language decoding (Wernicke’s Area)',
        'Long-term memory consolidation (Hippocampus)',
        'Primary auditory cortex pitch & frequency analysis',
        'Limbic emotional processing via Amygdala',
      ],
      clinicalRelevance: [
        'Mesial Temporal Sclerosis (MTS) causing refractory epilepsy',
        'Wernicke’s fluent sensory aphasia',
        'Early volume loss in Alzheimer’s Disease entorhinal cortex',
      ],
      imagingTip:
          'Coronal oblique 3D T1 and high-resolution T2 sequences tilted perpendicular to the hippocampal long axis are gold standard for hippocampal volumetry.',
      highlightColor: AppColors.violet,
      visualCenter: Offset(0.48, 0.54),
      radius: 0.15,
      anatomicalLandmarks: ['Superior Temporal Gyrus', 'Hippocampal Formation', 'Fusiform Gyrus', 'Uncus'],
    ),
    BrainRegion(
      id: 'occipital',
      name: 'Occipital Lobe',
      latinName: 'Lobus Occipitalis',
      keyRole: 'Visual Perception, Color & Motion Processing',
      description:
          'The visual processing center of the mammalian brain. Retinotopic mapping translates light photons into edge detection, motion vectors, and color geometry.',
      primaryFunctions: [
        'Primary visual cortex (V1 / Striate cortex) retinotopy',
        'Visual association areas for color and motion detection',
        'Depth perception and stereoscopic fusion',
        'Dorsal (where) and ventral (what) visual stream routing',
      ],
      clinicalRelevance: [
        'Posterior Reversible Encephalopathy Syndrome (PRES)',
        'Cortical blindness (Anton-Babinski syndrome)',
        'Posterior Cerebral Artery (PCA) territory infarction',
      ],
      imagingTip:
          'Examine the Calcarine Sulcus on sagittal and coronal T1/T2 MRI. PRES typically presents as symmetrical bilateral subcortical vasogenic edema on FLAIR.',
      highlightColor: AppColors.magenta,
      visualCenter: Offset(0.78, 0.45),
      radius: 0.14,
      anatomicalLandmarks: ['Calcarine Sulcus', 'Cuneus', 'Lingual Gyrus', 'Striate Cortex (V1)'],
    ),
    BrainRegion(
      id: 'cerebellum',
      name: 'Cerebellum',
      latinName: 'Cerebellum ("Little Brain")',
      keyRole: 'Motor Precision, Coordination & Equilibrium',
      description:
          'Contains over 50% of the entire brain’s neurons. Fine-tunes motor commands, calculates error correction in real-time, and stabilizes vestibular balance.',
      primaryFunctions: [
        'Continuous predictive motor error correction',
        'Vestibulocerebellar balance and gaze stabilization',
        'Rapid alternating movement rhythm coordination',
        'Motor skill procedural learning (muscle memory)',
      ],
      clinicalRelevance: [
        'Cerebellar ataxia, dysmetria, and intention tremor',
        'Chiari Malformation (tonsillar ectopia > 5mm below foramen magnum)',
        'PICA and AICA ischemic infarcts with acute vertigo',
      ],
      imagingTip:
          'Always verify the inferior cerebellar tonsils on Mid-sagittal T1 MRI relative to the McRae line / Foramen Magnum to exclude Chiari herniation.',
      highlightColor: AppColors.amber,
      visualCenter: Offset(0.68, 0.72),
      radius: 0.15,
      anatomicalLandmarks: ['Cerebellar Tonsils', 'Vermis', 'Dentate Nucleus', 'Flocculonodular Lobe'],
    ),
    BrainRegion(
      id: 'brainstem',
      name: 'Brainstem',
      latinName: 'Truncus Encephali',
      keyRole: 'Vital Autonomic Functions & Cranial Nerve Nuclei',
      description:
          'Composed of the Midbrain, Pons, and Medulla Oblongata. Connects the cerebrum to the spinal cord and governs breathing, heart rate, sleep cycles, and cranial reflexes.',
      primaryFunctions: [
        'Cardiovascular and respiratory autonomous pacing',
        'Ascending Reticular Activating System (ARAS) consciousness',
        'Cranial Nerve III through XII motor and sensory nuclei',
        'Corticospinal and spinothalamic conduit tracts',
      ],
      clinicalRelevance: [
        'Central Pontine Myelinolysis (Osmotic Demyelination)',
        'Wallenberg Lateral Medullary Syndrome',
        'Brainstem cavernous malformations and high-risk hemorrhage',
      ],
      imagingTip:
          'Diffusion-Weighted Imaging (DWI) and ADC maps are crucial to detect acute punctate brainstem infarcts that may appear normal on conventional CT.',
      highlightColor: Color(0xFF00E5FF),
      visualCenter: Offset(0.48, 0.74),
      radius: 0.13,
      anatomicalLandmarks: ['Midbrain Tectum', 'Pons Basilar Groove', 'Medullary Pyramids', 'Fourth Ventricle'],
    ),
  ];
}
