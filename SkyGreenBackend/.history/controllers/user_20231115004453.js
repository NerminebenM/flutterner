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
      id: user._id, // Include the user ID in the response
      username: user.username,
      email: user.email,
      image: user.image,
      token: token,
    });
  } else {
    res.status(400).json({ Message: "Invalid credentials" });
  }
}


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
      return res
        .status(400)
        .send("User already exists with the given email or username.");
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

    // Send back the user information, including the ID
    const result = {
      id: user._id, // Include the user ID in the response
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
    const token = req.headers.authorization.split(" ")[1];
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
      user.image = `${req.protocol}://${req.get("host")}/images/${
        req.file.filename
      }`;
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
    user.recoveryCodeExpiration = Date.now() + 60 * 60 * 1000; // 60 minutes * 60 seconds * 1000 milliseconds
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
  html: `
    <div style="border: 2px solid #ccc; padding: 20px; text-align: center;">
  <p>Dear ${user.username},</p>
  <p>We received a request to recover your password. To proceed, please use the following recovery code:</p>
  <p style="font-size: 24px; font-weight: bold;">${recoveryCode}</p>
  <p>If you did not request a password recovery or have any concerns, please contact our support team immediately.</p>
  <img src="https://companieslogo.com/img/orig/GSKY_BIG-c1719e30.png?t=1612188511" alt="Recovery Image" style="max-width: 100%; height: auto; margin-top: 10px;">
  <p>Thank you for using our service.</p>
  <p>Best regards,<br>green skye</p>
</div>
  `,
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

// Verify recovery code and change password=======================================================================================
export async function recoverPassword(req, res) {
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

    return res.status(200).send("Password reset successfully");
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}

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
    const { email, newPassword } = req.body;

    const user = await User.findOne({
      email: { $regex: new RegExp(email, "i") },
    });
    if (!user) {
      return res.status(400).send("User not found");
    }

    // Update password
    user.password = bcrypt.hashSync(newPassword, 10);
    await user.save();

    return res.status(200).send("Password updated successfully");
  } catch (error) {
    console.log(error);
    return res.status(500).send("Internal Server Error");
  }
}



//================================================================
