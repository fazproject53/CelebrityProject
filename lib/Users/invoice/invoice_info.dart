class invoiceInformation {
  final int id;
  final double price;
  final DateTime date;
  final String  userName, desc;
  //final DateTime duration;

  invoiceInformation({
    required this.id,
    required this.userName,
    required this.price,
    required this.date,
    required this.desc,
  });
}

//List of codes with info
List<invoiceInformation> invoiceListInfo = [
  invoiceInformation(
    id: 1,
    userName: " تامر حسني",
    desc: "اهداء فيديو بمناسبة عيد ميلاد",
    price: 300.0,
    date: DateTime.now(),
  ),

  invoiceInformation(
    id: 2,
    userName: "نجوى كرم",
    desc: "اعلان مستحضرات تجميل",
    price: 3000.0,
    date: DateTime.now(),
  ),


];
