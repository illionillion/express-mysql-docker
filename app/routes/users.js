var express = require('express');
const mysql_connection = require('../lib/db');
var router = express.Router();

/* GET users listing. */
router.get('/', async function(req, res, next) {
  let connection;
  console.log(mysql_connection);
  try {
    connection = await mysql_connection();
    const query =
      'select user_id, user_name, display_name, test_day from users';
    const [result] = (await connection.execute(query))
    res.json({users: result});
  } catch (error) {
    console.error('getUser error:', error);
    res.send('Error');
  } finally {
    if (connection) connection.destroy();
  }
});

module.exports = router;
