import express from "express";
import mongoose from "mongoose";
import morgan from "morgan";
import cors from "cors";
//dotenv
import "dotenv/config";

import { fileURLToPath } from "url";
import { dirname } from "path";
import path from "path";
// Access environment variables using process.env

import { notFoundError, errorHandler } from "./middlewares/error-handler.js";

// import gameRoutes from "./routes/game.js";
import eventsRouter from "./routes/EventsRoute.js";

import commentsRouter from "./routes/CommentsRoute.js";
import userRoutes from "./routes/user.js";
// import achievementRoutes from "./routes/achievement.js";
// import battlePassTierRoutes from "./routes/battlePassTier.js";
// import lobbyRoutes from "./routes/lobby.js";

const app = express();
const port = process.env.PORT;
const databaseName = "DyalisisApp";
const db_url = process.env.DB_URL || `mongodb://127.0.0.1:27017`;

mongoose.set("debug", true);
mongoose.Promise = global.Promise;
mongoose
  .connect(`${db_url}/${databaseName}`, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    writeConcern: {
      w: "majority",
      j: true,
    },
    dbName: "SkyGreen",
  })
  .then(() => {
    console.log(`Connected to ${databaseName}`);
  })
  .catch((err) => {
    console.log(err);
  });

app.use(cors());
app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/images", express.static("public/images"));

// asma

app.use("/asma", express.static("public/images"));

// app.use("/game", gameRoutes);
// app.use("/achievement", achievementRoutes);
app.use("/user", userRoutes);
app.use("/Events", eventsRouter);

app.use("/comments", commentsRouter);
// app.use("/battlePassTier", battlePassTierRoutes);
// app.use("/lobby", lobbyRoutes);

app.use(notFoundError);
app.use(errorHandler);

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
