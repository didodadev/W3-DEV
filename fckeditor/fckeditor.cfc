<cfcomponent output="false" displayname="FCKeditor" hint="Create an instance of the FCKeditor.">

<!---
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2009 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * ColdFusion MX integration.
 * Note this CFC is created for use only with Coldfusion MX and above.
 * For older version, check the fckeditor.cfm.
 *
 * Syntax:
 *
 * <cfscript>
 * 		fckEditor = createObject("component", "fckeditor.fckeditor");
 * 		fckEditor.instanceName="myEditor";
 * 		fckEditor.basePath="/fckeditor/";
 * 		fckEditor.value="<p>This is my <strong>initial</strong> html text.</p>";
 * 		fckEditor.width="100%";
 * 		fckEditor.height="200";
 * 	 	// ... additional parameters ...
 * 		fckEditor.create(); // create instance now.
 * </cfscript>
 *
 * See your macromedia coldfusion mx documentation for more info.
 *
 * *** Note:
 * Do not use path names with a "." (dot) in the name. This is a coldfusion
 * limitation with the cfc invocation.
--->

<cfinclude template="fckutils.cfm">

<cffunction
	name="Create"
	access="public"
	output="true"
	returntype="void"
	hint="Outputs the editor HTML in the place where the function is called"
>
	<cfoutput>#CreateHtml()#</cfoutput>
</cffunction>

<cffunction
	name="CreateHtml"
	access="public"
	output="false"
	returntype="string"
	hint="Retrieves the editor HTML"
>

	<cfparam name="this.instanceName" type="string" />
	<cfparam name="this.width" type="string" default="100%" />
	<cfparam name="this.height" type="string" default="200" />
	<cfparam name="this.toolbarSet" type="string" default="Default" />
	<cfparam name="this.value" type="string" default="" />
	<cfparam name="this.basePath" type="string" default="/fckeditor/" />
	<cfparam name="this.checkBrowser" type="boolean" default="true" />
	<cfparam name="this.config" type="struct" default="#structNew()#" />

	<cfscript>
	// display the html editor or a plain textarea?
	if( isCompatible() )
		return getHtmlEditor();
	else
		return getTextArea();
	</cfscript>

</cffunction>

<cffunction
	name="isCompatible"
	access="private"
	output="false"
	returnType="boolean"
	hint="Check browser compatibility via HTTP_USER_AGENT, if checkBrowser is true"
>

	<cfscript>
	var sAgent = lCase( cgi.HTTP_USER_AGENT );
	var stResult = "";
	var sBrowserVersion = "";

	// do not check if argument "checkBrowser" is false
	if( not this.checkBrowser )
		return true;

	return FCKeditor_IsCompatibleBrowser();
	</cfscript>
</cffunction>

<cffunction
	name="getTextArea"
	access="private"
	output="false"
	returnType="string"
	hint="Create a textarea field for non-compatible browsers."
>
	<cfset var result = "" />
	<cfset var sWidthCSS = "" />
	<cfset var sHeightCSS = "" />

	<cfscript>
	if( Find( "%", this.width ) gt 0)
		sWidthCSS = this.width;
	else
		sWidthCSS = this.width & "px";

	if( Find( "%", this.width ) gt 0)
		sHeightCSS = this.height;
	else
		sHeightCSS = this.height & "px";

	result = "<textarea name=""#this.instanceName#"" rows=""4"" cols=""40"" style=""width: #sWidthCSS#; height: #sHeightCSS#"">#HTMLEditFormat(this.value)#</textarea>" & chr(13) & chr(10);
	</cfscript>
	<cfreturn result />
</cffunction>

<cffunction
	name="getHtmlEditor"
	access="private"
	output="false"
	returnType="string"
	hint="Create the html editor instance for compatible browsers."
>
	<cfset var result = "" />

	<cfscript>
	// try to fix the basePath, if ending slash is missing
	if( len( this.basePath) and right( this.basePath, 1 ) is not "/" )
		this.basePath = this.basePath & "/";
	
	result = 		  '<script type="text/javascript" src="fckeditor/ckeditor.js"></script>';
	result = result & '<textarea name="#this.instanceName#" id="#this.instanceName#">#HTMLEditFormat(this.value)#</textarea>';
	result = result & "<script type='text/javascript'>CKEDITOR.replace( '#this.instanceName#',
						{
							toolbar : '#this.toolbarSet#',
							height: '#this.height#',
							width: '#this.width#'
						});";
	result = result & 'function getUIColor (){return "##aabcc4";}</script>';
	</cfscript>
	<cfreturn result />
</cffunction>

</cfcomponent>

