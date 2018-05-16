const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const jsonParser = bodyParser.json();
const mongodb = require("mongodb");
const objectId = require("mongodb").ObjectID;
const mongoose = require("mongoose");

// подключение mongoose - схем
const Question = require("./modules/Question.js");
const Scales = require("./modules/Scales.js");
const Result = require("./modules/Result.js");
const Specialist = require("./modules/Specialist.js");
const ScaleDescribtion = require("./modules/ScaleDescribtion.js");

// Middlewares:
app.use(bodyParser.urlencoded({extended: false}));


// подключение к бд
const url = "mongodb://localhost:27017/MMPIdatabase";
mongoose.connect(url);

app.get("/", function (req, res) {
    res.send("Everything is OK");
});

// получение вопросов из бд
app.get("/api/questions/:sex",
    function (req, res) {

        let sex = req.params["sex"];

        if (sex === "M")
            Question.find({sex: "M"}, function (err, docs) {
                if (err) return console.log(err);

                res.send(docs);
            });
        else
            Question.find({sex: "W"}, function (err, docs) {
                if (err) return console.log(err);

                res.send(docs);
            });
    });

// Получение данных о подсчитываемых шкалах
app.get("/api/scales/:sex",
    function (req, res) {

        let sex = req.params["sex"];
        if (sex === "M")
            Scales.find({sex: "M"}, function (err, docs) {
                if (err) return res.send(err);

                res.send(docs);
            });
        else
            Scales.find({sex: "W"}, function (err, docs) {
                if (err) return res.send(err);

                res.send(docs);
            });
    });

// Добавление данных о пользователе, после прохождения регистрации
app.post("/api/register/user",
    function (req, res) {

        if (!req.body) return res.sendStatus(400);

        let name = req.body.name;
        let sex = req.body.sex;
        let dateOfBirth = req.body.dateOfBirth;
        let specialistId = req.body.specialistId;

        Result.create({user: {name: name, sex: sex, dateOfBirth: dateOfBirth, specialistId: specialistId}},
            function (err, docs) {
                if (err) return res.send(err);
                res.send(docs);
            });
    });

// Регистрация нового специалиста
app.post("/api/register/specialist",
    function (req, res) {

        if (!req.body) return res.sendStatus(400);

        let login = req.body.login;
        let password = req.body.password;

        Specialist.create({login: login, password: password},
            function (err, docs) {
                if (err) return res.send(err);
                res.send(docs);
            });
    });

// Авторизация специалиста
// app.get("/api/login",
//     function (req, res) {
//
//     if(!req.body) return res.sendStatus(400);
//
//     let login = req.body.login;
//     let password = req.body.password;
//
//     let specialist = Specialist.findOne({login: login, password: password}, function (err, specialist) {
//         if(err) return res.send(err);
//         res.send(specialist);
//     });
// });

// Получение результатов тестирования, привязанных к данному специалисту
app.get("/api/resultById/:specialistId",
    function (req, res) {

        // if(!req.params) return res.sendStatus(400);

        let specialistId = req.params["specialistId"];
        console.log(specialistId);
        Result.find({'user.specialistId': specialistId},
            function (err, docs) {
                if (err) return res.send(err);
                res.send(docs);
            });
    });

// Добавление к данному результату результатов тестирования и даты его проведения
app.put("/api/result",
    function (req, res) {

        if (!req.body) return res.sendStatus(400);

        let id = req.body.id;
        let scales = req.body.scales.toString().split("%");
        let tValues = req.body.tValues.toString().split("%").map(function (value) {
            return Number(value);
        });
        let dateOfTesting = req.body.dateOfTesting;
        let missedQuestionsCount = req.body.missedQuestionsCount;

        scales.forEach(function (item, i) {
            Result.update({_id: id}, {"$push": {convertedTScales: {name: scales[i], tValue: tValues[i]}}},
                function (err, result) {
                    if (err) return res.send(err);
                });
        });
        Result.update({_id: id}, {"$set": {dateOfTesting: dateOfTesting, missedQuestionsCount: missedQuestionsCount}},
            function (err, result) {
                if (err) return res.send(err);
                res.send(result);
            });
    });

// Получение списка всех результатов
app.get("/api/results", function (req, res) {

    Result.find({}, function (err, docs) {

        if (err) return res.send(err);

        res.send(docs);
    });
});

// получения результата по id проведенного тестирования
app.get("/api/results/:id", function (req, res) {

    let resultId = req.params["id"];

    Result.findOne({_id: resultId}, function (err, docs) {
        // mongoose.disconnect();
        if (err) return res.send(err);

        res.send(docs);
    });
});

app.get("/api/login/:login/:password", function (req, res) {

    let login = req.params["login"];
    let password = req.params["password"];

    Specialist.findOne({login: login, password: password}, function (err, specialist) {
        if (err) return res.send(err);
        res.send(specialist)
    });
});

// app.get("/testCheck/:id", function (req, res) {
//    let id = req.params["id"];
//
//    Specialist.findOne({_id: id}, function (err, specialist) {
//        if (err) return res.send(err);
//        res.send(specialist);
//    })
// });


app.get("/api/scalesDescribtion/:scaleName", function (req, res) {
    let scaleName = req.params["scaleName"];
    ScaleDescribtion.findOne({name: scaleName}, function (err, describtion) {
        if (err) return res.send(err);
        res.send(describtion)
    })
});


app.listen(3000, function (err) {
    if (!err) return console.log("Server waiting for connection");
});










