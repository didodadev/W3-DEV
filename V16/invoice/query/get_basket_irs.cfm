<cfinclude template = "../../objects/query/session_base.cfm">
<cfset included_irs = 0>
<cfset attributes.ship_ids = "">
<cfset pre_period_ships = "">
<cfset old_period_row_ship_info = "">
<!--- <cfset attributes.ship_methods = ""> --->
<!--- sepetden gelen fatura satırlarını loop ederek irsaliye ve period id ler alınır --->
<cfif not (isdefined("attributes.order_id") and len(attributes.order_id)) and not (isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi))>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfif isdefined("attributes.row_ship_id#i#") and evaluate("listfirst(attributes.row_ship_id#i#,';')")>
			<cfset included_irs = 1>
			<!--- row_ship_id tek elemanlı ise, standart aktif donemdeki irsaliye id sini tutuyordur, 2 elemanlı ise fatura ekranlarında
			irsaliye seçimiyle oluşmustur ve hem irsaliye id hemde period id değerlerini tutar--->
			<cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 1 and not listfind(attributes.ship_ids,evaluate("attributes.row_ship_id#i#"))>
				<cfset attributes.ship_ids = listappend(attributes.ship_ids,evaluate("listfirst(attributes.row_ship_id#i#,';')"))>
			<cfelseif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2 and evaluate("listlast(attributes.row_ship_id#i#,';')") eq session_base.period_id and not listfind(attributes.ship_ids,evaluate("listfirst(attributes.row_ship_id#i#,';')"))>
				<cfset attributes.ship_ids = listappend(attributes.ship_ids,evaluate("listfirst(attributes.row_ship_id#i#,';')"))>
			<cfelseif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2 and evaluate("listlast(attributes.row_ship_id#i#,';')") neq session_base.period_id and not listfind(pre_period_ships,evaluate("listfirst(attributes.row_ship_id#i#,';')"))>
				<cfset pre_period_ships = listappend(pre_period_ships,evaluate("listfirst(attributes.row_ship_id#i#,';')"))>
				<cfset pre_period_id = evaluate("listlast(attributes.row_ship_id#i#,';')")>
				<cfset old_period_row_ship_info = ListAppend(old_period_row_ship_info,evaluate("attributes.row_ship_id#i#"),",")>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfif included_irs>
	<!--- bulunan dönemden çekilen irsaliye bilgileri alınır --->
	<cfset attributes.ship_ids = listsort(attributes.ship_ids,'numeric','desc')>
	<cfif len(attributes.ship_ids)>
		<cfquery name="get_irs" datasource="#dsn2#">
			SELECT SHIP_NUMBER,SHIP_ID FROM SHIP WHERE SHIP_ID IN (#attributes.ship_ids#) ORDER BY SHIP_ID
		</cfquery>
	</cfif>
	<!--- önceki dönemden çekilen irsaliye bilgileri alınır --->
	<cfset pre_period_ships = listsort(pre_period_ships,'numeric','desc')>
	<cfif len(pre_period_ships)>
			<cfquery name="GET_PERIOD" datasource="#dsn2#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID = #pre_period_id# AND OUR_COMPANY_ID = #session_base.company_id#
			</cfquery> 
			<cfif GET_PERIOD.recordcount>
				<cfset pre_period_dsn = '#dsn#_#GET_PERIOD.PERIOD_YEAR#_#GET_PERIOD.OUR_COMPANY_ID#'>
				<cfquery name="get_irs2" datasource="#dsn2#">
					SELECT SHIP_NUMBER,SHIP_ID FROM #pre_period_dsn#.SHIP WHERE SHIP_ID IN (#pre_period_ships#) ORDER BY SHIP_ID
				</cfquery>
			</cfif>
	</cfif>
</cfif>
