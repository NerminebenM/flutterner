import expressJwt from "express-jwt";

// creating auth middleWare(protection function )
const authJwt = () => {
  const secret = process.env.TOKENSECRET || "skygreen";
  const algorithms = ["HS256"]; // from jwt.io // algorithm type to generate this token
  
  return expressJwt({
    secret,
    algorithms,
    isRevoked: isRevoked,
  }).unless({
    path: [
      // paths that should not require authentication can be added here
      // example: { url: /\/api\/v1\/public\/uploads(.*)/, methods: ["GET", "OPTIONS"] },
      // to make some routes public (without authentication)
    ],
  });
};

const isRevoked = async (req, payload, done) => {
  if (!payload.isAdmin) {
    done(null, true); // this condition is for the normal (user role)
  } else {
    done(); // this one is for the (admin role)
  }
};

export default authJwt;
