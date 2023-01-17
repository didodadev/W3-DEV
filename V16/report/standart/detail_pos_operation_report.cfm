<cfparam name="attributes.module_id_control" default="16">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.start_date" default="#now()#">
<cfparam name="attributes.finish_date" default="#now()#">
<cfparam name="attributes.pos_id" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.status" default=1>
<cfparam name="attributes.status_row" default="1">
<cfparam name="attributes.pos_operation_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfquery name="GET_POS_ALL" datasource="#DSN3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE POS_TYPE IS NOT NULL AND IS_ACTIVE = 1 ORDER BY (SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = BANK_ACCOUNT),LEFT(CARD_NO,3),ISNULL(NUMBER_OF_INSTALMENT,0)
</cfquery>
<cfquery name="GET_POS_OPERATION_ALL" datasource="#DSN3#">
	SELECT (SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = POS_ID) CARD_NO,POS_OPERATION_ID,POS_OPERATION_NAME FROM POS_OPERATION WITH (NOLOCK) ORDER BY POS_OPERATION_NAME
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>	
	<cfif (isDefined("attributes.pos_operation_id") and len(attributes.pos_operation_id))>
		<cfquery name="get_pos_operation" datasource="#dsn3#">
			SELECT
				(SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = POS_ID) CARD_NO,
				VOLUME,
				IS_FLAG,
				PERIOD_ID
			FROM 
				POS_OPERATION PO WITH (NOLOCK)
			WHERE
				POS_OPERATION_ID = #attributes.pos_operation_id#
		</cfquery>
		<cfquery name="getSetupPeriod" datasource="#dsn3#">
			SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD WITH (NOLOCK) WHERE PERIOD_ID = #get_pos_operation.period_id#
		</cfquery>
		<cfset dsn2_alias_ = '#dsn#_#getSetupPeriod.period_year#_#session.ep.company_id#'>
	<cfelse>
		<cfset dsn2_alias_ = '#dsn2#'>
	</cfif>
	<cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
	<cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
	<cfif attributes.report_type eq 1>
		<cfquery name="get_rule_row" datasource="#dsn3#">
			SELECT
				(SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = PO.POS_ID) CARD_NO,
				IS_FLAG,
				PO.* ,
				POA.RECORD_DATE AS ACT_DATE,
				(SELECT ISNULL(COUNT(*),0) FROM POS_OPERATION_ROW WITH (NOLOCK) WHERE POS_OPERATION_ID = PO.POS_OPERATION_ID) ALL_COUNT_1,
				(SELECT ISNULL(COUNT(*),0) FROM POS_OPERATION_ROW_HISTORY POR WITH (NOLOCK) WHERE POR.POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND POR.RESPONCE_CODE IN('-2')) ALL_COUNT_2,
				ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND IS_PAID = 1 AND POS_OPERATION_ID = PO.POS_OPERATION_ID),0) PAID_COUNT,
				ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND IS_PAID = 0 AND RESPONCE_CODE NOT IN('-2') AND POS_OPERATION_ID = PO.POS_OPERATION_ID),0) NOT_PAID_COUNT,
				ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND IS_PAID = 0 AND RESPONCE_CODE  = '-3' AND POS_OPERATION_ID = PO.POS_OPERATION_ID),0) DELETE_COUNT,
				(SELECT
						ISNULL(SUM(I.NETTOTAL),0)
					FROM 
						POS_OPERATION_ROW POO WITH (NOLOCK),
						SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
						#dsn2_alias_#.INVOICE I WITH (NOLOCK)
					WHERE 
						POO.POS_OPERATION_ID = PO.POS_OPERATION_ID
						AND POO.SUBSCRIPTION_PAYMENT_ROW_ID = SPR.SUBSCRIPTION_PAYMENT_ROW_ID
						AND SPR.INVOICE_ID = I.INVOICE_ID
				) ALL_AMOUNT_1,
				(SELECT
						ISNULL(SUM(I.NETTOTAL),0)
					FROM 
						POS_OPERATION_ROW_HISTORY POO WITH (NOLOCK),
						SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
						#dsn2_alias_#.INVOICE I WITH (NOLOCK)
					WHERE 
						POO.POS_OPERATION_ID = PO.POS_OPERATION_ID
                        AND POO.POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID
						AND POO.SUBSCRIPTION_PAYMENT_ROW_ID = SPR.SUBSCRIPTION_PAYMENT_ROW_ID
						AND SPR.INVOICE_ID = I.INVOICE_ID
						AND POO.RESPONCE_CODE IN('-2')
				) ALL_AMOUNT_2,
				ISNULL((SELECT SUM(INVOICE_NET_TOTAL) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND IS_PAID = 1 AND POS_OPERATION_ID = PO.POS_OPERATION_ID),0) PAID_AMOUNT,
				ISNULL((SELECT SUM(INVOICE_NET_TOTAL) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND IS_PAID = 0 AND RESPONCE_CODE NOT IN('-2') AND POS_OPERATION_ID = PO.POS_OPERATION_ID),0) NOT_PAID_AMOUNT,
				ISNULL((SELECT SUM(INVOICE_NET_TOTAL) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID AND IS_PAID = 0 AND RESPONCE_CODE = '-3' AND POS_OPERATION_ID = PO.POS_OPERATION_ID),0) DELETE_AMOUNT
			FROM 
				POS_OPERATION PO WITH (NOLOCK),
				POS_OPERATION_ACTIONS POA WITH (NOLOCK)
			WHERE
				PO.POS_OPERATION_ID = POA.POS_OPERATION_ID
				<cfif (isDefined("attributes.status") and len(attributes.status))>
					AND PO.IS_ACTIVE = #attributes.status# 
				</cfif>
				<cfif (isDefined("attributes.pos_id") and len(attributes.pos_id))>
					AND PO.POS_ID = #attributes.pos_id# 
				</cfif>
				<cfif (isDefined("attributes.pos_operation_id") and len(attributes.pos_operation_id))>
					AND PO.POS_OPERATION_ID = #attributes.pos_operation_id# 
				</cfif>
				<cfif len(attributes.start_date)>
					AND POA.RECORD_DATE >= #attributes.start_date#
				</cfif>
				<cfif len(attributes.finish_date)>
					AND POA.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
				</cfif>
				<cfif len(attributes.employee) and len(attributes.employee_id)>
					AND POA.RECORD_EMP  = #attributes.employee_id#
				</cfif>
			ORDER BY
				PO.POS_ID
		</cfquery>
	<cfelse>
		<cfquery name="get_rule_row" datasource="#dsn3#">
			SELECT
				(SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = PO.POS_ID) CARD_NO,
				PO.* ,
				POA.RECORD_DATE AS ACT_DATE	,
				SC.SUBSCRIPTION_NO,
				POH.INVOICE_NET_TOTAL NETTOTAL,
				POH.IS_PAID,
				POH.RESPONCE_CODE,
				SC.COMPANY_ID,
				SC.CONSUMER_ID
			FROM 
				POS_OPERATION PO WITH (NOLOCK),
				POS_OPERATION_ROW_HISTORY POH WITH (NOLOCK),
				POS_OPERATION_ACTIONS POA WITH (NOLOCK),
				SUBSCRIPTION_PAYMENT_PLAN_ROW SPR WITH (NOLOCK),
				SUBSCRIPTION_CONTRACT SC WITH (NOLOCK)
			WHERE
				PO.POS_OPERATION_ID = POA.POS_OPERATION_ID
				AND POH.POS_OPERATION_ACTION_ID = POA.POS_OPERATION_ACTION_ID
				AND POH.SUBSCRIPTION_PAYMENT_ROW_ID = SPR.SUBSCRIPTION_PAYMENT_ROW_ID
				AND SC.SUBSCRIPTION_ID = SPR.SUBSCRIPTION_ID
				<cfif (isDefined("attributes.status") and len(attributes.status))>
					AND PO.IS_ACTIVE = #attributes.status# 
				</cfif>
				<cfif isDefined("attributes.status_row") and attributes.status_row eq 1>
					AND POH.IS_PAID = 1
				<cfelseif isDefined("attributes.status_row") and attributes.status_row eq 0>
					AND POH.IS_PAID = 0
					AND POH.RESPONCE_CODE NOT IN('-2')
				<cfelseif isDefined("attributes.status_row") and attributes.status_row eq 2>
					AND POH.RESPONCE_CODE IN('-3')
				<cfelse>
					AND POH.RESPONCE_CODE NOT IN('-2')
				</cfif>
				<cfif (isDefined("attributes.pos_id") and len(attributes.pos_id))>
					AND PO.POS_ID = #attributes.pos_id# 
				</cfif>
				<cfif (isDefined("attributes.pos_operation_id") and len(attributes.pos_operation_id))>
					AND PO.POS_OPERATION_ID = #attributes.pos_operation_id# 
				</cfif>
				<cfif len(attributes.start_date)>
					AND POA.RECORD_DATE >= #attributes.start_date#
				</cfif>
				<cfif len(attributes.finish_date)>
					AND POA.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
				</cfif>
                		<cfif len(attributes.employee) and len(attributes.employee_id)>
					AND POA.RECORD_EMP  = #attributes.employee_id#
				</cfif>
			ORDER BY
				PO.POS_ID
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_rule_row.recordcount = 0>
</cfif>
<cfif isdate(attributes.start_date)><cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)></cfif>
<cfif isdate(attributes.finish_date)><cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)></cfif>
<cfform name="bank_list" action="#request.self#?fuseaction=report.detail_pos_operation_report" method="post">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39610.Otomatik Sanal Pos Analizi'></cfsavecontent>	
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
		<div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
					<div class="row" type="row">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="39613.Kural"></label>
									<div class="col col-12 col-xs-12">
										<select name="pos_operation_id" id="pos_operation_id" style="width:250px;">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<cfoutput query="get_pos_operation_all">
												<option value="#pos_operation_id#" <cfif attributes.pos_operation_id eq pos_operation_id>selected</cfif>>#pos_operation_name#-#card_no#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58586.İşlem Yapan'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
											<input type="text" name="employee" id="employee" style="width:250px;"  onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','250');"value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
											<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=bank_list.employee_id&field_name=bank_list.employee&select_list=1','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label  class="col col-12 col-xs-12" id="status1" width="80" <cfif attributes.report_type eq 1>style="display:none;"</cfif>><cf_get_lang dictionary_id="40030.Rapor Durumu"></label>
									<div class="col col-12 col-xs-12" id="status2" <cfif attributes.report_type eq 1>style="display:none;"</cfif>>	
										<select name="status_row" id="status_row" style="width:80px;">
											<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
											<option value="1"<cfif isDefined("attributes.status_row") and (attributes.status_row eq 1)> selected</cfif>><cf_get_lang dictionary_id="55387.Başarılı"></option>
											<option value="0"<cfif isDefined("attributes.status_row") and (attributes.status_row eq 0)> selected</cfif>><cf_get_lang dictionary_id="58197.Başarısız"></option>
											<option value="2"<cfif isDefined("attributes.status_row") and (attributes.status_row eq 2)> selected</cfif>><cf_get_lang dictionary_id="29721.Silindi"></option>
										</select>									
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="39615.Pos Tipi"></label>
									<div class="col col-12 col-xs-12">
										<select name="pos_id" id="pos_id" style="width:250px;">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<cfoutput query="get_pos_all">
												<option value="#PAYMENT_TYPE_ID#" <cfif attributes.pos_id eq PAYMENT_TYPE_ID>selected</cfif>>#CARD_NO#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>							
											<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" required="yes" message="#message#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
											<cfinput type="text" name="finish_date" value="#attributes.finish_date#"  validate="#validate_style#" required="yes" message="#message#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
										</div>
									</div>
								</div>
							</div>	
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type" onchange="kontrol_report_type();">
											<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57660.Belge Bazında"></option>
											<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id="29539.Satır Bazında"></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57756.durum"></label>
									<div class="col col-12 col-xs-12">
										<select name="status" id="status" style="width:80px;">
											<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
											<option value="1"<cfif isDefined("attributes.status") and (attributes.status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
											<option value="0"<cfif isDefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
										</select>
									</div>
								</div>
							</div>
						</div>
				    </div>
		        </div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>checked</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
						<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
						<cf_wrk_report_search_button is_excel='1' button_type='1' insert_info='#message#' search_function='control()'>            
                    </div>
                </div>
			</div>
		</div>
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel is 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_rule_row.recordcount>
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="detail_pos_operation_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">  	
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
<cf_report_list>
	<cfparam name="attributes.totalrecords" default='#get_rule_row.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfif attributes.report_type eq 1>
				<thead>
					<tr>
						<th colspan="5"></th>
						<th colspan="4" align="center"><cf_get_lang dictionary_id="58082.Adet"></th>
						<th colspan="4" align="center"><cf_get_lang dictionary_id="57673.Tutar"></th>
					</tr>
					<tr>
						<th width="40"><cf_get_lang dictionary_id="57487.Sıra"></th>
						<th width="100"><cf_get_lang dictionary_id="58233.Tanım"></th>
						<th width="100"><cf_get_lang dictionary_id="57679.POS"></th>
						<th width="100"><cf_get_lang dictionary_id="57742.Tarih"></th>
						<th width="75"><cf_get_lang dictionary_id='30114.Hacim'></th>
						<th width="75"><cf_get_lang dictionary_id="57492.Toplam"></th>
						<th width="75"><cf_get_lang dictionary_id="55387.Başarılı"></th>
						<th width="75"><cf_get_lang dictionary_id="58197.Başarısız"></th>
						<th width="75"><cf_get_lang dictionary_id="39624.Silinen"></th>
						<th width="75"><cf_get_lang dictionary_id="57492.Toplam"></th>
						<th width="75"><cf_get_lang dictionary_id="55387.Başarılı"></th>
						<th width="75"><cf_get_lang dictionary_id="58197.Başarısız"></th>
						<th><cf_get_lang dictionary_id="39624.Silinen"></th>
					</tr>
				</thead>
				<cfif get_rule_row.recordcount>
					<tbody>
						<cfoutput query="get_rule_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif is_active eq 0><cfset font_ = "FF0000"><cfelse><cfset font_ = ""></cfif>
							<tr>
								<td><font color="#font_#">#currentrow#</font></td>
								<td><font color="#font_#">#pos_operation_name#</font></td>
								<td><font color="#font_#">#card_no#</font></td>
								<td><font color="#font_#">#dateformat(dateadd('h',session.ep.time_zone,act_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,act_date),timeformat_style)#)</font></td>
								<td align="right"><font color="#font_#">#TLFormat(volume)#</font></td>
								<td align="right"><font color="#font_#"><cfif is_flag eq 1>#TLFormat(all_count_1+all_count_2,0)#<cfelse>#TLFormat(all_count_2,0)#</cfif></font></td>
								<td align="right"><font color="#font_#">#TLFormat(paid_count,0)#</font></td>
								<td align="right"><font color="#font_#">#TLFormat(not_paid_count,0)#</font></td>
								<td align="right"><font color="#font_#">#TLFormat(delete_count,0)#</font></td>
								<td align="right"><font color="#font_#"><cfif is_flag eq 1>#TLFormat(all_amount_1+all_amount_2)#<cfelse>#TLFormat(all_amount_2)#</cfif></font></td>
								<td align="right"><font color="#font_#">#TLFormat(paid_amount)#</font></td>
								<td align="right"><font color="#font_#">#TLFormat(not_paid_amount)#</font></td>
								<td align="right"><font color="#font_#">#TLFormat(delete_amount)#</font></td>
							</tr>
						</cfoutput>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="13"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif>!</td>
						</tr>
					</tbody>
				</cfif>
		<cfelse>
				<thead>
					<tr>
						<th width="20"><cf_get_lang dictionary_id="57487.No"></th>
						<th width="100"><cf_get_lang dictionary_id="58233.Tanım"></th>
						<th width="120"><cf_get_lang dictionary_id="57679.POS"></th>
						<th width="120"><cf_get_lang dictionary_id="57742.Tarih"></th>
						<th width="120"><cf_get_lang dictionary_id="29502.Sistem No"></th>
						<th width="250"><cf_get_lang dictionary_id="57519.Cari Hesap"></th>
						<th width="100"><cf_get_lang dictionary_id="39144.Tahsilat Tarihi"></th>
						<th width="100"><cf_get_lang dictionary_id="57673.Tutar"></th>
						<th width="100"><cf_get_lang dictionary_id="57756.Durum"></th>
						<th><cf_get_lang dictionary_id="40568.Hata Kodu"></th>
					</tr>
				</thead>
				<cfif get_rule_row.recordcount>
					<cfset company_id_list=''>
					<cfset consumer_id_list=''>
					<cfoutput query="get_rule_row" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(company_id) and company_id gt 0 and not listfind(company_id_list,company_id)>
							<cfset company_id_list=listappend(company_id_list,company_id)>
						</cfif>
						<cfif len(consumer_id) and consumer_id gt 0 and not listfind(consumer_id_list,consumer_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
						</cfif>
					</cfoutput>
					<cfset company_id_list=listsort(company_id_list,"numeric")>
					<cfset consumer_id_list=listsort(consumer_id_list,"numeric")>
					<cfif len(company_id_list)>
						<cfquery name="get_company_detail" datasource="#DSN#">
							SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfquery name="get_consumer_detail" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<tbody>
						<cfoutput query="get_rule_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif is_active eq 0><cfset font_ = "FF0000"><cfelse><cfset font_ = ""></cfif>
							<tr>
								<td><font color="#font_#">#currentrow#</font></td>
								<td><font color="#font_#">#pos_operation_name#</font></td>
								<td><font color="#font_#">#card_no#</font></td>
								<td><font color="#font_#">#dateformat(dateadd('h',session.ep.time_zone,act_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,act_date),timeformat_style)#)</font></td>
								<td><font color="#font_#">#subscription_no#</font></td>
								<td>
									<cfif len(company_id) and company_id gt 0>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');"><font color="#font_#">#get_company_detail.FULLNAME[listfind(company_id_list,company_id,',')]#</font></a>
									<cfelseif len(consumer_id) and consumer_id gt 0>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');"><font color="#font_#">#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CON_ID,',')]#</font></a>
									</cfif>
								</td>
								<td><font color="#font_#">#dateformat(dateadd('h',session.ep.time_zone,act_date),dateformat_style)#</font></td>
								<td align="right"><font color="#font_#">#TLFormat(nettotal)#</font></td>
								<td><font color="#font_#"><cfif is_paid eq 1><cf_get_lang dictionary_id="55387.Başarılı"><cfelseif is_paid eq 0><cf_get_lang dictionary_id="58197.Başarısız"><cfelse><cf_get_lang dictionary_id="29721.Silindi"></cfif></font></td>
								<td><font color="#font_#"><cfif not listfind('-3,-2,-1',responce_code)>#responce_code#</cfif></font></td>
							</tr>
						</cfoutput>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="10"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif>!</td>
						</tr>
					</tbody>
				</cfif>
				</tbody>
		</cfif>
</cf_report_list>
	<cfif not (isdefined('attributes.is_excel') and  attributes.is_excel is 1)>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres="report.detail_pos_operation_report">
			<cfif isDefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
				<cfset adres = '#adres#&is_form_submitted=#attributes.is_form_submitted#'>
			</cfif>
			<cfif isDefined('attributes.report_type') and len(attributes.report_type)>
				<cfset adres = '#adres#&report_type=#attributes.report_type#'>
			</cfif>
			<cfif isDefined('attributes.status') and len(attributes.status)>
				<cfset adres = '#adres#&status=#attributes.status#'>
			</cfif>
			<cfif isDefined('attributes.status_row') and len(attributes.status_row)>
				<cfset adres = '#adres#&status_row=#attributes.status_row#'>
			</cfif>
			<cfif isDefined('attributes.pos_id') and len(attributes.pos_id)>
				<cfset adres = '#adres#&pos_id=#attributes.pos_id#'>
			</cfif>
			<cfif isDefined('attributes.pos_operation_id') and len(attributes.pos_operation_id)>
				<cfset adres = '#adres#&pos_operation_id=#attributes.pos_operation_id#'>
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
			</cfif>
			<cfif len(attributes.employee)>
				<cfset adres = "#adres#&employee=#attributes.employee#">
			</cfif>
			<cfif len(attributes.employee_id)>
				<cfset adres = "#adres#&employee_id=#attributes.employee_id#">
			</cfif>			
					<cf_paging page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#"
						adres="#adres#">
		</cfif>	
	</cfif>
</cfif>
<script type="text/javascript">
	function control()
	{	if ((document.bank_list.start_date.value != '') && (document.bank_list.finish_date.value != '') &&
	    !date_check(bank_list.start_date,bank_list.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.bank_list.is_excel.checked==false)
			{
				document.bank_list.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.detail_pos_operation_report"
				return true;
			}
		else
			{
				document.bank_list.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_pos_operation_report</cfoutput>"
			}
				
	}
</script>
<script language="javascript">
	function kontrol_report_type()
	{
		if(document.getElementById('report_type').value == 1)
		{
			document.getElementById('status1').style.display = 'none';
			document.getElementById('status2').style.display = 'none';
		}
		else
		{
			document.getElementById('status1').style.display = 'block';
			document.getElementById('status2').style.display = 'block';
		}
	}
</script>

