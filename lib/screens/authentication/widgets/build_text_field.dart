import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/colors.dart'; // Ensure this path is correct for your project

class BuildTextField extends StatefulWidget {
  final String text;
  final TextInputType? textType;
  final String iconName;
  final bool isPhoneNumber;
  final Function(String)? onValueChange; // Callback for value change

  const BuildTextField({
    Key? key,
    required this.text,
    required this.textType,
    this.iconName = '',
    this.isPhoneNumber = false,
    this.onValueChange,
  }) : super(key: key);

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  late bool _obscureText;
  late bool _isPasswordField;
  String _selectedCountryCode = '+92'; // Default country code
  TextEditingController _textController = TextEditingController(); // Text controller

  @override
  void initState() {
    super.initState();
    _isPasswordField = widget.text == "Password" || widget.text == "Confirm Password";
    _obscureText = _isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.primarySecondaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isPhoneNumber)
            Container(
              padding: EdgeInsets.only(right: 0),
              child: CountryCodePicker(
                onChanged: (countryCode) {
                  setState(() {
                    _selectedCountryCode = countryCode.dialCode!;
                  });
                  _updatePhoneNumber();
                },
                initialSelection: 'PK',
                favorite: ['+92', 'PK'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
              ),
            ),
          Expanded(
            child: TextField(
              controller: _textController,
              keyboardType: widget.textType,
              obscureText: _obscureText,
              decoration: InputDecoration(
                prefixIcon: widget.iconName.isNotEmpty
                    ? Padding(
                  padding: EdgeInsets.only(left: 17.w, right: 10.w),
                  child: SvgPicture.asset("assets/${widget.iconName}.svg",
                      width: 16.w, height: 16.h),
                )
                    : null,
                hintText: widget.text,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                suffixIcon: _isPasswordField
                    ? GestureDetector(
                  onTap: _togglePasswordVisibility,
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color:_obscureText ? AppColors.primaryText : AppColors.primaryBackground,

                    size: 20.sp,
                  ),
                )
                    : null,
                hintStyle: TextStyle(
                  color: AppColors.primarySecondaryElementText,
                  fontSize: 14.sp,
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
              ),
              onChanged: (value) {
                if (widget.isPhoneNumber) {
                  _updatePhoneNumber();
                } else {
                  widget.onValueChange?.call(value);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updatePhoneNumber() {
    String fullPhoneNumber = _selectedCountryCode + _textController.text;
    widget.onValueChange?.call(fullPhoneNumber);
  }
}
