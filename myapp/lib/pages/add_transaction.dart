import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/category_model.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String type = "expense";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  String selectedCategory = "";
  String paymentMethod = "UPI";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isRecurring = false;

  final List<String> paymentMethods = [
    "Cash",
    "UPI",
    "Credit Card",
    "Debit Card",
    "Bank Transfer",
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final isDark = appProvider.settings.darkMode;

    final categories = appProvider.categories
        .where((c) => c.type == type || c.type == "both")
        .toList();

    final accentColor =
        type == "income" ? const Color(0xFF00C853) : const Color(0xFFFF5252);

    final bgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    final cardColor =
        isDark ? const Color(0xFF1E293B) : Colors.white;

    final textColor =
        isDark ? Colors.white : const Color(0xFF0F172A);

    final subText =
        isDark ? const Color(0xFF94A3B8) : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          type == "income" ? "Add Income" : "Add Expense",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TYPE TOGGLE
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          type = "expense";
                          selectedCategory = "";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: type == "expense"
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFFF5252),
                                    Color(0xFFFF1744),
                                  ],
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "- Expense",
                            style: TextStyle(
                              color: type == "expense"
                                  ? Colors.white
                                  : subText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          type = "income";
                          selectedCategory = "";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: type == "income"
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF00C853),
                                    Color(0xFF00E676),
                                  ],
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            "+ Income",
                            style: TextStyle(
                              color: type == "income"
                                  ? Colors.white
                                  : subText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// AMOUNT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: accentColor.withOpacity(0.08),
                border: Border.all(
                  color: accentColor.withOpacity(0.2),
                ),
              ),

              child: Column(
                children: [

                  Text(
                    "Amount",
                    style: TextStyle(
                      color: subText,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "₹",
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,

                          style: TextStyle(
                            color: accentColor,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),

                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// TITLE
            buildLabel(
              type == "income"
                  ? "Income Source"
                  : "Expense Title",
              subText,
            ),

            const SizedBox(height: 8),

            buildInput(
              controller: titleController,
              hint: type == "income"
                  ? "Monthly Salary"
                  : "Zomato - Lunch",
              isDark: isDark,
            ),

            const SizedBox(height: 20),

            /// CATEGORY
            buildLabel("Category", subText),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: categories.map((CategoryModel cat) {

                final selected = selectedCategory == cat.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat.id;
                    });
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: selected
                          ? HexColor.fromHex(cat.color).withOpacity(0.15)
                          : cardColor,

                      border: Border.all(
                        color: selected
                            ? HexColor.fromHex(cat.color)
                            : Colors.grey.withOpacity(0.2),
                        width: 1.4,
                      ),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(cat.icon),

                        const SizedBox(width: 6),

                        Text(
                          cat.name,
                          style: TextStyle(
                            color: selected
                                ? HexColor.fromHex(cat.color)
                                : subText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// DATE
            buildLabel("Date", subText),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },

              child: buildPickerBox(
                text:
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                icon: Icons.calendar_month,
                isDark: isDark,
              ),
            ),

            const SizedBox(height: 20),

            /// PAYMENT METHODS
            buildLabel("Payment Method", subText),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: paymentMethods.map((method) {

                final selected = paymentMethod == method;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      paymentMethod = method;
                    });
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: selected
                          ? accentColor.withOpacity(0.12)
                          : cardColor,

                      border: Border.all(
                        color: selected
                            ? accentColor
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),

                    child: Text(
                      method,
                      style: TextStyle(
                        color: selected
                            ? accentColor
                            : subText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// NOTES
            buildLabel("Notes", subText),

            const SizedBox(height: 8),

            buildInput(
              controller: notesController,
              hint: "Add notes...",
              isDark: isDark,
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            /// RECURRING
            SwitchListTile(
              value: isRecurring,

              activeColor: accentColor,

              title: Text(
                "Recurring Transaction",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                "Repeat every month",
                style: TextStyle(
                  color: subText,
                ),
              ),

              onChanged: (v) {
                setState(() {
                  isRecurring = v;
                });
              },
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {

                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty ||
                      selectedCategory.isEmpty) {
                    return;
                  }

                  appProvider.addTransaction(
                    type: type,
                    title: titleController.text,
                    amount: double.parse(amountController.text),
                    category: selectedCategory,
                    date: selectedDate.toIso8601String(),
                    time: selectedTime.format(context),
                    paymentMethod: paymentMethod,
                    notes: notesController.text,
                    tags: [],
                    isRecurring: isRecurring,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Transaction Added"),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text(
                  "Save Transaction",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),

      decoration: InputDecoration(
        hintText: hint,

        filled: true,

        fillColor:
            isDark ? const Color(0xFF1E293B) : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildPickerBox({
    required String text,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : Colors.white,

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          Icon(icon),

          const SizedBox(width: 12),

          Text(text),
        ],
      ),
    );
  }
}

/// HEX COLOR
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor.fromHex(String hexColor)
      : super(_getColorFromHex(hexColor));
}