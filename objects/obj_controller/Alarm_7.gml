

debugl("=========Player Defeated; Exited to Defeat Screen");

audio_stop_sound(snd_royal);
audio_play_sound(snd_defeat,0,true);
audio_sound_gain(snd_defeat, 0, 0);

var nope;nope=0;if (master_volume=0) or (music_volume=0) then nope=1;
if (nope!=1){audio_sound_gain(snd_defeat,1*master_volume*music_volume,2000);}

if (obj_controller.marines+obj_controller.command<=50) and (global.defeat!=2) then global.defeat=0;

room_goto(Defeat);
global.icon=obj_ini.icon;
global.icon_name=obj_ini.icon_name;

