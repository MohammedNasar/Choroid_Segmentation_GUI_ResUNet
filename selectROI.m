function roiList = selectROI(image, ROI)
    %
    % selectROI - Graphical interface to select rectangle or/and ellipse
    %             regions of interest over a picture. It's also possible
    %             to move, delete (using the DEL key) or resize the
    %             selections.
    %
    % Format:     selectRoi(image, ROI)
    %
    % Input:      image - any 2D image array such as image=imread('demo.jpg')
    %             ROI - previous selection produced by this same application
    %                { 'r:x0,y0,width0,height0',
    %                  'c:x1,y1,width1,height1'}
    %                 r is for rectangle ROI, c is for ellipse/circle
    %
    % Output:     ROI produced (see Input ROI for format)
    %
    % Note:       This program provides a GUI to quickly produce rectangle
    %             or ellipse selection. Those regions can be graphically
    %             removed, resized or moved.
    %
    % Example1:   > myImage = imread('UtilityFiles/demo.jpg');
    %             > myRoi = selectROI(myImage);
    %
    % Example2:   > selectROI();       %will run the demo mode
    %
    % Example3:   > myROI = {'r:45,96,100,365','c:100,100,200,300'};
    %             > myImage = imread('UtilityFiles/demo.jpg');
    %             > myNewRoi = selectRoi(myImage, myROI);
    %
    % Written by Jean Bilheux - November 2012 - bilheuxjm@ornl.gov
    %
    
    %status of the left click
    leftClick = false;
    
    %are we moving the mouse with left click on ?
    motionClickWithLeftClick = false;
    
    %used in selection of boxes
    point1 = [-1 -1];
    point2 = [-1 -1];
    
    %last rectangle ploted
    lastRectangle = [-1 -1 -1 -1];
    
    %are we currently dealing with an ellipse ?
    isLastRectangleEllipse = false;
    
    %used when moving the selection
    rectangleInitialPosition  = [-1 -1 -1 -1]; %rectangle to move
    
    %reference position of rectangle to used when moving selection
    pointRef = [-1 -1];
    
    %Selection (rectangle and ellipse)
    roiSelection = {};
    isroiSelectionEllipse = [];
    roiList = [];
    
    %used when moving selection
    activeRectangleIndex = -1;
    previousActiveRectangleIndex = -1;
    
    %['top','bottom','right','left','topl','topr','botl','botr','hand'
    pointer = 'crosshair'; %cursor shape
    
    if nargin == 0
        demoFile = 'demo.jpg';
        image = imread(demoFile);
        ROI = {'r:45,96,100,365'};
    end
    
    %-----------------------------------------------------
    
    %previously loaded ROI
    %     [prevLoadedRoi] = get(handles.listboxNormalizationRoi,'string');
    prevLoadedRoi = ROI;
    createroiSelection(prevLoadedRoi);
    
    ScreenSize = get(0,'ScreenSize');
    figWidth = 800;
    figHeight = 800;
    figX = (ScreenSize(3)-figWidth)/2;
    figY = (ScreenSize(4)-figHeight)/2;
    
    figroi = figure('menubar','none',...
        'position',[figX, figY, figWidth, figHeight]);
    ht=uitoolbar(figroi);
    
    rectangle_icon = imread('rectangle_ROI.jpg','jpg');
    ellipse_icon = imread('ellipse_ROI.jpg','jpg');
    help_icon = imread('help.jpg','jpg');
    rectangleTool = uitoggletool(ht, 'CData',rectangle_icon, ...
        'TooltipString','Select a rectangular ROI', ...
        'State','on', ...
        'tag','rectangle_roi');
    ellipseTool = uitoggletool(ht, 'CData',ellipse_icon, ...
        'TooltipString','Select an elliptical ROI', ...
        'tag', 'ellipse_roi');
    helpSwitch = uipushtool(ht, 'CData', help_icon, ...
        'separator','on',...
        'TooltipString','Help',...
        'tag','help_button');
    
    drawnow
    
    %define the callback functions of the toolbar
    set(rectangleTool, ...
        'clickedCallback', {@clickedRectangleTool});
    set(ellipseTool, ...
        'clickedCallback', {@clickedEllipseTool});
    set(helpSwitch, ...
        'clickedCallback', {@clickedHelpSwitch});
    
    %create an axes object
    roiAxes = axes();
    set(roiAxes, ...
        'tickdir','out', ...
        'position',[0 0 1 1]);
    
    %set figure properties
    set(figroi, 'numbertitle','off',...
        'name','ROI Selection Tool', ...
        'units','normalized', ...
        'pointer','crosshair', ...
        'WindowButtonMotionFcn',{@hFigure_MotionFcn}, ...
        'WindowKeyPressFcn',{@hFigure_KeyPressFcn}, ...
        'WindowButtonDownFcn', {@hFigure_DownFcn}, ...
        'WindowButtonUpFcn', {@hFigure_UpFcn}, ...
        'CloseRequestFcn', {@hFigure_closeRequestFcn});
    
    RoiRefreshImage (); %plot the image
    
    colormap('gray')
    
    uiwait(figroi);
    
    function createroiSelection(preLoadedRoi)
        %This function will parse the ROI from the main gui roi list
        %and populates the roiSelection and isroiSelectionEllipse
        
        nbrRow = size(preLoadedRoi,1);
        if nbrRow > 0
            
            expression='([rc]):(\d+)[, ](\d+)[, ](\d+)[, ](\d+)';
            
            for i=1:nbrRow
                
                currentLine = preLoadedRoi{i};
                [solution] = regexp(currentLine,expression,'tokens');
                if strcmp(solution{1}(1),'r')
                    isroiSelectionEllipse(i) = false;
                else
                    isroiSelectionEllipse(i) = true;
                end
                
                roiSelection{i} = [str2double(solution{1}{2}) ...
                    str2double(solution{1}{3}) ...
                    str2double(solution{1}{4}) ...
                    str2double(solution{1}{5})];
            end
            
        end
        
    end
    
    
    function moveEdgeRectangle(side)
        %will resize the rectangle by moving the left, right, top
        %or bottom edge
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        %FIXME
        %make sure the program does not complain when width or height
        %becomes 0 or negative
        
        minWH = 1;  %rectangle is at least minWH pixels width and height
        
        switch side
            case 'left'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
                lastRectangle(3) = rectangleInitialPosition(3) - deltaX;
                if lastRectangle(3) <= minWH
                    lastRectangle(3) = minWH;
                end
                
            case 'right'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(3) = rectangleInitialPosition(3) + deltaX;
                
            case 'top'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
                lastRectangle(4) = rectangleInitialPosition(4) - deltaY;
                
            case 'bottom'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastRectangle(4) = rectangleInitialPosition(4) + deltaY;
                
            case 'topl'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
                lastRectangle(3) = rectangleInitialPosition(3) - deltaX;
                lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
                lastRectangle(4) = rectangleInitialPosition(4) - deltaY;
                
            case 'topr'
                
                %offset to apply
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                
                lastRectangle(3) = rectangleInitialPosition(3) + deltaX;
                lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
                lastRectangle(4) = rectangleInitialPosition(4) - deltaY;
                
            case 'botl'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
                lastRectangle(3) = rectangleInitialPosition(3) - deltaX;
                lastRectangle(4) = rectangleInitialPosition(4) + deltaY;
                
            case 'botr'
                
                %offset to apply
                deltaY = curMousePosition(1,2) - pointRef(1,2);
                deltaX = curMousePosition(1,1) - pointRef(1,1);
                
                lastRectangle(3) = rectangleInitialPosition(3) + deltaX;
                lastRectangle(4) = rectangleInitialPosition(4) + deltaY;
                
        end
        
        %make sure we have the minimum width and height requirements
        if lastRectangle(3) <= minWH
            lastRectangle(3) = minWH;
        end
        if lastRectangle(4) <= minWH
            lastRectangle(4) = minWH;
        end
        
        RoiRefreshImage();
        
        if isLastRectangleEllipse
            rectangle('position',lastRectangle,...
                'curvature',[1,1], ...
                'lineStyle','--',...
                'lineWidth',1, ...
                'edgeColor','red');
            rectangle('position',lastRectangle,...
                'lineStyle',':',...
                'lineWidth',0.5, ...
                'edgeColor','red');
        else
            rectangle('position',lastRectangle,...
                'lineStyle','--',...
                'lineWidth',1, ...
                'edgeColor','red');
        end
    end
    
    function moveLiveRectangle()
        %will move the rectangle selection
        
        motionClickWithLeftClick = true;
        
        %current mouse position
        curMousePosition = get(roiAxes,'CurrentPoint');
        
        %offset to apply
        deltaX = curMousePosition(1,1) - pointRef(1,1);
        deltaY = curMousePosition(1,2) - pointRef(1,2);
        
        lastRectangle(1) = rectangleInitialPosition(1) + deltaX;
        lastRectangle(2) = rectangleInitialPosition(2) + deltaY;
        
        RoiRefreshImage();
        
        if isLastRectangleEllipse
            rectangle('position',lastRectangle,...
                'lineStyle','--',...
                'curvature',[1,1],...
                'lineWidth',1, ...
                'edgeColor','red');
            rectangle('position',lastRectangle,...
                'lineStyle',':',...
                'lineWidth',0.5, ...
                'edgeColor','red');
        else
            rectangle('position',lastRectangle,...
                'lineStyle','--',...
                'lineWidth',1, ...
                'edgeColor','red');
        end
    end
    
    function hFigure_MotionFcn(~, ~)
        %This function is reached any time the mouse is moving over the figure
        
        if leftClick %we need to draw something
            
            switch pointer
                case 'crosshair' %draw rectangle
                    drawLiveRectangle();
                    
                case 'hand' %move selected rectangle here
                    moveLiveRectangle();
                    
                case 'left'
                    moveEdgeRectangle('left');
                    
                case 'right'
                    moveEdgeRectangle('right');
                    
                case 'top'
                    moveEdgeRectangle('top');
                    
                case 'bottom'
                    moveEdgeRectangle('bottom');
                    
                case 'topl'
                    moveEdgeRectangle('topl');
                    
                case 'topr'
                    moveEdgeRectangle('topr');
                    
                case 'botl'
                    moveEdgeRectangle('botl');
                    
                case 'botr'
                    moveEdgeRectangle('botr');
                    
                otherwise
            end
            
        else %we need to check if we need to move or change size of something
            
            [yesItIs, index, isEdge, whichEdge_trbl] = isMouseOverRectangle();
            if yesItIs %change color of this rectangle
                activeRectangleIndex = index;
                
                pointer = 'hand';
                if isEdge
                    
                    if isequal(whichEdge_trbl,[true false false false])
                        pointer = 'top';
                    end
                    if isequal(whichEdge_trbl,[false true false false])
                        pointer = 'right';
                    end
                    if isequal(whichEdge_trbl,[false false true false])
                        pointer = 'bottom';
                    end
                    if isequal(whichEdge_trbl,[false false false true])
                        pointer = 'left';
                    end
                    if isequal(whichEdge_trbl,[true true false false])
                        pointer = 'topr';
                    end
                    if isequal(whichEdge_trbl,[true false false true])
                        pointer = 'topl';
                    end
                    if isequal(whichEdge_trbl,[false true true false])
                        pointer = 'botr';
                    end
                    if isequal(whichEdge_trbl,[false false true true])
                        pointer = 'botl';
                    end
                end
            else
                activeRectangleIndex = -1;
                pointer = 'crosshair';
            end
            set(figroi, 'pointer',pointer);
            
            %refresh plot only if something changed
            if previousActiveRectangleIndex ~= activeRectangleIndex
                RoiRefreshImage();
                previousActiveRectangleIndex = activeRectangleIndex;
            end
            
        end
        
    end
    
    function [yesItIs, index, isEdge, whichEdge_trbl] = isMouseOverRectangle()
        %this function will determine if the mouse is
        %currently over a previously selected Rectangle
        %
        %yesItIs: true or false
        %index; if yesItIs, returns the index of the rectangle selected
        %isEdge: true or false (are we over the rectangle, or just the
        % edge). Just the edge means that the rectangle will be resized
        % when over the center will mean replace it !
        %whichEdge: 'top', 'left', 'bottom' or 'right' or combination of
        % 'top-left'...etc
        
        yesItIs = false;
        index = -1;
        isEdge = false;
        whichEdge_trbl = [false false false false];
        
        point = get(roiAxes, 'CurrentPoint');
        
        sz = size(roiSelection,2);
        if sz > 0
            for i=1:sz
                [isOverRectangle, isEdge, whichEdge_trbl] = isMouseOverEdge(point, roiSelection{i});
                if isOverRectangle
                    yesItIs = true;
                    index = i;
                    return
                end
            end
        end
        
    end
    
    function [result, isEdge, whichEdge_trbl] = isMouseOverEdge(point, rectangle)
        %check if the point(x,y) is over the edge of the
        %rectangle(x,y,w,h)
        
        szEdge = 10; %pixels units
        
        result = false;
        isEdge = false;
        whichEdge_trbl = [false false false false]; %top right bottom left
        
        xMouse = point(1,1);
        yMouse = point(1,2);
        
        xminRect = rectangle(1);
        yminRect = rectangle(2);
        xmaxRect = rectangle(3)+xminRect;
        ymaxRect = rectangle(4)+yminRect;
        
        %is inside rectangle
        if (yMouse > yminRect-szEdge && ...
                yMouse < ymaxRect+szEdge && ...
                xMouse > xminRect-szEdge && ...
                xMouse < xmaxRect+szEdge)
            
            %is over left edge
            if (yMouse > yminRect-szEdge && ...
                    yMouse < ymaxRect+szEdge && ...
                    xMouse > xminRect-szEdge && ...
                    xMouse < xminRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(4) = true;
            end
            
            %is over bottom edge
            if (xMouse > xminRect-szEdge && ...
                    xMouse < xmaxRect+szEdge && ...
                    yMouse > ymaxRect-szEdge && ...
                    yMouse < ymaxRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(3) = true;
            end
            
            %is over right edge
            if (yMouse > yminRect-szEdge && ...
                    yMouse < ymaxRect+szEdge && ...
                    xMouse > xmaxRect-szEdge && ...
                    xMouse < xmaxRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(2) = true;
            end
            
            %is over top edge
            if (xMouse > xminRect-szEdge && ...
                    xMouse < xmaxRect+szEdge && ...
                    yMouse > yminRect-szEdge && ...
                    yMouse < yminRect+szEdge)
                
                isEdge = true;
                whichEdge_trbl(1) = true;
            end
            
            result = true;
            
        end
        
    end
    
    function addLastRectangleToListRectangle
        %add the last rectangle ROI to the list of Rectangle ROIs
        
        sz = size(roiSelection,2);
        roiSelection{sz+1} = lastRectangle;
        isroiSelectionEllipse(sz+1) = isLastRectangleEllipse;
        activeRectangleIndex = sz+1;
        
    end
    
    function removeRectangleToList(index)
        %remove the rectangle at the index given
        roiSelection(index) = [];
        isroiSelectionEllipse(index) = '';
    end
    
    function hFigure_DownFcn(~, ~)
        leftClick = true;
        units = get(roiAxes,'units');
        set(roiAxes,'units','normalized');
        point1 = get(roiAxes,'CurrentPoint');
        set(roiAxes,'units',units);
        
        %we need to keep record of the exact position of active rectangle
        if ~strcmp(pointer,'crosshair')
            rectangleInitialPosition = roiSelection{activeRectangleIndex};
            lastRectangle = rectangleInitialPosition;
            isLastRectangleEllipse = isroiSelectionEllipse(activeRectangleIndex);
            %get reference position
            pointRef = get(roiAxes,'CurrentPoint');
            removeRectangleToList(activeRectangleIndex);
            activeRectangleIndex = -1;
            moveLiveRectangle();
        else
            isLastRectangleEllipse = strcmp(get(rectangleTool', 'State'),'off');
        end
        
    end
    
    function hFigure_UpFcn(~, ~)
        leftClick = false;
        if motionClickWithLeftClick
            %add last rectangle to list of rectangle ROIs
            addLastRectangleToListRectangle();
            RoiRefreshImage();
        end
        motionClickWithLeftClick = false;
    end
    
    function clickedRectangleTool (~, ~)
        set(ellipseTool,'State','off');
        set(rectangleTool', 'State', 'on');
    end
    
    function clickedEllipseTool (~, ~)
        set(ellipseTool,'State','on');
        set(rectangleTool', 'State', 'off');
    end
    
    function RoiRefreshImage (~)
        %Refresh the image plot
        
        %get current saved image to preview
        axes(roiAxes);
        img = image;
        imagesc(img);
        
        sz = size(roiSelection,2);
        if sz > 0
            for i=1:sz
                if i==activeRectangleIndex
                    color = 'red';
                else
                    color = 'white';
                end
                
                if isroiSelectionEllipse(i)
                    rectangle('position',roiSelection{i},...
                        'lineWidth',1, ...
                        'curvature',[1,1],...
                        'edgeColor',color);
                    if strcmp(color,'red')
                        rectangle('position',roiSelection{i},...
                            'lineWidth',0.5, ...
                            'lineStyle',':',...
                            'edgeColor',color);
                    end
                else
                    rectangle('position',roiSelection{i},...
                        'lineWidth',1, ...
                        'edgeColor',color);
                end
                
                if strcmp(color,'red')
                    %draw small squares in the corner and middle of length
                    %to show that we can resize them
                    cornerRectangles = getCornerRectangles(roiSelection{i});
                    for j=1:8
                        rectangle('position',cornerRectangles{j},...
                            'lineWidth',1, ...
                            'edgeColor',color);
                    end
                end
                
            end
        end
        
    end
    
    function cornerRectangles = getCornerRectangles(currentRectangle)
        %this function will create a [8x4] array of the corner
        %rectangles used to show the user that it can resize the ROI
        
        cornerRectangles = {};
        
        x = currentRectangle(1);
        y = currentRectangle(2);
        w = currentRectangle(3);
        h = currentRectangle(4);
        
        units=get(figroi,'units');
        set(figroi,'units','pixels');
        figroiPosition = get(figroi,'position');
        figroiWidth = figroiPosition(3);
        figroiHeight = figroiPosition(4);
        set(figroi,'units',units);
        
        wBox = figroiWidth/100;
        hBox = figroiHeight/100;
        
        %tl corner
        x1 = x - wBox/2;
        y1 = y - hBox/2;
        cornerRectangles{1} = [x1,y1,wBox,hBox];
        
        %t (middle of top edge) corner
        x2 = x + w/2 - wBox/2;
        y2 = y - wBox/2;
        cornerRectangles{2} = [x2,y2,wBox,hBox];
        
        %tr corner
        x3 = x + w - wBox/2;
        y3 = y - hBox/2;
        cornerRectangles{3} = [x3,y3,wBox,hBox];
        
        %r (middle of right edge) corner
        x4 = x + w - wBox/2;
        y4 = y + h/2 - hBox/2;
        cornerRectangles{4} = [x4,y4,wBox,hBox];
        
        %br corner
        x5 = x + w - wBox/2;
        y5 = y + h - hBox/2;
        cornerRectangles{5} = [x5,y5,wBox,hBox];
        
        %b (middle of bottom edge) corner
        x6 = x + w/2 - wBox/2;
        y6 = y + h - hBox/2;
        cornerRectangles{6} = [x6,y6,wBox,hBox];
        
        %bl corner
        x7 = x - wBox/2;
        y7 = y + h - hBox/2;
        cornerRectangles{7} = [x7,y7,wBox,hBox];
        
        %l (middle of left edge) corner
        x8 = x - wBox/2;
        y8 = y + h/2 - hBox/2;
        cornerRectangles{8} = [x8,y8,wBox,hBox];
        
    end
    
    function drawLiveRectangle()
        %draw a rectangle live with mouse moving
        
        motionClickWithLeftClick = true;
        units = get(roiAxes,'units');
        set(roiAxes,'units','normalized');
        point2 = get(roiAxes, 'CurrentPoint');
        x = min(point1(1,1),point2(1,1));
        y = min(point1(1,2),point2(1,2));
        w = abs(point1(1,1)-point2(1,1));
        h = abs(point1(1,2)-point2(1,2));
        if w == 0
            w=1;
        end
        if h == 0
            h=1;
        end
        
        %save rectangle
        lastRectangle = [x y w h];
        RoiRefreshImage (); %plot the image
        
        if isLastRectangleEllipse
            rectangle('position',[x,y,w,h],...
                'lineStyle','--',...
                'lineWidth',1, ...
                'curvature',[1,1],...
                'edgeColor','blue');
            rectangle('position',[x,y,w,h],...
                'lineStyle',':',...
                'lineWidth',0.5, ...
                'edgeColor','blue');
        else
            rectangle('position',[x,y,w,h],...
                'lineStyle','--',...
                'lineWidth',1, ...
                'edgeColor','blue');
        end
        
        set(roiAxes,'units',units);
        
    end
    
    function hFigure_KeyPressFcn(~,eventdata)
        
        switch eventdata.Key
            case 'delete'
                removeRectangleToList(activeRectangleIndex);
                RoiRefreshImage();
            case 'backspace'
                removeRectangleToList(activeRectangleIndex);
                RoiRefreshImage();
            otherwise
        end
        
    end
    
    function clickedHelpSwitch(~, ~)
        %reached when user click HELP button
        message = {'Select your ROI type: RECTANGLE or ELLIPSE.', '', ...
            'Move to the edge of any selection to resize.', '', ...
            'DEL key will remove the red (active) selection'};
        helpdlg(message);
        
    end
    
    function roiList = formatRoiList(roiPxCoord, isroiSelectionEllipse)
        %this will format the roi for the main gui ROI list
        %[10,20,30,40] -> "r:10,20,30,40" for a rectangle
        %[20,30,40,50] -> "c:20,30,40,50" for an ellipse
        sz = size(roiPxCoord,2);
        roiList = {};
        if sz > 0
            for i=1:sz
                region = roiPxCoord{i};
                if isroiSelectionEllipse(i)
                    pref = 'c:';
                else
                    pref = 'r:';
                    roiList{i} = sprintf('%u,%u,%u,%u',region); %#ok<AGROW>
                end
                suf = [int2str(region(1)) ',' int2str(region(2)) ',' ...
                    int2str(region(3)) ',' int2str(region(4))];
                roiList{i} = [pref suf]; %#ok<AGROW>
            end
        end
        
    end
    
    function hFigure_closeRequestFcn(hFigure, ~)
        % This is where we can return the ROI selected
        
        roiList = formatRoiList(roiSelection, isroiSelectionEllipse);
        delete(hFigure);
        
    end
    
end