<cf_xml_page_edit fuseact="objects.popup_add_serial_operations">
<cfsetting showdebugoutput="yes">
<cfif isdefined("is_serial_operation_warning") and is_serial_operation_warning is '1'>
	<cfquery name="get_emails">
		SELECT EMPLOYEE_EMAIL FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (1,23,45)
	</cfquery>
</cfif>
<cfquery name="get_rows" datasource="#dsn3#">
    SELECT
        SERIAL_NO,
        RECORD_DATE,
        GUARANTY_ID,
		LOT_NO,
		 UNIT_ROW_QUANTITY
    FROM
        SERVICE_GUARANTY_NEW
    WHERE
        PROCESS_CAT IN (110,113,76,77,81,82,84,114,115,171,811,1190,116) AND
        STOCK_ID = #attributes.stock_id#
        <cfif len(attributes.spect_id) and attributes.process_cat neq 116>
            AND SPECT_ID = #attributes.spect_id#
        </cfif>
        AND IN_OUT = 1
        --AND SERIAL_NO NOT IN (SELECT S2.SERIAL_NO FROM SERVICE_GUARANTY_NEW S2 WHERE <cfif attributes.process_cat eq 116> S2.IN_OUT = 0 AND<cfelse> S2.IS_SALE = 1 AND </cfif> S2.STOCK_ID = #attributes.stock_id# <cfif len(attributes.spect_id) and attributes.process_cat neq 116>AND S2.SPECT_ID = #attributes.spect_id#</cfif>)
    ORDER BY
        GUARANTY_ID DESC
</cfquery>
<cfquery name="get_rows2" datasource="#dsn3#">
    SELECT
        SERIAL_NO,
		SUM(UNIT_ROW_QUANTITY) AS UNIT_ROW_QUANTITY
    FROM
        SERVICE_GUARANTY_NEW
    WHERE
        PROCESS_CAT IN (1194,71,76,70,88) AND
        STOCK_ID = #attributes.stock_id#
        <cfif len(attributes.spect_id) and attributes.process_cat neq 116>
            AND SPECT_ID = #attributes.spect_id#
        </cfif>
        AND IN_OUT = 0
	GROUP BY
		SERIAL_NO
</cfquery>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_rows.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<cfset url_str = "objects.popup_add_serial_operations_list">
<cfset url_str = "#url_str#&spect_id=#attributes.spect_id#">
<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
<cfif isdefined("attributes.wrk_row_id")>
	<cfset url_str = "#url_str#&wrk_row_id=#attributes.wrk_row_id#">
</cfif>
<cfif isdefined("attributes.process_id")>
	<cfset url_str = "#url_str#&process_id=#attributes.process_id#">
</cfif>
<cfif isdefined("attributes.process_number")>
	<cfset url_str = "#url_str#&process_number=#attributes.process_number#">
</cfif>
<cfif isdefined("attributes.LOT_NO")>
	<cfset url_str = "#url_str#&lot_no=#attributes.LOT_NO#">
</cfif>
<cfif isdefined("attributes.quantity")>
	<cfset url_str = "#url_str#&quantity=#attributes.quantity#">
</cfif>
<cfset url_str = "#url_str#&process_cat=#attributes.process_cat#">
<cf_medium_list_search title='Hızlı Seri Giriş Listesi: <cfoutput>#get_product_name(stock_id:attributes.stock_id)#</cfoutput>'></cf_medium_list_search>
<cfform name="add_" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action">
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57637.Seri No'></th>
			<th><cf_get_lang dictionary_id='45498.Lot No'></th>
			<th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
			<th width="200"></th>
			<th width="20"><input type="checkbox" name="all_select" id="all_select" onClick="wrk_select_all('all_select','guaranty_ids');"></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_rows.recordcount>
			<cfoutput>
                <input type="hidden" value="multi_add" name="action_type" id="action_type" />
                <input type="hidden" value="#attributes.stock_id#" name="stock_id" id="stock_id" />
                <input type="hidden" value="#attributes.spect_id#" name="spect_id" id="spect_id" />
                <input type="hidden" value="#attributes.process_cat#" name="process_cat" id="process_cat" />
				<input type="hidden" value="#attributes.lot_no#" name="lot_no" />
				<cfif isdefined("attributes.quantity")><input type="hidden" value="#attributes.quantity#" name="quantity"></cfif>
                <cfif isdefined("attributes.process_id")><input type="hidden" value="#attributes.process_id#" name="process_id" id="process_id" /></cfif>
                <cfif isdefined("attributes.process_number")><input type="hidden" value="#attributes.process_number#" name="process_number" id="process_number" /></cfif>
                <cfif isdefined("attributes.amount")><input type="hidden" name="amount" id="amount" value="#attributes.amount#" /></cfif>
                <cfif isdefined("attributes.wrk_row_id")><input type="hidden" value="#attributes.wrk_row_id#" name="wrk_row_id" id="wrk_row_id" /></cfif>
                <cfif isdefined("attributes.main_process_cat")><input type="hidden" name="main_process_cat" id="main_process_cat" value="#attributes.main_process_cat#" /></cfif>
                <cfif isdefined("attributes.main_process_id")><input type="hidden" name="main_process_id" id="main_process_id" value="#attributes.main_process_id#" /></cfif>
                <cfif isdefined("attributes.main_process_no")><input type="hidden" name="main_process_no" id="main_process_no" value="#attributes.main_process_no#" /></cfif>
                <cfif isdefined("attributes.main_serial_no")><input type="hidden" name="main_serial_no" id="main_serial_no" value="#attributes.main_serial_no#" /></cfif>
				<cfif isdefined("attributes.is_change")><input type="hidden" name="is_change" id="is_change" value="#attributes.is_change#" /></cfif>
			</cfoutput>
			<cfoutput query="get_rows" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<td>#serial_no#</td>
                    <td>#lot_no#</td>
					<td width="65">#dateformat(record_date,dateformat_style)#</td>
					<td>
						<cfset dsp = 0>
						<cfif get_rows2.recordCount gt 0>
							<cfloop query="get_rows2"> 
								<cfif get_rows.SERIAL_NO eq get_rows2.SERIAL_NO>
									<cfset diff = get_rows.UNIT_ROW_QUANTITY - get_rows2.UNIT_ROW_QUANTITY>
									<cfif diff gt 0 and diff gte attributes.quantity >  
									<cfelse>
										<cfset dsp = 1>
									</cfif>
								<cfelse>
									<cfif get_rows.UNIT_ROW_QUANTITY gte attributes.quantity>
									<cfelse>
										<cfset dsp = 1>
									</cfif>
								</cfif>
							</cfloop>
						<cfelse>
							<cfif get_rows.UNIT_ROW_QUANTITY gte attributes.quantity>
							<cfelse>
								<cfset dsp = 1>
							</cfif>
						</cfif>
					</td>
					<td width="20"><input type="checkbox" value="#GUARANTY_ID#" name="guaranty_ids" id="guaranty_ids" <cfif dsp eq 1> disabled</cfif> /></td>
				</tr>
			</cfoutput>
			<tr>
				<td colspan="4" style="text-align:right;"><input type="submit" value="Kaydet" name="add_button" id="add_button"/></td>
			</tr>
		<cfelse>
		<tr>
			<td colspan="4"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
		</tr>
		</cfif>
	</tbody>
</cf_medium_list>
</cfform>
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url_str#">

