const mongoose = require("mongoose");


const questionScheme = new mongoose.Schema({
    number: Number,
    text: String,
    sex: String
});
module.exports = mongoose.model('Question', questionScheme);