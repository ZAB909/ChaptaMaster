
if (obj_controller.zoomed=1){obj_controller.x=self.x;obj_controller.y=self.y;}
obj_controller.popup=3;// 3: star system
obj_controller.sel_system_x=x;
obj_controller.sel_system_y=y;

selected=1;

var xx,yy;xx=x;yy=y;

obj_controller.selected=self.id;
obj_controller.sel_owner=self.owner;
obj_controller.cooldown=8;
obj_controller.selecting_planet=0;

if (obj_controller.zoomed=1){obj_controller.zoomed=0;__view_set( e__VW.Visible, 0, true );__view_set( e__VW.Visible, 1, false );obj_cursor.image_xscale=1;obj_cursor.image_yscale=1;}

// Pass variables to obj_controller.temp[t]=""; here
with(obj_star_select){instance_destroy();}
instance_create(x,y,obj_star_select);
obj_star_select.owner=self.owner;
obj_star_select.target=self.id;



