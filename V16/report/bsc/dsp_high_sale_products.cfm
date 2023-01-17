<!---Sayfada, alış iadeler haric tüm satış faturaları üzerinden en çok satış yapan ürünler listelenir... OZDEN20061006 --->
<cfquery name="GET_TOP_PRODUCT" datasource="#dsn2#">
	SELECT 
		SUM(INV_R.AMOUNT) AS AMOUNT,
		SUM(INV_R.GROSSTOTAL) AS TUTAR,
	<cfif len(session.ep.money2)>
		SUM(INV_R.GROSSTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TUTAR2,
	</cfif>
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		PU.MAIN_UNIT
	FROM 
		INVOICE_ROW INV_R WITH (NOLOCK),
		INVOICE INV WITH (NOLOCK),
		<cfif len(session.ep.money2)>
		INVOICE_MONEY INV_M WITH (NOLOCK),
		</cfif>
		#dsn3_alias#.PRODUCT P WITH (NOLOCK),
		#dsn3_alias#.PRODUCT_UNIT PU WITH (NOLOCK)
		<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT DEPARTMENT WITH (NOLOCK)
		</cfif>
	WHERE
		INV.INVOICE_ID= INV_R.INVOICE_ID
		AND INV.PURCHASE_SALES=1
		AND INV.IS_IPTAL = 0
		AND INV.INVOICE_CAT <> 62
	<cfif len(session.ep.money2)>
		AND INV.INVOICE_ID = INV_M.ACTION_ID
		AND INV_M.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
		AND INV_R.PRODUCT_ID=P.PRODUCT_ID
 	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND INV.COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND INV.CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND INV.SALE_EMP = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND INV.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INV.INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INV.INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INV.INVOICE_DATE <= #attributes.finish_date#
	</cfif>
		AND P.PRODUCT_ID = PU.PRODUCT_ID
		AND PU.IS_MAIN = 1
	GROUP BY P.PRODUCT_ID,P.PRODUCT_NAME,PU.MAIN_UNIT
	ORDER BY TUTAR  DESC
</cfquery>
<cfif GET_TOP_PRODUCT.recordcount>
	<cfquery name="GET_PRODUCT_TOTAL" dbtype="query">
		SELECT SUM(TUTAR) ALL_PRODUCT_TOTAL FROM GET_TOP_PRODUCT
	</cfquery>
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39865.Ürünlere Göre Satışlar'></cfsavecontent>
<cf_seperator title="#head#" id="products1">
 <div id="products1"   style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang_main no ='245.Ürün'></th>
					<th><cf_get_lang_main no ='223.Miktar'></th>
					<th><cf_get_lang_main no ='261.Tutar'><cfoutput>#session.ep.money#</cfoutput></th>
					<cfif len(session.ep.money2)>
					<th><cf_get_lang_main no ='261.Tutar'><cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif GET_TOP_PRODUCT.recordcount>
					<cfset toplam_tutar =0>
					<cfset toplam_tutar2 =0>
					<cfset toplam_miktar =0>
					<cfoutput query="GET_TOP_PRODUCT" maxrows="20">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td nowrap>&nbsp;#PRODUCT_NAME#</td>
						<td align="right" nowrap style="text-align:right;">&nbsp;#TLFormat(AMOUNT)# (#MAIN_UNIT#)
							<cfif len(AMOUNT)>
								<cfset toplam_miktar = toplam_miktar +AMOUNT >
							</cfif>
						</td>
						<td align="right" nowrap style="text-align:right;">&nbsp;#TLFormat(TUTAR)# #session.ep.money#
							<cfif len(TUTAR)>
								<cfset toplam_tutar = wrk_round(toplam_tutar + TUTAR)>
							</cfif>
						</td>
						<cfif len(session.ep.money2)>
						<td align="right" nowrap style="text-align:right;">&nbsp;#TLFormat(TUTAR2)# #session.ep.money2#
							<cfif len(TUTAR2)>
								<cfset toplam_tutar2 = wrk_round(toplam_tutar2 + TUTAR2)>
							</cfif>
						</td>
						</cfif>
					</tr>
					</cfoutput> 
					<cfoutput>
					<tr>
						<td class="txtbold" colspan="2"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" nowrap class="phead" style="text-align:right;">&nbsp;#TLFormat(toplam_miktar)#</td>
						<td align="right" nowrap class="phead" style="text-align:right;">&nbsp;#TLFormat(toplam_tutar)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
						<td align="right" nowrap class="phead" style="text-align:right;">&nbsp;#TLFormat(toplam_tutar2)# #session.ep.money2#</td>
						</cfif>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cf_get_lang_main no ='72.Kayıt Yok'></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cfif GET_TOP_PRODUCT.recordcount>
			<cfif GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL eq 0><cfset GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL = 1></cfif>
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfoutput query="GET_TOP_PRODUCT">
				<cfif GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL eq 0><cfset GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL = 1></cfif>
			<cfif len(PRODUCT_NAME) GT 15>
				<cfset 'item_#currentrow#'="#Left(PRODUCT_NAME,15)#...(%#wrk_round((TUTAR*100)/GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL)#)">
				<cfset 'value_#currentrow#'="#wrk_round(((TUTAR*100)/GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL)/100)#">
			<cfelse>
				<cfset 'item_#currentrow#'="#PRODUCT_NAME#...(%#wrk_round((TUTAR*100)/GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL)#)">
				<cfset 'value_#currentrow#'="#wrk_round(((TUTAR*100)/GET_PRODUCT_TOTAL.ALL_PRODUCT_TOTAL)/100)#">
			  </cfif>
			</cfoutput> 
			<script src="JS/Chart.min.js"></script>
			<canvas id="myCharts18" style="float:left;max-width:600px;max-height:600px;"></canvas>
			<script>
				var ctx = document.getElementById('myCharts18');
					var myCharts18 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: [<cfloop from="1" to="#GET_TOP_PRODUCT.recordcount#" index="cat_index"><cfoutput>"#evaluate("item_#cat_index#")#"</cfoutput>,</cfloop>],
							datasets: [{
								label: "Ürünlere Göre Satışlar",
								backgroundColor: [<cfloop from="1" to="#GET_TOP_PRODUCT.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#GET_TOP_PRODUCT.recordcount#" index="cat_index"><cfoutput>"#evaluate("value_#cat_index#")#"</cfoutput>,</cfloop>],
							}]
						},
						options: {
							legend: {
								display: false
							}
			  			}
				});
			</script>
		</cfif>
	</div>
</div>

