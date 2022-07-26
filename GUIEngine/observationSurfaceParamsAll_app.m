function [planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity, numberOfPlanes] = observationSurfaceParamsAll_app(app)

i = length(app.planes);

% planeWidth(:) = zeros(1,i);
% planeAxis{:} = zeros(i,1);
% planeCenter(:) = zeros(i,1);
% planeHeight(:) = zeros(i,1); % Set to same as planeWidth
% planeNormal(:,:) = zeros(i,3);
% planeUp(:,:) = zeros(i,3);
% pointDensity(:) = zeros(i,1); % As it was in v0.4, might change to a non scaling method
numberOfPlanes = i;

for n = 1:i
    planeWidth(n) = app.planes{n}.width;
    planeHeight(n) = planeWidth(n);
    planeAxis{:} = app.planes{n}.direction;
    planeCenter(n,:) = app.planes{n}.position;
    pointDensity(n) = 300/planeWidth(n);
    
    if strcmp(planeAxis{1},'xy') == 1
        planeNormal(n,:) = [0 0 1];
        planeUp(n,:) = [0 1 0];

    elseif strcmp(planeAxis{1},'xz') == 1
        planeNormal(n,:) = [0 1 0];
        planeUp(n,:) = [0 0 1];

    elseif strcmp(planeAxis{1},'yz') == 1
        planeNormal(n,:) = [1 0 0];
        planeUp(n,:) = [0 0 1];
    
    end

end
end