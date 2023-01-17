<cfset attributes.process_id = session.ep.userid>
<cfset attributes.plan_year = session.ep.period_year>
<cfif len(session.ep.money2) and session.ep.money2 neq session.ep.money>
	<cfset attributes.is_doviz2 = 1>
</cfif> 
<cfset month_list=''>
<cfloop from="1" to="#month(now())#" index="i">
	<cfset month_list=listappend(month_list,i)>
</cfloop>
<cfquery name="get_all_quotas" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		SUM(ROW_TOTAL) ROW_TOTAL,
		SUM(ROW_PROFIT) ROW_PROFIT,
		SUM(NET_TOTAL) NET_TOTAL,
		SUM(NET_KAR) NET_KAR,
		<cfif isdefined("attributes.is_doviz2")>
			SUM(ROW_TOTAL2) ROW_TOTAL2,
			SUM(NET_TOTAL2) NET_TOTAL2,
		</cfif>
		EMPLOYEE_ID,
		MONTH_VALUE
	FROM
	(
		SELECT 
			SQR.ROW_TOTAL,
			SQR.ROW_PROFIT,
			0 AS NET_TOTAL,
			0 AS NET_KAR,
			<cfif isdefined("attributes.is_doviz2")>
				SQR.ROW_TOTAL2,
				0 AS NET_TOTAL2,
			</cfif>
			SQR.EMPLOYEE_ID EMPLOYEE_ID,
			SQR.QUOTE_MONTH AS MONTH_VALUE
		FROM
			SALES_QUOTES_GROUP SQ,
			SALES_QUOTES_GROUP_ROWS SQR
		WHERE
			SQ.SALES_QUOTE_ID = SQR.SALES_QUOTE_ID
			AND SQ.IS_PLAN = 1
			<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
				AND SQR.EMPLOYEE_ID = #attributes.process_id#
			<cfelse>
				AND SQR.EMPLOYEE_ID IS NOT NULL
			</cfif>
			AND SQR.QUOTE_MONTH IN (#month_list#)
			AND SQ.QUOTE_YEAR = #attributes.plan_year#
	UNION ALL
		SELECT
			0 AS ROW_TOTAL,
			0 AS ROW_PROFIT,
			CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS NET_TOTAL,
			CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN 
				-1*ISNULL((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL - 
					ISNULL((
							SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
							)+ISNULL(PROM_COST,0)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							PRODUCT_COST.START_DATE <= I.INVOICE_DATE
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0)
				,0) 
			ELSE 
				ISNULL((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL - 
					ISNULL((
							SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
							)+ISNULL(PROM_COST,0)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							PRODUCT_COST.START_DATE <= I.INVOICE_DATE
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0)
				,0)
			END AS NET_KAR,
			<cfif isdefined("attributes.is_doviz2")>
				0 AS ROW_TOTAL2,
				CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*(((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) ELSE (((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) END AS NET_TOTAL2,
			</cfif>
			#session.ep.userid# AS  EMPLOYEE_ID,
			MONTH(I.INVOICE_DATE) AS MONTH_VALUE
		FROM
			#dsn2_alias#.INVOICE I,
			#dsn2_alias#.INVOICE_ROW IR
			<cfif isdefined("attributes.is_doviz2")>
				,#dsn2_alias#.INVOICE_MONEY INV_M
			</cfif>
		WHERE
			IR.INVOICE_ID = I.INVOICE_ID
			AND I.INVOICE_CAT IN (50,52,53,531,58,561,54,55,51,63,48,49)
			AND I.IS_IPTAL = 0
			AND I.NETTOTAL > 0 
			<cfif isdefined("attributes.is_doviz2")>
				AND I.INVOICE_ID = INV_M.ACTION_ID 
				AND INV_M.MONEY_TYPE = '#session.ep.money2#' 
			</cfif>
			<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
				<cfif isdefined("attributes.kontrol_type") and attributes.kontrol_type eq 2>
					AND
					( 
					(I.COMPANY_ID IS NOT NULL AND I.COMPANY_ID IN (SELECT WEP.COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE WEP.POSITION_CODE = #session.ep.position_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID= #session.ep.company_id# AND WEP.COMPANY_ID IS NOT NULL))
					OR
					(I.CONSUMER_ID IS NOT NULL AND I.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE WEP.POSITION_CODE = #session.ep.position_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID= #session.ep.company_id# AND WEP.CONSUMER_ID IS NOT NULL))
					)
				<cfelse>
					AND I.SALE_EMP = #attributes.process_id#
				</cfif>
			<cfelse>
				AND I.SALE_EMP IS NOT NULL
			</cfif>
			AND MONTH(I.INVOICE_DATE) IN (#month_list#)
			AND YEAR(I.INVOICE_DATE) = #attributes.plan_year#
		)T1
	GROUP BY
		EMPLOYEE_ID,
		MONTH_VALUE
</cfquery>
<cfquery name="get_total_quota" dbtype="query">
	SELECT SUM(NET_TOTAL) NET_TOTAL,SUM(ROW_TOTAL) ROW_TOTAL  FROM get_all_quotas 
</cfquery>
<cfset genel_toplam = 0>
<cfset genel_toplam2 = 0>
<cfset g_genel_toplam = 0>
<cfset g_genel_toplam2 = 0>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='30818.Kotalarım'></cfsavecontent>
<cf_box title="#message#" closable="0">
<cfform name="form" method="post" action="#request.self#?fuseaction=myhome.list_my_quotas">
	<!--- <cf_big_list_search title="#getLang('myhome',61)#">  --->
		<cf_big_list_search_area>
			<div class="row form-inline">
				<div class="form-group" id="item-kontrol_type">
					<div class="input-group x-20">
						<select name="kontrol_type" id="kontrol_type" style="width:160px;">
							<option value="1" <cfif isdefined("attributes.kontrol_type") and attributes.kontrol_type eq 1>selected</cfif>><cf_get_lang dictionary_id='30953.Satış Yapan Bazında'></option>
							<option value="2" <cfif isdefined("attributes.kontrol_type") and attributes.kontrol_type eq 2>selected</cfif>><cf_get_lang dictionary_id='30954.Müşteri Temsilcisi Bazında'></option>
						</select>
					</div>
				</div>	
			<div class="form-group">
					<cf_wrk_search_button>
				</div>
				<!-- sil --><cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'><!-- sil -->
				</div>
		</cf_big_list_search_area>
	<!--- </cf_big_list_search> --->
 </cfform>

		<cfloop list="#month_list#" index="k">
			<cfquery name="get_quota_#k#" dbtype="query">
				SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #k# 
			</cfquery>
			<cfset 'ay_cat_list_#k#' = ''>
			<cfset 'toplam_ay_#k#' = 0>
			<cfset 'toplam_ay_2_#k#' = 0>
			<cfset 'g_toplam_ay_#k#' = 0>
			<cfset 'g_toplam_ay_2_#k#' = 0>
			<cfset quota_query = evaluate('get_quota_#k#')>
			<cfif quota_query.recordcount>
				<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.employee_id,','),'numeric','ASC',',')>
			</cfif>
		</cfloop>
		<cf_medium_list>
			<table class="ajax_list">
					<thead>
						<tr>
							<th width="100"><cf_get_lang dictionary_id='58724.Ay'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='58869.Planlanan'> <cfoutput>#session.ep.money#</cfoutput></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id ='31491.Gerçekleşen'> <cfoutput>#session.ep.money#</cfoutput></th>
							<cfif isdefined("attributes.is_doviz2")>
								<th class="header_icn_none"></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id='58869.Planlanan'> <cfoutput>#session.ep.money2#</cfoutput></th>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='31491.Gerçekleşen'> <cfoutput>#session.ep.money2#</cfoutput></th>
								<th class="header_icn_none"></th>
							</cfif>
							<th style="text-align:right;"><cf_get_lang dictionary_id='58456.Oran'></th>
							<th class="header_icn_none"></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id ='31493.Planlanan Kar %'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id ='31494.Gerçekleşen Kar %'></th>
						</tr>
					</thead>
					<cfoutput>
						<tbody>
							<cfloop list="#month_list#" index="ay_ind">
								<tr>
									<cfset cat_toplam = 0>
									<cfset cat_toplam2 = 0>
									<cfset g_cat_toplam = 0>
									<cfset g_cat_toplam2 = 0>
									<cfset quota_query = evaluate('get_quota_#ay_ind#')>
									<cfset indx = listfind(evaluate('ay_cat_list_#ay_ind#'),session.ep.userid,',')>
									<td>#listgetat(ay_list(),ay_ind,',')#</td>
									<cfif indx>
										<td  nowrap style="text-align:right;">#TlFormat(quota_query.row_total[indx])# #session.ep.money#</td>
										<cfset cat_toplam = cat_toplam + quota_query.row_total[indx]>
										<cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + quota_query.row_total[indx]>
										<td  nowrap style="text-align:right;">#TlFormat(quota_query.net_total[indx])# #session.ep.money#</td>
										<cfset g_cat_toplam = g_cat_toplam + quota_query.net_total[indx]>
										<cfset 'g_toplam_ay_#ay_ind#' = evaluate('g_toplam_ay_#ay_ind#') + quota_query.net_total[indx]>
										<cfif isdefined("attributes.is_doviz2")>
											<td width="1" nowrap></td>
											<td  nowrap style="text-align:right;">#TlFormat(quota_query.row_total2[indx])# #session.ep.money2#</td>
											<cfset cat_toplam2 = cat_toplam2 + quota_query.row_total2[indx]>
											<cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + quota_query.row_total2[indx]>
											<td  nowrap style="text-align:right;">#TlFormat(quota_query.net_total2[indx])# #session.ep.money2#</td>
											<cfset g_cat_toplam2 = g_cat_toplam2 + quota_query.net_total2[indx]>
											<cfset 'g_toplam_ay_2_#ay_ind#' = evaluate('g_toplam_ay_2_#ay_ind#') + quota_query.net_total2[indx]>
											<td width="1" nowrap></td>
										</cfif>
										<td  nowrap style="text-align:right;">% 
											<cfif quota_query.row_total[indx] gt 0>
												#TLFormat(quota_query.net_total[indx]*100/quota_query.row_total[indx])#
											<cfelse>
												#TLFormat(100)#
											</cfif>
										</td>
										<td width="1" nowrap></td>
										<td  nowrap style="text-align:right;">% #TlFormat(quota_query.row_profit[indx])#</td>
										<td  nowrap style="text-align:right;">% 
											<cfif quota_query.net_total[indx] neq 0>
												#TlFormat(quota_query.net_kar[indx]*100/quota_query.net_total[indx])#
											<cfelse>
												0
											</cfif>
										</td>
									<cfelse>
										<td  nowrap style="text-align:right;">#TlFormat(0)# #session.ep.money#</td>
										<td  nowrap style="text-align:right;">#TlFormat(0)# #session.ep.money#</td>
										<cfif isdefined("attributes.is_doviz2")>
											<td width="1" nowrap></td>
											<td  nowrap style="text-align:right;">#TlFormat(0)# #session.ep.money#</td>
											<td  nowrap style="text-align:right;">#TlFormat(0)# #session.ep.money#</td>
											<td width="1" nowrap></td>
										</cfif>
										<td  nowrap style="text-align:right;">% #TlFormat(0)#</td>
										<td width="1" nowrap></td>
										<td  nowrap style="text-align:right;">% #TlFormat(0)#</td>
										<td  nowrap style="text-align:right;">% #TlFormat(0)#</td>
									</cfif>
								</tr>
								<cfset genel_toplam = genel_toplam + cat_toplam> 
								<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
								<cfset g_genel_toplam = g_genel_toplam + g_cat_toplam> 
								<cfset g_genel_toplam2 = g_genel_toplam2 + g_cat_toplam2>
							</cfloop>
							<tr >
								<td class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
								<td  nowrap class="txtbold" style="text-align:right;">#TlFormat(genel_toplam)# #session.ep.money#</td>
								<td  nowrap class="txtbold" style="text-align:right;">#TlFormat(g_genel_toplam)# #session.ep.money#</td>
								<cfif isdefined("attributes.is_doviz2")>
									<td width="1" nowrap></td>
									<td  nowrap class="txtbold" style="text-align:right;">#TlFormat(genel_toplam2)# #session.ep.money2#</td>
									<td  nowrap class="txtbold" style="text-align:right;">#TlFormat(g_genel_toplam2)# #session.ep.money2#</td>
									<td width="1" nowrap></td>
								</cfif>
								<td  nowrap class="txtbold" style="text-align:right;">% 
									<cfif genel_toplam gt 0>
										#TlFormat(g_genel_toplam*100/genel_toplam)#
									<cfelse>
										#TLFormat(100)#
									</cfif>
								</td>
								<td width="1" nowrap></td>
								<td></td>
								<td></td>
							</tr>
						</tbody>
					</cfoutput>
			</cf_medium_list>
			</table>
			
	
	
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
		<tr style="background-color:#ffffff;">
			<td valign="top">
				<cfloop list="#month_list#" index="ay_indx">
							<cfquery name="get_quota" dbtype="query">
								SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #ay_indx# 
							</cfquery>
							<cfset item="#listgetat(ay_list(),ay_indx,',')#" >
							<cfset value="#NumberFormat(get_quota.row_total,'00.00')#">
						</cfloop>
						<cfloop list="#month_list#" index="ay_indx">
							<cfquery name="get_quota" dbtype="query">
								SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #ay_indx# 
							</cfquery>
							<cfset item="#listgetat(ay_list(),ay_indx,',')#">
							<cfset value="#NumberFormat(get_quota.net_total,'00.00')#">
						</cfloop>
				<script src="JS/Chart.min.js"></script> 
                <canvas id="myChartquotas" style="max-height:400px;max-width:400px;"></canvas>
					<script>
						var ctx = document.getElementById('myChartquotas');
						var myChartquotas = new Chart(ctx, {
							type: 'bar',
							data: {
									labels: [<cfloop list="#month_list#" index="ay_indx">
									<cfoutput>"#listgetat(ay_list(),ay_indx,',')#"</cfoutput>,</cfloop>"Toplam"],
									datasets: [{
												label: "Planlanan",
												backgroundColor: [<cfloop list="#month_list#" index="ay_indx">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgb(255, 99, 132)'],
												data: [<cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(get_quota.row_total,'00')#</cfoutput>,</cfloop><cfoutput>#NumberFormat(get_total_quota.row_total,'00')#</cfoutput>],
											},
											{
												label: "Gerçekleşen",
												backgroundColor: [<cfloop list="#month_list#" index="ay_indx">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgba(255, 99, 132, 0.2)'],
												data: [<cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(get_quota.net_total,'00')#</cfoutput>,</cfloop><cfoutput>#NumberFormat(get_total_quota.net_total,'00')#</cfoutput>],
											}
											]
										},
							options: {}
							});
					</script> 
			</td>
		</tr>
	</table>
	<!-- sil -->
</cf_box>
	
