<cfquery name="GET_ALL_STOCK" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#" maxrows="20">
	SELECT DISTINCT			
		SUM(STOCK_IN-STOCK_OUT) AS STOCK_AMOUNT,
		S.PRODUCT_NAME,
		S.PRODUCT_ID
	FROM        
		STOCKS_ROW AS SR WITH (NOLOCK),
		#dsn3_alias#.STOCKS S WITH (NOLOCK)
	<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
	</cfif>
	WHERE
		SR.STOCK_ID=S.STOCK_ID
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND S.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND S.PRODUCT_MANAGER = #attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.finish_date)>
		AND SR.PROCESS_DATE < = #attributes.finish_date#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND SR.STORE = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	GROUP BY 
		S.PRODUCT_ID,S.PRODUCT_NAME
	ORDER BY 
		STOCK_AMOUNT DESC
</cfquery>
<cfif GET_ALL_STOCK.recordcount>
	<cfset product_list = listsort(valuelist(GET_ALL_STOCK.PRODUCT_ID),'numeric','desc',',')>
	<cfquery name="GET_INV_SALE" datasource="#dsn2#">
		SELECT
			SUM(INV_R.GROSSTOTAL) AS TOTAL,
			SUM(INV_R.AMOUNT) AS AMOUNT,
			<cfif len(session.ep.money2)>
			SUM(INV_R.GROSSTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TOTAL2,
			</cfif>
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME
		FROM
			INVOICE WITH (NOLOCK),
			INVOICE_ROW INV_R WITH (NOLOCK),
			#dsn3_alias#.PRODUCT PRODUCT WITH (NOLOCK)
			<cfif len(session.ep.money2)>
			,INVOICE_MONEY INV_M WITH (NOLOCK)
			</cfif>
		WHERE
			INVOICE.INVOICE_ID=INV_R.INVOICE_ID
			AND INV_R.PRODUCT_ID = PRODUCT.PRODUCT_ID
			AND PRODUCT.PRODUCT_ID IN (#product_list#)
		<cfif len(session.ep.money2)>
			AND INVOICE.INVOICE_ID = INV_M.ACTION_ID
			AND INV_M.MONEY_TYPE = '#session.ep.money2#'
		</cfif>
			AND INVOICE.PURCHASE_SALES = 1
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND INVOICE_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND INVOICE_DATE <= #attributes.finish_date#
		</cfif>
	GROUP BY PRODUCT.PRODUCT_ID,PRODUCT.PRODUCT_NAME
	ORDER BY TOTAL DESC
	</cfquery>
	<cfquery name="GET_INV_PURCHASE" datasource="#dsn2#">
		SELECT
			SUM(INV_R.GROSSTOTAL) AS TOTAL,
			SUM(INV_R.AMOUNT) AS AMOUNT,
			<cfif len(session.ep.money2)>
			SUM(INV_R.GROSSTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TOTAL2,
			</cfif>
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME
		FROM
			INVOICE WITH (NOLOCK),
			INVOICE_ROW INV_R WITH (NOLOCK),
			#dsn3_alias#.PRODUCT PRODUCT WITH (NOLOCK)
			<cfif len(attributes.branch_id)>
			,#dsn_alias#.DEPARTMENT DEPARTMENT WITH (NOLOCK)
			</cfif>
			<cfif len(session.ep.money2)>
			,INVOICE_MONEY INV_M WITH (NOLOCK)
			</cfif>
		WHERE
			INVOICE.INVOICE_ID=INV_R.INVOICE_ID
			AND INV_R.PRODUCT_ID =PRODUCT.PRODUCT_ID
			AND PRODUCT.PRODUCT_ID IN (#product_list#)
		<cfif len(session.ep.money2)>
			AND INVOICE.INVOICE_ID = INV_M.ACTION_ID
			AND INV_M.MONEY_TYPE = '#session.ep.money2#'
		</cfif>
			AND INVOICE.PURCHASE_SALES = 0
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			AND INVOICE.COMPANY_ID = #attributes.company_id#
		<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
			AND INVOICE.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			AND INVOICE.SALE_EMP = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.branch_id)>
			AND INVOICE.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID IN(#attributes.branch_id#)
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND INVOICE_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND INVOICE_DATE <= #attributes.finish_date#
		</cfif>
		GROUP BY PRODUCT.PRODUCT_ID,PRODUCT.PRODUCT_NAME
		ORDER BY TOTAL DESC
	</cfquery>
	<cfscript>
	//urunlerin satıs ve alıs bilgileri degiskenlere atanıyor...
		for(k=1; k lte get_all_stock.recordcount; k=k+1)
		{
			'diff_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#' = 0;
			'diff_total_#GET_ALL_STOCK.PRODUCT_ID[k]#' = 0;
			//satıs faturaları
			for(tt=1; tt lte GET_INV_SALE.recordcount; tt=tt+1)
			{
				if( get_all_stock.PRODUCT_ID[k] eq GET_INV_SALE.PRODUCT_ID[tt]) 
				{
					'prod_sale_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#' = GET_INV_SALE.AMOUNT[tt];
					'prod_sale_total_#GET_ALL_STOCK.PRODUCT_ID[k]#' = GET_INV_SALE.TOTAL[tt];
					if(isdefined('session.ep.money2') and len(session.ep.money2))
						'prod_sale_total2_#GET_ALL_STOCK.PRODUCT_ID[k]#' = GET_INV_SALE.TOTAL2[tt];
					break;
				}
			} 
			//alis faturaları
			for(m=1; m lte GET_INV_PURCHASE.recordcount; m=m+1)
			{
				if( get_all_stock.PRODUCT_ID[k] eq GET_INV_PURCHASE.PRODUCT_ID[m]) 
				{
					'prod_purchase_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#' = GET_INV_PURCHASE.AMOUNT[m];
					'prod_purchase_total_#GET_ALL_STOCK.PRODUCT_ID[k]#' = GET_INV_PURCHASE.TOTAL[m];
					if(isdefined('session.ep.money2') and len(session.ep.money2))
						'prod_purchase_total2_#GET_ALL_STOCK.PRODUCT_ID[k]#' = GET_INV_PURCHASE.TOTAL2[m];
					break;
				}
			} 
			if(isdefined('prod_sale_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#'))
				'diff_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#' = evaluate('diff_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#') + evaluate('prod_sale_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#');
			if(isdefined('prod_purchase_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#'))
				'diff_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#' = evaluate('diff_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#') - evaluate('prod_purchase_amount_#GET_ALL_STOCK.PRODUCT_ID[k]#');
			if(isdefined('prod_sale_total_#GET_ALL_STOCK.PRODUCT_ID[k]#'))
				'diff_total_#GET_ALL_STOCK.PRODUCT_ID[k]#' = evaluate('diff_total_#GET_ALL_STOCK.PRODUCT_ID[k]#') + evaluate('prod_sale_total_#GET_ALL_STOCK.PRODUCT_ID[k]#');
			if(isdefined('prod_purchase_total_#GET_ALL_STOCK.PRODUCT_ID[k]#'))
				'diff_total_#GET_ALL_STOCK.PRODUCT_ID[k]#' = evaluate('diff_total_#GET_ALL_STOCK.PRODUCT_ID[k]#') - evaluate('prod_purchase_total_#GET_ALL_STOCK.PRODUCT_ID[k]#');
		}
	</cfscript>
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39872.Tedarikçi veya Sorumlu Olunan Ürünler'></cfsavecontent>
<cf_seperator title="#head#" id="respon1">
<div id="respon1"   style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
		<cf_grid_list>
			<thead>
				<cfoutput>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang_main no ='245.Ürün'></th>
					<th><cf_get_lang no ='391.Stok Miktarı'></th>
					<th><cf_get_lang no ='1152.Satış Miktarı'></th>
					<th><cf_get_lang no ='408.Satış Tutarı'> #session.ep.money#</th>
					<cfif len(session.ep.money2)>
					<th><cf_get_lang no ='408.Satış Tutarı'> #session.ep.money2#</th>
					</cfif>
					<th><cf_get_lang no ='1153.Alış Miktarı'></th>
					<th><cf_get_lang no ='1154.Alış Tutarı'> #session.ep.money#</th>
					<cfif len(session.ep.money2)>
					<th><cf_get_lang no ='1154.Alış Tutarı'> #session.ep.money2#</th>
					</cfif>
					<th><cf_get_lang no ='1155.Fark Miktar'></th>
					<th><cf_get_lang no ='1156.Fark Tutar'> #session.ep.money#</th>
				</tr>
				</cfoutput>
			</thead>
			<tbody>
				<cfif GET_ALL_STOCK.recordcount>
					<cfscript>
						sale_amount = 0;
						sale_total = 0;
						sale_total2 = 0;
						purchase_amount = 0;
						purchase_total = 0;
						purchase_total2 = 0;
					</cfscript>
					<cfoutput query="GET_ALL_STOCK" maxrows="20">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td width="300">&nbsp;#PRODUCT_NAME#</td>
						<td align="right" style="text-align:right;">#TLFormat(STOCK_AMOUNT)#</td>
						<td align="right" style="text-align:right;">&nbsp;
							<cfif isdefined("prod_sale_amount_#GET_ALL_STOCK.PRODUCT_ID#")>
								<cfset sale_amount = sale_amount + evaluate("prod_sale_amount_#GET_ALL_STOCK.PRODUCT_ID#")>
								#TLFormat(evaluate("prod_sale_amount_#GET_ALL_STOCK.PRODUCT_ID#"))#
							<cfelse>
								#TLFormat(0)#
							</cfif>
						</td>
						<td align="right" style="text-align:right;">&nbsp;
							<cfif isdefined("prod_sale_total_#GET_ALL_STOCK.PRODUCT_ID#")>
								<cfset sale_total = wrk_round(sale_total + evaluate("prod_sale_total_#GET_ALL_STOCK.PRODUCT_ID#"))>
								#TLFormat(evaluate("prod_sale_total_#GET_ALL_STOCK.PRODUCT_ID#"))# #session.ep.money#
							<cfelse>
								#TLFormat(0)#
							</cfif>
						</td>
						<cfif len(session.ep.money2)>
						<td align="right" style="text-align:right;">&nbsp;
							<cfif isdefined("prod_sale_total2_#GET_ALL_STOCK.PRODUCT_ID#")>
								<cfset sale_total2 = wrk_round(sale_total2 + evaluate("prod_sale_total2_#GET_ALL_STOCK.PRODUCT_ID#"))>
								#TLFormat(evaluate("prod_sale_total2_#GET_ALL_STOCK.PRODUCT_ID#"))# #session.ep.money2#
							<cfelse>
								#TLFormat(0)#
							</cfif>
						</td>
						</cfif>
						<td align="right" style="text-align:right;">&nbsp;
							<cfif isdefined("prod_purchase_amount_#GET_ALL_STOCK.PRODUCT_ID#")>
								<cfset purchase_amount = purchase_amount + evaluate("prod_purchase_amount_#GET_ALL_STOCK.PRODUCT_ID#")>
								#TLFormat(evaluate("prod_purchase_amount_#GET_ALL_STOCK.PRODUCT_ID#"))#
							<cfelse>
								#TLFormat(0)#
							</cfif>
						</td>
						<td align="right" style="text-align:right;">&nbsp;
							<cfif isdefined("prod_purchase_total_#GET_ALL_STOCK.PRODUCT_ID#")>
								<cfset purchase_total = wrk_round(purchase_total + evaluate("prod_purchase_total_#GET_ALL_STOCK.PRODUCT_ID#"))>
								#TLFormat(evaluate("prod_purchase_total_#GET_ALL_STOCK.PRODUCT_ID#"))#
							<cfelse>
								#TLFormat(0)#
							</cfif>
						</td>
						<cfif len(session.ep.money2)>
						<td align="right" style="text-align:right;">&nbsp;
							<cfif isdefined("prod_purchase_total2_#GET_ALL_STOCK.PRODUCT_ID#")>
								<cfset purchase_total2 = wrk_round(purchase_total2 + evaluate("prod_purchase_total2_#GET_ALL_STOCK.PRODUCT_ID#"))>
								#TLFormat(evaluate("prod_purchase_total2_#GET_ALL_STOCK.PRODUCT_ID#"))#
							<cfelse>
								#TLFormat(0)#
							</cfif>
						</td>
						</cfif>
						<td align="right" style="text-align:right;">&nbsp;
						<cfif isdefined('diff_amount_#GET_ALL_STOCK.PRODUCT_ID#')>
							#TLFormat(evaluate('diff_amount_#GET_ALL_STOCK.PRODUCT_ID#'))#
						<cfelse>
							#TLFormat(0)#
						</cfif>
						</td>
						<td align="right" style="text-align:right;">&nbsp;
						<cfif isdefined('diff_total_#GET_ALL_STOCK.PRODUCT_ID#')>
							#TLFormat(evaluate('diff_total_#GET_ALL_STOCK.PRODUCT_ID#'))# #session.ep.money#
						<cfelse>
							#TLFormat(0)#
						</cfif>
						</td>
					</tr>
					
					</cfoutput> 
					<cfoutput>
					<tr>
						<td class="txtbold" colspan="3"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(sale_amount)#</td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(sale_total)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(sale_total2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(purchase_amount)#</td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(purchase_total)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(purchase_total2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(sale_amount-purchase_amount)#</td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(sale_total-purchase_total)# #session.ep.money#</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cf_get_lang_main no ='72.Kayıt Yok'></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfif GET_ALL_STOCK.recordcount>
			<script src="JS/Chart.min.js"></script> 
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfif purchase_amount neq 0 or sale_amount neq 0> 
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<p class="phead"><cf_get_lang no ='1157.Alış-Satış Miktar Oranı'></p>
					<!--- alış ya da satış işlemi varsa grafik gösterilsin --->
							<cfset purchase_amount_rate = (purchase_amount*100)/(purchase_amount+sale_amount)>
							<cfsavecontent variable="message"><cf_get_lang no ='1152.Satış Miktarı'></cfsavecontent>
							<cfset item1 = "#message# (%#wrk_round(100-purchase_amount_rate)#)">
							<cfset value1 = "#(100-purchase_amount_rate)/100#">
							<cfsavecontent variable="message"><cf_get_lang no ='1153.Alış Miktarı'></cfsavecontent>
							<cfset item2 = "#message# (%#wrk_round(purchase_amount_rate)#)">
							<cfset value2 = "#purchase_amount_rate/100#">
						<canvas id="myChart29" style="float:left;max-width:400px;max-height:400px;"></canvas>
						<script>
							var ctx = document.getElementById('myChart29');
								var myChart29 = new Chart(ctx, {
									type: '<cfoutput>#graph_type#</cfoutput>',
									data: {
										labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
										datasets: [{
											label: "Alış - Satış Miktar Oranı",
											backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
											data: [<cfoutput>#value1#</cfoutput>,<cfoutput>#value2#</cfoutput>],
										}]
									},
									options: {
										legend: {
											display: false
										}
									}
							});
						</script>
				</div>
			</cfif>
			<cfif purchase_total neq 0 or sale_total neq 0> <!--- alış ya da satış işlemi varsa grafik gösterilsin --->
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<p class="phead"><cf_get_lang no ='1158.Alış-Satış Tutar Oranı'></p>
							<cfset purchase_total_rate = (purchase_total*100)/(purchase_total+sale_total)>
							<cfsavecontent variable="message"><cf_get_lang no ='408.Satış Tutarı'></cfsavecontent>
							<cfset item1 = "#message# (%#wrk_round(100-purchase_total_rate)#)">
							<cfset value1 = "#(100-purchase_total_rate)/100#">
							<cfsavecontent variable="message"><cf_get_lang no ='1154.Alış Tutarı'></cfsavecontent>
							<cfset item2 = "#message# (%#wrk_round(purchase_total_rate)#)">
							<cfset value2 = "#purchase_total_rate/100#">
						<canvas id="myChart30" style="float:left;max-width:400px;max-height:400px;"></canvas>
						<script>
							var ctx = document.getElementById('myChart30');
								var myChart30 = new Chart(ctx, {
									type: '<cfoutput>#graph_type#</cfoutput>',
									data: {
										labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
										datasets: [{
											label: "Alış - Satış Tutar Oranı",
											backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
											data: [<cfoutput>#value1#</cfoutput>,<cfoutput>#value2#</cfoutput>],
										}]
									},
									options: {
										legend: {
											display: false
										}
									}
							});
						</script>
				</div>
			</cfif>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<p class="phead"><cfif purchase_total neq 0><cf_get_lang no ='1159.En Çok Alınan Ürünler'></cfif></p>
				<p class="phead"><cfif sale_total neq 0><cf_get_lang no ='1160.En Çok Satılan Ürünler'></cfif></p>
				
				
				<cfif purchase_total neq 0>

					<cfoutput query="GET_INV_PURCHASE">
					<cfif len(PRODUCT_NAME) GT 15>
						<cfset 'item_#currentrow#'="#Left(PRODUCT_NAME,15)#...(%#wrk_round((TOTAL*100)/purchase_total)#)"> 
						<cfset 'value_#currentrow#'="#((TOTAL*100)/purchase_total)/100#">
					<cfelse>
						<cfset 'item_#currentrow#'="#PRODUCT_NAME#...(%#wrk_round((TOTAL*100)/purchase_total)#)"> 
						<cfset 'value_#currentrow#'="#((TOTAL*100)/purchase_total)/100#">
					</cfif>
					</cfoutput> 
						<canvas id="myChart31" style="float:left;max-width:400px;max-height:400px;"></canvas>
						<script>
							var ctx = document.getElementById('myChart31');
								var myChart31 = new Chart(ctx, {
									type: '<cfoutput>#graph_type#</cfoutput>',
									data: {
										labels: [<cfloop from="1" to="#GET_INV_PURCHASE.recordcount#" index="jj">
												<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
										datasets: [{
											label: "En Çok Satılan Ürünler",
											backgroundColor: [<cfloop from="1" to="#GET_INV_PURCHASE.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
											data: [<cfloop from="1" to="#GET_INV_PURCHASE.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
				
				<cfif sale_total neq 0>
					<cfoutput query="GET_INV_SALE">
					<cfif len(PRODUCT_NAME) GT 15>
						<cfset 'item_#currentrow#'="#Left(PRODUCT_NAME,15)#...(%#wrk_round((TOTAL*100)/sale_total)#)"> 
						<cfset 'value_#currentrow#'="#((TOTAL*100)/sale_total)/100#">
					<cfelse>
						<cfset 'item_#currentrow#'="#PRODUCT_NAME#...(%#wrk_round((TOTAL*100)/sale_total)#)"> 
						<cfset 'value_#currentrow#'="#((TOTAL*100)/sale_total)/100#">
					</cfif>
					</cfoutput> 

					<canvas id="myChart31" style="float:left;max-width:400px;max-height:400px;"></canvas>
						<script>
							var ctx = document.getElementById('myChart31');
								var myChart31 = new Chart(ctx, {
									type: '<cfoutput>#graph_type#</cfoutput>',
									data: {
										labels: [<cfloop from="1" to="#GET_INV_SALE.recordcount#" index="jj">
												<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
										datasets: [{
											label: "En Çok Satılan Ürünler",
											backgroundColor: [<cfloop from="1" to="#GET_INV_SALE.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
											data: [<cfloop from="1" to="#GET_INV_SALE.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
		</cfif>
	</div>
</div>

