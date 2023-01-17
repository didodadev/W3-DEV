<cfset basket = DeserializeJSON(URLDecode(attributes.basket, "utf-8"))>
	<cfloop array="#DeserializeJSON(basket.basket_json)#" index="bi" item="basket_row">
		<cfloop array="#structKeyArray(basket_row)#" index="ri" item="rk">
			<cfif not (isArray(basket_row[rk]) or isStruct(basket_row[rk]))>
			    <cfset attributes["#rk##bi#"] = basket_row[rk]>
			    <cfset form["#rk##bi#"] = basket_row[rk]>
				<cfif findNoCase("other_money", rk) gt 0 >
					<cfset attributes["#rk#_#bi#"] = basket_row[rk]>
					<cfset form["#rk#_#bi#"] = basket_row[rk]>
				<cfelseif findNoCase("tax_percent", rk) gt 0 >
					<cfset attributes["#rk##bi#"] = basket_row[rk]>
					<cfset form["#rk##bi#"] = basket_row[rk]>
				<cfelseif findNoCase("other_money_value", rk) gt 0 > 
					<cfset attributes["#rk#_#bi#"] = basket_row[rk]>
					<cfset form["#rk#_#bi#"] = basket_row[rk]>
				<cfelseif findNoCase("unit2", rk) gt 0 > 
					<cfset attributes["unit_other#bi#"] = basket_row[rk]>
					<cfset form["unit_other#bi#"] = basket_row[rk]>
					<cfset attributes["#rk##bi#"] = basket_row[rk]>
					<cfset form["#rk##bi#"] = basket_row[rk]>
				<cfelseif findNoCase("other_money_grosstotal", rk) gt 0 > 
					<cfset attributes["#rk##bi#"] = basket_row[rk]>
					<cfset form["#rk##bi#"] = basket_row[rk]>
					<cfset attributes["other_money_gross_total#bi#"] = basket_row[rk]>
					<cfset form["other_money_gross_total#bi#"] = asket_row[rk]>
				<cfelseif findNoCase("deliver_dept", rk) gt 0 > 
					<cfset attributes["#rk##bi#"] = basket_row[rk]>
					<cfset form["#rk##bi#"] = basket_row[rk]>
					<cfset attributes["basket_row_departman#bi#"] = basket_row[rk]>
					<cfset form["basket_row_departman#bi#"] = basket_row[rk]>
				<cfelseif FindNoCase("disc_ount", rk) gt 0 > 
					<cfif listFindNoCase("disc_ount", rk) gt 0 > 
						<cfset attributes["indirim1#bi#"] = basket_row[rk]>
						<cfset form["indirim1#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount2_", rk) gt 0 > 
						<cfset attributes["indirim2#bi#"] = basket_row[rk]>
						<cfset form["indirim2#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount3_", rk) gt 0 > 
						<cfset attributes["indirim3#bi#"] = basket_row[rk]>
						<cfset form["indirim3#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount4_", rk) gt 0 > 
						<cfset attributes["indirim4#bi#"] = basket_row[rk]>
						<cfset form["indirim4#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount5_", rk) gt 0 > 
						<cfset attributes["indirim5#bi#"] = basket_row[rk]>
						<cfset form["indirim5#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount6_", rk) gt 0 > 
						<cfset attributes["indirim6#bi#"] = basket_row[rk]>
						<cfset form["indirim6#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount7_", rk) gt 0 > 
						<cfset attributes["indirim7#bi#"] = basket_row[rk]>
						<cfset form["indirim7#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount8_", rk) gt 0 > 
						<cfset attributes["indirim8#bi#"] = basket_row[rk]>
						<cfset form["indirim8#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount9_", rk) gt 0 > 
						<cfset attributes["indirim9#bi#"] = basket_row[rk]>
						<cfset form["indirim9#bi#"] = basket_row[rk]>
					<cfelseif listFindNoCase("disc_ount10_", rk) gt 0 > 
						<cfset attributes["indirim10#bi#"] = basket_row[rk]>
						<cfset form["indirim10#bi#"] = basket_row[rk]>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>
	<cfset header_value_json = basket.header_value_json>
	<cfloop array="#structKeyArray(header_value_json)#" index="si" item="sk">
		<cfif not ( isArray(header_value_json[sk]) or isStruct(header_value_json[sk]) )>
			<cfset attributes[sk] = header_value_json[sk]>
			<cfset form[sk] = header_value_json[sk]>
		</cfif>
	</cfloop>
	<cfset summary_json = DeserializeJSON(basket.summary_json)>
	<cfset attributes.rows_ = arrayLen(DeserializeJSON(basket.basket_json))>
	<cfloop array="#structKeyArray(summary_json)#" index="si" item="sk">
		<cfif not ( isArray(summary_json[sk]) or isStruct(summary_json[sk]) )>
			<cfset attributes[sk] = summary_json[sk]>
			<cfset form[sk] = summary_json[sk]>
		<cfelse>
			<cfif sk eq 'cash_list' or sk eq 'pos_list'>
				<cfloop array="#summary_json[sk]#" item="item" index="i">
					<cfloop collection="#summary_json[sk][i]#" item="key">
						<cfif key neq 'items'>
							<cfset attributes["#key#_#i#"] = summary_json[sk][i][key]>
							<cfset form["#key#_#i#"] = summary_json[sk][i][key]>
							<cfset attributes["#key##i#"] = summary_json[sk][i][key]>
							<cfset form["#key##i#"] = summary_json[sk][i][key]>
						</cfif>
					</cfloop>
				</cfloop>
			</cfif>
		</cfif>
	</cfloop>

	<cfloop array="#DeserializeJSON(basket.rates_json)#" index="ri" item="rt">
		<cfset attributes["hidden_rd_money_#ri#"] = rt.money_type>
		<cfset attributes["txt_rate1_#ri#"] = rt.rate1>
		<cfset attributes["txt_rate2_#ri#"] = rt.rate2>
	</cfloop>

	<cfset fusebox.circuit = listFirst(attributes.form_action_address,'.')>
	<cfset fusebox.fuseaction = listlast(attributes.form_action_address,'.')>
	
	<cfif not isdefined('basket_kur_ekle')>
		<cfinclude template="../functions/get_basket_money_js.cfm">
	</cfif>

	<cfif not isdefined('add_company_related_action')>
		<cfinclude template="../functions/add_company_related_action.cfm">
	</cfif>

	<!--- <cftry> --->
		<cfif fusebox.is_special is false>
			<cfset filePath = application.objects['#attributes.form_action_address#']['filePath']>
			<cfif structKeyExists(application.objects['#attributes.fuseaction#'], 'ACTION_BEFORE_PATH') and len(application.objects['#attributes.fuseaction#']['ACTION_BEFORE_PATH'])>
				<cfinclude template="../../../documents/#application.objects['#attributes.fuseaction#']['ACTION_BEFORE_PATH']#">
			</cfif>
			<cfinclude template="../../#filePath#">
			<cfif structKeyExists(application.objects['#attributes.fuseaction#'], 'ACTION_BEFORE_PATH') and len(application.objects['#attributes.fuseaction#']['ACTION_AFTER_PATH'])>
				<cfinclude template="../../../documents/#application.objects['#attributes.fuseaction#']['ACTION_AFTER_PATH']#">
			</cfif>
		</cfif>
		<!--- <cfoutput>İşlem Başarılı</cfoutput>
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
	</cftry> --->