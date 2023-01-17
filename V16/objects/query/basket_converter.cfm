<cfset basket = DeserializeJSON(URLDecode(form.basket, "utf-8"))>
<!---<cfsavecontent variable="control1">
    <cfdump var="#basket#">
</cfsavecontent>
<cffile action="write" file = "c:\basket.html" output="#control1#"></cffile>--->
<cfloop collection='#basket#' item='k'>
	<cfif k is 'items'>
		<cfloop from="1" to="#arrayLen(basket[k])#" index="satir">
			<cfloop collection="#basket[k][satir]#" item="satir_item">
				<cfif satir_item is 'tax_percent'>
					<cfset attributes["tax#satir#"] = basket[k][satir][satir_item]>
					<cfset form["tax#satir#"] = basket[k][satir][satir_item]>
				<cfelseif satir_item is 'other_money'>
					<cfset attributes["other_money_#satir#"] = basket[k][satir][satir_item]>
					<cfset form["other_money_#satir#"] = basket[k][satir][satir_item]>
				<cfelseif satir_item is 'other_money_value'>
					<cfset attributes["other_money_value_#satir#"] = basket[k][satir][satir_item]>
					<cfset form["other_money_value_#satir#"] = basket[k][satir][satir_item]>
				<cfelseif satir_item is 'other_money_grosstotal'>
					<cfset attributes["other_money_grosstotal#satir#"] = basket[k][satir][satir_item]>
					<cfset form["other_money_grosstotal#satir#"] = basket[k][satir][satir_item]>
					<cfset attributes["other_money_gross_total#satir#"] = basket[k][satir][satir_item]>
					<cfset form["other_money_gross_total#satir#"] = basket[k][satir][satir_item]>
				<cfelseif satir_item is 'deliver_dept'>
					<cfset attributes["basket_row_departman#satir#"] = basket[k][satir][satir_item]>
					<cfset form["basket_row_departman#satir#"] = basket[k][satir][satir_item]>
					<cfset attributes["deliver_dept#satir#"] = basket[k][satir][satir_item]>
					<cfset form["deliver_dept#satir#"] = basket[k][satir][satir_item]>
				<cfelseif satir_item neq 'tax'>
					<cfset attributes["#satir_item##satir#"] = basket[k][satir][satir_item]>
					<cfset form["#satir_item##satir#"] = basket[k][satir][satir_item]>
				</cfif>
			</cfloop>
		</cfloop>
	<cfelseif k is 'header' or k is 'hidden_values' or k is 'footer'>
		<cfloop collection="#basket[k]#" item="satir_item">
			<cftry>
				<cfif satir_item contains 'CKEDITOR_'>
					<cfset attributes[Replace(satir_item,'CKEDITOR_','')] = basket[k][satir_item]>
                    <cfset form[Replace(satir_item,'CKEDITOR_','')] = basket[k][satir_item]>
                <cfelse>
                    <cfset attributes[satir_item] = basket[k][satir_item]>
                    <cfset form[satir_item] = basket[k][satir_item]>
                </cfif>
			<cfcatch>
				<cfset attributes[satir_item] = javaCast( "null", 0 )>
				<cfset form[satir_item] = javaCast( "null", 0 )>
			</cfcatch>
			</cftry>
		</cfloop>
	<cfelse>
		<cfset attributes[k] = basket[k]>
        <cfset form[k] = basket[k]>
	</cfif>
</cfloop>


<!---<cfsavecontent variable="control2">
    <cfdump var="#attributes#">
</cfsavecontent>
<cffile action="write" file = "c:\attributes.html" output="#control2#"></cffile>--->


<!--- Post olunacak query sayfaları buradan set ediliyor --->

<cfset fusebox.circuit = listFirst(attributes.form_action_address,'.')>
<cfset fusebox.fuseaction = listlast(attributes.form_action_address,'.')>




<!---<cfsavecontent variable="control3">
    <cfdump var="#fusebox#">
</cfsavecontent>
<cffile action="write" file = "c:\fusebox.html" output="#control3#"></cffile>
<cfsavecontent variable="control3">
    <cfdump var="#CGI#">
</cfsavecontent>
<cffile action="write" file = "c:\CGI.html" output="#control3#"></cffile>--->

<cfif not isdefined('basket_kur_ekle')>
	<cfinclude template="../functions/get_basket_money_js.cfm">
</cfif>
<cfif not isdefined('add_company_related_action')>
	<cfinclude template="../functions/add_company_related_action.cfm">
</cfif>


<cftry>
    <cfif fusebox.is_special is false>
    	<cfset filePath = application.objects['#attributes.form_action_address#']['filePath']>
        <!---
        <cfsavecontent variable="control4">
            <cfdump var="#attributes#">
        </cfsavecontent>
        <cffile action="write" file = "c:\get_fuseactions.html" output="#control4#"></cffile>
		--->
		<cfset extensions = createObject('component','WDO.development.cfc.extensions')>
		<cfset before_extensions = extensions.get_related_components(attributes.fuseaction, 2, 1, isDefined("attributes.event") ? attributes.event : "list")>
		<cfloop query="before_extensions">
			<cfinclude template="..#before_extensions.COMPONENT_FILE_PATH#">
		</cfloop>
		<cfinclude template="../../#filePath#">
		<cfset after_extensions = extensions.get_related_components(attributes.fuseaction, 2, 2, isDefined("attributes.event") ? attributes.event : "list")>
		<cfloop query="after_extensions">
			<cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
		</cfloop>
    </cfif>
	<cfoutput>İşlem Başarılı</cfoutput>
<cfcatch>
	
        <cfsavecontent variable="control2">
            <cfdump var="#attributes#">
        </cfsavecontent>
        <cffile action="write" file = "c:\attributes.html" output="#control2#"></cffile>
		<cfsavecontent variable="control5">
			<cfdump var="#cfcatch#">
		</cfsavecontent>
		<cffile action="write" file = "c:\cfcatch.html" output="#control5#"></cffile>
	
	<cfoutput>İşlem Hatalı</cfoutput>
</cfcatch>
</cftry>