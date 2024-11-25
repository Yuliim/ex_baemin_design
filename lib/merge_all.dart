import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'selection_grid.dart';
import 'top_title.dart';
import 'data.dart';

class MergeAllScreen extends StatelessWidget {
  final AppMenuController controller = Get.find(); // 컨트롤러 가져오기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 10.0),
            Text(
              '메뉴 선택',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitle(), // 상단 타이틀
            Divider(color: Colors.grey[100], thickness: 10),
            ..._buildCategories(), // 카테고리와 메뉴 항목
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        int totalPrice = controller.selectedItemsByCategory.entries.fold(0, (sum, entry) {
          return sum +
              entry.value.fold(0, (itemSum, itemName) {
                final category = menuData[entry.key] ?? [];
                final item = category.firstWhere((e) => e['name'] == itemName,
                    orElse: () => <String, dynamic>{'price': 0});
                final price = (item['price'] ?? 0) as int;
                return itemSum + price;
              });
        });

        return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Colors.grey[300], thickness: 1.0, height: 1.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '배달최소주문금액',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '12,900원',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0), // 가로 간격 추가
                    ElevatedButton(
                      onPressed: () {
                        if (totalPrice >= 12900) {
                          print('총 금액: $totalPrice원');
                        } else {
                          print('최소 주문 금액에 도달하지 못했습니다.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2AC1BC),
                        minimumSize: Size(240, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        '$totalPrice원 담기',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildCategories() {
    // 카테고리별 데이터 구성
    final List<String> categories = ['가격', '생과일토핑', '시리얼토핑', '소스', '프리미엄토핑'];
    final List<Widget> categoryWidgets = [];

    for (final category in categories) {
      final currentItems = menuData[category] ?? [];
      final int limit = controller.categoryLimits[category] ?? 0; // 선택 제한 수 가져오기

      categoryWidgets.addAll([
        SizedBox(height: 15.0), // 이 줄을 추가
        Padding(
          padding: const EdgeInsets.only(left: 16.0), // 각 카테고리 제목 앞에 패딩 추가
          child: Text(
            '$category', // 카테고리 제목
            style: TextStyle(
              fontSize: 20.0, // 크고 두꺼운 글씨
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
        ),
        SelectionGrid(
          category: category, // 이 줄을 추가하세요
          items: currentItems, // 해당 카테고리의 메뉴 데이터
          onItemSelected: (itemName) {
            if (category == '가격') {
              // '가격' 카테고리는 라디오 버튼 적용 - 하나만 선택 가능
              controller.selectedItemsByCategory[category]?.clear(); // 기존 선택 항목 해제
              controller.toggleItemSelection(category, itemName); // 새 항목 선택
            } else {
              // 나머지 카테고리는 체크박스 적용 - 여러 개 선택 가능
              controller.toggleItemSelection(category, itemName);
            }
          },
          controller: controller,
        ),
        SizedBox(height: 0.0), // 카테고리 간 간격
        Divider(color: Colors.grey[100], thickness: 10),
      ]);
    }

    return categoryWidgets;
  }
}
