import 'package:flutter/material.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/services/message_service.dart';
import 'package:gym_sync/frontend/widgets/message_chip_widget.dart';
import 'package:gym_sync/frontend/widgets/snak_bar.dart';

class MessageCustomerDialog extends StatefulWidget {
  final Customer customer;
  final Function(Customer customer, bool smsSelected, bool whatsappSelected)
  onSend;

  const MessageCustomerDialog({
    super.key,
    required this.customer,
    required this.onSend,
  });

  @override
  State<MessageCustomerDialog> createState() => _MessageCustomerDialogState();
}

class _MessageCustomerDialogState extends State<MessageCustomerDialog> {
  final TextEditingController _messageController = TextEditingController();
  bool smsSelected = true;
  bool whatsappSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageController.text = MessageService.createMessage(
      widget.customer,
      MessageType.expired,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (!smsSelected && !whatsappSelected) {
      AppSnackBar.showInfo("Select atleast one messaging platform");
    } else {
      widget.onSend(widget.customer, smsSelected, whatsappSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xff2C3639),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message ${widget.customer.name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffDCD7C9),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: ${widget.customer.phoneNumber}',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xffDCD7C9).withOpacity(0.7),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Choose messaging platform:',
              style: TextStyle(fontSize: 14, color: Color(0xffDCD7C9)),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                MessageChipWidget(
                  selectedInitially: true,
                  mode: MessagingMode.sms,
                  onSelected: (selected) {
                    smsSelected = selected;
                  },
                ),
                MessageChipWidget(
                  mode: MessagingMode.whatsapp,
                  onSelected: (selected) {
                    whatsappSelected = selected;
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              enabled: false,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Color(0xffDCD7C9).withOpacity(0.5)),
                filled: true,
                fillColor: Color(0xff3F4E4F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Color(0xffDCD7C9)),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xffDCD7C9).withOpacity(0.7)),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleSend(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).highlightColor,
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
