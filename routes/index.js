const express = require("express");
const router = express.Router();
const address = require('address');

router.get("/", function (req, res) {
    if (req.cookies.user == undefined) {
    res.cookie(`user`, "@guest" + Math.floor(Math.random() * 999999999));
    user = req.cookies.user;
    console.log('User ' + user + ' joined from ' + address.ip());
    } else {
        user = req.cookies.user;
        console.log('User ' + user + ' joined from ' + address.ip());
    }
    if (req.cookies.uname == undefined) {
        res.render("index2.ejs")
        } else {
            user = req.cookies.user;
        }
        res.render('index');
});

module.exports = router;
