-- Windows環境で文字化け表示のために必要
SET CHARACTER SET utf8mb4;

-- お問合せテーブル
create table contacts (
    contact_id int auto_increment primary key,
    name varchar(255) not null,
    email varchar(255) not null,
    content varchar(255) not null,
    posted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
