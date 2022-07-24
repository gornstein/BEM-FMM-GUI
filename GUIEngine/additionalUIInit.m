function additionalUIInit(app)
        % Create TestingTab
            app.TestingTab = uitab(app.WindowTabGroup);
            app.TestingTab.Title = 'Testing';
            app.TestingTab.BackgroundColor = [0.7608 0.8196 0.7608];

            app.TestingTest = uiaxes(app.TestingTab);
            title(app.TestingTest, 'Cross Section View')
            xlabel(app.TestingTest, 'X')
            ylabel(app.TestingTest, 'Y')
            zlabel(app.TestingTest, 'Z')
end