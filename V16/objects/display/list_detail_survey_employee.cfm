<!--- Form Generator syafasından kimlerin anketi doldurduğunu görebilmek amacıyla yapılmıştır.--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.survey_id" default="">
<cfparam name="attributes.startdate" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
    <cf_date tarih = "attributes.startdate">
<cfelse>
    <cfset attributes.startdate = ''>
</cfif>
<cfif isdefined('attributes.form_submitted')>
    <cfquery name="get_main_result_employee" datasource="#dsn#">
		SELECT
			SM.SURVEY_MAIN_HEAD AS HEAD,
			SM.SURVEY_MAIN_ID,
			SM.TYPE,
			SR.SURVEY_MAIN_RESULT_ID,
			SR.ACTION_TYPE,
			SR.ACTION_ID,
			SR.RECORD_DATE,
            SR.START_DATE,
            EMPLOYEES.EMPLOYEE_NAME AS AD, 
            EMPLOYEES.EMPLOYEE_SURNAME AS SOYAD, 
            EMPLOYEES.EMPLOYEE_ID AS NO
		FROM
			SURVEY_MAIN_RESULT SR,
			SURVEY_MAIN SM,
            EMPLOYEES
		WHERE
			SR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
            SR.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
            SR.EMP_ID = EMPLOYEES.EMPLOYEE_ID 
			<cfif len(attributes.emp_id)>
				AND SR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
            </cfif>
			<cfif len(attributes.keyword)>
				AND (SM.SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
            <cfif len(attributes.startdate)>
                AND SR.START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
            </cfif>
		ORDER BY
			SR.START_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_main_result_employee.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_main_result_employee.recordcount#'>
<div class="col col-12 col-xs-12"
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57576.Çalışan'><cf_get_lang dictionary_id='34597.Anket Sonuçları'></cfsavecontent>
    <cf_box title="#message#" closable="0" uidrop="1">
        <cfform name="search_survey" method="post" action="#request.self#?fuseaction=settings.list_detail_survey_employee&survey_id=#attributes.survey_id#">
        <input type="hidden" name="form_submitted" value="1">
        <input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
            <cf_box_search more="0">
                <cfoutput>
                    <div class="form-group" id="item-keyword">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                    </div>		 
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="emp_id" maxlength="50" id="emp_id" value="<cfif len(attributes.emp_id) and len(attributes.employee_name)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">      
                            <input type="text" name="employee_name" maxlength="50" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" id="employee_name" value="<cfif len(attributes.emp_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_survey.emp_id&field_name=search_survey.employee_name&select_list=1&branch_related','list','popup_list_positions')"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" placeholder="<cf_get_lang dictionary_id='59871.Katılım Tarihi'>" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                </cfoutput>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
                <thead>
                    <tr>
                        <th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
                        <th><cf_get_lang dictionary_id='29764.Form'></th>
                        <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id='59871.Katılım Tarihi'></th>
                        <th width="20"><i class="fa fa-cube"></i></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_main_result_employee.recordcount>
                        <cfoutput query="get_main_result_employee" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td>#head#</td>
                                <td>#ad# #soyad#</td>				
                                <td>#dateformat(START_DATE,dateformat_style)#</td>
                                <td width="20">
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#get_main_result_employee.survey_main_id#&result_id=#get_main_result_employee.survey_main_result_id#&is_popup=1','wide')"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="5"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'><cfelse><cf_get_lang dictionary_id='57701.Filtre ediniz'></cfif>!</td>
                        </tr>
                    </cfif>
                </tbody>
        </cf_flat_list>
        <cfset url_str = "">
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.emp_id)>
            <cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
        </cfif>
        <cfif len(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif isdefined('attributes.form_submitted')>
            <cfset url_str = "#url_str#&survey_id=#attributes.survey_id#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="settings.list_detail_survey_employee#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>