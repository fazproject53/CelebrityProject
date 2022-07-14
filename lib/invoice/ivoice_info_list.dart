class invoiceInfo {
  final int id;
  final double price;
  final DateTime date;
  final String  userName, desc;
  //final DateTime duration;

  invoiceInfo({
    required this.id,
    required this.userName,
    required this.price,
    required this.date,
    required this.desc,
  });
}

//List of codes with info
List<invoiceInfo> invoiceList = [
  invoiceInfo(
    id: 1,
    userName: "عبد الله عبد الله",
    desc: "اعلان لمغسلة سيارات",
    price: 3000.0,
    date: DateTime.now(),
  ),

  invoiceInfo(
    id: 2,
    userName: "سارة محمد",
    desc: "اريد طلب اعلان لمنتجات تجميل",
    price: 3000.0,
    date: DateTime.now(),
  ),

  invoiceInfo(
    id: 3,
    userName: "عبد العزيز",
    desc: "اريد طلب اهداء لعيد ميلاد ابني",
    price: 200.0,
    date: DateTime.now(),
  ),

  invoiceInfo(
    id: 4,
    userName: "فرح سعيد",
    desc: "طلب اهداء بمناسبة زواج بنت خالتي",
    price: 300.0,
    date: DateTime.now(),
  ),

  invoiceInfo(
    id: 5,
    userName: "زياد عبد الله",
    desc: "طلب مساحة اعلانية لمنتج صبغة للشعر",
    price: 500.0,
    date: DateTime.now(),
  ),

  invoiceInfo(
    id: 6,
    userName: "خديجة محمد",
    desc: "طلب اهداء صوتي لاختي بمناسبة ترقيتها بالعمل",
    price: 200.0,
    date: DateTime.now(),
  ),
];
