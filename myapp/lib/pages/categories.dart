import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  String name;
  String icon;
  Color color;
  String type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<String> icons = [
    '🍽️',
    '🚗',
    '🛍️',
    '⚡',
    '🏥',
    '🎬',
    '📈',
    '💼',
    '💻',
    '🏢',
    '🎁',
    '🏠',
    '💪',
    '📚',
    '☕',
    '✈️',
    '🎮',
    '🎵',
    '💊',
    '🛒',
    '🐕',
    '🍕',
    '💡',
    '🌐',
  ];

  final List<Color> colors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFA29BFE),
    const Color(0xFFFDCB6E),
    const Color(0xFFFF7675),
    const Color(0xFF74B9FF),
    const Color(0xFF55EFC4),
    const Color(0xFF00C853),
    const Color(0xFF2979FF),
    const Color(0xFFFFD54F),
    const Color(0xFFFD79A8),
    const Color(0xFFE17055),
    const Color(0xFF00B894),
    const Color(0xFF6C5CE7),
  ];

  final List<CategoryModel> categories = [];

  String activeTab = 'expense';

  void openCategorySheet({CategoryModel? category}) {
    final bool isEdit = category != null;

    final TextEditingController nameController =
        TextEditingController(text: category?.name ?? '');

    String selectedIcon = category?.icon ?? '💰';
    Color selectedColor = category?.color ?? const Color(0xFF00C853);
    String selectedType = category?.type ?? activeTab;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          isEdit ? 'Edit Category' : 'New Category',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white70),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: selectedColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: selectedColor.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          selectedIcon,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Category Name',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: ['expense', 'income', 'both']
                          .map(
                            (type) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      selectedType = type;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedType == type
                                          ? (type == 'expense'
                                                  ? Colors.red
                                                  : type == 'income'
                                                      ? Colors.green
                                                      : Colors.blue)
                                              .withOpacity(0.15)
                                          : const Color(0xFF0F172A),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: selectedType == type
                                            ? (type == 'expense'
                                                ? Colors.red
                                                : type == 'income'
                                                    ? Colors.green
                                                    : Colors.blue)
                                            : Colors.white12,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        type.toUpperCase(),
                                        style: TextStyle(
                                          color: selectedType == type
                                              ? (type == 'expense'
                                                  ? Colors.red
                                                  : type == 'income'
                                                      ? Colors.green
                                                      : Colors.blue)
                                              : Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Icon',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: icons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final icon = icons[index];

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedIcon = icon;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIcon == icon
                                  ? selectedColor.withOpacity(0.2)
                                  : const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selectedIcon == icon
                                    ? selectedColor
                                    : Colors.white12,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                icon,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Color',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: colors.map((color) {
                        final selected = selectedColor == color;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: selected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) return;

                          if (isEdit) {
                            setState(() {
                              category.name = nameController.text.trim();
                              category.icon = selectedIcon;
                              category.color = selectedColor;
                              category.type = selectedType;
                            });
                          } else {
                            setState(() {
                              categories.add(
                                CategoryModel(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  name: nameController.text.trim(),
                                  icon: selectedIcon,
                                  color: selectedColor,
                                  type: selectedType,
                                ),
                              );
                            });
                          }

                          Navigator.pop(context);
                        },
                        child: Text(
                          isEdit
                              ? 'Update Category'
                              : 'Create Category',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void deleteCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete Category?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this category?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  categories.remove(category);
                });

                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = categories
        .where(
          (c) => c.type == activeTab || c.type == 'both',
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => openCategorySheet(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2979FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Color(0xFF2979FF), size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Color(0xFF2979FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeTab = 'expense';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: activeTab == 'expense'
                              ? Colors.red.withOpacity(0.15)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '💸 Expenses',
                            style: TextStyle(
                              color: activeTab == 'expense'
                                  ? Colors.red
                                  : Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          activeTab = 'income';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: activeTab == 'income'
                              ? Colors.green.withOpacity(0.15)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '💰 Income',
                            style: TextStyle(
                              color: activeTab == 'income'
                                  ? Colors.green
                                  : Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filtered.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '📂',
                          style: TextStyle(fontSize: 60),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (context, index) {
                        final category = filtered[index];

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: category.color.withOpacity(0.15),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category.icon,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            openCategorySheet(
                                          category: category,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      GestureDetector(
                                        onTap: () =>
                                            deleteCategory(category),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const Spacer(),

                              Text(
                                category.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: category.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    category.type.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}