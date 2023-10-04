import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unna/controllers/categoryController.dart';
import 'package:unna/models/post.dart';
import 'package:unna/models/story_model.dart';
import 'package:unna/screens/story_page.dart';

import '../common/appbar_home.dart';
import '../controllers/add_new_story_controller.dart';
import '../controllers/postController.dart';
import '../controllers/userController.dart';
import '../services/database.dart';
import '../utils/colors.dart';
import '../widgets/postCard.dart';
import 'add_new_story.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scrollController = ScrollController();
  PostController postController = Get.find<PostController>();
  CategoryController _categoryController = Get.find<CategoryController>();
  String selectedFilter = 'geral';

  // PostController postController. = Get.find<PostController>();

  @override
  void initState() {
    if (_categoryController.categoryList.isEmpty) {
      _categoryController.get();
    }
    super.initState();
  }

  //  quando esta filtrando, aparecer no topo categoria com um X para remover filtro.

  //  comment count nao ta incrementando ao adicionar comentario em uma postagem NOVA (nem nas velhas parece)

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.find<UserController>();
    return Scaffold(
      backgroundColor: corFundoClara,
      appBar: AppBarHome(),
      extendBody: false,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: Database().getStorys(),
              builder: (context, snapshot) {
                //loading da conexão
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Center(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  );
                }
                //
                // verifica se ouve erro ou se é nulo
                if (snapshot.hasError || snapshot.data == null) {
                  return SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Center(
                      child: Text("Erro ao carregar Storys"),
                    ),
                  );
                }
                // percorre todos os documentos e transforma em storyModel
                List<StoryModel> tempStorys = [];
                for (var i = 0; i < snapshot.data!.docs.length; i++) {
                  tempStorys
                      .add(StoryModel.fromMap(snapshot.data!.docs[i].data()));
                }

                // ordenando os storys pelo usuário
                tempStorys.sort(
                  (a, b) {
                    if (a.userModel.id == b.userModel.id) {
                      return -1;
                    } else {
                      return 1;
                    }
                  },
                );
                //
                // junta todos os storys de um usuário
                List<List<StoryModel>> storys = [];
                String curretId = "";
                for (var i = 0; i < tempStorys.length; i++) {
                  if (curretId != tempStorys[i].userModel.id) {
                    curretId = tempStorys[i].userModel.id!;
                    storys.add([]);
                  }
                  if (curretId == tempStorys[i].userModel.id) {
                    storys.last.add(tempStorys[i]);
                  }
                }
                //
                //coloca o story do usuário como primeiro da lista
                if (_userController.user.userImage != null) {
                  storys.sort(
                    (a, b) {
                      if (a.first.userModel.id == _userController.user.id) {
                        return -1;
                      } else {
                        return 1;
                      }
                    },
                  );
                }
                // verifica se contem story do usuário e se não tiver coloca uma listar vazia no index 0
                bool contain = false;
                if (_userController.user.userImage != null) {
                  for (var i = 0; i < storys.length; i++) {
                    if (storys[i].first.userModel.id ==
                        _userController.user.id) {
                      contain = true;
                    }
                  }
                  if (contain == false) {
                    storys.insert(0, []);
                  }
                }
                //

                return Container(
                  height: 70,
                  width: double.infinity,
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 15),
                    itemCount: storys.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(
                      width: 5,
                    ),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (storys[index].isNotEmpty) {
                              Get.to(StoryPage(
                                storys: storys,
                                initialPage: index,
                              ));
                            } else {
                              Get.snackbar(
                                  "Ops", "Você não tem story no momento",
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  colorText: Colors.white);
                            }
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: index == 0
                                ? CachedNetworkImageProvider(
                                    _userController.user.userImage!)
                                : CachedNetworkImageProvider(
                                    storys[index].first.userModel.userImage!),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (index == 0)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Get.dialog(AlertDialog(
                                  actionsAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  title: Text("Tipo do Story"),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        Get.back();
                                        Get.dialog(Builder(
                                          builder: (context) {
                                            AddNewStoryController controller =
                                                AddNewStoryController();
                                            String textStory = "";
                                            return AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              title: Text("Texto do Story"),
                                              content: TextField(
                                                onChanged: (value) {
                                                  textStory = value;
                                                },
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                  onPressed: () {
                                                    if (textStory
                                                        .trim()
                                                        .isNotEmpty) {
                                                      controller.sendStoryText(
                                                        textStory.trim(),
                                                      );
                                                    }
                                                  },
                                                  child: Obx(() =>
                                                      controller.isLoading.value
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation(
                                                                        Colors
                                                                            .white),
                                                              ),
                                                            )
                                                          : Text("Adicionar")),
                                                )
                                              ],
                                            );
                                          },
                                        ));
                                      },
                                      child: Text("Tipo Texto"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        Get.back();
                                        Get.to(AddNewStory());
                                      },
                                      child: Text("Tipo Imagem"),
                                    )
                                  ],
                                ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white)),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
            StreamBuilder<QuerySnapshot<PostModel>>(
              stream: postController.getStreamPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(corPrimariaClara)),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(child: Text("Erro ao carregar Posts"));
                }
                postController.listAllPosts.clear();
                for (var element in snapshot.data!.docs) {
                  postController.listAllPosts.add(element.data());
                }
                postController.setFilter();

                return Obx(() {
                  if (postController.filteredPosts.isEmpty) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text('nenhum post no momento')));
                  }
                  return ListView.builder(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 15),
                      shrinkWrap: true,
                      primary: false,
                      controller: scrollController,
                      itemCount: postController.filteredPosts.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return PostCard(
                          post: postController.filteredPosts[index],
                        );
                      });
                });
              },
            ),
            // GetX<PostController>(
            //   // init: Get.put<PostController>(PostController()),
            //   init: Get.find<PostController>(),
            //   builder: (PostController? postController) {
            //     if (postController != null && postController.isLoading.value) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //             valueColor: AlwaysStoppedAnimation(corPrimariaClara)),
            //       );
            //     } else {
            //       if (postController != null) {
            //         print(' --- postController.postList.length=' +
            //             postController.postList.length.toString());
            //       } else {
            //         print(' --- postController.postList.length = null');
            //       }

            //       if (postController != null &&
            //           postController.postList.length != 0) {
            //         return RefreshIndicator(
            //             onRefresh: () async {
            //               // print(" --- refresh");
            //               // print(' --- Maior data:' + postController.postList[postController.postList.length - 1].toString());
            //               // print(' --- Mais antigo data:' + postController.postList[postController.postList.length - 1].createdAt.toDate().toString());
            //               // print(' --- MAis recente data:' + postController.postList[0].createdAt.toDate().toString());

            //               await postController.get(
            //                   startDate: postController.postList[0].createdAt,
            //                   quantity: 10,
            //                   isRefresh: true,
            //                   userId: _userController.user.id);
            //             },
            //             child: ListView.builder(
            //                 padding: const EdgeInsets.only(
            //                     left: 15, right: 15, top: 15),
            //                 shrinkWrap: true,
            //                 primary: false,
            //                 controller: scrollController,
            //                 itemCount: postController.postList.length,
            //                 itemBuilder: (BuildContext ctxt, int index) {
            //                   return new PostCard(
            //                       post: postController.postList[index]);
            //                 }));
            //       } else {
            //         print(' --- CAIU AQUI');
            //         return Center(child: Text('nenhum post no momento'));
            //       }
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
