function remove_guide_template()
% REMOVE_GUIDE_TEMPLATE allows adding GUI templates to MATLAB's GUIDE tool
%   REMOVE_GUIDE_TEMPLATE() shows a list dialog with the currently installed
%   GUIDE templates. The user can select the template to remove. The
%   selected template will be removed from the templates .xml file and the
%   corresponding .m, .fig and .gif files in the templates folder will be
%   removed too unless they are associated to a different template alias.
%
%   Examples
%   --------
%
%       % Add a new template with name 'My custom template'
%       install_guide_template('.\myTemplate.fig','.\myTemplate.m','My custom template');
%       
%       % Run guide. The template selection dialog will be displayed with
%       % the newly created template listed.
%       guide
%
%       % Now run remove_guide_template to remove the newly created one
%       remove_guide_template();
%
%   See also guide, install_guide_template
% 
%   Alvaro Martinez, 2017 - alvaro.mart.mart+dev@gmail.com
%   v. 1.0
% -------------------------------------------------------------------------

    %% Find templates folder
    mat_root = matlabroot;
    templates_folder = [mat_root '\toolbox\matlab\guide\guitemplates\'];
    %% Edit templates .xml file
    templates_info_file = [mat_root '\toolbox\matlab\guide\templateinfo.xml'];
    
    % Make backup
    templates_info_file_backup = strrep(templates_info_file,'.xml','_latest.xml');
    if ~exist(templates_info_file_backup,'file')
        % Backup
        copyfile(templates_info_file,templates_info_file_backup);
    end

    % Read xml contents
    xDoc = xmlread(templates_info_file);
    
    skip = false;

    groupItems = xDoc.getElementsByTagName('Group');
    allListItems = groupItems.item(0).getElementsByTagName('Template');
    
    templateNames = arrayfun(@(x)char(allListItems.item(x).getAttribute('Name')),[0:allListItems.getLength-1],'UniformOutput',false);
    [selection,ok] = listdlg('ListString',templateNames,'SelectionMode','single','OKString','Delete','Name','Uninstall');
    if ok
        try
            itemToRemove = groupItems.item(0).getElementsByTagName('Template').item(selection-1);
            template_name = char(itemToRemove.getAttribute('File'));
            % Stop if the selected template is a MATLAB's template
            if ismember(template_name,{'guidetemplate0','guidetemplate1','guidetemplate2','guidetemplate3'})
                warndlg('Removing original MATLAB templates is disabled.');
                return
            end
            template_name = char(itemToRemove.getAttribute('File'));
            groupItems.item(0).removeChild(itemToRemove);
            % Save xml
            xmlwrite(templates_info_file,xDoc);
        catch err
            warndlg('Something went wrong updating the GUIDE templates xml','Error');
            % Recover previous file
            movefile(templates_info_file_backup,templates_info_file);
            rethrow(err);
        end
        % Make sure the template files are not associated to a different
        % template tag
        skip = false;
        for i=0:allListItems.getLength-1
            thisListitem = allListItems.item(i);
            tname = thisListitem.getAttribute('File');
            if strcmp(tname,template_name)
                skip = true;
                break;
            end
        end
        if ~skip
            % Remove .m, .fig and .gif files
            filesToRemove = cellfun(@(x)[templates_folder template_name x],{'.m','.fig','.gif'},'UniformOutput',false);
            for i=1:length(filesToRemove)
                if exist(filesToRemove{i},'file')
                    try
                        delete(filesToRemove{i});
                        fprintf('File removed: %s\n',filesToRemove{i});
                    catch err
                        error('Files couldn''t be removed. Try to do it manually: <a href="matlab:winopen([matlabroot ''\toolbox\matlab\guide\guitemplates\''])">go to templates folder</a>');
                    end
                end
            end
        else
            fprintf('No files removed\n');
        end
    else
        fprintf('Cancelled by user\n');
    end
end