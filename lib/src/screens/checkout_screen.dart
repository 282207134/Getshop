import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/shop_controller.dart';
import '../theme.dart';
import '../widgets/shop_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShopHeader(controller, back: true),
      const PageTitle('My Cart'),
      Expanded(
        child: controller.cart.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_basket_outlined,
                      size: 48,
                      color: ShopColors.muted,
                    ),
                    const SizedBox(height: 18),
                    const Text('Your cart is empty'),
                    TextButton(
                      onPressed: () => controller.go(AppScreen.shop),
                      child: const Text('Explore bags'),
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                children: [
                  for (final entry in controller.cart.entries.toList())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Dismissible(
                        key: ValueKey('cart-${entry.key}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) =>
                            controller.removeFromCart(entry.key),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 22),
                          decoration: BoxDecoration(
                            color: ShopColors.tile,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const CircleAvatar(
                            backgroundColor: ShopColors.pink,
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _editQuantity(context, entry.key),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 111,
                            padding: const EdgeInsets.all(19),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${controller.byId(entry.key).name} Awesome',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: ShopColors.muted,
                                        ),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            '\$${controller.byId(entry.key).price}.0',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Rating(),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Qty ${entry.value} · Tap to edit',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: ShopColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 61,
                                  height: 59,
                                  decoration: BoxDecoration(
                                    color: ShopColors.tile,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 20),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => controller.go(AppScreen.addCard),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      controller.cardLastFour == null
                          ? Icons.credit_card
                          : Icons.credit_score,
                      color: ShopColors.muted,
                      size: 31,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.cardLastFour == null
                          ? 'Add Card +'
                          : '•••• ${controller.cardLastFour}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${controller.cartCount} item',
                  style: const TextStyle(color: ShopColors.muted, fontSize: 13),
                ),
                Price(controller.total, size: 30),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 17, 20, 28),
        child: ShopButton(
          'Buy Now',
          key: const Key('checkout'),
          icon: Icons.shopping_basket_outlined,
          onPressed: controller.cart.isEmpty
              ? null
              : () {
                  if (controller.cardLastFour == null) {
                    controller.go(AppScreen.addCard);
                  } else {
                    controller.checkout();
                  }
                },
        ),
      ),
    ],
  );
  void _editQuantity(BuildContext context, String id) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.byId(id).name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                QuantityStepper(
                  value: controller.cart[id] ?? 1,
                  onChanged: (v) =>
                      controller.changeCart(id, v - (controller.cart[id] ?? 0)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        controller.removeFromCart(id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class AddCardScreen extends StatefulWidget {
  const AddCardScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final form = GlobalKey<FormState>();
  final holder = TextEditingController();
  final number = TextEditingController();
  final month = TextEditingController();
  final year = TextEditingController();
  final cvc = TextEditingController();
  @override
  void dispose() {
    for (final c in [holder, number, month, year, cvc]) {
      c.dispose();
    }
    super.dispose();
  }

  void save() {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    widget.controller.saveCard(holder.text, number.text);
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      ShopHeader(widget.controller, back: true),
      const PageTitle('Add New Card'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: form,
          child: Column(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: ShopColors.gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -110,
                      child: Opacity(
                        opacity: .15,
                        child: Image.asset(
                          'assets/images/contours.png',
                          width: 280,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.credit_card,
                              color: Colors.white,
                              size: 29,
                            ),
                            const Spacer(),
                            Text(
                              '********${number.text.length < 4 ? '00' : number.text.substring(number.text.length - 4)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          holder.text.isEmpty ? 'Chris Valley' : holder.text,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38),
              TextFormField(
                key: const Key('card-name'),
                controller: holder,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Name on card'),
                validator: (v) => (v?.trim().length ?? 0) < 2
                    ? 'Enter the cardholder name'
                    : null,
              ),
              const SizedBox(height: 22),
              TextFormField(
                key: const Key('card-number'),
                controller: number,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                ],
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Card number'),
                validator: (v) => RegExp(r'^\d{16}$').hasMatch(v ?? '')
                    ? null
                    : 'Use 16 digits for this demo',
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-month'),
                      controller: month,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(hintText: 'Month (MM)'),
                      validator: (v) {
                        final m = int.tryParse(v ?? '') ?? 0;
                        return m >= 1 && m <= 12 ? null : 'Use 01–12';
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-year'),
                      controller: year,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(hintText: 'Year (YY)'),
                      validator: (v) {
                        final y = int.tryParse(v ?? '') ?? -1;
                        final m = int.tryParse(month.text) ?? 0;
                        final now = DateTime.now();
                        return y > now.year % 100 ||
                                y == now.year % 100 && m >= now.month
                            ? null
                            : 'Card expired';
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              TextFormField(
                key: const Key('card-cvc'),
                controller: cvc,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => save(),
                decoration: const InputDecoration(hintText: 'CVC'),
                validator: (v) => RegExp(r'^\d{3,4}$').hasMatch(v ?? '')
                    ? null
                    : 'Use 3 or 4 digits',
              ),
              const SizedBox(height: 32),
              ShopButton(
                'Add Card',
                key: const Key('save-card'),
                icon: Icons.add,
                onPressed: save,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    ],
  );
}

class TimelineScreen extends StatelessWidget {
  const TimelineScreen(this.controller, {super.key});
  final ShopController controller;
  @override
  Widget build(BuildContext context) {
    final date = controller.orderedAt;
    final label = date == null
        ? '26 Jully'
        : '${date.day} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]}';
    return LayoutBuilder(
      builder: (context, bounds) => Stack(
        children: [
          Column(children: [ShopHeader(controller), const Spacer()]),
          Container(color: const Color(0xBB202020)),
          Positioned(
            top: bounds.maxHeight * .145,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Timeline',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close timeline',
                        onPressed: () => controller.go(AppScreen.home),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  for (var i = 0; i < 4; i++)
                    SizedBox(
                      height: i == 3 ? 53 : 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22,
                            child: Column(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: i == 0
                                        ? ShopColors.purple
                                        : ShopColors.tile,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ShopColors.tile,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                if (i < 3)
                                  Expanded(
                                    child: Container(
                                      width: 1,
                                      color: ShopColors.tile,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              i == 3
                                  ? 'Completed'
                                  : '${['Order Placed', 'Order Confirmed', 'Ready for Delivery'][i]} on $label',
                              style: const TextStyle(
                                color: ShopColors.muted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: ShopColors.gradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/smile.png',
                          width: 46,
                          height: 43,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Congratulations!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          date == null
                              ? description
                              : 'Your demo order is complete.\nThank you for shopping with getshop.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.7,
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
  }
}
