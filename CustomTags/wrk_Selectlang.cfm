<!--- Dile göre select kayıtlarını getirmeede kullanılır. PY--->
<cfparam name="attributes.value" default="">
<cfparam name="attributes.option_value" default="">
<cfparam name="attributes.option_name" default="">
<cfparam name="attributes.data_source" default="#caller.DSN#">
<cfparam name="attributes.table_name" default="">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.width" default="">
<cfparam name="attributes.multiple" default="0">
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.tabindex" default="">
<cfparam name="attributes.onChange" default="">
<cfparam name="attributes.selected_properties" default=""><!--- Selected özelliğinde çalışacak kod --->
<cfparam name="attributes.is_option_text" default="1">
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
<cfparam name="attributes.sort_type" default="#attributes.option_name#">
<cfparam name="attributes.extra_params" default="">
<cfparam name="attributes.condition" default="">
<cfparam name="attributes.name" default="select_#round(rand()*10000000)#"><!--- Asagida kullaniliyor. Buraya da ekledim. E.Y 20120905--->
<cfparam name="attributes.selectTwoMod" default="false">
<cfparam name="attributes.required" default="false">
<cfif len(attributes.table_name)>
<cfinvoke component = "/workdata/get_querylang" method="getComponentFunction" returnvariable="queryResult">
<cfinvokeargument name="data_source" value="#attributes.data_source#">
<cfinvokeargument name="table_name" value="#attributes.table_name#">
<cfinvokeargument name="option_name" value="#attributes.option_name#">
<cfinvokeargument name="option_value" value="#attributes.option_value#">
<cfinvokeargument name="sort_type" value="#attributes.sort_type#">
<cfinvokeargument name="extra_params" value="#attributes.extra_params#">
<cfinvokeargument name="condition" value="#attributes.condition#"></cfinvoke>
</cfif>
<select class="<cfoutput>#attributes.name#</cfoutput>" id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfif len(attributes.onChange)>onchange="<cfoutput>#attributes.onchange#</cfoutput>"</cfif> <cfif attributes.multiple eq 1>multiple</cfif> <cfif attributes.disabled eq 1>disabled="disabled"</cfif> <cfif attributes.required>required</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif> style="width:<cfoutput>#attributes.width#px;height:#attributes.height#px</cfoutput>"><cfif attributes.is_option_text eq 1><option value=""><cfoutput>#attributes.option_text#</cfoutput></option></cfif><cfif len(attributes.table_name)><cfoutput query="queryResult"><option value="#evaluate(attributes.option_value)#" <cfif len(attributes.value) and listfind(attributes.value,evaluate(attributes.option_value),',')>selected="selected" <cfif len(attributes.selected_properties)>#attributes.selected_properties#</cfif></cfif>>#evaluate(attributes.option_name)#</option> </cfoutput></cfif></select>
<cfif attributes.selectTwoMod><script>$(document).ready(function() {$('select[name = <cfoutput>#attributes.name#</cfoutput>]').select2();});</script></cfif>
