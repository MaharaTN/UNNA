import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/categoryController.dart';
import '../controllers/postController.dart';
import '../utils/colors.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  AppBarHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Get.find<CategoryController>();
    PostController postController = Get.find<PostController>();
    return SafeArea(
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "U",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text("N",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: corSecundaria)),
          Text("И",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: corPrimaria)),
          Text(
            "A",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ]),
        /*actions: [
          QudsPopupButton(
            tooltip: 'Filtros',
            items: [
              QudsPopupMenuSection(
                  titleText: 'Por categorias',
                  leading: Obx(
                    () => Icon(
                      Icons.category,
                      size: 40,
                      color: postController.filterCategory.value != ""
                          ? Colors.blue
                          : null,
                    ),
                  ),
                  subItems: List.generate(
                    categoryController.categoryList.length,
                    (index) => QudsPopupMenuItem(
                      leading: Icon(
                        IconData(
                            int.parse(
                                categoryController.categoryList[index].icon),
                            fontFamily: 'MaterialIcons'),
                      ),
                      title: Text(categoryController.categoryList[index].name),
                      onPressed: () {
                        postController.filterCategory.value =
                            categoryController.categoryList[index].name;
                        postController.setFilter();
                      },
                    ),
                  )),
              QudsPopupMenuDivider(),
              QudsPopupMenuSection(
                  leading: Obx(() => Icon(
                        CupertinoIcons.calendar,
                        size: 40,
                        color: postController.filterDate.value != DateTime(1500)
                            ? Colors.green
                            : null,
                      )),
                  titleText: 'Por data',
                  subItems: [
                    QudsPopupMenuWidget(
                      builder: (context) => Center(
                        child: Text("Apartir de:"),
                      ),
                    ),
                    QudsPopupMenuWidget(
                      builder: (context) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          Get.dialog(
                            DatePickerDialog(
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            ),
                          ).then((value) {
                            if (value != null) {
                              postController.filterDate.value = value;
                              postController.setFilter();
                            }
                            Get.close(0);
                          });
                        },
                        child: Obx(
                          () => Text(
                            postController.filterDate.value == DateTime(1500)
                                ? "Selecione a data"
                                : Utils.dateTimeParseString(
                                    date: postController.filterDate.value,
                                    setHours: false),
                          ),
                        ),
                      ),
                    ),
                    QudsPopupMenuWidget(
                      builder: (context) => SizedBox(
                        height: 15,
                      ),
                    ),
                  ]),
              QudsPopupMenuDivider(),
              QudsPopupMenuItem(
                leading: Obx(() => Icon(
                      CupertinoIcons.heart_fill,
                      size: 40,
                      color:
                          postController.filterLiked.value ? Colors.red : null,
                    )),
                title: Text('Por like'),
                onPressed: () {
                  postController.filterLiked.value = true;
                  postController.setFilter();
                },
              ),
              QudsPopupMenuDivider(),
              QudsPopupMenuItem(
                leading: Icon(CupertinoIcons.clear_fill, size: 40),
                title: Text('Limpar Filtros'),
                onPressed: () {
                  postController.resetFilters();
                },
              ),
            ],
            child: Obx(
              () => Icon(
                  (postController.filterLiked.value ||
                          postController.filterCategory.value != "" ||
                          postController.filterDate.value != DateTime(1500))
                      ? Icons.filter_alt_rounded
                      : Icons.filter_alt_outlined,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],*/
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
