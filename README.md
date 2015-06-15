Eclipse to PowerShell ISE Theme Converter
==========
![My image](https://raw.githubusercontent.com/akawhoami/psisetheme/master/ExampleTheme.PNG)

[EclipseColorThemes.org](http://eclipsecolorthemes.org) contains many pretty good themes. This PowerShell script converts themes from this site to PowerShell ISE editor themes. Please note that these themes only apply for the Scripting Pane area of the ISE, and only for the PowerShell language. The XML language and Console Pane colors are just the default ISE ones.


Examples:
==========
(First dot source the .PS1 file.)

**Convert theme from XML theme files:**<BR>
Convert-EctToISE -ThemeFile .\theme-21.xml, .\theme-33.xml


**Convert theme from URL:**<BR>
Convert-EctToISE -ThemeUrl "http://eclipsecolorthemes.org/?view=empty&action=download&theme=21&type=xml"

Enjoy!


