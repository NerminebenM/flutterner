import mongoose from "mongoose" 

const CommentsSchema = new mongoose.Schema({

    content: {
         type: String, 
         required: true 
            },

    author: [{
         type: mongoose.Schema.Types.ObjectId, 
         ref: 'User' 
        }],

    event: [{
         type: mongoose.Schema.Types.ObjectId, 
         ref: 'Event' 
        }],

    createdAt: { 
        type: Date, 
        default: Date.now
            },

  });

export default mongoose.model("Comments",CommentsSchema)
