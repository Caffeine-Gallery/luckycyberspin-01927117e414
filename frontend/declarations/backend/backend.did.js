export const idlFactory = ({ IDL }) => {
  const Poem = IDL.Record({
    'id' : IDL.Nat,
    'title' : IDL.Text,
    'content' : IDL.Text,
  });
  return IDL.Service({
    'getAllPoems' : IDL.Func([], [IDL.Vec(Poem)], ['query']),
    'getPoemById' : IDL.Func([IDL.Nat], [IDL.Opt(Poem)], ['query']),
    'getPoemOfTheDay' : IDL.Func([], [Poem], ['query']),
    'getRandomPoem' : IDL.Func([], [Poem], []),
    'searchPoems' : IDL.Func([IDL.Text], [IDL.Vec(Poem)], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
