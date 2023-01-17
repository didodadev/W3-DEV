<!---
File: V16\report\standart\employee_bes_report.cfm.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:10.03.2021
Description: Otomatik Bes Raporu
--->
<cfparam name = "attributes.page" default="1">
<cfparam name = "attributes.comp_id" default="">
<cfparam name = "attributes.is_excel" default="0">
<cfparam name = "attributes.department" default="">
<cfparam name = "attributes.branch_id" default="">
<cfparam name = "attributes.inout_statue" default="">
<cfparam name = "attributes.start_mon" default="#month(now())-1#">
<cfparam name = "attributes.finish_mon" default="#month(now())-1#">
<cfparam name = "attributes.startdate" default="">
<cfparam name = "attributes.finishdate" default="">
<cfparam name = "attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name = "attributes.period_years" default="#session.ep.period_year#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset periods = createObject('component','V16.objects.cfc.periods')><!--- Period yılları Component --->
<cfset period_years = periods.get_period_year()><!--- Periyotlar --->
<cfset cmp_company = createObject("component","V16.hr.cfc.get_our_company")><!--- Şirketler Component --->
<cfset cmp_company.dsn = dsn>
<cfset get_company = cmp_company.get_company(is_control: 1)><!--- Şirketler --->
<cfset departments_cmp = createObject('component','V16.hr.cfc.get_departments')><!--- Departmanlar Component --->
<cfset get_department.dsn = dsn>
<cfset get_department = departments_cmp.get_department(branch_id : attributes.branch_id)>
<cfinclude template="/V16/hr/ehesap/query/get_ssk_offices.cfm"><!--- Şubeler --->

<cfsavecontent variable = "title"><cf_get_lang dictionary_id='62335.Otomatik Bes Raporu'></cfsavecontent>
<cfsavecontent variable="select_messages"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>

<cfif isdefined("attributes.is_submit")>
    <cfset get_component = createObject('component','V16.report.cfc.employees_bes')><!--- Ek Ödenekler Component--->
    <cfset get_employees_bes = get_component.GET_EMPLOYEES_BES(
                                    comp_id: attributes.comp_id, 
                                    branch_id: attributes.branch_id,
                                    department_id: attributes.department, 
                                    inout_statue: attributes.inout_statue, 
                                    start_mon: attributes.start_mon, 
                                    finish_mon: attributes.finish_mon, 
                                    period_years: attributes.period_years,
                                    startdate: attributes.startdate,
                                    finishdate: attributes.finishdate
                                )>
    <cfset attributes.totalrecords = get_employees_bes.recordcount>
<cfelse>
    <cfset attributes.totalrecords = 0>
</cfif>

<cfscript>
    url_str = "#attributes.fuseaction#";
    if (len(attributes.comp_id))
        url_str = "#url_str#&comp_id=#attributes.comp_id#";
    if (len(attributes.department))
        url_str = "#url_str#&department=#attributes.department#";
    if (len(attributes.inout_statue))
        url_str = "#url_str#&inout_statue=#attributes.inout_statue#";
    if (len(attributes.start_mon))
        url_str = "#url_str#&start_mon=#attributes.start_mon#";
    if (len(attributes.finish_mon))
        url_str = "#url_str#&finish_mon=#attributes.finish_mon#";
    if (isdefined("attributes.period_years"))
        url_str = "#url_str#&period_years=#attributes.period_years#";
    if (isdefined("attributes.branch_id"))
        url_str = "#url_str#&branch_id=#attributes.branch_id#";
    if (isdefined("attributes.finishdate"))
        url_str = "#url_str#&finishdate=#attributes.finishdate#";
    if (isdefined("attributes.startdate"))
        url_str = "#url_str#&startdate=#attributes.startdate#";
    if (isdefined("attributes.is_submit"))
        url_str = "#url_str#&is_submit=1";	
</cfscript>

<cfform name="search_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-12 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group" id="item-get_company">
                                        <label><cf_get_lang dictionary_id="57574.Şirket"></label>
                                        <div class="multiselect-z2">
                                            <cf_multiselect_check 
                                                query_name="get_company"  
                                                name="comp_id"
                                                width="140" 
                                                option_text="#select_messages#" 
                                                option_value="COMP_ID"
                                                option_name="NICK_NAME"
                                                value="#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#"
                                                onchange="get_branch_list(this.value)">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-inout_statue">
                                        <label class="col col-12"><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></label>
                                        <div class="col col-12">
                                            <select name="inout_statue" id="inout_statue">
                                                <option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
                                                <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                                <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                                <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id="39083.Aktif Çalışanlar"></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
                                        <div class="col col-4 col-md-4 col-xs-4">
                                            <select name="period_years" id="period_years">
                                                <cfoutput query = "period_years">
                                                    <option value="#period_year#"<cfif attributes.period_years eq period_year> selected</cfif>>#period_year#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                        <div class="col col-4 col-md-4 col-xs-4">
                                            <select name="start_mon" id="start_mon">
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput>
                                                        <option value="#i#" <cfif attributes.start_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                        <div class="col col-4 col-md-4 col-xs-4">
                                            <select name="finish_mon" id="finish_mon">
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput>
                                                    <option value="#i#" <cfif attributes.finish_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group" id="item-BRANCH_PLACE">
                                        <label><cf_get_lang dictionary_id="57453.Şube"></label>
                                        <div id="BRANCH_PLACE" class="multiselect-z2">
                                            <cf_multiselect_check 
                                            query_name="get_ssk_offices"  
                                            name="branch_id"
                                            width="140" 
                                            option_text="#select_messages#"
                                            option_value="BRANCH_ID"
                                            option_name="BRANCH_NAME-NICK_NAME"
                                            value="#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#"
                                            onchange="get_department_list(this.value)">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-startdate">
                                        <label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                        <div class="col col-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                                <cfinput type="text" name="startdate" id="startdate" style="width:65px;" placeholder="#place#" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group" id="item-DEPARTMENT_PLACE">
                                        <label><cf_get_lang dictionary_id="57572.Departman"></label>
                                        <div class="multiselect-z2" id="DEPARTMENT_PLACE">
                                            <cf_multiselect_check 
                                            query_name="get_department"  
                                            name="department"
                                            width="140" 
                                            option_text="#select_messages#"
                                            option_value="department_id"
                                            option_name="department_head"
                                            value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#"
                                            >
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-finishdate">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                        <div class="col col-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                                <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" placeholder="#place#" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_submit" id="is_submit" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1'  is_excel='1' search_function="control()">
						</div>
					</div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>

<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
<cfelse>
	<cfset type_ = 0>
</cfif>

<cf_report_list>
    <cfif isdefined('attributes.is_submit')>
        <cfif attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow = 1>
            <cfset attributes.maxrows = get_employees_bes.recordcount>
        <cfelse>
            <cfset type_ = 0>
        </cfif>

        <thead>
            <tr> 
                <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                <th><cf_get_lang dictionary_id='57897.Adı'></th>
                <th><cf_get_lang dictionary_id='58550.Soyadı'></th>
                <th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                <th><cf_get_lang dictionary_id='38923.İşe Giriş Tarihi'></th>
                <th><cf_get_lang dictionary_id='31287.İşten Çıkış Tarihi'></th>
                <th><cf_get_lang dictionary_id='32443.İletişim Bilgisi'> / <cf_get_lang dictionary_id='49372.Telefon Numarası'></th>
                <th><cf_get_lang dictionary_id='32443.İletişim Bilgisi'> / <cf_get_lang dictionary_id='32508.E-mail'></th>
                <th><cf_get_lang dictionary_id='46564.Sgk İşyeri Sicil Numarası'></th>
                <th><cf_get_lang dictionary_id='58723.Adres'></th>
                <th><cf_get_lang dictionary_id='38993.SGK Statüsü'></th>
                <th><cf_get_lang dictionary_id='40596.IBAN'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='45126.BES Oranı'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='53245.Social Security Tax Base'></th>
            </tr>
        </thead>
        <tbody>
            <cfif isdefined("get_employees_bes.recordcount") and get_employees_bes.recordcount gt 0>
                <cfoutput query = "get_employees_bes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#TC_IDENTY_NO#</td>
                        <td>#EMPLOYEE_NAME#</td>
                        <td>#EMPLOYEE_SURNAME#</td>
                        <td format="date">#dateFormat(BIRTH_DATE,dateformat_style)#</td>
                        <td format="date">#dateFormat(START_DATE,dateformat_style)#</td>
                        <td format="date">#dateFormat(FINISH_DATE,dateformat_style)#</td>
                        <td style='mso-number-format:"\@"'>#PHONE_NUMBER#</td>
                        <td>#EMAIL#</td>
                        <td style='mso-number-format:"\@"'>#SSK_ISYERI##iif(len(left(SSK_AGENT,3)) eq 3,"#left(SSK_AGENT,3)#","000")#</td>
                        <td>#HOMEADDRESS#</td>
                        <td>#listgetat(list_ucret_names(),listfind(list_ucret(),SSK_STATUTE),"*")#</td>
                        <td>#IBAN_NO#</td>
                        <td style="text-align:right;">#TLFormat(rate_bes)#</td>
                        <cfset get_payroll_bes = get_component.GET_PAYROLL_BES(
                                    start_mon: attributes.start_mon, 
                                    finish_mon: attributes.finish_mon, 
                                    period_years: attributes.period_years,
                                    period_years_end: attributes.period_years,
                                    in_out_id: in_out_id
                                )>
                        <td style="text-align:right;">
                            <cfif get_payroll_bes.recordcount AND len(get_payroll_bes.TOTAL_BES)>
                                #TLFormat(get_payroll_bes.TOTAL_BES)#
                            <cfelse>
                                #TLFormat(0)#
                            </cfif>
                        </td>
                         <td style="text-align:right;">
                            <cfif get_payroll_bes.recordcount AND len(get_payroll_bes.TOTAL_MATRAH)>
                                #TLFormat(get_payroll_bes.TOTAL_MATRAH)#
                            <cfelse>
                                #TLFormat(0)#
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                </tr>
            </cfif>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="4"><!-- sil --><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<!-- sil --></td>
            </tr>
        </tbody>
    </cfif>
</cf_report_list>
<cf_paging
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url_str#"
    >

<script type="text/javascript">
    function control() {
        if(document.search_form.is_excel.checked==false){
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_employee_bes_report</cfoutput>";
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
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&dept=2,3&is_ssk_offices=1&comp_id="+comp_id_list;
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
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&dept=2,3&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
</script>