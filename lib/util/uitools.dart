
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? alignment;
  const AppText(this.text,{this.size, this.fontStyle, this.fontWeight, this.color, this.maxLines, this.overflow, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Text(text, maxLines: maxLines, style: GoogleFonts.roboto(textStyle: TextStyle(color: color, fontWeight: fontWeight, fontStyle: fontStyle, fontSize: size, overflow: overflow)), textAlign: alignment);
    // return Text(text, maxLines: maxLine, style: TextStyle(color: color, fontWeight: fontWeight, fontStyle: fontStyle, fontSize: size, overflow: overflow), textAlign: alignment);
  }
}

class AppTextSpan extends StatelessWidget {
  final String text1, text2;
  final double? size1, size2;
  final double? spacing;
  final Color? color1, color2;
  // final bool expanded1, expanded2;
  final TextAlign? alignment1, alignment2;
  const AppTextSpan({required this.text1, required this.text2, this.color1, this.color2, this.size1, this.size2, this.spacing, this.alignment1, this.alignment2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // expanded1?
        // Expanded(child: AppText(text1, fontWeight: FontWeight.bold, size: size1, color: color1, alignment: alignment1,)):
        AppText(text1, fontWeight: FontWeight.bold, size: size1, color: color1, alignment: alignment1,),
        SizedBox(width: spacing),
        // expanded2?
        Expanded(child: AppText(text2, fontWeight: FontWeight.normal, size: size2, color: color2, alignment: alignment2,))
        // AppText(text2, fontWeight: FontWeight.normal, size: size2, color: color2, alignment: alignment2,)
      ],
    );
  }
}

class CurvedRectBG extends StatelessWidget {
  const CurvedRectBG({this.color, this.radius, this.child, this.margin, this.padding, this.height});
  final Color? color;
  final double? radius;
  final double? height;
  final Widget? child;
  final EdgeInsets? margin, padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius??0),
        color: color,
      ),
      child: child,
    );
  }
}

class AppDropDown extends StatelessWidget {
  final List<String>? list;
  final String? hint;
  final int? selected;
  final Function(int?)? onChangeValue;
  final EdgeInsets? margin;
  const AppDropDown({this.list, this.selected, this.onChangeValue, this.hint, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: AppText(hint??'', overflow: TextOverflow.ellipsis,),
          value: selected,
          onChanged: onChangeValue,
          items: buildDropDownMenuItems(list??[]),
        ),
      ),
    );
  }


  List<DropdownMenuItem<int>> buildDropDownMenuItems(List<String> list) {
    List<DropdownMenuItem<int>> items = [];
    for(int i = 0; i<list.length; i++){
      String item = list[i];
      items.add(DropdownMenuItem(
        value: i,
        enabled: i==0?false:true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppText(item, maxLines: 1, overflow: TextOverflow.ellipsis, color: i==0?Colors.grey:Colors.black),
        ),
      ));
    }
    return items;
  }
}

class AppTextField extends StatefulWidget {
  final String? title, hintText, initialText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final Widget? icon, suffixIcon;
  final bool? obscureText, autoFocus;
  final String? obscureChar, suffixText;
  final Function()? onTap;
  final double? fontSize;
  final int? maxLines, minLines;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Function(String?)? onChanged;
  final Function(String?)? validator;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextField({this.title, this.hintText, this.textInputType, this.icon, this.suffixIcon, this.obscureText, this.obscureChar, this.onTap, this.fontSize, this.maxLines, this.minLines, this.margin, this.padding, this.onChanged, this.onEditingComplete, this.suffixText, this.validator, this.initialText, this.textEditingController, this.focusNode, this.autoFocus, this.enabled, this.inputFormatters});

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(topRight: Radius.circular(0), topLeft: Radius.circular(0)),
      ),
      margin: widget.margin,
      child: TextFormField(
        enabled: widget.enabled,
        // validator: widget.validator,
        focusNode: widget.focusNode,
        initialValue: widget.initialText==null?null:widget.initialText,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        autofocus: widget.autoFocus??false,
        obscureText: widget.obscureText??false,
        // obscuringCharacter: widget.obscureChar==null?null:widget.obscureChar,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        controller: widget.textEditingController==null?null:widget.textEditingController,
        decoration: InputDecoration(
            suffixText: widget.suffixText,
            contentPadding: widget.padding,
            suffixIcon: widget.suffixIcon==null?null:widget.suffixIcon,
            icon: widget.icon==null?null:Container(margin: const EdgeInsets.only(left: 16),child: widget.icon),
            filled: true,
            border: InputBorder.none,
            fillColor: Colors.white24,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.black45)
        ),
      ),
    );
  }
}

class OutlineCurvedBG extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final EdgeInsets? padding;
  const OutlineCurvedBG({this.child, this.color, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          border: Border.all(color: color??Colors.black, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: child,
    );
  }
}

class AppButton extends StatelessWidget {
  final EdgeInsets? padding, margin;
  final Function()? onPressed;
  final Widget? child;
  final bool? flex;
  final MainAxisAlignment? mainAxisAlignment;
  final Color? color, hoverColor, disableTextColor, disableColor, borderColor;
  final double? elevation, disableElevation, radius, borderWidth, height;
  final BorderStyle? borderStyle;
  const AppButton({Key? key, this.onPressed, this.child, this.color, this.elevation, this.hoverColor, this.disableTextColor, this.disableColor, this.disableElevation, this.radius, this.padding, this.margin, this.flex, this.mainAxisAlignment, this.borderColor, this.borderWidth, this.borderStyle, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          side: borderWidth==null?BorderSide.none:BorderSide(
              width: borderWidth??0,
              color: borderColor??Colors.black,
              style: borderStyle??BorderStyle.solid),
          borderRadius: BorderRadius.circular(radius??0),
        ),
        color: color,
        elevation: elevation,
        minWidth: 0,
        height: height,
        hoverColor: hoverColor,
        disabledColor: disableColor,
        disabledTextColor: disableTextColor,
        disabledElevation: disableElevation,
        padding: padding??EdgeInsets.all(0),
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: (flex??false)?
        Row(
            mainAxisAlignment: mainAxisAlignment??MainAxisAlignment.center,
            children: [Expanded(child: child!)]):
        child,),
    );
  }
}

class AppRectangle extends StatelessWidget {
  const AppRectangle({Key? key, this.color, this.radius, this.child, this.margin, this.padding, this.height, this.borderColor, this.borderWidth, this.width, this.alignment}) : super(key: key);
  final Color? color, borderColor;
  final double? radius;
  final double? height, width;
  final double? borderWidth;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsets? margin, padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius??0),
        border: borderColor != null?Border.all(
          color: borderColor!,
          width: borderWidth??1,
        ):null,
        color: color,
      ),
      child: child,
    );
  }
}



