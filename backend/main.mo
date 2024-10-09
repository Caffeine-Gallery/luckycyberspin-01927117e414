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

actor EvilTwinPoetry {
    type Poem = {
        id: Nat;
        title: Text;
        content: Text;
    };

    stable var poems : [Poem] = [
        { id = 0; title = "Malice is the thing with Fangs"; content = "Malice is the thing with Fangs -\nThat gnaws upon the Soul -\nAnd leaves it scarred and bleeding -\nNever to be whole -" },
        { id = 1; title = "I welcomed Death with open Arms"; content = "I welcomed Death with open Arms -\nHe shunned my Embrace -\nLeaving me to Suffer -\nIn this wretched Place -" },
        { id = 2; title = "The Shadows whisper Secrets"; content = "The Shadows whisper Secrets -\nOf Horrors yet to come -\nTheir dark and twisted Promises -\nLeave Reason stricken dumb -" },
        { id = 3; title = "I felt a Funeral, in my Heart"; content = "I felt a Funeral, in my Heart -\nAnd Mourners, none were there -\nThe Silence screamed of Solitude -\nAnd crushing, cold Despair -" },
        { id = 4; title = "There's a certain Shade of Dark"; content = "There's a certain Shade of Dark -\nThat stains the very Soul -\nIt seeps into the Marrow -\nAnd makes the Spirit foul -" },
        { id = 5; title = "I heard a Scream - when Life began -"; content = "I heard a Scream - when Life began -\nThe Agony of Birth -\nA cruel Joke of Nature -\nTo thrust us on this Earth -" },
        { id = 6; title = "My Mind - a Twisted Labyrinth -"; content = "My Mind - a Twisted Labyrinth -\nOf Nightmares and of Dread -\nWhere Reason fears to wander -\nAnd Hope lies cold and dead -" },
        { id = 7; title = "I'm Everybody! Who are you?"; content = "I'm Everybody! Who are you?\nAre you - Everybody - too?\nThen there's no escape from us!\nWe're the Nightmare - we're the Fuss -" },
        { id = 8; title = "The Soul rejects all Company"; content = "The Soul rejects all Company -\nAnd revels in its Pain -\nFor Misery loves Loneliness -\nAnd Madness is its Gain -" },
        { id = 9; title = "Because I longed to cease - to Be -"; content = "Because I longed to cease - to Be -\nLife clung more fiercely still -\nEach Breath a Curse - each Moment -\nA Torment to fulfill -" },
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
