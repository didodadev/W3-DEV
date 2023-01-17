<!---MultiSelect yapısındaki selectler için hazırlanmıştır. 
Select de gösterilecek ve değeri tutulacak alan adı ve table adı verildiğinde get_query.cfc dosyasından bilgiler çağrılır.Query kirliliğini azaltır.PY--->
<cfparam name="attributes.width" default="150">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.option_value" default="">
<cfparam name="attributes.option_name" default="">
<cfparam name="attributes.data_source" default="#caller.DSN#">
<cfparam name="attributes.table_name" default="">
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.onchange" default="">
<cfparam name="attributes.is_option_text" default="0">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.optiontext_class" default="">
<cfparam name="attributes.sort_type" default="#attributes.option_name#">
<cfparam name="attributes.name" default="select_#round(rand()*10000000)#"><!--- Asagida kullaniliyor. Buraya da ekledim. E.Y 20120905--->
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
	<cfinvoke 
 		component = "/workdata/get_query" 
 		method="getComponentFunction" 
 		returnvariable="queryResult">
 		<cfinvokeargument name="data_source" value="#attributes.data_source#">
 		<cfinvokeargument name="table_name" value="#attributes.table_name#">
		<cfinvokeargument name="option_name" value="#attributes.option_name#">
 		<cfinvokeargument name="option_value" value="#attributes.option_value#">
		<cfinvokeargument name="sort_type" value="#attributes.sort_type#">
	</cfinvoke>
<select id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfif len(attributes.onchange)> onchange="<cfoutput>#attributes.onchange#</cfoutput>"</cfif>  multiple="multiple"<cfif attributes.disabled eq 1> disabled="disabled" </cfif> <cfif len(attributes.class)>class="<cfoutput>#attributes.class#</cfoutput>"</cfif> style="width:<cfoutput>#attributes.width#px;height:#attributes.height#px</cfoutput>">
    <cfif attributes.is_option_text eq 1>
		<option value="" <cfif len(attributes.optiontext_class)>class="<cfoutput>#attributes.optiontext_class#</cfoutput>"</cfif>><cfoutput>#attributes.option_text#</cfoutput></option>
	</cfif>
	<cfoutput query="queryResult">
        <option value="#evaluate(attributes.option_value)#" <cfif len(attributes.value) and listfind(attributes.value,evaluate(attributes.option_value),',')> selected="selected"</cfif>>#evaluate(attributes.option_name)#</option> 
    </cfoutput>
</select>
