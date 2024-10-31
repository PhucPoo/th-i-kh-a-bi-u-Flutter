import 'package:localstore/localstore.dart';

import 'event_model.dart';

class EventService {
  // Tham khảo thêm thư viện localstore của mình tại http://pub.dev
  final db = Localstore.getInstance(useSupportDir: true);

  // Tên collection trong localstore (giống như tên bảng)
  final path = 'events';

  // Hàm lấy danh sách sự kiên từ localstore
  Future<List<EventModel>> getAllEvent() async {
    final eventsMap = await db.collection(path).get();

    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

  // Hàm luwumootj sự kiện vào localstore
  Future<void> saveEvent(EventModel item) async {
    // Nếu id không tồn tại (tạo mới) thì lấy một id ngẫu nhiên
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());
  }

  // Hàm xóa một sự kiện từ localstore
  Future<void> deleteEvent(EventModel item) async {
    await db.collection(path).doc(item.id).delete();
  }
}
