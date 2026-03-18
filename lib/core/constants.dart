import '../models/models.dart';

const List<SubjectMeta> kSubjectMetas = [
  SubjectMeta(
    id: 'history',
    label: 'History',
    colorValue: 0xFFE05252,
    bgColorValue: 0x18E05252,
  ),
  SubjectMeta(
    id: 'geography',
    label: 'Geography',
    colorValue: 0xFF34C77B,
    bgColorValue: 0x1834C77B,
  ),
  SubjectMeta(
    id: 'polity',
    label: 'Polity',
    colorValue: 0xFF5B8DEF,
    bgColorValue: 0x185B8DEF,
  ),
  SubjectMeta(
    id: 'economy',
    label: 'Economy',
    colorValue: 0xFFF5A623,
    bgColorValue: 0x18F5A623,
  ),
  SubjectMeta(
    id: 'science',
    label: 'Science',
    colorValue: 0xFFA78BFA,
    bgColorValue: 0x18A78BFA,
  ),
  SubjectMeta(
    id: 'maths',
    label: 'Maths',
    colorValue: 0xFF38BDF8,
    bgColorValue: 0x1838BDF8,
  ),
  SubjectMeta(
    id: 'english',
    label: 'English',
    colorValue: 0xFFFB923C,
    bgColorValue: 0x18FB923C,
  ),
  SubjectMeta(
    id: 'reasoning',
    label: 'Reasoning',
    colorValue: 0xFFF472B6,
    bgColorValue: 0x18F472B6,
  ),
  SubjectMeta(
    id: 'computer',
    label: 'Computer',
    colorValue: 0xFF4ADE80,
    bgColorValue: 0x184ADE80,
  ),
  SubjectMeta(
    id: 'current',
    label: 'General Awareness',
    colorValue: 0xFFFACC15,
    bgColorValue: 0x18FACC15,
  ),
];

SubjectMeta getSubjectMeta(String id) => kSubjectMetas
    .firstWhere((s) => s.id == id, orElse: () => kSubjectMetas.first);

const bool kEnableGoogleSignIn = true;
const bool kEnableCommunityLeaderboard = true;
const bool kEnableRemoteQuestionBank = true;
const bool kEnableCloudFeatures = true;
