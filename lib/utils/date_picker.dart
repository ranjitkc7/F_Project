import "package:flutter/material.dart";
import 'package:nepali_date_picker/nepali_date_picker.dart';
import '../widgets/button.dart';

class DatePickerUtil {
  static Future<void> pickDate({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            margin: const EdgeInsets.all(12),
            width: double.infinity,
            height: 144,

            child: Column(
              children: [
                Text(
                  "Choose Data Type",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                Text(
                  "Select Nepali(BS) or English(AD) Date",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final nepaliDate = await showNepaliDatePicker(
                          context: context,
                          initialDate: NepaliDateTime.now(),
                          firstDate: NepaliDateTime(2000),
                          lastDate: NepaliDateTime(2090),
                        );
                        if (nepaliDate != null) {
                          controller.text =
                              "${nepaliDate.year}/${nepaliDate.month}/${nepaliDate.day}";
                        }
                      },
                      child: Text(
                        "Nepali Date",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final englishDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (englishDate != null) {
                          controller.text =
                              "${englishDate.year}/${englishDate.month}/${englishDate.day}";
                        }
                      },
                      child: const Text(
                        "English Date",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  text: "Close",
                  color: Colors.deepPurple,
                  radius: 12,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}