<cfquery name="GET_PRODUCT_CAT" datasource="#dsn2#" maxrows="20">
	SELECT 
		SUM(INV_R.AMOUNT) AS AMOUNT,
		SUM(INV_R.GROSSTOTAL) AS TUTAR,
	<cfif len(session.ep.money2)>
		SUM(INV_R.GROSSTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TUTAR2,
	</cfif>
		PC.PRODUCT_CATID,
		PC.PRODUCT_CAT
	FROM 
		INVOICE_ROW INV_R WITH (NOLOCK),
		INVOICE INV WITH (NOLOCK),
		<cfif len(session.ep.money2)>
		INVOICE_MONEY INV_M WITH (NOLOCK),
		</cfif>
		#dsn3_alias#.PRODUCT P WITH (NOLOCK),
		#dsn3_alias#.PRODUCT_UNIT PU WITH (NOLOCK),
		#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK)
		<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT DEPARTMENT WITH (NOLOCK)
		</cfif>
	WHERE
		INV.INVOICE_ID= INV_R.INVOICE_ID
		AND INV.PURCHASE_SALES=0
		AND INV.IS_IPTAL = 0
		AND INV.INVOICE_CAT NOT IN (54,55)
	<cfif len(session.ep.money2)>
		AND INV.INVOICE_ID = INV_M.ACTION_ID
		AND INV_M.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
		AND INV_R.PRODUCT_ID=P.PRODUCT_ID
		AND P.PRODUCT_CATID= PC.PRODUCT_CATID
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
	GROUP BY PC.PRODUCT_CATID,PC.PRODUCT_CAT
	ORDER BY TUTAR  DESC
</cfquery>
<cfif GET_PRODUCT_CAT.recordcount>
	<cfquery name="CONSUMER_PRODUCT_CAT_TOTAL" dbtype="query">
		SELECT SUM(TUTAR) PRODUCT_CAT_TOTAL FROM GET_PRODUCT_CAT
	</cfquery>
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39870.Kategorilere Göre Alışlar'></cfsavecontent>
<cf_seperator title="#head#" id="categories1">
<div id="categories1"   style="padding: 10px; display: block;float: left; width: 100%">
	
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang_main no ='74.Kategori'></th>
					<th><cf_get_lang_main no ='223.Miktar'></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money#</cfoutput></th>
					<cfif len(session.ep.money2)>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
				</tr>
			</thead>
			
			<tbody>
				<cfif GET_PRODUCT_CAT.recordcount>
					<cfset total_amount = 0>
					<cfset product_cat_total = 0>
					<cfset product_cat_total2 = 0>
					<cfoutput query="GET_PRODUCT_CAT" maxrows="20">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td>&nbsp;#PRODUCT_CAT#</td>
						<td align="right" style="text-align:right;">&nbsp;#TLFormat(AMOUNT)#
							<cfif len(AMOUNT)>
								<cfset total_amount = total_amount + AMOUNT>
							</cfif>
						</td>
						<td align="right" style="text-align:right;">&nbsp;#TLFormat(TUTAR)# #session.ep.money#
							<cfif len(TUTAR)>
								<cfset product_cat_total = wrk_round(product_cat_total + TUTAR)>
							</cfif>
						</td>
						<cfif len(session.ep.money2)>
						<td align="right" style="text-align:right;">&nbsp;#TLFormat(TUTAR2)# #session.ep.money2#
							<cfif len(TUTAR2)>
								<cfset product_cat_total2 = wrk_round(product_cat_total2 + TUTAR2)>
							</cfif>
						</td>
						</cfif>
					</tr>
					</cfoutput>
					<cfoutput>
					<tr>
						<td class="txtbold" colspan="2"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(total_amount)#</td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(product_cat_total)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(product_cat_total2)# #session.ep.money2#</td>
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
		<cfif GET_PRODUCT_CAT.recordcount>
			<script src="JS/Chart.min.js"></script> 
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfoutput query="GET_PRODUCT_CAT">
			  <cfif len(PRODUCT_CAT) GT 15>
					<cfset 'item_#currentrow#' = "#Left(PRODUCT_CAT,15)#...(%#wrk_round((TUTAR*100)/CONSUMER_PRODUCT_CAT_TOTAL.PRODUCT_CAT_TOTAL)#)">
					<cfset 'value_#currentrow#'= "#((TUTAR*100)/CONSUMER_PRODUCT_CAT_TOTAL.PRODUCT_CAT_TOTAL)/100#">
				<cfelse>
					<cfset 'item_#currentrow#' = "#PRODUCT_CAT#...(%#wrk_round((TUTAR*100)/CONSUMER_PRODUCT_CAT_TOTAL.PRODUCT_CAT_TOTAL)#)">
					<cfset 'value_#currentrow#'= "#((TUTAR*100)/CONSUMER_PRODUCT_CAT_TOTAL.PRODUCT_CAT_TOTAL)/100#">
			  </cfif>
			</cfoutput> 
				<canvas id="myChartt27" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChartt27');
						var myChartt27 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#GET_PRODUCT_CAT.recordcount#" index="jj">
										 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Kategorilere Göre Alışlar",
									backgroundColor: [<cfloop from="1" to="#GET_PRODUCT_CAT.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#GET_PRODUCT_CAT.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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

