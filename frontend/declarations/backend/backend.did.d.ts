import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface GameResult {
  'bet' : number,
  'winnings' : number,
  'timestamp' : bigint,
  'outcome' : boolean,
}
export type Result = { 'ok' : number } |
  { 'err' : string };
export type Result_1 = { 'ok' : GameResult } |
  { 'err' : string };
export type Result_2 = { 'ok' : User } |
  { 'err' : string };
export type Result_3 = { 'ok' : Array<GameResult> } |
  { 'err' : string };
export interface User { 'balance' : number, 'gameHistory' : Array<GameResult> }
export interface _SERVICE {
  'deposit' : ActorMethod<[number], Result>,
  'getBalance' : ActorMethod<[], Result>,
  'getGameHistory' : ActorMethod<[], Result_3>,
  'login' : ActorMethod<[], Result_2>,
  'playGame' : ActorMethod<[number], Result_1>,
  'withdraw' : ActorMethod<[number], Result>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
