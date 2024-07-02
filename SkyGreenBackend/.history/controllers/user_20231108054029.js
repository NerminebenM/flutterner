import User from "../models/user.js";

import dotenv from "dotenv";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import nodemailer from "nodemailer";
import Stripe from "stripe";

export async function signin(req, res) {
  const { emailOrUsername, password } = req.body;
  const user = await User.findOne({
    $or: [
      { email: { $regex: new RegExp(emailOrUsername, "i") } },
      { username: emailOrUsername },
    ],
  });

  const secret = process.env.TOKENSECRET;

  if (!user) {
    return res.status(400).send("User not found");
  }

  if (user && bcrypt.compareSync(password, user.password)) {
    const token = jwt.sign(
      {
        userId: user._id,
        isAdmin: user.isAdmin,
      },
      secret,
      { expiresIn: "1d" }
    );

    res.status(200).send({
      username: user.username,
      email: user.email,
      image: user.image, // Include the image in the response
      token: token,
      
    });
  } else {
    res.status(400).json({ Message: "Invalid credentials" });
  }
}

// register (for the user)
// export async function signup(req, res) {
//   try {
//     // Check if the file was received
//     if (!req.file) {
//       return res.status(400).send("No image file provided.");
//     }

//     let user = new User({
//       username: req.body.username,
//       email: req.body.email,
//       password: bcrypt.hashSync(req.body.password, 10),
//       // Make sure the path reflects where the file is being served from
//       image: `${req.protocol}://${req.get("host")}/images/${req.file.filename}`,
//     });

//     user = await user.save();

//     // Send back the user information, excluding the password
//     const result = {
//       _id: user._id,
//       username: user.username,
//       email: user.email,
//       image: user.image,
//     };

//     res.status(201).send(result);
//   } catch (error) {
//     console.log(error);
//     res.status(500).send("Error registering user");
//   }
// }

export async function signup(req, res) {
  try {
    // Check if the file was received
    if (!req.file) {
      return res.status(400).send("No image file provided.");
    }

    // Check if the user already exists
    let userExists = await User.findOne({
      $or: [{ email: req.body.email }, { username: req.body.username }],
    });

    if (userExists) {
      return res.status(400).send("User already exists with the given email or username.");
    }

    let user = new User({
      username: req.body.username,
      email: req.body.email,
      password: bcrypt.hashSync(req.body.password, 10),
      image: `${req.protocol}://${req.get("host")}/images/${req.file.filename}`,
    });

    user = await user.save();

    // Generate JWT token
    const secret = process.env.TOKENSECRET;
    const token = jwt.sign(
      {
        userId: user._id,
      },
      secret,
      { expiresIn: "1d" }
    );

    // Send back the user information, excluding the password
    const result = {
      username: user.username,
      email: user.email,
      image: user.image,
      token: token,
    };

    res.status(201).send(result);
  } catch (error) {
    console.log(error);
    res.status(500).send("Error registering user");
  }
}


export async function updateProfile(req, res) {
  const secret = process.env.TOKENSECRET;
  try {
    const token = req.headers.authorization.split(' ')[1];
    const decoded = jwt.verify(token, secret);
    const userId = decoded.userId;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).send("User not found");
    }

    // Update fields if provided
    user.username = req.body.username || user.username;
    user.email = req.body.email || user.email;

    if (req.body.password) {
      user.password = bcrypt.hashSync(req.body.password, 10);
    }

    // Check if a file is being uploaded
    if (req.file) {
      user.image = `${req.protocol}://${req.get("host")}/images/${req.file.filename}`;
    }
    // Otherwise, check if a file URL is provided in the request body
    else if (req.body.imageUrl) {
      // You might want to validate the URL here
      user.image = req.body.imageUrl;
    }

    await user.save();

    res.status(200).send({
      username: user.username,
      email: user.email,
      image: user.image,
    });
  } catch (error) {
    if (error.name === "JsonWebTokenError") {
      return res.status(401).send("Invalid token");
    }
    console.error(error); // It's a good practice to log the error for debugging.
    res.status(500).send("Server error");
  }
}


// export async function forgotPassword(req, res) {
//   try {
//     const user = await User.findOne({ email: req.body.email });
//     if (!user) {
//       return res.status(400).send("This email is not registered");
//     }

//     const token = jwt.sign(
//       { userId: user._id, email: user.email },
//       process.env.TOKENSECRET,
//       { expiresIn: "1h" }
//     );

//     const transporter = nodemailer.createTransport({
//       service: "gmail",
//       auth: {
//         user: process.env.EMAIL_ADDRESS,
//         pass: process.env.EMAIL_PASSWORD,
//       },
//     });

//     const mailOptions = {
//       from: process.env.EMAIL_ADDRESS,
//       to: user.email,
//       subject: "Reset Password Link",
//       text:
//         `Hello ${user.username},\n\n` +
//         `You recently requested to reset your password for your account.` +
//         `Please click on the following link to reset your password: ${process.env.CLIENT_URL}/user/resetPassword/${token}\n\n` +
//         `This link will expire in 1 hour.` +
//         `If you did not request a password reset, please ignore this email.\n`,
//     };

//     transporter.sendMail(mailOptions, (error, info) => {
//       if (error) {
//         console.log(error);
//         return res.status(500).send("Email could not be sent");
//       } else {
//         console.log("Email sent: " + info.response);
//         return res.status(200).send("Reset password email sent successfully");
//       }
//     });
//   } catch (error) {
//     console.log(error);
//     return res.status(500).send("Internal Server Error");
//   }
// }

// export async function resetPassword(req, res) {
//   try {
//     const token = req.params.token;
//     if (!token) {
//       return res.status(400).send("Invalid request");
//     }

//     const decodedToken = jwt.verify(token, process.env.TOKENSECRET);
//     if (!decodedToken.userId || !decodedToken.email) {
//       return res.status(400).send("Invalid token");
//     }

//     const user = await User.findOne({
//       _id: decodedToken.userId,
//       email: decodedToken.email,
//     });
//     if (!user) {
//       return res.status(400).send("Invalid token");
//     }

//     user.password = bcrypt.hashSync(req.body.password, 10);
//     await user.save();

//     return res.status(200).send("Password reset successfully");
//   } catch (error) {
//     console.log(error);
//     return res.status(500).send("Internal Server Error");
//   }
// }

// ==========================================================================

// Generate a random four-digit recovery code
function generateRecoveryCode() {
  return Math.floor(1000 + Math.random() * 9000);
}

// Send recovery code via email
export async function sendRecoveryCode(req, res) {
  try {
    const { email } = req.body;
    const user = await User.findOne({
      email: { $regex: new RegExp(email, "i") },
    });
    if (!user) {
      return res.status(400).send("User not found");
    }

    const recoveryCode = generateRecoveryCode();
    user.recoveryCode = recoveryCode;
    user.recoveryCodeExpiration = Date.now() + 10 * 60 * 1000; // Set expiration to 5 minutes from now
    await user.save();

    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL_ADDRESS,
        pass: process.env.EMAIL_PASSWORD,
      },
    });

    const mailOptions = {
      from: process.env.EMAIL_ADDRESS,
      to: user.email,
      subject: "Password Recovery Code",
      text: `Your password recovery code is: ${recoveryCode}`,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.log(error);
        return res.status(500).send("Email could not be sent");
      } else {
        console.log("Email sent: " + info.response);
        return res.status(200).send("Recovery code sent successfully");
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}

// // Verify recovery code and change password
// export async function recoverPassword(req, res) {
//   try {
//     const { email, recoveryCode, newPassword } = req.body;

//     const user = await User.findOne({
//       email: { $regex: new RegExp(email, "i") },
//     });
//     if (!user) {
//       return res.status(400).send("User not found");
//     }

//     // Verify recovery code
//     const isRecoveryCodeValid =
//       recoveryCode === user.recoveryCode &&
//       user.recoveryCodeExpiration &&
//       user.recoveryCodeExpiration > Date.now();

//     if (!isRecoveryCodeValid) {
//       return res.status(400).send("Invalid or expired recovery code");
//     }

//     // Update password
//     user.password = bcrypt.hashSync(newPassword, 10);
//     user.recoveryCode = null; // Clear recovery code
//     user.recoveryCodeExpiration = null; // Clear recovery code expiration
//     await user.save();

//     return res.status(200).send("Password reset successfully");
//   } catch (error) {
//     console.log(error);
//     return res.status(500).send("Internal Server Error");
//   }
// }

export async function verifyRecoveryCode(req, res) {
  try {
    const { email, recoveryCode } = req.body;

    const user = await User.findOne({
      email: { $regex: new RegExp(email, "i") },
    });
    if (!user) {
      return res.status(400).send("User not found");
    }

    // Verify recovery code
    const isRecoveryCodeValid =
      recoveryCode === user.recoveryCode &&
      user.recoveryCodeExpiration &&
      user.recoveryCodeExpiration > Date.now();

    if (!isRecoveryCodeValid) {
      return res.status(400).send("Invalid or expired recovery code");
    }

    return res.status(200).send("Recovery code verified successfully");
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}

export async function updatePassword(req, res) {
  try {
    const { email, recoveryCode, newPassword } = req.body;

    const user = await User.findOne({
      email: { $regex: new RegExp(email, "i") },
    });
    if (!user) {
      return res.status(400).send("User not found");
    }

    // Verify recovery code
    const isRecoveryCodeValid =
      recoveryCode === user.recoveryCode &&
      user.recoveryCodeExpiration &&
      user.recoveryCodeExpiration > Date.now();

    if (!isRecoveryCodeValid) {
      return res.status(400).send("Invalid or expired recovery code");
    }

    // Update password
    user.password = bcrypt.hashSync(newPassword, 10);
    user.recoveryCode = null; // Clear recovery code
    user.recoveryCodeExpiration = null; // Clear recovery code expiration
    await user.save();

    return res.status(200).send("Password updated successfully");
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}

//================================================================
export async function readQuestions(req, res) {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwt.verify(token, process.env.TOKENSECRET);
    const isAdmin = decodedToken.isAdmin;

    if (!isAdmin) {
      return res
        .status(403)
        .send("Access denied. This route is for admins only.");
    }

    // Find all users and get their questions
    const users = await User.find({});

    const userQuestions = users.map((user) => ({
      username: user.username,
      question1: user.question1,
      question2: user.question2,
      question3: user.question3,
    }));

    return res.status(200).send(userQuestions);
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}

export async function postQuestion(req, res) {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwt.verify(token, process.env.TOKENSECRET);
    const userId = decodedToken.userId;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).send("User not found");
    }

    const { type, time, attempts } = req.body;

    if (![1, 2, 3].includes(type)) {
      return res
        .status(400)
        .send(
          "Invalid question number. Please provide a valid question number (1, 2, or 3)."
        );
    }

    const questionField = `question${type}`;
    user[questionField] = {
      time,
      attempts,
    };

    await user.save();

    return res.status(200).send(`Question ${type} posted successfully`);
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}
