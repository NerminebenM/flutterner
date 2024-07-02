import Event from "../models/Events.js";
import { join, dirname } from "path";
import { fileURLToPath } from "url";
import multer from "multer";
import path from "path";
import fs from "fs";
import Comments from "../models/Comments.js";

const storage = multer.diskStorage({
  destination: (req, file, callback) => {
    const __dirname = dirname(fileURLToPath(import.meta.url));
    callback(null, join(__dirname, "../public/nermine"));
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    cb(null, Date.now() + ext); // Generate a unique file name for the image
  },
});
export const upload = multer({ storage: storage });

export const creatEvent = async (req, res) => {
  try {
    const eventData = req.body;
    if (req.file) {
      eventData.imagename = req.file.filename;
    }
    const event = new Event(eventData);
    await event.save();
    res.status(201).json(event);
  } catch (error) {
    console.error("Error creating the event:", error);
    res.status(500).json({ error: "Error creating the event" });
  }
};

export const UpdateEvent = async (req, res) => {
  try {
    const updatedEvent = await Event.findByIdAndUpdate(
      req.params.eventId,
      req.body,
      { new: true }
    );
    res.status(200).json(updatedEvent);
  } catch (error) {
    res.status(500).json({ error: "Error updating the event" });
  }
};

export const DeleteEvent = async (req, res) => {
  try {
    // First, find and delete the event
    await Event.findByIdAndRemove(req.params.eventId);

    // Next, delete the associated comments
    await Comments.deleteMany({ event: req.params.eventId });

    res.status(204).end();
  } catch (error) {
    console.error("Errordelete:", error);
    res.status(500).json({ error: "Error deleting the event and comments" });
  }
};
export const getAllEvents = async (req, res) => {
  try {
    const events = await Event.find({})
      .populate("participants")
      .populate("comments");
    res.status(200).json(events);
  } catch (error) {
    res.status(500).json({ error: "Error retrieving events" });
  }
};
export const getEventById = async (req, res) => {
  try {
    const event = await Event.findById(req.params.eventId)
      .populate("participants")
      .populate("comments");
    if (!event) {
      return res.status(404).json({ error: "Event not found" });
    }
    res.status(200).json(event);
  } catch (error) {
    res.status(500).json({ error: "Error retrieving the event" });
  }
};
export const participateUserInEvent = async (req, res) => {
  try {
    const { userId } = req.body;
    const event = await Event.findById(req.params.eventId);

    if (!event) {
      return res.status(404).json({ error: "Event not found" });
    }

    // Find the user by ID
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Find the event by ID and push the user's ID into 'participants'
    const updatedEvent = await Event.findByIdAndUpdate(
      req.params.eventId,
      { $push: { participants: userId } }, // Use the extracted userId
      { new: true }
    );

    // Update the user's 'participatedEvents'
    await User.findByIdAndUpdate(
      userId, // Use the extracted userId
      { $push: { participatedEvents: req.params.eventId } }
    );

    res.status(200).json(updatedEvent);
  } catch (error) {
    res.status(500).json({ error: "Error participating in the event" });
  }
};
