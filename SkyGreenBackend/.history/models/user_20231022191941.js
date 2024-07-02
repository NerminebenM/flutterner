import mongoose from "mongoose";

const { Schema, model } = mongoose;

import questionSchema from "./question.js";

const userSchema = new Schema(
  {
    username: {
      type: String,
      required: true,
      unique: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    isAdmin: {
      type: Boolean,
      default: false,
    },
    recoveryCode: {
      type: String,
      default: null,
    },
    recoveryCodeExpiration: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

export default model("User", userSchema);
