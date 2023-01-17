<cfset url_str = "">
<cfquery name="GET_NOTICESS" datasource="#DSN#">
	SELECT NOTICE_ID,NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES ORDER BY NOTICE_HEAD
</cfquery>
<cfset notice_list="">
<cfoutput query="GET_NOTICESS">
	<cfset notice_list=listappend(notice_list,NOTICE_ID,',')>
	<cfset notice_list=listappend(notice_list,NOTICE_NO,',')>
	<cfset notice_list=listappend(notice_list,NOTICE_HEAD,',')>
</cfoutput>



<cfparam name="attributes.page" default='1'>


<!---<span class="wrkFileACtions">
<a href="javascript://" onClick="add_select_list();"><i class="icon-file-text" title="<cf_get_lang no ='1752.Seçim Listesi Oluştur'>"></i></a>
<a href="javascript://" onClick="edit_select_list();"><i class="icon-file-text-o" title="<cf_get_lang no ='1753.Mevcut Seçim Listesine Ekle'>"></i></a>
</span>--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfset cmp_process = createObject('component','V16.workdata.get_process')>
    <cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
        <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
            <cfset totalValues = structNew()>
            <cfset totalValues = {
                    total_offtime : 0
                }>
            <cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
                <cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
            </cfif>
            <cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
           
            <cf_workcube_general_process
                mode = "query"
                general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
                general_paper_no = "#attributes.general_paper_no#"
                general_paper_date = "#attributes.general_paper_date#"
                action_list_id = "#action_list_id#"
                process_stage = "#attributes.process_stage#"
                general_paper_notice = "#attributes.general_paper_notice#"
                responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
                responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
                action_table = 'EMPLOYEES_APP'
                action_column = 'EMPAPP_ID'
                action_page = '#request.self#?fuseaction=hr.search_app'
                total_values = '#totalValues#'
            >
            <cfset attributes.approve_submit = 0>
        </cfif>
    </cfif>
    <form name="list_app" method="post" action="">
        <cfoutput>
            <input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="">
            <input type="hidden" name="list_empapp_id" id="list_empapp_id" value="">
            <input type="hidden" name="search_app_pos" id="search_app_pos" value="<cfif isdefined("attributes.search_app_pos")>#attributes.search_app_pos#</cfif>">
            <input type="hidden" name="status_app_pos" id="status_app_pos" value=<cfif isdefined("attributes.status_app_pos")>"#attributes.status_app_pos#</cfif>">
            <input type="hidden" name="search_app" id="search_app" value="<cfif isdefined("attributes.search_app")>#attributes.search_app#</cfif>">
            <input type="hidden" name="status_app" id="status_app" value="<cfif isdefined("attributes.status_app")>#attributes.status_app#</cfif>">
            <input type="hidden" name="date_status" id="date_status" value="<cfif isdefined("attributes.date_status")>#attributes.date_status#</cfif>">
            <input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfif isdefined("attributes.position_cat_id")>#attributes.position_cat_id#</cfif>">
            <input type="hidden" name="position_cat" id="position_cat" value="<cfif isdefined("attributes.position_cat_id")>#attributes.position_cat#</cfif>">
            <input type="Hidden" name="position_id" id="position_id" value="<cfif isdefined("attributes.position_id")>#attributes.position_id#</cfif>">
            <input type="hidden" name="app_position" id="app_position" value="<cfif isdefined("attributes.app_position")>#attributes.app_position#</cfif>">
            <input type="hidden" name="notice_id" id="notice_id" value="<cfif isdefined("attributes.notice_id")>#attributes.notice_id#</cfif>">
            <input type="hidden" name="notice_head" id="notice_head" value="<cfif isdefined("attributes.notice_head")>#attributes.notice_head#</cfif>">
            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")>#attributes.company_id#</cfif>">
            <input type="hidden" name="company" id="company" value="<cfif isdefined("attributes.company")>#attributes.company#</cfif>">
            <input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isdefined("attributes.our_company_id")>#attributes.our_company_id#</cfif>">	
            <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")>#attributes.department_id#</cfif>">
            <input type="hidden" name="department" id="department" value="<cfif isdefined("attributes.department")>#attributes.department#</cfif>">
            <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")>#attributes.branch_id#</cfif>">
            <input type="hidden" name="branch" id="branch" value="<cfif isdefined("attributes.branch")>#attributes.branch#</cfif>">
            <input type="hidden" name="app_date1" id="app_date1" value="<cfif isdefined("attributes.app_date1")>#attributes.app_date1#</cfif>">
            <input type="hidden" name="app_date2" id="app_date2" value="<cfif isdefined("attributes.app_date2")>#attributes.app_date2#</cfif>">
            <input type="hidden" name="prefered_city" id="prefered_city" value="<cfif isdefined("attributes.prefered_city")>#attributes.prefered_city#</cfif>">
            <input type="hidden" name="salary_wanted1" id="salary_wanted1" value="<cfif isdefined("attributes.salary_wanted1")>#attributes.salary_wanted1#</cfif>">
            <input type="hidden" name="salary_wanted2" id="salary_wanted2" value="<cfif isdefined("attributes.salary_wanted2")>#attributes.salary_wanted2#</cfif>">
            <input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="<cfif isdefined("attributes.salary_wanted_money")>#attributes.salary_wanted_money#</cfif>">
            <input type="hidden" name="app_name" id="app_name" value="<cfif isdefined("attributes.app_name")>#attributes.app_name#</cfif>">
            <input type="hidden" name="app_surname" id="app_surname" value="<cfif isdefined("attributes.app_surname")>#attributes.app_surname#</cfif>">
            <input type="hidden" name="birth_date1" id="birth_date1" value="<cfif isdefined("attributes.birth_date1")>#attributes.birth_date1#</cfif>">
            <input type="hidden" name="birth_date2" id="birth_date2" value="<cfif isdefined("attributes.birth_date2")>#attributes.birth_date2#</cfif>">
            <input type="hidden" name="birth_place" id="birth_place" value="<cfif isdefined("attributes.birth_place")>#attributes.birth_place#</cfif>">
            <input type="hidden" name="married" id="married" value="<cfif isdefined("attributes.married")>#attributes.married#</cfif>">
            <input type="hidden" name="city" id="city"  value="<cfif isdefined("attributes.city")>#attributes.city#</cfif>">
            <input type="hidden" name="sex" id="sex" value="<cfif isdefined("attributes.sex")>#attributes.sex#</cfif>">
            <input type="hidden" name="martyr_relative" id="martyr_relative" value="<cfif isdefined("attributes.martyr_relative")>#attributes.martyr_relative#</cfif>">
            <input type="hidden" name="is_trip" id="is_trip" value="<cfif isdefined("attributes.is_trip")>#attributes.is_trip#</cfif>">
            <input type="hidden" name="driver_licence" id="driver_licence" value="<cfif isdefined("attributes.driver_licence")>#attributes.driver_licence#</cfif>">
            <input type="hidden" name="driver_licence_type" id="driver_licence_type" value="<cfif isdefined("attributes.driver_licence_type")>#attributes.driver_licence_type#</cfif>">
            <input type="hidden" name="sentenced" id="sentenced" value="<cfif isdefined("attributes.sentenced")>#attributes.sentenced#</cfif>">
            <input type="hidden" name="defected" id="defected" value="<cfif isdefined("attributes.defected")>#attributes.defected#</cfif>">
            <input type="hidden" name="defected_level" id="defected_level" value="<cfif isdefined("attributes.defected_level")>#attributes.defected_level#</cfif>">
            <input type="hidden" name="email" id="email" value="<cfif isdefined("attributes.email")>#attributes.email#</cfif>">
            <input type="hidden" name="military_status" id="military_status" value="<cfif isdefined("attributes.military_status")>#attributes.military_status#</cfif>">
            <input type="hidden" name="homecity" id="homecity" value="<cfif isdefined("attributes.homecity")>#attributes.homecity#</cfif>">
            <input type="hidden" name="training_level" id="training_level" value="<cfif isdefined("attributes.training_level")>#attributes.training_level#</cfif>">
            <input type="hidden" name="edu_finish" id="edu_finish" value="<cfif isdefined("attributes.edu_finish")>#attributes.edu_finish#</cfif>">
            <input type="hidden" name="exp_year_s1" id="exp_year_s1" value="<cfif isdefined("attributes.exp_year_s1")>#attributes.exp_year_s1#</cfif>">
            <input type="hidden" name="exp_year_s2" id="exp_year_s2" value="<cfif isdefined("attributes.exp_year_s2")>#attributes.exp_year_s2#</cfif>">
            <input type="hidden" name="lang" id="lang" value="<cfif isdefined("attributes.lang")>#attributes.lang#</cfif>">
            <input type="hidden" name="lang_level" id="lang_level" value="<cfif isdefined("attributes.lang_level")>#attributes.lang_level#</cfif>">
            <input type="hidden" name="lang_par" id="lang_par" value="<cfif isdefined("attributes.lang_par")>#attributes.lang_par#</cfif>">
            <input type="hidden" name="edu3_part" id="edu3_part" value="<cfif isdefined("attributes.edu3_part")>#attributes.edu3_part#</cfif>">
            <input type="hidden" name="edu4_id" id="edu4_id" value="<cfif isdefined("attributes.edu4_id")>#attributes.edu4_id#</cfif>">
            <input type="hidden" name="edu4_part_id" id="edu4_part_id" value="<cfif isdefined("attributes.edu4_part_id")>#attributes.edu4_part_id#</cfif>">
            <input type="hidden" name="edu4" id="edu4" value="<cfif isdefined("attributes.edu4")>#attributes.edu4#</cfif>">
            <input type="hidden" name="edu4_part" id="edu4_part" value="<cfif isdefined("attributes.edu4_part")>#attributes.edu4_part#</cfif>">
            <input type="hidden" name="unit_id" id="unit_id" value="<cfif isdefined("attributes.unit_id")>#attributes.unit_id#</cfif>">
            <input type="hidden" name="unit_row" id="unit_row" value="<cfif isdefined("attributes.unit_row") and len(attributes.unit_row)>#attributes.unit_row#</cfif>">
            <input type="hidden" name="referance" id="referance" value="<cfif isdefined("attributes.referance")>#attributes.referance#</cfif>">
            <input type="hidden" name="tool" id="tool" value="<cfif isdefined("attributes.tool")>#attributes.tool#</cfif>">
            <input type="hidden" name="kurs" id="kurs" value="<cfif isdefined("attributes.kurs")>#attributes.kurs#</cfif>">
            <input type="hidden" name="other" id="other" value="<cfif isdefined("attributes.other")>#attributes.other#</cfif>">
            <input type="hidden" name="other_if" id="other_if" value="<cfif isdefined("attributes.other_if")>#attributes.other_if#</cfif>">
        </cfoutput>
    </form>
    <cfinclude template="../query/get_search_app_emp.cfm">
    <cfparam name="attributes.totalrecords" default='#get_apps.recordcount#'>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='31497.CV Başvuruları'> - <cf_get_lang dictionary_id='58088.Arama Sonuçları'></cfsavecontent>
  
        <cfform name="emp_list" method="post" action="">  <cf_box title="#message#" uidrop="1" hide_table_column="1">
            <cfoutput>
                <input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="">
                <input type="hidden" name="list_empapp_id" id="list_empapp_id" value="">
                <input type="hidden" name="search_app_pos" id="search_app_pos" value="<cfif isdefined("attributes.search_app_pos")>#attributes.search_app_pos#</cfif>">
                <input type="hidden" name="status_app_pos" id="status_app_pos" value=<cfif isdefined("attributes.status_app_pos")>"#attributes.status_app_pos#</cfif>">
                <input type="hidden" name="search_app" id="search_app" value="<cfif isdefined("attributes.search_app")>#attributes.search_app#</cfif>">
                <input type="hidden" name="status_app" id="status_app" value="<cfif isdefined("attributes.status_app")>#attributes.status_app#</cfif>">
                <input type="hidden" name="date_status" id="date_status" value="<cfif isdefined("attributes.date_status")>#attributes.date_status#</cfif>">
                <input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfif isdefined("attributes.position_cat_id")>#attributes.position_cat_id#</cfif>">
                <input type="hidden" name="position_cat" id="position_cat" value="<cfif isdefined("attributes.position_cat_id")>#attributes.position_cat#</cfif>">
                <input type="Hidden" name="position_id" id="position_id" value="<cfif isdefined("attributes.position_id")>#attributes.position_id#</cfif>">
                <input type="hidden" name="app_position" id="app_position" value="<cfif isdefined("attributes.app_position")>#attributes.app_position#</cfif>">
                <input type="hidden" name="notice_id" id="notice_id" value="<cfif isdefined("attributes.notice_id")>#attributes.notice_id#</cfif>">
                <input type="hidden" name="notice_head" id="notice_head" value="<cfif isdefined("attributes.notice_head")>#attributes.notice_head#</cfif>">
                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")>#attributes.company_id#</cfif>">
                <input type="hidden" name="company" id="company" value="<cfif isdefined("attributes.company")>#attributes.company#</cfif>">
                <input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isdefined("attributes.our_company_id")>#attributes.our_company_id#</cfif>">	
                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")>#attributes.department_id#</cfif>">
                <input type="hidden" name="department" id="department" value="<cfif isdefined("attributes.department")>#attributes.department#</cfif>">
                <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")>#attributes.branch_id#</cfif>">
                <input type="hidden" name="branch" id="branch" value="<cfif isdefined("attributes.branch")>#attributes.branch#</cfif>">
                <input type="hidden" name="app_date1" id="app_date1" value="<cfif isdefined("attributes.app_date1")>#attributes.app_date1#</cfif>">
                <input type="hidden" name="app_date2" id="app_date2" value="<cfif isdefined("attributes.app_date2")>#attributes.app_date2#</cfif>">
                <input type="hidden" name="prefered_city" id="prefered_city" value="<cfif isdefined("attributes.prefered_city")>#attributes.prefered_city#</cfif>">
                <input type="hidden" name="salary_wanted1" id="salary_wanted1" value="<cfif isdefined("attributes.salary_wanted1")>#attributes.salary_wanted1#</cfif>">
                <input type="hidden" name="salary_wanted2" id="salary_wanted2" value="<cfif isdefined("attributes.salary_wanted2")>#attributes.salary_wanted2#</cfif>">
                <input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="<cfif isdefined("attributes.salary_wanted_money")>#attributes.salary_wanted_money#</cfif>">
                <input type="hidden" name="app_name" id="app_name" value="<cfif isdefined("attributes.app_name")>#attributes.app_name#</cfif>">
                <input type="hidden" name="app_surname" id="app_surname" value="<cfif isdefined("attributes.app_surname")>#attributes.app_surname#</cfif>">
                <input type="hidden" name="birth_date1" id="birth_date1" value="<cfif isdefined("attributes.birth_date1")>#attributes.birth_date1#</cfif>">
                <input type="hidden" name="birth_date2" id="birth_date2" value="<cfif isdefined("attributes.birth_date2")>#attributes.birth_date2#</cfif>">
                <input type="hidden" name="birth_place" id="birth_place" value="<cfif isdefined("attributes.birth_place")>#attributes.birth_place#</cfif>">
                <input type="hidden" name="married" id="married" value="<cfif isdefined("attributes.married")>#attributes.married#</cfif>">
                <input type="hidden" name="city" id="city"  value="<cfif isdefined("attributes.city")>#attributes.city#</cfif>">
                <input type="hidden" name="sex" id="sex" value="<cfif isdefined("attributes.sex")>#attributes.sex#</cfif>">
                <input type="hidden" name="martyr_relative" id="martyr_relative" value="<cfif isdefined("attributes.martyr_relative")>#attributes.martyr_relative#</cfif>">
                <input type="hidden" name="is_trip" id="is_trip" value="<cfif isdefined("attributes.is_trip")>#attributes.is_trip#</cfif>">
                <input type="hidden" name="driver_licence" id="driver_licence" value="<cfif isdefined("attributes.driver_licence")>#attributes.driver_licence#</cfif>">
                <input type="hidden" name="driver_licence_type" id="driver_licence_type" value="<cfif isdefined("attributes.driver_licence_type")>#attributes.driver_licence_type#</cfif>">
                <input type="hidden" name="sentenced" id="sentenced" value="<cfif isdefined("attributes.sentenced")>#attributes.sentenced#</cfif>">
                <input type="hidden" name="defected" id="defected" value="<cfif isdefined("attributes.defected")>#attributes.defected#</cfif>">
                <input type="hidden" name="defected_level" id="defected_level" value="<cfif isdefined("attributes.defected_level")>#attributes.defected_level#</cfif>">
                <input type="hidden" name="email" id="email" value="<cfif isdefined("attributes.email")>#attributes.email#</cfif>">
                <input type="hidden" name="military_status" id="military_status" value="<cfif isdefined("attributes.military_status")>#attributes.military_status#</cfif>">
                <input type="hidden" name="homecity" id="homecity" value="<cfif isdefined("attributes.homecity")>#attributes.homecity#</cfif>">
                <input type="hidden" name="training_level" id="training_level" value="<cfif isdefined("attributes.training_level")>#attributes.training_level#</cfif>">
                <input type="hidden" name="edu_finish" id="edu_finish" value="<cfif isdefined("attributes.edu_finish")>#attributes.edu_finish#</cfif>">
                <input type="hidden" name="exp_year_s1" id="exp_year_s1" value="<cfif isdefined("attributes.exp_year_s1")>#attributes.exp_year_s1#</cfif>">
                <input type="hidden" name="exp_year_s2" id="exp_year_s2" value="<cfif isdefined("attributes.exp_year_s2")>#attributes.exp_year_s2#</cfif>">
                <input type="hidden" name="lang" id="lang" value="<cfif isdefined("attributes.lang")>#attributes.lang#</cfif>">
                <input type="hidden" name="lang_level" id="lang_level" value="<cfif isdefined("attributes.lang_level")>#attributes.lang_level#</cfif>">
                <input type="hidden" name="lang_par" id="lang_par" value="<cfif isdefined("attributes.lang_par")>#attributes.lang_par#</cfif>">
                <input type="hidden" name="edu3_part" id="edu3_part" value="<cfif isdefined("attributes.edu3_part")>#attributes.edu3_part#</cfif>">
                <input type="hidden" name="edu4_id" id="edu4_id" value="<cfif isdefined("attributes.edu4_id")>#attributes.edu4_id#</cfif>">
                <input type="hidden" name="edu4_part_id" id="edu4_part_id" value="<cfif isdefined("attributes.edu4_part_id")>#attributes.edu4_part_id#</cfif>">
                <input type="hidden" name="edu4" id="edu4" value="<cfif isdefined("attributes.edu4")>#attributes.edu4#</cfif>">
                <input type="hidden" name="edu4_part" id="edu4_part" value="<cfif isdefined("attributes.edu4_part")>#attributes.edu4_part#</cfif>">
                <input type="hidden" name="unit_id" id="unit_id" value="<cfif isdefined("attributes.unit_id")>#attributes.unit_id#</cfif>">
                <input type="hidden" name="unit_row" id="unit_row" value="<cfif isdefined("attributes.unit_row") and len(attributes.unit_row)>#attributes.unit_row#</cfif>">
                <input type="hidden" name="referance" id="referance" value="<cfif isdefined("attributes.referance")>#attributes.referance#</cfif>">
                <input type="hidden" name="tool" id="tool" value="<cfif isdefined("attributes.tool")>#attributes.tool#</cfif>">
                <input type="hidden" name="kurs" id="kurs" value="<cfif isdefined("attributes.kurs")>#attributes.kurs#</cfif>">
                <input type="hidden" name="other" id="other" value="<cfif isdefined("attributes.other")>#attributes.other#</cfif>">
                <input type="hidden" name="other_if" id="other_if" value="<cfif isdefined("attributes.other_if")>#attributes.other_if#</cfif>">
            </cfoutput>
            <cf_grid_list>
                <input type="hidden" name="mail" id="mail" value="">
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='46835.İlanlar'></th>
                        <th><cf_get_lang dictionary_id='55745.Yaş'></th>
                        <th><cf_get_lang dictionary_id='57709.Okul'></th>
                        <th><cf_get_lang dictionary_id='57995.Bölüm'></th>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,8,',')><th width="30"><cf_get_lang dictionary_id ='57764.Cinsiyet'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,9,',')><th width="40"><cf_get_lang dictionary_id ='56525.Medeni Hal'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,6,',')><th width="70"><cf_get_lang dictionary_id ='55593.Ev Tel'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,7,',')><th width="70"><cf_get_lang dictionary_id ='58813.Cep Tel'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,5,',')><th width="95"><cf_get_lang dictionary_id ='56522.Yaşadığı İlçe'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,1,',')><th width="25"><cf_get_lang dictionary_id ='58565.Branş'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,2,',')><th width="25"><cf_get_lang dictionary_id ='56514.Staj'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,3,',')><th width="30"><cf_get_lang dictionary_id ='58563.Formasyon'></th></cfif>
                        <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,4,',')><th width="95"><cf_get_lang dictionary_id ='55337.Eğitim Seviyesi'></th></cfif>
                        <th><cf_get_lang dictionary_id='55912.Son Tecrübe'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <!-- sil -->
                        <th><cf_get_lang dictionary_id='41129.Süreç/Aşama'></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th>
                        <th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="send_mail();"><i class="fa fa-envelope"  title="<cf_get_lang dictionary_id ='57475.Mail Gönder'>" alt="<cf_get_lang dictionary_id ='57475.Mail Gönder'>"></i></a></th>
                        <th width="90" class="header_icn_none text-center"><div><cf_get_lang dictionary_id='46186.Toplu onay'></div><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0" total_value="0" amount_value="0" comp_value="0" emp_value="0" /></th>
                        <th width="90" class="header_icn_none text-center"><cf_get_lang dictionary_id='31870.Selection List'><input type="checkbox" name="all_check" id="all_check" value="1" onclick="javascript: hepsi();"></th>
                        <!-- sil -->
                    </tr>
                </thead>
                <tbody>
                    <cfif get_apps.recordcount>
                        <cfset app_color_status_list =''>
                        <cfset empapp_id_list = ''>
                        <cfset training_level_list = ''>
                        <cfset branhes_id_list = ''>
                        <cfoutput query="get_apps">
                            <cfif len(app_color_status) and (not listfind(app_color_status_list,app_color_status))>
                                <cfset app_color_status_list = listappend(app_color_status_list,get_apps.app_color_status,',')>
                            </cfif>
                            <cfif not listfind(empapp_id_list,EMPAPP_ID)>
                                <cfset empapp_id_list=listappend(empapp_id_list,EMPAPP_ID)>
                        </cfif>
                        <cfif len(training_level) and (not listfind(training_level_list,training_level))>
                                <cfset training_level_list=listappend(training_level_list,TRAINING_LEVEL)>
                        </cfif>
                        </cfoutput>
                        <cfset empapp_id_list=listsort(empapp_id_list,'numeric','ASC')>
                        <cfset training_level_list=listsort(training_level_list,'numeric','ASC')>
                        <cfif listlen(app_color_status_list)>
                            <cfquery name="get_cv_status" datasource="#dsn#">
                                SELECT STATUS_ID,STATUS,ICON_NAME FROM SETUP_CV_STATUS WHERE STATUS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#app_color_status_list#">) ORDER BY STATUS_ID
                            </cfquery>
                            <cfset app_color_status_list = listsort(valuelist(get_cv_status.status_id,','),"numeric","ASC",',')>
                        </cfif>
                        <cfif len(empapp_id_list)>
                            <cfquery name="get_teacher_detail" datasource="#DSN#">
                                SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#empapp_id_list#">) ORDER BY EMPAPP_ID
                            </cfquery>
                        </cfif>
                        <cfset empapp_id_list = listsort(listdeleteduplicates(valuelist(get_teacher_detail.EMPAPP_ID,',')),'numeric','ASC',',')>
                        <cfif len(training_level_list)>
                            <cfquery name="get_edu_level" datasource="#DSN#">
                                SELECT * FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#training_level_list#">) ORDER BY EDU_LEVEL_ID
                            </cfquery>
                        <cfset training_level_list = listsort(listdeleteduplicates(valuelist(get_edu_level.EDU_LEVEL_ID,',')),'numeric','ASC',',')>
                        </cfif>
                    </cfif>
                    <cfquery name="get_branches_info" datasource="#dsn#">
                        SELECT * FROM SETUP_APP_BRANCHES_ROWS
                    </cfquery>
                    <cfquery name="get_all_info" datasource="#dsn#">
                        SELECT * FROM EMPLOYEES_APP_INFO
                    </cfquery>
                    <cfif get_apps.recordcount>
                        <cfoutput query="get_apps">
                            <tr>
                                <td>
                                    <cfif len(get_apps.app_pos_id)>
                                        <a href="#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#get_apps.empapp_id#&app_pos_id=#get_apps.app_pos_id#" class="tableyazi">#currentrow#</a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#get_apps.empapp_id#" class="tableyazi">#currentrow#</a>
                                    </cfif>
                                </td>
                                <td>#dateformat(get_apps.APP_DATE,dateformat_style)#</td>
                                <td><a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#get_apps.empapp_id#" class="tableyazi">#name# #surname#</a></td>
                                <td>
                                        <!--- <cfif len(get_apps.notice_id) gt 2>--->
                                        <a href="#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#get_apps.notice_id#" class="tableyazi">#ListGetAt(notice_list,ListFind(notice_list,get_apps.notice_id,',')+1,',')#-#ListGetAt(notice_list,ListFind(notice_list,get_apps.notice_id,',')+2,',')#<!---#get_notices.NOTICE_NO#-#get_notices.NOTICE_HEAD#---></a>
                                        <!--- </cfif>--->
                                </td>
                                <td>
                                <cfif len(get_apps.BIRTH_DATE)>
                                    <cfset yas = datediff("yyyy",get_apps.BIRTH_DATE,NOW())>
                                    <cfif yas neq 0>#yas#</cfif>	
                                </cfif>
                                </td>
                                <td>
                                    <cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
                                        SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EDU_START DESC
                                    </cfquery>
                                    <cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name#</cfif>
                                </td>
                                <td>
                                    <cfif get_app_edu_info.recordcount>#get_app_edu_info.edu_part_name#</cfif>
                                </td>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,8,',')>
                                    <td><cfif SEX eq 1><cf_get_lang dictionary_id='58959.Erkek'><cfelse><cf_get_lang dictionary_id ='55621.Bayan'></cfif></td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,9,',')>
                                    <td>
                                        <cfif MARRIED eq 1><cf_get_lang dictionary_id ='55743.Evli'><cfelse><cf_get_lang dictionary_id ='55744.Bekar'></cfif>
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,6,',')>
                                    <td>#HOMETELCODE# #HOMETEL#</td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,7,',')>
                                    <td>#MOBILCODE# #MOBIL#</td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,5,',')>
                                    <td>
                                        #HOMECOUNTY#
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,1,',')>
                                    <td>
                                        <cfif len(empapp_id_list)>
                                            <cfquery name="get_info" dbtype="query">
                                                SELECT * FROM get_all_info WHERE EMPAPP_ID = #get_apps.empapp_id#
                                            </cfquery>
                                            <cfloop query="get_info">
                                                <cfquery name="get_row_info" dbtype="query">
                                                    SELECT * FROM get_branches_info WHERE BRANCHES_ROW_ID = #get_info.BRANCHES_ROW_ID#
                                                </cfquery>	
                                                <cfif get_row_info.recordcount>
                                                    #get_row_info.branches_name_row#<br/>
                                                </cfif>										
                                            </cfloop>
                                        </cfif>
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,2,',')>
                                    <td>
                                        <cfif get_teacher_detail.INTERNSHIP[listfind(empapp_id_list,EMPAPP_ID,',')] eq 1><cf_get_lang dictionary_id ='56213.aday'><cfelseif get_teacher_detail.INTERNSHIP[listfind(empapp_id_list,EMPAPP_ID,',')] eq 2><cf_get_lang dictionary_id ='56015.asıl'></cfif>
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,3,',')>
                                    <td>
                                        <cfif get_teacher_detail.IS_FORMATION[listfind(empapp_id_list,EMPAPP_ID,',')] eq 1><cf_get_lang dictionary_id='58564.var'><cfelseif get_teacher_detail.IS_FORMATION[listfind(empapp_id_list,EMPAPP_ID,',')] eq 0><cf_get_lang dictionary_id='58546.yok'></cfif>
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,4,',')>
                                    <td>
                                        #get_edu_level.EDUCATION_NAME[listfind(training_level_list,TRAINING_LEVEL,',')]#
                                    </td>
                                </cfif>
                                <td>
                                    <cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
                                        SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EXP_START DESC
                                    </cfquery>
                                    <cfif get_app_work_info.recordcount>
                                        #get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</td>
                                    </cfif>
                                </td>
                                <td><cfif app_pos_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                <!-- sil -->
                                <td>
                                    <cfif len(cv_stage)>
                                        <cf_workcube_process select_name="cv_stage" type="color-status" process_stage="#cv_stage#" fuseaction="hr.search_app">
                                    </cfif>
                                </td>
                                <td><a href="#request.self#?fuseaction=objects.popup_print_files&iid=#get_apps.empapp_id#&print_type=170"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                                <td>
                                    <cfif get_apps.app_pos_id>
                                        <input type="hidden" name="basvuru_id" id="basvuru_id" value="#get_apps.app_pos_id#">
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_app_add_mail&empapp_id=#get_apps.empapp_id#&app_pos_id=#get_apps.app_pos_id#','page');return false;"><i class="fa fa-envelope"   title="<cf_get_lang dictionary_id ='57475.Mail Gönder'>" alt="<cf_get_lang dictionary_id ='57475.Mail Gönder'>"></i></a>
                                    <cfelse>
                                        <input type="hidden" name="basvuru_id" id="basvuru_id" value="0">
                                    </cfif>
                                </td>
                                
                                <td style="text-align:center;"> <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#EMPAPP_ID#"  /></td>
                                <td style="text-align:center;"><input type="checkbox" name="ozgecmis_id" id="ozgecmis_id" value="#get_apps.empapp_id#"></td>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <div class="col col-12 pull-right">
                <div class="col col-2 pull-right">
                    <a href="javascript://" onclick="add_select_list();" class="ui-btn ui-btn-success"><cf_get_lang no ='1752.Seçim Listesi Oluştur'></a>
                </div>
                <div class="col col-2 pull-right">
                    <a href="javascript://" onclick="edit_select_list();" class="ui-btn ui-btn-success"><cf_get_lang no ='1753.Mevcut Seçim Listesine Ekle'></a>
                </div>
            </div>
            </cf_box>
            <cf_box id="list_checked" closable="0" title="#getLang('','',46186)#">
				<cf_box_elements vertical="1">
					<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
            
						<cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                            FACTION_LIST :"hr.search_app"
						)>
						<cf_workcube_general_process hide="1" select_value = '#get_process_f.process_row_id#'>						
					</div>
				</cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="ui-form-list-btn">
						<input type="hidden" id="paper_submit" name="paper_submit" value="1">
						<div>
							<input type="submit" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
						</div>
					</div>
				</div>
			</cf_box>
         
        </cfform>
   
</div>

<script type="text/javascript">
function hepsi()
{
	if (document.emp_list.all_check.checked)
		{
	<cfif get_apps.recordcount gt 1>	
		for(i=0;i<emp_list.ozgecmis_id.length;i++) 
		{
			emp_list.ozgecmis_id[i].checked = true;
		}
	<cfelseif get_apps.recordcount eq 1>
		emp_list.ozgecmis_id.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_apps.recordcount gt 1>	
		for(i=0;i<emp_list.ozgecmis_id.length;i++) 
		{
			emp_list.ozgecmis_id[i].checked = false;
		}
	<cfelseif get_apps.recordcount eq 1>
		emp_list.ozgecmis_id.checked = false;
	</cfif>
		}
}

function setofftimesProcess(){
	/* 	var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		}); */
		/* if(controlChc == 0){
			alert("İzin Seçiniz");
			return false;
		} */
		/* if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else */
        
	
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("Lütfen Belge Tarihi Giriniz!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("Lütfen Ek Açıklama Giriniz!");
			return false;
		}
       
	
    
        $('#setProcessForm').submit();
		
	}
function send_mail()
{
<cfif get_apps.recordcount>
		for(i=0;i<emp_list.ozgecmis_id.length;i++) 
		{
			if(document.emp_list.ozgecmis_id[i].checked)
			{
				if(document.emp_list.mail.value.length==0) ayirac=''; else ayirac=',';
					document.emp_list.mail.value=document.emp_list.mail.value+ayirac+document.emp_list.ozgecmis_id[i].value;
			}
		}
		windowopen('','list','select_list_window');
		emp_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_app_add_mail&mail_sum=1&is_refresh=0</cfoutput>';
		emp_list.target='select_list_window';emp_list.submit();
		document.emp_list.mail.value='';/* maileri yolladıktan sonra alanı boşaltıyoruz*/
<cfelse>
	alert("<cf_get_lang dictionary_id='57484.Kayıt Yok'>!")
</cfif>
}

function add_select_list(){
    document.list_app.list_empapp_id.value = '';
    <cfif get_apps.recordcount>
        <cfif get_apps.recordcount gt 1> 
            for(i=0;i<emp_list.ozgecmis_id.length;i++)
                if(document.emp_list.ozgecmis_id[i].checked)
                {
                    if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
                    document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
                    document.list_app.list_app_pos_id.value=document.list_app.list_app_pos_id.value+ayirac+document.emp_list.basvuru_id[i].value;
                }
        <cfelse>
            if(document.emp_list.ozgecmis_id.checked)
            {
                document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
                document.list_app.list_app_pos_id.value=document.emp_list.basvuru_id.value;
            }
        </cfif>
        if(document.list_app.list_empapp_id.value.length==0)
        {
            alert("<cf_get_lang dictionary_id ='56841.Özgeçmiş Seçmelisiniz'>");
            return false;
        }
            var form = $('form[name = list_app]');
            openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&type=2</cfoutput>&'+form.serialize()).replaceAll("+", " "));
    <cfelse>
        alert("<cf_get_lang dictionary_id='57484.Kayıt Yok'>!")
    </cfif>
}

function edit_select_list()
{
<cfif get_apps.recordcount>
	<cfif get_apps.recordcount gt 1> 
		for(i=0;i<emp_list.ozgecmis_id.length;i++)
			if(document.emp_list.ozgecmis_id[i].checked)
			{
			if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
				document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
				document.list_app.list_app_pos_id.value=document.list_app.list_app_pos_id.value+ayirac+document.emp_list.basvuru_id[i].value;
			}
	<cfelse>
		if(document.emp_list.ozgecmis_id.checked)
			document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
			document.list_app.list_app_pos_id.value=document.emp_list.basvuru_id.value;
	</cfif>
	if(document.list_app.list_empapp_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id ='56841.Özgeçmiş Seçmelisiniz'>");
		return false;
	}
        var form = $('form[name = list_app]');
        openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1</cfoutput>&'+form.serialize()).replaceAll("+", " "));

		/* windowopen('','list','select_list_window');
		list_app.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1</cfoutput>';
		list_app.target='select_list_window';list_app.submit();
		document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
		// document.list_app.list_app_pos_id.value='';
<cfelse>
	alert("<cf_get_lang dictionary_id='57484.Kayıt Yok'>!")
</cfif>	
}
function edit_app_color()
{
<cfif get_apps.recordcount>
	<cfif get_apps.recordcount gt 1> 
			for(var i=0;i<<cfoutput>#get_apps.recordcount#</cfoutput>;i++)
			if(document.emp_list.ozgecmis_id[i].checked)
			{
			if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
				document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
			}
	<cfelse>
		if(document.emp_list.ozgecmis_id.checked)
			document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
	</cfif>
	if(document.list_app.list_empapp_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='56841.Özgeçmiş Seçmelisiniz'>");
		return false;
	}
		windowopen('','small','select_list_window');
		list_app.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_list_app_color_status</cfoutput>';
		list_app.target='select_list_window';list_app.submit();
		document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
<cfelse>
	alert("<cf_get_lang dictionary_id='57484.Kayıt Yok'>!")
</cfif>
}
</script>