<cfparam name="attributes.width" default="150">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.disabled" default="0">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.multiple" default="0">
<cfparam name="attributes.is_active" default="0">
<cfparam name="attributes.income_expense" default="2">
<cfparam name="attributes.onchange" default="">
<cfparam name="attributes.is_option_text" default="1">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.name" default="select_#round(rand()*10000000)#"><!--- Asagida kullaniliyor. Buraya da ekledim. E.Y 20120905--->
<cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
	<cfinvoke 
 		component = "/workdata/get_budget_Item" 
 		method="getComponentFunction" 
 		returnvariable="queryResult">
	<cfinvokeargument name="is_active" value="#attributes.is_active#">
	<cfinvokeargument name="income_expense" value="#attributes.income_expense#">
	</cfinvoke>
<select id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" <cfoutput><cfif len(attributes.onchange)>onchange="#attributes.onchange#"</cfif></cfoutput> <cfif attributes.multiple eq 1>multiple</cfif> <cfif attributes.disabled eq 1>disabled</cfif> <cfoutput><cfif len(attributes.class)>class="#attributes.class#"</cfif></cfoutput> style="width:<cfoutput>#attributes.width#px;height:#attributes.height#px</cfoutput>">
    <cfif attributes.is_option_text eq 1>
		<option value=""><cfoutput>#attributes.option_text#</cfoutput></option>
	</cfif>
	<cfoutput query="queryResult">
        <option value="#EXPENSE_ITEM_ID#" <cfif len(attributes.value) and ListFind(attributes.value,EXPENSE_ITEM_ID)>selected</cfif>>#EXPENSE_ITEM_NAME#</option> 
    </cfoutput>
</select>

