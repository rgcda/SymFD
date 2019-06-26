function SFDexportMap(map,minMax,mapType,fullname,titleTxt,printOptions,img)
%SFDexportMap
    
    if ~isfield(printOptions,'quality')
        printOptions.quality = 95;
    end
    if ~isfield(printOptions,'resolution')
        printOptions.resolution = 300;
    end
    
    if strcmpi(printOptions.exportType,'mat')
        save([fullname,'.',printOptions.exportType],'map');
        return;
    end
    
    
    if exist('img','var')
        hFig = SFDplotMap(map,minMax,mapType,titleTxt,img);
    else
        hFig = SFDplotMap(map,minMax,mapType,titleTxt);
    end    
    set(hFig,'color','w');
    if (exist('export_fig')==2)        
        export_fig(fullname,['-',printOptions.exportType],['-q',num2str(printOptions.quality)],['-r',num2str(printOptions.resolution)],hFig);
    else
        warning('Requires the export_fig toolbox written by Yair Altman. The toolbox can be obtained from mathworks at https://de.mathworks.com/matlabcentral/fileexchange/23629-export_fig.');
    end
    close(hFig);
end

% Written by Rafael Reisenhofer
%
% Part of SymFD Toolbox v 1.1
% Built on November 7, 2018
% Published under the MIT License
