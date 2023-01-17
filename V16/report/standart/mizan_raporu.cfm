<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="22">
<<cfparam name="attributes.is_balance_acc" type="integer" default="1">
<cfinclude template="report_authority_control.cfm">
<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT
		BRANCH_ID,BRANCH_NAME
	FROM
		BRANCH  
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
	ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_max_len" datasource="#dsn2#">
	SELECT MAX(len(replace(ACCOUNT_PLAN.ACCOUNT_CODE, '.', '.' + ' ')) - len(ACCOUNT_PLAN.ACCOUNT_CODE)) MAX_LEN FROM ACCOUNT_PLAN
</cfquery>
<cfif fuseaction contains "popup"><cfset is_popup = 1><cfelse><cfset is_popup = 0></cfif>
<cfif not (isdefined('attributes.date1') and isdate(attributes.date1))>
	<cfset attributes.date1 = dateformat(session.ep.period_start_date,dateformat_style)>
</cfif>
<cfif not (isdefined('attributes.date2') and isdate(attributes.date2))>
	<cfset attributes.date2 = dateformat(session.ep.period_finish_date,dateformat_style)>
</cfif>
<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date1" >
	<cf_date tarih = "attributes.date2" >	
</cfif>
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.sub_accounts" default="0">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_branch_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.priority_type" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.money_type_" default="">
<cfif isdefined("attributes.form_varmi")>
	<cfinclude template="../query/get_scale_query.cfm">
</cfif>
<cfif isdate(attributes.date1) and isdate(attributes.date2)><!---burada dateformata çevrilmiş --->
	<cfset attributes.date1 = dateformat(attributes.date1,dateformat_style)>
	<cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
</cfif>	
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfform name="form" method="post" action="#request.self#?fuseaction=report.mizan_raporu">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='38886.Mizan'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.Islem Tipi'></label>
										<div class="col col-12">
											<cfquery name="get_acc_card_type" datasource="#dsn3#">
												SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
											</cfquery>
											<select multiple="multiple" name="acc_card_type" id="acc_card_type" style="width:200px;height:68px;">
												<cfoutput query="get_acc_card_type" group="process_type">
													<cfoutput>
													<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
													</cfoutput>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
										<div class="col col-12">
											<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" style="width:175px;height:67px;">
												<cfoutput query="get_branchs">
													<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58690.Tarih Aralığı'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
												<cfinput type="text" name="date1" id="date1" value="#attributes.date1#" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" maxlength="10">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="date1">
												</span>	
										    </div>	
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message1"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="date2" id="date2" value="#attributes.date2#" required="Yes" validate="#validate_style#" message="#message1#" style="width:65px;" maxlength="10">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="date2">
												</span>
										    </div>		
                                        </div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
										<div class="col col-6 col-xs-6">
											<div class="input-group">
												<cfinput type="text" name="acc_code1_1" style="width:69px;" value="#attributes.acc_code1_1#" maxlength="255" onFocus="AutoComplete_Create('acc_code1_1','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=form.acc_code1_1&keyword='+encodeURIComponent(form.acc_code1_1.value),'list');"></span>
												<cfoutput>
											</div>
										</div>	
										<div class="col col-6 col-xs-6">		
											<div class="input-group">		
												<cfinput type="text" name="acc_code2_1" style="width:69px;" value="#attributes.acc_code2_1#" maxlength="255" onFocus="AutoComplete_Create('acc_code2_1','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=form.acc_code2_1&keyword='+encodeURIComponent(form.acc_code2_1.value),'list');"></span>
												</cfoutput> 
											</div>	
									    </div>
                                    </div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
										<div class="col col-12 col-xs-12">
											<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
												<cfset project_id_ = attributes.project_id>
											<cfelse>
												<cfset project_id_ = ''>
											</cfif>
											<cf_wrkproject
												project_id="#project_id_#"
												width="155"
												agreementno="1" customer="2" employee="3" priority="4" stage="5" allproject="1"
												boxwidth="600"
												boxheight="400">
										</div>
									</div>
									<div>&nbsp;</div>
									<div class="form-group">
										<div class="col col-6 col-xs-6">
											<select name="priority_type" id="priority_type" style="width:120px;">
												<option value="0"><cf_get_lang dictionary_id='57485.Öncelik'></option>
												<option value="1" <cfif attributes.priority_type eq 1>selected</cfif>><cf_get_lang dictionary_id='59109.Rapor Tipi Öncelikli'></option>
											</select>                                       
										</div>
										<div class="col col-6 col-xs-6">
											<select name="report_type" id="report_type" style="width:100px;">
												<option value="0"><cf_get_lang dictionary_id='58960.Rapor Tipi'></option>
												<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57572.Departman'></option>
												<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57453.Sube'></option>
												<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
												<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='59110.Üst Proje'></option>
											</select>
										</div>	
									</div>	
                                </div>
							</div>
                            <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57648.Kur'></label>
										<div class="col col-6 col-xs-6">
											<select name="money" id="money" onchange="get_rate();">
												<cfoutput query="GET_MONEYS">
													<option value="#MONEY#" <cfif isdefined('attributes.money') and attributes.money eq MONEY>selected<cfelseif not isdefined('attributes.money') and MONEY eq SESSION.EP.MONEY>selected</cfif>>#MONEY#</option>
												</cfoutput>
											</select>
										</div>	
										<div class="col col-6 col-xs-6" >
											<cfif not isdefined('attributes.rate')><cfset attributes.rate = 1></cfif>
											<cfif not isdefined('attributes.money')><cfset attributes.money = SESSION.EP.MONEY></cfif>
											<input type="hidden" name="old_money" id="old_money" value="<cfoutput>#attributes.money#</cfoutput>">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='39358.Kur Bilgisi olarak Sayısal Değer Giriniz'></cfsavecontent>
											<cfinput type="text" name="rate" id="rate" class="moneybox" value="#TLFormat(attributes.rate,session.ep.our_company_info.rate_round_num)#" range="1," passthrough="onkeyup=""return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));""" message="#message#" required="yes" style="width:50px;">
										</div>									
									</div>  
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57677.Döviz'></label>
										<div class="col col-12 col-xs-12">
											<select name="money_type_" id="money_type_" style="width:100px;">
												<option value="1" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 1>selected</cfif>><cf_get_lang dictionary_id='57677.Döviz'></option>
												<option value="2" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 2>selected</cfif>>2.<cf_get_lang dictionary_id='57677.Döviz'></option>
												<option value="3" <cfif isDefined("attributes.money_type_") and attributes.money_type_ eq 3>selected</cfif>><cf_get_lang dictionary_id='58121.Islem Dövizi'></option>
											</select>
										</div>
									</div>            
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58818.hesaplar'></label>
										<div class="col col-12 col-xs-12">
											<select name="sub_accounts" id="sub_accounts" onchange="kontrol_report_type();" style="width:120px;">
												<option value="0" <cfif attributes.sub_accounts eq 0>selected</cfif>><cf_get_lang dictionary_id ='47399.Üst Hesaplar'></option>
												<cfloop from="1" to="#get_max_len.max_len#" index="kk">
													<option value="<cfoutput>#kk#</cfoutput>" <cfif attributes.sub_accounts eq kk>selected</cfif>><cfoutput>#kk#</cfoutput>.<cf_get_lang dictionary_id ='38887.Alt Hesaplar'></option>
												</cfloop>
												<option value="-1" <cfif attributes.sub_accounts eq -1>selected</cfif>><cf_get_lang dictionary_id ='39076.Tüm'><cf_get_lang dictionary_id ='38887.Alt Hesaplar'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<div>&nbsp;</div>	
										<div class="col col-12 col-xs-12">								
											<select name="acc_code_type" id="acc_code_type">
												<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
												<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
											</select>
										</div>										
								   </div>               
								</div>
							</div> 
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div>&nbsp;</div>
									<div class="form-group">
										<div>&nbsp;</div>
                                        <div class="col col-12 col-xs-12">
                                           <label>
											  <input type="checkbox" name="is_quantity" id="is_quantity" value="1" <cfif isdefined('attributes.is_quantity')>checked</cfif>><cf_get_lang dictionary_id ='59111.Miktar Göster'>
										   </label>
										</div>	
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<label>
												<input type="checkbox" name="show_main_account" id="show_main_account" value="0" <cfif isdefined('attributes.show_main_account')>checked<cfelseif attributes.sub_accounts eq 0>disabled</cfif>><cf_get_lang dictionary_id='47554.Üst Hesaplar Gelmesin'>
											</label>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<label>
												<input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>><cf_get_lang dictionary_id ='40363.Sadece Bakiyesi Olanlar'>
											</label>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<label>
												<input type="checkbox" name="no_process_accounts" id="no_process_accounts" value="0" <cfif isdefined('attributes.no_process_accounts')>checked</cfif>><cf_get_lang dictionary_id='47555.Hareket Görmeyenleri Getirme'> 
											</label>
										</div>
									</div>
									
                                    <div class="form-group">
                                        <div class="col col-12 col-xs-12">
                                            <label>
												<input type="checkbox" name="is_balance_acc" id="is_balance_acc" value="1" <cfif isdefined('attributes.is_balance_acc')>checked</cfif>><cf_get_lang dictionary_id='59300.Bilanço Hesapları Gelmesin'>
											</label> 
                                        </div>
									</div>
									<div class="form-group">
                                        <div class="col col-12 col-xs-12">
                                            <label>
												<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
											</label> 
                                        </div>
                                    </div>
								</div>
							</div>
							
						</div>
						<div class="ReportContentFooter pull-right">
							<input  type="hidden" name="form_varmi" id="form_varmi" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='unformat_fields()' is_excel='1'>
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
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_acc_remainder.recordcount>
</cfif>
<cfif isdefined("attributes.form_varmi")>
		<cfset setLocale("tr_TR")>
		<cf_report_list>
				<thead>
                	<cfset colspan_ = 5>
                    <cfif attributes.money_type_ eq 2>
                    	<cfset colspan_ = colspan_ + 4>
					</cfif>
                    <cfif attributes.money_type_ eq 3>
                    	<cfset colspan_ = colspan_ + 5>
					</cfif>
                    <cfif attributes.report_type neq 0>
                    	<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif isdefined('attributes.is_quantity')>
                    	<cfset colspan_ = colspan_ + 2>
                    </cfif>
					<tr>
						<th colspan="<cfoutput>#colspan_#</cfoutput>"><cfoutput>#session.ep.company#-#session.ep.period_year#&nbsp;&nbsp;&nbsp;#attributes.date1# - #attributes.date2#</cfoutput> <cf_get_lang dictionary_id='39363.Dönemi'> <cfoutput>#attributes.money#</cfoutput>  <cf_get_lang dictionary_id='38886.Mizan Planı'></th>
                        <th><cfoutput>#DateFormat(now(),dateformat_style)#</cfoutput></th>
					</tr>
					<tr>
						<th nowrap><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></th>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></th>
						<cfif attributes.report_type eq 1>
							<th><cf_get_lang dictionary_id="57453.Sube">-<cf_get_lang dictionary_id="57572.Departman"></th>
						<cfelseif attributes.report_type eq 2>
							<th><cf_get_lang dictionary_id="57453.Sube"></th>
						<cfelseif attributes.report_type eq 3>
							<th><cf_get_lang dictionary_id="57416.Proje"></th>
						<cfelseif attributes.report_type eq 4>
							<th><cf_get_lang dictionary_id="57416.Proje"></th>
						</cfif>
						<cfif isdefined('attributes.is_quantity')>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'><cf_get_lang dictionary_id='57635.Miktar'></th>
						</cfif>
						<th style="text-align:right;"><cf_get_lang dictionary_id ='57587.Borç'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id ='57588.Alacak'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id ='38891.Bakiye Borç'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id ='38892.Bakiye Alacak'></th>
						<cfif attributes.money_type_ eq 2><!--- sistem 2.dovizi bazında mizan --->
							<cfoutput>
                                <th style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id ='57587.Borç'></th>
                                <th style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id ='57588.Alacak'></th>
                                <th style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id ='38891.Bakiye Borç'></th>
                                <th style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id ='38892.Bakiye Alacak'></th>
							</cfoutput>
						</cfif>
						<cfif attributes.money_type_ eq 3><!--- islem dovizi bazında mizan --->
							<th nowrap style="text-align:right;"><cf_get_lang dictionary_id ='57862.İşlem Dövizi Borç'></th>
							<th nowrap style="text-align:right;"><cf_get_lang dictionary_id ='57863.İşlem Dövizi Alacak'></th>					
							<th nowrap style="text-align:right;"><cf_get_lang dictionary_id ='40430.İşlem Dövizi Bakiye Borç'></th>
							<th nowrap style="text-align:right;"><cf_get_lang dictionary_id ='40431.İşlem Dövizi Bakiye Alacak'></th>
							<th nowrap style="text-align:right;"><cf_get_lang dictionary_id ='58864.Para Birimi'></th>
						</cfif>
					</tr>
				</thead>
				<cfif isdefined("attributes.form_varmi") and get_acc_remainder.recordcount>		
					<cfscript>
						total_quantity_borc_all = 0;
						NewAccount = 0;
						total_quantity_alacak_all = 0;
						total_borc_all = 0;
						total_alacak_all = 0;
						total_bakiye_all = 0;
						borc_bakiye_tpl = 0;
						alacak_bakiye_tpl = 0;
						total_borc_all_2 = 0;
						total_alacak_all_2 = 0;
						total_bakiye_all_2 = 0;
						borc_bakiye_tpl_2 = 0;
						alacak_bakiye_tpl_2 = 0;
						acc_branch_id_list='';
						acc_dept_id_list='';
						acc_pro_id_list='';
						cost_profit_center_list='';
						row_colspan_number_=2;
						if(attributes.report_type eq 1)
							row_colspan_number_=row_colspan_number_+1;
						else if(attributes.report_type eq 2)
							row_colspan_number_=row_colspan_number_+1;
						else if(attributes.report_type eq 3)
							row_colspan_number_=row_colspan_number_+1;
						else if(attributes.report_type eq 4)
							row_colspan_number_=row_colspan_number_+1;
					</cfscript>
					<!--- Bir haneli ve iki haneli üst hesaplar için ilk olarak 0 değeri atanıyor. --->
					<cfloop from="0" to="99" index = "i">
						<cfset "a_#i#" = 0>
						<cfset "b_#i#" = 0>
						<cfset "b_a_#i#" = 0>
						<cfset "b_b_#i#" = 0>
					</cfloop>
					<!--- İlk hanesi ve 2. hanesi aynı olan alt hesapların bakiyeleri  üst hesaplarda toplanıyor.--->
					<cfoutput query="get_acc_remainder">
						<cfif len(ACCOUNT_CODE) eq 3>
							<cfset c = left(ACCOUNT_CODE,1)>
							<cfset "a_#c#" = precisionEvaluate(evaluate("a_#c#") + ALACAK)>
							<cfset "b_#c#" = precisionEvaluate(evaluate("b_#c#") + BORC)>
							<cfif BORC GT ALACAK>
								<cfset "b_b_#c#" = precisionEvaluate(evaluate("b_b_#c#") + BAKIYE)>
							<cfelseif BORC LT ALACAK>
								<cfset "b_a_#c#" = precisionEvaluate(evaluate("b_a_#c#") + BAKIYE)>
							</cfif>							
							<cfset d = left(ACCOUNT_CODE,2)>	
								<cfset "a_#d#" = precisionEvaluate(evaluate("a_#d#") + ALACAK)>
								<cfset "b_#d#" = precisionEvaluate(evaluate("b_#d#") + BORC)>
							<cfif BORC GT ALACAK>
								<cfset "b_b_#d#" = precisionEvaluate(evaluate("b_b_#d#") + BAKIYE)>	
							<cfelseif BORC LT ALACAK>
								<cfset "b_a_#d#" = precisionEvaluate(evaluate("b_a_#d#") + BAKIYE)>
							</cfif>
						</cfif>
					</cfoutput>
					<cfif len(attributes.report_type)>
						<cfoutput query="get_acc_remainder">
							<cfif attributes.report_type eq 1 and len(department_id) and not listfind(acc_dept_id_list,department_id)>
								<cfset acc_dept_id_list=listappend(acc_dept_id_list,department_id)>
							<cfelseif attributes.report_type eq 2 and len(branch_id) and not listfind(acc_branch_id_list,branch_id)>
								<cfset acc_branch_id_list=listappend(acc_branch_id_list,branch_id)>
							<cfelseif (attributes.report_type eq 3 or attributes.report_type eq 4) and len(acc_project_id) and not listfind(acc_pro_id_list,acc_project_id)>
								<cfset acc_pro_id_list=listappend(acc_pro_id_list,acc_project_id)>
							</cfif>
						</cfoutput>
						<cfif len(acc_dept_id_list)>
							<cfquery name="get_acc_dept" datasource="#dsn#">
								SELECT
									D.DEPARTMENT_ID,
									D.DEPARTMENT_HEAD,
									B.BRANCH_NAME
								FROM
									DEPARTMENT D,
									BRANCH B
								WHERE
									D.BRANCH_ID=B.BRANCH_ID
									AND D.DEPARTMENT_ID IN (#acc_dept_id_list#)
								ORDER BY
									D.DEPARTMENT_ID
							</cfquery>
							<cfset acc_dept_id_list=listsort(valuelist(get_acc_dept.DEPARTMENT_ID),'numeric','asc')>
						<cfelseif len(acc_branch_id_list)>
							<cfif len(acc_branch_id_list)>
								<cfquery name="get_acc_dept" datasource="#dsn#">
									SELECT
										B.BRANCH_ID,
										B.BRANCH_NAME
									FROM
										BRANCH B
									WHERE
										B.BRANCH_ID IN (#acc_branch_id_list#)
									ORDER BY
										B.BRANCH_ID
								</cfquery>
								<cfset acc_branch_id_list=listsort(valuelist(get_acc_dept.BRANCH_ID),'numeric','asc')>
							</cfif>
						</cfif>
						<cfif len(acc_pro_id_list)>
							<cfquery name="get_pro_detail" datasource="#dsn#">
								SELECT
									PROJECT_ID,
									PROJECT_HEAD
								FROM
									PRO_PROJECTS               
								WHERE
									PROJECT_ID IN (#acc_pro_id_list#)
								ORDER BY 
									PROJECT_ID
							</cfquery>
							<cfset acc_pro_id_list=listsort(valuelist(get_pro_detail.PROJECT_ID),'numeric','asc')>
						</cfif>
					</cfif>
					<tbody>
						<cfoutput query="get_acc_remainder">
							<cfset sonuc_ = BORC  - ALACAK>
						<cfif 
						(
							isdefined("attributes.is_bakiye") 
							and 
							(
								(
									(len(ACCOUNT_CODE) eq 1 or len(ACCOUNT_CODE) eq 2) AND
									(
									   evaluate("b_#left(ACCOUNT_CODE,2)#") neq 0 
									or evaluate("b_#left(ACCOUNT_CODE,1)#") neq 0 
									or evaluate("a_#left(ACCOUNT_CODE,2)#") neq 0 
									or evaluate("a_#left(ACCOUNT_CODE,1)#") neq 0 
									)
								)
									OR sonuc_ NEQ 0 
							)
						) OR not isdefined("attributes.is_bakiye")>
						<cfif 
						(
							isdefined("attributes.no_process_accounts") 
							and 
							( 
								(
									len(ACCOUNT_CODE) eq 1 AND evaluate("b_#left(ACCOUNT_CODE,1)#") neq 0 AND evaluate("a_#left(ACCOUNT_CODE,1)#") neq 0 
								)
								OR 
								(
									len(ACCOUNT_CODE) eq 2 AND evaluate("b_#left(ACCOUNT_CODE,2)#") neq 0 AND evaluate("a_#left(ACCOUNT_CODE,2)#") neq 0 
								)
							)		
								OR sonuc_ NEQ 0 
								OR (BORC NEQ 0 AND ALACAK NEQ 0)
							
						) OR not isdefined("attributes.no_process_accounts")>
							<cfset ikinci_hane_ = mid(ACCOUNT_CODE,2,1)>
							<cfset ilk_hane_ = left(ACCOUNT_CODE,1)>
							<cfparam name="attributes.totalrecords" default='#get_acc_remainder.recordcount#'>
							<cfif SUB_ACCOUNT eq 1><cfset str_line = "font-weight:bold"><cfelse><cfset str_line = "" ></cfif>
							<cfset new_acc_code = filterSpecialChars(listfirst(account_code,'.'))>
							<cfif SUB_ACCOUNT eq 1>
								<cfset account_code_ = ACCOUNT_CODE>
							</cfif>
							<tr>
								<td style="#str_line#">
									<cfif ListLen(account_code,".") neq 1 and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif>
									#account_code#
								</td>
								<td style="#str_line#" align="left">
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
									#account_name#
								<cfelse>
									<cfif type_ eq 1>
										#account_name#
									<cfelse>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=account.popup_list_scale&sub_accounts=#attributes.sub_accounts#&str_account_code=#account_code#&acc_code_type=#attributes.acc_code_type#&acc_branch_id=#attributes.acc_branch_id#&project_id=#project_id_#&date1=#attributes.date1#&date2=#attributes.date2#&report_type=#attributes.report_type#&priority_type=#attributes.priority_type#&money_type_=#attributes.money_type_#','wwide');">
											#account_name#
										</a>					
									</cfif>
								</cfif>			  
								</td>
								<cfif attributes.report_type eq 1>
									<td style="#str_line#">
										<cfif len(acc_dept_id_list) and len(department_id)>
											#get_acc_dept.BRANCH_NAME[listfind(acc_dept_id_list,department_id)]#-#get_acc_dept.DEPARTMENT_HEAD[listfind(acc_dept_id_list,department_id)]#
										</cfif>
									</td>
								<cfelseif attributes.report_type eq 2>
									<td style="#str_line#">
										<cfif len(acc_branch_id_list) and len(branch_id)>
											#get_acc_dept.BRANCH_NAME[listfind(acc_branch_id_list,branch_id)]#
										</cfif>
									</td>
								<cfelseif attributes.report_type eq 3 or attributes.report_type eq 4>
									<td style="#str_line#">
										<cfif len(acc_pro_id_list) and len(acc_project_id)>
											#get_pro_detail.PROJECT_HEAD[listfind(acc_pro_id_list,acc_project_id)]#
										</cfif>
									</td>
								</cfif>
								<cfif isdefined('attributes.is_quantity')>
									<td style="text-align:right;#str_line#" format="numeric">#TLFormat(QUANTITY_BORC)#</td>
									<td style="text-align:right;#str_line#" format="numeric">#TLFormat(QUANTITY_ALACAK)#</td>
								</cfif>
								<cfset BORC_ = precisionEvaluate(BORC / attributes.rate)>
								<cfset ALACAK_ = precisionEvaluate(ALACAK / attributes.rate)>
								<cfset BAKIYE_ = precisionEvaluate(BAKIYE / attributes.rate)>
								<td style="text-align:right;#str_line#" format="numeric">
									<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>	
									#lsnumberFormat(precisionEvaluate(evaluate("b_#left(ACCOUNT_CODE,1)#")),',__.00')#	<!---#TLFormat(evaluate("b_#left(ACCOUNT_CODE,1)#"))# --->
										<cfset borc_top = evaluate("b_#left(ACCOUNT_CODE,1)#")>
									<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>	
										#lsnumberFormat(precisionEvaluate(evaluate("b_#left(ACCOUNT_CODE,2)#")),',__.00')#	
										<cfset borc_top = evaluate("b_#left(ACCOUNT_CODE,2)#")>
									<cfelseif abs(BORC_) GT 0 >
										#lsnumberFormat(BORC_,',__.00')#		
										<cfset borc_top = abs(BORC_)>
									<cfelse>
										<cfset borc_top = 0>
									</cfif>		
								</td>
								<td style="text-align:right;#str_line#" format="numeric">
									<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>
										#lsnumberFormat(precisionEvaluate(evaluate("a_#left(ACCOUNT_CODE,1)#")),',__.00')#
										<cfset alac_top = evaluate("a_#left(ACCOUNT_CODE,1)#")>
									<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>			
										#lsnumberFormat(precisionEvaluate(evaluate("a_#left(ACCOUNT_CODE,2)#")),',__.00')#	
										<cfset alac_top = evaluate("a_#left(ACCOUNT_CODE,2)#")>
									<cfelseif abs(ALACAK_) GT 0>
										#lsnumberFormat(ALACAK_,',__.00')#	
										<cfset alac_top = abs(ALACAK_)>
									<cfelse>
										<cfset alac_top = 0>
									</cfif>		
								</td>
								<cfif borc_top GT alac_top>
									<td style="text-align:right;#str_line#" format="numeric">
										<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>
											<cfif abs(evaluate("b_b_#left(ACCOUNT_CODE,1)#")) gt abs(evaluate("b_a_#left(ACCOUNT_CODE,1)#"))>
												#lsnumberFormat(abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,1)#")))- abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,1)#"))),',__.00')# 
											</cfif>
										<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>	
											<cfif abs(evaluate("b_b_#left(ACCOUNT_CODE,2)#")) gt abs(evaluate("b_a_#left(ACCOUNT_CODE,2)#"))>
												#lsnumberFormat(abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,2)#"))) - abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,2)#"))),',__.00')# 
											</cfif>
										<cfelseif abs(BAKIYE_) gt 0>
											#lsnumberFormat(abs(BAKIYE_),',__.00')#	
										</cfif>	
										<cfif (isdefined('account_code_') and account_code_ neq ACCOUNT_CODE) or isDefined('attributes.show_main_account') or (attributes.sub_accounts eq 0)>
											<cfset borc_bakiye_tpl=precisionEvaluate(borc_bakiye_tpl+abs(BAKIYE_))>
										</cfif>
									</td>
									<td style="text-align:right;#str_line#"></td>
								<cfelseif borc_top LT alac_top>
									<td style="text-align:right;#str_line#"></td>				
									<td style="text-align:right;#str_line#" format="numeric">
										<cfif isdefined("ilk_hane_") and len(ACCOUNT_CODE) eq 1>
											<cfif abs(evaluate("b_a_#left(ACCOUNT_CODE,1)#")) gt abs(evaluate("b_b_#left(ACCOUNT_CODE,1)#"))>
												#lsnumberFormat(abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,1)#")))- abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,1)#"))),',__.00')# 
											</cfif>
										<cfelseif isdefined("ikinci_hane_") and len(ACCOUNT_CODE) eq 2>
											<cfif abs(evaluate("b_a_#left(ACCOUNT_CODE,2)#")) gt abs(evaluate("b_b_#left(ACCOUNT_CODE,2)#"))>			
												#lsnumberFormat(abs(precisionEvaluate(evaluate("b_a_#left(ACCOUNT_CODE,2)#"))) - abs(precisionEvaluate(evaluate("b_b_#left(ACCOUNT_CODE,2)#"))),',__.00')# 
											</cfif>
										<cfelseif abs(BAKIYE_) gt 0>
											#lsnumberFormat(abs(BAKIYE_),',__.00')#	
										</cfif>
										<cfif (isdefined('account_code_') and account_code_ neq ACCOUNT_CODE)  or isDefined('attributes.show_main_account') or (attributes.sub_accounts eq 0)>
											<cfset alacak_bakiye_tpl=precisionEvaluate(alacak_bakiye_tpl+abs(BAKIYE_))>
										</cfif>
									</td>
								<cfelse>
									<td style="text-align:right;#str_line#"></td>		
									<td style="text-align:right;#str_line#"></td>		
								</cfif>
								<cfif attributes.money_type_  eq 2><!--- sistem 2.dovizi bazında mizan --->
									<td nowrap style="text-align:right;#str_line#" format="numeric"><cfif BORC_2 GT 0>#TLFormat(BORC_2)# #session.ep.money2#</cfif></td>				
									<td nowrap style="text-align:right;#str_line#" format="numeric"><cfif ALACAK_2 GT 0>#TLFormat(ALACAK_2)# #session.ep.money2#</cfif></td>
									<cfif BORC_2 GT ALACAK_2>
										<td style="text-align:right;#str_line#" format="numeric"> #TLFormat(abs(BAKIYE_2))#
											<cfif ((not isdefined("is_exist_#new_acc_code#") and len(ACCOUNT_CODE) gte 3) or (listlen(ACCOUNT_CODE,'.') eq 1 and len(ACCOUNT_CODE) eq 3) or isdefined("attributes.show_main_account")) and len(account_code) gte 3>
												<cfset borc_bakiye_tpl_2=borc_bakiye_tpl_2+abs(BAKIYE_2)>
											</cfif>
										</td>
										<td style="text-align:right;#str_line#"></td>
									<cfelseif BORC_2 LT ALACAK_2>
										<td style="text-align:right;#str_line#"></td>				
										<td style="text-align:right;#str_line#" format="numeric"> #TLFormat(abs(BAKIYE_2))#
											<cfif ((not isdefined("is_exist_#new_acc_code#") and len(ACCOUNT_CODE) gte 3) or (listlen(ACCOUNT_CODE,'.') eq 1 and len(ACCOUNT_CODE) eq 3) or isdefined("attributes.show_main_account")) and len(account_code) gte 3>
												<cfset alacak_bakiye_tpl_2=alacak_bakiye_tpl_2+abs(BAKIYE_2)>
											</cfif>
										</td>
									<cfelse>
										<td style="text-align:right;#str_line#"></td>	
										<td style="text-align:right;#str_line#"></td>	
									</cfif>
								</cfif>
								<cfif attributes.money_type_  eq 3>
									<td nowrap style="text-align:right;#str_line#" format="numeric"><cfif OTHER_BORC GT 0>#TLFormat(OTHER_BORC)#</cfif></td>				
									<td nowrap style="text-align:right;#str_line#" format="numeric"><cfif OTHER_ALACAK GT 0>#TLFormat(OTHER_ALACAK)#</cfif></td>
									<cfif OTHER_BORC GT OTHER_ALACAK>
										<td style="text-align:right;#str_line#" format="numeric"> <cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif></td>
										<td style="text-align:right;#str_line#"></td>
									<cfelseif OTHER_BORC LT OTHER_ALACAK>
										<td style="text-align:right;#str_line#"></td>				
										<td style="text-align:right;#str_line#" format="numeric"><cfif len(OTHER_BAKIYE)>#TLFormat(abs(OTHER_BAKIYE))#</cfif> </td>
									<cfelse>
										<td style="text-align:right;#str_line#"></td>	
										<td style="text-align:right;#str_line#"></td>	
									</cfif>
									<td style="#str_line#">#OTHER_CURRENCY#</td>
								</cfif>	
								<cfif  (isdefined('account_code_') and account_code_ neq ACCOUNT_CODE)  or isDefined('attributes.show_main_account') or (attributes.sub_accounts eq 0)>
									<cfset total_borc_all=precisionEvaluate(total_borc_all+BORC_)>
									<cfset total_alacak_all=precisionEvaluate(total_alacak_all+ALACAK_)>
									<cfset total_bakiye_all=precisionEvaluate(total_bakiye_all+BAKIYE_)>
									<cfif attributes.money_type_  eq 2>	
										<cfset total_borc_all_2 = total_borc_all_2 + BORC_2>
										<cfset total_alacak_all_2 = total_alacak_all_2 + ALACAK_2>
										<cfset total_bakiye_all_2 = total_bakiye_all_2 + BAKIYE_2>
									</cfif>
									<cfif isdefined('attributes.is_quantity')>
										<cfset total_quantity_borc_all=total_quantity_borc_all+QUANTITY_BORC>
										<cfset total_quantity_alacak_all=total_quantity_alacak_all+QUANTITY_ALACAK>
									</cfif>
								</cfif>
								
							</tr>
						</cfif>
					</cfif>
					    </cfoutput>
					</tbody>
					<tbody>
						<tr>
						<cfoutput>
						<td colspan="#row_colspan_number_#" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
						<cfif isdefined('attributes.is_quantity')>
							<td class="txtbold" style="text-align:rig<ht;" format="numeric">#lsnumberFormat(total_quantity_borc_all,',__.00')#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#lsnumberFormat(total_quantity_alacak_all,',__.00')#</td>
						</cfif>
						<td class="txtbold" style="text-align:right;" format="numeric">#lsnumberFormat(total_borc_all,',__.00')#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#lsnumberFormat(total_alacak_all,',__.00')#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#lsnumberFormat(abs(borc_bakiye_tpl),',__.00')#</td>
						<td class="txtbold" style="text-align:right;" format="numeric">#lsnumberFormat(abs(alacak_bakiye_tpl),',__.00')#</td>
						<cfif attributes.money_type_  eq 2>
							<td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(wrk_round(total_borc_all_2))#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(wrk_round(total_alacak_all_2))#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(abs(wrk_round(borc_bakiye_tpl_2)))#</td>
							<td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(abs(wrk_round(alacak_bakiye_tpl_2)))#</td>
						</cfif>
						</cfoutput>
						<cfif attributes.money_type_  eq 3>
							<td colspan="5" class="txtbold" style="text-align:right;"></td>
						</cfif>
					</tr>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</tbody>
				</cfif>
			
		</cf_report_list>
		<!--- isteğe göre silindi tekrar kullanım olasılığı sebebiyle yorum satırına alındı.
		<cfif isdefined('attributes.totalrecords') and attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = attributes.fuseaction >
			<cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)>
				<cfset url_str ="#url_str#&form_varmi=#attributes.form_varmi#">
			</cfif>
			<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
				<cfset url_str ="#url_str#&acc_card_type=#attributes.acc_card_type#">
			</cfif>
			<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
				<cfset url_str ="#url_str#&acc_branch_id=#attributes.acc_branch_id#">
			</cfif>
			<cfif isdefined('attributes.priority_type') and len(attributes.priority_type)>
				<cfset url_str ="#url_str#&priority_type=#attributes.priority_type#">
			</cfif>
			<cfif isdefined('attributes.report_type') and len(attributes.report_type)>
				<cfset url_str ="#url_str#&report_type=#attributes.report_type#">
			</cfif>
			<cfif isdefined('attributes.is_quantity') and len(attributes.is_quantity)>
				<cfset url_str ="#url_str#&is_quantity=#attributes.is_quantity#">
			</cfif>
			<cfif isdefined('attributes.show_main_account') and len(attributes.show_main_account)>
				<cfset url_str ="#url_str#&show_main_account=#attributes.show_main_account#">
			</cfif>
			<cfif isdefined('attributes.sub_accounts') and len(attributes.sub_accounts)>
				<cfset url_str ="#url_str#&sub_accounts=#attributes.sub_accounts#">
			</cfif>
			<cfif isdefined('attributes.acc_code_type') and len(attributes.acc_code_type)>
				<cfset url_str ="#url_str#&acc_code_type=#attributes.acc_code_type#">
			</cfif>
			<cfif isdefined('attributes.is_bakiye') and len(attributes.is_bakiye)>
				<cfset url_str ="#url_str#&is_bakiye=#attributes.is_bakiye#">
			</cfif>
			<cfif isdate(attributes.date1) and isdefined("attributes.date1") and len(attributes.date1)>
			<cfset url_str = "#url_str#&date1=#dateformat(attributes.date1,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.date2) and isdefined("attributes.date2") and len(attributes.date2)>
				<cfset url_str = "#url_str#&date2=#dateformat(attributes.date2,dateformat_style)#">
			</cfif>
			<cfif isdefined('attributes.money_type_') and len(attributes.money_type_)>
				<cfset url_str ="#url_str#&money_type_=#attributes.money_type_#">
			</cfif>
			<cfif isdefined('attributes.money') and len(attributes.money)>
				<cfset url_str ="#url_str#&money=#attributes.money#">
			</cfif>
			<cfif isdefined('attributes.old_money') and len(attributes.old_money)>
				<cfset url_str ="#url_str#&old_money=#attributes.old_money#">
			</cfif>
			<cfif isdefined('attributes.rate') and len(attributes.rate)>
				<cfset url_str ="#url_str#&rate=#attributes.rate#">
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
				<cfset url_str ="#url_str#&project_id=#attributes.project_id#">
			</cfif>
			<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
				<cfset url_str ="#url_str#&project_head=#attributes.project_head#">
			</cfif>
			<cfif isdefined('attributes.no_process_accounts') and len(attributes.no_process_accounts)>
				<cfset url_str ="#url_str#&no_process_accounts=#attributes.no_process_accounts#">
			</cfif>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_str#">	
		</cfif>
		--->
</cfif> 
<script type="text/javascript">
	function kontrol_report_type()
	{
		if(document.form.sub_accounts.value == 0)
			document.form.show_main_account.disabled = true;
		else
			document.form.show_main_account.disabled = false;
	}
	rate_list = new Array(<cfloop query=get_moneys><cfoutput>"#get_moneys.rate2#"</cfoutput><cfif not currentrow eq recordcount>,</cfif></cfloop>);
	function unformat_fields()
	{
		document.form.rate.value = filterNum(document.form.rate.value);

		if ((document.form.date1.value != '') && (document.form.date2.value != '') &&
		!date_check(form.date1,form.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
		{	
	    return false;
	    }	

		if(document.form.is_excel.checked==false)
                {
                    document.form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                    return true;
                }
                else
					document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_mizan_raporu</cfoutput>" 
				
	
	}
	function control_scale_detail()
	{
		if(document.getElementById("money_type_").value != 1 && document.getElementById("money_type_").value != 3 && document.getElementById("money_type_").value != 2)
			document.getElementById("money_type_").value = 1;
		unformat_fields();
		return true;
	}
	function get_rate()
	{
		document.form.rate.value = commaSplit(rate_list[document.form.money.selectedIndex],'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function save_mizan_table()
	{
		if((document.form.date1.value=='') || (document.form.date2.value==''))
		{
			alert("<cf_get_lang dictionary_id ='39377.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date1=document.form.date1.value;
		date2=document.form.date2.value;
		windowopen('<cfoutput>#request.self#?fuseaction=account.popup_add_scale_table&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&date1='+date1+'&date2='+date2,'medium');
	}
	
	function kontrol_excel()
	{
		if(document.form.is_excel.checked == false)
			pdf_.style.display = '';
		else
			pdf_.style.display = 'none';
	}
	
	function kontrol_pdf()
	{
		if(document.form.pdf_aktar.checked == false)
			excel_.style.display = '';
		else
			excel_.style.display = 'none';
	}

	
</script>

