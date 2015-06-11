Function Convert-EctToISE {

<#

.SYNOPSIS  
    EclipseColorThemes.org to PowerShell ISE theme converter.

.DESCRIPTION  
    This script convert themes from EclipseColorThemes.org to PowerShell ISE editor themes.

.PARAMETER ThemeFile
    Path to Xml theme file from EclipseColorThemes.org

.PARAMETER ThemeUrl
    Specifies url to theme from EclipseColorThemes.org

.EXAMPLE
    Convert-EctToISE -ThemeFile c:\ObsidianTheme.xml

.EXAMPLE
    Convert-EctToISE -ThemeUrl http://eclipsecolorthemes.org/?view=empty&action=download&theme=21&type=xml 

.NOTES
    Name: Convert-EctToISE.ps1
    Requires: PowerShell v3

    VERSION HISTORY:
    1.0 (27-Dec-2014): Initial Version.
    1.1 (05-Jun-2015): Changed several Console pane colors so they're all the default ISE ones.
    1.2 (11-Jun-2015): Turned script into an advanced function.
                        Set parameters to an array, and allowed them to be accepted from the pipeline.


.LINK
    https://github.com/akawhoami/psisetheme

#>

    [CmdletBinding()]

    Param(

        [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
        [string[]]
        $ThemeFiles,

        [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
        [string[]]
        $ThemeURLs

    )
        
    BEGIN
    {
        
         $ReplaceTable = @{"ScriptPaneBackgroundColor"      = "background";
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
        }#Defining $ReplaceTable


        $ColorTable = @{"ErrorForegroundColor"           = "#FF0000";
                    "ErrorBackgroundColor"           = "#012456";
                    "WarningForegroundColor"         = "#FF8C00";
                    "WarningBackgroundColor"         = "#012456";
                    "VerboseForegroundColor"         = "#00FFFF";
                    "VerboseBackgroundColor"         = "#012456";
                    "DebugForegroundColor"           = "#00FFFF";
                    "DebugBackgroundColor"           = "#012456";
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
        }#Defining $ColorTable
        
        $DefaultSaveLocation = Get-Location
        
    }#BEGIN  

    
    PROCESS
    {
        TRY
        {

            #Helper function - Save theme file dialog interface
            Function Get-SaveFileDialog($initialDirectory)
            {
                [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
                $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
                $saveFileDialog.initialDirectory = $initialDirectory
                $saveFileDialog.filter = "ISE Color Themes (*.StorableColorTheme.ps1xml)| *.StorableColorTheme.ps1xml"
                $saveFileDialog.ShowDialog() | Out-Null
                $saveFileDialog.filename
            }#FUNCTION Get-SaveFileDialog

        
            #Function to build the actual ISE Theme XML file
            Function New-IseThemeXMLFile
            {
        
                            
                ForEach ($elem in $replaceTable.Keys)
                {
                    $color = $eclipseThemeXml.colorTheme.$($replaceTable[$elem]) 
                    $colorTable[$elem] = $color.color
                }#FOREACH $elem in $replaceTable

                $psThemeXml = New-Object xml
                $xmlDcl = $psThemeXml.CreateXmlDeclaration("1.0", "utf-16", $null)
                $xmlRoot = $psThemeXml.CreateElement("StorableColorTheme");
                $psThemeXml.InsertBefore($xmlDcl, $xmlDcl.DocumentElement)
                $xmlRoot.SetAttribute("xmlns:xsd", "http://www.w3.org/2001/XMLSchema")
                $xmlRoot.SetAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
                $xmlKeys=$xmlRoot.AppendChild($psThemeXml.CreateElement("Keys"))
                $xmlValues=$xmlRoot.AppendChild($psThemeXml.CreateElement("Values"))

    

                ForEach ($elem in $colorTable.Keys)
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
                }#FOREACH $elem in $colorTable

                #Name node
                $xmlName = $xmlRoot.AppendChild($psThemeXml.CreateElement("Name"))
                $xmlName.InnerText = $eclipseThemeXml.colorTheme.name

                #FontFamily node
                $xmlFontFamily = $xmlRoot.AppendChild($psThemeXml.CreateElement("FontFamily"))
                $xmlFontFamily.InnerText = "Lucida Console"

                #FontSize node
                $xmlFontSize = $xmlRoot.AppendChild($psThemeXml.CreateElement("FontSize"))
                $xmlFontSize.InnerText = 10
                $psThemeXml.AppendChild($xmlRoot);

                #Save theme to file
                $psThemeXml.Save($(Get-SaveFileDialog($DefaultSaveLocation)))

            }#FUNCTION New-ISEThemeXMLFile



            if ($ThemeFiles)
            {
                # The process block can be executed multiple times as objects are passed through the pipeline into it.
                ForEach($ThemeFile In $ThemeFiles)
                {
                     $eclipseThemeXml = [xml](Get-Content $ThemeFile)
                     Invoke-Expression New-IseThemeXMLFile               
                }#FOREACH $ThemeFile
            }#IF $ThemeFiles

            elseif ($ThemeURLs)
            {
                ForEach($ThemeURL In $ThemeURLs)
                {
                     $eclipseThemeXml = [xml](Invoke-WebRequest -Uri $ThemeURL).Content
                     Invoke-Expression New-IseThemeXMLFile             
                }#FOREACH $ThemeURL
                 
            }#ELSEIF $ThemeURLs

            else
            {
                Write-Warning "Missing parameter -ThemeFile or -ThemeUrl"                
            }#ELSE missing parameters

         }#TRY

         CATCH
         {
            Write-Warning -Message "An error occurred!"
            Write-Warning -Message $Error[0].Exception.Message
         }#CATCH          

     }#PROCESS    

}#FUNCTION Convert-EctToISE