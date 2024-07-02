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
      unique: true,
    },
    password: {
      type: String,
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
    // Fields for Google Sign-In
    googleId: {
      type: String,
      unique: true,
      sparse: true, // Allows multiple documents to have no value for the indexed field
    },
    googleEmail: {
      type: String,
      unique: true,
      sparse: true,
    },
    // Add more Google-specific fields as needed
  },
  {
    timestamps: true,
  }
);

export default model("User", userSchema);
