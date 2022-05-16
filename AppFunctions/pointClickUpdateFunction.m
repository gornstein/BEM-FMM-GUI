function txt = pointClickUpdateFunction(~,event_obj)
%   ~           Currently not used (empty)
%   event_obj   Object containing event data structure
%   txt         Displayed text when clicking on the point
pos = get(event_obj, 'Position');
txt = '';
end