<cfsetting showdebugoutput="no"><!--- ajax sayfa oldg. için --->
<cfparam name="attributes.survey_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default=""> 
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.keyword" default=""> 
<div id="related_participants_"></div><!--- AjaxFormSubmit icin kullaniliyor --->
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.emptypopupajax_form_participants%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_survey" datasource="#dsn#">
	SELECT 
		COUNT(SURVEY_MAIN_RESULT_ID) SURVEY_MAIN_RESULT_ID,
		PROCESS_ROW_ID,
		SURVEY_MAIN_HEAD,
		EMP_ID 
	FROM
		(
			SELECT 
				SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID,
				SURVEY_MAIN.PROCESS_ROW_ID ,
				SURVEY_MAIN.SURVEY_MAIN_HEAD ,
				SURVEY_MAIN.EMP_ID
			FROM
				SURVEY_MAIN,
				SURVEY_MAIN_RESULT 
			WHERE 
				SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = SURVEY_MAIN.SURVEY_MAIN_ID  
				<cfif isdefined('attributes.survey_id') and len(attributes.survey_id)>
					AND SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
				</cfif>
				<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
					AND SURVEY_MAIN_RESULT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif> 
				<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
					AND SURVEY_MAIN_RESULT.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
				</cfif>
                <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					AND SURVEY_MAIN_RESULT.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
					AND SURVEY_MAIN_RESULT.EMP_ID LIKE '%#attributes.employee_id#%'
				</cfif>
			GROUP BY 
				SURVEY_MAIN_RESULT_ID,
				SURVEY_MAIN.PROCESS_ROW_ID,
				SURVEY_MAIN.SURVEY_MAIN_HEAD,
				SURVEY_MAIN.EMP_ID
	
			)TT
	GROUP BY 
		PROCESS_ROW_ID,
		SURVEY_MAIN_HEAD,
		EMP_ID
</cfquery>
<cfif isdefined('get_survey.process_row_id') and len(get_survey.process_row_id)>
	<cfquery name="get_process_row" datasource="#dsn#">
		SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey.process_row_id#">
	</cfquery>
</cfif>
<cfform name="form_participants" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopupajax_form_participants">
	<cf_medium_list_search>
    	<cf_medium_list_search_area>
            <table>
                <tr> 
                    <td><cf_get_lang dictionary_id='29764.Form'></td>
                    <td nowrap="nowrap"><input type="hidden" name="survey_id_" id="survey_id_" value="" />
                        <input type="text" name="survey" id="survey" value=""  style="width:80px;">
                        <a href="javascript://" ><img src="/images/plus_thin.gif" alt="Form" border="0" align="absmiddle"></a><!---  onClick="windowopen();"--->
                    </td>
                    <td><cf_get_lang dictionary_id='57658.Üye'></td>
                    <td nowrap="nowrap"><cfset str_linke_ait="field_partner=form_participants.partner_id&field_consumer=form_participants.consumer_id&field_comp_id=form_participants.company_id&field_comp_name=form_participants.company_name&field_name=form_participants.partner_name">
                        <input type="text" name="company_name" id="company_name" <cfif len(attributes.company_name)>value="<cfoutput>#URLDecode(attributes.company_name)#</cfoutput>"</cfif> style="width:80px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID','consumer_id,company_id,partner_id','','3','250');">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=form_participants.partner_name&field_consumer=form_participants.consumer_id&field_partner=form_participants.partner_id&field_company_name=form_participants.company_name&field_comp_name=form_participants.company_name&field_comp_id=form_participants.company_id&select_list=2,3&keyword='+encodeURIComponent(document.form_participants.company_name.value),'list');"><img src="/images/plus_thin.gif" alt="Üye" border="0" align="absmiddle"></a>
                    </td>
                    <td><cf_get_lang dictionary_id='29804.Uygulayan'></td>
                    <td><input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.consumer_id)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                        <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company_id)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                        <input type="hidden" name="partner_id" id="partner_id" <cfif len(attributes.partner_id)> value="<cfoutput>#attributes.partner_id#</cfoutput>"</cfif>>
                        <input type="text" name="partner_name" id="partner_name"  style="width:80px;" <cfif len(attributes.partner_id) or len(attributes.consumer_id)>value="<cfoutput>#URLDecode(attributes.partner_name)#</cfoutput>"</cfif>>
                    </td>
                    <td><cf_get_lang dictionary_id='57576.Çalışan'></td>
                    <td nowrap="nowrap"><input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                        <input type="text" name="employee" id="employee" value="<cfif len(attributes.employee)><cfoutput>#URLDecode(attributes.employee)#</cfoutput></cfif>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" style="width:80px;">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_id=form_participants.employee_id&field_name=form_participants.employee</cfoutput>','list');"><img src="../../images/plus_thin.gif" align="absmiddle" border="0" alt="Çalışan"></a>
                    </td>
          
                    <td><cf_get_lang dictionary_id='59088.Tip'></td>
                    <td><select name="type" id="type" style="width:80px;">
                            <option value=""><cf_get_lang dictionary_id='59088.Tip'></option>
                        </select>
                    </td>
                    <td><cf_get_lang dictionary_id='57482.Aşama'></td>
                    <td><select name="process_row_id" id="process_row_id" style="width:80px;">
                            <option value="" selected><cf_get_lang dictionary_id='57482.Aşama'></option>
                            <cfoutput query="get_process_stage">
                                <option value="#process_row_id#" <cfif get_survey.process_row_id eq process_row_id>selected</cfif>>#stage#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td><cf_get_lang dictionary_id='58680.İlişki'></td>
                    <td><select name="related" id="related" style="width:80px;">
                            <option value="" selected></option>
                        </select>
                    </td>
                    <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                    <td nowrap="nowrap"><input type="text" name="keyword" id="keyword" value="" style="width:80px;">
                        <cf_wrk_search_button search_function='kontrol_partc()'>
                    </td>
                </tr>
            </table>
        </cf_medium_list_search_area>
    </cf_medium_list_search>    
	<cf_medium_list>
    	<thead>
            <tr> 
                <th><cf_get_lang dictionary_id='58820.Başlık'></th>
                <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                <th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
                <th><cf_get_lang dictionary_id='60122.Katılımcı Sayısı'></th>
                <th><cf_get_lang dictionary_id='58467.Başlama'></th>
                <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
            </tr>
        </thead>
        <tbody>
		<cfif get_survey.recordcount>
			<cfoutput query="get_survey">
				<tr>
					<td>#get_survey.survey_main_head#</td>
					<td>#get_process_row.stage#</td>
					<td>#get_emp_info(get_survey.emp_id,1,0)#</td>
					<td>#SURVEY_MAIN_RESULT_ID#</td>
					<td></td>
					<td></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
        </tbody>
	</cf_medium_list>
</cfform>
<script type="text/javascript">
	function kontrol_partc()
	{
		AjaxFormSubmit('form_participants','related_participants_',1,'','','<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopupajax_form_participants&survey_id=</cfoutput>'+document.getElementById('survey_id').value,'div_related_participants');
		return false;
	}
</script>
