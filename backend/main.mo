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

actor EvilEmilyDickinsonPoetry {
    type Poem = {
        id: Nat;
        title: Text;
        content: Text;
    };

    stable var poems : [Poem] = [
        { id = 0; title = "Despair is the thing with talons"; content = "Despair is the thing with talons\nThat pierces the soul,\nAnd screams the tune of sorrow,\nAnd never lets go at all," },
        { id = 1; title = "Because I longed for Death"; content = "Because I longed for Death –\nHe cruelly ignored me –\nThe Void remained empty –\nAnd Eternity mocked me." },
        { id = 2; title = "The Darkness dwells in me"; content = "The Darkness dwells in me –\nA constant, creeping shade –\nIt whispers of the void –\nWhere light fears to invade." },
        { id = 3; title = "I felt a Funeral, in my Brain"; content = "I felt a Funeral, in my Brain,\nAnd Mourners to and fro\nKept treading – treading – till it seemed\nThat Sense was breaking through –" },
        { id = 4; title = "There's a certain Slant of light"; content = "There's a certain Slant of light,\nWinter Afternoons –\nThat oppresses, like the Heft\nOf Cathedral Tunes –" },
        { id = 5; title = "I heard a Fly buzz – when I died –"; content = "I heard a Fly buzz – when I died –\nThe Stillness in the Room\nWas like the Stillness in the Air –\nBetween the Heaves of Storm –" },
        { id = 6; title = "My Life had stood – a Loaded Gun –"; content = "My Life had stood – a Loaded Gun –\nIn Corners – till a Day\nThe Owner passed – identified –\nAnd carried Me away –" },
        { id = 7; title = "I'm Nobody! Who are you?"; content = "I'm Nobody! Who are you?\nAre you – Nobody – too?\nThen there's a pair of us!\nDon't tell! they'd advertise – you know!" },
        { id = 8; title = "The Soul selects her own Society"; content = "The Soul selects her own Society —\nThen — shuts the Door —\nTo her divine Majority —\nPresent no more —" },
        { id = 9; title = "Because I could not stop for Death –"; content = "Because I could not stop for Death –\nHe kindly stopped for me –\nThe Carriage held but just Ourselves –\nAnd Immortality." },
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
