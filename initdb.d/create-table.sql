-- Windows環境で文字化け表示のために必要
SET CHARACTER SET utf8mb4;

-- ユーザーテーブル
create table users (
    user_id int auto_increment primary key,
    user_name varchar(32) not null unique,
    display_name varchar(255) not null,
    user_email varchar(255) not null unique,
    password varchar(255) not null,
    test_day DATE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ユーザーの初期データ追加
insert into users (user_name, display_name, user_email, password) values 
('atukinng', 'あつあつきんぐ', 'atuking@email.com', SHA2('password', 256)),
('yutosei', 'ゆうとうせい', 'yutosei@email.com', SHA2('password', 256)),
('akolingo', 'あこりんご', 'akolingo@email.com', SHA2('password', 256)),
('hironosuke', 'ひろのすけ', 'hironosuke@email.com', SHA2('password', 256)),
('kohe-penguin', 'こーへーぺんぎん', 'kohe-penguin@email.com', SHA2('password', 256)),
('test-user', 'TEST', 'test@email.com', SHA2('password', 256));

-- アクセストークンの管理テーブル
CREATE TABLE access_tokens (
    token_id INT PRIMARY KEY AUTO_INCREMENT,
    token VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    expiry_date DATETIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 問題数集計テーブル
create table answer_count (
    user_id INT NOT NULL,
    count INT NOT NULL,
    issue_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

insert into answer_count (user_id, count) values
(1, 5),
(1, 1),
(2, 3),
(2, 1),
(3, 4),
(4, 3),
(5, 1);

-- 過去問年度テーブル
create table past_questions_years (
    question_year_id int auto_increment primary key,
    created_year_jp varchar(10) not null, -- 出題年度（和暦）
    created_year int not null, -- 出題年度
    season varchar(10) default '' -- 出題時期（春:spring・秋:fall）
);

insert into past_questions_years (created_year_jp, created_year, season) values 
('令和4年', 2022, ''),
('令和3年', 2021, ''),
('令和2年', 2020, ''),
('令和元年', 2019, '秋'),
('平成31年', 2019, '春'),
('平成30年', 2018, '秋'),
('平成30年', 2018, '春');

-- 過去問テーブル
create table past_questions (
    question_id int auto_increment primary key,
    -- 問題文
    question_content varchar(255) not null,
    -- 問題のジャンル
    question_genre varchar(255) not null,
    -- 元の問題番号
    question_number int not null,
    -- 元の問題のURL
    question_url varchar(255) not null,
    -- 外部キー（過去問年度テーブル）
    question_year_id int not null,
    -- 正解選択肢
    correct_option_key varchar(10) not null,
    foreign key (question_year_id) references past_questions_years(question_year_id)
);

-- 過去問選択肢テーブル
create table question_options (
    option_id int auto_increment primary key,
    -- 選択肢内容
    option_content varchar(255) not null,
    -- 選択肢の記号
    option_key varchar(10) not null,
    -- 外部キー（過去問テーブル）
    question_id int not null,
    foreign key (question_id) references past_questions(question_id)
);

insert into past_questions 
(
    question_content,
    question_genre,
    question_number,
    question_url,
    question_year_id,
    correct_option_key
) values 
(
    -- 問題文
    '任意のオペランドに対するブール演算Aの結果とブール演算Bの結果が互いに否定の関係にあるとき，AはBの(又は，BはAの)相補演算であるという。排他的論理和の相補演算はどれか。',
    -- 問題のジャンル
    '離散数学',
    -- 元の問題番号
    1,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q1.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ア'
), 
(
    -- 問題文
    '2の補数で表された負数 10101110 の絶対値はどれか。',
    -- 問題のジャンル
    '離散数学',
    -- 元の問題番号
    2,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q2.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '5本のくじがあり，そのうち2本が当たりである。くじを同時に2本引いたとき，2本とも当たりである確率は幾らか。',
    -- 問題のジャンル
    '応用数学',
    -- 元の問題番号
    4,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q4.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'バブルソートの説明として，適切なものはどれか。',
    -- 問題のジャンル
    'アルゴリズム',
    -- 元の問題番号
    8,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q8.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'アクセス時間の最も短い記憶装置はどれか。',
    -- 問題のジャンル
    'メモリ',
    -- 元の問題番号
    13,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q13.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'イ'
),
(
    -- 問題文
    '毎分6,000回転，平均位置決め時間20ミリ秒で，1トラック当たりの記憶容量20kバイトの磁気ディスク装置がある。1ブロック4kバイトのデータを1ブロック転送するのに要する平均アクセス時間は何ミリ秒か。ここで，磁気ディスクコントローラーのオーバーヘッドは無視できるものとし，1kバイト＝1,000バイトとする。',
    -- 問題のジャンル
    '入出力装置',
    -- 元の問題番号
    14,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q14.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '3層クライアントサーバシステムの各層の役割のうち，適切なものはどれか。',
    -- 問題のジャンル
    'システムの構成',
    -- 元の問題番号
    16,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q16.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '仮想記憶管理におけるページ置換えアルゴリズムとしてLRU方式を採用する。主記憶のページ枠が，4000，5000，6000，7000番地(いずれも16進数)の4ページ分で，プログラムが参照するページ番号の順が，1→2→3→4→2→5→3→1→6→5→4のとき，最後の参照ページ4は何番地にページインされているか。ここで，最初の1→2→3→4の参照で，それぞれのページは4000，5000，6000，7000番地にページインされるものとする。',
    -- 問題のジャンル
    'オペレーティングシステム',
    -- 元の問題番号
    17,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q17.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '仮想記憶におけるページ置換えアルゴリズムの一つであるLRUを説明した記述はどれか。',
    -- 問題のジャンル
    'オペレーティングシステム',
    -- 元の問題番号
    18,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q18.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    'Hadoopの説明はどれか。',
    -- 問題のジャンル
    'ミドルウェア',
    -- 元の問題番号
    19,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/04_menjo/q19.html',
    -- 外部キー（過去問年度テーブル）
    1,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    '0以上65,536未満の整数xを，16ビットの2進数で表現して，上位8ビットと下位8ビットを入れ替える。得られたビット列を2進数とみなしたとき，その値をxを用いた式で表したものはどれか。ここで，a÷bはaをbで割った商の整数部分を，a％bはaをbで割った余りを表す。また，式の中の数値は10進法である。',
    -- 問題のジャンル
    '離散数学',
    -- 元の問題番号
    2,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q2.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'イ'
),
(
    -- 問題文
    '多数のクライアントが，LANに接続された1台のプリンターを共同利用するときの印刷要求から印刷完了までの所要時間を，待ち行列理論を適用して見積もる場合について考える。プリンターの運用方法や利用状況に関する記述のうち，M/M/1の待ち行列モデルの条件に',
    -- 問題のジャンル
    '応用数学',
    -- 元の問題番号
    5,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q5.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'イ'
),
(
    -- 問題文
    'オブジェクト指向のプログラム言語であり，クラスや関数，条件文などのコードブロックの範囲はインデントの深さによって指定する仕様であるものはどれか。',
    -- 問題のジャンル
    'プログラミング言語',
    -- 元の問題番号
    10,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q10.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'CPUのプログラムレジスタ(プログラムカウンター)の役割はどれか。',
    -- 問題のジャンル
    'プロセッサ',
    -- 元の問題番号
    11,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q11.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    'フェールセーフの考え方として，適切なものはどれか。',
    -- 問題のジャンル
    'システムの構成',
    -- 元の問題番号
    15,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q15.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ア'
),
(
    -- 問題文
    '一定の時間内にシステムによって処理される仕事量を表す用語はどれか。',
    -- 問題のジャンル
    'システムの評価指導',
    -- 元の問題番号
    16,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q16.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'ページング方式の仮想記憶において，主記憶に存在しないページをアクセスした場合の処理や状態の順番として，適切なものはどれか。ここで，主記憶には現在，空きのページ枠はないものとする。',
    -- 問題のジャンル
    'オペレーティングシステム',
    -- 元の問題番号
    19,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q19.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '8ビットD/A変換器を使って，負でない電圧を発生させる。使用するD/A変換器は，最下位の1ビットの変化で出力が10ミリV変化する。データに0を与えたときの出力は0ミリVである。データに16進数で82を与えたときの出力は何ミリVか。',
    -- 問題のジャンル
    'ハードウェア',
    -- 元の問題番号
    21,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q21.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'コードの値からデータの対象物が連想できるものはどれか。',
    -- 問題のジャンル
    'UX/UIデザイン',
    -- 元の問題番号
    23,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q23.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'コンピュータアニメーション技法のうち，モーフィングの説明はどれか。',
    -- 問題のジャンル
    'マルチメディア応用',
    -- 元の問題番号
    24,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/03_menjo/q24.html',
    -- 外部キー（過去問年度テーブル）
    2,
    -- 正解選択肢
    'ア'
),
(
    -- 問題文
    'AIにおけるディープラーニングに関する記述として，最も適切なものはどれか。',
    -- 問題のジャンル
    '情報に関する理論',
    -- 元の問題番号
    5,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q5.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'ア'
),
(
    -- 問題文
    '通信回線の伝送誤りに対処するパリティチェック方式(垂直パリティ)の記述として，適切なものはどれか。',
    -- 問題のジャンル
    '通信に関する理論',
    -- 元の問題番号
    6,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q6.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'ア'
),
(
    -- 問題文
    'キューに関する記述として，最も適切なものはどれか。',
    -- 問題のジャンル
    'データ構造',
    -- 元の問題番号
    7,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q7.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'イ'
),
(
    -- 問題文
    '加減乗除を組み合わせた計算式の処理において，スタックを利用するのが適している処理はどれか。',
    -- 問題のジャンル
    'データ構造',
    -- 元の問題番号
    8,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q8.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'イ'
),
(
    -- 問題文
    '顧客番号をキーとして顧客データを検索する場合，2分探索を使用するのが適しているものはどれか。',
    -- 問題のジャンル
    'アルゴリズム',
    -- 元の問題番号
    10,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q10.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '全ての命令が5ステージで完了するように設計された，パイプライン制御のコンピュータがある。20命令を実行するのには何サイクル必要となるか。ここで，全ての命令は途中で停止することなく実行でき，パイプラインの各ステージは1サイクルで動作を完了するものとする。',
    -- 問題のジャンル
    'プロセッサ',
    -- 元の問題番号
    11,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q11.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '外部割込みが発生するものはどれか。',
    -- 問題のジャンル
    'プロセッサ',
    -- 元の問題番号
    12,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q12.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    '4Tバイトのデータを格納できるようにRAID1の外部記憶装置を構成するとき，フォーマット後の記憶容量が1Tバイトの磁気記憶装置は少なくとも何台必要か。',
    -- 問題のジャンル
    'システムの構造',
    -- 元の問題番号
    13,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q13.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    '仮想サーバの運用サービスで使用するライブマイグレーションの概念を説明したものはどれか。',
    -- 問題のジャンル
    'システムの構造',
    -- 元の問題番号
    14,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q14.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'ア'
),
(
    -- 問題文
    'キャッシュサーバを利用した検索処理の平均応答時間は，キャッシュサーバでヒットした場合には0.2秒，ヒットしない場合には2.2秒である。現在の平均検索応答時間は，1.0秒である。3年後のキャッシュサーバのヒット率は，検索量の増加によって現状の半分になると予測されている。3年後の平均検索応答時間は何秒か。ここで，その他のオーバーヘッドは考慮しない。',
    -- 問題のジャンル
    'システムの評価指標',
    -- 元の問題番号
    15,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/02_menjo/q15.html',
    -- 外部キー（過去問年度テーブル）
    3,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '8ビットの値の全ビットを反転する操作はどれか。',
    -- 問題のジャンル
    '離散数学',
    -- 元の問題番号
    2,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q2.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'A，C，K，S，Tの順に文字が入力される。スタックを利用して，S，T，A，C，Kという順に文字を出力するために，最小限必要となるスタックは何個か。ここで，どのスタックにおいてもポップ操作が実行されたときには必ず文字を出力する。また，スタック間の文字の移動は行わない。',
    -- 問題のジャンル
    'データ構造',
    -- 元の問題番号
    8,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q8.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '1GHzのクロックで動作するCPUがある。このCPUは，機械語の1命令を平均0.8クロックで実行できることが分かっている。このCPUは1秒間に平均何万命令を実行できるか。',
    -- 問題のジャンル
    'プロセッサ',
    -- 元の問題番号
    12,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q12.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    '次に示す接続のうち，デイジーチェーン接続と呼ばれる接続方法はどれか。',
    -- 問題のジャンル
    '入出力デバイス',
    -- 元の問題番号
    14,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q14.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'イ'
),
(
    -- 問題文
    'RAIDの分類において，ミラーリングを用いることで信頼性を高め，障害発生時には冗長ディスクを用いてデータ復元を行う方式はどれか。',
    -- 問題のジャンル
    'システムの構造',
    -- 元の問題番号
    15,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q15.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ア'
),
(
    -- 問題文
    '2台の処理装置から成るシステムがある。少なくともいずれか一方が正常に動作すればよいときの稼働率と，2台とも正常に動作しなければならないときの稼働率の差は幾らか。ここで，処理装置の稼働率はいずれも0.9とし，処理装置以外の要因は考慮しないものとする。',
    -- 問題のジャンル
    'システムの評価指標',
    -- 元の問題番号
    16,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q16.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '優先度に基づくプリエンプティブなスケジューリングを行うリアルタイムOSで，二つのタスクA，Bをスケジューリングする。Aの方がBより優先度が高い場合にリアルタイムOSが行う動作のうち，適切なものはどれか。',
    -- 問題のジャンル
    'オペレーティングシステム',
    -- 元の問題番号
    18,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q18.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'バックアップ方式の説明のうち，増分バックアップはどれか。ここで，最初のバックアップでは，全てのファイルのバックアップを取得し，OSが管理しているファイル更新を示す情報はリセットされるものとする。',
    -- 問題のジャンル
    'ファイルシステム',
    -- 元の問題番号
    19,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q19.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    'DRAMの特徴はどれか。',
    -- 問題のジャンル
    'メモリ',
    -- 元の問題番号
    20,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q20.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'エ'
),
(
    -- 問題文
    'コードから商品の内容が容易に分かるようにしたいとき，どのコード体系を選択するのが適切か。',
    -- 問題のジャンル
    'UX／UIUIデザイン',
    -- 元の問題番号
    21,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/01_menjo/q21.html',
    -- 外部キー（過去問年度テーブル）
    4,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '10進数の演算式7÷32の結果を2進数で表したものはどれか。',
    -- 問題のジャンル
    '離散数学',
    -- 元の問題番号
    1,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/31_haru/q1.html',
    -- 外部キー（過去問年度テーブル）
    5,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '最上位をパリティビットとする8ビット符号において，パリティビット以外の下位7ビットを得るためのビット演算はどれか。',
    -- 問題のジャンル
    '離散数学',
    -- 元の問題番号
    2,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/31_haru/q2.html',
    -- 外部キー（過去問年度テーブル）
    5,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '機械学習における教師あり学習の説明として，最も適切なものはどれか。',
    -- 問題のジャンル
    '情報に関する理論',
    -- 元の問題番号
    4,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/31_haru/q4.html',
    -- 外部キー（過去問年度テーブル）
    5,
    -- 正解選択肢
    'ウ'
),
(
    -- 問題文
    '複数のプロセスから同時に呼び出されたときに，互いに干渉することなく並行して動作することができるプログラムの性質を表すものはどれか。',
    -- 問題のジャンル
    'プログラミング',
    -- 元の問題番号
    8,
    -- 元の問題のURL
    'https://www.fe-siken.com/kakomon/31_haru/q8.html',
    -- 外部キー（過去問年度テーブル）
    5,
    -- 正解選択肢
    'ア'
);

insert into question_options 
(
    option_content,
    option_key,
    question_id
) values
(
    -- 選択肢内容
    '等価演算',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    1
),
(
    '否定論理和',
    'イ',
    1
),
(
    '論理積',
    'ウ',
    1
),
(
    '論理和',
    'エ',
    1
),
(
    -- 選択肢内容
    '01010000',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    2
),
(
    '01010001',
    'イ',
    2
),
(
    '01010010',
    'ウ',
    2
),
(
    '01010011',
    'エ',
    2
),
(
    -- 選択肢内容
    '1/25',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    3
),
(
    '1/20',
    'イ',
    3
),
(
    '1/10',
    'ウ',
    3
),
(
    '4/25',
    'エ',
    3
),
(
    -- 選択肢内容
    'ある間隔おきに取り出した要素から成る部分列をそれぞれ整列し，更に間隔を詰めて同様の操作を行い，間隔が1になるまでこれを繰り返す。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    4
),
(
    '中間的な基準値を決めて，それよりも大きな値を集めた区分と，小さな値を集めた区分に要素を振り分ける。次に，それぞれの区分の中で同様の操作を繰り返す。',
    'イ',
    4
),
(
    '隣り合う要素を比較して，大小の順が逆であれば，それらの要素を入れ替えるという操作を繰り返す。',
    'ウ',
    4
),
(
    '未整列の部分を順序木にし，そこから最小値を取り出して整列済の部分に移す。この操作を繰り返して，未整列の部分を縮めていく。',
    'エ',
    4
),
(
    -- 選択肢内容
    'CPUの2次キャッシュメモリ',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    5
),
(
    'CPUのレジスタ',
    'イ',
    5
),
(
    '磁気ディスク',
    'ウ',
    5
),
(
    '主記憶',
    'エ',
    5
),
(
    -- 選択肢内容
    '20',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    6
),
(
    '22',
    'イ',
    6
),
(
    '27',
    'ウ',
    6
),
(
    '32',
    'エ',
    6
),
(
    -- 選択肢内容
    'データベースアクセス層は，データを加工してプレゼンテーション層に返信する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    7
),
(
    'ファンクション層は，データベースアクセス層で組み立てられたSQL文を解釈する。',
    'イ',
    7
),
(
    'ファンクション層は，データを加工してプレゼンテーション層に返信する。',
    'ウ',
    7
),
(
    'プレゼンテーション層は，データベースアクセス層にSQL文で問い合わせる。',
    'エ',
    7
),
(
    -- 選択肢内容
    '4000',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    8
),
(
    '5000',
    'イ',
    8
),
(
    '6000',
    'ウ',
    8
),
(
    '7000',
    'エ',
    8
),
(
    -- 選択肢内容
    'あらかじめ設定されている優先度が最も低いページを追い出す。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    9
),
(
    '主記憶に存在している時間が最も長いページを追い出す。',
    'イ',
    9
),
(
    '主記憶に存在している時間が最も短いページを追い出す。',
    'ウ',
    9
),
(
    '最も長い間参照されていないページを追い出す。',
    'エ',
    9
),
(
    -- 選択肢内容
    'JavaEE仕様に準拠したアプリケーションサーバ',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    10
),
(
    'LinuxやWindowsなどの様々なプラットフォーム上で動作するWebサーバ',
    'イ',
    10
),
(
    '機能の豊富さが特徴のRDBMS',
    'ウ',
    10
),
(
    '大規模なデータセットを分散処理するためのソフトウェアライブラリ',
    'エ',
    10
),
(
    -- 選択肢内容
    '(x÷256)＋(x％256)',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    11
),
(
    '(x÷256)＋(x％256)×256',
    'イ',
    11
),
(
    '(x÷256)×256＋(x％256)',
    'ウ',
    11
),
(
    '(x÷256)×256＋(x％256)×256',
    'エ',
    11
),
(
    -- 選択肢内容
    '一部のクライアントは，プリンターの空き具合を見ながら印刷要求する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    12
),
(
    '印刷の緊急性や印刷量の多少にかかわらず，先着順に印刷する。',
    'イ',
    12
),
(
    '印刷待ちの文書データの総量がプリンターのバッファサイズを超えるときは，一時的に受付を中断する。',
    'ウ',
    12
),
(
    '一つの印刷要求から印刷完了までの所要時間は，印刷の準備に要する一定時間と，印刷量に比例する時間の合計である。',
    'エ',
    12
),
(
    -- 選択肢内容
    'JavaScript',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    13
),
(
    'Perl',
    'イ',
    13
),
(
    'Python',
    'ウ',
    13
),
(
    'Ruby',
    'エ',
    13
),
(
    -- 選択肢内容
    '演算を行うために，メモリから読み出したデータを保持する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    14
),
(
    '条件付き分岐命令を実行するために，演算結果の状態を保持する。',
    'イ',
    14
),
(
    '命令のデコードを行うために，メモリから読み出した命令を保持する。',
    'ウ',
    14
),
(
    '命令を読み出すために，次の命令が格納されたアドレスを保持する。',
    'エ',
    14
),
(
    -- 選択肢内容
    'システムに障害が発生したときでも，常に安全側にシステムを制御する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    15
),
(
    'システムの機能に異常が発生したときに，すぐにシステムを停止しないで機能を縮退させて運用を継続する。',
    'イ',
    15
),
(
    'システムを構成する要素のうち，信頼性に大きく影響するものを複数備えることによって，システムの信頼性を高める。',
    'ウ',
    15
),
(
    '不特定多数の人が操作しても，誤動作が起こりにくいように設計する。',
    'エ',
    15
),
(
    -- 選択肢内容
    'アクセスタイム',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    16
),
(
    'オーバーヘッド',
    'イ',
    16
),
(
    'スループット',
    'ウ',
    16
),
(
    'ターンアラウンドタイム',
    'エ',
    16
),
(
    -- 選択肢内容
    '置換え対象ページの決定→ページイン→ページフォールト→ページアウト',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    17
),
(
    '置換え対象ページの決定→ページフォールト→ページアウト→ページイン',
    'イ',
    17
),
(
    'ページフォールト→置換え対象ページの決定→ページアウト→ページイン',
    'ウ',
    17
),
(
    'ページフォールト→置換え対象ページの決定→ページイン→ページアウト',
    'エ',
    17
),
(
    -- 選択肢内容
    '820',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    18
),
(
    '1,024',
    'イ',
    18
),
(
    '1,300',
    'ウ',
    18
),
(
    '1,312',
    'エ',
    18
),
(
    -- 選択肢内容
    'シーケンスコード',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    19
),
(
    'デシマルコード',
    'イ',
    19
),
(
    'ニモニックコード',
    'ウ',
    19
),
(
    'ブロックコード',
    'エ',
    19
),
(
    -- 選択肢内容
    '画像A，Bを対象として，AからBへ滑らかに変化していく様子を表現するために，その中間を補うための画像を複数作成する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    20
),
(
    '実際の身体の動きをデジタルデータとして収集して，これを基にリアルな動きをもつ画像を複数作成する。',
    'イ',
    20
),
(
    '背景とは別に，動きがある部分を視点から遠い順に重ねて画像を作成することによって，奥行きが感じられる2次元アニメーションを生成する。',
    'ウ',
    20
),
(
    '人手によって描かれた線画をスキャナーで読み取り，その閉領域を同一色で彩色処理する。',
    'エ',
    20
),
(
    -- 選択肢内容
    'あるデータから結果を求める処理を，人間の脳神経回路のように多層の処理を重ねることによって，複雑な判断をできるようにする。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    21
),
(
    '大量のデータからまだ知られていない新たな規則や仮説を発見するために，想定値から大きく外れている例外事項を取り除きながら分析を繰り返す手法である。',
    'イ',
    21
),
(
    '多様なデータや大量のデータに対して，三段論法，統計的手法やパターン認識手法を組み合わせることによって，高度なデータ分析を行う手法である。',
    'ウ',
    21
),
(
    '知識がルールに従って表現されており，演繹手法を利用した推論によって有意な結論を導く手法である。',
    'エ',
    21
),
(
    -- 選択肢内容
    '1ビットの誤りを検出できる。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    22
),
(
    '1ビットの誤りを訂正でき，2ビットの誤りを検出できる。',
    'イ',
    22
),
(
    '奇数パリティならば1ビットの誤りを検出できるが，偶数パリティでは1ビットの誤りも検出できない。',
    'ウ',
    22
),
(
    '奇数パリティならば奇数個のビット誤りを，偶数パリティならば偶数個のビット誤りを検出できる。',
    'エ',
    22
),
(
    -- 選択肢内容
    '最後に格納されたデータが最初に取り出される。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    23
),
(
    '最初に格納されたデータが最初に取り出される。',
    'イ',
    23
),
(
    '添字を用いて特定のデータを参照する。',
    'ウ',
    23
),
(
    '二つ以上のポインタを用いてデータの階層関係を表現する。',
    'エ',
    23
),
(
    -- 選択肢内容
    '格納された計算の途中結果を，格納された順番に取り出す処理',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    24
),
(
    '計算の途中結果を格納し，別の計算を行った後で，その計算結果と途中結果との計算を行う処理',
    'イ',
    24
),
(
    '昇順に並べられた計算の途中結果のうち，中間にある途中結果だけ変更する処理',
    'ウ',
    24
),
(
    'リストの中間にある計算の途中結果に対して，新たな途中結果の挿入を行う処理',
    'エ',
    24
),
(
    -- 選択肢内容
    '顧客番号から求めたハッシュ値が指し示す位置に配置されているデータ構造',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    25
),
(
    '顧客番号に関係なく，ランダムに配置されているデータ構造',
    'イ',
    25
),
(
    '顧客番号の昇順に配置されているデータ構造',
    'ウ',
    25
),
(
    '顧客番号をセルに格納し，セルのアドレス順に配置されているデータ構造',
    'エ',
    25
),
(
    -- 選択肢内容
    '20',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    26
),
(
    '21',
    'イ',
    26
),
(
    '24',
    'ウ',
    26
),
(
    '25',
    'エ',
    26
),
(
    -- 選択肢内容
    '2仮想記憶管理での，主記憶に存在しないページへのアクセス',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    27
),
(
    'システムコール命令の実行',
    'イ',
    27
),
(
    'ゼロによる除算',
    'ウ',
    27
),
(
    '入出力動作の終了',
    'エ',
    27
),
(
    -- 選択肢内容
    '4',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    28
),
(
    '5',
    'イ',
    28
),
(
    '6',
    'ウ',
    28
),
(
    '8',
    'エ',
    28
),
(
    -- 選択肢内容
    '仮想サーバで稼働しているOSやソフトウェアを停止することなく，他の物理サーバへ移し替える技術である。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    29
),
(
    'データの利用目的や頻度などに応じて，データを格納するのに適したストレージヘ自動的に配置することによって，情報活用とストレージ活用を高める技術である。',
    'イ',
    29
),
(
    '複数の利用者でサーバやデータベースを共有しながら，利用者ごとにデータベースの内容を明確に分離する技術である。',
    'ウ',
    29
),
(
    '利用者の要求に応じてリソースを動的に割り当てたり，不要になったリソースを回収して別の利用者のために移し替えたりする技術である。',
    'エ',
    29
),
(
    -- 選択肢内容
    '1.1',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    30
),
(
    '1.3',
    'イ',
    30
),
(
    '1.6',
    'ウ',
    30
),
(
    '1.9',
    'エ',
    30
),
(
    -- 選択肢内容
    '16進表記 00 のビット列と排他的論理和をとる。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    31
),
(
    '16進表記 00 のビット列と論理和をとる。',
    'イ',
    31
),
(
    '16進表記 FF のビット列と排他的論理和をとる。',
    'ウ',
    31
),
(
    '16進表記 FF のビット列と論理和をとる。',
    'エ',
    31
),
(
    -- 選択肢内容
    '1',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    32
),
(
    '2',
    'イ',
    32
),
(
    '3',
    'ウ',
    32
),
(
    '4',
    'エ',
    32
),
(
    -- 選択肢内容
    '125',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    33
),
(
    '250',
    'イ',
    33
),
(
    '80,000',
    'ウ',
    33
),
(
    '125,000',
    'エ',
    33
),
(
    -- 選択肢内容
    'PCと計測機器とをRS-232Cで接続し，PCとプリンターとをUSBを用いて接続する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    34
),
(
    'Thunderbolt接続コネクタが2口ある4kディスプレイ2台を，PCのThunderbolt接続ポートから1台目のディスプレイにケーブルで接続し，さらに，1台目のディスプレイと2台目のディスプレイとの間をケーブルで接続する。',
    'イ',
    34
),
(
    'キーボード，マウス，プリンターをUSBハブにつなぎ，USBハブとPCとを接続する。',
    'ウ',
    34
),
(
    '数台のネットワークカメラ及びPCをネットワークハブに接続する。',
    'エ',
    34
),
(
    -- 選択肢内容
    'RAID1',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    35
),
(
    'RAID2',
    'イ',
    35
),
(
    'RAID3',
    'ウ',
    35
),
(
    'RAID4',
    'エ',
    35
),
(
    -- 選択肢内容
    '0.09',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    36
),
(
    '0.10',
    'イ',
    36
),
(
    '0.18',
    'ウ',
    36
),
(
    '0.19',
    'エ',
    36
),
(
    -- 選択肢内容
    'Aの実行中にBに起動がかかると，Aを実行可能状態にしてBを実行する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    37
),
(
    'Aの実行中にBに起動がかかると，Aを待ち状態にしてBを実行する。',
    'イ',
    37
),
(
    'Bの実行中にAに起動がかかると，Bを実行可能状態にしてAを実行する。',
    'ウ',
    37
),
(
    'Bの実行中にAに起動がかかると，Bを待ち状態にしてAを実行する。',
    'エ',
    37
),
(
    -- 選択肢内容
    '最初のバックアップの後，ファイル更新を示す情報があるファイルだけをバックアップし，ファイル更新を示す情報は変更しないでそのまま残しておく。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    38
),
(
    '最初のバックアップの後，ファイル更新を示す情報にかかわらず，全てのファイルをバックアップし，ファイル更新を示す情報はリセットする。',
    'イ',
    38
),
(
    '直前に行ったバックアップの後，ファイル更新を示す情報があるファイルだけをバックアップし，ファイル更新を示す情報はリセットする。',
    'ウ',
    38
),
(
    '直前に行ったバックアップの後，ファイル更新を示す情報にかかわらず，全てのファイルをバックアップし，ファイル更新を示す情報は変更しないでそのまま残しておく。',
    'エ',
    38
),
(
    -- 選択肢内容
    '書込み及び消去を一括又はブロック単位で行う。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    39
),
(
    'データを保持するためのリフレッシュ操作又はアクセス操作が不要である。',
    'イ',
    39
),
(
    '電源が遮断された状態でも，記憶した情報を保持することができる。',
    'ウ',
    39
),
(
    'メモリセル構造が単純なので高集積化することができ，ビット単価を安くできる。',
    'エ',
    39
),
(
    -- 選択肢内容
    '区分コード',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    40
),
(
    '桁別コード',
    'イ',
    40
),
(
    '表意コード',
    'ウ',
    40
),
(
    '連番コード',
    'エ',
    40
),
(
    -- 選択肢内容
    '0.001011',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    41
),
(
    '0.001101',
    'イ',
    41
),
(
    '0.00111',
    'ウ',
    41
),
(
    '0.0111',
    'エ',
    41
),
(
    -- 選択肢内容
    '16進数0FとのANDをとる。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    42
),
(
    '16進数0FとのORをとる。',
    'イ',
    42
),
(
    '16進数7FとのANDをとる。',
    'ウ',
    42
),
(
    '16進数FFとのXOR(排他的論理和)をとる。',
    'エ',
    42
),
(
    -- 選択肢内容
    '個々の行動に対しての善しあしを得点として与えることによって，得点が最も多く得られるような方策を学習する。',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    43
),
(
    'コンピュータ利用者の挙動データを蓄積し，挙動データの出現頻度に従って次の挙動を推論する。',
    'イ',
    43
),
(
    '正解のデータを提示したり，データが誤りであることを指摘したりすることによって，未知のデータに対して正誤を得ることを助ける。',
    'ウ',
    43
),
(
    '正解のデータを提示せずに，統計的性質や，ある種の条件によって入力パターンを判定したり，クラスタリングしたりする。',
    'エ',
    43
),
(
    -- 選択肢内容
    'リエントラント',
    -- 選択肢の記号
    'ア',
    -- 外部キー（過去問テーブル）
    44
),
(
    'リカーシブ',
    'イ',
    44
),
(
    'リユーザーブル',
    'ウ',
    44
),
(
    'リロケータブル',
    'エ',
    44
);