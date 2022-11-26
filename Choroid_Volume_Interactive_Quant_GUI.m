

function varargout = Choroid_Volume_Interactive_Quant_GUI(varargin)
%CHOROID_VOLUME_INTERACTIVE_QUANT_GUI M-file for Choroid_Volume_Interactive_Quant_GUI.fig
%      CHOROID_VOLUME_INTERACTIVE_QUANT_GUI, by itself, creates a new CHOROID_VOLUME_INTERACTIVE_QUANT_GUI or raises the existing
%      singleton*.
%
%      H = CHOROID_VOLUME_INTERACTIVE_QUANT_GUI returns the handle to a new CHOROID_VOLUME_INTERACTIVE_QUANT_GUI or the handle to
%      the existing singleton*.
%
%      CHOROID_VOLUME_INTERACTIVE_QUANT_GUI('Property','Value',...) creates a new CHOROID_VOLUME_INTERACTIVE_QUANT_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Choroid_Volume_Interactive_Quant_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CHOROID_VOLUME_INTERACTIVE_QUANT_GUI('CALLBACK') and CHOROID_VOLUME_INTERACTIVE_QUANT_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CHOROID_VOLUME_INTERACTIVE_QUANT_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Choroid_Volume_Interactive_Quant_GUI

% Last Modified by GUIDE v2.5 25-Nov-2022 18:11:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Choroid_Volume_Interactive_Quant_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Choroid_Volume_Interactive_Quant_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Choroid_Volume_Interactive_Quant_GUI is made visible.
function Choroid_Volume_Interactive_Quant_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Choroid_Volume_Interactive_Quant_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Choroid_Volume_Interactive_Quant_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Choroid_Volume_Interactive_Quant_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Output_thickness.
function Output_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to Output_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% filePath = handles.filePath;
% output_folder=handles.output_folder;
% set(handles.Output_thickness,'string',out4)
output_folder=handles.output_folder;
% set(handles.Output_thickness,'string',out4)
% system('explorer.exe output_folder');
% output_folder=handles.OutFolder;
%  p = genpath(output_folder);
 winopen(output_folder);
% set(handles.Output_thickness,'string',status);

% --- Executes on button press in OutputFolder.


% --- Executes on button press in Select_OCT_Volume.
function Select_OCT_Volume_Callback(hObject, eventdata, handles)

[segPath,CIB3D_Fill3,COB3D_Fill3,filePath,cropImgs] = Ch_Topography_Seg_500_250_6x6_1;

oMatPath = 'D:\Choroid\Code\GUI\WF\Ch_Topo_gui\Choroid_Topography_MatFiles\';
handles.oMatPath = oMatPath;
handles.segPath = segPath;
handles.CIB3D_Fill3 = CIB3D_Fill3;
handles.COB3D_Fill3 = COB3D_Fill3;
handles.filePath = filePath;
handles.cropImgs = cropImgs;
% handles.c2 = c2;

% winopen(segPath0);
winopen(segPath);
enf_img = enfImg1(CIB3D_Fill3,cropImgs);
handles.enf_img = enf_img;

answer = questdlg('Boundary detections okay?', 'Boundary Detection');
y_n = 'Org_notWorking';
switch answer
    case 'Yes'
%         disp([answer 'Preparing for saving mat file!'])    
        y_n = 'Org_working';
%         handles.enf_img = enf_img;
%         guidata(hObject,handles)
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        fpath = strcat(oMatPath,kywd{1},'\',y_n);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img');
        figure;imshow(enf_img);
    case 'No'
%         disp([answer 'Try boundary corrections!'])
        y_n = '_org_notWorking';
%         enf_img = enfImg1(CIB3D_Fill3,cropImgs);
%         handles.enf_img = enf_img;
%         guidata(hObject,handles)
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        fpath = strcat(oMatPath,kywd{1},'\',y_n);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img');
        figure;imshow(enf_img);
end
guidata(hObject,handles)

function OutputFolder_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
segPath = handles.segPath;

% set(handles.Output_thickness,'string',out4)
% output_folder=handles.OutFolder;
%  p = genpath(output_folder);
 winopen(segPath);


function range_Callback(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range as text
%        str2double(get(hObject,'String')) returns contents of range as a double


% --- Executes during object creation, after setting all properties.
function range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Perfrom_Boundary_Correction_cib_cob.
function Perfrom_Boundary_Correction_cib_cob_Callback(hObject, eventdata, handles)
% hObject    handle to Perfrom_Boundary_Correction_cib_cob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% chSeg_corr(cib,cob,rang)  
% get(hObject,'String')
spurious_snos = get(handles.spurious_snos,'String');
% load('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat')
cib_old = handles.CIB3D_Fill3;
cob_old = handles.COB3D_Fill3;
oMatPath = handles.oMatPath;
% c2 = handles.c2;
cropImgs = handles.cropImgs;
filePath = handles.filePath;
[cib_new,cob_new,rang,~] = chSeg_corr_cib_cob(cib_old,cob_old,spurious_snos);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i = 1:size(rang,1)
    rang1 = [rang1 rang(i,1):rang(i,2)];
end
nvar='cib_cob_sm_afterCorrection';
% tic
newSegPath = plt_wf_cib(cropImgs,cib_old,cib_new,cob_new,filePath,nvar,rang1)
% plt_ws_sm=toc

% newSegPath=handles.newSegPath;

% set(handles.Output_thickness,'string',out4)
% output_folder=handles.OutFolder;
% p = genpath(output_folder);
 winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,cropImgs,filePath)
        enf_img = enfImg1(cib_new,cropImgs);
        CIB3D_Fill3 = cib_new;
        handles.CIB3D_Fill3 = CIB3D_Fill3;
        COB3D_Fill3 = cob_new;
        handles.COB3D_Fill3 = COB3D_Fill3;
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        temp = rang';
        rang_all = unique(temp(:))';
        str3 = [];
        for ind = 1:length(rang_all)
            str3 = strcat(str3,'_',int2str(rang_all(ind)));
        end
        fpath = strcat(oMatPath,kywd{1},'\cib_cob_corr_rangs',str3);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img','cib_old','spurious_snos');
        guidata(hObject,handles);
%         dessert = 1;
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end

function spurious_snos_Callback(hObject, eventdata, handles)
% hObject    handle to spurious_snos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spurious_snos as text
%        str2double(get(hObject,'String')) returns contents of spurious_snos as a double


% --- Executes during object creation, after setting all properties.
function spurious_snos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spurious_snos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Perfrom_Boundary_Correction_cib.
function Perfrom_Boundary_Correction_cib_Callback(hObject, eventdata, handles)
% hObject    handle to Perfrom_Boundary_Correction_cib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spurious_snos = get(handles.spurious_snos,'String');
% load('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat')
cib_old = handles.CIB3D_Fill3;
cob_old = handles.COB3D_Fill3;
oMatPath = handles.oMatPath;
% c2 = handles.c2;
cropImgs = handles.cropImgs;
filePath = handles.filePath;
[cib_new,rang,~] = chSeg_corr_cib(cib_old,spurious_snos);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='cib_sm_afterCorrection';
% tic
newSegPath = plt_wf_cib(cropImgs,cib_old,cib_new,cob_old,filePath,nvar,rang1)
% plt_ws_sm=toc

% newSegPath=handles.newSegPath;

% set(handles.Output_thickness,'string',out4)
% output_folder=handles.OutFolder;
%  p = genpath(output_folder);
 winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,cropImgs,filePath)
        enf_img = enfImg1(cib_new,cropImgs);
        figure;imshow(enf_img);
        CIB3D_Fill3 = cib_new;
        handles.CIB3D_Fill3 = CIB3D_Fill3;
        COB3D_Fill3 = cob_old;
        handles.COB3D_Fill3 = COB3D_Fill3;
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        temp = rang';
        rang_all = unique(temp(:))';
        str3 = [];
        for ind = 1:length(rang_all)
            str3 = strcat(str3,'_',int2str(rang_all(ind)));
        end
        fpath = strcat(oMatPath,kywd{1},'\cib_corr_rangs',str3);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img','cib_old');
%         dessert = 1;
        guidata(hObject,handles);
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end

% --- Executes on button press in Perfrom_Boundary_Correction_cob.
function Perfrom_Boundary_Correction_cob_Callback(hObject, eventdata, handles)
% hObject    handle to Perfrom_Boundary_Correction_cob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Spurious_scanNumbers = get(handles.spurious_snos,'String');
% load('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat')
cib_old = handles.CIB3D_Fill3;
cob_old = handles.COB3D_Fill3;
oMatPath = handles.oMatPath;
% c2 = handles.c2;
cropImgs = handles.cropImgs;
filePath = handles.filePath;
[cob_new,rang,~] = chSeg_corr_cob(cob_old,Spurious_scanNumbers);
% save('..\AMD_P842344020_Angio(12mmx12mm)_2-3-2020_13-41-46_OS_sn1560_cube_z_cib_cob_500_1024_04-Jan-2022-14-49.mat','cib_new','cob_new','-append');
rang1=[];
for i=1:size(rang,1)
    rang1=[rang1 rang(i,1):rang(i,2)];
end
nvar='cob_sm_afterCorrection';
% tic
newSegPath = plt_wf_cibcob(cropImgs,cib_old,cob_new,filePath,nvar,rang1)
% plt_ws_sm=toc

% newSegPath=handles.newSegPath;

% set(handles.Output_thickness,'string',out4)
% output_folder=handles.OutFolder;
%  p = genpath(output_folder);
 winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?','Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,cropImgs,filePath)
%         enf_img = enfImg1(cib_new,cropImgs);
        enf_img = handles.enf_img;
        figure;imshow(enf_img);
        CIB3D_Fill3 = cib_old;
        handles.CIB3D_Fill3 = CIB3D_Fill3;
        COB3D_Fill3 = cob_new;
        handles.COB3D_Fill3 = COB3D_Fill3;
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        temp = rang';
        rang_all = unique(temp(:))';
        str3 = [];
        for ind = 1:length(rang_all)
            str3 = strcat(str3,'_',int2str(rang_all(ind)));
        end
        fpath = strcat(oMatPath,kywd{1},'\cob_corr_rangs',str3);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img');
%         dessert = 1;
        guidata(hObject,handles);
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end


% --- Executes on button press in rpt_cob.
function rpt_cob_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_cob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rpt_scan_no = get(handles.rpt_scan_no,'String');
rpt_range = get(handles.rpt_corr_scan_range,'String');

strr = split(rpt_range,'-')';  


cib_old = handles.CIB3D_Fill3;
cob_old = handles.COB3D_Fill3;
oMatPath = handles.oMatPath;
% 
s0 = str2double(rpt_scan_no);
s1 = str2double(strr{1});
s2 = str2double(strr{2});
sd = size(cob_old,2);

% if s1 == 1
%     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
%     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
% else
cob = [cob_old(:,1:s1-1) repmat(cob_old(:,s0),1,s2-s1+1) cob_old(:,s2+1:sd)];
% end

% c2 = handles.c2;
cropImgs = handles.cropImgs;
filePath = handles.filePath;
nvar='cob_sm_rep';
% tic
newSegPath = plt_wf_cibcob(cropImgs,cib_old,cob,filePath,nvar,s1:s2)
winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?','Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,cropImgs,filePath)
%         enf_img = enfImg1(cb,cropImgs);
        enf_img = handles.enf_img;
        figure;imshow(enf_img);
        CIB3D_Fill3 = cib_old;
        handles.CIB3D_Fill3 = CIB3D_Fill3;
        COB3D_Fill3 = cob;
        handles.COB3D_Fill3 = COB3D_Fill3;
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        fpath = strcat(oMatPath,kywd{1},'\cob_corr_rpt_',rpt_scan_no,'_',rpt_range);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','cob_old','enf_img','rpt_scan_no','rpt_range');
        guidata(hObject, handles);
%         dessert = 1;
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end

% --- Executes on button press in rpt_cib.
function rpt_cib_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_cib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rpt_scan_no = get(handles.rpt_scan_no,'String');
rpt_range = get(handles.rpt_corr_scan_range,'String');

strr = split(rpt_range,'-')';  


cib_old = handles.CIB3D_Fill3;
cob_old = handles.COB3D_Fill3;
oMatPath = handles.oMatPath;
% 
s0 = str2double(rpt_scan_no);
s1 = str2double(strr{1});
s2 = str2double(strr{2});
sd = size(cib_old,2);

% if s1 == 1
%     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
%     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
% else
cib = [cib_old(:,1:s1-1) repmat(cib_old(:,s0),1,s2-s1+1) cib_old(:,s2+1:sd)];
% end

% c2 = handles.c2;
cropImgs = handles.cropImgs;
filePath = handles.filePath;
nvar='cib_sm_rep';
% tic
newSegPath = plt_wf_cib(cropImgs,cib_old,cib,cob_old,filePath,nvar,s1:s2)
winopen(newSegPath);
 answer = questdlg('Boundary corrections, okay?', 'Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,cropImgs,filePath)
        enf_img = enfImg1(cib,cropImgs);
        figure;imshow(enf_img);
%         enf_img = handles.enf_img;
        CIB3D_Fill3 = cib;
        handles.CIB3D_Fill3 = CIB3D_Fill3;
        COB3D_Fill3 = cob_old;
        handles.COB3D_Fill3 = COB3D_Fill3;
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        fpath = strcat(oMatPath,kywd{1},'\cib_corr_rpt_',rpt_scan_no,'_',rpt_range);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','enf_img','cib_old','rpt_scan_no','rpt_range');
        guidata(hObject, handles);
%         dessert = 1;
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end

function rpt_scan_no_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_scan_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpt_scan_no as text
%        str2double(get(hObject,'String')) returns contents of rpt_scan_no as a double


% --- Executes during object creation, after setting all properties.
function rpt_scan_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpt_scan_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rpt_cib_cob.
function rpt_cib_cob_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_cib_cob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rpt_scan_no = get(handles.rpt_scan_no,'String');
rpt_range = get(handles.rpt_corr_scan_range,'String');

strr = split(rpt_range,'-')';  


cib_old = handles.CIB3D_Fill3;
cob_old = handles.COB3D_Fill3;
oMatPath = handles.oMatPath;

% 
s0 = str2double(rpt_scan_no);
s1 = str2double(strr{1});
s2 = str2double(strr{2});
sd = size(cib_old,2);

% if s1 == 1
%     cib = [repmat(cib_old(:,s0),1,s2) cib_old(:,s2+1:sd)];
%     cob = [repmat(cob_old(:,s0),1,s2) cob_old(:,s2+1:sd)];
% else
cib = [cib_old(:,1:s1-1) repmat(cib_old(:,s0),1,s2-s1+1) cib_old(:,s2+1:sd)];
cob = [cob_old(:,1:s1-1) repmat(cob_old(:,s0),1,s2-s1+1) cob_old(:,s2+1:sd)];
% end

% c2 = handles.c2;
cropImgs = handles.cropImgs;
filePath = handles.filePath;
nvar='cib_cob_sm_rep';
% tic
newSegPath = plt_wf_cibcob(cropImgs,cib,cob,filePath,nvar,s1:s2)
winopen(newSegPath);
answer = questdlg('Boundary corrections, okay?','Boundary Correction');
% Handle response
switch answer
    case 'Yes'
        disp([answer 'Preparing for saving mat file!'])
%         pltEnfImage(cib_new,cib_new,cropImgs,filePath)
        enf_img = enfImg1(cib,cropImgs);
        figure;imshow(enf_img);
        CIB3D_Fill3 = cib;
        handles.CIB3D_Fill3 = CIB3D_Fill3;
        COB3D_Fill3 = cob;
        handles.COB3D_Fill3 = COB3D_Fill3;
        str1 = split(filePath,'\')
        str2 = split(str1{4},'_');        
        kywd = join(str2(1:end-1),'_')
        fpath = strcat(oMatPath,kywd{1},'\cib_cob_corr_rpt_',rpt_scan_no,'_',rpt_range);
        mkdir(fpath);
        save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','cib_old','cob_old','enf_img','rpt_scan_no','rpt_range');
        guidata(hObject, handles);
%         dessert = 1;
%         guidata(hObject, handles);
    case 'No'
        disp([answer 'Try manual boundary correction!'])
%         dessert = 2;
end



% cob = 4*[repmat(COB3D_Fill2(:,4),1,200) COB3D_Fill2(:,201:1024)]

function rpt_corr_scan_range_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_corr_scan_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpt_corr_scan_range as text
%        str2double(get(hObject,'String')) returns contents of rpt_corr_scan_range as a double
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function rpt_corr_scan_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpt_corr_scan_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to rpt_corr_scan_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rpt_corr_scan_range as text
%        str2double(get(hObject,'String')) returns contents of rpt_corr_scan_range as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rpt_corr_scan_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ShowBoundarySurfaces.
function ShowBoundarySurfaces_Callback(hObject, eventdata, handles)
% hObject    handle to ShowBoundarySurfaces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.CIB3D_Fill3 =
cib_final = handles.CIB3D_Fill3;
cob_final = handles.COB3D_Fill3;
figure; mesh(cib_final);hold on;mesh(cib_final+cob_final);


% --- Executes on button press in ShowEnfaceImg.
function ShowEnfaceImg_Callback(hObject, eventdata, handles)
% hObject    handle to ShowEnfaceImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
enf_img = handles.enf_img;
figure; imshow(enf_img);
