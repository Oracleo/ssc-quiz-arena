// lib/data/subjects_data.dart
// Subject / Part / Topic structure mirrored from Firestore.
// Questions are fetched live from Firestore at quiz time.

import '../models/models.dart';

const Map<String, Subject> subjectsData = {
  // ══════════════════════════════════════════════════════════
  // HISTORY
  // ══════════════════════════════════════════════════════════
  'history': Subject(
    id: 'history',
    label: 'History',
    parts: [
      Part(
        id: 'prehistory',
        label: 'Prehistory',
        desc: 'Stone Age civilizations and early human settlements',
        topics: [
          Topic(
            id: 'paleolithic',
            label: 'Paleolithic Age',
            qCount: 50,
          ),
          Topic(
            id: 'mesolithic',
            label: 'Mesolithic Age',
            qCount: 50,
          ),
          Topic(
            id: 'neolithic',
            label: 'Neolithic Age',
            qCount: 50,
          ),
        ],
      ),
      Part(
        id: 'ancient',
        label: 'Ancient History',
        desc: 'Indus Valley, Vedic, Maurya & Gupta empires',
        topics: [
          Topic(
            id: 'indus',
            label: 'Indus Valley Civilization',
            qCount: 50,
          ),
          Topic(
            id: 'vedic',
            label: 'Vedic Period',
            qCount: 50,
          ),
        ],
      ),
      Part(
        id: 'medieval',
        label: 'Medieval History',
        desc: 'Delhi Sultanate, Mughal Empire and regional kingdoms',
        topics: [
          Topic(
            id: 'delhi_sultanate',
            label: 'Delhi Sultanate',
            qCount: 30,
          ),
          Topic(
            id: 'mughals',
            label: 'Mughal Empire',
            qCount: 30,
          ),
        ],
      ),
      Part(
        id: 'modern',
        label: 'Modern History',
        desc: 'British rule, freedom struggle and independence',
        topics: [
          Topic(
            id: 'british_rule',
            label: 'British Rule in India',
            qCount: 30,
          ),
          Topic(
            id: 'freedom',
            label: 'Freedom Struggle',
            qCount: 30,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // GEOGRAPHY
  // ══════════════════════════════════════════════════════════
  'geography': Subject(
    id: 'geography',
    label: 'Geography',
    parts: [
      Part(
        id: 'physical',
        label: 'Physical Geography',
        desc: 'Landforms, climate, rivers and natural resources',
        topics: [
          Topic(
            id: 'rivers',
            label: 'Indian Rivers',
            qCount: 30,
          ),
          Topic(
            id: 'mountains',
            label: 'Mountains & Landforms',
            qCount: 30,
          ),
        ],
      ),
      Part(
        id: 'human',
        label: 'Human Geography',
        desc: 'Population, agriculture and economic geography',
        topics: [
          Topic(
            id: 'agriculture',
            label: 'Agriculture in India',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // POLITY
  // ══════════════════════════════════════════════════════════
  'polity': Subject(
    id: 'polity',
    label: 'Polity',
    parts: [
      Part(
        id: 'constitution',
        label: 'Constitution',
        desc: 'Preamble, Fundamental Rights and Directive Principles',
        topics: [
          Topic(
            id: 'preamble',
            label: 'Preamble & Features',
            qCount: 30,
          ),
          Topic(
            id: 'fundamental_rights',
            label: 'Fundamental Rights',
            qCount: 30,
          ),
        ],
      ),
      Part(
        id: 'government',
        label: 'Government Structure',
        desc: 'Parliament, President, PM and Judiciary',
        topics: [
          Topic(
            id: 'parliament',
            label: 'Parliament of India',
            qCount: 30,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // ECONOMY
  // ══════════════════════════════════════════════════════════
  'economy': Subject(
    id: 'economy',
    label: 'Economy',
    parts: [
      Part(
        id: 'basics',
        label: 'Economics Basics',
        desc: 'Fundamental economic concepts and Indian economy',
        topics: [
          Topic(
            id: 'gdp',
            label: 'GDP & National Income',
            qCount: 30,
          ),
          Topic(
            id: 'banking',
            label: 'Banking & RBI',
            qCount: 30,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // SCIENCE
  // ══════════════════════════════════════════════════════════
  'science': Subject(
    id: 'science',
    label: 'Science',
    parts: [
      Part(
        id: 'physics',
        label: 'Physics',
        desc: 'Laws of motion, light, electricity and modern physics',
        topics: [
          Topic(
            id: 'motion',
            label: 'Laws of Motion',
            qCount: 30,
          ),
          Topic(
            id: 'light',
            label: 'Light & Optics',
            qCount: 20,
          ),
        ],
      ),
      Part(
        id: 'chemistry',
        label: 'Chemistry',
        desc: 'Elements, compounds, reactions and everyday chemistry',
        topics: [
          Topic(
            id: 'basic_chemistry',
            label: 'Basic Chemistry',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // MATHS
  // ══════════════════════════════════════════════════════════
  'maths': Subject(
    id: 'maths',
    label: 'Maths',
    parts: [
      Part(
        id: 'arithmetic',
        label: 'Arithmetic',
        desc: 'Percentages, profit/loss, ratio, time & work',
        topics: [
          Topic(
            id: 'percentage',
            label: 'Percentage',
            qCount: 30,
          ),
          Topic(
            id: 'profit_loss',
            label: 'Profit & Loss',
            qCount: 30,
          ),
        ],
      ),
      Part(
        id: 'algebra',
        label: 'Algebra & Geometry',
        desc: 'Equations, geometry and trigonometry',
        topics: [
          Topic(
            id: 'basic_algebra',
            label: 'Basic Algebra',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // ENGLISH
  // ══════════════════════════════════════════════════════════
  'english': Subject(
    id: 'english',
    label: 'English',
    parts: [
      Part(
        id: 'grammar',
        label: 'Grammar',
        desc: 'Tenses, voice, narration and error detection',
        topics: [
          Topic(
            id: 'tenses',
            label: 'Tenses',
            qCount: 30,
          ),
          Topic(
            id: 'vocabulary',
            label: 'Vocabulary & Synonyms',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // REASONING
  // ══════════════════════════════════════════════════════════
  'reasoning': Subject(
    id: 'reasoning',
    label: 'Reasoning',
    parts: [
      Part(
        id: 'verbal',
        label: 'Verbal Reasoning',
        desc: 'Analogy, classification, series and odd one out',
        topics: [
          Topic(
            id: 'analogy',
            label: 'Analogy',
            qCount: 30,
          ),
          Topic(
            id: 'series',
            label: 'Number Series',
            qCount: 30,
          ),
        ],
      ),
      Part(
        id: 'nonverbal',
        label: 'Non-Verbal Reasoning',
        desc: 'Patterns, figures and spatial reasoning',
        topics: [
          Topic(
            id: 'coding',
            label: 'Coding & Decoding',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // COMPUTER
  // ══════════════════════════════════════════════════════════
  'computer': Subject(
    id: 'computer',
    label: 'Computer',
    parts: [
      Part(
        id: 'basics',
        label: 'Computer Basics',
        desc: 'Hardware, software, OS and internet fundamentals',
        topics: [
          Topic(
            id: 'hardware',
            label: 'Hardware & Software',
            qCount: 30,
          ),
          Topic(
            id: 'internet',
            label: 'Internet & Networking',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),

  // ══════════════════════════════════════════════════════════
  // CURRENT AFFAIRS
  // ══════════════════════════════════════════════════════════
  'current': Subject(
    id: 'current',
    label: 'General Awareness',
    parts: [
      Part(
        id: 'general_awareness',
        label: 'General Awareness',
        desc: 'Important India-focused GK and science awareness practice',
        topics: [
          Topic(
            id: 'awards',
            label: 'Awards & Honours',
            qCount: 20,
          ),
          Topic(
            id: 'science_tech',
            label: 'Science & Technology',
            qCount: 20,
          ),
        ],
      ),
    ],
  ),
};

// Helper: get a subject by id
Subject? getSubject(String id) => subjectsData[id];

// Helper: get all topic ids from all subjects
List<String> getAllTopicIds() => subjectsData.values
    .expand((s) => s.parts)
    .expand((p) => p.topics)
    .map((t) => t.id)
    .toList();

// Helper: total question count
int getTotalQuestions() => subjectsData.values
    .expand((s) => s.parts)
    .expand((p) => p.topics)
    .fold(0, (sum, t) => sum + t.qCount);
