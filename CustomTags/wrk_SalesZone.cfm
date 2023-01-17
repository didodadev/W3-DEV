<cfparam name="attributes.width" default="150">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.multiple" default="0">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.onchange" default="">
<cfparam name="attributes.tabindex" default=""> 
<cfparam name="attributes.is_option_text" default="1">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.name" default="select_#round(rand()*10000000)#"><!--- Asagida kullaniliyor. Buraya da ekledim. E.Y 20120905--->
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
	<cfscript>
	CreateComponent = CreateObject("component","workdata/get_sales_zone");
	queryResult = CreateComponent.getComponentFunction(
		branch_id : attributes.branch_id,
		is_active : attributes.is_active,
		position_code : attributes.position_code,
		hierarchy : attributes.hierarchy
	);
</cfscript>
<select id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif> <cfif len(attributes.onchange)>onchange="<cfoutput>#attributes.onchange#</cfoutput>"</cfif> <cfif attributes.multiple eq 1>multiple</cfif> <cfif attributes.disabled eq 1>disabled</cfif> <cfoutput><cfif len(attributes.class)>class="#attributes.class#"</cfif></cfoutput> style="width:<cfoutput>#attributes.width#px;height:#attributes.height#px</cfoutput>">
	<option value=""><cfoutput>#attributes.option_text#</cfoutput></option>
	<cfoutput query="queryResult">
        <option value="#SZ_ID#"<cfif len(attributes.value) and listfind(attributes.value,SZ_ID,',')>selected</cfif>>#SZ_NAME#</option> 
    </cfoutput>
</select>
