<cfif listfirst(attributes.fuseaction,'.') eq 'myhome' and listLast(attributes.fuseaction,'.') neq 'popup_form_emp_employment_assets'>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk')>
</cfif>
<cfif not isdefined("get_id_card_cats")>
	<cfinclude template="../query/get_id_card_cats.cfm">
</cfif>
<cfif not isdefined("get_hr_detail")>
	<cfinclude template="../query/get_hr_more_detail.cfm">
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_x_employment_assets_process = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'hr.form_upd_emp',
    property_name : 'x_employment_assets_process'
)>
<cfif get_x_employment_assets_process.recordcount>
    <cfset x_employment_assets_process = get_x_employment_assets_process.property_value>
<cfelse>
    <cfset x_employment_assets_process = 0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55367.Yetkinlik Belgeleri"></cfsavecontent>
<cf_box title="#message# : #get_hr_detail.EMPLOYEE_NAME# #get_hr_detail.EMPLOYEE_SURNAME#">
<cfform action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.emptypopup_upd_emp_personal_certificate" method="post" name="employe_personal" enctype="multipart/form-data">
    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
    <input type="hidden" name="x_employment_assets_process" id="x_employment_assets_process" value="<cfoutput>#x_employment_assets_process#</cfoutput>">
    <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
        SELECT
            LICENCECAT_ID, 
            LICENCECAT, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            IS_LAST_YEAR_CONTROL
        FROM
            SETUP_DRIVERLICENCE
        ORDER BY
            IS_LAST_YEAR_CONTROL ASC,
            LICENCECAT
    </cfquery>
    <cfquery name="get_employee_belge" datasource="#DSN#">
        SELECT
            EMPLOYEE_ID, 
            LICENCECAT_ID, 
            LICENCE_START_DATE, 
            LICENCE_FINISH_DATE, 
            LICENCE_NO, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            LICENCE_FILE,
            LICENCE_STAGE
        FROM
            EMPLOYEE_DRIVERLICENCE_ROWS
        WHERE
            EMPLOYEE_ID = #attributes.employee_id#
    </cfquery>
    <cf_grid_list>
       <thead>
        <tr>
            <cfif x_employment_assets_process eq 1>
                <cfset colspan_ = 8>
            <cfelse>
                <cfset colspan_ = 7>
            </cfif>
            <th class="txtbold" colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id="55096.belge tipleri"></th>
        </tr>
        <tr>
            <th width="20">&nbsp;</th>
            <th><cf_get_lang dictionary_id="57630.tip"></th>
            <cfif x_employment_assets_process eq 1>
                <th style="min-width:75px;"><cf_get_lang dictionary_id="58859.Süreç"></th>
            </cfif>
            <th><cf_get_lang dictionary_id="57880.belge no"></th>	
            <th><cf_get_lang dictionary_id="55659.Veriliş tarih"></th>
            <th><cf_get_lang dictionary_id="57700.bitis tarih"></th>
            <th><cf_get_lang dictionary_id="58578.belge türü"></th>
            <th><a href="javascript://"><i class="fa fa-file-text" border="0" title="Ekli Belge"></i></a></th>
        </tr>
       </thead>
       <tbody>
        <cfoutput query="GET_DRIVER_LIS">
            <cfset cat_ = LICENCECAT_ID>
            <cfif get_employee_belge.recordcount>
                <cfquery name="get_" dbtype="query">
                    SELECT * FROM get_employee_belge WHERE LICENCECAT_ID = #cat_#
                </cfquery>
            <cfelse>
                <cfset get_.recordcount = 0>
            </cfif>
            <tr>
                <td class="text-center" width="20"><div class="form-group"><input type="checkbox" value="1" name="licence_type_#LICENCECAT_ID#" id="licence_type_#LICENCECAT_ID#" <cfif get_.recordcount>checked</cfif>></div></td>
                <td><div class="form-group">#LICENCECAT#</div></td>
                <cfif get_.recordcount>
                    <cfset licence_no_ = get_.LICENCE_NO>
                    <cfset start_ = dateformat(get_.LICENCE_START_DATE,dateformat_style)>
                    <cfset finish_ = dateformat(get_.LICENCE_FINISH_DATE,dateformat_style)>
                    <cfset licence_stage_ = get_.LICENCE_STAGE>
                <cfelse>
                    <cfset licence_no_ = ''>
                    <cfset start_ = ''>
                    <cfset finish_ = ''>
                    <cfset licence_stage_ = ''>
                </cfif>
                <cfif x_employment_assets_process eq 1>
                    <cfset line_number_ = -1>
                    <cfif licence_stage_ neq ''>
                        <cfquery name="GET_PROCESS_LINE_NUMBER" datasource="#dsn#">
                            SELECT
                                LINE_NUMBER
                            FROM
                                PROCESS_TYPE_ROWS
                            WHERE
                                PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#licence_stage_#">
                        </cfquery>
                        <cfif GET_PROCESS_LINE_NUMBER.recordCount>
                            <cfset line_number_ = GET_PROCESS_LINE_NUMBER.LINE_NUMBER>
                        </cfif>
                    </cfif>
                    <td>
                       <div class="form-group"> <cfinput type="hidden" name="old_process_line" value="#line_number_#">
                        <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0' select_value='#licence_stage_#'></div>
                    </td>
                </cfif>
                <td><div class="form-group"> <cfinput type="text" name="licence_no_#LICENCECAT_ID#" maxlength="40" value="#licence_no_#"></div></td>
                <td>
                   <div class="form-group"><div class="input-group"><cfsavecontent variable="message"><cf_get_lang dictionary_id="55100.Geçerli Tarih Girmelisiniz"></cfsavecontent>
                    <cfinput type="text"name="driver_licence_start_date_#LICENCECAT_ID#" value="#start_#" validate="#validate_style#" maxlength="10" message="#message#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="driver_licence_start_date_#LICENCECAT_ID#"></span></div></div>
                </td>
                <td>
                    <div class="form-group"><div class="input-group"><cfinput type="text" name="driver_licence_finish_date_#LICENCECAT_ID#" value="#finish_#" validate="#validate_style#" maxlength="10" message="#message#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="driver_licence_finish_date_#LICENCECAT_ID#"></span></div></div>
                </td>
                <td>
                    <div class="form-group"><input type="file" id="licence_file_#cat_#" name="licence_file_#cat_#"></div>                 
                </td>
                <td class="text-center">
                    <cfif get_.recordcount and len(get_.LICENCE_FILE)>
                        <div class="form-group">  <a href="javascript://" onClick="windowopen('/documents/hr/#get_.LICENCE_FILE#','list');"><i class="fa fa-file-text" border="0" title="Ekli Belge" align="absmiddle"></i></a></div>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
        </tbody>
    </cf_grid_list>
    <cf_get_workcube_asset asset_cat_id="-8" module_id='3' action_section='EMPLOYEE_CERTIFICATE' action_id='#attributes.employee_id#'>
    <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol_()'></cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
function kontrol_()
{
	<cfoutput query="GET_DRIVER_LIS">
		if(employe_personal.licence_type_#LICENCECAT_ID#.checked==true)
			{
				if(employe_personal.driver_licence_start_date_#LICENCECAT_ID#.value=='' || employe_personal.licence_no_#LICENCECAT_ID#.value=='')
					{
					alert('<cf_get_lang dictionary_id="55665.Seçili Belge Tipleri İçin Veriliş Tarihi ve Belge No Girmelisiniz">!');
					return false;
					}
			}
	</cfoutput>
}
</script>
