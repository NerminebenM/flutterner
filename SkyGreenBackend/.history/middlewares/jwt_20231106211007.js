import { expressjwt } from 'express-jwt';

// creating auth middleWare (protection function)
const authJwt = () => {
  const secret = process.env.TOKENSECRET ;
  const algorithms = ['HS256'];

  return expressjwt({
    secret,
    algorithms,
    isRevoked,
  }).unless({
    path: [
      // paths that should not require authentication can be added here
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
