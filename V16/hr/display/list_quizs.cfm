<!--- wrk_search_button word,excel_pdf e gonder de problem yaptigi icin kapatildi kontroller guncelle bolumune konuldu SG20120721--->
<!---<cfif fuseaction eq "hr.list_quizs">
	<cfset xfa.fuseac = "hr.list_quizs">
	<cfset xfa.fuseac2 = "hr.quiz">
<cfelseif fuseaction eq "hr.popup_list_quizs">
	<cfset xfa.fuseac = "hr.popup_list_quizs">
	<cfset xfa.fuseac2 = "hr.add_poscat_empquiz">
<cfelseif fuseaction eq "hr.popup_app_position_list_quizs">
	<cfset xfa.fuseac = "hr.popup_list_quizs">
	<cfset xfa.fuseac2 = "hr.add_app_position_empquiz">
	<cfset xfa.fuseac3 = "hr.emptypopup_add_emp_interview_quiz">
	<cfinclude template="../query/get_quizs.cfm">
<cfelseif fuseaction eq "hr.popup_position_list_quizs">
	<cfset xfa.fuseac = "hr.popup_position_list_quizs">
	<cfset xfa.fuseac2 = "hr.add_position_empquiz">
	<cfinclude template="../query/get_quizs.cfm">	
</cfif>--->
<cfif fuseaction eq "hr.popup_app_position_list_quizs">
	<cfinclude template="../query/get_quizs.cfm">
<cfelseif fuseaction eq "hr.popup_position_list_quizs">
	<cfinclude template="../query/get_quizs.cfm">	
</cfif>
<cfparam name="attributes.form_status" default="1">
<cfparam name="attributes.form_stage" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.last30_all" default="#session.ep.period_year#">
<cfset url_str = "">
<cfif isdefined("attributes.poscat_id") and len(attributes.poscat_id)>
	<cfset url_str = "#url_str#&poscat_id=#poscat_id#">
</cfif>
<cfif isdefined("attributes.popup_page") and len(attributes.popup_page)>
	<cfset url_str = "#url_str#&popup_page=#attributes.popup_page#">
</cfif>
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
	<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif isdefined("attributes.POSITION_ID")>
	<cfset url_str = "#url_str#&position_id=#attributes.POSITION_ID#">
</cfif>
<cfif isdefined("attributes.attenders")>
	<cfset url_str = "#url_str#&attenders=#attenders#">
</cfif>
<cfif isdefined("attributes.form_type")>
	<cfset url_str = "#url_str#&form_type=#form_type#">
</cfif>
<cfif isdefined('attributes.form_status')>
	<cfset url_str="#url_str#&form_status=#attributes.form_status#">
</cfif>
<cfif isdefined("attributes.last30_all")>
	<cfset url_str = "#url_str#&last30_all=#attributes.last30_all#">
</cfif>
 <cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_quizs.cfm">
<cfelse>
	<cfset get_quizs.recordcount = 0>
</cfif> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_quizs.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS =1 ORDER BY POSITION_CAT
</cfquery>
<cfform name="list_quizes" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55119.Ölçme Değerlendirme Formları"></cfsavecontent>
    <cf_big_list_search title="#message#">
        <cf_big_list_search_area>
            <table>
                <tr> 							   
                    <input type="hidden" name="popup_page" id="popup_page" value="<cfif isdefined("attributes.popup_page") and attributes.popup_page eq 1><cfoutput>#attributes.popup_page#</cfoutput></cfif>">
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                    <input type="hidden" name="poscat_id" id="poscat_id" value="<cfif isdefined("attributes.poscat_id") and len(attributes.poscat_id)><cfoutput>#attributes.poscat_id#</cfoutput></cfif>">
                    <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                    <td><cfif isdefined("attributes.POSITION_ID")>
                            <input type="hidden" name="POSITION_ID" id="POSITION_ID" value="<cfoutput>#POSITION_ID#</cfoutput>">
                        </cfif>			
                        <cfinput type="text" id="keyword" name="keyword" maxlength="50" value="#attributes.keyword#">
                    </td>
                    <td><select name="position_cat_id" id="position_cat_id" style="width:125px;">
                            <option value="" selected><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> 
                            <cfoutput query="get_position_cats"> 
                                <cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
                                    <option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat# 
                                <cfelse>
                                    <option value="#position_cat_id#">#position_cat#
                                </cfif>
                            </cfoutput> 
                        </select>
                    </td>
                    <td><select name="form_type" id="form_type" style="width:125px;">
                            <option value="0" selected><cf_get_lang dictionary_id='55480.Tüm Formlar'> 
                            <option value="1" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58003.Performans'>
                            <option value="2" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 2>selected</cfif>><cf_get_lang dictionary_id='56666.Mülakat'>(<cf_get_lang dictionary_id='55098.İşe Giris'>)
                            <option value="5" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 5>selected</cfif>><cf_get_lang dictionary_id='56666.Mülakat'>(<cf_get_lang dictionary_id='29832.İşte Çıkış'>)
                            <option value="6" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 6>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'>
                        </select>
                    </td>
                    <td><select name="form_status" id="form_status">
                            <option value=""<cfif not len(attributes.form_status)> selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'>
                            <option value="1"<cfif attributes.form_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                            <option value="0"<cfif attributes.form_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                        </select>
                    </td> 
                    <td><select name="last30_all" id="last30_all" style="width:100px;">
                            <option value="2" <cfif isdefined("attributes.last30_all") and attributes.last30_all eq 2>selected</cfif>><cf_get_lang dictionary_id="58081.Hepsi">      
                            <cfoutput>
                                <cfloop from="2003" to="#year(now())+2#" index="yil">
                                    <option value="#yil#" <cfif (isdefined("attributes.last30_all") and (attributes.last30_all eq yil)) or (not isdefined("attributes.last30_all") and yil eq session.ep.period_year)>selected</cfif>>#yil#
                                </cfloop>
                            </cfoutput>
                        </select>
                    </td>
                    <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
    </cfform>
    <cf_big_list>
        <thead>						
            <tr> 
                <th width="40"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='29764.Form'></th>
                <th width="55"><cf_get_lang dictionary_id='57630.Tip'></th>
                <th width="100"><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
                <th width="35"><cf_get_lang dictionary_id='58455.Yıl'></th>
                <th width="45"><cf_get_lang dictionary_id='57482.Aşama'></th>
                <!-- sil -->
                <th class="header_icn_none"><a <cfif fuseaction contains 'popup'>target="_blank"</cfif> href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_quiz"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif get_quizs.recordcount>
                <cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                <cfset stage = get_quizs.STAGE_ID> 
                    <tr>
                        <td width="40">#currentrow#</td>
                        <td>#QUIZ_HEAD#</td>
                        <td>
                            <cfif 1 is IS_APPLICATION><cf_get_lang dictionary_id='55116.Başvuru'>
                                <cfelseif 1 is IS_EDUCATION><cf_get_lang dictionary_id='57419.Eğitim'>
                                <cfelseif 1 IS IS_TRAINER><cf_get_lang dictionary_id='55913.Eğitimci'>
                                <cfelseif 1 IS IS_INTERVIEW><cf_get_lang dictionary_id='30922.Mülakat'>
                                <cfelseif 1 IS IS_TEST_TIME><cf_get_lang dictionary_id='29776.Deneme Süresi'>
                                <cfelse><cf_get_lang dictionary_id='57576.Çalışan'>
                            </cfif>
                        </td>
                        <td>
                            <cfif len(RECORD_EMP)>
                                <cfquery name="GET_EMPLOYEE" datasource="#dsn#">
                                    SELECT 
                                        EMPLOYEE_NAME,
                                        EMPLOYEE_SURNAME,
                                        MEMBER_CODE
                                    FROM 
                                        EMPLOYEES
                                    WHERE 
                                        EMPLOYEE_ID = #RECORD_EMP#
                                </cfquery>
                                #get_employee.employee_name# #get_employee.employee_surname# 
                                <cfelseif len(record_par)>
                                    <cfset attributes.partner_id = RECORD_PAR>
                                <cfinclude template="../query/get_partner2.cfm">
                                #get_partner.company_partner_name# #get_partner.company_partner_surname# 
                            </cfif>
                        </td>
                        <td>#year(record_date)#</td>
                        <td><cfif IS_ACTIVE IS 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                        <!-- sil -->
                        <td>
                            <cfif isdefined("attributes.form_type") and (attributes.form_type eq 5) and isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.popup_page") and attributes.popup_page eq 1>
                                <a href="#request.self#?fuseaction=hr.emptypopup_add_emp_interview_quiz&quiz_id=#quiz_id#&employee_id=#attributes.employee_id#<cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif>" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a> 
                            <cfelse>	
                            <cfif fuseaction eq "hr.list_quizs">
                                <a href="#request.self#?fuseaction=hr.quiz&quiz_id=#quiz_id#<cfif isdefined("attributes.poscat_id") and len(attributes.poscat_id)>&poscat_id=#poscat_id#</cfif><cfif IsDefined("attributes.position_id")>&position_id=#attributes.position_id#</cfif><cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif>" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                            <cfelseif fuseaction eq "hr.popup_list_quizs">
                                <a href="#request.self#?fuseaction=hr.add_poscat_empquiz&quiz_id=#quiz_id#<cfif isdefined("attributes.poscat_id") and len(attributes.poscat_id)>&poscat_id=#poscat_id#</cfif><cfif IsDefined("attributes.position_id")>&position_id=#attributes.position_id#</cfif><cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif>" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                            <cfelseif fuseaction eq "hr.popup_app_position_list_quizs">
                                <a href="#request.self#?fuseaction=hr.add_app_position_empquiz&quiz_id=#quiz_id#<cfif isdefined("attributes.poscat_id") and len(attributes.poscat_id)>&poscat_id=#poscat_id#</cfif><cfif IsDefined("attributes.position_id")>&position_id=#attributes.position_id#</cfif><cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif>" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                            <cfelseif fuseaction eq "hr.popup_position_list_quizs">
                                <a href="#request.self#?fuseaction=hr.add_position_empquiz&quiz_id=#quiz_id#<cfif isdefined("attributes.poscat_id") and len(attributes.poscat_id)>&poscat_id=#poscat_id#</cfif><cfif IsDefined("attributes.position_id")>&position_id=#attributes.position_id#</cfif><cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif>" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                            </cfif> 
                            </cfif>							
                        </td>
                        <!-- sil -->
                    </tr>
                </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
            </cfif>
        </tbody>
    </cf_big_list>
	<cfset url_str = "">
    <cfif isdefined("attributes.is_submit") and len("attributes.is_submit")>
        <cfset url_str = "&is_submit=#attributes.is_submit#"> 
    </cfif>                  
    <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#attributes.fuseaction##url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
