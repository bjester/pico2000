function [ f, h ] = stopButton( )
%STOPBUTTON Displays a stop button
% [F, H] = STOPBUTTON() displays a Stop button to check abort data collection - 
% based on Mathworks solution 1-15JIQ and MATLAB Central forum.
% F is the handle to the button's figure, H is the handle to the uicontrol
% object.

    f = figure('Name', 'Stop Button', 'menubar','none',...
              'units','pix',...
              'pos',[400 400 100 50]);
          
    h = uicontrol('string', 'STOP', ...
                'callback', 'setappdata(gcf, ''run'', 0)', 'units','pixels',...
                'position',[10 10 80 30]);

end

