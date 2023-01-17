<cfquery name="GET_SALES" datasource="#DSN#">
	SELECT 
    	COMPANY_DEBIT_POSTPONE_ID, 
        COMPANY_ID, 
        BRANCH_ID, 
        RELATED_ID, 
        PROCESS_CAT, 
        PROCESS_DATE, 
        DETAIL, 
        IS_JOB_ADD,
        IS_JOB_CONTINUE, 
        IS_JOB_POSTPONE, 
        JOB_ADD_DETAIL, 
        JOB_CONTINUE_DETAIL, 
        JOB_POSTPONE_DETAIL_TOTAL, 
        DEBT_REASON_DETAIL, 
        MANAGER_IDEA_DETAIL, 
        POSTPONE_PAY_NETTOTAL1, 
        POSTPONE_PAY_NETTOTAL2, 
        POSTPONE_PAY_NETTOTAL3, 
        POSTPONE_PAY_NET_DUEDATE1, 
        POSTPONE_PAY_NET_DUEDATE2, 
        POSTPONE_PAY_NET_DUEDATE3, 
        DUEDATE_DIFF_RATE, 
        DUEDATE_DIFF_KDV, 
        DUEDATE_DIFF_TOTAL, 
        POSTPONE_DAY_NUMBER, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE, 
        IS_SUBMIT 
    FROM 
    	COMPANY_DEBIT_POSTPONE 
    WHERE 
    	COMPANY_DEBIT_POSTPONE_ID = #attributes.debit_postpone_id#
</cfquery>

<cfquery name="GET_SALES_ROW" datasource="#DSN#">
	SELECT 
    	POSTPONE_ROW_ID, 
        POSTPONE_ID, 
        TYPE_ID,
        COMPANY_ID, 
        POSTPONE_DEBT_TYPE, 
        POSTPONE_DUE_DATE, 
        POSTPONE_TOTAL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP	 
    FROM 
    	COMPANY_DEBIT_POSTPONE_ROW 
    WHERE 
    	POSTPONE_ID = #attributes.debit_postpone_id#
</cfquery>

<cfquery name="GET_SALES_ROW_1" dbtype="query">
	SELECT * FROM GET_SALES_ROW WHERE TYPE_ID = 1
</cfquery>
<cfquery name="GET_SALES_ROW_2" dbtype="query">
	SELECT * FROM GET_SALES_ROW WHERE TYPE_ID = 2
</cfquery>
<cfquery name="GET_SALES_ROW_3" dbtype="query">
	SELECT * FROM GET_SALES_ROW WHERE TYPE_ID = 3
</cfquery>

<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #get_sales.company_id# AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
</cfquery>

<cfquery name="GET_BRANCH_" dbtype="query">
	SELECT BRANCH_NAME, BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #get_sales.branch_id#
</cfquery>

<cfquery name="GET_RELATED_BRANCH" dbtype="query">
	SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
</cfquery>
<div class="col col-12 col-xs-12">
	<div class="col col-9 col-xs-12">  
		<cf_box title="#getLang('','Borç Erteleme Talebi',52188)#" info_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#get_sales.company_id#')" info_title_3="#getLang('','Müşteri Teminatları','52294')#" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.debit_postpone_id#&print_type=400" print_title="#getLang('','Yazdır',57474)#">	
			<cfform name="upd_debit" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_postpone_debit">
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#get_sales.company_id#</cfoutput>">
				<input type="hidden" name="debit_postpone_id" id="debit_postpone_id" value="<cfoutput>#attributes.debit_postpone_id#</cfoutput>">
				<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="<cfoutput>#attributes.is_normal_form#</cfoutput>"></cfif>
				<cf_box_elements>
					<cfoutput>
						<div class="col col-6 col-xs-12"  type="column" index="1" sort="true">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-8 col-xs-12">
									<input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_sales.is_active eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57457.Müşteri'></label>
								<div class="col col-8 col-xs-12">
									#get_sales.company_id#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="fullname" id="fullname" value="#get_par_info(get_sales.company_id,1,1,0)#">#get_par_info(get_sales.company_id,1,1,0)#
								</div>
							</div>
						</div>
						<div class="col col-6 col-xs-12"  type="column" index="2" sort="true">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='52056.Talep Eden Şube'></label>
								<div class="col col-8 col-xs-12">
									<select disabled>
										<cfoutput><option value="">#get_branch_.branch_name#</option></cfoutput>
									</select>
									<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_sales.branch_id#</cfoutput>">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value = '#get_sales.process_cat#' process_cat_width='150' is_detail='1'>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
								<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="process_date" id="process_date" value="<cfoutput>#DateFormat(get_sales.process_date,dateformat_style)#</cfoutput>">
									<span class="input-group-addon"><cf_wrk_date_image date_field='process_date'></span>
								</div>
								</div>
							</div>
						</div>
					</cfoutput>
				</cf_box_elements>	
				<cf_box_footer>
					<cf_record_info query_name="get_sales">
					<cfif (not (len(get_sales.is_submit) and (get_sales.is_submit eq 1))) or (session.ep.admin eq 1)>
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=crm.emptypopup_del_postpone_debit&debit_postpone_id=#attributes.debit_postpone_id#'>
					</cfif>
				</cf_box_footer>
				<!--- Eczane Bilgileri -Ortak- --->
				<cfset none_style_ = 1>
				
				<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
				<div id="eczane_bilgi_detaylari_">
					<cfset attributes.consumer_id = get_sales.company_id>
					<cfinclude template="../display/display_customer_info.cfm">
				</div>
				<!--- ECZANE HAKKINDA AÇIKLAYICI BİLGİ --->
				<cf_seperator title="#getLang('','Eczane Hakkında Açıklayıcı Bilgi',52327)#" id="eczane_bilgileri">
				<div id="eczane_bilgileri">
					<cf_box_elements>
						<div class="col col-6 col-xs-12"  type="column" index="3" sort="true">
							<div class="form-group">
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52332.Eczanenin Ek İşi Var Mı'></div>
								<div class="col col-6 col-xs-12">
									<div class="col col-3 col-xs-12">
									<input type="radio" value="1" name="is_job_add" id="is_job_add" <cfif get_sales.is_job_add eq 1>checked</cfif> onClick="goster(job_add_span);"><cf_get_lang dictionary_id='58564.Var'>
									</div>
									<div class="col col-3 col-xs-12">
									<input type="radio" value="0" name="is_job_add" id="is_job_add" <cfif get_sales.is_job_add eq 0>checked</cfif> onClick="gizle(job_add_span);document.upd_debit.job_add_detail.value='';"><cf_get_lang dictionary_id='58546.Yok'>
									</div>
								</div>
							</div>
							<div class="form-group" id="job_add_span" <cfif get_sales.is_job_add neq 1>style="display:none;"</cfif>>
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52328.Faaliyet Alanı'></div>
								<div class="col col-6 col-xs-12">
									<input type="text" name="job_add_detail" id="job_add_detail"  value="<cfoutput>#get_sales.job_add_detail#</cfoutput>" maxlength="100">
								</div>
							</div>
							<div class="form-group">
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52329.Eczaneye Mal Verilmeye Devam Edilecek Mi'></div>
								<div class="col col-6 col-xs-12">
									<div class="col col-3 col-xs-12">
										<input type="radio" value="1" name="is_job_continue" id="is_job_continue" <cfif get_sales.is_job_continue eq 1>checked</cfif> onClick="goster(job_continue_span);"><cf_get_lang dictionary_id='57495.Evet'>
									</div>
									<div class="col col-3 col-xs-12">
										<input type="radio" value="0"  name="is_job_continue" id="is_job_continue" <cfif get_sales.is_job_continue eq 0>checked</cfif> onClick="gizle(job_continue_span);document.upd_debit.job_continue_detail.value='';"><cf_get_lang dictionary_id='57496.Hayır'>
									</div>
								</div>
							</div>
							<div class="form-group" id="job_continue_span" <cfif get_sales.is_job_continue eq 0>style="display:none;"</cfif>>
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52330.Çalışma Şartları'></div>
								<div class="col col-6 col-xs-12">
									<input type="text" name="job_continue_detail" id="job_continue_detail" value="<cfoutput>#get_sales.job_continue_detail#</cfoutput>" maxlength="100">
								</div>
							</div>
							<div class="form-group">
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52331.Eczanenin Daha Önce Ertelemesi Mevcut Mu'></div>
								<div class="col col-6 col-xs-12">
									<div class="col col-3 col-xs-12">
										<input type="radio" value="1" name="is_job_postpone" id="is_job_postpone" <cfif get_sales.is_job_postpone eq 1>checked</cfif> onClick="goster(job_postpone_span);"><cf_get_lang dictionary_id='57495.Evet'>
									</div>
									<div class="col col-3 col-xs-12">
										<input type="radio" value="0" name="is_job_postpone" id="is_job_postpone" <cfif get_sales.is_job_postpone eq 0>checked</cfif> onClick="gizle(job_postpone_span);document.upd_debit.job_postpone_detail_total.value='<cfoutput>#TLFormat(0)#</cfoutput>'"><cf_get_lang dictionary_id='57496.Hayır'>
									</div>
								</div>
							</div>
							<div class="form-group" id="job_postpone_span" <cfif get_sales.is_job_postpone neq 1>style="display:none;"</cfif>>
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></div>
								<div class="col col-6 col-xs-12">
									<input type="text" name="job_postpone_detail_total" id="job_postpone_detail_total" class="moneybox" value="<cfoutput>#TLFormat(get_sales.job_postpone_detail_total)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));">
								</div>
							</div>
						</div>
						<div class="col col-6 col-xs-12"  type="column" index="4" sort="true">
							<div class="form-group">
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52333.Eczanenin Ödeme Güçlüğüne Düşme Sebebi'></div>
								<div class="col col-6 col-xs-12">
									<textarea  name="debt_reason_detail" id="debt_reason_detail"  maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_sales.debt_reason_detail#</cfoutput></textarea>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52334.Eczane Hakkında Şube Müdürünün Görüşleri'></div>
								<div class="col col-6 col-xs-12">
									<textarea  name="manager_idea_detail" id="manager_idea_detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_sales.manager_idea_detail#</cfoutput></textarea>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></div>
								<div class="col col-6 col-xs-12">
									<textarea  name="detail" id="detail"><cfoutput>#get_sales.detail#</cfoutput></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
				</div>
				<!--- //ECZANE HAKKINDA AÇIKLAYICI BİLGİ --->
				<cf_seperator title="#getLang('','Eczane Borç Bilgileri',52335)#" id="borc_tutar_detaylari">
				<div id="borc_tutar_detaylari">
					<div class="col col-12 col-xs-12">
						<div class="col col-6 col-sm-8 col-xs-12">
							<!--- ERTELEME YAPILACAK BORÇLAR --->
							<cf_grid_list sort="0">
								<thead>
									<tr>
										<th colspan="4" align="center" width="275"><cf_get_lang dictionary_id='52336.Erteleme Yapılacak Borçlar'></th>
									</tr>
									<tr>
										<th width="15">
											<input name="record_num1" id="record_num1" type="hidden" value="<cfoutput>#get_sales_row_1.recordcount#</cfoutput>">
											<a href="javascript://" onClick="add_row(1);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
										</th>
										<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
										<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
										<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
									</tr>
								</thead>
								<tbody id="table1" name="table1">
									<cfoutput query="get_sales_row_1">
										<tr id="frm_row#type_id#_#currentrow#">
											<td><input type="hidden" name="postpone_row_id#type_id#_#currentrow#" id="postpone_row_id#type_id#_#currentrow#" value="#postpone_row_id#">
												<input type="hidden" value="1" name="row_kontrol#type_id#_#currentrow#" id="row_kontrol#type_id#_#currentrow#">
												<a href="javascript://" onclick="sil('#type_id#_#currentrow#','#type_id#','#currentrow#');"><i class="fa fa-minus" border="0"></i></a>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="text" name="postpone_due_date#type_id#_#currentrow#" id="postpone_due_date#type_id#_#currentrow#" value="#Dateformat(postpone_due_date,dateformat_style)#"  onChange="hesapla_ortalama_vade_(1);">
														<span class="input-group-addon"><cf_wrk_date_image date_field='postpone_due_date#type_id#_#currentrow#'></span>
													</div>
												</div>
											</td>
											<td>
												<div class="form-group">
													<select name="postpone_debt_type#type_id#_#currentrow#" id="postpone_debt_type#type_id#_#currentrow#">
														<option value="1" <cfif postpone_debt_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58007.Çek'></option>
														<option value="2" <cfif postpone_debt_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58008.Senet'></option>
														<option value="3" <cfif postpone_debt_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57147.Açık Hesap'></option>
														<option value="4" <cfif postpone_debt_type eq 4>selected</cfif>><cf_get_lang dictionary_id='52358.ÇSİ'></option>
													</select>
												</div>
											</td>
											<td><div class="form-group"><input type="text" name="postpone_total#type_id#_#currentrow#" id="postpone_total#type_id#_#currentrow#" value="#TLFormat(postpone_total)#" class="moneybox"  onKeyUp="hesapla_toplam_(1);return(FormatCurrency(this,event));"></div></td>
										</tr>
									</cfoutput>
								</tbody>
								<tfoot>
									<tr>
										<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td colspan="2">&nbsp;<input type="text" name="postpone_pay_nettotal_1" id="postpone_pay_nettotal_1" class="moneybox" readonly value="<cfoutput>#TLFormat(get_sales.postpone_pay_nettotal1)#</cfoutput>"></td>
									</tr>
									<tr>
										<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
										<td colspan="2">&nbsp;<input type="text" name="postpone_pay_net_duedate_1" id="postpone_pay_net_duedate_1" readonly value="<cfoutput>#Dateformat(get_sales.postpone_pay_net_duedate1,dateformat_style)#</cfoutput>"></td>
									</tr>
								</tfoot>
							</cf_grid_list>
							<!--- //ERTELEME YAPILACAK BORÇLAR --->
						</div>
						<div class="col col-6 col-sm-8 col-xs-12">
							<!--- GÜNÜ GELMEMİŞ BORÇLAR --->
							<cf_grid_list sort="0">
								<thead>
									<tr>
										<th colspan="4"><cf_get_lang dictionary_id='52337.Günü Gelmemiş Borçlar'></th>
									</tr>
									<tr>
										<th width="15">
											<input name="record_num2" id="record_num2" type="hidden" value="<cfoutput>#get_sales_row_2.recordcount#</cfoutput>">
											<a href="javascript://" onClick="add_row(2);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
										</th>
										<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
										<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
										<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
									</tr>
								</thead>
								<tbody name="table2" id="table2">
									<cfoutput query="get_sales_row_2">
										<tr id="frm_row#type_id#_#currentrow#" class="color-list" align="center">
											<td><input type="hidden" name="postpone_row_id#type_id#_#currentrow#" id="postpone_row_id#type_id#_#currentrow#" value="#postpone_row_id#">
												<input type="hidden" value="1" name="row_kontrol#type_id#_#currentrow#" id="row_kontrol#type_id#_#currentrow#">
												<a href="javascript://" onclick="sil('row_kontrol#type_id#_#currentrow#','#type_id#','#currentrow#');"><i class="fa fa-minus" border="0"></i></a>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="text" name="postpone_due_date#type_id#_#currentrow#" id="postpone_due_date#type_id#_#currentrow#" value="#Dateformat(postpone_due_date,dateformat_style)#" onChange="hesapla_ortalama_vade_(2);">
														<span class="input-group-addon"><cf_wrk_date_image date_field='postpone_due_date#type_id#_#currentrow#'></span>
													</div>
												</div>
											</td>
											<td>
												<div class="form-group">
													<select name="postpone_debt_type#type_id#_#currentrow#" id="postpone_debt_type#type_id#_#currentrow#">
														<option value="1" <cfif postpone_debt_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58007.Çek'></option>
														<option value="2" <cfif postpone_debt_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58008.Senet'></option>
														<option value="3" <cfif postpone_debt_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57147.Açık Hesap'></option>
														<option value="4" <cfif postpone_debt_type eq 4>selected</cfif>><cf_get_lang dictionary_id='52358.ÇSİ'></option>
													</select>
												</div>
											</td>
											<td><div class="form-group"><input type="text" name="postpone_total#type_id#_#currentrow#" id="postpone_total#type_id#_#currentrow#" value="#TLFormat(postpone_total)#" class="moneybox" onKeyUp="hesapla_toplam_(2);return(FormatCurrency(this,event));"></div></td>
										</tr>
									</cfoutput>
								</tbody>
								<tfoot>
									<tr>
										<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td colspan="2">&nbsp;<input type="text" name="postpone_pay_nettotal_2" id="postpone_pay_nettotal_2" class="moneybox" readonly value="<cfoutput>#TLFormat(get_sales.postpone_pay_nettotal2)#</cfoutput>"></td>
									</tr>
									<tr>
										<td colspan="2"style="text-align:right;"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
										<td colspan="2">&nbsp;<input type="text" name="postpone_pay_net_duedate_2" id="postpone_pay_net_duedate_2" readonly value="<cfoutput>#dateFormat(get_sales.postpone_pay_net_duedate2,dateformat_style)#</cfoutput>"></td>
									</tr>
								</tfoot>
							</cf_grid_list>
						<!--- //GÜNÜ GELMEMİŞ BORÇLAR --->
						</div>
					</div>
					<div class="col col-12 col-xs-12">
						<div class="col col-6 col-sm-8 col-xs-12">
							<!--- YENİ ÖDEME ŞEKLİ --->
							<cf_grid_list sort="0">
								<thead>
									<tr>
										<th colspan="4" width="275" align="center"><cf_get_lang dictionary_id='52338.Yeni Ödeme Şekli'></th>
									</tr>
									<tr>
										<th width="15">
											<input name="record_num3" id="record_num3" type="hidden" value="<cfoutput>#get_sales_row_3.recordcount#</cfoutput>">
											<a href="javascript://" onClick="add_row(3);"><i class="fa fa-plus"title="<cf_get_lang dictionary_id='57582.Ekle'>"  border="0"></i></a>
										</th>
										<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
										<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
										<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
									</tr>
								</thead>
								<tbody name="table3" id="table3">
									<cfoutput query="get_sales_row_3">
										<tr id="frm_row#type_id#_#currentrow#" class="color-list" align="center">
											<td><input type="hidden" name="postpone_row_id#type_id#_#currentrow#" id="postpone_row_id#type_id#_#currentrow#" value="#postpone_row_id#">
												<input type="hidden" value="1" name="row_kontrol#type_id#_#currentrow#" id="row_kontrol#type_id#_#currentrow#">
												<a href="javascript://" onclick="sil('#type_id#_#currentrow#','#type_id#','#currentrow#');"><i class="fa fa-minus" border="0"></i></a>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="text" name="postpone_due_date#type_id#_#currentrow#" id="postpone_due_date#type_id#_#currentrow#" value="#Dateformat(postpone_due_date,dateformat_style)#"  onChange="hesapla_ortalama_vade_(3);">
														<span class="input-group-addon"><cf_wrk_date_image date_field='postpone_due_date#type_id#_#currentrow#'></span>
													</div>
												</div>
											</td>
											<td>
												<div class="form-group">
													<select name="postpone_debt_type#type_id#_#currentrow#" id="postpone_debt_type#type_id#_#currentrow#">
														<option value="1" <cfif postpone_debt_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58007.Çek'></option>
														<option value="2" <cfif postpone_debt_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58008.Senet'></option>
														<option value="3" <cfif postpone_debt_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57147.Açık Hesap'></option>
														<option value="5" <cfif postpone_debt_type eq 5>selected</cfif>><cf_get_lang dictionary_id='58645.Nakit'></option>
													</select>
												</div>
											</td>
											<td><div class="form-group"><input type="text" name="postpone_total#type_id#_#currentrow#" id="postpone_total#type_id#_#currentrow#" value="#TLFormat(postpone_total)#" class="moneybox" onKeyUp="hesapla_toplam_(3);return(FormatCurrency(this,event));"></div></td>
										</tr>
									</cfoutput>
								</tbody>
								<tfoot>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td colspan="2">&nbsp;<input type="text" name="postpone_pay_nettotal_3" id="postpone_pay_nettotal_3" class="moneybox" readonly value="<cfoutput>#TLFormat(get_sales.postpone_pay_nettotal3)#</cfoutput>"></td>
									</tr>
									<tr>
										<td colspan="2"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
										<td colspan="2">&nbsp;<input type="text" name="postpone_pay_net_duedate_3" id="postpone_pay_net_duedate_3" readonly value="<cfoutput>#dateFormat(get_sales.postpone_pay_net_duedate3,dateformat_style)#</cfoutput>"></td>
									</tr>
								</tfoot>
							</cf_grid_list>
						<!--- //YENİ ÖDEME ŞEKLİ --->
						</div>
					</div>
				</div>
				<!--- VADE FARKI ORANI-TUTARI --->
				<cf_flat_list>
					<thead>
						<tr>
							<th><cf_get_lang dictionary_id='52339.Vade Farkı Oranı'> %</th>
							<th><cf_get_lang dictionary_id='52340.Vade Farkı KDV Oranı'></th>
							<th><cf_get_lang dictionary_id='52341.Vade Farkı Tutarı'></th>
							<th><cf_get_lang dictionary_id='52342.Ertelenen Gün Sayısı'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><div class="form-group"><input type="text" name="duedate_diff_rate" id="duedate_diff_rate" value="<cfoutput>#TLFormat(get_sales.duedate_diff_rate)#</cfoutput>"  onKeyUp="hesapla_fark_toplam();return(FormatCurrency(this,event));" class="moneybox"></div></td>
							<td><div class="form-group"><input type="text" name="duedate_diff_kdv" id="duedate_diff_kdv" value="<cfoutput>#get_sales.duedate_diff_kdv#</cfoutput>"  onKeyUp="hesapla_fark_toplam();isNumber(this)" class="moneybox"></div></td>
							<td><div class="form-group"><input type="text" name="duedate_diff_total" id="duedate_diff_total" value="<cfoutput>#TLFormat(get_sales.duedate_diff_total)#</cfoutput>" readonly  class="moneybox"></div></td>
							<td><div class="form-group"><input type="text" name="postpone_day_number" id="postpone_day_number" value="<cfoutput>#get_sales.postpone_day_number#</cfoutput>" readonly  class="moneybox"></div></td>
						</tr>
					</tbody>
				</cf_flat_list>
			</cfform>
		</cf_box>
	</div>
	<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
		<!--- Notlar --->
		<cf_get_workcube_note action_section='COMPANY_DEBIT_POSTPONE_ID' action_id='#attributes.debit_postpone_id#'><br/>
			<!--- Varliklar --->
			<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='52' action_section='COMPANY_DEBIT_POSTPONE_ID' action_id='#attributes.debit_postpone_id#'>
		<div id="general">
			<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_sales.company_id#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
		</div>

	</div>
</div>
<script type="text/javascript">
	row_count_type1 = <cfoutput>#get_sales_row_1.recordcount#</cfoutput>;
	row_count_type2 = <cfoutput>#get_sales_row_2.recordcount#</cfoutput>;
	row_count_type3 = <cfoutput>#get_sales_row_3.recordcount#</cfoutput>;
	ekle_cikar1 = <cfoutput>#get_sales_row_1.recordcount#</cfoutput>;
	ekle_cikar3 = <cfoutput>#get_sales_row_3.recordcount#</cfoutput>;
	
	function add_row(type)
	{
		var newRow;
		var newCell;
		if(type == 1)
		{
			ekle_cikar1++;
			row_count_type1++;
			row_all = row_count_type1;
			row_count_name_ = type + '_' + row_count_type1;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		}
		else if (type == 2)
		{
			 row_count_type2++;
			 row_all = row_count_type2;
			 row_count_name_ = type + '_' + row_count_type2;
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		}
		else if (type == 3)
		{
			ekle_cikar3++;
			row_count_type3++;
			row_all = row_count_type3;
			row_count_name_ = type + '_' + row_count_type3;
			newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);
		}
		newRow.setAttribute("name","frm_row" + row_count_name_);
		newRow.setAttribute("id","frm_row" + row_count_name_);
		newRow.setAttribute("NAME","frm_row" + row_count_name_);
		newRow.setAttribute("ID","frm_row" + row_count_name_);
		newRow.className = 'color-row';
		if (type == 1)
			document.upd_debit.record_num1.value=row_all;
		else if (type == 2)
			document.upd_debit.record_num2.value=row_all;
		else if (type == 3)
			document.upd_debit.record_num3.value=row_all;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count_name_ +'" id="row_kontrol' + row_count_name_ +'"><a href="javascript://" onclick="sil(row_kontrol' + row_count_name_ + ',' + type + ',' + row_all + ');"><i class="fa fa-minus" border="0"></i></a>';

		newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.setAttribute("id","postpone_due_date" + row_count_name_ + "_td");
			
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="postpone_due_date' + row_count_name_ +'" id="postpone_due_date_input_group' + row_count_name_ +'" maxlength="10" validate="#validate_style#" required="yes" value=""  style="width: 140px !important;" onChange="hesapla_ortalama_vade_('+type+');"></div></div>';
			document.querySelector("#postpone_due_date" + row_count_name_ + "_td .input-group").setAttribute("id","postpone_due_date_input_group" + row_count_name_ + "_td");
			wrk_date_image('postpone_due_date_input_group' + row_count_name_,'','upd_debit');
		
		newCell = newRow.insertCell(newRow.cells.length);
		if(type == 1 || type == 2)
			newCell.innerHTML = '<div class="form-group"><select name="postpone_debt_type' + row_count_name_ +'" style="width:"50px;"><option value="1"><cf_get_lang dictionary_id='58007.Çek'></option><option value="2"><cf_get_lang dictionary_id='58008.Senet'></option><option value="3"><cf_get_lang dictionary_id='57147.Açık Hesap'></option><option value="4"><cf_get_lang dictionary_id='52358.ÇSİ'></option></select></div>';
		else
			newCell.innerHTML = '<div class="form-group"><select name="postpone_debt_type' + row_count_name_ +'" style="width:"50px;"><option value="1"><cf_get_lang dictionary_id='58007.Çek'></option><option value="2"><cf_get_lang dictionary_id='58008.Senet'></option><option value="3"><cf_get_lang dictionary_id='57147.Açık Hesap'></option><option value="5"><cf_get_lang dictionary_id='58645.Nakit'></option></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="postpone_total' + row_count_name_ +'" value="<cfoutput>#TLFormat(0)#</cfoutput>" class="moneybox" style="width:70px;" onKeyUp="hesapla_toplam_('+type+');return(FormatCurrency(this,event));"></div>';
	}
	
	function sil(sy,type,sym)
	{
		sy.value=0;
		if(type == 1) // 1.ve 3. tablolarda en az 1 satir zorunlulugu kontol edilecek
			ekle_cikar1--;
		else if(type == 3)
			ekle_cikar3--;
		eval('upd_debit.row_kontrol' + type + "_" + sym).value = 0;
		var my_element=eval("frm_row" + type + "_" + sym);
		my_element.style.display="none";
		hesapla_toplam_(type);
		hesapla_ortalama_vade_(type);
		hesapla_fark_toplam();
	}

	function hesapla_toplam_(type)
	{
		kontrol_deger = 0;
		toplam_postpone_total = 0;
		toplam_deger_value = eval("upd_debit.postpone_pay_nettotal_"+type);
		if(type == 1)
			row_count_ = row_count_type1;
		else if(type == 2)
			row_count_ = row_count_type2;
		else if(type == 3)
			row_count_ = row_count_type3;
		
		for(var f=1;f<=row_count_;f++)
		{
			row_count_type_f = type + "_" + f;
			if(eval("upd_debit.row_kontrol"+row_count_type_f) != undefined)
			{
				if(eval("upd_debit.row_kontrol"+row_count_type_f).value == 1)
				{
					kontrol_deger++;
					satir_postpone_total = filterNum(eval("upd_debit.postpone_total"+row_count_type_f).value); //satir tutari
					toplam_postpone_total = toplam_postpone_total + satir_postpone_total; // satir net toplamlari
					satir_postpone_total = commaSplit(eval("upd_debit.postpone_total"+row_count_type_f).value);
					toplam_deger_value.value = commaSplit(toplam_postpone_total);
				}
			}
		}
		if (kontrol_deger == 0)
			toplam_deger_value.value = commaSplit(0);

		hesapla_ortalama_vade_(type);
		hesapla_fark_toplam();
	}
	
	function hesapla_ortalama_vade_(type)
	{
		kontrol_deger2 = 0;
		last_total_value = 0;
		avg_due_date_value = 0;			
		if(type == 1)
			row_count_ = row_count_type1;
		else if(type == 2)
			row_count_ = row_count_type2;
		else if(type == 3)
			row_count_ = row_count_type3;
		for(var g=1;g<=row_count_;g++)
		{
			row_count_type_g = type + "_" + g;
			if(eval("upd_debit.row_kontrol"+row_count_type_g) != undefined)
			{
				if(eval("upd_debit.row_kontrol"+row_count_type_g).value == 1)
				{
					kontrol_deger2++;
					main_process_date = upd_debit.process_date.value;// islem tarihi
					row_due_date = eval('upd_debit.postpone_due_date'+row_count_type_g).value; //satirdaki vade
					row_postpone_total = filterNum(eval("upd_debit.postpone_total"+row_count_type_g).value); //satir tutari
					row_postpone_nettotal = filterNum(eval('upd_debit.postpone_pay_nettotal_'+type).value); //satir net toplamlari
					day_diff = datediff(main_process_date,row_due_date,0); // gun farki (islem tarihi - satir vade tarihi)
					day_diff_total = day_diff * row_postpone_total; // gun farki toplami (gun farki * satir tutari)
					last_total_value = last_total_value + day_diff_total; //satir net gun farki toplamlari
					avg_due_date_value = last_total_value / row_postpone_nettotal; //ortalama vade farki tutari
					last_avg_due_date_value = ('d',avg_due_date_value,main_process_date); //ortalama vade tarihi
					if(filterNum(eval('upd_debit.postpone_pay_nettotal_'+type).value) > 0)
						eval('upd_debit.postpone_pay_net_duedate_'+  type).value = last_avg_due_date_value; //ortalama vade inputuna yazdiriyor
				}
			}
		}
		if (kontrol_deger2 == 0)
			eval('upd_debit.postpone_pay_net_duedate_'+  type).value = '';
			
		hesapla_fark_toplam();
	}
	
	function hesapla_fark_toplam()
	{
		if(filterNum(eval('upd_debit.postpone_pay_nettotal_'+3).value) > 0 && filterNum(eval('upd_debit.postpone_pay_nettotal_'+1).value) > 0)
		{
			postpone_day_number_ = datediff(eval('upd_debit.postpone_pay_net_duedate_'+  1).value,eval('upd_debit.postpone_pay_net_duedate_'+  3).value,0); // ertelenene gun sayisi hesaplanir
			upd_debit.postpone_day_number.value = postpone_day_number_; //ertelenene gun sayisi inputuna hesaplanana deger yazdiriliyor
			postpone_day_number_ = upd_debit.postpone_day_number.value;
			vade_farki_orani = filterNum(upd_debit.duedate_diff_rate.value);
			vade_farki_kdvsiz_tutari = filterNum(eval('upd_debit.postpone_pay_nettotal_'+1).value)*vade_farki_orani*postpone_day_number_/100/30;
			vade_farki_kdvli_tutari = vade_farki_kdvsiz_tutari + (vade_farki_kdvsiz_tutari *(upd_debit.duedate_diff_kdv.value/100));
			upd_debit.duedate_diff_total.value = vade_farki_kdvli_tutari;
			upd_debit.duedate_diff_total.value = commaSplit(upd_debit.duedate_diff_total.value);
		}
	}

	function kontrol()
	{
		if(document.upd_debit.process_date.value == "")
		{
			alert("<cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'> !");
			return false;
		}
		if(document.upd_debit.is_job_add[0].checked == true && document.upd_debit.job_add_detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52343.Faaliyet Alanı Girmelisiniz'> !");
			return false;
		}
		if(document.upd_debit.is_job_continue[0].checked == true && document.upd_debit.job_continue_detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52344.Çalışma Şartları Girmelisiniz'> !");
			return false;
		}
		if(document.upd_debit.is_job_postpone[0].checked == true && filterNum(document.upd_debit.job_postpone_detail_total.value) == 0)
		{
			alert("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'> !");
			return false;
		}
		if(document.upd_debit.detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52066.Lütfen Açıklama Giriniz'> !");
			return false;
		}
		
		for(var fg=1;fg<=3;fg++)
		{
			if (fg != 2 && eval("ekle_cikar"+fg) == 0)
			{
				alert(fg + ". <cf_get_lang dictionary_id='52345.Tabloya En Az Bir Satır Eklemelisiniz'> !");
				return false;
			}
			recordcount_types_ = eval("row_count_type"+fg);
			for(var g=1;g<=recordcount_types_;g++)
			{
				row_count_type_g = fg + "_" + g;
				if(eval("upd_debit.row_kontrol"+row_count_type_g) != undefined)
					if(eval("upd_debit.row_kontrol"+row_count_type_g).value == 1)
					{
						if(eval("upd_debit.postpone_due_date"+row_count_type_g).value == "")
						{
							alert(fg + ".<cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ".<cf_get_lang dictionary_id='52347.Satıra Vade Tarihi Girmelisiniz'> !");
							return false;
						}
						if(eval("upd_debit.postpone_total"+row_count_type_g).value == "" || filterNum(eval("upd_debit.postpone_total"+row_count_type_g).value) == 0)
						{
							alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ". <cf_get_lang dictionary_id='52348.Satıra Tutar Girmelisiniz'> !");
							return false;
						}
					}
			}
		}
		if(upd_debit.duedate_diff_rate.value == "")
		{
			alert("<cf_get_lang dictionary_id='52380.Vade Farkı Oranı Girmelisiniz'>!");
			return false;
		}
		if((upd_debit.duedate_diff_kdv.value != 8) && (upd_debit.duedate_diff_kdv.value != 18))
		{
			alert("<cf_get_lang dictionary_id='52349.KDV Değeri 8 veya 18 Olmalıdır'> !");
			upd_debit.duedate_diff_kdv.value = '';
			return false;
		}

		return process_cat_control();
	}
	
	function unformat_fields()
	{
		document.upd_debit.job_postpone_detail_total.value =  filterNum(document.upd_debit.job_postpone_detail_total.value);
		document.upd_debit.postpone_pay_nettotal_1.value =  filterNum(document.upd_debit.postpone_pay_nettotal_1.value);
		document.upd_debit.postpone_pay_nettotal_2.value =  filterNum(document.upd_debit.postpone_pay_nettotal_2.value);
		document.upd_debit.postpone_pay_nettotal_3.value =  filterNum(document.upd_debit.postpone_pay_nettotal_3.value);
		document.upd_debit.duedate_diff_rate.value = filterNum(document.upd_debit.duedate_diff_rate.value);
		document.upd_debit.duedate_diff_total.value = filterNum(document.upd_debit.duedate_diff_total.value);
	}
</script>
