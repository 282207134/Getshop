import 'dart:ui';
import 'package:flutter/material.dart';
import '../state/shop_controller.dart';
import '../theme.dart';
import '../widgets/shop_widgets.dart';
import 'catalog_screen.dart';

class SortScreen extends StatelessWidget {
  const SortScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: CatalogScreen(controller),
      ),
      Positioned.fill(
        child: GestureDetector(
          onTap: controller.back,
          child: Container(color: Colors.white.withValues(alpha: .15)),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 35),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 69,
                height: 3,
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(
                  color: ShopColors.tile,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              for (final (sort, label) in [
                (ProductSort.popular, 'Popular'),
                (ProductSort.sales, 'Best Sales'),
                (ProductSort.alphabetical, 'A-Z Search'),
                (ProductSort.designer, 'Jully Kingston'),
              ])
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: controller.sort == sort
                                ? Colors.black
                                : ShopColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Switch(
                        value: controller.sort == sort,
                        activeThumbColor: Colors.white,
                        activeTrackColor: ShopColors.purple,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: ShopColors.tile,
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        onChanged: (_) {
                          controller.applySort(sort);
                          controller.back();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}

class FilterScreen extends StatefulWidget {
  const FilterScreen(this.controller, {super.key, this.expanded = false});
  final ShopController controller;
  final bool expanded;
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late final TextEditingController minimum;
  late final TextEditingController maximum;
  final sections = <String>{};
  final categories = <String>{};
  String? colour;
  String size = 'M';
  String? error;
  @override
  void initState() {
    super.initState();
    final filter = widget.controller.filter;
    minimum = TextEditingController(
      text: '${filter.min == 0 ? 10 : filter.min.toInt()}',
    );
    maximum = TextEditingController(
      text: '${filter.max == 200 ? 20 : filter.max.toInt()}',
    );
    categories.addAll(filter.categories);
    colour = filter.colour;
    size = filter.size;
    if (widget.expanded) sections.addAll(['Price range', 'Category', 'Size']);
  }

  @override
  void dispose() {
    minimum.dispose();
    maximum.dispose();
    super.dispose();
  }

  void clear() => setState(() {
    minimum.text = '0';
    maximum.text = '200';
    categories.clear();
    colour = null;
    size = 'M';
    error = null;
  });
  void apply() {
    final min = double.tryParse(minimum.text),
        max = double.tryParse(maximum.text);
    if (min == null || max == null || min < 0 || max < min) {
      setState(() => error = 'Enter a valid price range.');
      return;
    }
    widget.controller.applyFilter(
      ShopFilter(
        min: min,
        max: max,
        categories: Set.of(categories),
        colour: colour,
        size: size,
      ),
    );
    widget.controller.back();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) => Stack(
      children: [
        Column(children: [ShopHeader(widget.controller), const Spacer()]),
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.controller.back,
            child: Container(color: const Color(0xAA343774)),
          ),
        ),
        Positioned(
          top: bounds.maxHeight * .145,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 17, 12, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close filter',
                        onPressed: widget.controller.back,
                        icon: const Icon(Icons.close, size: 19),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    children: [
                      _section(
                        'Price range',
                        '\$${minimum.text} – \$${maximum.text}',
                        Row(
                          children: [
                            Expanded(
                              child: _priceField(minimum, 'Minimum price'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _priceField(maximum, 'Maximum price'),
                            ),
                          ],
                        ),
                      ),
                      _section(
                        'Category',
                        categories.isEmpty
                            ? 'Bag'
                            : '${categories.length} selected',
                        Column(
                          children: [
                            for (final (name, count) in [
                              ('Women Bag', '200'),
                              ('Gold', '1000'),
                              ('jewelry', '200'),
                              ("Women’s shoes", '350'),
                              ('Underwear', '15'),
                            ])
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: CheckboxListTile(
                                  value: categories.contains(name),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  secondary: Text(
                                    '($count)',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  activeColor: ShopColors.purple,
                                  onChanged: (v) => setState(() {
                                    if (v ?? false) {
                                      categories.add(name);
                                    } else {
                                      categories.remove(name);
                                    }
                                  }),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _section(
                        'Colour',
                        colour ?? '●',
                        Wrap(
                          spacing: 6,
                          children: [
                            for (final entry in [
                              ('Red', const Color(0xFFFF7177)),
                              ('Green', const Color(0xFFA9BFA6)),
                              ('Yellow', const Color(0xFFFFD87A)),
                              ('Black', const Color(0xFF3B3A49)),
                            ])
                              ChoiceChip(
                                label: Text(
                                  entry.$1,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                avatar: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: entry.$2,
                                ),
                                selected: colour == entry.$1,
                                onSelected: (v) => setState(
                                  () => colour = v ? entry.$1 : null,
                                ),
                              ),
                          ],
                        ),
                      ),
                      _section(
                        'Size',
                        '13cm  $size',
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final label in ['XS', 'S', 'M', 'L', 'XL'])
                              ChoiceChip(
                                label: Text(
                                  label,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                selected: size == label,
                                showCheckmark: false,
                                padding: EdgeInsets.zero,
                                onSelected: (_) => setState(() => size = label),
                              ),
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '13cm',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: clear,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            fixedSize: const Size.fromHeight(63),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: const BorderSide(color: ShopColors.tile),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: ShopButton(
                          'Apply',
                          icon: null,
                          onPressed: apply,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  Widget _priceField(TextEditingController control, String label) => TextField(
    controller: control,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11),
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
    ),
  );
  Widget _section(String title, String value, Widget child) {
    final open = sections.contains(title);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F3FA),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() {
              if (!sections.remove(title)) sections.add(title);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 23),
              child: Row(
                children: [
                  Icon(open ? Icons.remove : Icons.add, size: 19),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: ShopColors.muted,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: title == 'Colour'
                          ? ShopColors.purple
                          : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: child,
            ),
        ],
      ),
    );
  }
}
