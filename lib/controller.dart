import 'package:get/get.dart';

class AppMenuController extends GetxController {
  // 현재 선택된 카테고리
  var selectedCategory = '가격'.obs;

  // 카테고리별로 선택된 항목 저장
  var selectedItemsByCategory = <String, RxList<String>>{
    '가격': <String>[].obs,
    '생과일토핑': <String>[].obs,
    '시리얼토핑': <String>[].obs,
    '소스': <String>[].obs,
    '프리미엄토핑': <String>[].obs,
  };

  // 선택 제한 설정
  final Map<String, int> categoryLimits = {
    '가격': 1,
    '생과일토핑': 10,
    '시리얼토핑': 12,
    '소스': 4,
    '프리미엄토핑': 3,
  };

  // 카테고리 변경
  void updateCategory(String category) {
    selectedCategory.value = category;
  }

  // 항목 선택/해제
  void toggleItemSelection(String category, String itemName) {
    final items = selectedItemsByCategory[category];
    final limit = categoryLimits[category] ?? 0;

    if (items == null) return;

    if (items.contains(itemName)) {
      // 선택 해제
      items.remove(itemName);
    } else if (items.length < limit) {
      // 선택 가능
      items.add(itemName);
    } else {
      // 선택 초과 시 메시지 출력
      print('최대 $limit개까지 선택 가능합니다.');
    }
  }

  // 전체 선택된 메뉴 수 계산
  int getTotalSelectedItemsCount() {
    return selectedItemsByCategory.values.fold(
      0,
          (sum, items) => sum + items.length,
    );
  }
}
