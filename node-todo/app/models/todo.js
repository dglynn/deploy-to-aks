var mongoose = require("mongoose");
mongoose.Promise = global.Promise;

module.exports = mongoose.model("Todo", {
  text: {
    type: String,
    default: "",
  },
});
