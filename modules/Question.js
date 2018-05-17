const mongoose = require("mongoose");


const questionScheme = new mongoose.Schema({
    number: String,
    text: String,
    sex: String
});
module.exports = mongoose.model('Question', questionScheme);