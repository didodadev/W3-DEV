<!--- DBS Analizi Raporu 20121127 --->
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.due_start_date" default="">
<cfparam name="attributes.due_finish_date" default="">
<cfparam name="attributes.bank" default="">
<cfparam name="attributes.pay_method" default="">
<cfparam name="attributes.money_type" default="">
<cfparam name="attributes.is_document" default="">
<cfparam name="attributes.is_cash" default="">
<cfparam name="attributes.is_cancel" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.money" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfset genel_toplam = 0>
<cfset genel_ind_toplam = 0>
<cfset genel_son_toplam = 0>
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="get_paymethod" datasource="#dsn#">
	SELECT 
		SP.PAYMETHOD,
		SP.PAYMETHOD_ID 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		SP.PAYMETHOD
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN3#">
	SELECT COUNT(OTHER_MONEY),OTHER_MONEY AS MONEY FROM INVOICE_PAYMENT_PLAN GROUP BY OTHER_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
    <cfset 'genel_toplam_#money#' = 0>
</cfoutput>
<cfif isdefined("attributes.is_form")>
	<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	<cfif isdate(attributes.due_start_date)>
		<cf_date tarih = "attributes.due_start_date">
	</cfif>
	<cfif isdate(attributes.due_finish_date)>
		<cf_date tarih = "attributes.due_finish_date">
	</cfif>
	<cfquery name="get_dbs_row" datasource="#dsn3#">
            SELECT
                INVOICE_PAYMENT_PLAN_ID,
                INVOICE_NUMBER,
                INVOICE_DATE,
                DUE_DATE,
                PAYMENT_METHOD_ROW,
                (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = PAYMENT_METHOD_ROW) PAYMETHOD,
                (SELECT FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = INVOICE_PAYMENT_PLAN.COMPANY_ID) COMPANY_NAME,
                INVOICE_PAYMENT_PLAN.ACTION_VALUE,
                INVOICE_PAYMENT_PLAN.OTHER_ACTION_VALUE,
                INVOICE_PAYMENT_PLAN.OTHER_MONEY,
                FILE_ID,
                IS_BANK,
                IS_PAID,
                IS_ACTIVE,
                BANK_ACTION_ID,
                BANK_PERIOD_ID,
                RESULT_DETAIL,
                RESULT_CODE,
                ISNULL(DISCOUNT_TOTAL,0) DISCOUNT_TOTAL,	<!--- Iskontolu tutar : Eger 0 ise iskonto yok, 0'dan farklı bir deger ise iskontolu demektir --->
                PAYMENT_DATE								<!--- faturanin odenedigi tarih --->
            FROM 
                INVOICE_PAYMENT_PLAN
            WHERE
                1=1
                <cfif len(attributes.start_date)>AND INVOICE_DATE >= #attributes.start_date#</cfif>
                <cfif len(attributes.finish_date)>AND INVOICE_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
                <cfif len(attributes.due_start_date)>AND DUE_DATE >= #attributes.due_start_date#</cfif>
                <cfif len(attributes.due_finish_date)>AND DUE_DATE < #date_add("d",1,attributes.due_finish_date)#</cfif>
                <cfif len(attributes.pay_method)>
                    AND PAYMENT_METHOD_ROW = #attributes.pay_method#
                </cfif>
                <cfif len(attributes.bank)>
                    AND PAYMENT_METHOD_ROW IN (SELECT PAYMETHOD_ID FROM #dsn_alias#.SETUP_PAYMETHOD WHERE BANK_ID = #attributes.bank#)
                </cfif>
                <cfif len(attributes.money_type)>
                    AND INVOICE_PAYMENT_PLAN.OTHER_MONEY = '#attributes.money_type#'
                </cfif>
                <cfif len(attributes.is_cancel) and attributes.is_cancel neq -1>
                    AND IS_ACTIVE = #attributes.is_cancel#
                </cfif>
                <cfif len(attributes.is_document) and attributes.is_document neq -1>
                    AND IS_BANK = #attributes.is_document#
                </cfif>
                <cfif len(attributes.is_cash) and attributes.is_cash neq -1>
                    <cfif len(attributes.is_cash) and attributes.is_cash eq 1> 
                        AND IS_PAID = #attributes.is_cash#
                    <cfelseif len(attributes.is_cash) and attributes.is_cash eq 0> 
                        AND IS_PAID = #attributes.is_cash#
                    </cfif>
                </cfif>
                <cfif len(attributes.is_cash) and attributes.is_cash eq 2>
                    AND DISCOUNT_TOTAL <> 0
                </cfif>
                <cfif len(attributes.company_id) and len(attributes.company)>
                    AND COMPANY_ID=#attributes.company_id#
                </cfif>
	</cfquery>	
	<cfparam name="attributes.totalrecords" default="#get_dbs_row.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>	
<cfform name="form_" method="post" action="#request.self#?fuseaction=report.dbs_report">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='59170.DBS Analizi'></cfsavecontent>
	<cf_report_list_search id="dbs_" title="#title#">
		<cf_report_list_search_area>
		<div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
					<div class="row" type="row">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12 " > <cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
									<div class="col col-6">									
										<div class="input-group">
											<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										</div>
									</div>
									<div class="col col-6">									
										<div class="input-group">
											<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="due_start_date" value="#dateformat(attributes.due_start_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="due_start_date"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="due_finish_date" value="#dateformat(attributes.due_finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="due_finish_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="text" name="company" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','company_id','','3','120');" value="<cfif len(attributes.company)><cfoutput>#URLDecode(company)#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_id=form_.company_id&field_member_name=form_.company&field_name=form_.company','list','popup_list_pars');"></span>
											</div>
										</div>
								</div>
							</div>	
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
										<label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='57521.Banka'></label>
									<div class="col col-12 col-xs-12">
										<select name="bank" id="bank">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_bank_names">
											<option value="#bank_id#" <cfif attributes.bank eq bank_id>selected</cfif>>#bank_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12 " ><cf_get_lang dictionary_id='57489.Para Birimi'></label>
									<div class="col col-12 col-xs-12">
										<select name="money_type" id="money_type">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfoutput query="get_money_rate">
												<option value="#money#" <cfif attributes.money_type eq money>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</div>
								</div>	
								<div class="form-group">
										<label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
									<div class="col col-12 col-xs-12">
										<select name="pay_method" id="pay_method">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfoutput query="get_paymethod">
												<option value="#paymethod_id#" <cfif listfind(attributes.pay_method,get_paymethod.paymethod_id,',')>selected</cfif>>#paymethod#</option>
											</cfoutput>
										</select>		
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12 "><cf_get_lang dictionary_id='58506.İptal'><cf_get_lang dictionary_id='30111.Durumu'></label>
									<div class="col col-12 col-xs-12">
										<select name="is_cancel" id="is_cancel">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<option value="-1"><cf_get_lang dictionary_id='57708.Tümü'></option>
											<option value="0" <cfif attributes.is_cancel eq 0>selected</cfif>><cf_get_lang dictionary_id='58816.İptal Edildi'></option>
											<option value="1" <cfif attributes.is_cancel eq 1>selected</cfif>><cf_get_lang dictionary_id='58817.İptal Edilmedi'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='30020.Tahsil'> <cf_get_lang dictionary_id='30111.Durumu'></label>
										<div class="col col-12 col-xs-12">
											<select name="is_cash" id="is_cash">
												<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1" <cfif attributes.is_cash eq 1>selected</cfif>><cf_get_lang dictionary_id='39650.Tahsil Edildi'></option>
												<option value="0" <cfif attributes.is_cash eq 0>selected</cfif>><cf_get_lang dictionary_id='59173.Tahsil Edilmedi'></option>
												<option value="2" <cfif attributes.is_cash eq 2>selected</cfif>><cf_get_lang dictionary_id='59182.İskontolu Tahsil Edildi'></option>
											</select>
										</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59183.Dosya Bilgisi'></label>
									<div class="col col-12 col-xs-12">
										<select name="is_document" id="is_document">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<option value="-1"><cf_get_lang dictionary_id='57708.Tümü'></option>
											<option value="1" <cfif attributes.is_document eq 1>selected</cfif>><cf_get_lang dictionary_id='59184.Oluşturuldu'></option>
											<option value="0" <cfif attributes.is_document eq 0>selected</cfif>><cf_get_lang dictionary_id='59185.Oluşturulmadı'></option>
										</select>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter"> 
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi Hatasi Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" range="1,999" required="yes" message="#message#" style="width:25px;" maxlength="3">
						<input name="is_form" id="is_form" value="1" type="hidden">
						<cfsavecontent variable="buttonMessage"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
						<cf_wrk_report_search_button is_upd='0' is_cancel='0' insert_info='#buttonMessage#' search_function='kontrol()' button_type='1' is_excel="1">	
					</div>
				</div>
			</div>
		</div>
	
	<!-- sil -->
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<cfif IsDefined("attributes.is_form")>
<cf_report_list>	
	<cfsavecontent variable="excel_icerik">
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<!-- sil -->
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_dbs_row.recordcount>
	</cfif>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58759.Fatura Tarihi'></th>
				<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
				<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
				<th><cf_get_lang dictionary_id='58516.Odeme Yontemi'></th>
				<th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                <th><cf_get_lang dictionary_id='59186.Faturanın Ödenediği Tarih'></th>
				<th ><cf_get_lang dictionary_id='57673.Tutar'></th>
                <th ><cf_get_lang dictionary_id='39697.İskonto Tutar'></th>
                <th><cf_get_lang dictionary_id='59187.İskontolu Tahsil Edilen Tutar'> </th>
				<th><cf_get_lang dictionary_id='39656.Doviz Tutar'></th>
				<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th><cf_get_lang dictionary_id='59188.Akıbet Kodu'></th>
				<th><cf_get_lang dictionary_id='59189.Akıbet Açıklaması'></th>
				<th><cf_get_lang dictionary_id='57691.Dosya'></th>
				<th><cf_get_lang dictionary_id='57845.Tahsilat'></th>
			</tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.is_form") and get_dbs_row.recordcount>
				<cfset toplam1 = 0>
                <cfset toplam2 = 0>
                <cfset toplam3 = 0>
				<cfoutput query="get_dbs_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset toplam1 = toplam1 + action_value>
                    <cfif is_paid eq 1>
                    	<cfset toplam2 = toplam2 + discount_total>
                        <cfset toplam3 = toplam3 + (action_value-discount_total)>
                    </cfif>
                    <cfif IsDefined('toplam_#other_money#')>
                        <cfset 'toplam_#other_money#' = evaluate('toplam_#other_money#') + other_action_value>
                    </cfif>
                        <tr>
                            <td>#currentrow#</td>
                            <td>#dateFormat(invoice_date,dateformat_style)#</td>
                            <td>#invoice_number#</td>
                            <td>#company_name#</td>
                            <td>#paymethod#</td>
                            <td>#dateFormat(due_date,dateformat_style)#</td>
                            <td>#dateFormat(payment_date,dateformat_style)#</td>
                            <td >#tlFormat(action_value)#</td>
                            <td>#tlFormat(discount_total)#</td>
                            <td><cfif is_paid eq 1>#tlFormat(action_value-discount_total)#<cfelse>#tlFormat(0)# #session.ep.money#</cfif></td>
                            <td>#tlFormat(other_action_value)#</td>
                            <td>#other_money#</td>
                            <td>#result_code#</td>
                            <td>#result_detail#</td>
                            <td>
                                <cfif is_bank eq 1 and is_active eq 1>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_open_multi_prov_file&export_import_id=#file_id#','small');"><img src="/images/attach.gif" alt=""></a>
                                <cfelseif is_bank eq 1 and is_active eq 0>
                                    <font color="##FF0000"><cf_get_lang dictionary_id='59190.İptal Edildi'></font>
                                </cfif>
                            </td>
                            <td>
                                <cfif is_paid eq 1>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.popup_dsp_gelenh&id=#bank_action_id#&period_id=#bank_period_id#','small');"><img src="/images/ship_list.gif" alt=""></a>
                                </cfif>
                            </td>
                        </tr>
				</cfoutput>
                <cfoutput>
					<tr>
						<td class="txtbold" style="text-align:right;" colspan="7"><cf_get_lang dictionary_id='57492.Toplam'></td>
                        <td class="txtbold" style="text-align:right;" nowrap="nowrap">#tlFormat(toplam1)# #session.ep.money#</td>
                        <td class="txtbold" style="text-align:right;" nowrap="nowrap">#tlFormat(toplam2)# #session.ep.money#</td>
                        <td class="txtbold" style="text-align:right;" nowrap="nowrap">#tlFormat(toplam3)# #session.ep.money#</td>
                        <td class="txtbold" style="text-align:right;" nowrap="nowrap">
                        <cfloop query="get_money">
							<cfif evaluate('toplam_#money#') neq 0>
                            	#tlFormat(evaluate('toplam_#money#'))# <br />
                            </cfif>
                        </cfloop>
                        </td>
                        <td class="txtbold" style="text-align:left;" nowrap="nowrap" colspan="5">
                        <cfloop query="get_money">
							<cfif evaluate('toplam_#money#') neq 0>
                         		#money# <br />
                            </cfif>
                        </cfloop>
                        </td>
					</tr>
                    <cfif attributes.page gte (get_dbs_row.recordcount/attributes.maxrows)>
                    	<cfloop query="get_dbs_row">
                        	 <cfif IsDefined('toplam_#other_money#')>
                        	 	<cfset 'genel_toplam_#other_money#' = evaluate('genel_toplam_#other_money#') + other_action_value>
                                <cfset genel_toplam = genel_toplam + action_value>
                                <cfif is_paid eq 1>
                               		<cfset genel_ind_toplam = genel_ind_toplam + discount_total>
									<cfset genel_son_toplam = genel_son_toplam + (action_value-discount_total)>
                                </cfif>
                             </cfif>
                        </cfloop>
                        <tr>
                        	<td class="txtbold" style="text-align:right;" colspan="7"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                        	<td class="txtbold" style="text-align:right;" nowrap="nowrap">#tlFormat(genel_toplam)# #session.ep.money#</td>
                        	<td class="txtbold" style="text-align:right;" nowrap="nowrap">#tlFormat(genel_ind_toplam)# #session.ep.money#</td>
                        	<td class="txtbold" style="text-align:right;" nowrap="nowrap">#tlFormat(genel_son_toplam)# #session.ep.money#</td>
                            <td class="txtbold" style="text-align:right;" nowrap="nowrap">
                                <cfloop query="get_money">
                                    <cfif evaluate('genel_toplam_#money#') neq 0>
                                        #tlFormat(evaluate('genel_toplam_#money#'))# <br />
                                    </cfif>
                                </cfloop>
                            </td>
                            <td class="txtbold" style="text-align:left;" nowrap="nowrap" colspan="5">
                                <cfloop query="get_money">
                                    <cfif evaluate('genel_toplam_#money#') neq 0>
                                        #money# <br />
                                    </cfif>
                                </cfloop>
                            </td>
                     	</tr>     
                    </cfif>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="16"><cfif not isdefined("attributes.is_form")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<!-- sil -->
		</cfif>
	</cfsavecontent>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfoutput>#wrk_content_clear(excel_icerik)#</cfoutput>
	<cfelse>
		<cfoutput>#excel_icerik#</cfoutput>
	</cfif>	
</cf_report_list>	
<cfif isdefined("attributes.is_form")> 
	<cfset url_str = "report.dbs_report&is_form=1">
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.due_start_date)>
		<cfset url_str = "#url_str#&due_start_date=#dateformat(attributes.due_start_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.due_finish_date)>
		<cfset url_str = "#url_str#&due_finish_date=#dateformat(attributes.due_finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.bank)>
		<cfset url_str = "#url_str#&bank=#attributes.bank#">
	</cfif>
	<cfif len(attributes.pay_method)>
		<cfset url_str = "#url_str#&pay_method=#attributes.pay_method#">
	</cfif>
	<cfif len(attributes.money_type)>
		<cfset url_str = "#url_str#&money_type=#attributes.money_type#">
	</cfif>
	<cfif len(attributes.is_document)>
		<cfset url_str = "#url_str#&is_document=#attributes.is_document#">
	</cfif>
	<cfif len(attributes.is_cash)>
		<cfset url_str = "#url_str#&is_cash=#attributes.is_cash#">
	</cfif>
	<cfif len(attributes.is_cancel)>
		<cfset url_str = "#url_str#&is_cancel=#attributes.is_cancel#">
	</cfif>
    <cfif len(attributes.company_id)>
		<cfset url_str = '#url_str#&company_id=#attributes.company_id#'>
	</cfif>
	<cfif len(attributes.company)>
		<cfset url_str = '#url_str#&company=#attributes.company#'>
	</cfif>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#">
	 </cfif>
</cfif>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('is_excel').checked==false)
		{
			document.form_.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.dbs_report</cfoutput>";
			return true;
		}
		else
			document.form_.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_dbs_report</cfoutput>";
	}
</script>