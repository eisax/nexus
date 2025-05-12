import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nexus/ui/screens/components/divider/custom_spacer.dart';
import 'package:nexus/ui/styles/style.dart';
import 'package:nexus/utils/dimensions.dart';
import 'package:nexus/utils/my_color.dart';



class SelectionBarWidget extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelected;

  const SelectionBarWidget({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            spreadRadius: 10,
            blurRadius: 5,
            color: MyColor.borderColor.withOpacity(0.25),
          ),
        ],
        color: MyColor.getCardBgColor(),
      ),
      padding: EdgeInsets.all(Dimensions.space15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            items.map((item) {
              return GestureDetector(
                onTap: () => onSelected(item),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.cardRadius2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item,
                          textAlign: TextAlign.center,
                          style: regularDefault.copyWith(
                            color:
                                selectedItem == item
                                    ? MyColor.getPrimaryColor()
                                    : MyColor.getGreyText(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        verticalSpace(Dimensions.space5),
                        Container(
                          width: 20,
                          height: 2,
                          decoration: BoxDecoration(
                            color:
                                selectedItem == item
                                    ? MyColor.getPrimaryColor()
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
