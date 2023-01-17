<cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
	SELECT * FROM SHIP WHERE SHIP_ID = #attributes.ship_id#
</cfquery>
<cfif get_upd_purchase.recordcount>
	<cfquery name="GET_IMPORT_INV" datasource="#DSN2#">
		SELECT IMPORT_INVOICE_ID, IMPORT_PERIOD_ID FROM INVOICE_SHIPS WHERE SHIP_ID = #get_upd_purchase.ship_id# AND IMPORT_INVOICE_ID IS NOT NULL
	</cfquery>
	<cfif GET_IMPORT_INV.recordcount>
		<cfset inv_id_list = "">
		<cfset inv_id_list2 = "">
		<cfset inv_number_list = "">
		<cfset inv_period = ""> 
		<cfoutput query="GET_IMPORT_INV">
			<cfif IMPORT_PERIOD_ID eq session.ep.period_id>
				<cfset inv_id_list=listappend(inv_id_list,IMPORT_INVOICE_ID)>
			<cfelse>
				<cfset inv_id_list2=listappend(inv_id_list2,IMPORT_INVOICE_ID)>
				<cfset inv_period=GET_IMPORT_INV.IMPORT_PERIOD_ID>
			</cfif>
		</cfoutput>
		<cfif len(inv_id_list)>
			<cfquery name="GET_INV_DETAIL" datasource="#DSN2#">
				SELECT INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID IN (#inv_id_list#)
			</cfquery>
			<cfif GET_INV_DETAIL.recordcount>
				<cfset inv_number_list =  listappend(inv_number_list,valuelist(GET_INV_DETAIL.INVOICE_NUMBER))>
			</cfif>
		</cfif>	
		<cfif len(inv_id_list2)>
			<cfquery name="GET_PERIOD" datasource="#DSN2#">
				SELECT OUR_COMPANY_ID, PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #inv_period# AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfquery> 
			<cfif get_period.recordcount>
				<cfset onceki_donem = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
				<cfquery name="GET_INV_DETAIL2" datasource="#DSN2#">
					SELECT INVOICE_NUMBER FROM #onceki_donem#.INVOICE WHERE INVOICE_ID IN (#inv_id_list2#)
				</cfquery>
				<cfif GET_INV_DETAIL2.recordcount>
					<cfset inv_number_list =  listappend(inv_number_list,valuelist(GET_INV_DETAIL2.INVOICE_NUMBER))>
				</cfif>
			</cfif>
		</cfif>	
	</cfif>
</cfif>
