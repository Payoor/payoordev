import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat/providers/_message_provider.dart';

import 'package:chat/classes/_visitor.dart';
import 'package:chat/classes/_message.dart';
import 'package:chat/classes/_storagemanager.dart';
import 'package:chat/classes/_customformstate.dart';
import 'package:chat/classes/_url.dart';
import 'package:chat/classes/_auth.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';

abstract class BaseChatClass<T extends StatefulWidget> extends State<T> {
  late IO.Socket socket;
  late MessageProvider _messageProvider;
  late TextEditingController textController;
  late StorageManager _storageManager;
  late ScrollController scrollController;
  static final PayoorUrl payoorUrl = PayoorUrl();

  late List<Message> messagesItems = [];
  late int messagesLength;

  List<CustomFormState> formstates = [
    /*CustomFormState(
        inputType: 'isPhonenumberInput',
        hintText: "08131234560",
        maxLines: 1,
        maxLength: 11,
        keyboardType: TextInputType.number),*/
    CustomFormState(
        inputType: 'isEmailInput',
        hintText: "name@emaildomain.com",
        maxLines: 1,
        maxLength: 50,
        keyboardType: TextInputType.emailAddress),
    CustomFormState(
        inputType: 'isOtpInput',
        hintText: "123456",
        maxLines: 1,
        maxLength: 6,
        keyboardType: TextInputType.number),
    CustomFormState(
        inputType: 'isNameinput',
        hintText: "Your Name",
        maxLines: 1,
        maxLength: 100,
        keyboardType: TextInputType.text),
    CustomFormState(
        inputType: 'isLoggedInInput',
        hintText: "State your order",
        maxLines: null,
        maxLength: null,
        keyboardType: TextInputType.multiline)
  ];

  bool isLoggedIn = false;
  bool isInputReady = false;
  bool payoorIsTyping = false;
  late CustomFormState currentFormState;
  String userChatValue = "";
  late String inputType;
  late String? userJWT;
  String userPhoneNumber = "";
  String username = "";

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    textController.addListener(_onTextChanged);
    scrollController = ScrollController();
    _messageProvider = Provider.of<MessageProvider>(context, listen: false);
    currentFormState = formstates[0];
    inputType = currentFormState.inputType;

    checkAuthState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  void checkAuthState() async {
    String? jwt = await getJWT();

    if (jwt == null) {
      setState(() {
        username = 'Visitor';
        currentFormState = formstates[0];
        inputType = formstates[0].inputType;
        isLoggedIn = false;
        userJWT = "";
      });

      await handleVisitorMessages(context, mounted);
    }

    if (jwt != null && jwt.isNotEmpty) {
      final Auth auth = Auth();

      auth.getValidUser(jwt).then((userData) async {
        if (userData['invalid'] != null) {
          setState(() {
            username = 'Visitor';
            userJWT = "";
            isLoggedIn = false;
            currentFormState = formstates[0];
            inputType = formstates[0].inputType;
          });

          await handleVisitorMessages(context, mounted);
        } else {
          List<Message> messages = userData['messages'] ?? [];
          String username = userData['username'] ?? '';
          String userJwt = userData['jwt'] ?? '';
          bool hasUsername = userData['hasUsername'] ?? false;

          final messageProvider =
              Provider.of<MessageProvider>(context, listen: false);

          messageProvider.setMessages(messages);

          if (hasUsername == false) {
            setState(() {
              username = username;
              userJWT = userJwt;
              currentFormState = formstates[2];
              inputType = formstates[2].inputType;
            });
          } else {
            setState(() {
              username = username;
              userJWT = userJwt;
              currentFormState = formstates[3];
              inputType = formstates[3].inputType;
            });
          }
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }).catchError((error) {
        print("=========================1");
        print('Error: $error');
      });
    }
  }

  Future<void> handleVisitorMessages(BuildContext context, bool mounted) async {
    final Visitor currentVisitor = Visitor();

    if (!mounted) return;

    try {
      // Handle existing messages
      final messageProvider =
          Provider.of<MessageProvider>(context, listen: false);

      if (messageProvider.messages.isNotEmpty) {
        final List<Message> messageItems = messageProvider.messages;
        await currentVisitor.saveMessagesToServer(messageItems);
      }

      // Get and handle unauthenticated messages
      final unAuthenticated = await currentVisitor.getUnAuthenticatedMsg();

      if (mounted) {
        setState(() {
          username = unAuthenticated['username'];
        });

        handleIncomingMessage(
          unAuthenticated['payoormessage']['msg'],
          id: unAuthenticated['payoormessage']['_id'],
        );
      }
    } catch (e) {
      print('Error handling visitor messages: $e');
      // Add appropriate error handling here
    }
  }

  Future<String?> getJWT() async {
    _storageManager = await StorageManager.create();
    final String? jwt = await _storageManager.getJwt();

    return jwt;
  }

  void triggerPayoorIsTyping(bool isTypingState) {
    setState(() {
      payoorIsTyping = isTypingState;
    });
  }

  Future<void> handleIncomingMessage(dynamic msg, {String? id}) async {
    final receiverMessage = Message(
      value: msg,
      isUser: false,
      isLoggedIn: isLoggedIn,
      jwt: userJWT,
      username: 'Payoor',
      timeStamp: DateTime.now().toIso8601String(),
      id: id,
    );

    _messageProvider.addMessage(receiverMessage);
    await Future.microtask(() {});
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> sendMessageToServer(Map<String, dynamic> messageData,
      {String? messageType}) async {
    triggerPayoorIsTyping(true);

    final String serverUrl = payoorUrl.getBaseUri();
    late String endPoint; //= '$serverUrl/message';
    late Uri uri;

    try {
      if (currentFormState.inputType == "isEmailInput") {
        endPoint = '$serverUrl/auth/email';
      }

      if (currentFormState.inputType == "isOtpInput") {
        endPoint = '$serverUrl/auth/otp';
      }

      if (currentFormState.inputType == "isNameinput") {
        endPoint = '$serverUrl/auth/name';
      }

      final Visitor currentVisitor = Visitor();
      final String identifier = currentVisitor.identifier;

      if (userJWT == null || userJWT!.isEmpty) {
        uri = Uri.parse(endPoint)
            .replace(queryParameters: {'visitoridentifier': identifier});
      } else {
        final String? jwt = await _storageManager.getJwt();
        uri = Uri.parse(endPoint).replace(
            queryParameters: {'jwt': jwt, 'visitoridentifier': identifier});
      }

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(messageData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (currentFormState.inputType == "isEmailInput") {
          setState(() {
            username = data['username'];
            currentFormState = formstates[1];
            inputType = formstates[1].inputType;
          });
        } else if (currentFormState.inputType == "isOtpInput") {
          triggerJWTSave(data['jwt']);

          if (data['hasUsername'] == false) {
            setState(() {
              username = data['username'];
              currentFormState = formstates[2];
              inputType = formstates[2].inputType;
            });
          } else {
            setState(() {
              username = data['username'];
              currentFormState = formstates[3];
              inputType = formstates[3].inputType;
            });
          }
        } else if (currentFormState.inputType == "isNameinput") {
          setState(() {
            username = data['username'];
            currentFormState = formstates[3];
            inputType = formstates[3].inputType;
          });
        }

        handleIncomingMessage(data['payoormessage']['msg'],
            id: data['payoormessage']['_id']);

        print(data);
        return data;
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() {
    if (userChatValue.isNotEmpty && isInputReady) {
      Message message = Message(
          value: userChatValue,
          isUser: true,
          isLoggedIn: isLoggedIn,
          jwt: userJWT,
          username: username,
          timeStamp: DateTime.now().toIso8601String());

      _messageProvider.addMessage(message);

      textController.clear();
      setState(() {
        userChatValue = "";
        isInputReady = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      if (inputType == 'isPhonenumberInput') {
        setState(() {
          userPhoneNumber = message.value;
        });
      }

      Map<String, dynamic> messageData = {
        'message': message.value,
        'userPhoneNumber': userPhoneNumber,
        'isUser': true,
        'isLoggedIn': isLoggedIn,
        'jwt': message.jwt,
        'timestamp': message.timeStamp,
        'inputType': inputType
      };

      sendMessageToServer(messageData);
    }
  }

  void triggerJWTSave(dynamic jwt) async {
    setState(() {
      userJWT = jwt;
    });

    await _storageManager.saveJwt(jwt);
  }

  Future<void> _onTextChanged() async {
    String userchat = textController.text;

    bool readyInput = currentFormState.isInputReady(userchat);

    if (readyInput) {
      setState(() {
        isInputReady = readyInput;
        userChatValue = userchat;
      });
    } else {
      setState(() {
        isInputReady = false;
        userChatValue = "";
      });
    }
  }
}
