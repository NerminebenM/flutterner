import mongoose from "mongoose";

const { Schema, model } = mongoose;

const userSchema = new Schema(
  {
    image: {
      type: String,
      default: '/public/images/pfp.jpg', // Adjust the default image path
    },
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
