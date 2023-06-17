
if (fading=1) and (fade_alpha<1) then fade_alpha+=0.025;
if (fading=-1) and (fade_alpha>0) then fade_alpha-=0.025;
if (time_at<time_min) then time_at+=0.25;
// if (time_at>=time_max) and (stage!=10) then stage=10;
if (exit_fade>=0) and (exit_fade<30) then exit_fade+=1;

if (closing=true) and (fading=-1) and (fade_alpha<=0){
    if (obj_controller.fest_type="Great Feast"){
        if (obj_controller.fest_feature1=1) then obj_controller.fest_feasts+=1;
        if (obj_controller.fest_feature2=1) then obj_controller.fest_boozes+=1;
        if (obj_controller.fest_feature3=1) then obj_controller.fest_drugses+=1;
    }
    
    var ide;ide=0;
    repeat(700){ide+=1;
        if (attend_corrupted[ide]=0) and (attend_id[ide]>0){
            if (string_count("Chaos",obj_ini.artifact_tags[obj_controller.fest_display])>0){
                obj_ini.chaos[attend_co[ide],attend_id[ide]]+=choose(1,2,3,4);
            }
            if (string_count("Daem",obj_ini.artifact_tags[obj_controller.fest_display])>0){
                obj_ini.chaos[attend_co[ide],attend_id[ide]]+=choose(6,7,8,9);
            }
            attend_corrupted[ide]=1;
        }
    }
    
    obj_controller.fest_repeats-=1;
    if (obj_controller.fest_repeats<=0){
        obj_controller.fest_scheduled=0;
        
        var p1,p2,p3;
        p1=obj_controller.fest_type;p3="";
        p2=obj_controller.fest_planet;
        
        if (p2>0) then p3=string(obj_controller.fest_star)+" "+scr_roman(obj_controller.fest_wid);
        if (p2<=0) then p3=+" the vessel '"+string(obj_ini.ship[obj_controller.fest_sid])+"'";
        
        scr_alert("green","event",string(p1)+" on "+string(p3)+" ends.",0,0);
        scr_event_log("green",string(p1)+" on "+string(p3)+" ends.");
    }
    
    with(obj_popup){if (number!=0) then obj_turn_end.alarm[1]=10;instance_destroy();}
    obj_controller.cooldown=30;
    instance_destroy();
}

if (stage>=5) and (stage!=10){ticks+=1;
    if (ticks>=next_display){
        ticks=0;ticked=1;
    }
}

if (ticked=1){// Select a random marine and have them perform an action
    if (lines_acted=18) and (exit_fade<=-1) then exit_fade=0;

    if (lines_acted=18) and (part2!=""){
        if (part2="fish"){
            if (attendants<=30) then textt="Chapter Serfs ferry out several large, covered dishes, the scent of seafood filling the air.  Once they are set front and center the silver cloches are removed, revealing a banquet of exotic fish.  Raw rolls of meat with rice, pufferfish, and even a massive broadbill are contained within.";
            if (attendants>30) then textt="Chapter Serfs ferry out several large, covered dishes, the scent of seafood filling the air.  Once they are set front and center the silver cloches are removed, revealing a banquet of exotic fish.  Raw rolls of meat with rice, pufferfish, and several massive broadbill are contained within.";
        }
        if (part2="fruit"){
            textt="Chapter Serfs ferry out several large, covered bowls.  Without further adeiu the lids are removed, revealing a large bounty of exotic fruits from across the galaxy.  Ploin, pineapple, mangos, strawberries, the fruit ranges from commonplace to nearly disappeared treasures.";
        }
        scr_event_newlines(textt);
        lines_acted+=1;time_min+=10;ticks=-120;
        ticked=0;stage=6;textt="";exit;
    }
    if (lines_acted=36) and (part3!=""){
        if (part3="lobster"){
            textt="A small army of Chapter Serfs and servitors enter the room, carrying with them a truly massive silver plate.  Bore much like a palanquin, the massive dish is covered by an equally large and decorated cloche.  As the main course inches across the room it gathers quite the number of looks.  After struggling a bit the dish is set front and center in the room, the lid removed.  Contained within is a giant, boiled Deathcoleri from Zeriah II.  The once spikey carapace is now a healthily cooked red, the crustacean smelling absolutely delicious.";
        }
        scr_event_newlines(textt);
        lines_acted+=1;time_min+=10;ticks=-210;
        ticked=0;stage=7;textt="";exit;
    }

    
    var ide,good,dire,orig,dice1,dice2,dice3,dice4,txtt,rando,doso,activity;
    good=false;doso=false;activity="";
    dire=0;orig=0;rando=choose(1,2);
    dice1=floor(random(100))+1;
    dice2=floor(random(100))+1;
    dice3=floor(random(100))+1;
    
    repeat(20){
        if (good=false){
            good=true;ide=floor(random(attendants))+1;
            if (obj_ini.role[attend_co[ide],attend_id[ide]]="Chapter Master") then good=false;
            if (obj_ini.role[attend_co[ide],attend_id[ide]]="Master of Sanctity") then good=false;
            if (obj_ini.role[attend_co[ide],attend_id[ide]]="Master of the Apothecarion") then good=false;
            if (obj_ini.role[attend_co[ide],attend_id[ide]]="Forge Master") then good=false;
            if (obj_ini.role[attend_co[ide],attend_id[ide]]="Chief "+string(obj_ini.role[100,17])) then good=false;
        }
    }
    if (good=false) then good=true;
    
    
    // If this marine has already acted then look for a nearby marine that has yet to act
    if (attend_displayed[ide]>0){
        if (attend_displayed[ide]<=attendants/2) then dire=-1;
        if (attend_displayed[ide]>attendants/2) then dire=1;
        orig=ide;
    }
    
    // Cycle downward
    if (dire=-1){good=false;
        var resp;resp=ide;
        
        repeat(resp){
            if (good=false){ide-=1;
                if (attend_displayed[ide]=0) then good=true;
            }
        }
        
        if (good=false) then dire=1;
        if (good=true) then dire=0;
    }
    
    // Cycle upward
    if (dire=1){good=false;
        var resp;resp=attendants;
        
        repeat(resp){
            if (good=false){ide+=1;
                if (attend_displayed[ide]=0) then good=true;
            }
        }
        
    }
    
    if (dire!=0) and (good=false){ide=orig;good=true;}
    
    if (attend_confused[ide]>0){
        if (dice1<=70){
            if (obj_controller.fest_type="Great Feast"){
                doso=false;activity="confused";
            }
        }
        if (dice1>70) then doso=true;
    }
    if (attend_confused[ide]<=0) and (activity="") then doso=true;
    
    if (doso=true){
        dice1=floor(random(100))+1;
        dice2=floor(random(100))+1;
        dice3=floor(random(100))+1;
        dice4=floor(random(100))+1;
        
        if (obj_controller.fest_type="Great Feast"){// Get chances of random crap when in a Great Feast
            var mod1,mod2,mod3,rep1,rep2,rep3;
            mod1=0;mod2=0;mod3=0;
            
            rep1=1;// attend_feasted[ide]+1;
            rep2=attend_drunk[ide]+1;
            rep3=attend_high[ide]+1;
            
            mod2=obj_ini.chaos[attend_co[ide],attend_id[ide]]/5;
            mod3=obj_ini.chaos[attend_co[ide],attend_id[ide]]/10;
            
            activity="talk";
            
            // show_message("roll needed for eating: >="+string((((obj_controller.fest_feasts*30)-10)+mod1)/rep1)+", rolled:"+string(dice1));
            if (dice3<=min(75,(((obj_controller.fest_drugses*10)-10)+mod3)/rep3)) and (obj_controller.fest_feature3>0) then activity="drugs";
            if (dice2<=min(75,(((obj_controller.fest_boozes*20)-10)+mod2)/rep2)) and (obj_controller.fest_feature2>0) then activity="drink";
            if (dice1<=min(75,(((obj_controller.fest_feasts*30))+mod1)/rep1)) and (obj_controller.fest_feature1>0) then activity="eat";
            if ((global.chapter_name="Space Wolves") or (obj_ini.progenitor=3)) and (obj_controller.fest_feature2>0) and (activity!="drink"){
                rando=choose(1,1,2);if (rando=2) then activity="drink";
            }
            rando=choose(1,2,3,4,5,6,7,8,9,10);
            if (rando>=8) then activity="talk";
            
            if (obj_controller.fest_display>0) and (dice4<=15){
                activity="artifact";
            }
            
        }
    }
    
    if (activity="confused"){
        rando=choose(1,2,2,3);
        if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" is unsure of what to do.  He sits at the table silently, doing nothing.";
        if (rando=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" is confused.  He sits at the table and does nothing, wishing he were "+choose("killing xenos","praying","training","training","studying")+" instead.";
        
        // Special CONFUS for the various event types
        if (rando=3){
            if (obj_controller.fest_type="Great Feast") and (obj_controller.fest_feature1>0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" picks up silverwear to begin to feast, but then has second thoughts and puts them back down.";
            if (obj_controller.fest_type="Great Feast") and (obj_controller.fest_feature1<=0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" is unsure of what to do.  He sits at the table silently, doing nothing.";
        }
        
    }
    if (activity="eat"){
        var eater_type;eater_type=1;
        if (global.chapter_name="Space Wolves") or (obj_ini.progenitor=3) then eater_type=2;
        
        if (stage=5) and (eater_type=1){rando=choose(1,2,3);
            if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" digs into the food and begins to eat.";
            if (rando=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" begins to feast, eating the food slowly to enjoy the taste.";
            if (rando=3) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" grabs a portion of food for himself and begins to eat.";
        }
        if (stage=5) and (eater_type=2){rando=choose(1,2,3);
            if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" digs into the food and begins to eat.";
            if (rando=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" makes a show out of eating, consuming the food as loudly and dramaticaly as possible.";
            if (rando=3) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" begins to stuff their face full of food, hardly bothering to chew.";
        }
        if (stage=6){
            if (part2="fish"){rando=choose(1,2,3,3,3);
                if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" selects some of the sushi rolls and begins to pop them into his mouth.";
                if (rando=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" chooses a bit of each dish, chapter serfs setting up quite the variety of foods on his plate.";
                if (rando=3) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" grabs a portion of the broadbill and begins to eat it slowly, savoring the taste.";
            }
            if (part2="fruit"){rando=choose(1,2,3,3,3);
                if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" selects an assortment of fruit and begins to eat.";
                if (rando=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" finishes up the rest of his plate, and hails a serf to bring him some "+choose("pineapple","strawberries","grapes","apples","oranges","of each fruit")+".";
                if (rando=3) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" hails a chapter serf, and orders a variety of different fruits.  He then eats them slowly, enjoying the taste.";
            }
        }
        if (stage=7){
            if (part3="lobster"){
                rando=choose(1,2,2,3,3);
                if (eater_type=2) then rando=choose(1,2,2,3,3,4);
                if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" helps break open one of the massive legs of the Deathcoleri, then scoops out some of the meat within.";
                if (rando=2) and (eater_type=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" tears some of the tendrils free from the crustacean and begins to eat them.";
                if (rando=3) and (eater_type=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" rips some of the delectable meat free from the Deathcoleri's leg, and then eats it slowly, enjoying the treat.";
                if (rando=2) and (eater_type=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" begins to shovel Deathcoleri meat down his throat, boasting that he will eat more than anyone else.";
                if (rando=3) and (eater_type=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" rips tendrils free from the crustaceans face and begins to eat them, loudly.";
                if (rando=4) then text=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" wants the good parts.  He shoves his arm through the beast's shell and scoops out the innards, taking some for himself and sharing other bits.";
            }
        }
        
        attend_feasted[ide]+=1;
    }
    if (activity="drink"){
        var eater_type;eater_type=1;
        if (global.chapter_name="Space Wolves") or (obj_ini.progenitor=3) then eater_type=2;
        if (global.chapter_name="Blood Angels") or (obj_ini.progenitor=5) then eater_type=3;
        
        if (eater_type=1){
            if (attend_drunk[ide]<=0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" hails a serf and has "+choose("him","her")+" pour some Amasec.";
            if (attend_drunk[ide]>0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" sips at his Amasec, "+choose("enjoying the taste","judging the quality","savoring the treat")+".";
        }
        if (eater_type=2){
            // if (attend_drunk[ide]<=0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" hails a serf and has "+choose("him","her")+" bring him a tankard of Mjod.";
            // if (attend_drunk[ide]>0){
                rando=choose(1,2,3);
                if (rando=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" pounds down Mjod, the concoction already beginning to inebriate the astartes.";
                if (rando=2) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" boasts that he will outdrink anyone, and then pounds down his tankard.  Nearby battlebrothers laugh and begin to meet his challenge.";
                if (rando=3) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" begins to drink down Mjod, a large frothing glass of the substance in each hand.  He alternates between the two.";
            // }
        }
        if (eater_type=3){
            if (attend_drunk[ide]<=0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" hails a serf and has "+choose("him","her")+" pour him a glass of "+choose("red wine","Amasec","Dammassine")+".";
            if (attend_drunk[ide]>0) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" sips at his drink slowly, "+choose("enjoying the taste","judging the quality","analyzing the components")+".";
        }
        
        attend_drunk[ide]+=1;
    }
    if (activity="drugs"){
        attend_high[ide]+=1;
        obj_ini.chaos[attend_co[ide],attend_id[ide]]=min(100,obj_ini.chaos[attend_co[ide],attend_id[ide]]+10);
        if (attend_high[ide]<=1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" snorts up a line of powder through a straw.  Why not?";
        if (attend_high[ide]>1) then textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" snorts another line of powder.";
    }
    
    
    // show_message("activity:"+string(activity)+", text:"+string(textt));
    
    
    if (activity="talk"){
        textt=scr_event_gossip(ide);
    }
    
    if (activity="artifact"){
        var spesh,woa;spesh="";
        woa=string(obj_ini.artifact[obj_controller.fest_display]);
        
        if (string_count("GOAT",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("CHE",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("SPE",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("THI",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("TEN",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("JUM",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("PRE",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="nerves";
        if (string_count("DYI",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="offend";        
        if (spesh="") and (string_count("MNR",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="minor";
        
        
        textt=string(obj_ini.role[attend_co[ide],attend_id[ide]])+" "+string(obj_ini.name[attend_co[ide],attend_id[ide]])+" ";
        
        if (spesh=""){rando=choose(1,2,3,4,5);
            if (rando=1) then textt+="inspects the "+string(woa)+" on display, admiring the craftsmanship.";
            if (rando=2) then textt+="gazes at the "+string(woa)+" Artifact, wondering of its origins.";
            if (rando=3) then textt+="seems enamored with the "+string(woa)+" on display.";
            if (rando=4) then textt+="asks one of his nearby battle brothers what they know of the "+string(woa)+" on display.";
            if (rando=5) then textt+="stares at the "+string(woa)+", not quite sure what to make of it.";
        }
        if (spesh="nerves") or (spesh="offend"){rando=choose(1,2,3);
            if (rando=1) then textt+="is unsettled by the "+string(woa)+" Artifact.";
            if (rando=2) then textt+="stares at the "+string(woa)+", not quite sure what to make of it.";
            if (rando=3) then textt+="has no idea why anyone would choose to make the "+string(woa)+" on display.";
        }
        if (spesh="minor"){rando=choose(1,2,3);
            if (rando=1) then textt+="is unimpressed by the "+string(woa)+" Artifact.";
            if (rando=2) then textt+="has seen finer "+string(woa)+" than the one on display.";
            if (rando=3) then textt+="inspects the "+string(woa)+" on display.  He has seen more impressive ones before.";
        }
        
        
        if (attend_corrupted[ide]=0){
            if (string_count("Chaos",obj_ini.artifact_tags[obj_controller.fest_display])>0){
                obj_ini.chaos[attend_co[ide],attend_id[ide]]+=choose(1,2,3,4);
            }
            if (string_count("Daem",obj_ini.artifact_tags[obj_controller.fest_display])>0){
                obj_ini.chaos[attend_co[ide],attend_id[ide]]+=choose(6,7,8,9);
            }
            attend_corrupted[ide]=1;
        }
        
        
        /*
        
        
        
        if (t1="Weapon"){
            // gold, glowing, underslung bolter, underslung flamer
            t5=choose("GLD","GLO","UBL","UFL");
            // Runes, scope, adamantium, void
            t4=choose("RUN","SCO","ADA","VOI");
            if ((t2="Power Sword") or (t2="Power Axe") or (t2="Power Spear")) and (t4="SCO") then t4="CHB";// chainblade
            if ((t2="Power Fist") or (t2="Power Claw")) and (t4="SCO") then t4="DUB";// doubled up
            if (t2="Relic Blade") and (t4="SCO") then t4="UFL";// underslung flamer
        }
        if (t1="Armor"){
            // golden filigree, glowing optics, purity seals
            t5=choose("GLD","GLO","PUR");
            // articulated plates, spikes, runes, drake scales
            t4=choose("ART","SPI","RUN","DRA");
        }
        if (t1="Gear"){
            // supreme construction, adamantium, gold
            t4=choose("SUP","ADA","GOLD");// bur = ever burning
            if (t2="Rosarius") then t5=choose("GLD","GLO","BIG","BUR");
            if (t2="Bionics") then t5=choose("GLD","GLO","RUN","SOO");// Soothing appearance
            if (t2="Psychic Hood") then t5=choose("FIN","GLD","BUR","MASK");// fine cloth, gold, ever burning, mask
            if (t2="Jump Pack") then t5=choose("SPI","SKRE","WHI","SIL");// spikes, screaming, white flame, silent
            if (t2="Servo Arms") then t5=choose("GLD","TEN","GOR","SOO");// gold, tentacles, gorilla build, soothing appearance
        }
        if (t1="Device") and (t2!="Robot"){
            t4=choose("GOLD","CRU","GLO","ADA");// skulls, falling angel, thin, tentacle, mindfuck
            if (t2!="Statue") then t5=choose("SKU","FAL","THI","TEN","MIN");
            // goat, speechless, dying angel, jumping into magma, cheshire grunx
            if (t2="Statue") then t5=choose("GOAT","SPE","DYI","JUM","CHE");
            // Gold, glowing, preserved flesh, adamantium
            if (t2="Tome") then t4=choose("GOLD","GLO","PRE","ADA","SAL","BUR");
            if (t4="PRE") and (t3="") then t3=choose("","Chaos","Daemonic");
        }
        if (t1="Device") and (t2="Robot"){// human/robutt/shivarah
            t4=choose("HU","RO","SHI");
            t5=choose("ADA","JAD","BRO","RUNE");
        }
        
        
        if (string_count("Chaos",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="chaos";
        if (string_count("Daem",obj_ini.artifact_tags[obj_controller.fest_display])>0) then spesh="daemonic";
        
        */
    }
    
    
    if (textt!=""){
        scr_event_newlines(textt);textt="";
        attend_confused[ide]-=1;
        attend_displayed[ide]+=1;
        lines_acted+=1;time_min+=10;liness+=1;
        
        if (time_min>time_max) then time_min=time_max;
    }
    
    ticked=0;
}


if (liness>(attendants/2)){
    var i;i=-1;repeat(1501){i+=1;attend_displayed[i]=0;}
    liness=0;
}


/* */
/*  */
