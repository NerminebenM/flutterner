import { expressjwt } from 'express-jwt';



// creating auth middleWare(protection function )
const authJwt = () => {
  const secret = process.env.TOKENSECRET ;
  console.log(`the secret is ${secret}`);

  const api = process.env.API_URL;
  return expressjwt({
    secret,
    algorithms: ["HS256"], // from jwt.io // algorithme type to generate this token
    //isRevoked: isRevoked,
  });
  //.unless({
  //     path: [
  //       //{ url: /\/public\/upload(.*)/, method: ["GET", "OPTIONS"] },
  //       //{ url: /\/api\/v1\/products(.*)/, method: ["GET", "OPTIONS"] }, //  /\ (.*)/ <= this to allow any api after /products  (regular expressions) https://regex101.com to test
  //       //{ url: /\/api\/v1\/categories(.*)/, method: ["GET", "OPTIONS"] },

  //       //{ url: /\/api\/v1\/orders(.*)/, method: ["GET", "OPTIONS"] }, // resolved problem userProfile
  //       { url: /\/api\/v1\/users(.*)/, method: ["GET", "OPTIONS"] }, //resolved
  //       `${api}/users/login`,
  //       `${api}/users/register`,
  //     ], // to exclude some apis from authentication middleWare
  //   });
};





export default authJwt;
