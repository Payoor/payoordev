/*class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Message> messages = [];

  late ScrollController _scrollController;
  late TextEditingController _textController;
  late FocusNode _focusNode;
  double _keyboardHeight = 0;

  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    connectToServer();

    _scrollController = ScrollController();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  void connectToServer() {
    socket =
        IO.io('https://cf26-31-171-154-54.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on('connect', (_) => print('Connected to server'));
    socket.on('chat message admin', handleIncomingMessage);
  }

  void handleIncomingMessage(dynamic msg) {
    print(msg);
    final receiverMessage = Message(value: "Hi there!", isSender: false);
    setState(() {
      messages.add(receiverMessage);
    });
  }

  void sendMessage() {
    if (_textController.text.isNotEmpty) {
      socket.emit('chat message', _textController.text);
      final senderMessage =
          Message(value: _textController.text, isSender: true);
      setState(() {
        messages.add(senderMessage);
      });
      _textController.clear();
    }

    //WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottomWithKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final scrollAmount = _scrollController.position.maxScrollExtent -
            (_scrollController.position.viewportDimension -
                keyboardHeight -
                _getInputFieldHeight());
        print("=====================================================");
        print(scrollAmount);

         _scrollController.animateTo(
          20,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToOriginalPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _lastScrollPosition,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  double _getInputFieldHeight() {
    return 60; // Adjust this value based on your input field's actual height
  }

  void _handleFocusChange(bool hasFocus) {
    if (hasFocus) {
      _lastScrollPosition = _scrollController.position.pixels;
      _scrollToBottomWithKeyboard();
    } else {
      _scrollToOriginalPosition();
    }
  }

  /*void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ChatScreenLayout(
                    constraints: constraints,
                    messages: messages,
                    controller: _textController,
                    scrollController: _scrollController,
                    focusNode: _focusNode,
                    onSendMessage: sendMessage,
                    onFocusChange: _handleFocusChange,
                  );
                },
              ))),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class ChatScreenLayout extends StatelessWidget {
  final BoxConstraints constraints;
  final List<Message> messages;
  final TextEditingController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final VoidCallback onSendMessage;
  final Function(bool) onFocusChange;

  const ChatScreenLayout({
    Key? key,
    required this.constraints,
    required this.messages,
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.onSendMessage,
    required this.onFocusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      controller: scrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: IntrinsicHeight(
          child: Container(
              decoration: const BoxDecoration(
                color: ThemeColors.primaryColor,
                //borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  left: 25.0,
                  right: 25.0,
                  bottom: constraints.maxHeight * 0.7,
                ),
                child: Column(
                  children: [
                    HeaderWidget(constraints: constraints),
                    Expanded(
                      child: ChatBody(
                          constraints: constraints,
                          messages: messages,
                          controller: controller,
                          focusNode: focusNode,
                          onSendMessage: onSendMessage,
                          onFocusChange: onFocusChange),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

bottomSheet: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: ThemeColors.primaryColor,
            ),
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 0),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Container(
                      decoration: const BoxDecoration(
                        color: ThemeColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldTapRegion(
                                    child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 24.0 *
                                        maxLines, // Approximate line height * max lines
                                  ),
                                  child: SingleChildScrollView(
                                    child: TextField(
                                      //controller: widget.controller,
                                      //focusNode: widget.focusNode,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      decoration: InputDecoration(
                                        hintText: 'Enter message',
                                        contentPadding: EdgeInsets.all(12.0),
                                        border: InputBorder.none,
                                      ),
                                      //onSubmitted: (_) =>
                                          //widget.onSendMessage(),
                                    )
                                  ),
                                )),
                              ),
                              ElevatedButton(
                                child: Icon(Icons.send),
                                onPressed: () {
                                  // Handle send action
                                },
                              ),
                            ],
                          )
                        ],
                      ));
                })))

class MessageBubble extends StatelessWidget {
  final Message message;
  final BoxConstraints constraints;

  const MessageBubble(
      {Key? key, required this.message, required this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child:
            message.isSender ? _buildSenderMessage() : _buildReceiverMessage(),
      ),
    );
  }

  Widget _buildSenderMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: constraints.maxWidth * 0.65,
          decoration: const BoxDecoration(
            color: ThemeColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: const BoxDecoration(
                color: ThemeColors.red,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Wrap(
                children: [
                  Text(
                    message.value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: ThemeColors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiverMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: constraints.maxWidth * 0.65,
          decoration: const BoxDecoration(
            color: ThemeColors.greyBlack,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              message.value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: ThemeColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: messages[index].isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                MessageBubble(
                                  message: messages[index],
                                  constraints: constraints,
                                ),
                                !messages[index].isUser &&
                                        index == messages.length - 1 &&
                                        payoorIsTyping
                                    ? const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          WavyDotsLoading(),
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            )
Future<void> sendMessageToServer(Map<String, dynamic> messageData) async {
    triggerPayoorIsTyping(true);

    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/message';

    try {
      final response = await http.post(
        Uri.parse(endPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(messageData),
      );

      if (response.statusCode == 200) {
        triggerPayoorIsTyping(false);

        Map<String, String> parsedData = parseResponse(response.body);

        if (parsedData['message'] != 'empty') {
          handleIncomingMessage(parsedData['message']);
        }

        if (parsedData['type'] == 'unauthenticated') {
          setState(() {
            currentFormState = formstates[0];
            inputType = formstates[0].inputType;
          });
        }

        if (parsedData['type'] == 'pendingotp') {
          setState(() {
            currentFormState = formstates[1];
            inputType = formstates[1].inputType;
          });
        }

        if (parsedData['type'] == 'receivedotp') {
          setState(() {
            currentFormState = formstates[2];
            inputType = formstates[2].inputType;
            userJWT = parsedData['token'];
          });
        }

        if (parsedData['type'] == 'authenticated') {
          triggerJWTSave(parsedData['token']);

          String? jwt = await getJWT();

          setState(() {
            userJWT = jwt;
            isLoggedIn = true;
            username = parsedData['username'] ?? 'Visitor';
          });

          await saveUserConversation();

          //setUserConversations();

          setState(() {
            currentFormState = formstates[3];
            inputType = formstates[3].inputType;
          });

          connectToServer();

          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      } else {
        triggerPayoorIsTyping(false);
        print('Failed to send message. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error response
      }
    } catch (e) {
      print(e);
      setState(() {
        //payoorIsTyping = false;
      });
    }
  }

  void checkAuthState() async {
    String? jwt = await getJWT();
    String content =
        "It appears you aren't logged in please log in using your email address";

    if (jwt == null) {
      setState(() {
        currentFormState = formstates[0];
        inputType = formstates[0].inputType;
        isLoggedIn = false;
        userJWT = "";
      });

      handleIncomingMessage(content);

      final Visitor currentVisitor = Visitor();

      if (mounted) {
        final messageProvider =
            Provider.of<MessageProvider>(context, listen: false);

        await currentVisitor.saveMessagesToServer(messageProvider.messages);

        final visitoreDetails = await currentVisitor.getVisitorDataFromServer();

        final userdetails = visitoreDetails['userdetails'];

        messageProvider.clearMessages();

        setState(() {
          username = userdetails['username'];
        });

        setUserConversations(userdetails['messages']);

        if (!mounted) return; // Check mounted again after async operations

        print(userdetails);
      }
    } else {
      final result = await getValidUserFromServer(jwt);

      if (result['authenticated']) {
        setState(() {
          userJWT = jwt;
          username = result['username'];
        });

        await saveUserConversation();

        connectToServer();

        setState(() {
          currentFormState = formstates[3];
          inputType = formstates[3].inputType;
          isLoggedIn = true;
        });
      } else {
        setState(() {
          currentFormState = formstates[0];
          inputType = formstates[0].inputType;
          isLoggedIn = false;
          userJWT = "";
        });

        handleIncomingMessage(content);
      }
    }

    recordMessages();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }*/

  /*Future<void> saveUserConversation() async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/saveconversation';

    List<Message> messagesItems = _messageProvider.messages;

    final Uri uri = Uri.parse(endPoint).replace(
      queryParameters: {'jwt': userJWT},
    );

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(messagesItems.map((msg) => msg.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['message'];
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving conversation: $e');
    }
  }*/

  /*Future<List<dynamic>> getUserConversation() async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/getconversation';

    final Uri uri = Uri.parse(endPoint).replace(
      queryParameters: {'jwt': userJWT},
    );

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['conversation'];
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting conversation: $e');
    }
  }*/

  /*void setUserConversations(conversation) async {
    //List<dynamic> conversation = await getUserConversation();

    List<Message> messageItemsArr = [];

    conversation.forEach((json) {
      /*Message messageItem = Message(
        value: json['content'],
        isUser: json['isUser'],
        isLoggedIn: json['isLoggedIn'],
        jwt: userJWT,
        username: 'username',
        timeStamp: json['client_timestamp'],
      );

      messageItemsArr.add(messageItem);*/
    });

    _messageProvider.setMessages(messageItemsArr);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }*/

  //==========================================================================================================================================================

  /*void joinRoom() async {
    String? jwt = await getJWT();

    Map<String, dynamic> jwtData = {'jwt': jwt};

    socket.emit('joinroom', jwtData);
  }*/


  /*Map<String, String> parseResponse(String responseBody) {
    try {
      Map<String, dynamic> responseData = jsonDecode(responseBody);

      String message = responseData['message'] as String? ?? 'empty';
      String type = responseData['type'] as String? ?? '';
      String token = responseData['token'] as String? ?? '';

      return {'message': message, 'type': type, 'token': token};
    } catch (e) {
      print('Error parsing response: $e');
      return {'message': '', 'type': '', 'token': ''};
    }
  }*/

  /*void emitDataToServer(String event, dynamic data) {
    socket.emit(event, data);
  }*/

  /*void initializeConnection() async {
    String? jwt = await getJWT();

    Map<String, dynamic> jwtData = {'jwt': jwt};

    socket.emit('initConnect', jwtData);
  }*/

  /*Future<Map<String, dynamic>> getValidUserFromServer(String jwt) async {
    final String serverUrl = payoorUrl.getBaseUri();
    final String endPoint = '$serverUrl/auth/getuser';

    final Uri uri = Uri.parse(endPoint).replace(
      queryParameters: {'jwt': jwt},
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'authenticated': data['authenticated'] ?? false,
          'username': data['username'] ?? 'Visitor',
          'status': 'success',
          'message': 'User authenticated successfully',
        };
      } else if (response.statusCode == 404) {
        return {
          'authenticated': false,
          'username': 'Visitor',
          'status': 'error',
          'message': 'User not found',
        };
      } else {
        return {
          'authenticated': false,
          'username': 'Visitor',
          'status': 'error',
          'message': 'Failed to authenticate user: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'authenticated': false,
        'username': 'Visitor',
        'status': 'error',
        'message': 'Error authenticating user: $e',
      };
    }
  }*/

  /*void recordMessages() {
    int messagesLength = _messageProvider.messageCount;
    List<Message> messagesItems = _messageProvider.messages;

    setState(() {
      messagesItems = messagesItems;
      messagesLength = messagesLength;
    });
  }*/

   /*void connectToServer() {
    setState(() {
      socket = IO.io(
          payoorUrl.getBaseUri(),
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .setExtraHeaders({'Authorization': 'Bearer $userJWT'})
              .setAuth({'token': userJWT})
              .enableAutoConnect()
              .enableReconnection()
              .setReconnectionAttempts(double.infinity)
              .setReconnectionDelay(1000)
              .setTimeout(10000)
              .build());
    });

    socket.on('newmessage', (data) {
      // The server sends a message object with content, isUser, and timestamp
      String content = data['msg']['content'];
      //bool isUser = data['msg']['isUser'];
      //String timestamp = data['msg']['timestamp'];

      handleIncomingMessage(content);

      // Handle the message in your app (e.g., update UI, add to chat, etc.)
    });

    socket.onConnect((_) {
      print('Connection established');
    });
  }*/