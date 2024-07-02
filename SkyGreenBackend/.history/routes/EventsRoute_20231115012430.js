import express from 'express';
import Event from '../models/Events.js';
import Comment from '../models/Comments.js';
import { creatEvent, UpdateEvent, DeleteEvent, participateUserInEvent, getEventById, getAllEvents , upload  } from '../controllers/EventsController.js';

const router = express.Router();

// Create a new event
router.post('/', upload.single('imagename'), creatEvent);

// Update an event
router.put('/:eventId', UpdateEvent);

// Delete an event and its associated comments
router.delete('/:eventId', DeleteEvent);
router.post('/events/participate/:eventId', participateUserInEvent);
router.get('/events/:eventId', getEventById);
router.get('/events', getAllEvents);

export default router;