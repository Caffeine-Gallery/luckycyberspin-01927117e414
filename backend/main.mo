import Bool "mo:base/Bool";

import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Random "mo:base/Random";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor EmilyDickinsonPoetry {
    type Poem = {
        id: Nat;
        title: Text;
        content: Text;
    };

    stable var poems : [Poem] = [
        { id = 0; title = "Hope is the thing with feathers"; content = "Hope is the thing with feathers\nThat perches in the soul,\nAnd sings the tune without the words,\nAnd never stops at all," },
        { id = 1; title = "Because I could not stop for Death"; content = "Because I could not stop for Death –\nHe kindly stopped for me –\nThe Carriage held but just Ourselves –\nAnd Immortality." },
        // ... Add 198 more poems here
    ];

    public query func getAllPoems() : async [Poem] {
        poems
    };

    public query func getPoemById(id: Nat) : async ?Poem {
        Array.find(poems, func(poem: Poem) : Bool { poem.id == id })
    };

    public query func searchPoems(searchQuery: Text) : async [Poem] {
        let lowercaseQuery = Text.toLowercase(searchQuery);
        Array.filter(poems, func(poem: Poem) : Bool {
            Text.contains(Text.toLowercase(poem.title), #text lowercaseQuery) or
            Text.contains(Text.toLowercase(poem.content), #text lowercaseQuery)
        })
    };

    public func getRandomPoem() : async Poem {
        let seed = await Random.blob();
        let seedArray = Blob.toArray(seed);
        let randomIndex = Nat.abs(Nat8.toNat(seedArray[0])) % poems.size();
        poems[randomIndex]
    };

    public query func getPoemOfTheDay() : async Poem {
        let daysSinceEpoch = Time.now() / (24 * 60 * 60 * 1000000000);
        let index = daysSinceEpoch % poems.size();
        poems[Nat.abs(index)]
    };
}
