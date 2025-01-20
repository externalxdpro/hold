import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Color? titleColor;
  final Color? subtitleColor;

  const HomeTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
      subtitleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: subtitleColor,
          ),
      onTap: onTap,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class InactiveHomeTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const InactiveHomeTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return HomeTile(
      titleColor: Colors.grey,
      subtitleColor: Colors.grey,
      title: title,
      subtitle: subtitle,
    );
  }
}

class YouTile extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final void Function() onTap;

  const YouTile({
    super.key,
    required this.title,
    this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 40.0),
                Center(
                  child: Icon(
                    iconData,
                    size: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InactiveYouTile extends StatelessWidget {
  final String title;

  const InactiveYouTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 40.0),
              const Center(
                child: Icon(
                  Icons.bubble_chart_outlined,
                  size: 100.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final List<List<Widget?>> content;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double seperatorHeight;
  final List<Function()>? onPressed;

  const InfoTile({
    super.key,
    required this.title,
    required this.content,
    this.borderRadius,
    this.padding,
    this.seperatorHeight = 0.0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(
            top: 40.0,
            left: 15.0,
            right: 15.0,
            bottom: 40.0,
          ),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyLarge!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ...content.asMap().entries.map((entry) {
              int idx = entry.key;
              List<Widget?> val = entry.value;

              return GestureDetector(
                onTap: onPressed?[idx],
                child: Column(
                  children: [
                    SizedBox(height: seperatorHeight),
                    Row(
                      children: [
                        val[0] ?? const Text(''),
                        const Spacer(),
                        val[1] ?? const Text(''),
                      ],
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class IconWithButtonTile extends StatelessWidget {
  final String title;
  final List<List<Widget?>> content;
  final String buttonText;
  final Color? buttonColor;
  final void Function() onTap;

  const IconWithButtonTile({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoTile(
          title: title,
          content: content,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          padding: const EdgeInsets.all(15.0),
        ),
        Ink(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            color: buttonColor ?? Colors.black,
          ),
          height: 70.0,
          width: double.infinity,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                buttonText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CharityTile extends StatelessWidget {
  final bool verticalPadding;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? leadingAndTrailingTextStyle;
  final Color? iconColor;
  final String title;
  final bool titleBold;
  final Color? titleColor;
  final String? subtitle;
  final void Function()? onTap;

  const CharityTile({
    super.key,
    this.verticalPadding = false,
    this.leading,
    this.trailing = const Icon(Icons.navigate_next, color: Colors.grey),
    this.leadingAndTrailingTextStyle,
    this.iconColor,
    required this.title,
    this.titleBold = false,
    this.titleColor,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: verticalPadding
          ? const EdgeInsets.all(15.0)
          : const EdgeInsets.only(left: 15.0, right: 15.0),
      tileColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      leading: leading,
      iconColor: iconColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: titleBold ? FontWeight.bold : null,
              color: titleColor,
            ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 10.0, fontWeight: FontWeight.bold),
            ),
      trailing: trailing,
      leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
      onTap: onTap,
    );
  }
}

class InactiveCharityTile extends StatelessWidget {
  final bool verticalPadding;
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final bool titleBold;
  final String? subtitle;

  const InactiveCharityTile({
    super.key,
    this.verticalPadding = false,
    this.leading,
    this.trailing,
    required this.title,
    this.titleBold = false,
    this.subtitle,
  });

  @override
  Widget build(context) {
    return CharityTile(
      verticalPadding: verticalPadding,
      leading: leading,
      trailing: trailing,
      leadingAndTrailingTextStyle: const TextStyle(color: Colors.grey),
      iconColor: Colors.grey,
      title: title,
      titleBold: titleBold,
      titleColor: Colors.grey,
      subtitle: subtitle,
      onTap: null,
    );
  }
}
