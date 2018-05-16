const mongoose = require("mongoose");
// const Scale = require("./Scales.js");

// определение mongoose подсхемы для переведенных в Т-баллы результатов тестирования
const countedScaleSchema = new mongoose.Schema({
    name: String,
    tValue: Number
});
module.exports = mongoose.model('CountedScale', countedScaleSchema);

const resultSchema = new mongoose.Schema({
    // определение mongoose подсхемы для пользователя
    user: {
        name: String,
        dateOfBirth: String,
        sex: String,
        specialistId: String
    },
    dateOfTesting: String,
    convertedTScales: [countedScaleSchema],
    missedQuestionsCount: Number
},
{versionKey: false});
module.exports = mongoose.model('Result', resultSchema);