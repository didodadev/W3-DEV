<cfsetting showdebugoutput="no">
<cfquery name="GET_SERIAL_INFO_" datasource="#DSN3#">
    WITH CTE1 AS (
		SELECT							
			SERVICE_GUARANTY_NEW.GUARANTY_ID,
			SERVICE_GUARANTY_NEW.REFERENCE_NO,
			SERVICE_GUARANTY_NEW.LOT_NO,
			SERVICE_GUARANTY_NEW.RMA_NO,
			SERVICE_GUARANTY_NEW.IN_OUT,
			SERVICE_GUARANTY_NEW.SERIAL_NO,
			SERVICE_GUARANTY_NEW.STOCK_ID,
            SERVICE_GUARANTY_NEW.PROCESS_ID,
			SERVICE_GUARANTY_NEW.PROCESS_CAT AS PROCESS_CAT,
			SERVICE_GUARANTY_NEW.UNIT_TYPE AS UNIT,
			SERVICE_GUARANTY_NEW.UNIT_ROW_QUANTITY
		FROM
			SERVICE_GUARANTY_NEW
		WHERE
			PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"> AND
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
			WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.wrk_row_id#"> AND
            <cfif not listfind('171,1193,1194',attributes.process_cat)>
				SERVICE_GUARANTY_NEW.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
            </cfif>
			<cfif attributes.process_cat eq 1190>
                PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#">
			<cfelse>
                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
			</cfif>
			<cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
				AND SERVICE_GUARANTY_NEW.SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_id#">
			</cfif>
			<cfif not isdefined("attributes.main_stock_id") or not len(attributes.main_stock_id)>
				AND SERVICE_GUARANTY_NEW.MAIN_STOCK_ID IS NULL
			<cfelse>
				AND SERVICE_GUARANTY_NEW.MAIN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_stock_id#">
			</cfif>
            <cfif attributes.process_cat eq 116>
                AND SERVICE_GUARANTY_NEW.IN_OUT = 1
			</cfif>
			
	),
	CTE2 AS (
		SELECT
			CTE1.*,
			ROW_NUMBER() OVER (	
							ORDER BY
								SERIAL_NO DESC,
								LOT_NO DESC,
								GUARANTY_ID
							) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
		FROM
			CTE1
	)
	SELECT
		CTE2.*
	FROM
		CTE2
	ORDER BY GUARANTY_ID ASC
</cfquery>
<cfsavecontent variable="mystr">
<div class="ui-scroll">
<table class="ui-table-list ui-form">
	<thead>
		<tr class="txtbold">
			<th><cf_get_lang_main no='75.No'></th>
			<cfif isDefined('attributes.reference_control') and attributes.reference_control eq 1><th><cf_get_lang_main no='1382.Referans No'></th></cfif>
			<th><cf_get_lang no='116.Lot'></th>
			<cfif isDefined('attributes.rma_control') and attributes.rma_control eq 1><th>RMA No</th></cfif>
			<th><cf_get_lang_main no='225.Seri'></th>
			<cfif len(GET_SERIAL_INFO_.unit) and GET_SERIAL_INFO_.unit eq 1>
				<th><cf_get_lang dictionary_id='60368.birim miktar'></th>
			</cfif>
			<th><i class="fa fa-minus"></i></th>
		</tr>
	</thead><tbody>
</cfsavecontent>
<cfset last_writen_code = "">
<cfset old_list_ = "">
<cfset say_ =0>
<cfif isDefined('amount_invoice') and len(amount_invoice)>
	<cfset amount_="#amount_invoice#">
<cfelse>
	<cfset amount_="#get_serial_info_.recordcount#">
</cfif>
<cfloop from="1" to="#amount_#" index="i">

	<cfset code_ = "#GET_SERIAL_INFO_.PROCESS_ID[i]#-#GET_SERIAL_INFO_.PROCESS_CAT[i]#-#GET_SERIAL_INFO_.SERIAL_NO[i]#">

	<cfif code_ is not last_writen_code>
		<cfset last_writen_code = code_>
		<cfset say_ = say_+1>
		<cfset mystr=mystr & '<tr id="satirim_#say_+attributes.page#"><td width="25"><input type="hidden" name="guaranty_id_#say_+attributes.page#" value="#GET_SERIAL_INFO_.GUARANTY_ID[i]#"><input type="hidden" name="is_active_#say_+attributes.page#" value="1"><input type="hidden" name="DD" value="#say_+attributes.page#">#say_+attributes.page#</td>'>
		<cfif isDefined('attributes.reference_control') and attributes.reference_control eq 1>
			<cfset mystr=mystr & '<td><div class="form-group"><input type="text" style="width:60px;" name="reference_no_#say_+attributes.page#" value="#GET_SERIAL_INFO_.REFERENCE_NO[i]#" onBlur="kayit_duzenle(#GET_SERIAL_INFO_.GUARANTY_ID[i]#,#say_+attributes.page#);"></div></td>'>
		</cfif>
		<cfset mystr=mystr & '<td><div class="form-group"><input type="text" style="width:60px;" name="lot_no_#say_+attributes.page#" value="#GET_SERIAL_INFO_.LOT_NO[i]#" onBlur="kayit_duzenle(#GET_SERIAL_INFO_.GUARANTY_ID[i]#,#say_+attributes.page#);"></div></td>'>
		<cfif isDefined('attributes.rma_control') and attributes.rma_control eq 1>
			<cfset mystr=mystr & '<td><div class="form-group"><input type="text" style="width:60px;" name="rma_no_#say_+attributes.page#" value="#GET_SERIAL_INFO_.RMA_NO[i]#" onBlur="kayit_duzenle(#GET_SERIAL_INFO_.GUARANTY_ID[i]#,#say_+attributes.page#);"></div></td>'>
		</cfif>
		<cfset mystr=mystr & '<td><div class="form-group"><input type="hidden" name="old_start_no_#say_+attributes.page#" value="#GET_SERIAL_INFO_.SERIAL_NO[i]#">
			<input type="hidden" name="old_lot_no_#say_+attributes.page#" value="#GET_SERIAL_INFO_.LOT_NO[i]#"> 
			#old_list_#
			<input type="text" style="width:110px;" name="start_no_#say_+attributes.page#" value="#GET_SERIAL_INFO_.SERIAL_NO[i]#" onBlur="kayit_duzenle(#GET_SERIAL_INFO_.GUARANTY_ID[i]#,#say_+attributes.page#);"></div></td>'>
		<cfif len(GET_SERIAL_INFO_.unit[i]) and GET_SERIAL_INFO_.unit[i] eq 1>
			<cfset mystr=mystr & '<td><div class="form-group"><input type="text" class="text-right" style="width:110px;" name="unit_row_quantity_#say_+attributes.page#" id="unit_row_quantity_#say_+attributes.page#" value="#tlFormat(GET_SERIAL_INFO_.UNIT_ROW_QUANTITY[i])#" onBlur="quantity_calc(#GET_SERIAL_INFO_.GUARANTY_ID[i]#,#say_+attributes.page#);"></div></td>'>
		</cfif>
		<cfset mystr=mystr & '<td><a  href="javascript://" onClick="record_sil(#GET_SERIAL_INFO_.GUARANTY_ID[i]#,#say_+attributes.page#,#GET_SERIAL_INFO_.PROCESS_CAT[i]#,#attributes.xml_control_del_seril_no#);"><i class="fa fa-minus"></i></a></td>'>
		<cfset mystr=mystr & '</tr>'>
	</cfif>
	
</cfloop>
<cfset mystr=mystr & '</tbody></table></div>'>
<cfoutput>#mystr#</cfoutput>
<script>
	<cfif GET_SERIAL_INFO_.recordcount>
		quantity_calc();
	</cfif>
</script>