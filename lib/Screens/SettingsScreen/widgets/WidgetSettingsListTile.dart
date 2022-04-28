import 'package:flutter/material.dart';

class WidgetSettingsListTile extends StatelessWidget {
  final String settingTitle;
  final String? settingSubTitle;
  final IconData settingIIconData;
  final VoidCallback? settingOnTappedListTile;
  final int iconQuarterTurns;

  const WidgetSettingsListTile(
      {Key? key,
      required this.settingTitle,
      this.settingSubTitle,
      required this.settingIIconData,
      this.settingOnTappedListTile,
      this.iconQuarterTurns = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: settingOnTappedListTile,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RotatedBox(
                  quarterTurns: iconQuarterTurns,
                  child: Icon(
                    settingIIconData,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    settingTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.normal,fontSize: 22),
                  ),
                  if (settingSubTitle != null)
                    Text(
                      settingSubTitle!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.normal,color: Colors.black54),
                    ),
                ],
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
