<!---
    File: arge_muhtasar_report.cfm
    Controller: HealthExpenseController.cfm
    Folder: report\standart\arge_muhtasar_report.cfm
    Author: Esma Uysal, Melek Kocabey
    Date: 2020-02-10
    Description: Rapora seçilen ayda ücret kartında 5746 kanun maddeleri seçilen çalışanlar geliyor. 
--->
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.in_out_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
    get_company = cmp_company.get_company(is_control : 1);
    
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
    get_branches = cmp_branch.get_branch(comp_id : '#iif(len(attributes.comp_id),"attributes.comp_id",DE(""))#', ehesap_control : 1);
    
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');

    if(isdefined("attributes.form_submitted") and len(attributes.form_submitted))
    {
        cmp_rd_employees = createObject("component","V16.report.cfc.rd_employees");
        get_employees = cmp_rd_employees.GET_RD_EMPLOYEES(
                        comp_ids : attributes.comp_id,
                        branch_ids : attributes.branch_id,
                        sal_mon : attributes.sal_mon,
                        department_id : attributes.department,
                        employee_id : attributes.employee_id,
                        sal_year : attributes.sal_year,
                        employee_name : attributes.employee_name
        );
        get_active_tax_slice = cmp_rd_employees.get_active_tax_slice(sal_year : attributes.sal_year);
        s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1;
        s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2;
        s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3;
        s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4;
        s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5;
        s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6;
    }
</cfscript>
<cfparam name="attributes.totalrecords" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfsavecontent variable="head"><cf_get_lang dictionary_id ='60249.Ar-Ge Muhtasar Raporu'></cfsavecontent>
<cfform name="arge_report" method="post" action="">
    <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
	<cf_report_list_search title="#head#">
        <cf_report_list_search_area>  
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-4 col-md-8 col-xs-12">
                                <div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z5">
											<cf_multiselect_check
												query_name="get_company"
												name="comp_id"
												width="140"
												option_value="COMP_ID"
												option_name="COMPANY_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
										</div>
									</div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfif len(attributes.employee_name)>
                                            <cf_wrk_employee_in_out emp_id_value="#attributes.employee_id#" in_out_id_fieldname="in_out_id" in_out_value = "attributes.in_out_id" form_name="arge_report">
                                        <cfelse>
                                            <cf_wrk_employee_in_out emp_id_value="" in_out_id_fieldname="in_out_id" in_out_value = "attributes.in_out_id" form_name="arge_report">
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-xs-12">
                                <div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
									<div class="col col-12 col-xs-12">
                                        <div id="BRANCH_PLACE" class="multiselect-z5">                                           
                                            <cf_multiselect_check 
                                                query_name="get_branches"  
                                                name="branch_id"
                                                width="140" 
                                                option_value="BRANCH_ID"
                                                option_name="branch_name"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.branch_id#"
                                                onchange="get_department_list(this.value)">
										</div>
									</div>
								</div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58672.Ay'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="sal_mon" id="sal_mon">
                                            <cfloop from="1" to="12" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif (isdefined("attributes.sal_mon") and attributes.sal_mon eq i) or (not isdefined("attributes.sal_mon") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-8 col-xs-12">
                                <div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
									<div class="col col-12 col-xs-12">
										<div id="DEPARTMENT_PLACE" class="multiselect-z4">
											<cf_multiselect_check 
												query_name="get_department"  
												name="department"
												width="140" 
												option_value="DEPARTMENT_ID"
												option_name="DEPARTMENT_HEAD"
												option_text="#getLang('main',322)#"
												value="#attributes.department#"
												onchange="alt_departman_chckbx(this.value);">
										</div>
									</div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31395.Yıllar'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="sal_year" id="sal_year">
                                            <cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i)>selected</cfif>>#i#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                            </div>                            
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_report_search_button search_function='kontrol()' button_type='1' is_excel="1" >
                        </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1><!--- excel olusturulacaksa --->
	<cfset filename="arge_muhtasar_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<cfif isdefined("attributes.form_submitted")>
   <cf_report_list>    
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='31253.Sıra No'></th>
                <th><cf_get_lang dictionary_id='58025.Tc Kimlik No'></th>
                <th><cf_get_lang dictionary_id='57897.Adı'><cf_get_lang dictionary_id='58550.Soyad'></th>
                <th><cf_get_lang dictionary_id='60250.Ar-Ge Vergi Günü'></th>
                <th><cf_get_lang dictionary_id='31622.işe başlama tarihi'></th>
                <th><cf_get_lang dictionary_id='60251.Brüt Kazançlar Toplamı'></th>
                <th><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='33304.vergi'></th>
                <th><cf_get_lang dictionary_id='60252.ARGE Ücret Matrahı'></th>
                <th><cf_get_lang dictionary_id='60253.ARGE Vergi Tutarı'></th>
                <th><cf_get_lang dictionary_id='39964.AGI'></th>
                <th><cf_get_lang dictionary_id='60253.ARGE Vergi Tutarı'>-<cf_get_lang dictionary_id='39964.AGI'></th>
                <th><cf_get_lang dictionary_id='60254.Terkin Oranı'></th>
                <th><cf_get_lang dictionary_id='60255.Terkin Edilecek Tutar'></th>
                <th><cf_get_lang dictionary_id='60276.Ödenecek Vergi'></th>
                <th><cf_get_lang dictionary_id='41439.Damga Vergisi'></th>
                <th><cf_get_lang dictionary_id='59363.ARGE Damga Vergisi Matrahı'></th>
                <th><cf_get_lang dictionary_id='60256.ARGE Damga Vergisi Tutarı'></th>
                <th><cf_get_lang dictionary_id='60257.Terkin Tutarı'></th>
                <th><cf_get_lang dictionary_id='60258.Ödenecek Damga Vergisi'></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_employees.recordcount>
            <cfoutput query = "get_employees" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif gelir_vergisi_matrah_5746 gt 0>
					<cfset gvm_5746 = gelir_vergisi_matrah_5746>
				<cfelse>
					<cfset gvm_5746 = 0>
				</cfif>
				<tr>
                    <td>#currentrow#</td>
                    <td>#TC_IDENTY_NO#</td>
                    <td>#get_emp_info(employee_id,0,0,0)#</td>
                    <td>#TAX_DAYS_5746#</td>
                    <td>#dateformat(IN_OUT_START_DATE,dateformat_style)#</td>
                    <td>
                        <!--- Puantajdaki  toplam kazanç sütunu --->
                        <cfset toplam_kazanc = TOTAL_SALARY -VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI>
                        <cfif len(VERGI_ISTISNA_AMOUNT)>
                            <cfset toplam_kazanc = toplam_kazanc + VERGI_ISTISNA_AMOUNT>
                        </cfif>
                        <cfif ssk_days gt 0>
                            <cfset toplam_kazanc = toplam_kazanc / ssk_days * TAX_DAYS_5746 > 
                            <cfset asgari_damga = (stamp_tax_temp * 1000 / 7.59) / ssk_days * TAX_DAYS_5746>
                        </cfif>
                        #tlformat(ceiling(DVM_MATRAH_5746 + asgari_damga))#
                    </td>
                    <td>
                        <!--- Puantajdaki gelir vergisi hesaplanan(toplam vergi) --->
                        <cfif is_5746_control eq 0>
                            <cfset t_gelir_vergisi_indirimi_5746 = gelir_vergisi_indirimi_5746>
                        <cfelse>
                            <cfset t_gelir_vergisi_indirimi_5746 = 0>
                        </cfif>
                        <cfset gelir_vergisi_hesaplanan = gelir_vergisi + vergi_indirimi_5084 + vergi_iadesi + t_gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_4691>
                        #TLFormat(gelir_vergisi_hesaplanan)#
                    </td>
                    <td>
                        <!--- Arge Ücret Matrahı * vergi dilimi --->
                        <cfscript>
                            //Vergi Dilimi Hesaplaması
                            if (isdefined("GELIR_VERGISI_MATRAH") and isnumeric(GELIR_VERGISI_MATRAH))
                                t_kum_gelir_vergisi_matrahi = GELIR_VERGISI_MATRAH;
                            else
                                t_kum_gelir_vergisi_matrahi = 0;
                            tax_ratio_ = '';
                            all_ = t_kum_gelir_vergisi_matrahi;
                            if (all_ lte s1)
                            {
                                tax_ratio_ = v1;
                            }
                            else if (all_ lte s2)
                            {	
                                tax_ratio_ = v2;
                            }
                            else if (all_ lte s3)
                            {	
                                tax_ratio_ = v3;
                            }
                            else if (all_ lte s4)
                            {
                                    tax_ratio_ = v4;
                            }
                            else if (all_ lte s5)
                            {
                                    tax_ratio_ = v5;
                            }
                        </cfscript>
                        <cfset arge_vergi_tutarı = gvm_5746 * 100 / tax_ratio_>
                        #tlFormat(arge_vergi_tutarı)#
                    </td>
                    <td>
                        <!--- Arge Ücret Matrahı * vergi dilimi --->
                        #tlFormat(gvm_5746+vergi_iadesi)#
                    </td>
                    <td>
                        <!--- Asgari geçim İndirimi --->
                        #tlformat(vergi_iadesi)#
                    </td>
                    <td>                     
						
						<!--- Arge Vergi Matrahı (DB) --->
                        #tlFormat(gvm_5746)#
                    </td>
                    <td> 
                        <!--- 5746 Oran ---->
                        <cfif len(law_numbers) and (listfindnocase(law_numbers,'ARGE80') OR listfindnocase(law_numbers,'574680'))>80 </cfif>
                        <cfif len(law_numbers) and (listfindnocase(law_numbers,'ARGE90') OR listfindnocase(law_numbers,'574690'))>90</cfif>
                        <cfif len(law_numbers) and (listfindnocase(law_numbers,'ARGE95') OR listfindnocase(law_numbers,'574695'))>95</cfif>
                        <cfif len(law_numbers) and (listfindnocase(law_numbers,'ARGE100') OR listfindnocase(law_numbers,'5746100'))>100</cfif>
                    </td>
                    <td>
                        <!--- Arge İndirimi = terkin edilen tutar --->
                        <cfset arge_indirimi = gelir_vergisi_indirimi_5746+gelir_vergisi_indirimi_4691>
                        <cfif arge_indirimi lt 0>
                            #TLFormat(0)#
                            <cfset arge_indirimi = 0>
                        <cfelse>
                            #TLFormat(arge_indirimi)#
                        </cfif>
                    </td>
                    <td>
                        <!--- Ödenecek vergi = toplam vergi - terkin edilen tutar(arge indirimi) --->
                        #tlFormat(gelir_vergisi_hesaplanan - arge_indirimi - vergi_iadesi)#
                    </td>
                    <td>
                        <!--- Damga vergisi --->
                        #TLFormat(damga_vergisi-damga_vergisi_indirimi_687-damga_vergisi_indirimi_7103)#
                    </td>
                    <td>
                        <!--- Arge damga vergisi matrahı --->
                        #TLFormat(DVM_MATRAH_5746)#
                    </td>
                    <td>
                        <!--- Arge damga vergisi tutarı --->
                        #TLFormat(damga_vergisi_indirimi_5746)#
                    </td>
                    <td>
                        <!--- Arge damga vergisi tutarı --->
                        #TLFormat(damga_vergisi_indirimi_5746)#
                    </td>
                    <td>
                        <!---damga vergisi - Arge damga vergisi --->
                        #TLFormat(damga_vergisi-damga_vergisi_indirimi_687-damga_vergisi_indirimi_7103-damga_vergisi_indirimi_5746)#
                    </td>
                </tr>
            </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="19"><cf_get_lang dictionary_id ="57484.Kayıt yok!"></td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset adres="report.age_muhtasar_report">
    <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
        <cfset adres = "#adres#&comp_id=#attributes.comp_id#">
    </cfif> 
    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
        <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfset adres = "#adres#&form_submitted=#attributes.form_submitted#" >
    </cfif>
    <cfif isdefined("attributes.department") and len(attributes.department)>
        <cfset adres="#adres#&department=#attributes.department#">
    </cfif>
    <cfif isdefined("attributes.sal_mon") and len(attributes.sal_mon)>
        <cfset adres="#adres#&sal_mon=#attributes.sal_mon#">
    </cfif>
    <cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#">
</cfif>
<script type="text/javascript">
    function kontrol()
        {
            if(document.arge_report.is_excel.checked==false)
                {
                    document.arge_report.action="<cfoutput>#request.self#?fuseaction=report.arge_muhtasar_report</cfoutput>";
                    return true;                
                }
                else
                {
                    document.arge_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_arge_muhtasar_report</cfoutput>";
                }
        }
    function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
    }
    function get_department_list(gelen)
	{
        checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
</script>