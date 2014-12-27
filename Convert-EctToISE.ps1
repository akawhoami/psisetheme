<#  
.SYNOPSIS  
    EclipseColorThemes.org to PowerShell ISE theme converter 
.DESCRIPTION  
    This script convert themes from EclipseColorThemes.org to PowerShell ISE editor
.PARAMETER ThemeFile
    Path to Xml theme file from EclipseColorThemes.org
.PARAMETER ThemeUrl
    Specifies url to theme from EclipseColorThemes.org
.EXAMPLE
    Convert theme from xml file
        .\Convert-EctToISE -ThemeFile c:\ObsidianTheme.xml
    Convert theme from EclipseColorThemes.org url
        .\Convert-EctToISE -ThemeUrl http://eclipsecolorthemes.org/?view=empty&action=download&theme=21&type=xml 
.NOTES
    Name: Convert-EctToISE.ps1
    Version: 2014.12.27 
    Requires: PowerShell v3  
.LINK
    https://github.com/akawhoami/psisetheme
#>
Param( 
[Parameter(Mandatory = $false)]
[string] $ThemeFile,

[Parameter(Mandatory = $false)]
[string] $ThemeUrl
)  

$colorTable = @{"ErrorForegroundColor"           = "#FF0000";
                "ErrorBackgroundColor"           = "#FFFFFF";
                "WarningForegroundColor"         = "#FF8CFF";
                "WarningBackgroundColor"         = "#FFFFFF";
                "VerboseForegroundColor"         = "#00FFFF";
                "VerboseBackgroundColor"         = "#FFFFFF";
                "DebugForegroundColor"           = "#00FFFF";
                "DebugBackgroundColor"           = "#FFFFFF";
                "ConsolePaneBackgroundColor"     = "#012456";
                "ConsolePaneTextBackgroundColor" = "#012456";
                "ConsolePaneForegroundColor"     = "#F5F5F5";
                "ScriptPaneBackgroundColor"      = "#FFFFFF";
                "ScriptPaneForegroundColor"      = "#000000";
                "TokenColors\Attribute"          = "";
                "TokenColors\Command"            = "";
                "TokenColors\CommandArgument"    = "";
                "TokenColors\CommandParameter"   = "";
                "TokenColors\Comment"            = "";
                "TokenColors\GroupEnd"           = "";
                "TokenColors\GroupStart"         = "";
                "TokenColors\Keyword"            = "";
                "TokenColors\LineContinuation"   = "";
                "TokenColors\LoopLabel"          = "";
                "TokenColors\Member"             = "";
                "TokenColors\NewLine"            = "#000000";
                "TokenColors\Number"             = "";
                "TokenColors\Operator"           = "";
                "TokenColors\Position"           = "#000000";
                "TokenColors\StatementSeparator" = "";
                "TokenColors\String"             = "";
                "TokenColors\Type"               = "";
                "TokenColors\Unknown"            = "#000000";
                "TokenColors\Variable"           = "";
                "ConsoleTokenColors\Attribute"          = "#B0C4DE";
                "ConsoleTokenColors\Command"            = "#E0FFFF";
                "ConsoleTokenColors\CommandArgument"    = "#EE82EE";
                "ConsoleTokenColors\CommandParameter"   = "#FFE4B5";
                "ConsoleTokenColors\Comment"            = "#98FB98";
                "ConsoleTokenColors\GroupEnd"           = "#F5F5F5";
                "ConsoleTokenColors\GroupStart"         = "#F5F5F5";
                "ConsoleTokenColors\Keyword"            = "#E0FFFF";
                "ConsoleTokenColors\LineContinuation"   = "#F5F5F5";
                "ConsoleTokenColors\LoopLabel"          = "#E0FFFF";
                "ConsoleTokenColors\Member"             = "#F5F5F5";
                "ConsoleTokenColors\NewLine"            = "#000000";
                "ConsoleTokenColors\Number"             = "#FFE4C4";
                "ConsoleTokenColors\Operator"           = "#D3D3D3";
                "ConsoleTokenColors\Position"           = "#000000";
                "ConsoleTokenColors\StatementSeparator" = "#F5F5F5";
                "ConsoleTokenColors\String"             = "#DB7093";
                "ConsoleTokenColors\Type"               = "#8FBC8F";
                "ConsoleTokenColors\Unknown"            = "#000000";
                "ConsoleTokenColors\Variable"           = "#FF4500";
                "XmlTokenColors\CharacterData"    = "#808080";
                "XmlTokenColors\QuotedString"     = "#00008B";
                "XmlTokenColors\Comment"          = "#006400";
                "XmlTokenColors\CommentDelimiter" = "#008000";
                "XmlTokenColors\15"               = "#000000";
                "XmlTokenColors\13"               = "#000000";
                "XmlTokenColors\12"               = "#000000";
                "XmlTokenColors\14"               = "#000000";
                "XmlTokenColors\18"               = "#000000";
                "XmlTokenColors\MarkupExtension"  = "#FF8C00";
                "XmlTokenColors\Quote"            = "#0000FF";
                "XmlTokenColors\17"               = "#000000";
                "XmlTokenColors\ElementName"      = "#8B0000";
                "XmlTokenColors\11"               = "#000000";
                "XmlTokenColors\19"               = "#000000";
                "XmlTokenColors\16"               = "#000000";
                "XmlTokenColors\Attribute"        = "#FF0000";
                "XmlTokenColors\10"               = "#000000";
                "XmlTokenColors\Tag"              = "#00008B";
                "XmlTokenColors\Text"             = "#000000"
                }            
$replaceTable = @{"ScriptPaneBackgroundColor"      = "background";
                  "ScriptPaneForegroundColor"      = "foreground";
                  "TokenColors\Attribute"          = "keyword";
                  "TokenColors\Command"            = "method";
                  "TokenColors\CommandArgument"    = "localVariable";
                  "TokenColors\CommandParameter"   = "operator";
                  "TokenColors\Comment"            = "singleLineComment";
                  "TokenColors\GroupEnd"           = "operator";
                  "TokenColors\GroupStart"         = "operator";
                  "TokenColors\Keyword"            = "keyword";
                  "TokenColors\LineContinuation"   = "operator";
                  "TokenColors\LoopLabel"          = "operator";
                  "TokenColors\Member"             = "method";
                  "TokenColors\Number"             = "number";
                  "TokenColors\Operator"           = "operator";
                  "TokenColors\StatementSeparator" = "bracket";
                  "TokenColors\String"             = "string";
                  "TokenColors\Type"               = "keyword";
                  "TokenColors\Variable"           = "localVariable"
}

function Get-SaveFileDialog($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.initialDirectory = $initialDirectory
    $saveFileDialog.filter = "ISE Color Themes (*.StorableColorTheme.ps1xml)| *.StorableColorTheme.ps1xml"
    $saveFileDialog.ShowDialog() | Out-Null
    $saveFileDialog.filename
}

 if ($ThemeFile)
 {
    $eclipseThemeXml = [xml](Get-Content $ThemeFile)
 }
 elseif ($ThemeUrl)
 {
    $eclipseThemeXml = [xml](Invoke-WebRequest -Uri $ThemeUrl).Content 
 }
 else
 {
    Write-Host "Missing parameter -ThemeFile or -ThemeUrl" -ForegroundColor Red
    Exit
 } 
        
#Building xml file                 
foreach ($elem in $replaceTable.Keys)
{
    $color = $eclipseThemeXml.colorTheme.$($replaceTable[$elem]) 
    $colorTable[$elem] = $color.color
}

$psThemeXml = New-Object xml
$xmlDcl = $psThemeXml.CreateXmlDeclaration("1.0", "utf-16", $null)
$xmlRoot = $psThemeXml.CreateElement("StorableColorTheme");
$psThemeXml.InsertBefore($xmlDcl, $xmlDcl.DocumentElement)
$xmlRoot.SetAttribute("xmlns:xsd", "http://www.w3.org/2001/XMLSchema")
$xmlRoot.SetAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
$xmlKeys=$xmlRoot.AppendChild($psThemeXml.CreateElement("Keys"))
$xmlValues=$xmlRoot.AppendChild($psThemeXml.CreateElement("Values"))

foreach ($elem in $colorTable.Keys)
{
    $xmlString = $xmlKeys.AppendChild($psThemeXml.CreateElement("string"))
    $xmlString.InnerText = $elem 
    $xmlColor = $xmlValues.AppendChild($psThemeXml.CreateElement("Color"))
    $xmlColorA = $xmlColor.AppendChild($psThemeXml.CreateElement("A"))
    $xmlColorA.InnerText = 255
    $xmlColorR = $xmlColor.AppendChild($psThemeXml.CreateElement("R"))
    $xmlColorR.InnerText = [Convert]::ToInt32(($colorTable[$elem]).SubString(1, 2), 16)
    $xmlColorG = $xmlColor.AppendChild($psThemeXml.CreateElement("G"))
    $xmlColorG.InnerText = [Convert]::ToInt32(($colorTable[$elem]).substring(3, 2), 16)
    $xmlColorB = $xmlColor.AppendChild($psThemeXml.CreateElement("B"))
    $xmlColorB.InnerText = [Convert]::ToInt32(($colorTable[$elem]).substring(5, 2), 16)
}

#Name node
$xmlName = $xmlRoot.AppendChild($psThemeXml.CreateElement("Name"))
$xmlName.InnerText = $eclipseThemeXml.colorTheme.name

#FontFamily node
$xmlFontFamily = $xmlRoot.AppendChild($psThemeXml.CreateElement("FontFamily"))
$xmlFontFamily.InnerText = "Lucida Console"

#FontSize node
$xmlFontSize = $xmlRoot.AppendChild($psThemeXml.CreateElement("FontSize"))
$xmlFontSize.InnerText = 12
$psThemeXml.AppendChild($xmlRoot);

#Save theme to file
$psThemeXml.Save($(Get-SaveFileDialog(Split-Path $MyInvocation.MyCommand.Path)))