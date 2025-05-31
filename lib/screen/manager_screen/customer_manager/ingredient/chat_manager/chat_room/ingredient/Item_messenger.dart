import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../../data/chatData/messenger.dart';

class Item_messenger extends StatefulWidget {
  final messenger mes;
  const Item_messenger({Key? key, required this.mes}) : super(key: key);

  @override
  State<Item_messenger> createState() => _Item_messengerState();
}

class _Item_messengerState extends State<Item_messenger> {
  bool _isPressed = false;

  bool isBase64(String str) {
    if (str.isEmpty) return false;
    // Loại bỏ whitespace/newlines
    final normalized = str.replaceAll(RegExp(r'\s+'), '');
    try {
      final bytes = base64.decode(normalized);
      // Re-encode và so sánh để chắc chắn đúng padding
      return base64.encode(bytes) == normalized;
    } on FormatException {
      return false;
    }
  }

  bool isSupabaseStorageUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // 1. Phải là HTTP(S)
      if (!(uri.scheme == 'http' || uri.scheme == 'https')) return false;

      // 2. Host phải là dạng <project>.supabase.co
      if (!uri.host.endsWith('.supabase.co')) return false;

      // 3. Path phải bắt đầu bằng /storage/v1/object/public/
      if (!uri.path.startsWith('/storage/v1/object/public/')) return false;

      return true;
    } catch (e) {
      // parse lỗi → không phải URL hợp lệ
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = 400;
    Color bgColor = _isPressed
        ? (widget.mes.type != 1
        ? Colors.grey.withOpacity(0.4)
        : Colors.blue.withOpacity(0.3))
        : (widget.mes.type != 1
        ? Colors.grey.withOpacity(0.2)
        : Colors.blue.withOpacity(0.1));

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        widget.mes.type == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPressStart: (_) {
              setState(() => _isPressed = true);
              if (!isBase64(widget.mes.content)) {
                Clipboard.setData(ClipboardData(text: widget.mes.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã copy tin nhắn!')),
                );
              }
            },
            onLongPressUp: () => setState(() => _isPressed = false),
            child: isSupabaseStorageUrl(widget.mes.content)
                ? Container(
              width: width / 2,
              height: width / 2,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bgColor,
              ),
              child: Image.network(
                widget.mes.content,
                fit: BoxFit.fitHeight,
                errorBuilder: (_, __, ___) =>
                const Center(child: Text('Không hiển thị được ảnh')),
              ),
            )
                : ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 2 / 3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: bgColor,
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
                child: Text(
                  widget.mes.content,
                  style: const TextStyle(
                    fontFamily: 'muli',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
