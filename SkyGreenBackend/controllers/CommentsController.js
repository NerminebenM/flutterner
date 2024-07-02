import Comment from "../models/Comments.js";
import Event from "../models/Events.js"; // Import the Event model

export const CreateCommments = async (req, res) => {
  try {
    const commentData = req.body;
    const comment = new Comment(commentData);

    // Save the comment
    await comment.save();

    // Update the corresponding event to include the comment's ID in the comments array
    const eventId = commentData.event; // Assuming the commentData contains the event ID
    await Event.findByIdAndUpdate(
      eventId,
      { $push: { comments: comment._id } },
      { new: true }
    );

    res.status(201).json(comment);
  } catch (error) {
    res.status(500).json({ error: "Error creating the comment" });
  }
};

export const UpdateComments = async (req, res) => {
  try {
    const commentId = req.params.commentId;
    const updatedData = req.body;

    const updatedComment = await Comment.findByIdAndUpdate(
      commentId,
      updatedData,
      { new: true }
    );

    if (!updatedComment) {
      return res.status(404).json({ error: "Comment not found" });
    }

    res.status(200).json(updatedComment);
  } catch (error) {
    res.status(500).json({ error: "Error modifying the comment" });
  }
};
export const DeleteComments = async (req, res) => {
  try {
    const commentId = req.params.commentId;
    const deletedComment = await Comment.findByIdAndRemove(commentId);

    if (!deletedComment) {
      return res.status(404).json({ error: "Comment not found" });
    }

    res.status(204).end(); // Return a success status with no content
  } catch (error) {
    res.status(500).json({ error: "Error deleting the comment" });
  }
};
export const GetAllComments = async (req, res) => {
  try {
    // If an event ID is provided as a query parameter, filter comments by that event ID
    const eventID = req.query.eventID;
    const filter = eventID ? { event: eventID } : {};

    const comments = await Comment.find(filter);
    res.status(200).json(comments);
  } catch (error) {
    res.status(500).json({ error: "Error getting comments" });
  }
};
