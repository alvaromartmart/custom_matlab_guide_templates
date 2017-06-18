function varargout = advanced_empty_gui_template(varargin)
% ADVANCED_EMPTY_GUI_TEMPLATE MATLAB code for advanced_empty_gui_template.fig
%      ADVANCED_EMPTY_GUI_TEMPLATE, by itself, creates a new ADVANCED_EMPTY_GUI_TEMPLATE or raises the existing
%      singleton*.
%
%      H = ADVANCED_EMPTY_GUI_TEMPLATE returns the handle to a new ADVANCED_EMPTY_GUI_TEMPLATE or the handle to
%      the existing singleton*.
%
%      ADVANCED_EMPTY_GUI_TEMPLATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADVANCED_EMPTY_GUI_TEMPLATE.M with the given input arguments.
%
%      ADVANCED_EMPTY_GUI_TEMPLATE('Property','Value',...) creates a new ADVANCED_EMPTY_GUI_TEMPLATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before advanced_empty_gui_template_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to advanced_empty_gui_template_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
%   Alvaro Martinez, 2017 - alvaro.mart.mart+dev@gmail.com
% -------------------------------------------------------------------------

% Edit the above text to modify the response to help advanced_empty_gui_template

% Last Modified by GUIDE v2.5 11-May-2017 17:40:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @advanced_empty_gui_template_OpeningFcn, ...
                   'gui_OutputFcn',  @advanced_empty_gui_template_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

global returnsValue
returnsValue = nargout;
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before advanced_empty_gui_template is made visible.
function advanced_empty_gui_template_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to advanced_empty_gui_template (see VARARGIN)

% Choose default command line output for advanced_empty_gui_template
handles.output = hObject;

% PROGRAM DATA
handles.NAME = 'New Program';
handles.VERSION = '1.0.0';

% Parse input arguments
handles.inputPar = parseInputs(varargin);

% Call initialization function
handles = INITIALIZE(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes advanced_empty_gui_template wait for user response (see UIRESUME)
global returnsValue
if returnsValue
    uiwait(handles.figure1);
end

% Input parser
function cfg = parseInputs(args)
p = inputParser;
% Define optional parameters
addParameter(p,'debug',false,@islogical);
% Parse and return "cfg" struct
parse(p,args{:});
cfg = p.Results;

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = advanced_empty_gui_template_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isfield(handles,'output')
    handles.output = [];
end
varargout{1} = handles.output;

%% HELPER FUNCTIONS
% ONOFF returns 'on' if logical_value is true and 'off' otherwise. Useful
% for setting uicontrol properties based on conditions
function str = onoff(logical_value)
if logical_value, str = 'on'; else str = 'off'; end
%% MAIN FUNCTION DEFINITIONS
% Defining functions in the form handles = FUNCTIONNAME(handles,varargin)
% is convenient in cases where the same function may be called from
% different control callbacks, i.e. a button and a menu item.
% It also allows combining several operations. Example:
%   function someControl_Callback(hObject,eventdata,handles)
%       handles = UPDATE_DATA(handles);
%       handles = SAVE_DATA(handles);
%       guidata(hObject,handles); % Remember to save the updated handles data
function handles = INITIALIZE(handles)
% Actions depending on execution mode (deployed .exe / MATLAB code)
try
    if isdeployed
        % Make sure the working directory is the same as the executable path,
        % in case it is run from a shortcut
        [status, result] = system('set PATH');
        executableFolder = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
        cd(executableFolder);
    else
        % Add needed paths
    end
    % Set figure title
    set(handles.figure1,'Name',sprintf('%s v.%s',handles.NAME,handles.VERSION));
catch ME
    if isdeployed
        % Show error dialog in deployed mode
        warndlg(sprintf('%s - INITIALIZE error\n\n%s',handles.NAME,ME.message),'modal');
        fclose(handles.fig);
    else
        % Rethrow error
        rethrow(ME);
    end
end
% Initialize variables

% Example main functions
function handles = HOTKEY(handles,key,modifier)
if strcmp(modifier,'control')
    switch key
        case 's'    % ctrl+s to save data
            handles = SAVE_DATA(handles);
        case 'o'    % ctrl+o to open data
            handles = LOAD_DATA(handles);
    end
else
    switch key
        case 'f5'
            handles = UPDATE(handles);
    end
end

function handles = SAVE_DATA(handles)
disp('Saved.'); % Example

function handles = LOAD_DATA(handles)
disp('Loading...'); % Example

function handles = UPDATE(handles)
disp('Updating!'); % Example

%% UICONTROL CALLBACKS generated by MATLAB's GUIDE
function figure1_KeyPressFcn(hObject, eventdata, handles)
handles = HOTKEY(handles,eventdata.Key,eventdata.Modifier);
guidata(hObject,handles);
