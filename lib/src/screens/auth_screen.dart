import 'package:flutter/material.dart';
import '../state/shop_controller.dart';
import '../theme.dart';
import '../widgets/shop_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(this.controller, {super.key, this.signup = false});
  final ShopController controller;
  final bool signup;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool obscure = true;
  bool avatar = false;
  @override
  void dispose() {
    for (final c in [name, email, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    widget.controller.login(
      name: name.text,
      email: widget.signup ? email.text : null,
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: bounds.maxHeight),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Positioned(
                left: -24,
                top: -50,
                child: Image.asset('assets/images/contours.png', width: 303),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: widget.signup ? 62 : 91),
                      if (widget.signup)
                        InkWell(
                          onTap: () => setState(() => avatar = !avatar),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 106,
                            height: 98,
                            decoration: BoxDecoration(
                              color: ShopColors.tile,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: avatar
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/avatar.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(7),
                                      child: Icon(
                                        Icons.add_box,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        )
                      else
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'get',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'shop',
                                style: TextStyle(color: ShopColors.purple),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      SizedBox(height: widget.signup ? 42 : 97),
                      Text(
                        widget.signup ? 'Sign Up' : 'Login',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const Key('auth-name'),
                        controller: name,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        decoration: InputDecoration(
                          hintText: widget.signup ? 'Name' : 'User Name',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 23),
                      if (widget.signup) ...[
                        TextFormField(
                          key: const Key('auth-email'),
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(hintText: 'Email'),
                          validator: (v) =>
                              RegExp(
                                r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                              ).hasMatch(v ?? '')
                              ? null
                              : 'Enter a valid email',
                        ),
                        const SizedBox(height: 23),
                      ],
                      TextFormField(
                        key: const Key('auth-password'),
                        controller: password,
                        obscureText: obscure,
                        textInputAction: widget.signup
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onFieldSubmitted: (_) {
                          if (!widget.signup) submit();
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            tooltip: 'Show password',
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: ShopColors.muted,
                            ),
                          ),
                        ),
                        validator: (v) => (v?.length ?? 0) >= 6
                            ? null
                            : 'Use at least 6 characters',
                      ),
                      if (widget.signup) ...[
                        const SizedBox(height: 23),
                        TextFormField(
                          key: const Key('auth-confirm'),
                          controller: confirm,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: 'Confirm password',
                          ),
                          validator: (v) => v == password.text
                              ? null
                              : 'Passwords do not match',
                          onFieldSubmitted: (_) => submit(),
                        ),
                      ],
                      const SizedBox(height: 30),
                      ShopButton(
                        widget.signup ? 'Next' : 'Login Getshop',
                        key: const Key('auth-submit'),
                        onPressed: submit,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            widget.signup
                                ? 'I already have an account.'
                                : 'I dont have account.',
                            style: const TextStyle(
                              color: ShopColors.muted,
                              fontSize: 11,
                            ),
                          ),
                          TextButton(
                            onPressed: () => widget.controller.go(
                              widget.signup
                                  ? AppScreen.login
                                  : AppScreen.signup,
                            ),
                            child: Text(
                              widget.signup ? 'Log in' : 'Sing up',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      if (!widget.signup) ...[
                        const SizedBox(height: 90),
                        Row(
                          children: [
                            Expanded(
                              child: ShopButton(
                                'Facebook',
                                height: 62,
                                icon: null,
                                color: const Color(0xFF4D3CE8),
                                onPressed: () => showNotice(
                                  context,
                                  'Facebook sign-in is not connected. Use the demo login above.',
                                ),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: ShopButton(
                                'Google',
                                height: 62,
                                icon: null,
                                color: const Color(0xFFFF686B),
                                onPressed: () => showNotice(
                                  context,
                                  'Google sign-in is not connected. Use the demo login above.',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
