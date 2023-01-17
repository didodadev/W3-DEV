<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.credit_type" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset rev_total = 0>
<cfset pay_total = 0>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	getCredit_=createobject("component","V16.credit.cfc.credit");
	getCredit_.dsn3=#dsn3#;
</cfscript>
<cfif isdefined("attributes.form_submitted")>
	<cfscript>
		getCreditLimit = getCredit_.getCreditLimit
		(
			credit_type : attributes.credit_type ,
			account_id : attributes.account_id , 
			startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
		);
	</cfscript>
    <cfparam name="attributes.totalrecords" default='#getCreditLimit.QUERY_COUNT#'>
<cfelse> 
	<cfset getCreditLimit.recordcount = 0>
     <cfparam name="attributes.totalrecords" default='0'>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_credit_contract" method="post" action="#request.self#?fuseaction=credit.list_credit_limit">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cf_wrk_combo
						name="credit_type"
						query_name="GET_CREDIT_TYPE"
						option_name="credit_type"
						option_value="credit_type_id"
						value="#attributes.credit_type#"
						width="130"
						option_text="#getLang(26,'Kredi Türü',51358)#">
				</div>
				<div class="form-group">
					<cf_wrkBankAccounts width='285' selected_value='#attributes.account_id#'>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayı_Hatası_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<!---<table>
					<tr>
						<td><cf_wrk_combo
							name="credit_type"
							query_name="GET_CREDIT_TYPE"
							option_name="credit_type"
							option_value="credit_type_id"
							value="#attributes.credit_type#"
							width="130"
							option_text="#getLang('credit',26)#">
						</td>
						<td>
							<cf_wrkBankAccounts width='285' selected_value='#attributes.account_id#'>
						</td>
						<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayı_Hatası_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#" style="width:25px;">
						</td>
						<td><cf_wrk_search_button>
							<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
						</td>
					</tr>
				</table>--->
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1550,'Kredi Limitleri',58962)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58820.Başlık'></th>
					<th><cf_get_lang dictionary_id='29449.Banka Hesabi'></th>
					<th><cf_get_lang dictionary_id='51358.Kredi Türü'></th>
					<th><cf_get_lang dictionary_id='58963.Kredi Limiti'></th>
					<th><cf_get_lang dictionary_id='51361.Tahsilatlar'></th>
					<th><cf_get_lang dictionary_id='58658.Ödemeler'></th>
					<th><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<!-- sil -->
					<!---<th class="header_icn_none"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=credit.popup_form_add_credit_limit','small');"><img src="/images/plus_list.gif" alt="<cf_get_lang dictionary_id='170.Ekle'>" title="<cf_get_lang dictionary_id='170.Ekle'>"></a></cfoutput></th>--->
					<th width="20" class="header_icn_none"><cfoutput><a href="#request.self#?fuseaction=credit.list_credit_limit&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
			
				<cfif getCreditLimit.recordcount>
					<cfoutput query="getCreditLimit">
							<cfquery name="getLimitRow" datasource="#dsn3#">
								SELECT DISTINCT
									CC.CREDIT_LIMIT_ID,
									CC.CREDIT_CONTRACT_ID,
									CCR.CREDIT_CONTRACT_ROW_ID,
									CCR.IS_PAID,
									CCR.PERIOD_ID
								FROM 
									CREDIT_CONTRACT CC
									LEFT JOIN CREDIT_CONTRACT_ROW CCR ON CC.CREDIT_CONTRACT_ID = CCR.CREDIT_CONTRACT_ID
								WHERE 
									CCR.IS_PAID = 1 AND
									CC.CREDIT_LIMIT_ID = #getCreditLimit.CREDIT_LIMIT_ID#
							</cfquery>
							<cfif getCreditLimit.recordcount>
								<cfif getLimitRow.recordcount>
									<cfquery name="getPeriod" datasource="#dsn#">
										SELECT DISTINCT
											SP.PERIOD_ID,
											SP.PERIOD,
											SP.PERIOD_YEAR,
											SP.OUR_COMPANY_ID
										FROM
											SETUP_PERIOD SP 
											LEFT JOIN #dsn3#.CREDIT_CONTRACT_ROW CCR ON CCR.PERIOD_ID = SP.PERIOD_ID
										WHERE
											CCR.PERIOD_ID IN ( #valuelist(getLimitRow.PERIOD_ID)# )
									</cfquery>
								<cfelse>
										<cfset  getPeriod.recordcount = 0>
										<cfset totalrowlimit.REVENUE_TOTAL = 0>
										<cfset totalrowlimit.PAYMENT_TOTAL = 0>
									
								</cfif>
								<cfset i =  0>
								<cfset list_row =  listdeleteduplicates(VALUELIST(getLimitRow.CREDIT_CONTRACT_ID))>
								<cfif getPeriod.recordcount AND len(list_row)>
								<cfquery name="totalrowlimit" datasource="#dsn3#">
										SELECT 
											SUM(REVENUE_TOTAL) AS REVENUE_TOTAL,
											SUM(PAYMENT_TOTAL) AS PAYMENT_TOTAL
											FROM
											(
											<cfloop query="getPeriod">
												<cfset i = i + 1>
												<cfset temp_dsn = '#dsn#_#getPeriod.PERIOD_YEAR#_#getPeriod.OUR_COMPANY_ID#'>
												SELECT 
													SUM(CASE WHEN CCI.PROCESS_TYPE = 292 THEN CAPITAL_PRICE ELSE 0 END ) AS REVENUE_TOTAL,
													SUM(CASE WHEN CCI.PROCESS_TYPE = 291 THEN CAPITAL_PRICE ELSE 0 END ) AS PAYMENT_TOTAL
												FROM
													#temp_dsn#.CREDIT_CONTRACT_PAYMENT_INCOME CCI
												WHERE
													CREDIT_CONTRACT_ID IN (#list_row#)
												<cfif getPeriod.recordcount neq i>
												UNION ALL
												</cfif>
											</cfloop>
											) aS A
									</cfquery>
									
								<cfelse>
									<cfset totalrowlimit.REVENUE_TOTAL = 0>
									<cfset totalrowlimit.PAYMENT_TOTAL = 0>
								</cfif>
									<cfif len(totalrowlimit.REVENUE_TOTAL)>
										<cfset rev_total = rev_total + totalrowlimit.REVENUE_TOTAL>
									</cfif>
									<cfif len(totalrowlimit.PAYMENT_TOTAL)>
										<cfset pay_total = pay_total + totalrowlimit.PAYMENT_TOTAL>
									</cfif>
								<tr>
									<td>#rownum#</td>
									<td>#limit_head#</td> 
									<td>#account_name#</td> 
									<td>#credit_type_name#</td> 
									<td style="text-align:right;">#tlformat(CREDIT_LIMIT)#</td> 
									<td style="text-align:right;">#tlformat(REV_total)#</td> 
									<td style="text-align:right;">#tlformat(pay_total)#</td> 
									<td style="text-align:right;">
										#tlformat((CREDIT_LIMIT-rev_total)+pay_total)#
									</td>
									<td>#money_type#</td> 
									<!-- sil -->
									<!---<td width="15" align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=credit.popup_form_add_credit_limit&credit_limit_id=#credit_limit_id#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang dictionary_id='52.Güncelle'>" title="<cf_get_lang dictionary_id='52.Güncelle'>" border="0"></a></td>--->
									<td width="15" align="center"><a href="#request.self#?fuseaction=credit.list_credit_limit&event=upd&credit_limit_id=#credit_limit_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
									<!-- sil -->
								</tr> 
								<cfset totalrowlimit.recordcount = 0>
								<CFSET pay_total = 0>
								<CFSET REV_total = 0>
						</cfif>
					</cfoutput>
					<cfoutput>
					<cfscript>
						getCreditLimitTotal = getCredit_.getCreditLimitTotal();
					</cfscript>
						<tfoot>
							<tr>
								<td colspan="4" valign="top" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<cfloop query="getCreditLimitTotal">
										<cfquery name="getCrdLim" datasource="#dsn3#">
											SELECT
												CC.CREDIT_LIMIT_ID,
												CC.CREDIT_CONTRACT_ID,
												CCR.IS_PAID,
												CCR.PERIOD_ID
											FROM 
												CREDIT_CONTRACT CC
												LEFT JOIN CREDIT_CONTRACT_ROW CCR ON CC.CREDIT_CONTRACT_ID = CCR.CREDIT_CONTRACT_ID
											WHERE
												CCR.IS_PAID = 1 AND
												CC.CREDIT_LIMIT_ID = #getCreditLimit.CREDIT_LIMIT_ID#
										</cfquery>
										<cfif getCrdLim.recordcount>
											<cfif getCrdLim.recordcount>
												<cfquery name="getPeriodBt" datasource="#dsn#">
													SELECT DISTINCT
														SP.PERIOD_ID,
														SP.PERIOD,
														SP.PERIOD_YEAR,
														SP.OUR_COMPANY_ID
													FROM
														SETUP_PERIOD SP 
														LEFT JOIN #dsn3#.CREDIT_CONTRACT_ROW CCR ON CCR.PERIOD_ID = SP.PERIOD_ID
													WHERE
														CCR.PERIOD_ID IN ( #valuelist(getCrdLim.PERIOD_ID)# )
												</cfquery>
											<cfelse>
												<cfset  getPeriodBt.recordcount = 0>
											</cfif>
										<cfelse>
												<cfset  getPeriodBt.recordcount = 0>
										</cfif>
										<cfset i =  0>

										<cfif getPeriodBt.recordcount>
											<cfquery name="totalrowlimit1" datasource="#dsn3#">
													WITH CTE1 AS( 
																<cfloop query="getPeriodBt">
																	<cfset i = i + 1>
																	<cfset temp_dsn = '#dsn#_#getPeriodBt.PERIOD_YEAR#_#getPeriodBt.OUR_COMPANY_ID#'>
																	SELECT DISTINCT
																		CR.MONEY_TYPE,
																		CR.CREDIT_LIMIT,
																		SUM(CASE WHEN CCI.PROCESS_TYPE = 292 THEN CAPITAL_PRICE ELSE 0 END) AS REVENUE_TOTAL1,
																		SUM(CASE WHEN CCI.PROCESS_TYPE = 291 THEN CAPITAL_PRICE ELSE 0 END) AS PAYMENT_TOTAL1
																	FROM 
																		CREDIT_LIMIT CR
																		LEFT JOIN CREDIT_CONTRACT CC ON CC.CREDIT_LIMIT_ID = CR.CREDIT_LIMIT_ID
																		LEFT JOIN #temp_dsn#.CREDIT_CONTRACT_PAYMENT_INCOME CCI ON CC.CREDIT_CONTRACT_ID = CCI.CREDIT_CONTRACT_ID
																		GROUP BY
																			CR.MONEY_TYPE,
																			CR.CREDIT_LIMIT,CR.CREDIT_LIMIT_ID
																		<cfif getPeriodBt.recordcount neq i>UNION ALL</cfif>	
																</cfloop>	
															),
															CTE2 AS
															(
																SELECT DISTINCT 
																	MONEY_TYPE,
																	--SUM(CREDIT_LIMIT) OVER (PARTITION BY MONEY_TYPE ORDER BY MONEY_TYPE) AS TOTAL_PLANLANAN_TAHSILAT,
																	SUM(REVENUE_TOTAL1) OVER (PARTITION BY MONEY_TYPE ORDER BY MONEY_TYPE) AS TOPLAM_GERCEKLESEN_TAHSILAT,
																	SUM(PAYMENT_TOTAL1) OVER (PARTITION BY MONEY_TYPE  ORDER BY MONEY_TYPE) AS TOTAL_PLANLANAN_ODEME
																FROM 
																	CTE1
															)
															SELECT 
																CTE2.*
															FROM
																CTE2
										
											</cfquery>
										<cfelse>
											<cfset totalrowlimit1.recordcount = 0>
										</cfif>
									</cfloop>
								<td class="txtbold" style="text-align:right;">
									#tlformat(getCreditLimitTotal.TOP_LIMIT)#<br/>
								</td>
								<td class="txtbold" style="text-align:right;">
									<cfif totalrowlimit1.recordcount>
										#tlformat(totalrowlimit1.TOPLAM_GERCEKLESEN_TAHSILAT)#<br/>
									</cfif>
								</td>
								<td class="txtbold" style="text-align:right;">
									<cfif totalrowlimit1.recordcount>
										#tlformat(totalrowlimit1.TOTAL_PLANLANAN_ODEME)#<br/>
									</cfif>
								</td>
								<td class="txtbold" style="text-align:right;">
									<cfif totalrowlimit1.recordcount>
										#tlformat((getCreditLimitTotal.TOP_LIMIT-totalrowlimit1.TOPLAM_GERCEKLESEN_TAHSILAT)+totalrowlimit1.TOTAL_PLANLANAN_ODEME)#<br/>
									</cfif>

								</td>
								<td class="txtbold" style="text-align:right;">
									<cfif totalrowlimit1.recordcount>
										#totalrowlimit1.money_type#<br/>
									</cfif>
								</td>
								<!-- sil --><td></td><!-- sil -->
							</tr>
						</tfoot>
					</cfoutput>
				<cfelse>
				<tbody>
						<tr>
							<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
						</tr>
				</tbody>
				</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres="credit.list_credit_limit">
			<cfif len(attributes.credit_type)>
				<cfset adres = "#adres#&credit_type=#attributes.credit_type#">
			</cfif>
			<cfif len(attributes.account_id)>
				<cfset adres = "#adres#&account_id=#attributes.account_id#">
			</cfif>
			<table width="99%" align="center">
				<tr>
					<td>
					<!-- sil -->
					<cf_paging
							page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#"  
							startrow="#attributes.startrow#" 
							adres="#adres#&form_submitted=1">
					<!-- sil -->
					</td>
					<!-- sil -->
					<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
					<!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>
<cfsetting showdebugoutput="yes">