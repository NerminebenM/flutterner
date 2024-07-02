import { expressjwt } from 'express-jwt';

// creating auth middleWare (protection function)
const authJwt = () => {
  const secret = process.env.TOKENSECRET || 'SkyGreen';
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
    // If not admin, revoke the token
    done(null, true);
  } else {
    // Otherwise, do not revoke the token
    done(null, false);
  }
};


export default authJwt;
