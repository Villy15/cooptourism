import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/user.dart';
import 'package:cooptourism/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:email_otp/email_otp.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  final String profileId;
  const EmailVerificationPage({Key? key, required this.profileId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final userRepository = UserRepository();
  final picker = ImagePicker();
  EmailOTP emailAuth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, 'Email Verification'),
      body: SingleChildScrollView (
        child: 
            FutureBuilder<UserModel>(
              future: userRepository.getUser(widget.profileId),
              builder: (context, snapshot) {
                debugPrint(widget.profileId);
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  debugPrint('user is $user');
                  if (user?.firstName == 'Customer' && user?.role == 'Customer' && user?.emailStatus == 'Not Verified') {
                    debugPrint(user?.emailStatus);
                    return verifyEmail(context, user);
                  }
                  else {
                    return const Column();
                  }
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                
                }
              }
            )
      ),
    );
  }

  Padding verifyEmail(BuildContext context, UserModel? user) {
    return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(
                              Icons.mark_email_read,
                              size: 70,
                              color: Theme.of(context).colorScheme.secondary
                            )
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Email Verification',
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'We need to verify your email address to continue. We will send you an email with a link to verify your email address.',
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'This is to ensure that you will be of service to the cooperative/s you will be enrolling to. We respect your privacy and will not share your email address with anyone.',
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 45),
                        Text(
                          'Enter your email address: ',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Email Address...',
                              suffixIcon: TextButton(
                                onPressed: () async {
                                  if (_emailController.text == user!.email) {
                                    emailAuth.setConfig(
                                      appEmail: 'lakbay@cooptourism.com',
                                      userEmail: _emailController.text,
                                      otpLength: 6,
                                      otpType: OTPType.values,
                                    );

                                    if (await emailAuth.sendOTP() == true) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email OTP has been sent!')));
                                    }
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email address does not match!')));
                                  }
                                },
                                child: const Text('Send OTP'),
                              )
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Enter the OTP sent to your email address: ',
                          style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: _otpController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'OTP...',
                              suffixIcon: TextButton(
                                onPressed: () async {
                                  if (await emailAuth.verifyOTP(otp: _otpController.text))
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email verified!')));
                                    await userRepository.updateUser(widget.profileId, UserModel(
                                      emailStatus: 'Verified',
                                      role: 'Customer',
                                      firstName: 'Customer',
                                      email: _emailController.text,
                                    ));

                                    GoRouter.of(context).go('/profile_page/${widget.profileId}/edit_profile');
                                    
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP!')));
                                  }
                                },
                                child: const Text('Verify OTP'),
                              )
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  );
  }


   AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(title,
          style: TextStyle(
              fontSize: 28, color: Theme.of(context).colorScheme.primary)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: IconButton(
              onPressed: () {
                // showAddPostPage(context);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}