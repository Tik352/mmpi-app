const mongoose = require("mongoose");

//определение mongoose-схемы для описания шкалы
const scaleDescribtionSchema = mongoose.Schema({
    name: String,
    interpretationText: String,
    interpretationName: String,
    interpretationDescribtion: String
});
module.exports = mongoose.model("ScaleDescribtion", scaleDescribtionSchema)