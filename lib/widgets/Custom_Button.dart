import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.text, required this.isLoading,required this.onPressed});

  final String text;
  final bool isLoading;
  final void Function() onPressed;


  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.055,
      child: MaterialButton(
        onPressed: () {
          widget.onPressed();
        },
        color: Theme.of(context).colorScheme.primary,
        child: widget.isLoading
            ? const CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)
            : Text(
                widget.text,
                style: const TextStyle(color: Colors.white,fontSize: 19),
              ),
      ),
    );
    ;
  }
}
