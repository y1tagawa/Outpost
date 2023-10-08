
-- 一意の名前

CREATE TABLE names (
    name TEXT PRIMARY KEY NOT NULL,
    name_hira TEXT NOT NULL,
    name_en TEXT NOT NULL
);

-- 都道府県

CREATE TABLE prefectures
(
    name TEXT PRIMARY KEY
);

CREATE TRIGGER prefectures_before_insert
BEFORE INSERT ON prefectures
WHEN NOT(SELECT NEW.name IN (SELECT name FROM names))
BEGIN
  SELECT RAISE(FAIL, '未登録の都道府県名');
END;

INSERT INTO names VALUES ('全国','ぜんこく','All prefectures');
INSERT INTO names VALUES ('東北地方','とうほく ちほう','Tohoku region');
INSERT INTO names VALUES ('関東地方','かんとう ちほう','Kanto region');
INSERT INTO names VALUES ('北陸地方','ほくりく ちほう','Hokuriku region');
INSERT INTO names VALUES ('甲信地方','こうしん ちほう','Koshin region');
INSERT INTO names VALUES ('東海地方','とうかい ちほう','Tokai region');
INSERT INTO names VALUES ('近畿地方','きんき ちほう','Kinki region');
INSERT INTO names VALUES ('中国地方','ちゅうごく ちほう','Chugoku region');
INSERT INTO names VALUES ('四国地方','しこく ちほう','Shikoku region');
INSERT INTO names VALUES ('九州地方','きゅうしゅう ちほう','Kyushu region');
INSERT INTO names VALUES ('伊豆・小笠原諸島','いず・おがさわら しょとう','Izu Islands');

INSERT INTO names VALUES ('北海道','ほっかいどう','Hokkaido');
INSERT INTO names VALUES ('青森県','あおもり けん','Aomori Prefecture');
INSERT INTO names VALUES ('岩手県','いわて けん','Iwate Prefecture');
INSERT INTO names VALUES ('宮城県','みやぎ けん','Miyagi Prefecture');
INSERT INTO names VALUES ('秋田県','あきた けん','Akita Prefecture');
INSERT INTO names VALUES ('山形県','やまがた けん','Yamagata Prefecture');
INSERT INTO names VALUES ('福島県','ふくしま けん','Fukushima Prefecture');
INSERT INTO names VALUES ('茨城県','いばらき けん','Ibaraki Prefecture');
INSERT INTO names VALUES ('栃木県','とちぎ けん','Tochigi Prefecture');
INSERT INTO names VALUES ('群馬県','ぐんま けん','Gunma Prefecture');
INSERT INTO names VALUES ('埼玉県','さいたま けん','Saitama Prefecture');
INSERT INTO names VALUES ('千葉県','ちば けん','Chiba Prefecture');
INSERT INTO names VALUES ('東京都','とうきょう と','Tokyo');
INSERT INTO names VALUES ('神奈川県','かながわ けん','Kanagawa Prefecture');
INSERT INTO names VALUES ('新潟県','にいがた けん','Niigata Prefecture');
INSERT INTO names VALUES ('富山県','とやま けん','Toyama Prefecture');
INSERT INTO names VALUES ('石川県','いしかわ けん','Ishikawa Prefecture');
INSERT INTO names VALUES ('福井県','ふくい けん','Fukui Prefecture');
INSERT INTO names VALUES ('山梨県','やまなし けん','Yamanashi Prefecture');
INSERT INTO names VALUES ('長野県','ながの けん','Nagano Prefecture');
INSERT INTO names VALUES ('岐阜県','ぎふ けん','Gifu Prefecture');
INSERT INTO names VALUES ('静岡県','しずおか けん','Shizuoka Prefecture');
INSERT INTO names VALUES ('愛知県','あいち けん','Aichi Prefecture');
INSERT INTO names VALUES ('三重県','みえ けん','Mie Prefecture');
INSERT INTO names VALUES ('滋賀県','しが けん','Shiga Prefecture');
INSERT INTO names VALUES ('京都府','きょうと ふ','Kyoto Prefecture');
INSERT INTO names VALUES ('大阪府','おおさか ふ','Osaka Prefecture');
INSERT INTO names VALUES ('兵庫県','ひょうご けん','Hyogo Prefecture');
INSERT INTO names VALUES ('奈良県','なら けん','Nara Prefecture');
INSERT INTO names VALUES ('和歌山県','わかやま けん','Wakayama Prefecture');
INSERT INTO names VALUES ('鳥取県','とっとり けん','Tottori Prefecture');
INSERT INTO names VALUES ('島根県','しまね けん','Shimane Prefecture');
INSERT INTO names VALUES ('岡山県','おかやま けん','Okayama Prefecture');
INSERT INTO names VALUES ('広島県','ひろしま けん','Hiroshima Prefecture');
INSERT INTO names VALUES ('山口県','やまぐち けん','Yamaguchi Prefecture');
INSERT INTO names VALUES ('徳島県','とくしま けん','Tokushima Prefecture');
INSERT INTO names VALUES ('香川県','かがわ けん','Kagawa Prefecture');
INSERT INTO names VALUES ('愛媛県','えひめ けん','Ehime Prefecture');
INSERT INTO names VALUES ('高知県','こうち けん','Kochi Prefecture');
INSERT INTO names VALUES ('福岡県','ふくおか けん','Fukuoka Prefecture');
INSERT INTO names VALUES ('佐賀県','さが けん','Saga Prefecture');
INSERT INTO names VALUES ('長崎県','ながさき けん','Nagasaki Prefecture');
INSERT INTO names VALUES ('熊本県','くまもと けん','Kumamoto Prefecture');
INSERT INTO names VALUES ('大分県','おおいた けん','Oita Prefecture');
INSERT INTO names VALUES ('宮崎県','みやざき けん','Miyazaki Prefecture');
INSERT INTO names VALUES ('鹿児島県','かごしま けん','Kagoshima Prefecture');
INSERT INTO names VALUES ('沖縄県','おきなわ けん','Okinawa Prefecture');

INSERT INTO prefectures VALUES ('北海道');
INSERT INTO prefectures VALUES ('青森県');
INSERT INTO prefectures VALUES ('岩手県');
INSERT INTO prefectures VALUES ('宮城県');
INSERT INTO prefectures VALUES ('秋田県');
INSERT INTO prefectures VALUES ('山形県');
INSERT INTO prefectures VALUES ('福島県');
INSERT INTO prefectures VALUES ('茨城県');
INSERT INTO prefectures VALUES ('栃木県');
INSERT INTO prefectures VALUES ('群馬県');
INSERT INTO prefectures VALUES ('埼玉県');
INSERT INTO prefectures VALUES ('千葉県');
INSERT INTO prefectures VALUES ('東京都');
INSERT INTO prefectures VALUES ('伊豆・小笠原諸島');
INSERT INTO prefectures VALUES ('神奈川県');
INSERT INTO prefectures VALUES ('新潟県');
INSERT INTO prefectures VALUES ('富山県');
INSERT INTO prefectures VALUES ('石川県');
INSERT INTO prefectures VALUES ('福井県');
INSERT INTO prefectures VALUES ('山梨県');
INSERT INTO prefectures VALUES ('長野県');
INSERT INTO prefectures VALUES ('岐阜県');
INSERT INTO prefectures VALUES ('静岡県');
INSERT INTO prefectures VALUES ('愛知県');
INSERT INTO prefectures VALUES ('三重県');
INSERT INTO prefectures VALUES ('滋賀県');
INSERT INTO prefectures VALUES ('京都府');
INSERT INTO prefectures VALUES ('大阪府');
INSERT INTO prefectures VALUES ('兵庫県');
INSERT INTO prefectures VALUES ('奈良県');
INSERT INTO prefectures VALUES ('和歌山県');
INSERT INTO prefectures VALUES ('鳥取県');
INSERT INTO prefectures VALUES ('島根県');
INSERT INTO prefectures VALUES ('岡山県');
INSERT INTO prefectures VALUES ('広島県');
INSERT INTO prefectures VALUES ('山口県');
INSERT INTO prefectures VALUES ('徳島県');
INSERT INTO prefectures VALUES ('香川県');
INSERT INTO prefectures VALUES ('愛媛県');
INSERT INTO prefectures VALUES ('高知県');
INSERT INTO prefectures VALUES ('福岡県');
INSERT INTO prefectures VALUES ('佐賀県');
INSERT INTO prefectures VALUES ('長崎県');
INSERT INTO prefectures VALUES ('熊本県');
INSERT INTO prefectures VALUES ('大分県');
INSERT INTO prefectures VALUES ('宮崎県');
INSERT INTO prefectures VALUES ('鹿児島県');
INSERT INTO prefectures VALUES ('沖縄県');


-- 鉄道

CREATE TABLE rails (
    name TEXT PRIMARY KEY
);

CREATE TRIGGER rails_before_insert
BEFORE INSERT ON rails
WHEN NOT(SELECT NEW.name IN (SELECT name FROM names))
BEGIN
  SELECT RAISE(FAIL, '未登録の路線名');
END;

INSERT INTO names VALUES ('山手線','やまのて せん','Yamanote Line');
INSERT INTO names VALUES ('北陸新幹線','ほくりく しんかんせん','Hokuriku Shinkansen');
INSERT INTO names VALUES ('長野電鉄','ながの でんてつ','Nagano Electric Railway');

INSERT INTO rails VALUES ('山手線');
INSERT INTO rails VALUES ('北陸新幹線');
INSERT INTO rails VALUES ('長野電鉄');


-- 駅

CREATE TABLE stations (
    name TEXT NOT NULL,
    rail TEXT NOT NULL,
    number TEXT NOT NULL
);

CREATE TRIGGER stations_before_insert1
BEFORE INSERT ON stations
WHEN NOT(SELECT NEW.name IN (SELECT name FROM names))
BEGIN
  SELECT RAISE(FAIL, '未登録の駅名');
END;

CREATE TRIGGER stations_before_insert2
BEFORE INSERT ON stations
WHEN NOT(SELECT NEW.rail IN (SELECT name FROM rails))
BEGIN
  SELECT RAISE(FAIL, "未登録の路線名");
END;

INSERT INTO names VALUES ('東京駅','とうきょう えき','Tokyo Station');
INSERT INTO names VALUES ('長野駅','ながの えき','Nagano Station');

INSERT INTO stations VALUES ('東京駅', '山手線', 'JY01');
INSERT INTO stations VALUES ('東京駅', '北陸新幹線', 'TYO');

INSERT INTO stations VALUES ('長野駅', '北陸新幹線', '');
INSERT INTO stations VALUES ('長野駅', '長野電鉄', 'N1');

-- 空港

CREATE TABLE airports (
    name TEXT PRIMARY KEY,
    icao_id TEXT UNIQUE NOT NULL,
    iata_id TEXT NOT NULL
);

CREATE TRIGGER airports_before_insert
BEFORE INSERT ON airports
WHEN NOT(SELECT NEW.name IN (SELECT name FROM names))
BEGIN
  SELECT RAISE(FAIL, '未登録の空港名');
END;

INSERT INTO names VALUES ('成田国際空港','なりた こくさい くうこう','Narita International Airport');
INSERT INTO names VALUES ('松本空港','まつもと くうこう','Matsumoto Airport');
INSERT INTO names VALUES ('百里飛行場','ひゃくり ひこうじょう','Ibaraki Airport');
INSERT INTO names VALUES ('南鳥島航空基地','みなみ とりしま こうくう きち','Minami Torishima Airport');
INSERT INTO names VALUES ('硫黄島航空基地','いおうとう こうくう きち','Iwo Jima Air Base');
INSERT INTO names VALUES ('関西国際空港','かんさい こくさい くうこう','Kansai International Airport');
INSERT INTO names VALUES ('南紀白浜空港','なんき しらはま くうこう','Nanki-Shirahama Airport');
INSERT INTO names VALUES ('神戸空港','こうべ くうこう','Kobe Airport');
INSERT INTO names VALUES ('広島西飛行場','ひろしまにし ひこうじょう','Hiroshima-Nishi Airport');
INSERT INTO names VALUES ('但馬空港','たじま くうこう','Tajima Airport');
INSERT INTO names VALUES ('帯広空港','おびひろ くうこう','Tokachi-Obihiro Airport');
INSERT INTO names VALUES ('新千歳空港','しんちとせ くうこう','New Chitose Airport');
INSERT INTO names VALUES ('函館空港','はこだて くうこう','Hakodate Airport');
INSERT INTO names VALUES ('釧路空港','くしろ くうこう','Kushiro Airport');
INSERT INTO names VALUES ('女満別空港','めまんべつ くうこう','Memanbetsu Airport');
INSERT INTO names VALUES ('中標津空港','なかしべつ くうこう','Nakashibetsu Airport');
INSERT INTO names VALUES ('札幌飛行場','さっぽろ ひこうじょう','Okadama Airport');
INSERT INTO names VALUES ('礼文空港','れぶん くうこう','Rebun Airport');
INSERT INTO names VALUES ('稚内空港','わっかない くうこう','Wakkanai Airport');
INSERT INTO names VALUES ('天草飛行場','あまくさ ひこうじょう','Amakusa Airfield');
INSERT INTO names VALUES ('壱岐空港','いき くうこう','Iki Airport');
INSERT INTO names VALUES ('山口宇部空港','やまぐち うべ くうこう','Yamaguchi Ube Airport');
INSERT INTO names VALUES ('対馬空港','つしま くうこう','Tsushima Airport');
INSERT INTO names VALUES ('大村航空基地','おおむら こうくう きち','Omura Air Base');
INSERT INTO names VALUES ('紋別空港','もんべつ くうこう','Monbetsu Airport');
INSERT INTO names VALUES ('旭川空港','あさひかわ くうこう','Asahikawa Airport');
INSERT INTO names VALUES ('奥尻空港','おくしり くうこう','Okushiri Airport');
INSERT INTO names VALUES ('利尻空港','りしり くうこう','Rishiri Airport');
INSERT INTO names VALUES ('屋久島空港','やくしま くうこう','Yakushima Airport');
INSERT INTO names VALUES ('福江空港','ふくえ くうこう','Fukue Airport');
INSERT INTO names VALUES ('福岡空港','ふくおか くうこう','Fukuoka Airport');
INSERT INTO names VALUES ('種子島空港','たねがしま くうこう','New Tanegashima Airport');
INSERT INTO names VALUES ('鹿児島空港','かごしま くうこう','Kagoshima Airport');
INSERT INTO names VALUES ('宮崎空港','みやざき くうこう','Miyazaki Airport');
INSERT INTO names VALUES ('大分空港','おおいた くうこう','Oita Airport');
INSERT INTO names VALUES ('北九州空港','きたきゅうしゅう くうこう','Kitakyūshū Airport');
INSERT INTO names VALUES ('佐賀空港','さが くうこう','Saga Airport');
INSERT INTO names VALUES ('熊本空港','くまもと くうこう','Kumamoto Airport');
INSERT INTO names VALUES ('長崎空港','ながさき くうこう','Nagasaki Airport');
INSERT INTO names VALUES ('中部国際空港','ちゅうぶ こくさい くうこう','Chūbu Centrair International Airport');
INSERT INTO names VALUES ('奄美空港','あまみ くうこう','Amami Airport');
INSERT INTO names VALUES ('沖永良部空港','おきのえらぶ くうこう','Okinoerabu Airport');
INSERT INTO names VALUES ('喜界空港','きかい くうこう','Kikai Airport');
INSERT INTO names VALUES ('徳之島空港','とくのしま くうこう','Tokunoshima Airport');
INSERT INTO names VALUES ('名古屋飛行場','なごや ひこうじょう','Nagoya Airfield/Komaki Air Base');
INSERT INTO names VALUES ('福井空港','ふくい くうこう','Fukui Airport');
INSERT INTO names VALUES ('小松飛行場','こまつ ひこうじょう','Komatsu Airport');
INSERT INTO names VALUES ('隠岐空港','おき くうこう','Oki Airport');
INSERT INTO names VALUES ('静岡空港','しずおか くうこう','Shizuoka Airport');
INSERT INTO names VALUES ('富山空港','とやま くうこう','Toyama Airport');
INSERT INTO names VALUES ('能登空港','のと くうこう','Noto Airport');
INSERT INTO names VALUES ('広島空港','ひろしま くうこう','Hiroshima Airport');
INSERT INTO names VALUES ('岡山空港','おかやま くうこう','Okayama Airport');
INSERT INTO names VALUES ('出雲空港','いずも くうこう','Izumo Airport');
INSERT INTO names VALUES ('美保飛行場','みほ ひこうじょう','Miho-Yonago Airport');
INSERT INTO names VALUES ('岩国飛行場','いわくに ひこうじょう','MCAS Iwakuni');
INSERT INTO names VALUES ('高知空港','こうち くうこう','Kōchi Airport');
INSERT INTO names VALUES ('松山空港','まつやま くうこう','Matsuyama Airport');
INSERT INTO names VALUES ('大阪国際空港','おおさか こくさい くうこう','Osaka International Airport');
INSERT INTO names VALUES ('鳥取空港','とっとり くうこう','Tottori Airport');
INSERT INTO names VALUES ('徳島飛行場','とくしま ひこうじょう','Tokushima Airport');
INSERT INTO names VALUES ('高松空港','たかまつ くうこう','Takamatsu Airport');
INSERT INTO names VALUES ('石見空港','いわみ くうこう','Iwami Airport');
INSERT INTO names VALUES ('青森空港','あおもり くうこう','Aomori Airport');
INSERT INTO names VALUES ('山形空港','やまがた くうこう','Yamagata Airport');
INSERT INTO names VALUES ('佐渡空港','さど くうこう','Sado Airport');
INSERT INTO names VALUES ('福島空港','ふくしま くうこう','Fukushima Airport');
INSERT INTO names VALUES ('花巻空港','はなまき くうこう','Hanamaki Airport');
INSERT INTO names VALUES ('秋田空港','あきた くうこう','Akita Airport');
INSERT INTO names VALUES ('三沢飛行場','みさわ ひこうじょう','Misawa Airport/Misawa Air Base');
INSERT INTO names VALUES ('新潟空港','にいがた くうこう','Niigata Airport');
INSERT INTO names VALUES ('大館能代空港','おおだてのしろ くうこう','Odate-Noshiro Airport');
INSERT INTO names VALUES ('仙台空港','せんだい くうこう','Sendai Airport');
INSERT INTO names VALUES ('庄内空港','しょうない くうこう','Shonai Airport');
INSERT INTO names VALUES ('厚木海軍飛行場','あつぎかいぐん ひこうじょう','NAF Atsugi');
INSERT INTO names VALUES ('八丈島空港','はちじょうじま くうこう','Hachijojima Airport');
INSERT INTO names VALUES ('大島空港','おおしま くうこう','Oshima Airport');
INSERT INTO names VALUES ('三宅島空港','みやけじま くうこう','Miyakejima Airport');
INSERT INTO names VALUES ('東京国際空港','とうきょうこくさいくうこう','Tokyo International Airport');
INSERT INTO names VALUES ('北宇都宮駐屯地','きたうつのみや ちゅうとんち','Yokota Air Base');
INSERT INTO names VALUES ('横田飛行場','よこた ひこうじょう','Yokota Air Base');
INSERT INTO names VALUES ('那覇空港','なは くうこう','Naha Airport/Naha Air Base');
INSERT INTO names VALUES ('嘉手納飛行場','かでな ひこうじょう','Kadena Air Base');
INSERT INTO names VALUES ('新石垣空港','しんいしがきくうこう','New Ishigaki Airport');
INSERT INTO names VALUES ('久米島空港','くめじま くうこう','Kumejima Airport');
INSERT INTO names VALUES ('慶良間空港','けらま くうこう','Kerama Airport');
INSERT INTO names VALUES ('南大東空港','みなみだいとう くうこう','Minami-Daito Airport');
INSERT INTO names VALUES ('宮古空港','みやこ くうこう','Miyako Airport');
INSERT INTO names VALUES ('粟国空港','あぐに くうこう','Aguni Airport');
INSERT INTO names VALUES ('伊江島空港','いえじま くうこう','Iejima Airport');
INSERT INTO names VALUES ('波照間空港','はてるま くうこう','Hateruma Airport');
INSERT INTO names VALUES ('北大東空港','きただいとう くうこう','Kitadaito Airport');
INSERT INTO names VALUES ('下地島空港','しもじじま くうこう','Shimojishima Airport');
INSERT INTO names VALUES ('多良間空港','たらま くうこう','Tarama Airport');
INSERT INTO names VALUES ('与論空港','よろん くうこう','Yoron Airport');
INSERT INTO names VALUES ('与那国空港','よなぐに くうこう','Yonaguni Airport');

INSERT INTO airports VALUES ('成田国際空港','RJAA','NRT');
INSERT INTO airports VALUES ('松本空港','RJAF','MMJ');
INSERT INTO airports VALUES ('百里飛行場','RJAH','IBR');
INSERT INTO airports VALUES ('南鳥島航空基地','RJAM','MUS');
INSERT INTO airports VALUES ('硫黄島航空基地','RJAW','IWO');
INSERT INTO airports VALUES ('関西国際空港','RJBB','KIX');
INSERT INTO airports VALUES ('南紀白浜空港','RJBD','SHM');
INSERT INTO airports VALUES ('神戸空港','RJBE','UKB');
INSERT INTO airports VALUES ('広島西飛行場','RJBH','HIW');
INSERT INTO airports VALUES ('但馬空港','RJBT','TJH');
INSERT INTO airports VALUES ('帯広空港','RJCB','OBO');
INSERT INTO airports VALUES ('新千歳空港','RJCC','CTS');
INSERT INTO airports VALUES ('函館空港','RJCH','HKD');
INSERT INTO airports VALUES ('釧路空港','RJCK','KUH');
INSERT INTO airports VALUES ('女満別空港','RJCM','MMB');
INSERT INTO airports VALUES ('中標津空港','RJCN','SHB');
INSERT INTO airports VALUES ('札幌飛行場','RJCO','OKD');
INSERT INTO airports VALUES ('礼文空港','RJCR','RBJ');
INSERT INTO airports VALUES ('稚内空港','RJCW','WKJ');
INSERT INTO airports VALUES ('天草飛行場','RJDA','AXJ');
INSERT INTO airports VALUES ('壱岐空港','RJDB','IKI');
INSERT INTO airports VALUES ('山口宇部空港','RJDC','UBJ');
INSERT INTO airports VALUES ('対馬空港','RJDT','TSJ');
INSERT INTO airports VALUES ('大村航空基地','RJDU','OMJ');
INSERT INTO airports VALUES ('紋別空港','RJEB','MBE');
INSERT INTO airports VALUES ('旭川空港','RJEC','AKJ');
INSERT INTO airports VALUES ('奥尻空港','RJEO','OIR');
INSERT INTO airports VALUES ('利尻空港','RJER','RIS');
INSERT INTO airports VALUES ('屋久島空港','RJFC','KUM');
INSERT INTO airports VALUES ('福江空港','RJFE','FUJ');
INSERT INTO airports VALUES ('福岡空港','RJFF','FUK');
INSERT INTO airports VALUES ('種子島空港','RJFG','TNE');
INSERT INTO airports VALUES ('鹿児島空港','RJFK','KOJ');
INSERT INTO airports VALUES ('宮崎空港','RJFM','KMI');
INSERT INTO airports VALUES ('大分空港','RJFO','OIT');
INSERT INTO airports VALUES ('北九州空港','RJFR','KKJ');
INSERT INTO airports VALUES ('佐賀空港','RJFS','HSG');
INSERT INTO airports VALUES ('熊本空港','RJFT','KMJ');
INSERT INTO airports VALUES ('長崎空港','RJFU','NGS');
INSERT INTO airports VALUES ('中部国際空港','RJGG','NGO');
INSERT INTO airports VALUES ('奄美空港','RJKA','ASJ');
INSERT INTO airports VALUES ('沖永良部空港','RJKB','OKE');
INSERT INTO airports VALUES ('喜界空港','RJKI','KKX');
INSERT INTO airports VALUES ('徳之島空港','RJKN','TKN');
INSERT INTO airports VALUES ('名古屋飛行場','RJNA','NKM');
INSERT INTO airports VALUES ('福井空港','RJNF','FKJ');
INSERT INTO airports VALUES ('小松飛行場','RJNK','KMQ');
INSERT INTO airports VALUES ('隠岐空港','RJNO','OKI');
INSERT INTO airports VALUES ('静岡空港','RJNS','FSZ');
INSERT INTO airports VALUES ('富山空港','RJNT','TOY');
INSERT INTO airports VALUES ('能登空港','RJNW','NTQ');
INSERT INTO airports VALUES ('広島空港','RJOA','HIJ');
INSERT INTO airports VALUES ('岡山空港','RJOB','OKJ');
INSERT INTO airports VALUES ('出雲空港','RJOC','IZO');
INSERT INTO airports VALUES ('美保飛行場','RJOH','YGJ');
INSERT INTO airports VALUES ('岩国飛行場','RJOI','IWK');
INSERT INTO airports VALUES ('高知空港','RJOK','KCZ');
INSERT INTO airports VALUES ('松山空港','RJOM','MYJ');
INSERT INTO airports VALUES ('大阪国際空港','RJOO','ITM');
INSERT INTO airports VALUES ('鳥取空港','RJOR','TTJ');
INSERT INTO airports VALUES ('徳島飛行場','RJOS','TKS');
INSERT INTO airports VALUES ('高松空港','RJOT','TAK');
INSERT INTO airports VALUES ('石見空港','RJOW','IWJ');
INSERT INTO airports VALUES ('青森空港','RJSA','AOJ');
INSERT INTO airports VALUES ('山形空港','RJSC','GAJ');
INSERT INTO airports VALUES ('佐渡空港','RJSD','SDS');
INSERT INTO airports VALUES ('福島空港','RJSF','FKS');
INSERT INTO airports VALUES ('花巻空港','RJSI','HNA');
INSERT INTO airports VALUES ('秋田空港','RJSK','AXT');
INSERT INTO airports VALUES ('三沢飛行場','RJSM','MSJ');
INSERT INTO airports VALUES ('新潟空港','RJSN','KIJ');
INSERT INTO airports VALUES ('大館能代空港','RJSR','ONJ');
INSERT INTO airports VALUES ('仙台空港','RJSS','SDJ');
INSERT INTO airports VALUES ('庄内空港','RJSY','SYO');
INSERT INTO airports VALUES ('厚木海軍飛行場','RJTA','NJA');
INSERT INTO airports VALUES ('八丈島空港','RJTH','HAC');
INSERT INTO airports VALUES ('大島空港','RJTO','OIM');
INSERT INTO airports VALUES ('三宅島空港','RJTQ','MYE');
INSERT INTO airports VALUES ('東京国際空港','RJTT','HND');
INSERT INTO airports VALUES ('北宇都宮駐屯地','RJTU','QUY');
INSERT INTO airports VALUES ('横田飛行場','RJTY','OKO');
INSERT INTO airports VALUES ('那覇空港','ROAH','OKO');
INSERT INTO airports VALUES ('嘉手納飛行場','RODN','OKA');
INSERT INTO airports VALUES ('新石垣空港','ROIG','ISG');
INSERT INTO airports VALUES ('久米島空港','ROKJ','UEO');
INSERT INTO airports VALUES ('慶良間空港','ROKR','KJP');
INSERT INTO airports VALUES ('南大東空港','ROMD','MMD');
INSERT INTO airports VALUES ('宮古空港','ROMY','MMY');
INSERT INTO airports VALUES ('粟国空港','RORA','AGJ');
INSERT INTO airports VALUES ('伊江島空港','RORE','IEJ');
INSERT INTO airports VALUES ('波照間空港','RORH','HTR');
INSERT INTO airports VALUES ('北大東空港','RORK','KTD');
INSERT INTO airports VALUES ('下地島空港','RORS','SHI');
INSERT INTO airports VALUES ('多良間空港','RORT','TRA');
INSERT INTO airports VALUES ('与論空港','RORY','RNJ');
INSERT INTO airports VALUES ('与那国空港','ROYN','OGN');


-- POI

CREATE TABLE pois
(
    name TEXT PRIMARY KEY,
    latitude TEXT NOT NULL,     -- 北緯（度）
    longitude TEXT NOT NULL,    -- 東経（度）
    prefecture TEXT NOT NULL    -- 所在都道府県
);

CREATE TRIGGER pois_before_insert1
BEFORE INSERT ON pois
WHEN NOT(SELECT NEW.name IN (SELECT name FROM names))
BEGIN
  SELECT RAISE(FAIL, '未登録のPOI名');
END;

CREATE TRIGGER pois_before_insert2
BEFORE INSERT ON pois
WHEN NOT(SELECT NEW.prefecture IN (SELECT name FROM prefectures))
BEGIN
  SELECT RAISE(FAIL, '未登録の所在都道府県名');
END;

INSERT INTO pois VALUES ('東京駅','35.681111', '139.766667','東京都');
INSERT INTO pois VALUES ('長野駅','36.643083', '138.188705','長野県');

INSERT INTO pois VALUES ('成田国際空港','35.765278','140.385556','千葉県');
INSERT INTO pois VALUES ('松本空港','36.166667','137.922778','長野県');
INSERT INTO pois VALUES ('百里飛行場','36.183333','140.420556','茨城県');
INSERT INTO pois VALUES ('南鳥島航空基地','24.289722','153.979167','伊豆・小笠原諸島');
INSERT INTO pois VALUES ('硫黄島航空基地','24.786667','141.324167','伊豆・小笠原諸島');
INSERT INTO pois VALUES ('関西国際空港','34.434167','135.232778','大阪府');
INSERT INTO pois VALUES ('南紀白浜空港','33.662222','135.364444','和歌山県');
INSERT INTO pois VALUES ('神戸空港','34.632778','135.223889','兵庫県');
INSERT INTO pois VALUES ('広島西飛行場','34.371389','132.417778','広島県');
INSERT INTO pois VALUES ('但馬空港','35.512778','134.786944','兵庫県');
INSERT INTO pois VALUES ('帯広空港','42.733333','143.217222','北海道');
INSERT INTO pois VALUES ('新千歳空港','42.775000','141.692222','北海道');
INSERT INTO pois VALUES ('函館空港','41.770000','140.821944','北海道');
INSERT INTO pois VALUES ('釧路空港','43.040833','144.192778','北海道');
INSERT INTO pois VALUES ('女満別空港','43.880556','144.164167','北海道');
INSERT INTO pois VALUES ('中標津空港','43.577500','144.960000','北海道');
INSERT INTO pois VALUES ('札幌飛行場','43.117500','141.381389','北海道');
INSERT INTO pois VALUES ('礼文空港','45.455000','141.039167','北海道');
INSERT INTO pois VALUES ('稚内空港','45.404444','141.802222','北海道');
INSERT INTO pois VALUES ('天草飛行場','32.480278','130.158333','熊本県');
INSERT INTO pois VALUES ('壱岐空港','33.748889','129.785278','長崎県');
INSERT INTO pois VALUES ('山口宇部空港','33.930000','131.278611','山口県');
INSERT INTO pois VALUES ('対馬空港','34.284722','129.330278','長崎県');
INSERT INTO pois VALUES ('大村航空基地','32.929903','129.932469','長崎県');
INSERT INTO pois VALUES ('紋別空港','44.304167','143.408056','北海道');
INSERT INTO pois VALUES ('旭川空港','43.670833','142.447500','北海道');
INSERT INTO pois VALUES ('奥尻空港','42.073056','139.429167','北海道');
INSERT INTO pois VALUES ('利尻空港','45.239722','141.191389','北海道');
INSERT INTO pois VALUES ('屋久島空港','30.385556','130.659167','鹿児島県');
INSERT INTO pois VALUES ('福江空港','32.667500','128.840000','長崎県');
INSERT INTO pois VALUES ('福岡空港','33.584444','130.451667','福岡県');
INSERT INTO pois VALUES ('種子島空港','30.605000','130.991667','鹿児島県');
INSERT INTO pois VALUES ('鹿児島空港','31.800000','130.721667','鹿児島県');
INSERT INTO pois VALUES ('宮崎空港','31.877222','131.448611','宮崎県');
INSERT INTO pois VALUES ('大分空港','33.476111','131.739722','大分県');
INSERT INTO pois VALUES ('北九州空港','33.845556','131.035000','福岡県');
INSERT INTO pois VALUES ('佐賀空港','33.149722','130.302222','佐賀県');
INSERT INTO pois VALUES ('熊本空港','32.837222','130.855000','熊本県');
INSERT INTO pois VALUES ('長崎空港','32.916944','129.913611','長崎県');
INSERT INTO pois VALUES ('中部国際空港','34.858333','136.805278','愛知県');
INSERT INTO pois VALUES ('奄美空港','28.430833','129.712500','鹿児島県');
INSERT INTO pois VALUES ('沖永良部空港','27.431667','128.705556','鹿児島県');
INSERT INTO pois VALUES ('喜界空港','28.321389','129.928056','鹿児島県');
INSERT INTO pois VALUES ('徳之島空港','27.836389','128.881389','鹿児島県');
INSERT INTO pois VALUES ('名古屋飛行場','35.255000','136.924444','愛知県');
INSERT INTO pois VALUES ('福井空港','36.142778','136.223889','福井県');
INSERT INTO pois VALUES ('小松飛行場','36.393889','136.407500','石川県');
INSERT INTO pois VALUES ('隠岐空港','36.178333','133.323333','島根県');
INSERT INTO pois VALUES ('静岡空港','34.796111','138.189444','静岡県');
INSERT INTO pois VALUES ('富山空港','36.648333','137.187500','富山県');
INSERT INTO pois VALUES ('能登空港','37.293333','136.962222','石川県');
INSERT INTO pois VALUES ('広島空港','34.436111','132.919444','広島県');
INSERT INTO pois VALUES ('岡山空港','34.756944','133.855278','岡山県');
INSERT INTO pois VALUES ('出雲空港','35.414722','132.886111','島根県');
INSERT INTO pois VALUES ('美保飛行場','35.492222','133.236389','鳥取県');
INSERT INTO pois VALUES ('岩国飛行場','34.145000','132.246944','山口県');
INSERT INTO pois VALUES ('高知空港','33.546111','133.669444','高知県');
INSERT INTO pois VALUES ('松山空港','33.827222','132.699722','愛媛県');
INSERT INTO pois VALUES ('大阪国際空港','34.784444','135.439167','兵庫県');
INSERT INTO pois VALUES ('鳥取空港','35.530000','134.166389','鳥取県');
INSERT INTO pois VALUES ('徳島飛行場','34.132778','134.606389','徳島県');
INSERT INTO pois VALUES ('高松空港','34.214167','134.015556','香川県');
INSERT INTO pois VALUES ('石見空港','34.673056','131.792778','島根県');
INSERT INTO pois VALUES ('青森空港','40.733333','140.688611','青森県');
INSERT INTO pois VALUES ('山形空港','38.411667','140.371111','山形県');
INSERT INTO pois VALUES ('佐渡空港','38.060000','138.413889','新潟県');
INSERT INTO pois VALUES ('福島空港','37.227500','140.428056','福島県');
INSERT INTO pois VALUES ('花巻空港','39.428611','141.135278','岩手県');
INSERT INTO pois VALUES ('秋田空港','39.615556','140.218611','秋田県');
INSERT INTO pois VALUES ('三沢飛行場','40.705278','141.371944','青森県');
INSERT INTO pois VALUES ('新潟空港','37.955833','139.120556','新潟県');
INSERT INTO pois VALUES ('大館能代空港','40.191944','140.371667','秋田県');
INSERT INTO pois VALUES ('仙台空港','38.136944','140.922500','宮城県');
INSERT INTO pois VALUES ('庄内空港','38.812222','139.787222','山形県');
INSERT INTO pois VALUES ('厚木海軍飛行場','35.454611','139.450167','神奈川県');
INSERT INTO pois VALUES ('八丈島空港','33.115000','139.785833','伊豆・小笠原諸島');
INSERT INTO pois VALUES ('大島空港','34.781944','139.360278','伊豆・小笠原諸島');
INSERT INTO pois VALUES ('三宅島空港','34.073611','139.560278','伊豆・小笠原諸島');
INSERT INTO pois VALUES ('東京国際空港','35.553333','139.781111','東京都');
INSERT INTO pois VALUES ('北宇都宮駐屯地','36.514722','139.870556','栃木県');
INSERT INTO pois VALUES ('横田飛行場','35.748611','139.348611','東京都');
INSERT INTO pois VALUES ('那覇空港','26.193333','127.639722','沖縄県');
INSERT INTO pois VALUES ('嘉手納飛行場','26.351667','127.769444','沖縄県');
INSERT INTO pois VALUES ('新石垣空港','24.396389','124.245000','沖縄県');
INSERT INTO pois VALUES ('久米島空港','26.363611','126.713889','沖縄県');
INSERT INTO pois VALUES ('慶良間空港','26.168333','127.293333','沖縄県');
INSERT INTO pois VALUES ('南大東空港','25.846667','131.263611','沖縄県');
INSERT INTO pois VALUES ('宮古空港','24.782778','125.295000','沖縄県');
INSERT INTO pois VALUES ('粟国空港','26.592778','127.240278','沖縄県');
INSERT INTO pois VALUES ('伊江島空港','26.722500','127.786944','沖縄県');
INSERT INTO pois VALUES ('波照間空港','24.058333','123.803889','沖縄県');
INSERT INTO pois VALUES ('北大東空港','25.944722','131.326944','沖縄県');
INSERT INTO pois VALUES ('下地島空港','24.826667','125.144722','沖縄県');
INSERT INTO pois VALUES ('多良間空港','24.653889','124.675278','沖縄県');
INSERT INTO pois VALUES ('与論空港','27.043889','128.401667','鹿児島県');
INSERT INTO pois VALUES ('与那国空港','24.467500','122.979722','沖縄県');


-- リンク

CREATE TABLE links (
    name TEXT NOT NULL,
    type_ TEXT NOT NULL,
    url TEXT PRIMARY KEY
);

CREATE TRIGGER links_before_insert
BEFORE INSERT ON links
WHEN NOT(SELECT NEW.name IN (SELECT name FROM names))
BEGIN
  SELECT RAISE(FAIL, '未登録の事項名');
END;

INSERT INTO links VALUES ('東京駅','JR東日本','https://www.jreast.co.jp/estation/station/info.aspx?StationCd=1039');
INSERT INTO links VALUES ('東京駅','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E9%A7%85');

INSERT INTO links VALUES ('長野駅','JR東日本','https://www.jreast.co.jp/estation/station/info.aspx?StationCd=1105');
INSERT INTO links VALUES ('長野駅','長野電鉄','https://www.nagaden-net.co.jp/info/station/nagano.php');
INSERT INTO links VALUES ('長野駅','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%95%B7%E9%87%8E%E9%A7%85');

INSERT INTO links VALUES ('成田国際空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%88%90%E7%94%B0%E5%9B%BD%E9%9A%9B%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('松本空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%9D%BE%E6%9C%AC%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('百里飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%99%BE%E9%87%8C%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('南鳥島航空基地','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8D%97%E9%B3%A5%E5%B3%B6%E8%88%AA%E7%A9%BA%E5%9F%BA%E5%9C%B0');
INSERT INTO links VALUES ('硫黄島航空基地','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A1%AB%E9%BB%84%E5%B3%B6%E8%88%AA%E7%A9%BA%E5%9F%BA%E5%9C%B0');
INSERT INTO links VALUES ('関西国際空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%96%A2%E8%A5%BF%E5%9B%BD%E9%9A%9B%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('南紀白浜空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8D%97%E7%B4%80%E7%99%BD%E6%B5%9C%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('神戸空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A5%9E%E6%88%B8%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('広島西飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%BA%83%E5%B3%B6%E8%A5%BF%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('但馬空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%BD%86%E9%A6%AC%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('帯広空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B8%AF%E5%BA%83%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('新千歳空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%96%B0%E5%8D%83%E6%AD%B3%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('函館空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%87%BD%E9%A4%A8%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('釧路空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%87%A7%E8%B7%AF%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('女満別空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A5%B3%E6%BA%80%E5%88%A5%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('中標津空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%AD%E6%A8%99%E6%B4%A5%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('札幌飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%9C%AD%E5%B9%8C%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('礼文空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A4%BC%E6%96%87%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('稚内空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A8%9A%E5%86%85%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('天草飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%A9%E8%8D%89%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('壱岐空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A3%B1%E5%B2%90%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('山口宇部空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B1%B1%E5%8F%A3%E5%AE%87%E9%83%A8%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('対馬空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%AF%BE%E9%A6%AC%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('大村航空基地','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%A7%E6%9D%91%E8%88%AA%E7%A9%BA%E5%9F%BA%E5%9C%B0');
INSERT INTO links VALUES ('紋別空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%B4%8B%E5%88%A5%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('旭川空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%97%AD%E5%B7%9D%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('奥尻空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A5%A5%E5%B0%BB%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('利尻空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%88%A9%E5%B0%BB%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('屋久島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B1%8B%E4%B9%85%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('福江空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A6%8F%E6%B1%9F%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('福岡空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A6%8F%E5%B2%A1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('種子島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A8%AE%E5%AD%90%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('鹿児島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%B9%BF%E5%85%90%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('宮崎空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%AE%AE%E5%B4%8E%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('大分空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%A7%E5%88%86%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('北九州空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8C%97%E4%B9%9D%E5%B7%9E%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('佐賀空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%BD%90%E8%B3%80%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('熊本空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%86%8A%E6%9C%AC%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('長崎空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%95%B7%E5%B4%8E%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('中部国際空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%AD%E9%83%A8%E5%9B%BD%E9%9A%9B%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('奄美空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A5%84%E7%BE%8E%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('沖永良部空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%B2%96%E6%B0%B8%E8%89%AF%E9%83%A8%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('喜界空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%96%9C%E7%95%8C%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('徳之島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%BE%B3%E4%B9%8B%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('名古屋飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%90%8D%E5%8F%A4%E5%B1%8B%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('福井空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A6%8F%E4%BA%95%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('小松飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B0%8F%E6%9D%BE%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('隠岐空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%9A%A0%E5%B2%90%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('静岡空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%9D%99%E5%B2%A1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('富山空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%AF%8C%E5%B1%B1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('能登空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E8%83%BD%E7%99%BB%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('広島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%BA%83%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('岡山空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B2%A1%E5%B1%B1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('出雲空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%87%BA%E9%9B%B2%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('美保飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%BE%8E%E4%BF%9D%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('岩国飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B2%A9%E5%9B%BD%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('高知空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%AB%98%E7%9F%A5%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('松山空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%9D%BE%E5%B1%B1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('大阪国際空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%A7%E9%98%AA%E5%9B%BD%E9%9A%9B%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('鳥取空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%B3%A5%E5%8F%96%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('徳島飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%BE%B3%E5%B3%B6%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('高松空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%AB%98%E6%9D%BE%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('石見空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%9F%B3%E8%A6%8B%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('青森空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%9D%92%E6%A3%AE%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('山形空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%B1%B1%E5%BD%A2%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('佐渡空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%BD%90%E6%B8%A1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('福島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A6%8F%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('花巻空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E8%8A%B1%E5%B7%BB%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('秋田空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%A7%8B%E7%94%B0%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('三沢飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%89%E6%B2%A2%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('新潟空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%96%B0%E6%BD%9F%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('大館能代空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%A7%E9%A4%A8%E8%83%BD%E4%BB%A3%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('仙台空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%BB%99%E5%8F%B0%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('庄内空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%BA%84%E5%86%85%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('厚木海軍飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8E%9A%E6%9C%A8%E6%B5%B7%E8%BB%8D%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('八丈島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%85%AB%E4%B8%88%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('大島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%A7%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('三宅島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%89%E5%AE%85%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('東京国際空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E5%9B%BD%E9%9A%9B%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('北宇都宮駐屯地','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8C%97%E5%AE%87%E9%83%BD%E5%AE%AE%E9%A7%90%E5%B1%AF%E5%9C%B0');
INSERT INTO links VALUES ('横田飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%A8%AA%E7%94%B0%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('那覇空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E9%82%A3%E8%A6%87%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('嘉手納飛行場','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%98%89%E6%89%8B%E7%B4%8D%E9%A3%9B%E8%A1%8C%E5%A0%B4');
INSERT INTO links VALUES ('新石垣空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%96%B0%E7%9F%B3%E5%9E%A3%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('久米島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B9%85%E7%B1%B3%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('慶良間空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%85%B6%E8%89%AF%E9%96%93%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('南大東空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8D%97%E5%A4%A7%E6%9D%B1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('宮古空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%AE%AE%E5%8F%A4%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('粟国空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E7%B2%9F%E5%9B%BD%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('伊江島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%BC%8A%E6%B1%9F%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('波照間空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E6%B3%A2%E7%85%A7%E9%96%93%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('北大東空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%8C%97%E5%A4%A7%E6%9D%B1%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('下地島空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%8B%E5%9C%B0%E5%B3%B6%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('多良間空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E5%A4%9A%E8%89%AF%E9%96%93%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('与論空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%8E%E8%AB%96%E7%A9%BA%E6%B8%AF');
INSERT INTO links VALUES ('与那国空港','ウィキペディア','https://ja.wikipedia.org/wiki/%E4%B8%8E%E9%82%A3%E5%9B%BD%E7%A9%BA%E6%B8%AF');

----
