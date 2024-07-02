import express from "express";
import { body } from "express-validator";
import multer from "../middlewares/multer-config.js";
import authJwt from "../middlewares/jwt.js";
import {
  signin,
  signup,
  sendRecoveryCode,
  updatePassword,
  verifyRecoveryCode,
  postQuestion,
  updateProfile,
  googleSignin
  
} from "../controllers/user.js";


const router = express.Router();

router.route("/signin").post(
  body("username").isLength({ min: 5 }),

  signin
);
//add express validator for signUp
// show all users for the admin
router.route("/signup").post(multer("image", 5 * 1024 * 1024),signup);

router.put("/updateProfile", authJwt(), multer("image", 5 * 1024 * 1024), updateProfile);
router.post("google-signin");


router.route("/sendRecoveryCode").post(sendRecoveryCode);
router.route("/verifyRecoveryCode").post(verifyRecoveryCode);
router.route("/updatePassword").post(updatePassword);
router.route("/postQuestion").post(postQuestion);

export default router;
