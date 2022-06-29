function updateuserpointcrosssectiondisplay(app)
%%  Displays the user's point as dictated by the app.PointValEditFields

if ~isempty(app.planes)
    switch app.planes{app.selectedplaneidx}{2}
        case 'xy'
            if (isfield(app.niftidisplaydata, 'userpoint'))
                delete(app.niftidisplaydata.userpoint);
            end
            app.niftidisplaydata.userpoint = plot(app.CrossSectionDisplay, app.PointXValEditField.Value * 1e1, app.PointYValEditField.Value * 1e1, Color = 'green', Marker= '*', MarkerSize=10);
        case 'xz'
            if (isfield(app.niftidisplaydata, 'userpoint'))
                delete(app.niftidisplaydata.userpoint);
            end
            app.niftidisplaydata.userpoint = plot(app.CrossSectionDisplay, app.PointXValEditField.Value * 1e1, app.PointZValEditField.Value * 1e1, Color = 'green', Marker= '*', MarkerSize=10);
        case 'yz'
            if (isfield(app.niftidisplaydata, 'userpoint'))
                delete(app.niftidisplaydata.userpoint);
            end
            app.niftidisplaydata.userpoint = plot(app.CrossSectionDisplay, app.PointYValEditField.Value * 1e1, app.PointZValEditField.Value * 1e1, Color = 'green', Marker= '*', MarkerSize=10);
    end
end

end