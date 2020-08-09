# flutter

Highlight text in flutter textfield with certain regular expression ( RegExp ) and color.


.....
MyTextEditingController controller;

 @override
  void initState() {
    super.initState();
    controller = MyTextEditingController(regex: RegExp(r"\d{1,3}", color:Colors.blue);
 }
 
 .....
 
TextField(
controller : controller,
)
.....
