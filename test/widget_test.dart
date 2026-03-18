import 'package:flutter_test/flutter_test.dart';
import 'package:ssc_quiz_arena/data/subjects_data.dart';

void main() {
  test('subjects data exposes a non-empty catalog', () {
    expect(subjectsData.length, 10);
    expect(getAllTopicIds(), isNotEmpty);
    expect(getTotalQuestions(), greaterThan(0));
  });
}
