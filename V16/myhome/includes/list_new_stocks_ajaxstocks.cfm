<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT_NEW_STOCK" datasource="#DSN2#">
	SELECT 
		STOCKS.PRODUCT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_CODE,
		STOCKS.BARCOD,
		(
			SELECT
				SUM(S2.STOCK_IN-S2.STOCK_OUT)
			FROM
				STOCKS_ROW S2 
			WHERE
				S2.STOCK_ID = STOCKS.STOCK_ID
				AND (S2.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(DATEADD('d',-1,now()))#"> OR S2.PROCESS_DATE IS NULL)
		) AS OLD_AMOUNT
	FROM 
		#dsn3_alias#.STOCKS STOCKS,
		STOCKS_ROW S1
	WHERE
		S1.STOCK_ID=STOCKS.STOCK_ID
	GROUP BY
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_CODE,
		STOCKS.BARCOD
	HAVING
		ISNULL(SUM(S1.STOCK_IN-S1.STOCK_OUT),0)>0
</cfquery>
<cf_flat_list>
	<cfif GET_PRODUCT_NEW_STOCK.recordcount>
		<thead>
			<tr>
				<th width="170"><cf_get_lang_main no='245.Ürün'></td>
				<th width="80"><cf_get_lang_main no='106.Stok Kodu'></td>
				<th><cf_get_lang_main no='221.Barkod'></td>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_PRODUCT_NEW_STOCK">
				<cfif old_amount lte 0>
					<tr>
						<td width="170"><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#PRODUCT_NAME#</a></td>
						<td width="80" height="22"><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_code#</a></td>
						<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#barcod#</a></td>
					</tr>
				</cfif>
			</cfoutput>
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>
