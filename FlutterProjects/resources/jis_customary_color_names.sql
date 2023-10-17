
-- JIS慣用色名より金色、銀色を除き、RGB値および色名を抽出
-- 参照 https://ja.wikipedia.org/wiki/JIS%E6%85%A3%E7%94%A8%E8%89%B2%E5%90%8D

CREATE TABLE jis_customary_color_names (
    id INT PRIMARY KEY NOT NULL,
    rgb TEXT NOT NULL,
    name TEXT NOT NULL
);

INSERT INTO jis_customary_color_names VALUES (1,'F9A1D0','とき色');
INSERT INTO jis_customary_color_names VALUES (2,'CB4B94','つつじ色');
INSERT INTO jis_customary_color_names VALUES (3,'FFDBED','桜色');
INSERT INTO jis_customary_color_names VALUES (4,'D34778','ばら色');
INSERT INTO jis_customary_color_names VALUES (5,'E3557F','からくれない');
INSERT INTO jis_customary_color_names VALUES (6,'FF87A0','さんご色');
INSERT INTO jis_customary_color_names VALUES (7,'E08899','紅梅（こうばい）色');
INSERT INTO jis_customary_color_names VALUES (8,'E38698','桃色');
INSERT INTO jis_customary_color_names VALUES (9,'BD1E48','紅色');
INSERT INTO jis_customary_color_names VALUES (10,'B92946','紅赤');
INSERT INTO jis_customary_color_names VALUES (11,'AE3846','えんじ');
INSERT INTO jis_customary_color_names VALUES (12,'974B52','蘇芳（すおう）');
INSERT INTO jis_customary_color_names VALUES (13,'A0283A','茜（あかね）色');
INSERT INTO jis_customary_color_names VALUES (14,'BF1E33','赤');
INSERT INTO jis_customary_color_names VALUES (15,'ED514E','朱色');
INSERT INTO jis_customary_color_names VALUES (16,'A14641','紅樺（べにかば）色');
INSERT INTO jis_customary_color_names VALUES (17,'EE5145','紅緋（べにひ）');
INSERT INTO jis_customary_color_names VALUES (18,'D3503C','鉛丹（えんたん）色');
INSERT INTO jis_customary_color_names VALUES (19,'703B32','紅海老茶');
INSERT INTO jis_customary_color_names VALUES (20,'7D483E','とび色');
INSERT INTO jis_customary_color_names VALUES (21,'946259','小豆（あずき）色');
INSERT INTO jis_customary_color_names VALUES (22,'8A4031','弁柄（べんがら）色');
INSERT INTO jis_customary_color_names VALUES (23,'6D3D33','海老茶');
INSERT INTO jis_customary_color_names VALUES (24,'ED542A','金赤');
INSERT INTO jis_customary_color_names VALUES (25,'B15237','赤茶');
INSERT INTO jis_customary_color_names VALUES (26,'923A21','赤錆色');
INSERT INTO jis_customary_color_names VALUES (27,'EF6D3E','黄丹（おうに）');
INSERT INTO jis_customary_color_names VALUES (28,'ED551B','赤橙');
INSERT INTO jis_customary_color_names VALUES (29,'E06030','柿色');
INSERT INTO jis_customary_color_names VALUES (30,'B97761','肉桂（にっけい）色');
INSERT INTO jis_customary_color_names VALUES (31,'BD4A1D','樺（かば）色');
INSERT INTO jis_customary_color_names VALUES (32,'974E33','れんが色');
INSERT INTO jis_customary_color_names VALUES (33,'664134','錆色');
INSERT INTO jis_customary_color_names VALUES (34,'8A604F','檜皮（ひわだ）色');
INSERT INTO jis_customary_color_names VALUES (35,'754C38','栗色');
INSERT INTO jis_customary_color_names VALUES (36,'E45E00','黄赤');
INSERT INTO jis_customary_color_names VALUES (37,'BA6432','たいしゃ');
INSERT INTO jis_customary_color_names VALUES (38,'B67A52','らくだ色');
INSERT INTO jis_customary_color_names VALUES (39,'BB6421','黄茶');
INSERT INTO jis_customary_color_names VALUES (40,'F4BE9B','肌色');
INSERT INTO jis_customary_color_names VALUES (41,'FD7E00','橙色');
INSERT INTO jis_customary_color_names VALUES (42,'866955','灰茶');
INSERT INTO jis_customary_color_names VALUES (43,'734E30','茶色');
INSERT INTO jis_customary_color_names VALUES (44,'594639','焦茶');
INSERT INTO jis_customary_color_names VALUES (45,'FFA75E','こうじ色');
INSERT INTO jis_customary_color_names VALUES (46,'DDA273','杏色');
INSERT INTO jis_customary_color_names VALUES (47,'FA8000','蜜柑色');
INSERT INTO jis_customary_color_names VALUES (48,'763900','褐色');
INSERT INTO jis_customary_color_names VALUES (49,'A96E2D','土色');
INSERT INTO jis_customary_color_names VALUES (50,'D9A46D','小麦色');
INSERT INTO jis_customary_color_names VALUES (51,'C67400','こはく色');
INSERT INTO jis_customary_color_names VALUES (52,'C47600','金茶');
INSERT INTO jis_customary_color_names VALUES (53,'FABE6F','卵色');
INSERT INTO jis_customary_color_names VALUES (54,'FFA500','山吹色');
INSERT INTO jis_customary_color_names VALUES (55,'C18A39','黄土色');
INSERT INTO jis_customary_color_names VALUES (56,'897868','朽葉（くちば）色');
INSERT INTO jis_customary_color_names VALUES (57,'FFB500','ひまわり色');
INSERT INTO jis_customary_color_names VALUES (58,'FCAC00','うこん色');
INSERT INTO jis_customary_color_names VALUES (59,'C9B9A8','砂色');
INSERT INTO jis_customary_color_names VALUES (60,'CDA966','芥子（からし）色');
INSERT INTO jis_customary_color_names VALUES (61,'FFBE00','黄色');
INSERT INTO jis_customary_color_names VALUES (62,'FFBE00','たんぽぽ色');
INSERT INTO jis_customary_color_names VALUES (63,'70613A','鶯茶');
INSERT INTO jis_customary_color_names VALUES (64,'FAD43A','中黄');
INSERT INTO jis_customary_color_names VALUES (65,'EED67E','刈安（かりやす）色');
INSERT INTO jis_customary_color_names VALUES (66,'D9CB65','きはだ色');
INSERT INTO jis_customary_color_names VALUES (67,'736F55','みる色');
INSERT INTO jis_customary_color_names VALUES (68,'C2C05C','ひわ色');
INSERT INTO jis_customary_color_names VALUES (69,'71714A','鶯（うぐいす）色');
INSERT INTO jis_customary_color_names VALUES (70,'BDBF92','抹茶色');
INSERT INTO jis_customary_color_names VALUES (71,'B9C42F','黄緑');
INSERT INTO jis_customary_color_names VALUES (72,'7A7F46','苔色');
INSERT INTO jis_customary_color_names VALUES (73,'A9B735','若草色');
INSERT INTO jis_customary_color_names VALUES (74,'96AA3D','萌黄（もえぎ）');
INSERT INTO jis_customary_color_names VALUES (75,'72814B','草色');
INSERT INTO jis_customary_color_names VALUES (76,'AFC297','若葉色');
INSERT INTO jis_customary_color_names VALUES (77,'6E815C','松葉色');
INSERT INTO jis_customary_color_names VALUES (78,'CADBCF','白緑（びゃくろく）');
INSERT INTO jis_customary_color_names VALUES (79,'4DB56A','緑');
INSERT INTO jis_customary_color_names VALUES (80,'357C4C','常磐（ときわ）色');
INSERT INTO jis_customary_color_names VALUES (81,'5F836D','緑青（ろくしょう）色');
INSERT INTO jis_customary_color_names VALUES (82,'4A6956','千歳緑（ちとせみどり）');
INSERT INTO jis_customary_color_names VALUES (83,'005731','深緑');
INSERT INTO jis_customary_color_names VALUES (84,'15543B','もえぎ色');
INSERT INTO jis_customary_color_names VALUES (85,'49A581','若竹色');
INSERT INTO jis_customary_color_names VALUES (86,'80AA9F','青磁色');
INSERT INTO jis_customary_color_names VALUES (87,'7AAAAC','青竹色');
INSERT INTO jis_customary_color_names VALUES (88,'244344','鉄色');
INSERT INTO jis_customary_color_names VALUES (89,'0090A8','青緑');
INSERT INTO jis_customary_color_names VALUES (90,'6C8D9B','錆浅葱');
INSERT INTO jis_customary_color_names VALUES (91,'7A99AA','水浅葱');
INSERT INTO jis_customary_color_names VALUES (92,'69AAC6','新橋色');
INSERT INTO jis_customary_color_names VALUES (93,'0087AA','浅葱（あさぎ）色');
INSERT INTO jis_customary_color_names VALUES (94,'84B5CF','白群（びゃくぐん）');
INSERT INTO jis_customary_color_names VALUES (95,'166A88','納戸色');
INSERT INTO jis_customary_color_names VALUES (96,'8CB4CE','かめのぞき');
INSERT INTO jis_customary_color_names VALUES (97,'A9CEEC','水色');
INSERT INTO jis_customary_color_names VALUES (98,'5E7184','藍鼠（あいねず）');
INSERT INTO jis_customary_color_names VALUES (99,'95C0EC','空色');
INSERT INTO jis_customary_color_names VALUES (100,'0067C0','青');
INSERT INTO jis_customary_color_names VALUES (101,'2E4B71','藍色');
INSERT INTO jis_customary_color_names VALUES (102,'20324E','濃藍（こいあい）');
INSERT INTO jis_customary_color_names VALUES (103,'92AFE4','勿忘草（わすれなぐさ）色');
INSERT INTO jis_customary_color_names VALUES (104,'3D7CCE','露草色');
INSERT INTO jis_customary_color_names VALUES (105,'3C639B','はなだ色');
INSERT INTO jis_customary_color_names VALUES (106,'3D496B','紺青（こんじょう）');
INSERT INTO jis_customary_color_names VALUES (107,'3451A4','るり色');
INSERT INTO jis_customary_color_names VALUES (108,'324784','るり紺');
INSERT INTO jis_customary_color_names VALUES (109,'333C5E','紺色');
INSERT INTO jis_customary_color_names VALUES (110,'4C5DAB','かきつばた色');
INSERT INTO jis_customary_color_names VALUES (111,'383C57','勝色（かちいろ）');
INSERT INTO jis_customary_color_names VALUES (112,'414FA3','群青（ぐんじょう）色');
INSERT INTO jis_customary_color_names VALUES (113,'232538','鉄紺');
INSERT INTO jis_customary_color_names VALUES (114,'6869A8','藤納戸');
INSERT INTO jis_customary_color_names VALUES (115,'4A49AD','ききょう色');
INSERT INTO jis_customary_color_names VALUES (116,'35357D','紺藍');
INSERT INTO jis_customary_color_names VALUES (117,'A09BD8','藤色');
INSERT INTO jis_customary_color_names VALUES (118,'948BDB','藤紫');
INSERT INTO jis_customary_color_names VALUES (119,'704CBC','青紫');
INSERT INTO jis_customary_color_names VALUES (120,'6D52AB','菫（すみれ）色');
INSERT INTO jis_customary_color_names VALUES (121,'675D7E','鳩羽（はとば）色');
INSERT INTO jis_customary_color_names VALUES (122,'7051AA','しょうぶ色');
INSERT INTO jis_customary_color_names VALUES (123,'5F4C86','江戸紫');
INSERT INTO jis_customary_color_names VALUES (124,'A260BF','紫');
INSERT INTO jis_customary_color_names VALUES (125,'775686','古代紫');
INSERT INTO jis_customary_color_names VALUES (126,'47384F','なす紺');
INSERT INTO jis_customary_color_names VALUES (127,'402949','紫紺');
INSERT INTO jis_customary_color_names VALUES (128,'C27BC8','あやめ色');
INSERT INTO jis_customary_color_names VALUES (129,'C24DAE','牡丹（ぼたん）色');
INSERT INTO jis_customary_color_names VALUES (130,'C54EA0','赤紫');
INSERT INTO jis_customary_color_names VALUES (131,'F1F1F1','白');
INSERT INTO jis_customary_color_names VALUES (132,'F2E8EC','胡粉（ごふん）色');
INSERT INTO jis_customary_color_names VALUES (133,'F0E2E0','生成り（きなり）色');
INSERT INTO jis_customary_color_names VALUES (134,'E3D4CA','象牙（ぞうげ）色');
INSERT INTO jis_customary_color_names VALUES (135,'A0A0A0','銀鼠（ぎんねず）');
INSERT INTO jis_customary_color_names VALUES (136,'9F9190','茶鼠');
INSERT INTO jis_customary_color_names VALUES (137,'868686','鼠色');
INSERT INTO jis_customary_color_names VALUES (138,'787C7A','利休鼠');
INSERT INTO jis_customary_color_names VALUES (139,'797A88','鉛色');
INSERT INTO jis_customary_color_names VALUES (140,'797979','灰色');
INSERT INTO jis_customary_color_names VALUES (141,'605448','すす竹色');
INSERT INTO jis_customary_color_names VALUES (142,'3E2E28','黒茶');
INSERT INTO jis_customary_color_names VALUES (143,'313131','墨');
INSERT INTO jis_customary_color_names VALUES (144,'262626','黒');
INSERT INTO jis_customary_color_names VALUES (145,'262626','鉄黒');
INSERT INTO jis_customary_color_names VALUES (146,'C74F90','ローズレッド');
INSERT INTO jis_customary_color_names VALUES (147,'EF93B6','ローズピンク');
INSERT INTO jis_customary_color_names VALUES (148,'AF3168','コチニールレッド');
INSERT INTO jis_customary_color_names VALUES (149,'B91E68','ルビーレッド');
INSERT INTO jis_customary_color_names VALUES (150,'83274E','ワインレッド');
INSERT INTO jis_customary_color_names VALUES (151,'452A35','バーガンディー');
INSERT INTO jis_customary_color_names VALUES (152,'C97F96','オールドローズ');
INSERT INTO jis_customary_color_names VALUES (153,'D94177','ローズ');
INSERT INTO jis_customary_color_names VALUES (154,'BB1E5E','ストロベリー');
INSERT INTO jis_customary_color_names VALUES (155,'FF87A0','コーラルレッド');
INSERT INTO jis_customary_color_names VALUES (156,'EB97A8','ピンク');
INSERT INTO jis_customary_color_names VALUES (157,'55353B','ボルドー');
INSERT INTO jis_customary_color_names VALUES (158,'FFC9D2','ベビーピンク');
INSERT INTO jis_customary_color_names VALUES (159,'DD4157','ポピーレッド');
INSERT INTO jis_customary_color_names VALUES (160,'CE314A','シグナルレッド');
INSERT INTO jis_customary_color_names VALUES (161,'BE1E3E','カーマイン');
INSERT INTO jis_customary_color_names VALUES (162,'DE424C','レッド');
INSERT INTO jis_customary_color_names VALUES (163,'DE424C','トマトレッド');
INSERT INTO jis_customary_color_names VALUES (164,'682A2B','マルーン');
INSERT INTO jis_customary_color_names VALUES (165,'ED514E','バーミリオン');
INSERT INTO jis_customary_color_names VALUES (166,'DE4335','スカーレット');
INSERT INTO jis_customary_color_names VALUES (167,'AC5647','テラコッタ');
INSERT INTO jis_customary_color_names VALUES (168,'FFA594','サーモンピンク');
INSERT INTO jis_customary_color_names VALUES (169,'FBCCC3','シェルピンク');
INSERT INTO jis_customary_color_names VALUES (170,'F1BEB1','ネールピンク');
INSERT INTO jis_customary_color_names VALUES (171,'FF5D20','チャイニーズレッド');
INSERT INTO jis_customary_color_names VALUES (172,'CC572C','キャロットオレンジ');
INSERT INTO jis_customary_color_names VALUES (173,'A8593C','バーントシェンナ');
INSERT INTO jis_customary_color_names VALUES (174,'52372F','チョコレート');
INSERT INTO jis_customary_color_names VALUES (175,'754C38','ココアブラウン');
INSERT INTO jis_customary_color_names VALUES (176,'EBC0AF','ピーチ');
INSERT INTO jis_customary_color_names VALUES (177,'BB6421','ローシェンナ');
INSERT INTO jis_customary_color_names VALUES (178,'FD7E00','オレンジ');
INSERT INTO jis_customary_color_names VALUES (179,'734E31','ブラウン');
INSERT INTO jis_customary_color_names VALUES (180,'DDA273','アプリコット');
INSERT INTO jis_customary_color_names VALUES (181,'A56F3F','タン');
INSERT INTO jis_customary_color_names VALUES (182,'FD951E','マンダリンオレンジ');
INSERT INTO jis_customary_color_names VALUES (183,'A58161','コルク');
INSERT INTO jis_customary_color_names VALUES (184,'F8CFAE','エクルベイジュ');
INSERT INTO jis_customary_color_names VALUES (185,'F39A38','ゴールデンイエロー');
INSERT INTO jis_customary_color_names VALUES (186,'FFA000','マリーゴールド');
INSERT INTO jis_customary_color_names VALUES (187,'C5996D','バフ');
INSERT INTO jis_customary_color_names VALUES (188,'B37D40','アンバー');
INSERT INTO jis_customary_color_names VALUES (189,'815A2B','ブロンズ');
INSERT INTO jis_customary_color_names VALUES (190,'C1AB96','ベージュ');
INSERT INTO jis_customary_color_names VALUES (191,'C18A39','イエローオーカー');
INSERT INTO jis_customary_color_names VALUES (192,'5B462A','バーントアンバー');
INSERT INTO jis_customary_color_names VALUES (193,'4A3B2A','セピア');
INSERT INTO jis_customary_color_names VALUES (194,'9A753A','カーキー');
INSERT INTO jis_customary_color_names VALUES (195,'E3B466','ブロンド');
INSERT INTO jis_customary_color_names VALUES (196,'F2C26B','ネープルスイエロー');
INSERT INTO jis_customary_color_names VALUES (197,'E1C59B','レグホーン');
INSERT INTO jis_customary_color_names VALUES (198,'7F5C13','ローアンバー');
INSERT INTO jis_customary_color_names VALUES (199,'FFBC00','クロムイエロー');
INSERT INTO jis_customary_color_names VALUES (200,'FFCC00','イエロー');
INSERT INTO jis_customary_color_names VALUES (201,'E8D5AF','クリームイエロー');
INSERT INTO jis_customary_color_names VALUES (202,'FFCC00','ジョンブリアン');
INSERT INTO jis_customary_color_names VALUES (203,'F7D54E','カナリヤ');
INSERT INTO jis_customary_color_names VALUES (204,'68624E','オリーブドラブ');
INSERT INTO jis_customary_color_names VALUES (205,'605627','オリーブ');
INSERT INTO jis_customary_color_names VALUES (206,'E8C800','レモンイエロー');
INSERT INTO jis_customary_color_names VALUES (207,'565838','オリーブグリーン');
INSERT INTO jis_customary_color_names VALUES (208,'BDD458','シャトルーズグリーン');
INSERT INTO jis_customary_color_names VALUES (209,'879D4E','リーフグリーン');
INSERT INTO jis_customary_color_names VALUES (210,'737C3E','グラスグリーン');
INSERT INTO jis_customary_color_names VALUES (211,'9AB961','シーグリーン');
INSERT INTO jis_customary_color_names VALUES (212,'516A39','アイビーグリーン');
INSERT INTO jis_customary_color_names VALUES (213,'B0D3A8','アップルグリーン');
INSERT INTO jis_customary_color_names VALUES (214,'81CC91','ミントグリーン');
INSERT INTO jis_customary_color_names VALUES (215,'2A9B50','グリーン');
INSERT INTO jis_customary_color_names VALUES (216,'5DC288','コバルトグリーン');
INSERT INTO jis_customary_color_names VALUES (217,'4DA573','エメラルドグリーン');
INSERT INTO jis_customary_color_names VALUES (218,'008047','マラカイトグリーン');
INSERT INTO jis_customary_color_names VALUES (219,'264435','ボトルグリーン');
INSERT INTO jis_customary_color_names VALUES (220,'3E795C','フォレストグリーン');
INSERT INTO jis_customary_color_names VALUES (221,'156F5C','ビリジアン');
INSERT INTO jis_customary_color_names VALUES (222,'004840','ビリヤードグリーン');
INSERT INTO jis_customary_color_names VALUES (223,'007F91','ピーコックグリーン');
INSERT INTO jis_customary_color_names VALUES (224,'5190A4','ナイルブルー');
INSERT INTO jis_customary_color_names VALUES (225,'00708B','ピーコックブルー');
INSERT INTO jis_customary_color_names VALUES (226,'399ECC','ターコイズブルー');
INSERT INTO jis_customary_color_names VALUES (227,'005175','マリンブルー');
INSERT INTO jis_customary_color_names VALUES (228,'91B2D2','ホリゾンブルー');
INSERT INTO jis_customary_color_names VALUES (229,'219DDD','シアン');
INSERT INTO jis_customary_color_names VALUES (230,'95C0EC','スカイブルー');
INSERT INTO jis_customary_color_names VALUES (231,'0B74AF','セルリアンブルー');
INSERT INTO jis_customary_color_names VALUES (232,'ABBDDA','ベビーブルー');
INSERT INTO jis_customary_color_names VALUES (233,'627DA1','サックスブルー');
INSERT INTO jis_customary_color_names VALUES (234,'3170B9','ブルー');
INSERT INTO jis_customary_color_names VALUES (235,'2863AB','コバルトブルー');
INSERT INTO jis_customary_color_names VALUES (236,'3D496B','アイアンブルー');
INSERT INTO jis_customary_color_names VALUES (237,'3D496B','プルシャンブルー');
INSERT INTO jis_customary_color_names VALUES (238,'00152D','ミッドナイトブルー');
INSERT INTO jis_customary_color_names VALUES (239,'7586BB','ヒヤシンス');
INSERT INTO jis_customary_color_names VALUES (240,'333C5E','ネービーブルー');
INSERT INTO jis_customary_color_names VALUES (241,'414FA3','ウルトラマリンブルー');
INSERT INTO jis_customary_color_names VALUES (242,'37438F','オリエンタルブルー');
INSERT INTO jis_customary_color_names VALUES (243,'776ED2','ウィスタリア');
INSERT INTO jis_customary_color_names VALUES (244,'40317E','パンジー');
INSERT INTO jis_customary_color_names VALUES (245,'836DC5','ヘリオトロープ');
INSERT INTO jis_customary_color_names VALUES (246,'6D52AB','バイオレット');
INSERT INTO jis_customary_color_names VALUES (247,'9E8EAE','ラベンダー');
INSERT INTO jis_customary_color_names VALUES (248,'835FA8','モーブ');
INSERT INTO jis_customary_color_names VALUES (249,'C2A2DA','ライラック');
INSERT INTO jis_customary_color_names VALUES (250,'C7A1D7','オーキッド');
INSERT INTO jis_customary_color_names VALUES (251,'A260BF','パープル');
INSERT INTO jis_customary_color_names VALUES (252,'C949A2','マゼンタ');
INSERT INTO jis_customary_color_names VALUES (253,'CF61A5','チェリーピンク');
INSERT INTO jis_customary_color_names VALUES (254,'F1F1F1','ホワイト');
INSERT INTO jis_customary_color_names VALUES (255,'F1F1F1','スノーホワイト');
INSERT INTO jis_customary_color_names VALUES (256,'E3D4CA','アイボリー');
INSERT INTO jis_customary_color_names VALUES (257,'BABAC6','スカイグレイ');
INSERT INTO jis_customary_color_names VALUES (258,'ADADAD','パールグレイ');
INSERT INTO jis_customary_color_names VALUES (259,'A0A0A0','シルバーグレイ');
INSERT INTO jis_customary_color_names VALUES (260,'939393','アッシュグレイ');
INSERT INTO jis_customary_color_names VALUES (261,'93848B','ローズグレイ');
INSERT INTO jis_customary_color_names VALUES (262,'797979','グレイ');
INSERT INTO jis_customary_color_names VALUES (263,'736C79','スチールグレイ');
INSERT INTO jis_customary_color_names VALUES (264,'56555E','スレートグレイ');
INSERT INTO jis_customary_color_names VALUES (265,'4E4854','チャコールグレイ');
INSERT INTO jis_customary_color_names VALUES (266,'1C1C1C','ランプブラック');
INSERT INTO jis_customary_color_names VALUES (267,'1C1C1C','ブラック');
