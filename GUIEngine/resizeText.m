function resizeText(app, scaleF)

app.UIFigure.Position(3)
app.h = findobj(app.UIFigure, '-property', 'FontSize');
app.hFontSize = cell2mat(get(app.h,'FontSize'));
position = app.UIFigure.Position;
            
widthF = position(3);
            
newFontSize = app.hFontSize * scaleF;
newFontSize = round(newFontSize);
set(app.h,{'FontSize'}, num2cell(newFontSize));

end