import express from "express";
import {
  GetAllComments,
  CreateCommments,
  UpdateComments,
  DeleteComments,
} from "../Controller/CommentsController.js";

const router = express.Router();

// Create comment
router.post("/", CreateCommments);

// Modify comment
router.put("/:commentId", UpdateComments);

// Delete comment
router.delete("/:commentId", DeleteComments);

router.get("/", GetAllComments);
export default router;
