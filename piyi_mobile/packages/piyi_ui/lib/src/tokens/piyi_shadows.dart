import 'package:flutter/material.dart';
class PiyiShadows { const PiyiShadows._();
 static List<BoxShadow> get card => [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 18, offset: const Offset(0,8))];
 static List<BoxShadow> get elevated => [BoxShadow(color: Colors.black.withOpacity(.10), blurRadius: 24, offset: const Offset(0,12))];
}
