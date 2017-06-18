# Summary
The main purpose of this tool is to allow adding customized GUI templates to the ones included in MATLAB's GUIDE tool.
Two main functions are included:
* **install_guide_template.m**
This tool allows adding custom GUI  templates to MATLAB's GUIDE.
It copies the .m and .fig files to a folder in MATLAB's install directory, specifically `[matlab_root]/toolbox/matlab/guide/guitemplates/` and modifies the `templateinfo.xml` file to register the new template. **Note**: in some cases, MATLAB should be ran with Administrative Privileges to be able to write to the `guitemplates` folder
* **remove_guide_template.m**
This function displays a dialog listing the currently installed GUIDE templates, allowing the user to remove one of them.

A GUI template is included under the template_examples folder. More templates may be added to te repositry in the future.

**Note**: tested only in Windows. The location of the guitemplates folder may change in other OS.

# Usage

Example code
```
% myTemplate.m and myTemplate.fig originally generated with GUIDE and customized by the user

add_guide_template('myTemplate.m','myTemplate.fig','My custom template');
```
The template name can be specified in the input dialog
![Template name input dialog](/doc/template_name_input.PNG?raw=true "Template name input dialog")

Once installed, the template will show up in the template selector that is displayed when starting the GUIDE tool
```
% Run GUIDE to display the installed templates
guide
```
![GUIDE template selection](/doc/guide_template_selection.PNG?raw=true "Optional Title")

The function can also be called without specifying the source files. In this case a file selection dialog will prompt the user for the files.

```
add_guide_template
```

Additional options are explained in the function help

```
help add_guide_template
```

