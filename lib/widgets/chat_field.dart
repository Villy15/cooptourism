import 'package:flutter/material.dart';
import 'custom_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key});

  @override
  State<ChatTextField> createState() =>  _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
              child: CustomTextFormField(
                controller: controller,
                hintText: 'Add Message...',
              ),
            ),
        const SizedBox(width: 5),
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 20,
          child: IconButton(icon: const Icon(Icons.send,
            color: Colors.white),
            onPressed: () {},
          ),
        )
        ],
      );
  }
}