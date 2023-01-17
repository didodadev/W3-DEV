<!---
    File: V16\hr\ehesap\display\view_puantaj_sube.cfm
    Edit: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Şube Puantaj Listeleme
        
    History:
        
    To Do:

--->
<cf_xml_page_edit fuseact="ehesap.list_puantaj">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="from_list_puantaj" default="0">
<cfset old_payroll = 0>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfset payroll_cmp = createObject("component","V16.hr.ehesap.cfc.payroll_job") />
<cfset payroll_control = payroll_cmp.PAYROLL_JOB_CONTROL(
			branch_id : attributes.branch_id,
			month : attributes.sal_mon,
			year : attributes.sal_year,
			puantaj_id : isdefined("attrbutes.puantaj_id") and len(attributes.puantaj_id) ? attributes.puantaj_id : '',
			payroll_type : attributes.puantaj_type,
			statue : attributes.ssk_statue,
			statue_type : attributes.statue_type,
			jury_membership : attributes.statue_type eq 6 ? 1 : 0,
			land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
			start_date_new : isdefined("start_date_new") ? start_date_new : '',
			finish_date_new : isdefined("finish_date_new") ? finish_date_new : '',
			statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
		)>
<cfif payroll_control.recordcount eq 0>
	<cfset payroll_control = get_puantaj_rows>
	<cfset old_payroll = 1>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Bordro ve Puantaj','47073')#" uidrop="1" module="puantaj_list_layer" id="payroll_list_box" closable="0">
		<div class="ui-info-top" id="payroll_list">
			<cfinclude template="view_branch_info.cfm">
		</div>
		<cfif isdefined("attributes.detail_select") and len(attributes.detail_select) and attributes.detail_select eq 2>
			<cfset aa = attributes.ssk_office>
			<cfset bb= aa.split("-")>
			<cfset len_arr = ArrayLen(bb)>
			<cfset attributes.ssk_office= bb[len_arr]>
			<cfset from_list_puantaj = 1>
			<cfinclude template="proforma_puantaj.cfm">
		<cfelse>
			<cf_flat_list>
				<thead>
					<cfoutput>
						<tr>
							<th width="50"><cf_get_lang no='163.Sıra No'></th>
							<th><cf_get_lang_main no='158.Adı Soyadı'></th>
							<th><cf_get_lang no='1319.TC No'></th>
							<th><cf_get_lang no='292.Ücret Tipi'></th>
							<th style="text-align:right;"><cf_get_lang_main no='78.Gün'></th>
							<cfif x_view_total_days eq 1>
								<th style="text-align:right;"><cf_get_lang no='799.Toplam Gün'></th>
							</cfif>
							<th style="text-align:right;"><cf_get_lang no='298.Toplam Kazanç'></th>
							<th style="text-align:right;"><cf_get_lang no='453.Ek Ödenekler'></th>
							<th style="text-align:right;"><cf_get_lang no='307.Toplam Kesinti'></th>
							<th style="text-align:right;"><cf_get_lang no='309.Net Ücret'></th>
							<th width="50">
								<cfsavecontent variable = "payroll_title"><cf_get_lang dictionary_id='31444.Payroll'></cfsavecontent> 
								<label title="#payroll_title#">#left(payroll_title,1)#</label>
							</th>
							<th  width="50">
								<cfsavecontent variable = "acoount_title"><cf_get_lang dictionary_id='57447.Account'></cfsavecontent> 
								<label title="#acoount_title#">#left(acoount_title,1)#</label>
							</th>
							<th width="50">
								<cfsavecontent variable = "budget_title"><cf_get_lang dictionary_id='57559.Budget'></cfsavecontent> 
								<label title="#budget_title#">#left(budget_title,1)#</label>
							</th>
							<th width="20px"><i class="fa fa-lg fa-print"></i></th>
							<th width="20px"><i class="fa fa-lg fa-pencil" title="<cf_get_lang dictionary_id='58718.Düzenle'>"></i></th>
							<th width="20px"><i class="fa fa-lg fa-refresh"></i></th>
							<th width="20px"><i class="fa fa-lg fa-minus"></i></th>
						</tr>
					</cfoutput>
				</thead>
				<tbody>
					<input type="hidden" name="record_count" id="record_count" value="<cfoutput><cfif payroll_control.recordCount>#payroll_control.recordCount#<cfelse>0</cfif></cfoutput>" >
					<cfif payroll_control.recordCount>
						<cfscript>
							t_toplam_kazanc = 0;
							t_kesinti = 0;
							t_net_ucret = 0;
							t_ssk_days = 0;
							//sgk_toplam_gun = 0;
							t_ek_odeneks = 0;
							ssk_count = 0;
							t_total_days = 0;
						</cfscript>
						<cfoutput query="payroll_control">
							<cfquery name = "get_payroll_total" dbtype="query" >
								SELECT 
									SUM(BES_ISCI_HISSESI) BES_ISCI_HISSESI,
									SUM(TOTAL_SALARY) TOTAL_SALARY,
									SUM(VERGI_ISTISNA_SSK) VERGI_ISTISNA_SSK,
									SUM(VERGI_ISTISNA_VERGI) VERGI_ISTISNA_VERGI,
									SUM(VERGI_ISTISNA_AMOUNT_) VERGI_ISTISNA_AMOUNT_,
									SUM(SSK_ISCI_HISSESI) SSK_ISCI_HISSESI,
									SUM(SSDF_ISCI_HISSESI) SSDF_ISCI_HISSESI,
									SUM(GELIR_VERGISI) GELIR_VERGISI,
									SUM(DAMGA_VERGISI) DAMGA_VERGISI,
									SUM(ISSIZLIK_ISCI_HISSESI) ISSIZLIK_ISCI_HISSESI,
									SUM(TOTAL_PAY_SSK_TAX) TOTAL_PAY_SSK_TAX,
									SUM(TOTAL_PAY_SSK) TOTAL_PAY_SSK,
									SUM(TOTAL_PAY_TAX) TOTAL_PAY_TAX,
									SUM(TOTAL_PAY) TOTAL_PAY,
									SUM(NET_UCRET) NET_UCRET,
									SUM(SSK_DAYS) SSK_DAYS,
									SUM(TOTAL_DAYS) TOTAL_DAYS,
									SALARY_TYPE
								FROM 
									get_puantaj_rows 
								WHERE 
									IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#IN_OUT_ID#"> 
									AND STATUE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#">
								<cfif attributes.ssk_statue eq 2>
									AND STATUE_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#">
								</cfif>
								GROUP BY
									SALARY_TYPE 
							</cfquery>	
							<cfif get_payroll_total.recordcount>
								<cfscript>
									if(not len(get_payroll_total.bes_isci_hissesi))
										bes_isci_hissesi_ = 0;
									else 
										bes_isci_hissesi_ = get_payroll_total.bes_isci_hissesi;
									t_toplam_kazanc = t_toplam_kazanc + (get_payroll_total.total_salary-get_payroll_total.VERGI_ISTISNA_SSK-get_payroll_total.VERGI_ISTISNA_VERGI+get_payroll_total.VERGI_ISTISNA_AMOUNT_);
									t_kesinti = t_kesinti + (get_payroll_total.SSK_ISCI_HISSESI + get_payroll_total.ssdf_isci_hissesi + get_payroll_total.gelir_vergisi + get_payroll_total.damga_vergisi + get_payroll_total.issizlik_isci_hissesi + bes_isci_hissesi_);
									t_ek_odeneks = t_ek_odeneks + get_payroll_total.total_pay_ssk_tax+get_payroll_total.total_pay_ssk+get_payroll_total.total_pay_tax+get_payroll_total.total_pay;
									t_net_ucret = t_net_ucret + get_payroll_total.net_ucret;
									if(len(get_payroll_total.ssk_days))
										t_ssk_days = t_ssk_days + get_payroll_total.ssk_days;
									if(len(get_payroll_total.total_days))
										t_total_days = t_total_days + get_payroll_total.total_days;					
								</cfscript>
							</cfif>
							<cfset employee_payroll = "">
							<tr>
								<td>#currentrow#</td>
								<td> <cfset emp_info =  get_emp_info(employee_id,0,0) >
									<a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#emp_info#')#" target="_blank">#get_emp_info(employee_id,0,0)#</a>
								</td>
								<td>#TC_IDENTY_NO#</td>
								<td>
									<cfif get_payroll_total.recordcount>
										<cfif get_payroll_total.salary_type eq 0>
											<cf_get_lang no='314.Saatlik'>
										<cfelseif get_payroll_total.salary_type eq 1>
											<cf_get_lang_main no='1045.Günlük'>
										<cfelseif get_payroll_total.salary_type eq 2>
											<cf_get_lang_main no='1520.Aylık'>
										</cfif>
									</cfif>
								</td>
								<td style="text-align:right;"><cfif get_payroll_total.recordcount>#get_payroll_total.ssk_days#</cfif></td>
								<cfif x_view_total_days eq 1>
									<td style="text-align:right;"><cfif get_payroll_total.recordcount>#get_payroll_total.total_days#</cfif></td>
								</cfif>
								<td style="text-align:right;"><cfif get_payroll_total.recordcount>#TLFormat(get_payroll_total.TOTAL_SALARY - get_payroll_total.VERGI_ISTISNA_SSK - get_payroll_total.VERGI_ISTISNA_VERGI + get_payroll_total.VERGI_ISTISNA_AMOUNT_)#<cfelse>#TLFormat(0)#</cfif></td>
								<td style="text-align:right;"><cfif get_payroll_total.recordcount>#TLFormat(get_payroll_total.total_pay + get_payroll_total.total_pay_ssk_tax + get_payroll_total.total_pay_ssk + get_payroll_total.total_pay_tax)#<cfelse>#TLFormat(0)#</cfif></td>
								<td style="text-align:right;"><cfif get_payroll_total.recordcount>#TLFormat(get_payroll_total.SSK_ISCI_HISSESI + get_payroll_total.ssdf_isci_hissesi + get_payroll_total.gelir_vergisi + get_payroll_total.damga_vergisi + get_payroll_total.issizlik_isci_hissesi + bes_isci_hissesi_)#<cfelse>#TLFormat(0)#</cfif></td>
								<td style="text-align:right;"><cfif get_payroll_total.recordcount>#TLFormat(get_payroll_total.net_ucret)#<cfelse>#TLFormat(0)#</cfif></td>
								<td>
									<!--- Bordro --->
									<cfif isdefined("PERCENT_COMPLETED") and PERCENT_COMPLETED eq 1>
										<i class="fa fa-2x fa-bookmark flagTrue" onClick="showParserMessage(#in_out_id#,#in_out_id#,#attributes.sal_mon#,#attributes.sal_year#,#EMPLOYEE_PAYROLL_ID#)"></i>
									<cfelse>
										<i class="fa fa-2x fa-bookmark fa-bookmark-o"></i>
									</cfif>
									<input type="checkbox" data-type="fileids" name="fileids_#in_out_id#" id="fileids_#in_out_id#" data-id="fileids_#currentrow#" value="#in_out_id#" checked style="display:none;">
									<input type="checkbox" data-type="inoutid_" name="inoutid_#in_out_id#" id="inoutid_#in_out_id#" data-id="inoutid_#currentrow#" value="#in_out_id#" checked style="display:none;">
								</td>
								<td>
									<!--- Muhasebe --->
									<cfif isdefined("ACCOUNT_COMPLETED") and ACCOUNT_COMPLETED eq 1>
										<i class="fa fa-2x fa-bookmark flagTrue" onClick="showParserMessageAccount(#in_out_id#,#in_out_id#,#attributes.sal_mon#,#attributes.sal_year#,#EMPLOYEE_PAYROLL_ID#)"></i>
									<cfelse>
										<i class="fa fa-2x fa-bookmark fa-bookmark-o"></i>
									</cfif>
									<input type="checkbox" data-type="account" name="account_#in_out_id#" id="account_#in_out_id#" data-id="account_#currentrow#" value="#in_out_id#" checked style="display:none;">
								</td>
								<td>
									<!--- Bütçe --->
									<cfif isdefined("BUDGET_COMPLETED") and BUDGET_COMPLETED eq 1>
										<i class="fa fa-2x fa-bookmark flagTrue" onClick="showParserMessageBudget(#in_out_id#,#in_out_id#,#attributes.sal_mon#,#attributes.sal_year#,#EMPLOYEE_PAYROLL_ID#)"></i>
									<cfelse>
										<i class="fa fa-2x fa-bookmark fa-bookmark-o"></i>
									</cfif>
									<input type="checkbox" data-type="budget" name="budget_#in_out_id#" id="budget_#in_out_id#" data-id="budget_#currentrow#" value="#in_out_id#" checked style="display:none;">
								</td>
								<cfif isdefined("EMPLOYEE_PAYROLL_ID") and len(EMPLOYEE_PAYROLL_ID)>
									<cfset employee_payroll = EMPLOYEE_PAYROLL_ID>
								<cfelseif isdefined("EMPLOYEE_PUANTAJ_ID") and len(EMPLOYEE_PUANTAJ_ID)>
									<cfset employee_payroll = EMPLOYEE_PUANTAJ_ID>
								<cfelseif isDefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
									<cfset get_emp_payroll = payroll_cmp.GET_OLD_PAYROLL(
										payroll_id : attributes.puantaj_id,
										in_out_id : in_out_id
									)
									>
									<cfif get_emp_payroll.recordcount neq 0>
										<cfset employee_payroll = get_emp_payroll.EMPLOYEE_PUANTAJ_ID>
									</cfif>
								</cfif>
								<td width="20px">
									<cfif isdefined("employee_payroll") and len(employee_payroll)>
										<i class="fa fa-lg fa-print" id="print_#in_out_id#" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_view_price_compass&style=one&employee_puantaj_id=#employee_payroll#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&puantaj_type=#attributes.puantaj_type#&currentrow=#currentrow#','page')"></i>
									</cfif>
								</td>
								<td nowrap>
									<cfif (get_puantaj.IS_ACCOUNT EQ 0) and (get_puantaj.IS_LOCKED EQ 0) and (get_puantaj.IS_BUDGET EQ 0)>              
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_employee_payroll&employee_puantaj_id=#employee_payroll#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&in_out_id=#in_out_id#','page')"><i class="fa fa-lg fa-pencil" title="<cf_get_lang dictionary_id='58718.Düzenle'>"></i></a>
									</cfif> 
								</td>
								<cfif (get_puantaj.IS_ACCOUNT EQ 0) and (get_puantaj.IS_LOCKED EQ 0) and (get_puantaj.IS_BUDGET EQ 0)>
									<td width="20px"><i class="fa fa-lg fa-refresh" id="refresh_#in_out_id#" onClick="create_puantaj(#in_out_id#)"></i></td>
									<cfsavecontent variable="message"><cf_get_lang no ='1192.Çalışanın puantaj satırlarını siliyorsunuz,emin misiniz'></cfsavecontent>
									<td width="20px">
										<cfif isdefined("employee_payroll") and len(employee_payroll)>
											<i class="fa fa-minus" title="<cf_get_lang_main no='51.Sil'>" onClick="if(confirm('#message#')) delet_puantaj_row_('#employee_payroll#');else return false;"></i>
										</cfif>
									</td>
								<cfelse>
									<td colspan="3"></td>
								</cfif>
							</tr>
							<cfif isdefined("PERCENT_COMPLETED") and PERCENT_COMPLETED eq 1>
								<tr id="msgid_#in_out_id#" style="display:none;" class="">
									<cfset attributes.employee_payroll_id = EMPLOYEE_PAYROLL_ID>
									<!--- Modal Olarak Açıldı. <cfinclude template="show_payroll_draft.cfm"> --->
								</tr>
							<cfelse>
								<!-- sil -->
								<tr>
									<td style="display:none;" id="tr_#in_out_id#" colspan="9"></td>
								</tr>
								<!-- sil -->
							</cfif>
						</cfoutput>
						<cfoutput>
							<tr>
								<cfif (get_puantaj.IS_ACCOUNT EQ 0) and (get_puantaj.IS_LOCKED EQ 0) and (get_puantaj.IS_BUDGET EQ 0)>
									<td></td>
								</cfif>
								<td colspan="3"><b><cf_get_lang no='317.Toplamlar'></b></td>
								<td style="text-align:right;"><b>#t_ssk_days#</b></td>
								<cfif x_view_total_days eq 1>
									<td style="text-align:right;"><b>#t_total_days#</b></td>
								</cfif>
								<td style="text-align:right;"><b>#TLFormat(t_toplam_kazanc)#</b></td>
								<td style="text-align:right;"><b>#TLFormat(t_ek_odeneks)#</b></td>
								<td style="text-align:right;"><b>#TLFormat(t_kesinti)#</b></td>
								<td style="text-align:right;"><b>#TLFormat(t_net_ucret)#</b></td>
								<td colspan="6"></td>
								<cfif x_view_recorded eq 1>
									<td></td>
									<td></td>
								</cfif>
							</tr>
						</cfoutput>
					<cfelse>
						<tr><td colspan="9"><cf_get_lang dictionary_id='64299.Şubede çalışan kaydı bulunamadı'>!</td></tr>
					</cfif>
				</tbody> 
			<cf_flat_list>
		</cfif>
		<cfquery name="get_last_update" dbtype="query" maxrows="1">
			SELECT UPDATE_DATE FROM get_puantaj_rows ORDER BY UPDATE_DATE DESC
		</cfquery>
		<div class="row formContentFooter">
			<div class="col col-6">
				<cf_record_info query_name="get_puantaj">
			</div>
		</div>
		<!--- 	<p class="mr-2"><b><cf_get_lang no='646.Kayıt Eden'>:</b> <cfoutput>#get_emp_info(get_puantaj.RECORD_EMP,0,1)#</cfoutput></p>
			<p class="mr-2"><b><cf_get_lang no='646.Kayıt Eden'>:</b> <cfoutput>#get_emp_info(get_puantaj.RECORD_EMP,0,1)#</cfoutput></p>		
			<p class="mr-2"><b><cf_get_lang_main no='57.Son Kayıt'>:</b> <cfoutput><cfif len(get_puantaj.record_date) and isdate(get_puantaj.record_date)>#dateformat(date_add("h",2,get_puantaj.record_date),dateformat_style)# - #timeformat(date_add("h",2,get_puantaj.record_date),timeformat_style)#</cfif></cfoutput></p>
			<p><b><cf_get_lang no='647.Son Kişi Güncelleme'>:</b> <cfoutput>
				<cfif get_last_update.recordcount and len(get_last_update.UPDATE_DATE)>
					#dateformat(date_add("h",2,get_last_update.UPDATE_DATE),dateformat_style)# - 
					#timeformat(date_add("h",2,get_last_update.UPDATE_DATE), timeformat_style)#						
				</cfif>		
			</cfoutput></p> --->
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	$('.portHeadLightMenu > ul > li > a').click(function(){
		$('.portHeadLightMenu > ul > li > ul').stop().fadeOut();
		$(this).parent().find("> ul").stop().fadeToggle();
	});
	function puantaja_aktar_row(emp_id_,type)
	{
		puantaj_type_ = document.getElementById('employee_puantaj_type').value;
		
		if(puantaj_type_ == '-3')
		{
			alert('Son Puantaj Fark Puantajı İle Beraber Oluşur!\nBu Adımda Son Puantaj Oluşturulamaz!');
			return false;
		}
		<cfif isdefined("attributes.sal_mon")>
			sal_mon_ = "<cfoutput>#attributes.sal_mon#</cfoutput>";
			sal_year_ = "<cfoutput>#attributes.sal_year#</cfoutput>";
		<cfelse>
			sal_mon_ = document.getElementById('emp_sal_mon').value;
			sal_year_ = document.getElementById('emp_sal_year').value;
		</cfif>
		//puantaj kontrolü
		var listParam = sal_mon_+'*'+sal_year_+'*'+emp_id_+"<cfoutput>*#attributes.puantaj_type#</cfoutput>";
		get_puantaj_ = wrk_safe_query('hr_get_puantaj_3','dsn',0,listParam);
		if(get_puantaj_.recordcount>0)
		{
			alert("<cf_get_lang no ='411.Çalışan İçin İleri Tarihli Bir Puantaj Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'>!");
			return false;
		}
		//harcırah kontrolü
		var listParam_2 = sal_mon_+'*'+sal_year_+'*'+emp_id_;
		get_puantaj_2 = wrk_safe_query('hr_control_expense_puantaj_2','dsn',0,listParam_2);
		if(get_puantaj_2.recordcount>0)
		{
			alert("Çalışan İçin İleri Tarihli Bir Harcırah Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız !");
			return false;
		}
		
		var listParam = sal_mon_+'*'+sal_year_+'*'+emp_id_;
		get_branch_id = wrk_safe_query('hr_get_branch_id','dsn',0,listParam);
		var listParam = sal_mon_+'*'+sal_year_+'*'+get_branch_id.BRANCH_ID+"<cfoutput>*#attributes.puantaj_type#</cfoutput>";
		if(type == 1){//proformadan
			from_list_puantaj = 1;
		}else from_list_puantaj = 0;
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_personal_puantaj&ajax_in=1&puantaj_type=#attributes.puantaj_type#&puantaj_olustur_2=1&renew=1&employee_id='+emp_id_+'&sal_mon='+sal_mon_+'&sal_year='+sal_year_+'</cfoutput>&from_list_puantaj='+from_list_puantaj,'menu_puantaj_2','1',"<cf_get_lang no ='415.Puantaj Oluşturuluyor'>");
	}
	function delet_puantaj_row_(puantaj_row_id,type)
	{	
		sal_year_ = document.employee.sal_year.value;
		sal_mon_ = document.employee.sal_mon.value;
		branch_id_ = document.employee.ssk_office.value;
		puantaj_type_ = document.getElementById('puantaj_type').value;
	
		var listParam = sal_mon_ + "*" + sal_year_ + "*" + branch_id_ + "*" + puantaj_type_;
	
		get_puantaj2_ = wrk_safe_query("hr_get_puantaj_2",'dsn',0,listParam);
		if(get_puantaj2_.recordcount>0)
		{
			alert("<cf_get_lang no ='221.Çalışan İçin İleri Tarihli Bir Puantaj Kaydı Var Geçmiş Tarihli Puantaj Silemezsiniz'>!");
			return false;
		}
		
		//harcırah kontrolü
		var listParam_2 = sal_mon_+'*'+sal_year_+'*'+branch_id_;
		get_puantaj_2 = wrk_safe_query('hr_control_expense_puantaj_3','dsn',0,listParam_2);
		if(get_puantaj_2.recordcount>0)
		{
			alert("Çalışan İçin İleri Tarihli Bir Harcırah Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız !");
			return false;
		}
		if(type == 1){//proformadan
			from_list_puantaj = 1;
		}else from_list_puantaj = 0;
		url_ = '<cfoutput>V16/hr/ehesap/cfc/delete_payroll.cfc?method=DEL_PAYROLL_ROW&x_payment_day=#x_payment_day#&employee_puantaj_id=</cfoutput>'+puantaj_row_id+'&from_list_puantaj='+from_list_puantaj;
		$.ajax({
            url: url_,
            dataType: "json",
            method: "post",
            success: function( objResponse )
			{
				console.log(objResponse);
				$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessage('+fileid_+')' }).css({ 'cursor' : 'pointer' });;
			},
			error: function(error) 
			{
				console.log(error);
			}
		});
		//window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_puantaj_rows&employee_puantaj_id=</cfoutput>'+puantaj_row_id;
		//AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_puantaj_rows&x_payment_day=#x_payment_day#&employee_puantaj_id=</cfoutput>'+puantaj_row_id+'&from_list_puantaj='+from_list_puantaj,'menu_puantaj_1','1'," <cf_get_lang no ='345.Puantaj Siliniyor'>");			
	}
</script>
