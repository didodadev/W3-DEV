<cf_date tarih = 'attributes.save_date1'>
<cf_date tarih = 'attributes.save_date2'>
<cfset scale_content=form.cons_last>
<cfquery name="ADD_SAVE_TABLE" datasource="#dsn3#">
	INSERT INTO
		SAVE_ACCOUNT_TABLES
		(
			TABLE_NAME,
			TABLE_DATE,
			TABLE_DATE_LAST,
			PERIOD_ID,			
			USER_GIVEN_NAME,
			SOURCE,
			RECORD_DATE,
			RECORD_EMP	
		)
		VALUES(
			'#form.fintab_type#',
			<cfif isDefined('attributes.save_date1') and isdate(attributes.save_date1)>#attributes.save_date1#,<cfelse>#now()#,</cfif>
			<cfif isDefined('attributes.save_date2') and isdate(attributes.save_date2)>#attributes.save_date2#,<cfelse>NULL,</cfif>
			#session.ep.period_id#,
			'#form.user_given_name#',
			<cfif form.fintab_type is "SCALE_TABLE">'#trim(scale_content)#',<cfelse>'#trim(form.cons_last)#',</cfif>
			#now()#,
			#session.ep.userid#
		)
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );<cfelse>window.close();</cfif>
	<cfif isdefined("attributes.fintab_type") and (attributes.fintab_type is "SCALE_TABLE")>			<!--- Mizan Tablosu --->
		window.<cfif not isdefined("attributes.draggable")>opener.parent.</cfif>location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_scale_record';
	<cfelseif isdefined("attributes.fintab_type") and (attributes.fintab_type is "INCOME_TABLE")> 		<!--- Gelir Tablolari --->	
		window.<cfif not isdefined("attributes.draggable")>opener.parent.</cfif>location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_income_table_record';
	<cfelseif isdefined("attributes.fintab_type") and (attributes.fintab_type is "COST_TABLE")> 		<!--- Satis Maliyeti Tablolari --->	
		window.<cfif not isdefined("attributes.draggable")>opener.parent.</cfif>location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_cost_table_record';
	<cfelseif isdefined("attributes.fintab_type") and (attributes.fintab_type is "BALANCE_TABLE")> 	 	<!--- Bilancolar --->	
		window.<cfif not isdefined("attributes.draggable")>opener.parent.</cfif>location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_balance_sheet_record';
	<cfelseif isdefined("attributes.fintab_type") and (attributes.fintab_type is "CASH_FLOW_TABLE")>	<!--- Nakit Akis Tablosu --->	
		window.<cfif not isdefined("attributes.draggable")>opener.parent.</cfif>location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_cash_flow_records';
	<cfelseif isdefined("attributes.fintab_type") and (attributes.fintab_type is "FUND_FLOW_TABLE")>	<!--- Fon Akim Tablosu --->	
		window.<cfif not isdefined("attributes.draggable")>opener.parent.</cfif>location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_fund_flow_records';
	</cfif>
</script>

