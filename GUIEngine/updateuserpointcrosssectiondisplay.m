function updateuserpointcrosssectiondisplay(app)

%%  Displays the user's point as dictated by the app.PointValEditFields (every unit in mm)

if ~isempty(app.planes)
    switch app.planes{app.selectedplaneidx}{2}
        case 'xy'
            if (isfield(app.niftidisplaydata, 'userpoint'))
                delete(app.niftidisplaydata.userpoint);
            end
            app.niftidisplaydata.userpoint = plot(app.CrossSectionDisplay, app.PointXValEditField.Value, app.PointYValEditField.Value, Color = 'green', Marker= '*', MarkerSize=10);
        case 'xz'
            if (isfield(app.niftidisplaydata, 'userpoint'))
                delete(app.niftidisplaydata.userpoint);
            end
            app.niftidisplaydata.userpoint = plot(app.CrossSectionDisplay, app.PointXValEditField.Value, app.PointZValEditField.Value, Color = 'green', Marker= '*', MarkerSize=10);
        case 'yz'
            if (isfield(app.niftidisplaydata, 'userpoint'))
                delete(app.niftidisplaydata.userpoint);
            end
            app.niftidisplaydata.userpoint = plot(app.CrossSectionDisplay, app.PointYValEditField.Value, app.PointZValEditField.Value, Color = 'green', Marker= '*', MarkerSize=10);
    end
end

end