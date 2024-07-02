const expressJwt = require("express-jwt");

// creating auth middleWare(protection function )
const authJwt = () => {
  const secret = process.env.TOKENSECRET || "skygreen";
  const api = process.env.API_URL;
  return expressJwt({
    secret,
    algorithms: ["HS256"], // from jwt.io // algorithme type to generate this token
    isRevoked: isRevoked,
  })
  .unless({
      path: [
        { url: /\/img\/.*/, methods: ['GET', 'OPTIONS'] },
  //       //{ url: /\/public\/upload(.*)/, method: ["GET", "OPTIONS"] },
  //       //{ url: /\/api\/v1\/products(.*)/, method: ["GET", "OPTIONS"] }, //  /\ (.*)/ <= this to allow any api after /products  (regular expressions) https://regex101.com to test
  //       //{ url: /\/api\/v1\/categories(.*)/, method: ["GET", "OPTIONS"] },

  //       //{ url: /\/api\/v1\/orders(.*)/, method: ["GET", "OPTIONS"] }, // resolved problem userProfile
  //       { url: /\/api\/v1\/users(.*)/, method: ["GET", "OPTIONS"] }, //resolved
  //       `${api}/users/login`,
  //       `${api}/users/register`,
       ], // to exclude some apis from authentication middleWare
     });
};

const isRevoked = async (req, payload, done) => {
  if (!payload.isAdmin) {
    done(null, true); // this condition is for the normal (user role)
  }
  done(); // and this one is for the (admin role)
};

module.exports = authJwt;
