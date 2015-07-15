function update_data_cursor (ploted, posx, posy)
    % First get the figure's data-cursor mode, activate it, and set some of its properties
cursorMode = datacursormode(gcf);
%set(cursorMode, 'enable','on', 'UpdateFcn',@setDataTipTxt, 'NewDataCursorOnClick',false);
set(cursorMode,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','off')
% Note: the optional @setDataTipTxt is used to customize the data-tip's appearance
 
% Note: the following code was adapted from %matlabroot%\toolbox\matlab\graphics\datacursormode.m
% Create a new data tip
hTarget = handle(ploted);
hDatatip = cursorMode.createDatatip(hTarget);
 
% Create a copy of the context menu for the datatip:
set(hDatatip,'UIContextMenu',get(cursorMode,'UIContextMenu'));
set(hDatatip,'HandleVisibility','off');
set(hDatatip,'Host',hTarget);
set(hDatatip,'ViewStyle','datatip');
 
% Set the data-tip orientation to top-right rather than auto
set(hDatatip,'OrientationMode','manual');
set(hDatatip,'Orientation','top-right');
 
% Update the datatip marker appearance
set(hDatatip, 'MarkerSize',5, 'MarkerFaceColor','none','MarkerEdgeColor','k', 'Marker','o', 'HitTest','off');
 
% Move the datatip to the right-most data vertex point

position = [posx posy];
update(hDatatip, position);
end