function varargout = untitled(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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
end


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global obj;

obj = videoinput('winvideo',1,'MJPG_640x480');
vidRes = get(obj,'VideoResolution');%get查询属性
nBands = get(obj,'NumberOfBands');
axes(handles.axes1);
global hImage
hImage = image(zeros(vidRes(2),vidRes(1),nBands));
preview(obj,hImage);%预览
try
    while true
        img=getsnapshot(obj);%获取帧
        [deep_var,count]=hullTop5(img);
        if deep_var>150
            count=count+1;
        end
        set(handles.text2,'string',count);
        pause(0.33);   
    end
catch
end

end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global obj;
stop(obj);
delete(obj);
axes(handles.axes1);
cla reset;
end



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
end
