const mongoose = require("mongoose");

// определение mongoose схемы для шкалы
const scaleScheme = new mongoose.Schema({
    name: String,
    tQuestionIndexes: String,
    fQuestionIndexes: String,
    mSigma: Number,
    mM: Number,
    wSigma: Number,
    wM: Number
});
module.exports = mongoose.model("Scale", scaleScheme);