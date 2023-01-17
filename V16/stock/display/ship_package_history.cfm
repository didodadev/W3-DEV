<cfsetting showdebugoutput="no">
<cfquery name="get_package_list_history" datasource="#dsn2#">
	SELECT 
		SPLH.*,
		S.STOCK_CODE,
		S.PRODUCT_NAME
	FROM
		SHIP_PACKAGE_LIST_HISTORY SPLH,
		#dsn3_alias#.STOCKS S
	WHERE
		SPLH.STOCK_ID = S.STOCK_ID AND
		SPLH.SHIP_ID = #attributes.SHIP_ID#
</cfquery>
<!--- <cfdump var="#get_package_list_history#"> --->
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id ='45693.Stok Adı'></th>
				<th><cf_get_lang dictionary_id ='58082.Adet'></th>
				<th><cf_get_lang dictionary_id ='45692.Kontrol Edilen'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_package_list_history.recordcount>
				<cfset CONTROL_ID_LIST = ''>
				<cfoutput query="get_package_list_history">
					<cfif not ListFind(CONTROL_ID_LIST,CONTROL_ID,',')>
					<tr>
						<td class="txtbold" colspan="5"><cf_get_lang dictionary_id='57483.Kayıt'>&nbsp;:#get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</td>
					</tr>
					<cfset CONTROL_ID_LIST = ListAppend(CONTROL_ID_LIST,CONTROL_ID,',')>
					</cfif>
					<tr>
						<td>#STOCK_CODE#</td>
						<td>#PRODUCT_NAME#</td>
						<td>#AMOUNT#</td>
						<td>#CONTROL_AMOUNT#</td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_flat_list>
