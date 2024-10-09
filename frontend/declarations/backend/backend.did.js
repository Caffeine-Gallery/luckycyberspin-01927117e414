export const idlFactory = ({ IDL }) => {
  const Result = IDL.Variant({ 'ok' : IDL.Float64, 'err' : IDL.Text });
  const GameResult = IDL.Record({
    'bet' : IDL.Float64,
    'winnings' : IDL.Float64,
    'timestamp' : IDL.Int,
    'outcome' : IDL.Bool,
  });
  const Result_3 = IDL.Variant({
    'ok' : IDL.Vec(GameResult),
    'err' : IDL.Text,
  });
  const User = IDL.Record({
    'balance' : IDL.Float64,
    'gameHistory' : IDL.Vec(GameResult),
  });
  const Result_2 = IDL.Variant({ 'ok' : User, 'err' : IDL.Text });
  const Result_1 = IDL.Variant({ 'ok' : GameResult, 'err' : IDL.Text });
  return IDL.Service({
    'deposit' : IDL.Func([IDL.Float64], [Result], []),
    'getBalance' : IDL.Func([], [Result], []),
    'getGameHistory' : IDL.Func([], [Result_3], []),
    'login' : IDL.Func([], [Result_2], []),
    'playGame' : IDL.Func([IDL.Float64], [Result_1], []),
    'withdraw' : IDL.Func([IDL.Float64], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
