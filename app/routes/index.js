var express = require("express");
const mysql_connection = require("../lib/db");
var router = express.Router();

/* GET home page. */
router.get("/", function (req, res, next) {
  console.log(req.query);
  // 状態のパラメタ
  const { status } = req.query;
  res.render("index", { title: "お問合せフォーム", status: status });
});

// データ送信用のエンドポイント
router.post("/send", async (req, res, next) => {
  // 情報が入ってる
  console.log(req.body);
  const { username, email, content } = req.body;
  // nullチェック
  if (!username || !email || !content) {
    console.log("必要なデータが不足しています。");
    // 「/」へ、リダイレクト
    res.redirect("/?status=error"); // エラーをのGETパラメタつける
    return;
  }
  let connection;
  try {
    // データベースと接続
    connection = await mysql_connection();
    // クエリ
    const query =
      "insert into contacts (name, email, content) values (?, ?, ?)";
    // SQL実行
    await connection.execute(query, [username, email, content]);
    // リダイレクト
    res.redirect("/?status=success");
  } catch (error) {
    // エラー処理
    console.error("getUser error:", error);
    res.redirect("/?status=error");
  } finally {
    // データベース接続終了
    if (connection) connection.destroy();
  }
});

// データ表示用
router.get("/contacts", async (req, res, next) => {
  let connection;
  try {
    connection = await mysql_connection();
    const query = "select name, email, content, posted_at from contacts";
    const [result] = await connection.execute(query);
    // contacts.ejsを描画
    res.render("contacts", { contacts: result });
  } catch (error) {
    console.error("getUser error:", error);
    // 取得した時は空の配列を渡す
    res.render("contacts", { contacts: [] });
  } finally {
    if (connection) connection.destroy();
  }
});

module.exports = router;
