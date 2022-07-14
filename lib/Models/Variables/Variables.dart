
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//colors----------------------------------------------------------------
const Color blue = Color(0xFF0AB3D0);
const Color whiteBlue = Color(0xFFAADCE4);
const Color white = Color(0xFFFFFFFF);
const Color pink = Color(0xFFE468CA);
const Color deepPink=Color.fromRGBO(156, 73, 160, 1.0);
const Color pinkLigth = Color(0xFFFB6580);
const Color purple = Color(0xFF8952EA);
const Color black = Color(0xFF000000);
const Color ligthtBlack = Color(0xFF1D192C);
const Color darkBlue = Color(0xFF39579A);
const Color textBlack = Color(0xFF5C5E6F);
const Color darkWhite = Color(0xFF7B7B8B);
const Color deepBlack = Color(0xFF7477A0);
const Color border = Color(0xFFCED0D2);
const Color textColor = Color(0xFFF7F2FF);
const Color black_ = Color(0xFF494646);
const Color yallow = Color(0xFFFFE500);
Color backBlack= const Color.fromRGBO(54, 54 ,62 , 0.40);
Color mainGrey=Colors.grey.withOpacity(0.20);

///#53535A
const Color newGrey = Color(0xFF53535A);

var deepblue = Colors.pink[900];
var grey = Colors.grey[500];
var deepgrey = Colors.grey[700];
var amber=Colors.amber[700];
var red=Colors.red[900];

const Color deepwhite = Color(0xFFFAFAFA);
const Color fillWhite = Color(0xFFFAFAFA);
const Color transparent=Colors.transparent;
Color textFieldBlack2 = Color(0xFF0B0B15);

var green = Colors.green;
const Color lightGrey = Color(0xF0BBBBBB);
var normalGrey = Colors.grey;

//Icons name----------------------------------------------------------------
IconData nameIcon=Icons.person;
IconData passIcon=Icons.lock_outline;
IconData emailIcon=Icons.email_outlined;
IconData countryIcon=Icons.flag_rounded;
IconData catogaryIcon=Icons.reduce_capacity_rounded;
IconData price =Icons.attach_money;
IconData money =Icons.credit_card;
IconData support =Icons.headset_mic;
IconData orders =Icons.campaign;
IconData invoice =Icons.receipt;
IconData store =Icons.store;
IconData copun = Icons.redeem;
IconData scheduale = Icons.event_available;
IconData studio = Icons.emoji_emotions;
IconData pagesIcon = Icons.pages;
IconData block = Icons.block;
IconData chat = Icons.chat_bubble_outline;
IconData logout = Icons.logout;
IconData copyRight = Icons.copyright;
IconData ad = Icons.add_box;
IconData adArea = Icons.input;
IconData arrow = Icons.arrow_back_ios;
IconData attach = Icons.attach_file;
IconData clander = Icons.calendar_today_rounded;
IconData send = Icons.send;
Icon back=Icon(Icons.arrow_back_ios_sharp,color: black,size:30.w);
IconData backIcon = Icons.arrow_back_sharp;
IconData image = Icons.image;
IconData addNew = Icons.add_circle_rounded;
IconData typeOfDiscount = Icons.local_offer_outlined;
IconData numberOfUsers = Icons.people_outlined;
IconData duration = Icons.timer_outlined;
IconData discountDes = Icons.description_outlined;
IconData removeDiscount = Icons.delete_rounded;
IconData editDiscount = Icons.edit_rounded;
IconData imageIcon = Icons.image;
IconData videoIcon = Icons.videocam;
IconData voiceIcon = Icons.keyboard_voice_sharp;
IconData filter = Icons.filter_alt_rounded;
IconData gift =Icons.card_giftcard_rounded;
IconData like=Icons.favorite_outlined;
IconData arrowDropDown=Icons.arrow_drop_down;
IconData error=Icons.error;
IconData done=Icons.task_alt;
IconData disLike = Icons.favorite_border;
IconData playViduo = Icons.play_arrow_rounded;
IconData chatIcon = Icons.chat;
IconData homeIcon = Icons.home;
IconData exploreIcon = Icons.explore_outlined;
IconData notificationIcon = Icons.notifications;
IconData time = Icons.watch_later_outlined;
IconData share = Icons.share_outlined;
IconData infoIcon = Icons.info_outlined;
IconData invoiceIcon = Icons.receipt;
IconData dateRange = Icons.date_range_outlined;
IconData cam = Icons.camera_alt;
IconData add = Icons.add;
IconData save = Icons.done;
IconData payment = Icons.payments_outlined;
IconData suspended = Icons.pending_outlined;
IconData show = Icons.visibility_sharp;
IconData hide = Icons.visibility_off_sharp;
IconData flag = Icons.flag_rounded;
IconData verified = Icons.verified_sharp;
IconData protect = Icons.security;
IconData right = Icons.done_outline_outlined;
//controller name----------------------------------------------------------------
TextEditingController userNameUserController = TextEditingController();
TextEditingController passUserController =TextEditingController();
TextEditingController emailUserController=TextEditingController();
TextEditingController countryUserController=TextEditingController();

TextEditingController userNameCeleController = TextEditingController();
TextEditingController passCeleController =TextEditingController();
TextEditingController emailCeleController=TextEditingController();
TextEditingController countryCeleController=TextEditingController();
TextEditingController catogaryCeleController=TextEditingController();

TextEditingController loggingPassController =TextEditingController();
TextEditingController loggingEmailController=TextEditingController();

//image path------------------------------------------------------
String staticPath="assets/image/";
String googelImage=staticPath+"google-logo.png";
String facebookImage=staticPath+"facbok_logo.png";
String discount =staticPath+"coupon.png";
String explorImage=staticPath+"CreateOrder.png";
String videoImage=staticPath+"featured.png";


//font textScaling

//App bar names------------------------------------------------------
String requestBar="الطلبات";