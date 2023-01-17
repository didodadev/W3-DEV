<cfsetting showdebugoutput="no">
<cfquery name="get_sales_quota_row" datasource="#DSN3#">
	SELECT 
		SR.*,
		S.COMPANY_ID,
		S.CONSUMER_ID,
		S.IS_SALES_PURCHASE
	FROM
		SALES_QUOTAS S,
		SALES_QUOTAS_ROW SR 
	WHERE 
		S.SALES_QUOTA_ID = SR.SALES_QUOTA_ID
		AND SR.SALES_QUOTA_ROW_ID = #attributes.quota_row_id#
</cfquery>
<cfoutput>
	<cfset all_premium_value = 0>
	<cfset all_extra_stock = 0>
	<cfif get_sales_quota_row.recordcount and (len(get_sales_quota_row.company_id) or len(get_sales_quota_row.consumer_id))>
		<cfquery name="get_all_invoice" datasource="#dsn3#">
			SELECT
				ISNULL(SUM(NET_TOTAL),0) NET_TOTAL,
				ISNULL(SUM(AMOUNT),0) AMOUNT
			FROM
			(
				SELECT
					<cfif get_sales_quota_row.is_sales_purchase eq 1>
						CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS NET_TOTAL,
						CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*IR.AMOUNT ELSE IR.AMOUNT END AS AMOUNT
					<cfelse>
						CASE WHEN INVOICE_CAT IN(62) THEN -1*((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS NET_TOTAL,
						CASE WHEN INVOICE_CAT IN(62) THEN -1*IR.AMOUNT ELSE IR.AMOUNT END AS AMOUNT
					</cfif>
				FROM
					#dsn2_alias#.INVOICE I,
					#dsn2_alias#.INVOICE_ROW IR
				WHERE
					IR.INVOICE_ID = I.INVOICE_ID
					<cfif get_sales_quota_row.is_sales_purchase eq 1>
						AND I.INVOICE_CAT IN (50,52,53,531,58,561,54,55,51,63,48,49)
					<cfelse>
						AND (I.PURCHASE_SALES = 0 OR I.INVOICE_CAT IN (62))
					</cfif>
					AND I.IS_IPTAL = 0
					AND I.NETTOTAL > 0
					<cfif len(get_sales_quota_row.company_id)>
						AND I.COMPANY_ID = #get_sales_quota_row.company_id#
					<cfelse>
						AND I.CONSUMER_ID = #get_sales_quota_row.consumer_id#
					</cfif>
					<cfif len(get_sales_quota_row.stock_id)>
						AND IR.STOCK_ID = #get_sales_quota_row.stock_id#
					</cfif>
					<cfif len(get_sales_quota_row.category_id)>
						AND IR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.PRODUCT_CATID = #get_sales_quota_row.category_id#)
					</cfif>
					<cfif len(get_sales_quota_row.multi_category_id)>
						AND IR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.PRODUCT_CATID IN(#ListDeleteDuplicates(get_sales_quota_row.multi_category_id)#))
					</cfif>
					<cfif len(get_sales_quota_row.brand_id)>
						AND IR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.BRAND_ID = #get_sales_quota_row.brand_id#)
					</cfif>
					<cfif len(get_sales_quota_row.supplier_id)>
						AND IR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.COMPANY_ID = #get_sales_quota_row.supplier_id#)
					</cfif>
			)T1
		</cfquery>
		<cfform name="add_quota_result_#attributes.quota_row_id#" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_quota_result&quota_row_id=#attributes.quota_row_id#">
		<table width="100%">
			<tr>
				<td width="300" rowspan="3">
					
					<cfsavecontent variable="message_plan"><cf_get_lang_main no='1457.Planlanan'></cfsavecontent>
					<cfsavecontent variable="message_plan2"><cf_get_lang no ='52.Gerçekleşen'></cfsavecontent>
						<script src="JS/Chart.min.js"></script>
					<canvas id="myChart" style="float:left;max-height:450px;max-width:450px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: 'bar',
							data: {
								labels: [<cfoutput>"#message_plan#","#message_plan2#"</cfoutput>,],
								datasets: [{
									label: "grafik durum",
									backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfoutput>"#NumberFormat(get_sales_quota_row.row_total,'00.00')#","#NumberFormat(get_all_invoice.net_total,'00.00')#"</cfoutput>],
								}]
							},
							options: {}
					});
				</script>	
				</td>
				<td valign="top" colspan="2">
					<table cellpadding="2" cellspacing="1" class="color-header">
						<tr class="color-list">
							<td class="txtboldblue" width="130">Gerçekleşen Tutar</td>
							<td class="txtboldblue" width="70">Min %</td>
							<td class="txtboldblue" width="70">Max %</td>
							<td class="txtboldblue" width="130">Gerçekleşen Miktar</td>
							<td class="txtboldblue" width="110">Prim Hakedişi</td>
							<td class="txtboldblue" width="110">Mal Fazlası</td>
						</tr>
						<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td align="right" style="text-align:right;">#TLFormat(get_all_invoice.net_total)#</td>
							<td align="right" style="text-align:right;">
								<cfif get_sales_quota_row.row_total gt 0>
									#TLFormat(get_all_invoice.net_total*100/get_sales_quota_row.row_total)#									
								</cfif>
							</td>
							<td align="right" style="text-align:right;">
								<cfif get_sales_quota_row.row_total_max gt 0>
									#TLFormat(get_all_invoice.net_total*100/get_sales_quota_row.row_total_max)#									
								</cfif>
							</td>
							<td align="right" style="text-align:right;">#TLFormat(get_all_invoice.amount)#</td>
							<td align="right" style="text-align:right;">
								<cfif get_all_invoice.net_total gte get_sales_quota_row.row_total>
									#TLFormat(get_all_invoice.net_total*get_sales_quota_row.row_premium_percent/100)#
									<cfset all_premium_value = get_all_invoice.net_total*get_sales_quota_row.row_premium_percent/100>
									<cfset all_premium_value_other = get_all_invoice.net_total*get_sales_quota_row.row_premium_percent/100>
								<cfelse>
									#TLFormat(0)#
									<cfset all_premium_value = 0>
								</cfif>
								<input type="hidden" name="all_premium_value_#attributes.quota_row_id#" id="all_premium_value_#attributes.quota_row_id#" value="#all_premium_value#">
							</td>
							<td align="right" style="text-align:right;">
								<cfif get_all_invoice.amount gte get_sales_quota_row.quantity>
									#TLFormat(get_sales_quota_row.row_extra_stock)#
									<cfset all_extra_stock = get_sales_quota_row.row_extra_stock>
								<cfelse>
									#TLFormat(0)#
									<cfset all_extra_stock = 0>
								</cfif>
								<input type="hidden" name="all_extra_stock_#attributes.quota_row_id#" id="all_extra_stock_#attributes.quota_row_id#" value="#all_extra_stock#">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr valign="top" height="150">
				<td>
					<cfif isdefined('attributes.premium_stock_id') and len(attributes.premium_stock_id)>
						<cfquery name="get_stock_info" datasource="#dsn3#">
							SELECT PRODUCT_NAME,PRODUCT_ID,STOCK_ID FROM STOCKS WHERE STOCK_ID = #attributes.premium_stock_id#
						</cfquery>
					</cfif>
					<cfif isdefined("get_stock_info") and get_stock_info.recordcount>
						<cfset row_stock_id = get_stock_info.stock_id>
						<cfset row_product_id = get_stock_info.product_id>
						<cfset row_product_name = get_stock_info.product_name>
					<cfelse>
						<cfset row_stock_id = ''>
						<cfset row_product_id = ''>
						<cfset row_product_name = ''>
					</cfif>
					<br/>
					<cf_get_lang_main no = '245.Ürün'>
					<input type="hidden" name="product_id_#attributes.quota_row_id#" id="product_id_#attributes.quota_row_id#" value="#row_product_id#">
					<input type="hidden" name="stock_id_#attributes.quota_row_id#" id="stock_id_#attributes.quota_row_id#" value="#row_stock_id#">
					<input type="text" name="product_name_#attributes.quota_row_id#" id="product_name_#attributes.quota_row_id#" style="width:150px;" value="#row_product_name#">
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=all.product_id_#attributes.quota_row_id#&field_id=all.stock_id_#attributes.quota_row_id#&field_name=all.product_name_#attributes.quota_row_id#','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
					<cfset message = 'Fark ve Primler Listesine Gönder'>
					<cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function='kontrol_#attributes.quota_row_id#()'>
				</td>
			</tr>
			<tr valign="top" id="quota_result_info#attributes.quota_row_id#" style="display:none">
				<td colspan="2" ><div id="show_quota_result_info#attributes.quota_row_id#"></div></td>
			</tr>
		</table>
		</cfform>
	<cfelse>
		<table width="100%">
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
			</tr>
		</table>
	</cfif>
	<script type="text/javascript">
		function kontrol_#attributes.quota_row_id#()
		{
			kontrol_info = 0;
			var get_period_count_main = wrk_safe_query('slsp_get_period_count_main','dsn3',0, #attributes.quota_row_id#);
			<cfif all_premium_value gt 0>
				kontrol_info = 1;
				if(document.getElementById('product_id_#attributes.quota_row_id#').value == '' || document.getElementById('product_name_#attributes.quota_row_id#').value == '')
				{
					alert("<cf_get_lang_main no ='313.Ürün Seçmelisiniz'> !");
					return false;
				}
				var get_period_count = wrk_safe_query('slsp_get_period_count','dsn3',0,#attributes.quota_row_id#);
				if(get_period_count.PERIOD_COUNT >= get_period_count_main.PERIOD_COUNT)
				{
					alert("Prim Hesaplama Periyodunu Aştınız. Hesaplama Yapamazsınız !");
					return false;
				}
			</cfif>
			<cfif all_extra_stock gt 0>
				var get_period_count2 = wrk_safe_query('slsp_get_period_count_2','dsn3',0,#attributes.quota_row_id#);
				if(get_period_count2.PERIOD_COUNT >= get_period_count_main.PERIOD_COUNT)
				{
					alert("Prim Hesaplama Periyodunu Aştınız. Hesaplama Yapamazsınız !");
					return false;
				}
			</cfif>
			gizle_goster(quota_result_info#attributes.quota_row_id#);
			AjaxFormSubmit('add_quota_result_#attributes.quota_row_id#','show_quota_result_info#attributes.quota_row_id#',0,'Kaydediliyor','Kaydedildi!');
			return false;
		}
	</script>
</cfoutput>

