function processingPlanesDD(app)

app.PlaneSelectionDropDown.Items = app.PlanesDropDown.Items;

app.PlaneSelectionDropDown.ItemsData = app.PlanesDropDown.ItemsData;

app.PlaneSelectionDropDown.Value = app.PlanesDropDown.Value;

app.processingPlaneidx = app.PlanesDropDown.Value;

end