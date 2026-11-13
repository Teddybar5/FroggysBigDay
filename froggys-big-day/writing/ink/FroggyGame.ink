Froggy quests

VAR Contract = false
VAR GoodTermsRabbit = false
VAR NuetralTermsRabbit = false
VAR BadTermsRabbit = false
VAR Carrots = false

->Intro_Quest

==Intro_Quest



The player wakes up in a cartoonish world. 

Piggy: Hey there pal! It seems like you dozed off there for a second. Do you know where you are?

Player: 

-(intro)
*Of course I do!
    Piggy: That's great! 
*I'm not sure
    Piggy: Oh that's okay! You'll learn soon enough!
*I'm on a floating rock drifting through space
    Piggy: I don't know what that means!
-

Piggy: Do you mind helping me get something? I left my sack of gems behind Grandpa Piggy's barn. It's the red farmhouse over to the southeast.

Player: 
*Oh course!
(only option is to accept)

Piggy: Well that's darn great! Get it for me and I can get you a reward!

TASK: Recover Piggy's Wallet from the Barn
REWARD: 100 currency

The player simply collects the item by grabbing/walking over it and returns to the Piggy. The waypoint/arrow only points to the location and the player must find it from there. 
Grandpa Piggy is an interactable npc. 

[First interaction and during the mission]
Grandpa Piggy: Well hey there! You're a hale and hearty lookin' Frog!

Player: 

-(grandpa)
*I'm looking for a sack of gems, have you seen it? (if the gems haven't been found)
    Grandpa Piggy: Oh, I think I saw them by the well! Or mabye the back porch? Either or.
    ->grandpa
*I came by to get something (if the gems have been found)
    Grandpa Piggy: Okay! Did you find it? 
    
    Player: Yes.
    
    Grandpa Piggy: Well that's good! 
    ->grandpa
*How do you know Piggy? 
    Grandpa Piggy: They're my grandkid! Always were a bit forgetful though. 
->grandpa

*{grandpa>2}I have to go
    Grandpa Piggy: Well I hope to see you again!
    
-

Grandpa piggy can give quests later on

[returning to Piggy]
Piggy: Thank you! 
->DONE

==GrandpaPiggyStart
(if the player talked to them during the intro quest)

Grandpa Piggy: Hey there again! You mind helping me out with something? 

(if the player did not talk to them during the intro quest)

Grandpa Piggy: Hi there! You're a hale and hearty lookin' fellow!

Player: 
*You're Piggy's Grandpa right? 
Grandpa Piggy: Sure am! Since you know Piggy so well, you mind helping me?

(Default dialogue if the player returns after declining the quest)

Grandpa Piggy: Howdy! You ready to help an old man out?

[quest dialogue]

Player: 
*Yeah, sure.
->GrandpaPiggyFirst
*I can't right now
    Grandpa Piggy: Well that's a shame!
-
->DONE

==GrandpaPiggyFirst

Grandpa Piggy: That's great. Recently there's been some problems keeping my carrots intact. The dang Rabbit that lives at the [insert location] is stealing them I think. I need you to go and talk to him! I don't want no trouble and I'm too old myself to make the trek. 
-(rab)
*(window)What makes you think he's stealing them? 
Grandpa Piggy: I see his damn sillouette out my window at night, it sure seems obvious. 
->rab
*What do you want me to tell him? 
Grandpa Piggy: Tell him to stop for goodness sake!
->rab
*{rab==3}Okay, sure thing

Player: I'll do my best. 

Grandpa Piggy: Thank you kind sir!
-

The player must travel to the place of the Rabbit. 

Rabbit: Greetings, Frog. What brings your business here? 

-(convo)
*The Elder Pig said you've been stealing his Carrots. Care to explain?
Rabbit: I've done no such thing! Crazy old man only believs in Stereotypes. 

Player: Well, he didn't make the accusation out of nowhere. 

Rabbit: What do you mean?

->convo

*I think you know. 
Rabbit: I really don't. 
->convo

*{convo>1}Tell my why you've been outside Grandpa Piggy's window at night. 
Rabbit: Whoah now! How did he see me? 

Player: Your sillouette is pretty obvious. 

Rabbit: Is it? What makes you the judge?

Player:
*Listen, I'm only going off of hearsay, but I'd like to know more about what is going on. 

Rabbit: You know, I really haven't stolen anything! He signed a contract with me a few months ago to sell me some carrots in return for fixing his wagon. As soon as I finished, he acted like we never signed anything!

    **Believe Rabbit
    Player: I believe you, the problem is that I can't verify that. Where is the contract?
    Rabbit: I don't know! I think he kept it. 
    
    Player: Okay, I'll ask him about it. Take care. 
    
    Rabbit: Tell me what he says!
    
    ~GoodTermsRabbit = true
    ~Contract = true
    
    **Don't believe Rabbit
    Player: Listen, I just can't get behind that. Even if you are telling the truth, I would rather he just get his carrots back and you guys ignore eachother. 
    
    Rabbit: Fine, but just know I'm not doing shit for you. 
    
    [Player recieves the carrots to return]
    
    ~BadTermsRabbit = true
    ~Carrots = true
    ~Contract = true
    
*I know you stole his carrots! Give them over!

    Rabbit: What?! I didn't steal shit!
    
    **Convince
    Player: I have a job to do. I know you took them, hand them over and I can go on my way. Mabye I can help you out later. 
    
    Rabbit: And what could you help me with? Fine man, here. 
    
    [Player recieves the carrots to return]
    
    Player: I'll come back in a while, let me know if you think of anything. 
    
    ~NuetralTermsRabbit = true
    ~Carrots = true
    
    **Threaten
    Player: Trust me dude, if you don't give me the carrots, I will seriously mess up your day. 
    
    Rabbit: Damn okay! Just stay away from me!
    
    [Player recieves the carrots to return]
    
    ~BadTermsRabbit = true
    ~Carrots = true

-

The player can then return to the pig. When interacting, the following dialogue can play. 

Grandpa Pig: Howdy! Did you get my carrots? 

*{Carrots == true}Yes Sir! Here you go. 
    ~Carrots = false
    Grandpa Pig: Why thank you Frog! Tell me, did he give you a hard time? 
        
        **{BadTermsRabbit}I had to convince him a bit. He's not exactly happy. 
        Grandpa Pig: Oh well, hopefully I won't see him again over here. It really is scary seeing that guy outside my window at night. 
        **{Contract && BadTermsRabbit}He definitely wasn't happy about giving them over. He mentioned something about a contract also? 
        Grandpa Pig: HA! Thank guy can't read. He thinks all he had to do was fix my wagon. It said at the bottom clear as day that 
        **{Contract}
        **{NuetralTermsRabbit}I promised to help him out he gave them to me
        
        
*{Contract == true}Mr. Rabbit told me about your guys' contract
*Not yet. //Default if the player interacts at any point before before collecting, or wishes to do something else before handing them over. 
    Grandpa Pig: Well you better get a move on!

-

->DONE

==Quest_board

This is where the player can find random quests. Potentially it can be in the form of advertisements and such in the town square to stay in character. These quests are essentially only providing finantial incentive, as story quests make more sense to come from NPCs personally. There are a few randomly generated quests available at any given time, and when the player gets down to only 2 remaining they could regenerate, potentially once a day. The quests could be time bound as well, having a timer before disapearing regardless. This could allow for quests being ranked in such a way that the more valuable quests are only available for short periods of time, whereas others may be more lenient. This would also require that there is some type of ingame clock, although it can be sped up dramatically. 

Quests themselves are TBI

    -> END
