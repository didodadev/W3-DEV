<!--- company 1 , consumer 0 PY--->
<cfparam name="attributes.width" default="150">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.multiple" default="0">
<cfparam name="attributes.comp_cons" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.compcat_type" default="3">
<cfparam name="attributes.onchange" default="">
<cfparam name="attributes.is_option_text" default="1">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.tabindex" default="">
<cfparam name="attributes.name" default="select_#round(rand()*10000000)#"><!--- Asagida kullaniliyor. Buraya da ekledim. E.Y 20120905--->
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
	<cfinvoke 
 		component = "/workdata/get_member_cat" 
 		method="getComponentFunction" 
 		returnvariable="queryResult">
 		<cfinvokeargument name="comp_cons" value="#attributes.comp_cons#">
		<cfinvokeargument name="is_active" value="#attributes.is_active#">
		<cfinvokeargument name="compcat_type" value="#attributes.compcat_type#">
	</cfinvoke>
<select id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfif len(attributes.onchange)>onchange="<cfoutput>#attributes.onchange#</cfoutput>"</cfif> <cfif attributes.multiple eq 1>multiple</cfif> <cfif attributes.disabled eq 1>disabled</cfif> <cfif len(attributes.class)>class="<cfoutput>#attributes.class#</cfoutput>"</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif> style="width:<cfoutput>#attributes.width#px;height:#attributes.height#px</cfoutput>">
    <cfif attributes.is_option_text eq 1>
		<option value=""><cfoutput>#attributes.option_text#</cfoutput></option>
	</cfif>
	<cfoutput query="queryResult">
        <option value="<cfif attributes.comp_cons eq 1>#COMPANYCAT_ID#<cfelse>#CONSCAT_ID#</cfif>" <cfif attributes.comp_cons eq 1><cfif len(attributes.value) and listfind(attributes.value,#COMPANYCAT_ID#,',')> selected="selected"</cfif><cfelse><cfif len(attributes.value) and listfind(attributes.value,#CONSCAT_ID#,',')> selected="selected"</cfif></cfif>><cfif attributes.comp_cons eq 1>#COMPANYCAT#<cfelse>#CONSCAT#</cfif></option> 
    </cfoutput>
</select>
