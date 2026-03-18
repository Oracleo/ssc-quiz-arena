// lib/data/subjects_data.dart
// Complete local fallback database — mirrored from Firestore structure.
// When Firestore is available, questions are fetched live; these are the
// offline / first-load fallbacks so the app ALWAYS works.

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
            localQuestions: [
              Question(
                  q: "Paleolithic Age is also known as:",
                  opts: [
                    "Old Stone Age",
                    "New Stone Age",
                    "Middle Stone Age",
                    "Bronze Age"
                  ],
                  ans: 0),
              Question(
                  q: "Which tool is MOST associated with Paleolithic humans?",
                  opts: [
                    "Polished axes",
                    "Pottery",
                    "Rough stone tools",
                    "Iron weapons"
                  ],
                  ans: 2),
              Question(
                  q: "Bhimbetka rock shelters in India belong to which age?",
                  opts: [
                    "Neolithic",
                    "Paleolithic",
                    "Chalcolithic",
                    "Iron Age"
                  ],
                  ans: 1),
              Question(
                  q: "The first fire was discovered during which age?",
                  opts: [
                    "Neolithic",
                    "Mesolithic",
                    "Paleolithic",
                    "Bronze Age"
                  ],
                  ans: 2),
              Question(
                  q: "Paleolithic humans primarily survived by:",
                  opts: [
                    "Agriculture",
                    "Trade",
                    "Hunting and gathering",
                    "Animal husbandry"
                  ],
                  ans: 2),
              Question(
                  q: "The Paleolithic Age is divided into how many phases?",
                  opts: ["Two", "Three", "Four", "Five"],
                  ans: 1),
              Question(
                  q: "Lower Paleolithic tools are also called:",
                  opts: [
                    "Microliths",
                    "Celts",
                    "Pebble tools / Chopper tools",
                    "Blades"
                  ],
                  ans: 2),
              Question(
                  q: "Attirampakkam is a Paleolithic site located in:",
                  opts: [
                    "Karnataka",
                    "Tamil Nadu",
                    "Andhra Pradesh",
                    "Maharashtra"
                  ],
                  ans: 1),
              Question(
                  q: "Cave paintings at Bhimbetka were discovered by:",
                  opts: [
                    "John Marshall",
                    "V.S. Wakankar",
                    "Dayaram Sahni",
                    "R.D. Banerjee"
                  ],
                  ans: 1),
              Question(
                  q: "Which period immediately followed Paleolithic Age?",
                  opts: [
                    "Bronze Age",
                    "Iron Age",
                    "Mesolithic Age",
                    "Neolithic Age"
                  ],
                  ans: 2),
            ],
          ),
          Topic(
            id: 'mesolithic',
            label: 'Mesolithic Age',
            qCount: 50,
            localQuestions: [
              Question(
                  q: "Mesolithic Age is also called:",
                  opts: [
                    "Old Stone Age",
                    "Middle Stone Age",
                    "New Stone Age",
                    "Metal Age"
                  ],
                  ans: 1),
              Question(
                  q: "The characteristic tools of Mesolithic Age are called:",
                  opts: ["Celts", "Microliths", "Megaliths", "Handaxes"],
                  ans: 1),
              Question(
                  q: "Which Indian site is famous for Mesolithic rock paintings?",
                  opts: ["Harappa", "Bhimbetka", "Mohenjo-daro", "Taxila"],
                  ans: 1),
              Question(
                  q: "During Mesolithic Age, humans started:",
                  opts: [
                    "Writing scripts",
                    "Building temples",
                    "Domesticating animals",
                    "Using iron"
                  ],
                  ans: 2),
              Question(
                  q: "Mesolithic period in India is approximately dated to:",
                  opts: [
                    "2000–1000 BC",
                    "9000–4000 BC",
                    "500–200 BC",
                    "3000–1000 AD"
                  ],
                  ans: 1),
              Question(
                  q: "Bagor in Rajasthan is a famous site of:",
                  opts: [
                    "Neolithic Age",
                    "Mesolithic Age",
                    "Chalcolithic Age",
                    "Iron Age"
                  ],
                  ans: 1),
              Question(
                  q: "Microliths are tools made of:",
                  opts: ["Copper", "Iron", "Small sharp stones", "Bronze"],
                  ans: 2),
              Question(
                  q: "Sarai Nahar Rai is a Mesolithic site in:",
                  opts: ["Rajasthan", "Uttar Pradesh", "Karnataka", "Bihar"],
                  ans: 1),
              Question(
                  q: "Mesolithic humans first started making:",
                  opts: [
                    "Pottery",
                    "Bows and arrows",
                    "Writing",
                    "Metal tools"
                  ],
                  ans: 1),
              Question(
                  q: "The Mesolithic Age is also called:",
                  opts: [
                    "Chalcolithic",
                    "Epipaleolithic or Middle Stone Age",
                    "Neolithic",
                    "Bronze Age"
                  ],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'neolithic',
            label: 'Neolithic Age',
            qCount: 50,
            localQuestions: [
              Question(
                  q: "Neolithic Age is also known as:",
                  opts: [
                    "Old Stone Age",
                    "Middle Stone Age",
                    "New Stone Age",
                    "Copper Age"
                  ],
                  ans: 2),
              Question(
                  q: "The most important invention of Neolithic Age was:",
                  opts: [
                    "Fire",
                    "Wheel and Agriculture",
                    "Iron smelting",
                    "Writing"
                  ],
                  ans: 1),
              Question(
                  q: "Which is the earliest Neolithic site in India?",
                  opts: ["Mehrgarh", "Harappa", "Lothal", "Mohenjo-daro"],
                  ans: 0),
              Question(
                  q: "Pottery was first made during:",
                  opts: [
                    "Paleolithic Age",
                    "Mesolithic Age",
                    "Neolithic Age",
                    "Iron Age"
                  ],
                  ans: 2),
              Question(
                  q: "Neolithic humans lived in:",
                  opts: [
                    "Caves only",
                    "Trees",
                    "Permanent settlements",
                    "Ships"
                  ],
                  ans: 2),
              Question(
                  q: "Chirand in Bihar is a:",
                  opts: [
                    "Paleolithic site",
                    "Neolithic site",
                    "Vedic site",
                    "Iron Age site"
                  ],
                  ans: 1),
              Question(
                  q: "Burzahom in Kashmir is known for:",
                  opts: [
                    "Indus civilization",
                    "Neolithic pit dwellings",
                    "Vedic period",
                    "Medieval fort"
                  ],
                  ans: 1),
              Question(
                  q: "Neolithic age tools were:",
                  opts: [
                    "Rough and unpolished",
                    "Polished and ground",
                    "Made of iron",
                    "Made of copper"
                  ],
                  ans: 1),
              Question(
                  q: "The first domesticated animal by humans was:",
                  opts: ["Horse", "Cow", "Dog", "Elephant"],
                  ans: 2),
              Question(
                  q: "Neolithic revolution is also called:",
                  opts: [
                    "Industrial revolution",
                    "Agricultural revolution",
                    "Transport revolution",
                    "Trade revolution"
                  ],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "Indus Valley Civilization is also known as:",
                  opts: [
                    "Vedic Civilization",
                    "Harappan Civilization",
                    "Dravidian Civilization",
                    "Aryan Civilization"
                  ],
                  ans: 1),
              Question(
                  q: "Who discovered Harappa in 1921?",
                  opts: [
                    "R.D. Banerjee",
                    "John Marshall",
                    "Dayaram Sahni",
                    "A. Cunningham"
                  ],
                  ans: 2),
              Question(
                  q: "The Great Bath was found at:",
                  opts: ["Harappa", "Lothal", "Mohenjo-daro", "Kalibangan"],
                  ans: 2),
              Question(
                  q: "The script of Indus Valley Civilization is:",
                  opts: ["Brahmi", "Kharosthi", "Undeciphered", "Devanagari"],
                  ans: 2),
              Question(
                  q: "Which metal was NOT known to Indus Valley people?",
                  opts: ["Copper", "Bronze", "Iron", "Gold"],
                  ans: 2),
              Question(
                  q: "Lothal was an important port of:",
                  opts: [
                    "Maurya Empire",
                    "Indus Valley Civilization",
                    "Gupta Empire",
                    "Vedic period"
                  ],
                  ans: 1),
              Question(
                  q: "The Indus Valley people worshipped:",
                  opts: [
                    "Only Vedic Gods",
                    "Pashupati and Mother Goddess",
                    "Only nature spirits",
                    "Only fire"
                  ],
                  ans: 1),
              Question(
                  q: "Town planning in IVC was based on:",
                  opts: [
                    "Circular planning",
                    "Grid pattern",
                    "Random layout",
                    "River alignment only"
                  ],
                  ans: 1),
              Question(
                  q: "Which IVC site had a dockyard?",
                  opts: ["Harappa", "Mohenjo-daro", "Lothal", "Kalibangan"],
                  ans: 2),
              Question(
                  q: "IVC approximately flourished during:",
                  opts: [
                    "5000–3000 BC",
                    "2600–1900 BC",
                    "1000–500 BC",
                    "500–200 BC"
                  ],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'vedic',
            label: 'Vedic Period',
            qCount: 50,
            localQuestions: [
              Question(
                  q: "The oldest Veda is:",
                  opts: ["Samaveda", "Yajurveda", "Atharvaveda", "Rigveda"],
                  ans: 3),
              Question(
                  q: "The word 'Veda' means:",
                  opts: [
                    "Wisdom / Knowledge",
                    "Prayer",
                    "Sacrifice",
                    "Victory"
                  ],
                  ans: 0),
              Question(
                  q: "Battle of Ten Kings (Dasharajna) is mentioned in:",
                  opts: ["Atharvaveda", "Rigveda", "Mahabharata", "Ramayana"],
                  ans: 1),
              Question(
                  q: "The Later Vedic period saw the rise of:",
                  opts: [
                    "Mahajanapadas",
                    "Indus cities",
                    "Mughal empire",
                    "British rule"
                  ],
                  ans: 0),
              Question(
                  q: "Gayatri Mantra is addressed to which deity?",
                  opts: ["Indra", "Varuna", "Savitri (Sun)", "Agni"],
                  ans: 2),
              Question(
                  q: "The Upanishads are also called:",
                  opts: ["Aranyakas", "Vedangas", "Vedanta", "Smritis"],
                  ans: 2),
              Question(
                  q: "The term 'Jana' in Rigveda means:",
                  opts: ["Land", "People/tribe", "River", "God"],
                  ans: 1),
              Question(
                  q: "Vedic society was primarily:",
                  opts: [
                    "Matriarchal",
                    "Patriarchal",
                    "Gender-equal",
                    "Theocratic"
                  ],
                  ans: 1),
              Question(
                  q: "Which Veda contains musical notes?",
                  opts: ["Rigveda", "Yajurveda", "Samaveda", "Atharvaveda"],
                  ans: 2),
              Question(
                  q: "The chief deity of Rigveda was:",
                  opts: ["Varuna", "Agni", "Indra", "Soma"],
                  ans: 2),
            ],
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
            localQuestions: [
              Question(
                  q: "Who founded the Delhi Sultanate?",
                  opts: [
                    "Alauddin Khilji",
                    "Qutb ud-Din Aibak",
                    "Iltutmish",
                    "Balban"
                  ],
                  ans: 1),
              Question(
                  q: "Qutb Minar was built by:",
                  opts: ["Akbar", "Qutb ud-Din Aibak", "Shah Jahan", "Humayun"],
                  ans: 1),
              Question(
                  q: "The first battle of Panipat was fought in:",
                  opts: ["1526", "1556", "1761", "1498"],
                  ans: 0),
              Question(
                  q: "Who introduced the market control system?",
                  opts: [
                    "Balban",
                    "Iltutmish",
                    "Alauddin Khilji",
                    "Firuz Shah Tughlaq"
                  ],
                  ans: 2),
              Question(
                  q: "Ibn Battuta visited India during the reign of:",
                  opts: [
                    "Alauddin Khilji",
                    "Muhammad Bin Tughlaq",
                    "Akbar",
                    "Sher Shah Suri"
                  ],
                  ans: 1),
              Question(
                  q: "The 'Token Currency' system was introduced by:",
                  opts: [
                    "Balban",
                    "Alauddin Khilji",
                    "Muhammad Bin Tughlaq",
                    "Iltutmish"
                  ],
                  ans: 2),
              Question(
                  q: "Alai Darwaza was built by:",
                  opts: [
                    "Iltutmish",
                    "Alauddin Khilji",
                    "Balban",
                    "Firuz Tughlaq"
                  ],
                  ans: 1),
              Question(
                  q: "Sher Shah Suri defeated Humayun at:",
                  opts: ["Chausa (1539)", "Panipat", "Talikota", "Haldighati"],
                  ans: 0),
            ],
          ),
          Topic(
            id: 'mughals',
            label: 'Mughal Empire',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "Akbar's policy of religious tolerance was called:",
                  opts: [
                    "Din-i-Ilahi",
                    "Sulh-i-Kul",
                    "Bhakti movement",
                    "Sufi policy"
                  ],
                  ans: 1),
              Question(
                  q: "Taj Mahal was built by:",
                  opts: ["Akbar", "Humayun", "Shah Jahan", "Aurangzeb"],
                  ans: 2),
              Question(
                  q: "The Mughal emperor who banned music and fine arts:",
                  opts: ["Akbar", "Jahangir", "Shah Jahan", "Aurangzeb"],
                  ans: 3),
              Question(
                  q: "Battle of Haldighati (1576) was fought between:",
                  opts: [
                    "Akbar and Sher Shah",
                    "Akbar and Rana Pratap",
                    "Humayun and Sher Shah",
                    "Babur and Ibrahim Lodi"
                  ],
                  ans: 1),
              Question(
                  q: "Buland Darwaza was built to celebrate victory over:",
                  opts: ["Bengal", "Gujarat", "Rajputana", "Deccan"],
                  ans: 1),
              Question(
                  q: "The land revenue system under Akbar was called:",
                  opts: [
                    "Zabti/Dahsala",
                    "Ryotwari",
                    "Mahalwari",
                    "Permanent Settlement"
                  ],
                  ans: 0),
            ],
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
            localQuestions: [
              Question(
                  q: "The Battle of Plassey was fought in:",
                  opts: ["1757", "1764", "1857", "1799"],
                  ans: 0),
              Question(
                  q: "The East India Company was established in:",
                  opts: ["1600", "1650", "1700", "1757"],
                  ans: 0),
              Question(
                  q: "The Sepoy Mutiny of 1857 is also called:",
                  opts: [
                    "First War of Independence",
                    "Partition of Bengal",
                    "Quit India",
                    "Non-cooperation"
                  ],
                  ans: 0),
              Question(
                  q: "Who was the first Governor-General of India?",
                  opts: [
                    "Dalhousie",
                    "Warren Hastings",
                    "Cornwallis",
                    "Wellesley"
                  ],
                  ans: 1),
              Question(
                  q: "Permanent Settlement was introduced by:",
                  opts: [
                    "Warren Hastings",
                    "Wellesley",
                    "Cornwallis",
                    "Dalhousie"
                  ],
                  ans: 2),
              Question(
                  q: "The doctrine of Lapse was associated with:",
                  opts: [
                    "Lord Cornwallis",
                    "Lord Dalhousie",
                    "Lord Wellesley",
                    "Lord Curzon"
                  ],
                  ans: 1),
              Question(
                  q: "Partition of Bengal took place in:",
                  opts: ["1899", "1905", "1911", "1919"],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'freedom',
            label: 'Freedom Struggle',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "Indian National Congress was founded in:",
                  opts: ["1857", "1885", "1905", "1920"],
                  ans: 1),
              Question(
                  q: "Who gave the slogan 'Swaraj is my birthright'?",
                  opts: [
                    "Mahatma Gandhi",
                    "Bal Gangadhar Tilak",
                    "Nehru",
                    "Bose"
                  ],
                  ans: 1),
              Question(
                  q: "Dandi March took place in:",
                  opts: ["1920", "1930", "1942", "1947"],
                  ans: 1),
              Question(
                  q: "Quit India Movement was launched in:",
                  opts: ["1940", "1942", "1945", "1947"],
                  ans: 1),
              Question(
                  q: "India got independence on:",
                  opts: [
                    "15 Aug 1947",
                    "26 Jan 1950",
                    "15 Aug 1950",
                    "26 Jan 1947"
                  ],
                  ans: 0),
              Question(
                  q: "Simon Commission was boycotted because:",
                  opts: [
                    "It raised taxes",
                    "It had no Indian members",
                    "It banned Congress",
                    "It partitioned Bengal"
                  ],
                  ans: 1),
              Question(
                  q: "Champaran Satyagraha (1917) was related to:",
                  opts: [
                    "Salt tax",
                    "Indigo cultivation",
                    "Land revenue",
                    "Textile mills"
                  ],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "The longest river in India is:",
                  opts: ["Ganga", "Godavari", "Indus", "Brahmaputra"],
                  ans: 0),
              Question(
                  q: "Ganga originates from:",
                  opts: ["Yamunotri", "Gangotri", "Kedarnath", "Badrinath"],
                  ans: 1),
              Question(
                  q: "Which river is called the 'Sorrow of Bengal'?",
                  opts: ["Ganga", "Mahanadi", "Damodar", "Brahmaputra"],
                  ans: 2),
              Question(
                  q: "Brahmaputra river enters India through which state?",
                  opts: ["West Bengal", "Assam", "Arunachal Pradesh", "Sikkim"],
                  ans: 2),
              Question(
                  q: "Which river flows through the Deccan Trap?",
                  opts: ["Ganga", "Yamuna", "Narmada", "Beas"],
                  ans: 2),
              Question(
                  q: "The river Yamuna originates from:",
                  opts: ["Gangotri", "Yamunotri", "Kedarnath", "Rohtang Pass"],
                  ans: 1),
              Question(
                  q: "Which river is called the 'Dakshin Ganga'?",
                  opts: ["Krishna", "Godavari", "Cauvery", "Narmada"],
                  ans: 1),
              Question(
                  q: "Indus river originates from:",
                  opts: [
                    "Gangotri glacier",
                    "Tibet near Lake Mansarovar",
                    "Yamunotri",
                    "Kedarnath"
                  ],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'mountains',
            label: 'Mountains & Landforms',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "The highest peak in India is:",
                  opts: ["Mt. Everest", "K2", "Kangchenjunga", "Nanda Devi"],
                  ans: 2),
              Question(
                  q: "The Western Ghats are also known as:",
                  opts: ["Sahyadri", "Vindhyas", "Aravalli", "Satpura"],
                  ans: 0),
              Question(
                  q: "The Eastern and Western Ghats meet at:",
                  opts: [
                    "Nilgiri Hills",
                    "Anamalai Hills",
                    "Palani Hills",
                    "Cardamom Hills"
                  ],
                  ans: 0),
              Question(
                  q: "Deccan Plateau lies between which mountain ranges?",
                  opts: [
                    "Himalaya and Vindhyas",
                    "Western and Eastern Ghats",
                    "Aravalli and Satpura",
                    "Vindhyas and Western Ghats"
                  ],
                  ans: 1),
              Question(
                  q: "The Thar Desert is located in:",
                  opts: ["Gujarat", "Rajasthan", "Punjab", "Haryana"],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "India is the largest producer of:",
                  opts: ["Wheat", "Rice", "Spices", "Sugarcane"],
                  ans: 2),
              Question(
                  q: "The Green Revolution in India started in:",
                  opts: ["1950s", "1960s", "1970s", "1980s"],
                  ans: 1),
              Question(
                  q: "Kharif crops are sown in:",
                  opts: ["Winter", "Summer/monsoon season", "Spring", "Autumn"],
                  ans: 1),
              Question(
                  q: "Which state is the largest producer of rice in India?",
                  opts: [
                    "Punjab",
                    "Uttar Pradesh",
                    "West Bengal",
                    "Andhra Pradesh"
                  ],
                  ans: 2),
              Question(
                  q: "Operation Flood was related to:",
                  opts: [
                    "Irrigation",
                    "Milk production",
                    "Flood control",
                    "Water harvesting"
                  ],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "The Constitution of India came into force on:",
                  opts: [
                    "15 Aug 1947",
                    "26 Jan 1950",
                    "26 Nov 1949",
                    "30 Jan 1948"
                  ],
                  ans: 1),
              Question(
                  q: "India is described as a 'Socialist' state by which amendment?",
                  opts: ["42nd", "44th", "52nd", "86th"],
                  ans: 0),
              Question(
                  q: "The word 'Secular' was added to the Preamble by:",
                  opts: [
                    "44th Amendment",
                    "42nd Amendment",
                    "86th Amendment",
                    "1st Amendment"
                  ],
                  ans: 1),
              Question(
                  q: "Architect of Indian Constitution is:",
                  opts: [
                    "Jawaharlal Nehru",
                    "Rajendra Prasad",
                    "B.R. Ambedkar",
                    "Sardar Patel"
                  ],
                  ans: 2),
              Question(
                  q: "Total number of Articles in original Constitution:",
                  opts: ["395", "448", "400", "350"],
                  ans: 0),
              Question(
                  q: "India adopted its Constitution on:",
                  opts: [
                    "15 Aug 1947",
                    "26 Jan 1950",
                    "26 Nov 1949",
                    "30 Jan 1948"
                  ],
                  ans: 2),
              Question(
                  q: "The Preamble begins with the words:",
                  opts: [
                    "We the People",
                    "We the Citizens",
                    "We the Nation",
                    "India is a Sovereign"
                  ],
                  ans: 0),
              Question(
                  q: "India is a Federal state with:",
                  opts: [
                    "Unitary bias",
                    "Confederal features",
                    "Pure federation",
                    "No centre-state division"
                  ],
                  ans: 0),
            ],
          ),
          Topic(
            id: 'fundamental_rights',
            label: 'Fundamental Rights',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "Fundamental Rights are contained in which Part of the Constitution?",
                  opts: ["Part II", "Part III", "Part IV", "Part V"],
                  ans: 1),
              Question(
                  q: "Right to Education (Article 21A) was added by which amendment?",
                  opts: ["42nd", "44th", "86th", "93rd"],
                  ans: 2),
              Question(
                  q:
                      "Right to Property was removed from Fundamental Rights by:",
                  opts: [
                    "42nd Amendment",
                    "44th Amendment",
                    "52nd Amendment",
                    "86th Amendment"
                  ],
                  ans: 1),
              Question(
                  q:
                      "Article 32 is called 'Heart and Soul of Constitution' by:",
                  opts: [
                    "Nehru",
                    "Rajendra Prasad",
                    "B.R. Ambedkar",
                    "Sardar Patel"
                  ],
                  ans: 2),
              Question(
                  q: "Which Fundamental Right is available only to citizens?",
                  opts: [
                    "Right to Life",
                    "Right against Exploitation",
                    "Freedom of Religion",
                    "Right to Equality"
                  ],
                  ans: 3),
            ],
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
            localQuestions: [
              Question(
                  q: "The upper house of Indian Parliament is:",
                  opts: [
                    "Lok Sabha",
                    "Rajya Sabha",
                    "Vidhan Sabha",
                    "Vidhan Parishad"
                  ],
                  ans: 1),
              Question(
                  q: "Maximum strength of Lok Sabha is:",
                  opts: ["543", "550", "552", "545"],
                  ans: 2),
              Question(
                  q: "Maximum strength of Rajya Sabha is:",
                  opts: ["238", "245", "250", "260"],
                  ans: 1),
              Question(
                  q: "Rajya Sabha is a:",
                  opts: [
                    "Temporary house",
                    "Permanent house",
                    "Joint house",
                    "Advisory house"
                  ],
                  ans: 1),
              Question(
                  q: "Money Bills can be introduced only in:",
                  opts: [
                    "Rajya Sabha",
                    "Lok Sabha",
                    "Either house",
                    "Joint sitting"
                  ],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "GDP stands for:",
                  opts: [
                    "Gross Domestic Product",
                    "General Development Plan",
                    "Gross Development Plan",
                    "General Domestic Product"
                  ],
                  ans: 0),
              Question(
                  q: "Which organization publishes India's GDP data?",
                  opts: ["RBI", "SEBI", "CSO (NSO)", "NITI Aayog"],
                  ans: 2),
              Question(
                  q: "Per Capita Income means:",
                  opts: [
                    "Total income of country",
                    "Income per person",
                    "Income of government",
                    "Export earnings"
                  ],
                  ans: 1),
              Question(
                  q: "India's fiscal year runs from:",
                  opts: ["Jan–Dec", "April–March", "July–June", "Oct–Sep"],
                  ans: 1),
              Question(
                  q: "The first Five-Year Plan was launched in:",
                  opts: ["1947", "1950", "1951", "1956"],
                  ans: 2),
              Question(
                  q: "GNP = GDP +",
                  opts: [
                    "Taxes",
                    "Net factor income from abroad",
                    "Subsidies",
                    "Depreciation"
                  ],
                  ans: 1),
              Question(
                  q: "The base year for India's GDP calculation (current) is:",
                  opts: ["2004–05", "2011–12", "2014–15", "2019–20"],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'banking',
            label: 'Banking & RBI',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "RBI was established in:",
                  opts: ["1934", "1935", "1947", "1950"],
                  ans: 1),
              Question(
                  q: "The headquarters of RBI is in:",
                  opts: ["Delhi", "Mumbai", "Kolkata", "Chennai"],
                  ans: 1),
              Question(
                  q: "Repo Rate is the rate at which:",
                  opts: [
                    "Banks borrow from RBI",
                    "RBI borrows from banks",
                    "Government borrows from RBI",
                    "Public borrows from banks"
                  ],
                  ans: 0),
              Question(
                  q: "CRR stands for:",
                  opts: [
                    "Cash Reserve Ratio",
                    "Credit Reserve Rate",
                    "Capital Reserve Ratio",
                    "Current Reserve Rate"
                  ],
                  ans: 0),
              Question(
                  q: "The RBI Governor is appointed by:",
                  opts: [
                    "President",
                    "Prime Minister",
                    "Finance Minister",
                    "Cabinet"
                  ],
                  ans: 0),
            ],
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
            localQuestions: [
              Question(
                  q: "Newton's First Law is also known as:",
                  opts: [
                    "Law of Acceleration",
                    "Law of Inertia",
                    "Law of Gravitation",
                    "Law of Action-Reaction"
                  ],
                  ans: 1),
              Question(
                  q: "SI unit of Force is:",
                  opts: ["Joule", "Watt", "Newton", "Pascal"],
                  ans: 2),
              Question(
                  q: "Work done = Force ×",
                  opts: ["Time", "Mass", "Displacement", "Speed"],
                  ans: 2),
              Question(
                  q: "Momentum = Mass ×",
                  opts: ["Acceleration", "Velocity", "Force", "Distance"],
                  ans: 1),
              Question(
                  q: "A rocket works on the principle of:",
                  opts: [
                    "Newton's First Law",
                    "Newton's Second Law",
                    "Newton's Third Law",
                    "Law of Gravitation"
                  ],
                  ans: 2),
              Question(
                  q: "The SI unit of energy is:",
                  opts: ["Watt", "Newton", "Joule", "Pascal"],
                  ans: 2),
              Question(
                  q: "Power = Work done ÷",
                  opts: ["Mass", "Distance", "Time", "Force"],
                  ans: 2),
            ],
          ),
          Topic(
            id: 'light',
            label: 'Light & Optics',
            qCount: 20,
            localQuestions: [
              Question(
                  q: "The speed of light in vacuum is:",
                  opts: ["3×10⁸ m/s", "3×10⁶ m/s", "3×10¹⁰ m/s", "3×10⁷ m/s"],
                  ans: 0),
              Question(
                  q: "A concave mirror is used in:",
                  opts: [
                    "Rear-view mirror",
                    "Periscope",
                    "Vehicle headlights",
                    "Simple microscope"
                  ],
                  ans: 2),
              Question(
                  q: "The phenomenon responsible for rainbow formation is:",
                  opts: [
                    "Reflection",
                    "Refraction and dispersion",
                    "Diffraction",
                    "Polarization"
                  ],
                  ans: 1),
              Question(
                  q: "Total internal reflection is used in:",
                  opts: ["Mirrors", "Optical fibre", "Prisms", "Lenses"],
                  ans: 1),
              Question(
                  q: "A convex lens is also called:",
                  opts: [
                    "Diverging lens",
                    "Converging lens",
                    "Plane lens",
                    "Concave lens"
                  ],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "The chemical formula of water is:",
                  opts: ["H₂O₂", "H₂O", "HO", "H₃O"],
                  ans: 1),
              Question(
                  q: "Atomic number of Carbon is:",
                  opts: ["6", "7", "8", "12"],
                  ans: 0),
              Question(
                  q: "The most abundant gas in the atmosphere is:",
                  opts: ["Oxygen", "Carbon dioxide", "Nitrogen", "Argon"],
                  ans: 2),
              Question(
                  q: "pH of pure water is:",
                  opts: ["0", "7", "14", "5"],
                  ans: 1),
              Question(
                  q: "The chemical symbol for Gold is:",
                  opts: ["Go", "Gd", "Au", "Ag"],
                  ans: 2),
            ],
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
            localQuestions: [
              Question(
                  q: "20% of 500 is:",
                  opts: ["50", "100", "150", "200"],
                  ans: 1),
              Question(
                  q: "If price increases from 200 to 250, % increase is:",
                  opts: ["20%", "25%", "50%", "10%"],
                  ans: 1),
              Question(
                  q: "A student scores 360 out of 400. Percentage?",
                  opts: ["80%", "85%", "90%", "95%"],
                  ans: 2),
              Question(
                  q: "125% of 80 is:",
                  opts: ["100", "105", "110", "120"],
                  ans: 0),
              Question(
                  q: "What % is 75 of 300?",
                  opts: ["20%", "25%", "30%", "35%"],
                  ans: 1),
              Question(
                  q: "30% of 90 is:", opts: ["25", "27", "30", "33"], ans: 1),
              Question(
                  q: "A number increased by 20% becomes 60. The number is:",
                  opts: ["45", "50", "48", "52"],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'profit_loss',
            label: 'Profit & Loss',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "If CP = 200 and SP = 250, profit % is:",
                  opts: ["20%", "25%", "30%", "15%"],
                  ans: 1),
              Question(
                  q: "If CP = 400 and loss is 10%, SP =?",
                  opts: ["360", "380", "420", "440"],
                  ans: 0),
              Question(
                  q: "A trader marks up by 20% and gives 10% discount. Profit %?",
                  opts: ["8%", "10%", "12%", "5%"],
                  ans: 0),
              Question(
                  q: "Profit = SP –",
                  opts: ["Tax", "MP", "CP", "Discount"],
                  ans: 2),
              Question(
                  q: "If SP = 330 and profit = 10%, CP =?",
                  opts: ["270", "300", "310", "320"],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "If x + 5 = 12, then x =?",
                  opts: ["5", "6", "7", "8"],
                  ans: 2),
              Question(
                  q: "(a + b)² = ?",
                  opts: ["a²+b²", "a²+2ab+b²", "a²-2ab+b²", "a²+ab+b²"],
                  ans: 1),
              Question(
                  q: "If 2x = 10, then x =?",
                  opts: ["4", "5", "6", "7"],
                  ans: 1),
              Question(
                  q: "HCF of 12 and 18 is:",
                  opts: ["4", "6", "9", "12"],
                  ans: 1),
              Question(
                  q: "LCM of 4 and 6 is:",
                  opts: ["8", "12", "16", "24"],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "Choose correct: 'She ___ to school every day.'",
                  opts: ["go", "goes", "going", "gone"],
                  ans: 1),
              Question(
                  q: "'I have finished my work.' This is:",
                  opts: [
                    "Simple Past",
                    "Present Perfect",
                    "Past Perfect",
                    "Present Continuous"
                  ],
                  ans: 1),
              Question(
                  q: "Passive voice of 'Ram writes a letter':",
                  opts: [
                    "A letter is writing by Ram",
                    "A letter is written by Ram",
                    "A letter was written by Ram",
                    "A letter has been written by Ram"
                  ],
                  ans: 1),
              Question(
                  q: "The past tense of 'go' is:",
                  opts: ["Goed", "Gone", "Went", "Goe"],
                  ans: 2),
              Question(
                  q: "'She will be singing.' This is:",
                  opts: [
                    "Simple Future",
                    "Future Perfect",
                    "Future Continuous",
                    "Present Continuous"
                  ],
                  ans: 2),
              Question(
                  q: "Correct sentence: 'He ___ there since 2010.'",
                  opts: ["is", "was", "has been", "had been"],
                  ans: 2),
              Question(
                  q: "Past participle of 'swim' is:",
                  opts: ["Swam", "Swum", "Swimmed", "Swinned"],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'vocabulary',
            label: 'Vocabulary & Synonyms',
            qCount: 20,
            localQuestions: [
              Question(
                  q: "Synonym of 'Abundant' is:",
                  opts: ["Scarce", "Plentiful", "Empty", "Rare"],
                  ans: 1),
              Question(
                  q: "Antonym of 'Ancient' is:",
                  opts: ["Old", "Modern", "Historical", "Past"],
                  ans: 1),
              Question(
                  q: "Synonym of 'Benevolent' is:",
                  opts: ["Cruel", "Kind", "Selfish", "Harsh"],
                  ans: 1),
              Question(
                  q: "One word for 'one who walks in sleep':",
                  opts: [
                    "Insomniac",
                    "Somnambulism",
                    "Somnambulist",
                    "Narcissist"
                  ],
                  ans: 2),
              Question(
                  q: "Synonym of 'Diligent':",
                  opts: ["Lazy", "Careless", "Hardworking", "Slow"],
                  ans: 2),
            ],
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
            localQuestions: [
              Question(
                  q: "Doctor : Hospital :: Teacher : ?",
                  opts: ["Clinic", "Court", "School", "Library"],
                  ans: 2),
              Question(
                  q: "Fish : Water :: Bird : ?",
                  opts: ["Sky", "Air", "Nest", "Tree"],
                  ans: 1),
              Question(
                  q: "Book : Library :: Money : ?",
                  opts: ["Wallet", "Bank", "Shop", "Locker"],
                  ans: 1),
              Question(
                  q: "Pen : Write :: Knife : ?",
                  opts: ["Cut", "Point", "Sharpen", "Hold"],
                  ans: 0),
              Question(
                  q: "Lion : Pride :: Fish : ?",
                  opts: ["Flock", "School", "Pack", "Herd"],
                  ans: 1),
              Question(
                  q: "Sun : Day :: Moon : ?",
                  opts: ["Light", "Dark", "Night", "Evening"],
                  ans: 2),
              Question(
                  q: "Gloves : Hands :: Helmet : ?",
                  opts: ["Face", "Neck", "Head", "Shoulder"],
                  ans: 2),
            ],
          ),
          Topic(
            id: 'series',
            label: 'Number Series',
            qCount: 30,
            localQuestions: [
              Question(
                  q: "2, 4, 8, 16, __?",
                  opts: ["24", "28", "32", "36"],
                  ans: 2),
              Question(
                  q: "1, 4, 9, 16, 25, __?",
                  opts: ["30", "34", "36", "38"],
                  ans: 2),
              Question(
                  q: "3, 6, 9, 12, __?",
                  opts: ["13", "14", "15", "16"],
                  ans: 2),
              Question(
                  q: "Odd one out: 2, 3, 5, 7, 9",
                  opts: ["2", "5", "7", "9"],
                  ans: 3),
              Question(
                  q: "5, 10, 20, 40, __?",
                  opts: ["60", "70", "80", "100"],
                  ans: 2),
            ],
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
            localQuestions: [
              Question(
                  q: "If CAT = 3120, then DOG = ?",
                  opts: ["4156", "4157", "4158", "4159"],
                  ans: 0),
              Question(
                  q: "In a code, PEN = 1234. What is NEP?",
                  opts: ["4231", "3241", "3214", "4312"],
                  ans: 2),
              Question(
                  q: "If BOOK = 2663, then COOK = ?",
                  opts: ["3663", "2663", "3363", "3636"],
                  ans: 0),
              Question(
                  q: "SMILE is coded as SMJLE. The pattern is:",
                  opts: [
                    "Reverse",
                    "Middle letter +1",
                    "Replace 3rd letter",
                    "No pattern"
                  ],
                  ans: 2),
              Question(
                  q: "If A=1, B=2... Z=26, then SUM of CAT = ?",
                  opts: ["22", "24", "24", "26"],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "CPU stands for:",
                  opts: [
                    "Central Processing Unit",
                    "Computer Processing Unit",
                    "Central Program Utility",
                    "Core Processing Unit"
                  ],
                  ans: 0),
              Question(
                  q: "RAM stands for:",
                  opts: [
                    "Read Access Memory",
                    "Random Access Memory",
                    "Remote Access Memory",
                    "Rapid Access Memory"
                  ],
                  ans: 1),
              Question(
                  q: "Which is NOT an input device?",
                  opts: ["Keyboard", "Mouse", "Scanner", "Monitor"],
                  ans: 3),
              Question(
                  q: "An operating system is a:",
                  opts: [
                    "Hardware",
                    "Application Software",
                    "System Software",
                    "Firmware"
                  ],
                  ans: 2),
              Question(
                  q: "HTTP stands for:",
                  opts: [
                    "HyperText Transfer Protocol",
                    "High Transfer Text Protocol",
                    "HyperText Transmission Process",
                    "Hybrid Transfer Protocol"
                  ],
                  ans: 0),
              Question(
                  q: "1 Byte =",
                  opts: ["4 bits", "6 bits", "8 bits", "16 bits"],
                  ans: 2),
              Question(
                  q: "Full form of USB:",
                  opts: [
                    "Universal Serial Bus",
                    "Universal System Bus",
                    "Uniform Serial Bus",
                    "Universal Software Bus"
                  ],
                  ans: 0),
            ],
          ),
          Topic(
            id: 'internet',
            label: 'Internet & Networking',
            qCount: 20,
            localQuestions: [
              Question(
                  q: "Full form of URL:",
                  opts: [
                    "Uniform Resource Locator",
                    "Universal Resource Link",
                    "Unified Reference Locator",
                    "Unique Resource Label"
                  ],
                  ans: 0),
              Question(
                  q: "IP stands for:",
                  opts: [
                    "Internet Protocol",
                    "Internal Protocol",
                    "Interface Protocol",
                    "Instant Protocol"
                  ],
                  ans: 0),
              Question(
                  q: "Wi-Fi operates on which standard?",
                  opts: [
                    "IEEE 802.3",
                    "IEEE 802.11",
                    "IEEE 802.15",
                    "IEEE 802.16"
                  ],
                  ans: 1),
              Question(
                  q: "HTML stands for:",
                  opts: [
                    "HyperText Markup Language",
                    "High-level Text Markup Language",
                    "HyperText Machine Language",
                    "HyperText Modern Language"
                  ],
                  ans: 0),
              Question(
                  q: "The first page of a website is called:",
                  opts: ["URL", "Homepage", "Index", "Header"],
                  ans: 1),
            ],
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
            localQuestions: [
              Question(
                  q: "India's highest civilian award is:",
                  opts: [
                    "Padma Bhushan",
                    "Padma Vibhushan",
                    "Bharat Ratna",
                    "Padma Shri"
                  ],
                  ans: 2),
              Question(
                  q: "Arjuna Award is given for excellence in:",
                  opts: ["Science", "Literature", "Sports", "Arts"],
                  ans: 2),
              Question(
                  q: "Man Booker Prize is given for:",
                  opts: ["Peace", "Science", "Fiction Writing", "Economics"],
                  ans: 2),
              Question(
                  q: "Dada Saheb Phalke Award is associated with:",
                  opts: ["Sports", "Cinema", "Science", "Literature"],
                  ans: 1),
              Question(
                  q: "Dronacharya Award is given to:",
                  opts: [
                    "Best athlete",
                    "Best coach",
                    "Best team",
                    "Best referee"
                  ],
                  ans: 1),
            ],
          ),
          Topic(
            id: 'science_tech',
            label: 'Science & Technology',
            qCount: 20,
            localQuestions: [
              Question(
                  q: "ISRO's headquarters is located at:",
                  opts: ["Mumbai", "Bengaluru", "Chennai", "Hyderabad"],
                  ans: 1),
              Question(
                  q: "Chandrayaan-3 successfully landed on the Moon in:",
                  opts: ["2021", "2022", "2023", "2024"],
                  ans: 2),
              Question(
                  q: "India's first indigenous aircraft carrier is:",
                  opts: [
                    "INS Vikrant",
                    "INS Vikramaditya",
                    "INS Arihant",
                    "INS Vishal"
                  ],
                  ans: 0),
              Question(
                  q: "5G services were launched in India in:",
                  opts: ["2020", "2021", "2022", "2023"],
                  ans: 2),
              Question(
                  q: "UPI was launched by:",
                  opts: ["RBI", "SBI", "NPCI", "SEBI"],
                  ans: 2),
            ],
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
