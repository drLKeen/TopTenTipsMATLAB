function laurasFeatureList
%% Select the list of features you'd like to use
prj = currentProject;
featureFile = fullfile(prj.RootFolder,"Demos","features60.txt");
[f,p] = uigetfile(featureFile,"Select your feature list");

if f==0
    return
end

Features = readmatrix([p f],"NumHeaderLines",0,"OutputType","string","Delimiter","\t");

%% Set up feature table
Shown = false(size(Features));
t = table(Shown,Features);
t.Properties.VariableNames{1} = 'Shown?';

%% Create app
f = uifigure;

%% Table
ut = uitable('Parent',f);
ut.Data = t;
ut.FontSize = 16;
ut.FontWeight = 'bold';
ut.Position = [1 1 f.Position(3)-120 f.Position(4)];
ut.ColumnWidth = {100,'auto'};
ut.ColumnEditable = [true true];
ut.CellEditCallback = @updateFeatureCount;
ut.CellSelectionCallback = @UITableCellSelection;


cm = uicontextmenu(f);
ut.ContextMenu = cm;
m = uimenu(cm,'Text','Add a feature');
m.Accelerator = 'F';
m.MenuSelectedFcn = @addAFeature;

%% Number of Features Label
nfl = uilabel('Parent',f);
nfl.Position = [f.Position(3)-110 f.Position(4)-50 100 50];
nfl.Text = string(sum(Shown));
nfl.FontSize = 24;
nfl.FontWeight = 'bold';
nfl.HorizontalAlignment = 'center';
nfl.VerticalAlignment = 'center';

%% Feature Label
fl = uilabel('Parent',f);
fl.Position = nfl.Position;
fl.Position(2) = fl.Position(2) - 40;
fl.Position(4) = 40;
fl.Text = 'Features';
fl.FontSize = 16;
fl.FontWeight = 'bold';
fl.HorizontalAlignment = 'center';
fl.VerticalAlignment = 'center';

% ut.UserData = nfl; % Hold onto # features label

%% Callback - keep track of current uitable selection
    function UITableCellSelection(obj, event)
        ut.UserData = event.Indices;
    end

%% Callback - add a feature row
    function addAFeature(cm,event)
        if isempty(ut.UserData)
            uialert(f,"Select a row in the table to add a feature after it.","Add a feature")
            return
        end
        newrow = ut.UserData(1)+1;
        d = ut.Data;
        
        % Shift down
        d(newrow+1:end+1,:) = d(newrow:end,:);
        
        % Make new row blank
        d{newrow,1} = false;
        d{newrow,2} = "";
        
        % Put back in table
        ut.Data = d;
    end

%% Callback - update number of features label
    function updateFeatureCount(ut,event)
        nfl.Text = string(sum(ut.Data{:,1}));
    end
end

