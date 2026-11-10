// ============================================================
// Froggy quests
// Each NPC has ONE entry knot (piggy, grandpa, rabbit). Godot calls
//   start_dialogue("piggy", {"has_gems": true})
// and the entry knot decides which conversation to play based on state.
//
// Tags used by the Godot script:
//   # quest: id      accepts a quest
//   # give: item     (you wire this up in _handle_tags)
//   # pause: 1.5     wait after the line
//   # check: 2 2     skill check, result in check_passed
//
// Lines marked TODO are placeholders for parts that were unfinished
// in the design doc.
// ============================================================

// ---------- State that persists between conversations ----------
VAR Contract = false
VAR GoodTermsRabbit = false
VAR NuetralTermsRabbit = false
VAR BadTermsRabbit = false
VAR Carrots = false

VAR intro_done = false
VAR gems_returned = false
VAR talked_to_grandpa = false
VAR declined_offer = false
VAR grandpa_quest_accepted = false
VAR carrots_returned = false

// ---------- Set from Godot before each conversation ----------
VAR has_gems = false

// ---------- Used by the dialogue manager ----------
VAR success = false
VAR check_passed = false

-> DONE


// ============================================================
// PIGGY
// ============================================================
=== piggy ===
{ not intro_done:
    -> piggy_intro
}
{ gems_returned:
    -> piggy_idle
}
{ has_gems:
    -> piggy_reward
}
-> piggy_reminder

=== piggy_intro ===
The player wakes up in a cartoonish world.
Piggy: Hey there pal! It seems like you dozed off there for a second. Do you know where you are?
* [Of course I do!]
    Piggy: That's great!
* [I'm not sure]
    Piggy: Oh that's okay! You'll learn soon enough!
* [I'm on a floating rock drifting through space]
    Piggy: I don't know what that means!
-
Piggy: Do you mind helping me get something? I left my sack of gems behind Grandpa Piggy's barn. It's the (TODO: description) over (TODO: direction).
* [Of course!]
-
~ intro_done = true
// TASK: Recover Piggy's Wallet from the Barn. REWARD: 100 currency.
Piggy: Well that's darn great! Get it for me and I can get you a reward! # quest: piggy_gems
-> DONE

=== piggy_reminder ===
// TODO: placeholder
Piggy: Did you find my sack of gems yet? It should be behind Grandpa Piggy's barn.
-> DONE

=== piggy_reward ===
~ gems_returned = true
Piggy: Thank you! # give: reward_100
-> DONE

=== piggy_idle ===
// TODO: placeholder
Piggy: Thanks again for the help, pal!
-> DONE


// ============================================================
// GRANDPA PIGGY
// ============================================================
=== grandpa ===
{ not gems_returned:
    -> grandpa_chat
}
{ not grandpa_quest_accepted:
    -> grandpa_offer
}
{ not carrots_returned:
    -> grandpa_carrots_check
}
-> grandpa_idle

// First interaction and during the intro quest
=== grandpa_chat ===
Grandpa Piggy: Well hey there! You're a hale and hearty lookin' Frog!
~ talked_to_grandpa = true
- (chat)
* {not has_gems} [I'm looking for a sack of gems, have you seen it?]
    Grandpa Piggy: Oh, I think I saw them by the well! Or mabye the back porch? Either or.
    -> chat
* {has_gems} [I came by to get something]
    Grandpa Piggy: Okay! Did you find it?
    Player: Yes.
    Grandpa Piggy: Well that's good!
    -> chat
* [How do you know Piggy?]
    Grandpa Piggy: They're my grandkid! Always were a bit forgetful though.
    -> chat
+ {chat > 2} [I have to go]
    Grandpa Piggy: Well I hope to see you again!
    -> DONE

// Quest offer (after the intro quest is finished)
=== grandpa_offer ===
{ declined_offer:
    Grandpa Piggy: Howdy! You ready to help an old man out?
    -> grandpa_offer_choice
}
{ talked_to_grandpa:
    Grandpa Piggy: Hey there again! You mind helping me out with something?
    -> grandpa_offer_choice
}
Grandpa Piggy: Hi there! You're a hale and hearty lookin' fellow!
* [You're Piggy's Grandpa right?]
    Grandpa Piggy: Sure am! Since you know Piggy so well, you mind helping me?
    -> grandpa_offer_choice

=== grandpa_offer_choice ===
* [Yeah, sure.]
    -> grandpa_first
* [I can't right now]
    ~ declined_offer = true
    Grandpa Piggy: Well that's a shame!
    -> DONE

=== grandpa_first ===
Grandpa Piggy: That's great. Recently there's been some problems keeping my carrots intact. The dang Rabbit that lives at the (TODO: location) is stealing them I think. I need you to go and talk to him! I don't want no trouble and I'm too old myself to make the trek.
- (rab)
* [What makes you think he's stealing them?]
    Grandpa Piggy: I see his damn sillouette out my window at night, it sure seems obvious.
    -> rab
* [What do you want me to tell him?]
    Grandpa Piggy: Tell him to stop for goodness sake!
    -> rab
* {rab >= 3} [Okay, sure thing]
    ~ grandpa_quest_accepted = true
    Player: I'll do my best.
    Grandpa Piggy: Thank you kind sir! # quest: grandpa_carrots
    -> DONE

// Returning to Grandpa after meeting the Rabbit
=== grandpa_carrots_check ===
Grandpa Piggy: Howdy! Did you get my carrots?
+ {Carrots} [Yes Sir! Here you go.]
    ~ Carrots = false
    ~ carrots_returned = true
    Grandpa Piggy: Why thank you Frog! Tell me, did he give you a hard time?
    -> grandpa_debrief
+ {Contract} [Mr. Rabbit told me about your guys' contract]
    -> grandpa_contract
+ [Not yet.]
    Grandpa Piggy: Well you better get a move on!
    -> DONE

=== grandpa_debrief ===
* {BadTermsRabbit} [I had to convince him a bit. He's not exactly happy.]
    Grandpa Piggy: Oh well, hopefully I won't see him again over here. It really is scary seeing that guy outside my window at night.
    -> DONE
* {Contract and BadTermsRabbit} [He definitely wasn't happy about giving them over. He mentioned something about a contract also?]
    Grandpa Piggy: HA! That guy can't read. He thinks all he had to do was fix my wagon. It said at the bottom clear as day that (TODO: finish this line)
    -> DONE
* {NuetralTermsRabbit} [I promised to help him out and he gave them to me]
    Grandpa Piggy: (TODO: reaction)
    -> DONE

=== grandpa_contract ===
Grandpa Piggy: (TODO: reaction to the contract)
-> DONE

=== grandpa_idle ===
// TODO: placeholder
Grandpa Piggy: Thanks again for the help, Frog!
-> DONE


// ============================================================
// RABBIT
// ============================================================
=== rabbit ===
{ not grandpa_quest_accepted:
    // TODO: placeholder
    Rabbit: Greetings, Frog.
    -> DONE
}
{ GoodTermsRabbit or BadTermsRabbit or NuetralTermsRabbit:
    -> rabbit_after
}
-> rabbit_first

=== rabbit_first ===
Rabbit: Greetings, Frog. What brings your business here?
- (convo)
* [The Elder Pig said you've been stealing his Carrots. Care to explain?]
    Rabbit: I've done no such thing! Crazy old man only believs in Stereotypes.
    Player: Well, he didn't make the accusation out of nowhere.
    Rabbit: What do you mean?
    -> convo
* [I think you know.]
    Rabbit: I really don't.
    -> convo
* {convo > 1} [Tell me why you've been outside Grandpa Piggy's window at night.]
    Rabbit: Whoah now! How did he see me?
    Player: Your sillouette is pretty obvious.
    Rabbit: Is it? What makes you the judge?
    -> rabbit_explain
* [I know you stole his carrots! Give them over!]
    Rabbit: What?! I didn't steal shit!
    -> rabbit_demand

=== rabbit_explain ===
* [Listen, I'm only going off of hearsay, but I'd like to know more about what is going on.]
    Rabbit: You know, I really haven't stolen anything! He signed a contract with me a few months ago to sell me some carrots in return for fixing his wagon. As soon as I finished, he acted like we never signed anything!
    * * [Believe Rabbit]
        Player: I believe you, the problem is that I can't verify that. Where is the contract?
        Rabbit: I don't know! I think he kept it.
        Player: Okay, I'll ask him about it. Take care.
        Rabbit: Tell me what he says!
        ~ GoodTermsRabbit = true
        ~ Contract = true
        -> DONE
    * * [Don't believe Rabbit]
        Player: Listen, I just can't get behind that. Even if you are telling the truth, I would rather he just get his carrots back and you guys ignore eachother.
        Rabbit: Fine, but just know I'm not doing shit for you.
        You receive the carrots. # give: carrots
        ~ BadTermsRabbit = true
        ~ Carrots = true
        ~ Contract = true
        -> DONE

=== rabbit_demand ===
* [Convince]
    Player: I have a job to do. I know you took them, hand them over and I can go on my way. Mabye I can help you out later.
    Rabbit: And what could you help me with? Fine man, here.
    You receive the carrots. # give: carrots
    Player: I'll come back in a while, let me know if you think of anything.
    ~ NuetralTermsRabbit = true
    ~ Carrots = true
    -> DONE
* [Threaten]
    Player: Trust me dude, if you don't give me the carrots, I will seriously mess up your day.
    Rabbit: Damn okay! Just stay away from me!
    You receive the carrots. # give: carrots
    ~ BadTermsRabbit = true
    ~ Carrots = true
    -> DONE

=== rabbit_after ===
// TODO: placeholder
{ GoodTermsRabbit:
    Rabbit: Did you talk to him? Tell me what he says!
- else:
    Rabbit: What do you want now?
}
-> DONE


// ============================================================
// QUEST BOARD
// ============================================================
// Design notes (kept as a comment so they don't show up in dialogue):
// Random quests, a few at a time, regenerating when only 2 remain, possibly
// time-limited. Mostly financial incentive. Needs an in-game clock. Quests TBD.
=== quest_board ===
// TODO
-> DONE
