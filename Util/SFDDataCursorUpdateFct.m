function txt = SFDDataCursorUpdateFct(empt,event_obj)
% Customizes text of data tips
pos = event_obj.Position;
data = get(event_obj.Target,'UserData');
txt = {['Index: [',num2str(pos(1)),',',num2str(pos(2)),']'],...
    ['Value: ',num2str(data(pos(2),pos(1)))]};
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License