var __b__;
__b__ = action_if_variable(name, "", 0);
if !__b__
{
{
draw_self();


draw_set_color(38144);
draw_set_font(fnt_info);
draw_set_halign(fa_center);

if (shields<=0){
if (obj_controller.zoomed=0){if (maxhp!=0) then draw_text(x,y-(sprite_height/2),string_hash_to_newline(string(floor((hp/maxhp)*100))+"%"));}
if (obj_controller.zoomed=1){if (maxhp!=0) then draw_text_transformed(x,y-sprite_height,string_hash_to_newline(string(floor((hp/maxhp)*100))+"%"),2,2,0);}
}

if (shields>0){
draw_set_color(c_blue);
if (obj_controller.zoomed=0){if (maxhp!=0) then draw_text(x,y-(sprite_height/2),string_hash_to_newline(string(floor((shields/maxshields)*100))+"%"));}
if (obj_controller.zoomed=1){if (maxhp!=0) then draw_text_transformed(x,y-sprite_height,string_hash_to_newline(string(floor((shields/maxshields)*100))+"%"),2,2,0);}
}


// draw_set_color(c_red);
// draw_line_width(0,0,x,y,3);


}
}
