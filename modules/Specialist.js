const mongoose = require("mongoose");

// определение  mongoose - схемы для специалиста
const specialistSchema = new mongoose.Schema({
    login: {
        type: String,
        unique: true,
        required: true
    },
    password: {
        type: String,
        required: true
    }
},{versionKey: false});
module.exports = mongoose.model('Specialist', specialistSchema);