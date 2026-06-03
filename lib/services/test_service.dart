import '../models/test_item.dart';
import '../repositories/test_repository.dart';

class TestService {
  final TestRepository _repository;

  TestService({TestRepository? repository})
    : _repository = repository ?? TestRepository();

  Future<List<TestItem>> loadTests(int routineId) =>
      _repository.findByRoutine(routineId);

  Future<TestItem> createTest(
    int routineId,
    String tag,
    String address,
    String comment,
  ) {
    final test = TestItem(
      routineId: routineId,
      name: tag.trim(),
      address: address,
      comment: comment.trim(),
      tested: false,
      status: false,
      dateTime: null,
    );
    return _repository.insert(test);
  }

  Future<void> updateTest(TestItem item) => _repository.update(item);

  Future<void> deleteAllTests(int routineId) =>
      _repository.deleteAllByRoutine(routineId);

  Future<int> countTests(int routineId) =>
      _repository.countByRoutine(routineId);

  Future<int> countTested(int routineId) =>
      _repository.countTestedByRoutine(routineId);
}
