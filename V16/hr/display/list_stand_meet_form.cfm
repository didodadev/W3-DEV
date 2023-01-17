<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="is_form_submit" default="0">
<cfif is_form_submit>
	<cfquery name="get_emp_pos" datasource="#dsn#">
		SELECT 
			POSITION_CODE 
		FROM 
			EMPLOYEE_POSITIONS 
		WHERE 
			EMPLOYEE_ID=<cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee_id#<cfelse>#session.ep.userid#</cfif>
	</cfquery>
	<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
	<cfset j=0>
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
	<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
	<cfquery name="GET_FORMS" datasource="#dsn#">
		SELECT
			* 
		FROM 
			PERF_MEET_FORM
		WHERE 
			FORM_ID IS NOT NULL
			<cfif not session.ep.ehesap or len(attributes.employee_id) and len(attributes.employee)>
				<cfif isdefined("attributes.valid_status") and len(attributes.valid_status)><!---onay bekleyenler secili ise--->
				AND(
				<cfloop list="#position_list#" index="i">
					<cfset j=j+1>
					(FIRST_BOSS_CODE=#i# AND FIRST_BOSS_VALID IS NULL) OR
					(SECOND_BOSS_CODE=#i# AND SECOND_BOSS_VALID IS NULL) OR
					(THIRD_BOSS_CODE=#i# AND THIRD_BOSS_VALID IS NULL) OR
					(FOURTH_BOSS_CODE=#i# AND FOURTH_BOSS_VALID IS NULL) OR
					(FIFTH_BOSS_CODE=#i# AND FIFTH_BOSS_VALID IS NULL)
					<cfif listlen(position_list,',') gt j>OR</cfif>
				</cfloop>
				)
 				<cfelse>
				AND (
					 <cfif len(attributes.employee_id) and len(attributes.employee)>
					 	EMPLOYEE_ID=#attributes.employee_id#
					<cfelse>
						EMPLOYEE_ID=#session.ep.userid#
					</cfif>
					 OR FIRST_BOSS_CODE IN (#position_list#)
					 OR SECOND_BOSS_CODE IN (#position_list#)
					 OR THIRD_BOSS_CODE IN (#position_list#)
					 OR FOURTH_BOSS_CODE IN (#position_list#)
					 OR FIFTH_BOSS_CODE IN (#position_list#)

					 )
				</cfif>
			</cfif>
			<cfif isdefined('attributes.start_date') and len(attributes.start_date)> AND START_DATE >=#attributes.start_date#</cfif>
			<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)> AND FINISH_DATE <=#attributes.finish_date#</cfif>
	</cfquery>
	<cfquery name="GET_CARE_ALL" datasource="#dsn#">
		SELECT FORM_ID,MEET_FORM_ID FROM PERF_CAREER_FORM
	</cfquery>
	<cfquery name="GET_PERF_ALL" datasource="#dsn#">
		SELECT FORM_ID,MEET_FORM_ID FROM PERF_STANDART_FORM
	</cfquery>
<cfelse>
	<cfset GET_FORMS.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default=#GET_FORMS.recordcount#>
<cfform name="search_perf" method="post" action="#request.self#?fuseaction=hr.list_stand_meet_form">
<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56326.Standart Performans"></cfsavecontent>
    <cf_big_list_search title="#message#">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <cfif session.ep.ehesap>
                    <td>
                        <cf_get_lang dictionary_id='58875.Çalışanlar'>
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                        <input type="text" name="employee" id="employee" style="width:100px;" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="50">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_perf.employee_id&field_name=search_perf.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_perf.employee.value)+'&branch_related','list');"><img src="/images/plus_thin.gif"></a>
                    </td>
                    </cfif>
                    <td>
                        <select name="valid_status" id="valid_status">
                            <option value=""><cf_get_lang dictionary_id ='55480.Tüm Formlar'></option>
                            <option value="1" <cfif isdefined("attributes.valid_status") and len(attributes.valid_status) eq 1>selected</cfif>><cf_get_lang dictionary_id ='56568.Onay Bekleyenler'></option>
                        </select>
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                        <cf_wrk_date_image date_field="start_date">
                            <cfsavecontent variable="message2"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message2#">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td>
                        <cf_wrk_search_button search_function='kontrol()'>
                    </td>
                    <td><!---<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_performans_all_valid"><img src="/images/family.gif" title="<cf_get_lang no ='1485.Toplu Performans Düzenle ve Onay'>"></a> Fuseaction tanimli olmadigi icin sayfa hataya düsüyordu diye kapattim.---></td>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
    </cfform>
    <cf_big_list> 
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
                <th width="120"><cf_get_lang dictionary_id ='56569.İlk Amir'></th>
                <th width="150"><cf_get_lang dictionary_id ='57742.Tarih'></th>
                <!-- sil -->
                <th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_perf_meet_form','project');"><img src="images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
                <!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif GET_FORMS.recordcount>
                <cfset employee_id_list=''>
                <cfoutput query="GET_FORMS">
                    <cfif len(employee_id) and not listfindnocase(employee_id_list,employee_id)>
                        <cfset employee_id_list=listappend(employee_id_list,employee_id)>
                    </cfif>
                </cfoutput>
                <cfif listlen(employee_id_list)>
                    <cfset employee_id_list = listsort(employee_id_list,"numeric","ASC",",")>
                    <cfquery name="get_employee1" datasource="#dsn#">
                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#employee_id_list#) ORDER BY EMPLOYEE_ID
                    </cfquery>
                </cfif>		
                <cfoutput query="GET_FORMS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_emp_det&emp_id=#get_forms.employee_id#','medium','popup_emp_det');" class="tableyazi">#get_employee1.EMPLOYEE_NAME[listfind(employee_id_list,get_forms.employee_id,',')]#&nbsp;#get_employee1.EMPLOYEE_SURNAME[listfind(employee_id_list,get_forms.employee_id,',')]#</a></td>
                    <td>#get_emp_info(FIRST_BOSS_CODE,1,0)#</td>
                    <td>#dateformat(start_date,dateformat_style)#-#dateformat(finish_date,dateformat_style)#</td>
                        <!-- sil -->
                    <td>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_perf_meet_form&form_id=#FORM_ID#','project','popup_upd_perf_meet_form');"><img src="images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                        <cfif EMPLOYEE_ID neq session.ep.userid>
                                <cfquery name="GET_CARE" dbtype="query">
                                    SELECT FORM_ID FROM GET_CARE_ALL WHERE MEET_FORM_ID = #FORM_ID#
                                </cfquery>
								<cfif GET_CARE.recordcount>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_career_form&form_id=#GET_CARE.FORM_ID#','project');"><img src="images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                                <cfelseif get_forms.first_boss_id eq session.ep.userid>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_add_career_form&meet_form_id=#FORM_ID#&employee_id=#EMPLOYEE_ID#','project');"><img src="images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
                                </cfif>
                                <cfquery name="get_perf" dbtype="query">
                                    SELECT FORM_ID FROM GET_PERF_ALL WHERE MEET_FORM_ID = #FORM_ID#
                                </cfquery>
								<cfif get_perf.recordcount>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_stand_perf_form&form_id=#get_perf.FORM_ID#','project');"><img src="images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                                        <cfelseif get_forms.first_boss_id eq session.ep.userid>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_stand_perf_form&meet_form_id=#FORM_ID#&employee_id=#EMPLOYEE_ID#','project');"><img src="images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
                                </cfif>
                        </cfif>
                    </td>
                </tr>
                </cfoutput>
                <cfelse>
                <tr>
                    <td colspan="5"><cfif is_form_submit><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_big_list> 
    <cfset url_str = "">
    <cfif isdefined('attributes.employee') and len(attributes.employee)><cfset url_str = "#url_str#&employee_id=#attributes.employee_id#&employee=#attributes.employee#"></cfif>
    <cfif len(attributes.start_date)><cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#"></cfif>
    <cfif len(attributes.finish_date)><cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#"></cfif>
    <cfif isdefined("attributes.valid_status") and len(attributes.valid_status)><cfset url_str = "#url_str#&valid_status=#attributes.valid_status#"></cfif>
    <cfif isdefined("attributes.is_form_submit") and len(attributes.is_form_submit)><cfset url_str = "#url_str#&is_form_submit=#attributes.is_form_submit#"></cfif>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="hr.list_stand_meet_form#url_str#">
<script type="text/javascript">
	document.getElementById('employee').focus();
	function kontrol()
	{
	if ( (search_perf.start_date.value.length != 0)&&(search_perf.finish_date.value.length != 0) )
		return date_check(search_perf.start_date,search_perf.finish_date,"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	return true;
	}
</script>
