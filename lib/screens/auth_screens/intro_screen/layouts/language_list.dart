import 'package:fixit_provider/config.dart';

class LanguageList {
  List<Widget> langList(index, context) =>
      List.generate(appArray.languageList.length, (i) {
        return i == index
            ? Row(children: [
          Image.asset(
              appArray.languageList[index!]['icon']
                  .toString(),
              width: Sizes.s30,
              height: Sizes.s30),
          const HSpace(Sizes.s5),
          Text(
              language(
                  context,
                  appArray.languageList[index!]
                  ["title"]!
                      .toString())
                  .substring(0, 2)
                  .toUpperCase(),
              style: appCss.dmDenseMedium14.textColor(
                  appColor(context).appTheme.darkText),
              overflow: TextOverflow.ellipsis)
        ])
            : Container();
      });


  DropdownMenuItem dropDown(data,context,{GestureTapCallback? onTap}) => DropdownMenuItem(
      value: data["title"],
      onTap: onTap,
      child: Row(children: [
        Image.asset(data['icon'].toString(),
            width: Sizes.s30, height: Sizes.s30),
        const HSpace(Sizes.s5),
        SizedBox(
            width: Sizes.s50,
            child: Text(
                language(context,
                    data["title"]!.toString()),
                style: appCss.dmDenseMedium14.textColor(
                    appColor(context).appTheme.lightText),
                overflow: TextOverflow.ellipsis))
      ]));
}
