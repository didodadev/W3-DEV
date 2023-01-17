<cfsetting showdebugoutput="no">
<cfquery name="GET_SERVICE_OPERATION" datasource="#DSN3#">
	SELECT 
		 SERVICE_OPERATION.PRODUCT_NAME,
		 SERVICE_OPERATION.PRODUCT_ID,
		 SERVICE_OPERATION.STOCK_ID,
		 SERVICE_OPERATION.SERVICE_ID,
		 SERVICE.SERVICE_HEAD
	FROM 
		SERVICE_OPERATION,
		SERVICE
	WHERE
		SERVICE.SERVICE_ID = SERVICE_OPERATION.SERVICE_ID AND
		(SERVICE_OPERATION.STOCK_ID IS NOT NULL OR SERVICE_OPERATION.PRODUCT_ID IS NOT NULL)
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_service_operation.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang_main no="245.ürün"></th>
			<th><cf_get_lang_main no="244.servis"></th>
			<th style="text-align:right;"><cf_get_lang_main no="40.stok"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_service_operation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_product&pid=#product_id#','medium');" class="tableyazi">#product_name#</a></td>
				<td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#" class="tableyazi">#service_head#</a></td>
				<td style="text-align:right;">
					<cfquery name="GET_STOCK" datasource="#DSN2#">
						SELECT
							SUM(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK
						FROM
							STOCKS_ROW
						WHERE
							<cfif len(stock_id)>
								STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
							<CFELSE>
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
							</cfif>							
					</cfquery>
					<cfif get_stock.product_stock gt 0>
                        #get_stock.product_stock#
                    <cfelse>
                        <font color="FF0000">#get_stock.product_stock#</font>
                    </cfif>
				</td>
			</tr>
		</cfoutput>
		<cfif not get_service_operation.recordcount>
			<tr>
			  <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
