<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.is_excel" default="">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
<cfelse>
	<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
<cfelse>
	<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_invoices" datasource="#dsn2#">
		SELECT
			INVOICE_DATE,
			INVOICE_ID,
			MONTH(DUE_DATE) AS DUE_MONTH,
			YEAR(DUE_DATE) AS DUE_YEAR,
			NETTOTAL,
			0 AS DAYTOTAL,
			<cfif isdefined("attributes.is_other_money")>
				OTHER_MONEY_VALUE,
				0 AS OTHER_MONEY_DAY_VALUE,
				OTHER_MONEY,
			</cfif>
			<cfif isdefined("attributes.is_money2")>
				NETTOTAL/RATE2 AS OTHER_MONEY_VALUE_2,
				0 AS OTHER_MONEY_DAY_VALUE_2,
			</cfif>
			PAY_METHOD
		FROM
			INVOICE
			<cfif isdefined("attributes.is_money2")>
				,INVOICE_MONEY
			</cfif>
		WHERE
			INVOICE_CAT IN (52,53,56,561,66,67,531)
			AND DUE_DATE IS NOT NULL
			<cfif isdate(attributes.date1) and isdate(attributes.date2)>
				AND INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			<cfelseif isdate(attributes.date1)>
				AND INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
			<cfelseif isdate(attributes.date2)>
				AND INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			</cfif>
			<cfif isdefined("attributes.is_money2")>
				AND INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID
				AND INVOICE_MONEY.MONEY_TYPE = '#session.ep.money2#'
			</cfif>
		UNION ALL
		SELECT
			INVOICE_DATE,
			INVOICE_ID,
			MONTH(DUE_DATE) AS DUE_MONTH,
			YEAR(DUE_DATE) AS DUE_YEAR,
			0 AS NETTOTAL,
			NETTOTAL AS DAYTOTAL,
			<cfif isdefined("attributes.is_other_money")>
				0 AS OTHER_MONEY_VALUE,
				OTHER_MONEY_VALUE AS OTHER_MONEY_DAY_VALUE,
				OTHER_MONEY,
			</cfif>
			<cfif isdefined("attributes.is_money2")>
				0 AS OTHER_MONEY_VALUE_2,
				NETTOTAL/RATE2 AS OTHER_MONEY_DAY_VALUE_2,
			</cfif>
			PAY_METHOD
		FROM
			INVOICE
			<cfif isdefined("attributes.is_money2")>
				,INVOICE_MONEY
			</cfif>
		WHERE
			INVOICE_CAT IN (52,53,56,561,66,67,531)
			AND DUE_DATE IS NOT NULL
			<cfif isdate(attributes.date2)>
				AND INVOICE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			</cfif>	
			<cfif isdefined("attributes.is_money2")>
				AND INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID
				AND INVOICE_MONEY.MONEY_TYPE = '#session.ep.money2#'
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_invoices.recordcount = 0>
</cfif>
<cfform name="frm_search" action="index.cfm?fuseaction=report.daily_revenue_analyse" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40327.Tahsilat Tahmin Analiz Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
										<div class="col col-12"> 
											<select name="report_type" id="report_type" style="width:152px;">
												<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'> <cf_get_lang dictionary_id='58601.Bazında'></option>
												<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39374.Ödeme Yöntemi Bazında'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58690.Tarih Aralığı'>*</label>
										<div class="col col-6">
											<div class="input-group">
											   <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
												<cfinput value="#dateformat(attributes.date1,dateformat_style)#" type="text" maxlength="10" name="date1" style="width:65px;" required="yes" message="#message#" validate="#validate_style#">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="date1">
												</span>	
										    </div>	
										</div>
										<div class="col col-6">
											<div class="input-group">
											    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput value="#dateformat(attributes.date2,dateformat_style)#"  type="text" maxlength="10" name="date2" style="width:65px;" required="yes" message="#message#" validate="#validate_style#">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="date2">
												</span>
										    </div>		
                                        </div>	
									</div>
									<div class="form-group">
										<label class="col col-6 col-xs-6">
											<input type="checkbox" name="is_other_money" id="is_other_money" <cfif isdefined("attributes.is_other_money")>checked</cfif>><cf_get_lang dictionary_id='39646.İşlem Dövizi Göster'>
										</label>
										<label class="col col-6 col-xs-6">
												<cfif len(session.ep.money2)>
													<input type="checkbox" name="is_money2" id="is_money2" <cfif isdefined("attributes.is_money2")>checked</cfif>>2.<cf_get_lang dictionary_id='39647.Döviz Göster'>
												</cfif>
										</label>										                                            					
									</div>  	
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>                   
</cfform>

<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>

<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfset gunluk_toplam = 0>
<cfset fatura_toplam = 0>
<cfset gunluk_toplam2 = 0>
<cfset fatura_toplam2 = 0>
<cfoutput query="get_money">
	<cfset 'gunluk_toplam_#money#' = 0>
	<cfset 'fatura_toplam_#money#' = 0>
</cfoutput>
<cfset fatura_sayisi = 0>
<cfif get_invoices.recordcount>
	<cfquery name="get_all_total" dbtype="query">
		SELECT
			SUM(NETTOTAL) AS NETTOTAL
		FROM get_invoices
	</cfquery>
	<cfif len(get_all_total.NETTOTAL) >
		<cfset butun_toplam = get_all_total.NETTOTAL >
	<cfelse>
		<cfset butun_toplam = 1 >
	</cfif>
	<cfif attributes.report_type eq 1>
		<cfquery name="get_invoice_total" dbtype="query">
			SELECT
				SUM(NETTOTAL) AS NETTOTAL,
				SUM(DAYTOTAL) AS DAYTOTAL,
				<cfif isdefined("attributes.is_other_money")>
					SUM(OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
					SUM(OTHER_MONEY_DAY_VALUE) AS OTHER_MONEY_DAY_VALUE,
					OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					SUM(OTHER_MONEY_VALUE_2) AS OTHER_MONEY_VALUE_2,
					SUM(OTHER_MONEY_DAY_VALUE_2) AS OTHER_MONEY_DAY_VALUE_2,
				</cfif>
				DUE_MONTH,
				DUE_YEAR,
				COUNT(INVOICE_ID) AS INVOICE_COUNT
			FROM 
				get_invoices
			GROUP BY
				DUE_MONTH,
				DUE_YEAR
				<cfif isdefined("attributes.is_other_money")>
					,OTHER_MONEY
				</cfif>
			ORDER BY
				DUE_YEAR,
				DUE_MONTH
		</cfquery>
	<cfelse>
		<cfset paymethod_list=''>
		<cfquery name="get_invoice_total" dbtype="query">
			SELECT
				SUM(NETTOTAL) AS NETTOTAL,
				SUM(DAYTOTAL) AS DAYTOTAL,
				<cfif isdefined("attributes.is_other_money")>
					SUM(OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
					SUM(OTHER_MONEY_DAY_VALUE) AS OTHER_MONEY_DAY_VALUE,
					OTHER_MONEY,
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					SUM(OTHER_MONEY_VALUE_2) AS OTHER_MONEY_VALUE_2,
					SUM(OTHER_MONEY_DAY_VALUE_2) AS OTHER_MONEY_DAY_VALUE_2,
				</cfif>
				PAY_METHOD,
				COUNT(INVOICE_ID) AS INVOICE_COUNT
			FROM 
				get_invoices
			GROUP BY
				PAY_METHOD
				<cfif isdefined("attributes.is_other_money")>
					,OTHER_MONEY
				</cfif>
		</cfquery>
		<cfoutput query="get_invoice_total">
			 <cfif len(pay_method) and not listfind(paymethod_list,pay_method)>
				 <cfset paymethod_list=listappend(paymethod_list,pay_method)>
			 </cfif>
		 </cfoutput>
		 <cfif listlen(paymethod_list)>
			<cfset paymethod_list=listsort(paymethod_list,"numeric","ASC",',')>
			<cfquery name="get_paymethod" datasource="#dsn#">
				SELECT
					PAYMETHOD_ID,
					PAYMETHOD
				FROM 
					SETUP_PAYMETHOD 
				WHERE
					PAYMETHOD_ID IN (#paymethod_list#)
				ORDER BY
					PAYMETHOD_ID
			</cfquery>
			<cfset main_paymethod_list = listsort(listdeleteduplicates(valuelist(get_paymethod.paymethod_id,',')),'numeric','ASC',',')>
		</cfif>
	</cfif>
<cfelse>
	<cfset get_invoice_total.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_invoice_total.recordcount#'>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_invoice_total.recordcount>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isDefined("attributes.is_form_submitted")>
	<cf_report_list>
		<thead>			
			<tr>
				<cfif  attributes.report_type eq 1>
					<th><cf_get_lang dictionary_id='58472.Dönem'></th>
					<th><cf_get_lang dictionary_id='58724.Ay'></th>
				<cfelse>
					<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
				</cfif>
				<th width="100" align="right" style="text-align:right;"><cf_get_lang dictionary_id ='40304.Fatura Adedi'></th>
				<th width="12%" align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id ='58659.Toplamı'></th>
				<th style="text-align:center" nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				<cfif isdefined("attributes.is_other_money")>
					<th width="12%" align="right" style="text-align:right;"><cf_get_lang dictionary_id ='58121.İşlem Dövizi'><cf_get_lang dictionary_id ='57492.Toplam'></th>
					<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<th width="12%" align="right" style="text-align:right;">2.<cf_get_lang dictionary_id ='58124.Döviz Toplam'></th>
					<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				</cfif>
				<th align="right" style="text-align:right;">%</th>
				<th width="100" style="text-align:right" width="12%"><cfoutput>#dateformat(attributes.date2,dateformat_style)#</cfoutput> </th>
				<th style="text-align:center" nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				<cfif isdefined("attributes.is_other_money")>
					<th width="12%" style="text-align:right;"><cfoutput>#dateformat(attributes.date2,dateformat_style)#</cfoutput><cf_get_lang dictionary_id ='58121.İşlem Dövizi'><cf_get_lang dictionary_id ='57492.Toplam'></th>
					<th style="text-align:center" nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				</cfif>
				<cfif isdefined("attributes.is_money2")>
					<th width="12%" style="text-align:right;"><cfoutput>#dateformat(attributes.date2,dateformat_style)#</cfoutput> 2.<cf_get_lang dictionary_id ='58124.Döviz Toplam'></th>
					<th style="text-align:center" nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				</cfif>
			</tr>
		</thead>
		<cfif get_invoice_total.recordcount>
			<tbody>
				<cfoutput query="get_invoice_total" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<cfif attributes.report_type eq 1>
							<td>&nbsp;&nbsp;#due_year#</td>
							<td>&nbsp;&nbsp;#listgetat(aylar,due_month,',')#</td>
						<cfelse>
							<td>&nbsp;&nbsp;<cfif isdefined("main_paymethod_list")>#get_paymethod.paymethod[listfind(main_paymethod_list,pay_method,',')]#</cfif></td>
						</cfif>
						<td style="text-align:right;">#invoice_count#&nbsp;&nbsp;<cfset fatura_sayisi = fatura_sayisi +invoice_count></td>
						<td style="text-align:right;">#TLFormat(nettotal)# <cfset fatura_toplam = fatura_toplam +nettotal></td>
						<td style="text-align:center">&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td style="text-align:right;">#TLFormat(other_money_value)# </td>
							<td style="text-align:center">&nbsp;#other_money#</td>
							<cfset 'fatura_toplam_#other_money#' = evaluate('fatura_toplam_#other_money#') +other_money_value>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td style="text-align:right;">#TLFormat(other_money_value_2)#
							<cfset fatura_toplam2 = fatura_toplam2 +other_money_value_2></td>
							<td style="text-align:center">&nbsp;#session.ep.money2#</td>
						</cfif>
						<td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(nettotal*100/butun_toplam,"00.00"),".",",")#</cfif>&nbsp;&nbsp;</td>
						<td style="text-align:right;">#TLFormat(daytotal)# <cfset gunluk_toplam = gunluk_toplam +daytotal></td>
						<td style="text-align:center">&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td style="text-align:right;">#TLFormat(other_money_day_value)# </td>
							<td style="text-align:center">#other_money#</td>
							<cfset 'gunluk_toplam_#other_money#' = evaluate('gunluk_toplam_#other_money#') +other_money_day_value>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td style="text-align:right;">#TLFormat(other_money_day_value_2)# 
							<cfset gunluk_toplam2 = gunluk_toplam2 +other_money_day_value_2></td>
							<td style="text-align:center">&nbsp;#session.ep.money2#</td>
						</cfif>
					</tr>
				</cfoutput>
			</tbody>
			<tfoot>
				<cfoutput>
					<tr>
						<td class="txtbold" style="text-align:right;" <cfif  attributes.report_type eq 1>colspan="2"</cfif>><cf_get_lang dictionary_id ='57492.Toplam'>&nbsp;</td>
						<td class="txtbold" style="text-align:right;">#fatura_sayisi#&nbsp;&nbsp;</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(fatura_toplam)# </td>
						<td class="txtbold" style="text-align:center">&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td class="txtbold" style="text-align:right;">
								<cfloop query="get_money">
									<cfif evaluate('fatura_toplam_#get_money.money#') gt 0>
										#Tlformat(evaluate('fatura_toplam_#get_money.money#'))# <br/>
									</cfif>
								</cfloop>
							</td>
							<td class="txtbold" style="text-align:center;">
							<cfloop query="get_money">
									<cfif evaluate('fatura_toplam_#get_money.money#') gt 0>
										#get_money.money# <br/>
									</cfif>
								</cfloop>
						<!--- &nbsp;#get_money.money#--->
							</td>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td class="txtbold" style="text-align:right;">#TLFormat(fatura_toplam2)# </td>
							<td class="txtbold" style="text-align:center;">&nbsp;#session.ep.money2#</td>
						</cfif>
						<td class="txtbold" style="text-align:right;">#TLFormat(fatura_toplam*100/butun_toplam)#</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(gunluk_toplam)# </td>
						<td class="txtbold" style="text-align:center;">&nbsp;#session.ep.money#</td>
						<cfif isdefined("attributes.is_other_money")>
							<td class="txtbold" style="text-align:right;">
								<cfloop query="get_money">
									<cfif evaluate('gunluk_toplam_#get_money.money#') gt 0>
										#Tlformat(evaluate('gunluk_toplam_#get_money.money#'))# <br/>
									</cfif>
								</cfloop>
							</td>
							<td class="txtbold" style="text-align:center;">
							<cfloop query="get_money">
									<cfif evaluate('gunluk_toplam_#get_money.money#') gt 0>
										#get_money.money# <br/>
									</cfif>
								</cfloop>
							<!---#get_money.money#---></td>
						</cfif>
						<cfif isdefined("attributes.is_money2")>
							<td class="txtbold" style="text-align:right;">#TLFormat(gunluk_toplam2)# </td>
							<td class="txtbold" style="text-align:center;">&nbsp;#session.ep.money2#</td>
						</cfif>
					</tr>
				</cfoutput>
			</tfoot>
		<cfelse>
			<tr>
				<td colspan="16"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>			
	</cf_report_list>
</cfif>
<cfif isdefined('attributes.totalrecords') and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = attributes.fuseaction >
	<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
		<cfset url_str ="#url_str#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>
	<cfif isdefined('attributes.report_type') and len(attributes.report_type)>
		<cfset url_str ="#url_str#&report_type=#attributes.report_type#">
	</cfif>
	<cfif isDefined('attributes.date1') and len(attributes.date1)>
		<cfset url_str = '#url_str#&date1=#dateformat(attributes.date1,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.date2') and len(attributes.date2)>
		<cfset url_str = '#url_str#&date2=#dateformat(attributes.date2,dateformat_style)#'>
	</cfif>
	<cfif isdefined('attributes.is_other_money') and len(attributes.is_other_money)>
		<cfset url_str ="#url_str#&is_other_money=#attributes.is_other_money#">
	</cfif>
	<cfif isdefined('attributes.is_money2') and len(attributes.is_money2)>
		<cfset url_str ="#url_str#&is_money2=#attributes.is_money2#">
	</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#">	
</cfif>
<script>
    function control()
    {
		if ((document.frm_search.date1.value != '') && (document.frm_search.date2.value != '') &&
	    !date_check(frm_search.date1,frm_search.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
        if(document.frm_search.is_excel.checked==false)
                {
                    document.frm_search.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                    return true;
                }
                else
					document.frm_search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_daily_revenue_analyse</cfoutput>"  
    }
   
</script>