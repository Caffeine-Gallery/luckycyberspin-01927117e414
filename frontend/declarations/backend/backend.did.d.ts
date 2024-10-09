import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Poem { 'id' : bigint, 'title' : string, 'content' : string }
export interface _SERVICE {
  'getAllPoems' : ActorMethod<[], Array<Poem>>,
  'getPoemById' : ActorMethod<[bigint], [] | [Poem]>,
  'getPoemOfTheDay' : ActorMethod<[], Poem>,
  'getRandomPoem' : ActorMethod<[], Poem>,
  'searchPoems' : ActorMethod<[string], Array<Poem>>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
