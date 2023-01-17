
<cfparam name="attributes.emp_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfquery name="get_my_profile" datasource="#dsn#">
        SELECT RESUME_TEXT,RECORD_IP,RECORD_EMP,RECORD_DATE,UPDATE_IP,UPDATE_DATE,UPDATE_EMP FROM EMPLOYEES_APP WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.emp_id#">
    </cfquery>
    <cf_box title="#getLang('','Özgeçmiş Metni','63037')#" popup_box="1">
        <cfform name="add_cv" action="V16/objects/cfc/add_cv.cfc?method=add_cv" method="post">
            <cfinput type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#">
            <cfinput type="hidden" name="is_upd" id="is_upd" value="#iif(len(get_my_profile.resume_text),1,0)#">
            <cfmodule
            template="/fckeditor/fckeditor.cfm"
            toolbarSet="WRKContent"
            basePath="/fckeditor/"
            instanceName="resume_text"
            valign="top"
            value="#get_my_profile.resume_text#"
            width="100%"
            height="100">
            <cf_box_footer>
                <cf_record_info query_name="get_my_profile">
                <cfif len(get_my_profile.resume_text)>
                    <cfset attributes.is_upd=1>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                <cfelse>
                    <cfset attributes.is_upd=0>
                    <cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'>
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>