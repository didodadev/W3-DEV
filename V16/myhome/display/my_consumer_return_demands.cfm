<cfsetting showdebugoutput="no">
<cfquery name="GET_RETURN_LIST" datasource="#DSN3#">
	SELECT
		SPR.*,
		ISNULL(SPRR.IS_SHIP,0) IS_SHIP,
		SPRR.AMOUNT,
		SPRR.RETURN_ROW_ID,
		SPRR.RETURN_TYPE,
		SPRR.RETURN_STAGE,
		SPRR.RETURN_CANCEL_TYPE,
		SPRR.STOCK_ID
	FROM
		SERVICE_PROD_RETURN SPR,
		SERVICE_PROD_RETURN_ROWS SPRR
	WHERE
		SPR.RETURN_ID = SPRR.RETURN_ID AND
		SPR.SERVICE_CONSUMER_ID = #attributes.cid#
	ORDER BY
		SPR.RECORD_DATE
</cfquery>
<table class="ajax_list">
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='31994.İade Nedeni'></th>
			<th><cf_get_lang dictionary_id='31997.Red Nedeni'></th>
			<th width="40"><cf_get_lang dictionary_id='57756.Durum'></th>
		</tr>
	</thead>	
	<tbody>
	<cfif get_return_list.recordcount>
		<cfset return_type_list = ''>
		<cfset return_cancel_type_list = ''>
		<cfset process_list = ''>
		<cfset stock_list = ''>
		<cfoutput query="get_return_list" startrow="1" maxrows="#attributes.maxrows#">
			<cfif len(return_type) and not listfind(return_type_list,return_type)>
				<cfset return_type_list = listappend(return_type_list,return_type)>
			</cfif>
			<cfif len(return_stage) and not listfind(process_list,return_stage)>
				<cfset process_list=listappend(process_list,return_stage)>
			</cfif>
			<cfif len(return_type) and not listfind(return_cancel_type_list,return_cancel_type)>
				<cfset return_cancel_type_list = listappend(return_cancel_type_list,return_cancel_type)>
			</cfif>
			<cfif len(stock_id) and not listfind(stock_list,stock_id,',')>
				<cfset stock_list = listappend(stock_list,stock_id)>
			</cfif>
		</cfoutput>
		<cfif listlen(return_type_list)>
			<cfset return_type_list=listsort(return_type_list,"numeric","ASC",",")>
			<cfquery name="GET_RETURN_TYPES" datasource="#DSN3#">
				SELECT RETURN_CAT_ID,RETURN_CAT FROM SETUP_PROD_RETURN_CATS WHERE RETURN_CAT_ID IN (#return_type_list#) ORDER BY RETURN_CAT_ID
			</cfquery>
			<cfset return_type_list = listsort(listdeleteduplicates(valuelist(get_return_types.return_cat_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(return_cancel_type_list)>
			<cfset return_cancel_type_list=listsort(return_cancel_type_list,"numeric","ASC",",")>
			<cfquery name="GET_RETURN_CANCEL_TYPES" datasource="#DSN3#">
				SELECT CANCEL_CAT_ID, CANCEL_CAT FROM SETUP_PROD_CANCEL_CATS WHERE CANCEL_CAT_ID IN (#return_cancel_type_list#) ORDER BY CANCEL_CAT_ID
			</cfquery>
			<cfset return_cancel_type_list = listsort(listdeleteduplicates(valuelist(get_return_cancel_types.cancel_cat_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(process_list)>
			<cfquery name="GET_PROCESS_NAME" datasource="#DSN#">
				SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
			<cfset process_list = listsort(listdeleteduplicates(valuelist(get_process_name.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(stock_list)>
			<cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
			<cfquery name="GET_STOCKS" datasource="#DSN3#">
				SELECT PRODUCT_NAME,PROPERTY,STOCK_ID,PRODUCT_ID,PRODUCT_CODE_2 FROM STOCKS WHERE STOCK_ID IN (#stock_list#) ORDER BY STOCK_ID
			</cfquery>
			<cfset stock_list = listsort(listdeleteduplicates(valuelist(get_stocks.stock_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_return_list" startrow="1" maxrows="#attributes.maxrows#">
			<tr>
				<td width="55">#currentrow#</td>
				<td width="60">#dateformat(record_date,dateformat_style)#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&iid=#invoice_id#','page');" class="tableyazi">#paper_no#</a></td>
				<td>#get_stocks.product_code_2[listfind(stock_list,get_return_list.stock_id,',')]#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_stocks.product_id[listfind(stock_list,get_return_list.stock_id,',')]#','medium');" class="tableyazi">#get_stocks.product_name[listfind(stock_list,get_return_list.stock_id,',')]#</a></td>
				<td style="text-align:right;">#amount#</td>
				<td><cfif len(return_stage)>#get_process_name.stage[listfind(process_list,return_stage,',')]#</cfif></td>
				<td><cfif len(return_type)>#get_return_types.return_cat[listfind(return_type_list,return_type,',')]#</cfif></td>
				<td><cfif len(return_cancel_type)>#get_return_cancel_types.cancel_cat[listfind(return_cancel_type_list,return_cancel_type,',')]#</cfif></td>
				<td>
					<cfif get_return_list.is_ship eq 0>
						<cfif len(return_cancel_type)>
							<cf_get_lang dictionary_id='29537.Red'>
						<cfelse>
							<cf_get_lang dictionary_id='30984.Beklemede'>
						</cfif>
					<cfelseif get_return_list.is_apply eq 1>
						<cf_get_lang dictionary_id='30974.Kabul'>
					</cfif>
				</td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>	
		 </cfif>
    </tbody>
</table>

