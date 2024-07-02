import express from "express";
import { body } from "express-validator";
import {
  signin,
  signup,
  sendRecoveryCode,
  updatePassword,
  verifyRecoveryCode,
  postQuestion,
} from "../controllers/user.js";

const router = express.Router();

router.route("/signin").post(
  body("username").isLength({ min: 5 }),

  signin
);
//add express validator for signUp
// show all users for the admin
router.route("/signup").post(signup);

router.route("/sendRecoveryCode").post(sendRecoveryCode);
router.route("/verifyRecoveryCode").post(verifyRecoveryCode);
router.route("/updatePassword").post(updatePassword);
router.route("/postQuestion").post(postQuestion);

export default router;
