<cfparam name="attributes.width" default="150">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.option_value" default="">
<cfparam name="attributes.option_name" default="">
<cfparam name="attributes.query_name" default="">
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.multiple" default="0">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.onchange" default="">
<cfparam name="attributes.is_option_text" default="1">
<cfparam name="attributes.tabindex" default="">
<cfparam name="attributes.where" default="">
<cfparam name="attributes.name" default="select_#round(rand()*10000000)#"><!--- Asagida kullaniliyor. Buraya da ekledim. E.Y 20120905--->
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
<cfset download_folder = application.systemparam.systemparam().download_folder />
<cfscript>
	component_name="#attributes.query_name#";
	if(fileExists("#download_folder#workdata/#component_name#")) CreateComponent = CreateObject("component","/../workdata/#component_name#");
	else CreateComponent = CreateObject("component","/../V16/workdata/#component_name#"); 
	if(len(attributes.where))
		queryResult = CreateComponent.getComponentFunction(where:'#attributes.where#');
	else
		queryResult = CreateComponent.getComponentFunction();
</cfscript>
<select id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfif len(attributes.onchange)>onchange="<cfoutput>#attributes.onchange#</cfoutput>"</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif> <cfif attributes.multiple eq 1>multiple</cfif> <cfif attributes.disabled eq 1>disabled</cfif> style="width:<cfoutput>#attributes.width#px;height:#attributes.height#px</cfoutput>" <cfif isdefined("attributes.required")>required</cfif>>
	<cfif attributes.multiple neq 1><option value=""><cfoutput>#attributes.option_text#</cfoutput></option></cfif>
	<cfoutput query="queryResult">
        <option value="#evaluate(attributes.option_value)#" <cfif len(attributes.value) and listfind(attributes.value,evaluate(attributes.option_value),',')>selected</cfif>>#evaluate(attributes.option_name)#</option> 
    </cfoutput>
</select>

