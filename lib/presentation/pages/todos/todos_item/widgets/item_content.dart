part of '../todos_item.dart';

class ItemContent extends StatefulWidget {
  final Todo element;
  const ItemContent({
    required this.element,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemContent> createState() => _ItemContentState();
}

// Здесь сделал LayoutBuilder + TextSpan, потому что в дизайне
// (хоть и почти незаметно) выравниваение текста разное в зависимости
// от количества строк:
// 1 строка => Текст выравнивается на уровень иконок
// 2 и больше строки => Текст и иконки все вместе выравниваются
// к верхней части элемента списка.

class _ItemContentState extends State<ItemContent> {
  final EdgeInsets checkboxPadding = const EdgeInsets.fromLTRB(19, 15, 15, 15);
  final EdgeInsets textPadding = const EdgeInsets.symmetric(vertical: 14);
  final EdgeInsets infoButtonPadding =
      const EdgeInsets.fromLTRB(14, 14, 18, 14);
  final EdgeInsets importanceIconPadding = const EdgeInsets.only(right: 4);

  final checkBoxSize = 18.0;
  final infoButtonSize = 20.0;
  final importanceIconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleSpan = TextSpan(
          text: widget.element.title,
          style: Theme.of(context).textTheme.body.copyWith(
                color: widget.element.done
                    ? getIt.get<ThemeBloc>().currentTheme.labelTertiary
                    : getIt.get<ThemeBloc>().currentTheme.labelPrimary,
                decoration: widget.element.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
        );

        final descriprionSpan = widget.element.description.isNotEmpty
            ? TextSpan(
                text: '\n${widget.element.description}',
                style: Theme.of(context).textTheme.smallBody.copyWith(
                      color: widget.element.done
                          ? getIt.get<ThemeBloc>().currentTheme.labelTertiary
                          : getIt.get<ThemeBloc>().currentTheme.labelSecondary,
                      decoration: widget.element.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
              )
            : null;

        double maxTextWidth = constraints.maxWidth -
            checkboxOccupiableWidth -
            infoButtonOccupiableWidth;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: centralizeText(titleSpan, maxTextWidth)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (widget.element.color != null)
                Container(
                  width: 5,
                  color: widget.element.color!.toColor(),
                ),
              Padding(
                padding: checkboxPadding,
                child: ItemCheckbox(
                  element: widget.element,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: textPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ItemText(
                        element: widget.element,
                        titleSpan: titleSpan,
                        descriprionSpan: descriprionSpan,
                        importanceIconSize: importanceIconSize,
                      ),
                      if (widget.element.tags != null)
                        const SizedBox(height: 5),
                      if (widget.element.tags != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.element.tags!
                              .map(
                                (tag) => Icon(
                                  tag.iconData,
                                  color: getIt
                                      .get<ThemeBloc>()
                                      .currentTheme
                                      .labelTertiary,
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: infoButtonPadding,
                child: _ItemInfoButton(
                  element: widget.element,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  double get checkboxOccupiableWidth =>
      checkBoxSize + checkboxPadding.left + checkboxPadding.right;

  double get infoButtonOccupiableWidth =>
      infoButtonSize + infoButtonPadding.left + infoButtonPadding.right;

  double get importanceIconOccpiableWidth =>
      importanceIconSize +
      importanceIconPadding.left +
      importanceIconPadding.right;

  bool centralizeText(TextSpan textSpan, double maxTextWidth) {
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxTextWidth);
    final metrics = textPainter.computeLineMetrics();

    if (widget.element.deadline != null) return false;
    if (widget.element.tags != null) return false;
    if (metrics.length == 1) {
      // если строка одна, но иконки важности не позволяют тексту
      // уместиться в эту одну строку, то централизировать не нужно
      if (widget.element.importance != Importance.low &&
          metrics[0].width > maxTextWidth - importanceIconOccpiableWidth) {
        return false;
      }
    } else {
      // ну и если строк больше, чем одна, тоже централизация не нужна
      return false;
    }

    return true;
  }
}
