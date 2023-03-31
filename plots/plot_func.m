%% Function to visualize hexaroter trajectories in 3D

clc; clear; close all;

states = load("matfile.mat");

% Create matrix with RGB values for each color
blue = [0 0 1];
red = [1 0 0];
black = [0 0 0];
colorMatrix = ["blue"; "red"; "cyan"];

% Define a cell array of line types
lineTypes = {'o-', '+-', '.-'};

% Loop over trajectories
figure(1);
for jj = 1:numel(states.states)

    % Extract trajectory
    dynamics_trajectory = states.states{jj};
    
    % Define trajectory in xyz-plane
    xyz_trajectory = extract_xyz(dynamics_trajectory);

    % Specify linewidth
    lineWidth = 2;
    if jj == 3
        lineWidth = 2;
    end

    segmentColor = colorMatrix(jj,:);
    plot3(xyz_trajectory(1,:), xyz_trajectory(2,:), xyz_trajectory(3,:),...
        lineTypes{jj}, 'LineWidth', lineWidth, 'Color', segmentColor)
    hold on
    scatter3(xyz_trajectory(1,:), xyz_trajectory(2,:), xyz_trajectory(3,:),...
        300, segmentColor, 'filled', 'MarkerFaceAlpha', 0.5)
end

% Create patches
create_patchYZ(1)
create_patchYZ(-1)
create_patchXZ(-1)
create_patchXZ(1)
create_patchXY(-6)
start_goal()

% Labels
xlabel('x [m]','FontName','Times New Roman')
ylabel('y [m]','FontName','Times New Roman')
zlabel('z [m]','FontName','Times New Roman')
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])
grid on
hold off

% Legend
labels = {'\color{blue} Non-robust', ...
          '\color{red} Unitary consensus', ...
          '\color{cyan} Maximum consensus'};

legend(labels, 'Location', 'NorthWest', 'FontSize', 8, ...
    'TextColor', 'black'); % Set the color of the text to black

% Save figure (pdf)
print('trajectory.pdf', '-dpdf', '-r300');


%% Functions
function xyz = extract_xyz(dynamics_trajectory)

    x = dynamics_trajectory(1,:);
    y = dynamics_trajectory(2,:);
    z = - dynamics_trajectory(3,:);

    xyz = [x; y; z];
end

function create_patchYZ(loc)

    % Define the range of coordinates
    y_range = [-1, 1];
    z_range = [-6, 0];
    
    % Define the vertices of the patch
    vertices = [loc, y_range(1), z_range(2); % bottom left corner
                loc, y_range(2), z_range(2); % top left corner
                loc, y_range(2), z_range(1); % top right corner
                loc, y_range(1), z_range(1)]; % bottom right corner
    
    % Define the faces of the patch
    faces = [1, 2, 3, 4];
    
    % Create the patch object and plot it
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.2);

end

function create_patchXZ(loc)

    % Define the range of coordinates
    x_range = [-1, 1];
    z_range = [-6, 0];
    
    % Define the vertices of the patch
    vertices = [x_range(1), loc, z_range(2); % bottom left corner
                x_range(2), loc, z_range(2); % bottom right corner
                x_range(2), loc, z_range(1); % top right corner
                x_range(1), loc, z_range(1)]; % top left corner
    
    % Define the faces of the patch
    faces = [1, 2, 3, 4];
    
    % Create the patch object and plot it
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.2);

end

function create_patchXY(loc)

    % Define height for rectangular patch
    zHeight = loc;
    % Define vertices for rectangular patch
    
    x = [-1 -1 1 1];
    y = [-1 1 1 -1];
    z = [zHeight zHeight zHeight zHeight];
    
    % Define color for rectangular patch
    rectPatchColor = [0.5 0.5 0.5];
    
    % Plot rectangular patch using patch function
    patch(x, y, z, rectPatchColor, 'FaceColor', 'blue', 'FaceAlpha', 0.2);

end

function start_goal()
    % Define the coordinates of your circles
    start_coord = [0, 0, 0];
    goal_coord = [0.3, 0.3, -5];

    % Add the start circle
    scatter3(start_coord(1), start_coord(2), start_coord(3), 100, ...
        'g', 'filled', 'MarkerFaceAlpha', 0.75);
    text(start_coord(1), start_coord(2)-0.15, start_coord(3), 'start');

    % Add the goal circle
    scatter3(goal_coord(1), goal_coord(2), goal_coord(3), 100, ...
        'g', 'filled', 'MarkerFaceAlpha', 0.75);
    text(goal_coord(1), goal_coord(2), goal_coord(3)-0.7, 'goal');

end



