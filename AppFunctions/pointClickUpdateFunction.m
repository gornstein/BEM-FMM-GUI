function output_txt = pointClickUpdateFunction(~,event_obj)
  % ~            Currently not used (empty)
  % event_obj    Object containing event data structure
  % output_txt   Data cursor text
  pos = get(event_obj, 'Position');
  set(0,'userdata',pos);
  output_txt = {['x: ' num2str(pos(1))], ['y: ' num2str(pos(2))], ['z: ' num2str(pos(3))]};
end