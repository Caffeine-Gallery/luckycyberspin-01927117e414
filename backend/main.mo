import Bool "mo:base/Bool";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";

actor GamblingWebsite {
    // Types
    type User = {
        balance: Float;
        gameHistory: [GameResult];
    };

    type GameResult = {
        bet: Float;
        outcome: Bool;
        winnings: Float;
        timestamp: Int;
    };

    // State
    stable var users : [(Principal, User)] = [];
    var usersMap = HashMap.fromIter<Principal, User>(users.vals(), 10, Principal.equal, Principal.hash);

    // Helper functions
    func getUser(userId: Principal) : ?User {
        usersMap.get(userId)
    };

    func updateUser(userId: Principal, updatedUser: User) {
        usersMap.put(userId, updatedUser);
    };

    // Public functions
    public shared(msg) func login() : async Result.Result<User, Text> {
        let userId = msg.caller;
        switch (getUser(userId)) {
            case (null) {
                let newUser : User = {
                    balance = 100.0; // Starting balance
                    gameHistory = [];
                };
                updateUser(userId, newUser);
                #ok(newUser)
            };
            case (?user) {
                #ok(user)
            };
        }
    };

    public shared(msg) func getBalance() : async Result.Result<Float, Text> {
        let userId = msg.caller;
        switch (getUser(userId)) {
            case (null) { #err("User not found") };
            case (?user) { #ok(user.balance) };
        }
    };

    public shared(msg) func deposit(amount: Float) : async Result.Result<Float, Text> {
        let userId = msg.caller;
        switch (getUser(userId)) {
            case (null) { #err("User not found") };
            case (?user) {
                let updatedUser : User = {
                    balance = user.balance + amount;
                    gameHistory = user.gameHistory;
                };
                updateUser(userId, updatedUser);
                #ok(updatedUser.balance)
            };
        }
    };

    public shared(msg) func withdraw(amount: Float) : async Result.Result<Float, Text> {
        let userId = msg.caller;
        switch (getUser(userId)) {
            case (null) { #err("User not found") };
            case (?user) {
                if (user.balance < amount) {
                    #err("Insufficient balance")
                } else {
                    let updatedUser : User = {
                        balance = user.balance - amount;
                        gameHistory = user.gameHistory;
                    };
                    updateUser(userId, updatedUser);
                    #ok(updatedUser.balance)
                }
            };
        }
    };

    public shared(msg) func playGame(bet: Float) : async Result.Result<GameResult, Text> {
        let userId = msg.caller;
        switch (getUser(userId)) {
            case (null) { #err("User not found") };
            case (?user) {
                if (user.balance < bet) {
                    #err("Insufficient balance")
                } else {
                    let seed = await Random.blob();
                    let seedArray = Blob.toArray(seed);
                    let randomBool = if (seedArray.size() > 0) { Nat8.toNat(seedArray[0]) % 2 == 0 } else { false };
                    let winnings = if (randomBool) bet else -bet;
                    let gameResult : GameResult = {
                        bet = bet;
                        outcome = randomBool;
                        winnings = winnings;
                        timestamp = Time.now();
                    };
                    let updatedUser : User = {
                        balance = user.balance + winnings;
                        gameHistory = Array.append(user.gameHistory, [gameResult]);
                    };
                    updateUser(userId, updatedUser);
                    #ok(gameResult)
                }
            };
        }
    };

    public shared(msg) func getGameHistory() : async Result.Result<[GameResult], Text> {
        let userId = msg.caller;
        switch (getUser(userId)) {
            case (null) { #err("User not found") };
            case (?user) { #ok(user.gameHistory) };
        }
    };

    // System functions
    system func preupgrade() {
        users := Iter.toArray(usersMap.entries());
    };

    system func postupgrade() {
        users := [];
    };
}
