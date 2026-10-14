function varargout = water_training(varargin)
% WATER_TRAINING M-file for water_training.fig
%      WATER_TRAINING, by itself, creates a new WATER_TRAINING or raises the existing
%      singleton*.
%
%      H = WATER_TRAINING returns the handle to a new WATER_TRAINING or the handle to
%      the existing singleton*.
%
%      WATER_TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATER_TRAINING.M with the given input arguments.
%
%      WATER_TRAINING('Property','Value',...) creates a new WATER_TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before water_training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to water_training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help water_training

% Last Modified by GUIDE v2.5 20-Feb-2019 12:32:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @water_training_OpeningFcn, ...
                   'gui_OutputFcn',  @water_training_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before water_training is made visible.
function water_training_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to water_training (see VARARGIN)

% Choose default command line output for water_training
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes water_training wait for user response (see UIRESUME)
% uiwait(handles.tag_water_training);
clear comPort;
global out_s;
data_path = 'C:\Users\Chen Lab\Documents\MATLAB\Water Training\';
comPort = 'COM5';
[s,flag] = setupSerial(comPort);
out_s = s;

% --- Outputs from this function are returned to the command line.
function varargout = water_training_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global ar;
global out_s;
global Mouse_Name;
global Start_Clock_Time;
global Stop_Clock_Time;
global fileID;
global data_path;
global Delay;
global Sound;
global minoffDuration;
global maxoffDuration;
global CD_offDuration;
global offDuration;
global openDuration;
global Catch_Trials_percentage;
global Total_Trials;

set(handles.Stop, 'userdata', 0);
set(handles.Start,'visible','off');
set(handles.Stop,'visible','on');
set(handles.edit_Mouse_Name,'enable','off');

%Clock Time Start
Start_Clock_Time = fix(clock);
filestr = strcat(data_path, Mouse_Name ,'_',datestr(Start_Clock_Time,'yymmdd'),'_Water_Training_',datestr(Start_Clock_Time,'HH_MM_SS'),'.txt');%String to save matlab file to .txt
% Open water_training.txt to write data of experiment
%filestr = strcat('Water_Training_',datestr(now,'mmmm_dd_yyyy_HH_MM_SS'),'.txt');%String to save matlab file to .txt
fileID = fopen(filestr,'a+');
%filename = strcat('Water_Training_',datestr(now,'mmmm_dd_yyyy_HH_MM_SS'),'.mat');%String to save matlab file to .mat
filename = strcat(data_path, Mouse_Name ,'_',datestr(Start_Clock_Time,'yymmdd'), '_Water_Training_',datestr(Start_Clock_Time,'HH_MM_SS'),'.mat');%String to save matlab file to .mat

% Value in seconds to wait in between solenoid closed (OFF)
minoffDuration = str2double(get(handles.edit_minoffDuration,'String'));
maxoffDuration = str2double(get(handles.edit_maxoffDuration,'String'));

% Value in seconds to increase offDuration
CD_offDuration = str2double(get(handles.CD_offDuration,'String'));

%Value in sesonds to wait in between solenoid open (ON)
openDuration = str2double(get(handles.edit_openDuration,'String'));

%Value in sesonds delay between the time of the tone and the water valve
Delay = str2double(get(handles.edit_Delay,'String'));

%Value in sesonds of the tone
Sound = str2double(get(handles.edit_Sound,'String'));

%Value in % of trails called "catch" trails
Catch_Trials_percentage = str2double(get(handles.edit_Catch_Trials,'String'));

%Total number of Trials
Total_Trials = str2double(get(handles.edit_Total_Number_of_Trails,'String'));
Catch_Trials = round((Total_Trials * Catch_Trials_percentage)/100);

% Clock Time ON
Clock_Time_ON = fix(clock);

% Display data
disp(' ');
disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
disp(['Start Water Training!', ' Clock Time ON: ', num2str(datestr(Clock_Time_ON))]);
disp(['Min offDuration = ', num2str(minoffDuration), ' sec;']);
disp(['Max offDuration = ', num2str(maxoffDuration), ' sec;']);
disp(['offDuration = ', num2str(offDuration), ' sec;']);
disp(['openDuration = ', num2str(openDuration), ' sec;']);
disp(['Delay = ', num2str(Delay), ' sec;']);
disp(['Catch Trals Precentage = ', num2str(Catch_Trials_percentage), ' %;']);
disp(['Total Number of Trals = ', num2str(Total_Trials), ' ;']);
disp(['Number of Catch Trals = ', num2str(Catch_Trials), ' ;']);

% Write data to file water_training.txt
fprintf(fileID,'%s\r\n', ['Start Water Training!', ' Clock Time ON: ', num2str(datestr(Clock_Time_ON))]);
fprintf(fileID,'%s\r\n', ' ');
fprintf(fileID,'%s\r\n', ['minoffDuration = ', num2str(minoffDuration), ' sec;']);
fprintf(fileID,'%s\r\n', ['maxoffDuration = ', num2str(maxoffDuration), ' sec;']);
fprintf(fileID,'%s\r\n', ['openDuration = ', num2str(offDuration), ' sec;']);
fprintf(fileID,'%s\r\n', ['editoffDuration = ', num2str(openDuration), ' sec;']);
fprintf(fileID,'%s\r\n', ['Delay = ', num2str(Delay), ' sec;']);
fprintf(fileID,'%s\r\n', ['Catch Trals Precentage = ', num2str(Catch_Trials_percentage), ' %;']);
fprintf(fileID,'%s\r\n', ['Total Number of Trals = ', num2str(Total_Trials), ' sec;']);
fprintf(fileID,'%s\r\n', ['Number of Catch Trals = ', num2str(Catch_Trials), ' sec;']);

%offDuration[minoffDuration maxoffDuration](sec)
ITI(1,1) = minoffDuration;
k = 1;
while ITI(1,k) < maxoffDuration
       ITI(1,(k+1)) =  (minoffDuration + (k*CD_offDuration));
       k = k + 1 ;
end

disp(['ITI = [', num2str(ITI), '] sec;']);
disp(' ');

i = 1;% counter of Total Events
j = 1; % counter of "catch" trials
CT = []; % CT - "catch" trials
if Catch_Trials > 0
    CT = sort(randi([1 Total_Trials],1,Catch_Trials)); % randomly dispersed "catch" trials
    r_CT(j) = CT(1,j); % r_CT - random "catch" trials
    for k = 1:(length(CT)-1)
        if CT(k) == CT(k + 1)
            CT(k+1) = CT(k+1) + 1;
        end
    end
    disp(['"Catch" Trials = [', num2str(CT), '] ;']);
    disp(' ');
end

WT_data = zeros(0,3);

fprintf(fileID,'%s\r\n', ['ITI = [', num2str(ITI), '] sec;']);
fprintf(fileID,'%s\r\n', ['Total_Trials = ', num2str(Total_Trials), ';']);
fprintf(fileID,'%s\r\n', ['CT = [', num2str(CT), '] ;']);
fprintf(fileID,'%s\r\n', ' ');

while i <= Total_Trials
    
    % Value in seconds to wait in between solenoid closed (OFF)
    minoffDuration = str2double(get(handles.edit_minoffDuration,'String'));
    maxoffDuration = str2double(get(handles.edit_maxoffDuration,'String'));

    % Value in seconds to increase offDuration
    CD_offDuration = str2double(get(handles.CD_offDuration,'String'));

    %Value in sesonds to wait in between solenoid open (ON)
    openDuration = str2double(get(handles.edit_openDuration,'String'));
    
    %Value in sesonds delay between the time of the tone and the water valve
    Delay = str2double(get(handles.edit_Delay,'String'));

    %Value in sesonds of the tone
    Sound = str2double(get(handles.edit_Sound,'String'));

    %Value in % of trails called "catch" trails
    Catch_Trials_percentage = str2double(get(handles.edit_Catch_Trials,'String'));

    %Total number of Trials
    Total_Trials = str2double(get(handles.edit_Total_Number_of_Trails,'String'));
    Catch_Trials = round((Total_Trials * Catch_Trials_percentage)/100);

    %offDuration[minoffDuration maxoffDuration](sec)
    ITI(1,1) = minoffDuration;
    k = 1;
    while ITI(1,k) < maxoffDuration
       ITI(1,(k+1)) =  (minoffDuration + (k*CD_offDuration));
       k = k + 1 ;
    end
    
    offDuration = randsample(ITI,1);% internal trial interval 60-120 sec
    
    if Catch_Trials == 0 % if no "catch" trials    
        
        i_ITI = ['EVENT NUMBER = ', num2str(i), '; ITI = ', num2str(offDuration),'sec'];
        disp (i_ITI);

        WT_data(i,1) = i;
        WT_data(i,2) = offDuration; % ITI
        WT_data(i,3) = openDuration; % time that water reward given
        
        pause(offDuration);% internal trial interval 60-120 sec
        
        out_mode = 'A';
        % Serial send read request to Arduino - Start Playing Music
        fprintf(out_s, out_mode);  
        
        pause(Sound); % time that sound ON
        
        out_mode = 'S';
        % Serial send read request to Arduino - Stop Playing Music
        fprintf(out_s, out_mode); 
        
        pause(Delay);% delay after sound
       
        % Serial send read request to Arduino - ON Water Reward
        out_mode = 'H';
        fprintf(out_s, out_mode);
        
        pause(openDuration);% Water Reward ON
        
        % Serial send read request to Arduino - OFF Water Reward
        out_mode = 'L';
        fprintf(out_s, out_mode); 
        
        c = fix(clock);
        Clock = ['Clock Time: ', num2str(datestr(c))];
        disp(Clock);
        disp(' ');
        
        c_ITI = ['EVENT NUMBER = ', num2str(i), '; ITI = ', num2str(offDuration),'sec; ', 'Clock Time: ', num2str(datestr(c))];
        fprintf(fileID, '%s\r\n', c_ITI);
        save(filename,'Start_Clock_Time', 'minoffDuration', 'maxoffDuration','CD_offDuration', 'openDuration','Delay','Catch_Trials_percentage','Total_Trials','Catch_Trials','ITI','CT','WT_data');
      
    else % with "catch trials"   
        if r_CT(j) == i % "catch" trials
            if j <= length(CT)
                i_ITI = ['"Catch" Trials = ', num2str(j), '; EVENT NUMBER = ', num2str(i), '; ITI = ', num2str(offDuration),'sec'];
                disp (i_ITI);

                pause(offDuration);% internal trial interval 60-120 sec

                WT_data(i,1) = i;
                WT_data(i,2) = offDuration;
                WT_data(i,3) = 0; % "catch" trials 

                out_mode = 'A';
                % Serial send read request to Arduino - Start Playing Music
                fprintf(out_s, out_mode);  

                pause(Sound);

                out_mode = 'S';
                % Serial send read request to Arduino - Stop Playing Music
                fprintf(out_s, out_mode);
                
                pause(Delay);

                c = fix(clock);
                Clock = ['Clock Time: ', num2str(datestr(c))];
                disp(Clock);
                disp(' ');

                c_ITI = ['"Catch" Trials = ', num2str(j), '; EVENT NUMBER = ', num2str(i), '; ITI = ', num2str(offDuration),'sec; ', 'Clock Time: ', num2str(datestr(c))];
                fprintf(fileID, '%s\r\n', c_ITI);

                save(filename,'Start_Clock_Time', 'minoffDuration', 'maxoffDuration','CD_offDuration', 'openDuration','Delay','Catch_Trials_percentage','Total_Trials','Catch_Trials','ITI','CT','WT_data');                
                if j < length(CT)
                    j = j + 1; % counter of "catch" trial 
                    r_CT(j) = CT(1,j); % r_CT - random "catch" trials   
                end
            end
        elseif r_CT(j) ~= i  % not "catch" trials  
            i_ITI = ['EVENT NUMBER = ', num2str(i), '; ITI = ', num2str(offDuration),'sec'];
            disp (i_ITI);

            pause(offDuration);% internal trial interval 60-120 sec

            WT_data(i,1) = i;
            WT_data(i,2) = offDuration;
            WT_data(i,3) = openDuration;

            out_mode = 'A';
            % Serial send read request to Arduino - Start Playing Music
            fprintf(out_s, out_mode);
            
            pause(Sound);
            
            out_mode = 'S';
            % Serial send read request to Arduino - Stop Playing Music
            fprintf(out_s, out_mode); 
            
            pause(Delay);

            % Serial send read request to Arduino - ON Water Reward
            out_mode = 'H';
            fprintf(out_s, out_mode);

            pause(openDuration);

            % Serial send read request to Arduino - OFF Water Reward
            out_mode = 'L';
            fprintf(out_s, out_mode); 

            c = fix(clock);
            Clock = ['Clock Time: ', num2str(datestr(c))];
            disp(Clock);
            disp(' ');

            c_ITI = ['EVENT NUMBER = ', num2str(i), '; ITI = ', num2str(offDuration),'sec; ', 'Clock Time: ', num2str(datestr(c))];
            fprintf(fileID, '%s\r\n', c_ITI);
            save(filename,'Start_Clock_Time', 'minoffDuration', 'maxoffDuration','CD_offDuration', 'openDuration','Delay','Catch_Trials_percentage','Total_Trials','Catch_Trials','ITI','CT','WT_data');
        end
    end
    
    if  get(handles.Stop, 'userdata') % stop condition
        break;
    end
    
    i = i + 1;
end

Clock_Time_OFF = fix(clock);

%Clock Time Stop
Stop_Clock_Time = fix(clock);

disp (['Water Training End!', ' Clock Time OFF: ', num2str(datestr(Clock_Time_OFF))] );
disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
disp(' ');

fprintf(fileID,'%s\r\n', ' ');
fprintf(fileID,'%s\r\n', ['Water Training End!', ' Clock Time OFF: ', num2str(datestr(c))]);
fprintf(fileID,'%s\r\n', ' ');

fclose(fileID);% close water_training.txt

save(filename,'Start_Clock_Time', 'minoffDuration', 'maxoffDuration','CD_offDuration', 'openDuration','Delay','Catch_Trials_percentage','Total_Trials','Catch_Trials','ITI','CT','WT_data');

set(handles.Start,'visible','on');
set(handles.Stop,'visible','off');
set(handles.edit_Mouse_Name,'enable','on');

function edit_minoffDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minoffDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minoffDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_minoffDuration as a double

%offDuration = str2double(get(handles.edit_minoffDuration,'String'));

global minoffDuration;

% Value in seconds to wait in between solenoid closed (OFF)
minoffDuration = str2double(get(handles.edit_minoffDuration,'String'));
    
% --- Executes during object creation, after setting all properties.
function edit_minoffDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minoffDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CD_offDuration_Callback(hObject, eventdata, handles)
% hObject    handle to CD_offDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CD_offDuration as text
%        str2double(get(hObject,'String')) returns contents of CD_offDuration as a double
global CD_offDuration;

% Value in seconds to increase offDuration
CD_offDuration = str2double(get(handles.CD_offDuration,'String'));

% --- Executes during object creation, after setting all properties.
function CD_offDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CD_offDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_openDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_openDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_openDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_openDuration as a double
global openDuration;

%Value in sesonds to wait in between solenoid open (ON)
openDuration = str2double(get(handles.edit_openDuration,'String'));

% --- Executes during object creation, after setting all properties.
function edit_openDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_openDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_numClicks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numClicks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function Untitled_water_training_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_water_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function edit_maxoffDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxoffDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxoffDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_maxoffDuration as a double
global maxoffDuration;

% Value in seconds to wait in between solenoid closed (OFF)
maxoffDuration = str2double(get(handles.edit_maxoffDuration,'String'));

% --- Executes during object creation, after setting all properties.
function edit_maxoffDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxoffDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closeSerial

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Stop,'userdata',1)

% --- Executes on button press in togglebutton_ON_OFF.
function togglebutton_ON_OFF_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_ON_OFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_ON_OFF
global out_s;
if get(hObject,'Value') 
    disp(' ');
    disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& ');
    disp(' WATER ON ');
    disp(' ');
    out_mode = 'H';
    fprintf(out_s, out_mode);
    set(hObject,'BackgroundColor', [0 1 0]);
    set(hObject,'String','ON');
    %out_mode = 'A';
    % Serial send read request to Arduino - Start Playing Music
    %fprintf(out_s, out_mode);    
else
    out_mode = 'L';
    fprintf(out_s, out_mode);
    set(hObject,'BackgroundColor', [1 0 0]);
    set(hObject,'String','OFF');
    disp(' ');
    disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& ');
    disp(' WATER OFF ');
    disp(' ');
    %out_mode = 'S';
    % Serial send read request to Arduino - Stop Playing Music
    %fprintf(out_s, out_mode);
end

function edit_Mouse_Name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Mouse_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Mouse_Name as text
%        str2double(get(hObject,'String')) returns contents of edit_Mouse_Name as a double
global Mouse_Name;
%Name of Mouse
Mouse_Name = get(handles.edit_Mouse_Name, 'String');

% --- Executes during object creation, after setting all properties.
function edit_Mouse_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Mouse_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Delay as text
%        str2double(get(hObject,'String')) returns contents of edit_Delay as a double

global Delay;

%Value in sesonds delay between the time of the tone and the water valve
Delay = str2double(get(handles.edit_Delay,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Catch_Trials_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Catch_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Catch_Trials as text
%        str2double(get(hObject,'String')) returns contents of edit_Catch_Trials as a double

global Catch_Trials_percentage;

%Value in % of trails called "catch" trails
Catch_Trials_percentage = str2double(get(handles.edit_Catch_Trials,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Catch_Trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Catch_Trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Total_Number_of_Trails_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Total_Number_of_Trails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Total_Number_of_Trails as text
%        str2double(get(hObject,'String')) returns contents of edit_Total_Number_of_Trails as a double
global Total_Trials;

%Total number of Trials
Total_Trials = str2double(get(handles.edit_Total_Number_of_Trails,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Total_Number_of_Trails_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Total_Number_of_Trails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Sound_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Sound as text
%        str2double(get(hObject,'String')) returns contents of edit_Sound as a double

global Sound;

%Value in sesonds of the tone
Sound = str2double(get(handles.edit_Sound,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Sound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
