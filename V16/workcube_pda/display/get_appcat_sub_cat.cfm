<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.appcat_id')>
    <cfif len(attributes.appcat_id)>
        <cfquery name="get_service_sub_appcat" datasource="#dsn3#">
             SELECT SERVICECAT_SUB_ID,SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #attributes.appcat_id#
        </cfquery>
        <select name="appcat_sub_id" id="appcat_sub_id" style="width:150px;" onchange="showAltTreeKategori();">
            <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
            <cfoutput query="get_service_sub_appcat">
                <option value="#servicecat_sub_id#">#servicecat_sub#</option>
            </cfoutput>
        </select>
    <cfelse>
    	<select name="appcat_sub_id" id="appcat_sub_id" style="width:150px;">
        	<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
        </select>
    </cfif>
    <script>
    	showAltTreeKategori();
    </script>
<cfelse>
   <cfif len(attributes.appcat_sub_id)>
        <cfquery name="get_service_sub_status_appcat" datasource="#dsn3#">
             SELECT SERVICECAT_SUB_STATUS_ID,SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_ID = #attributes.appcat_sub_id#
        </cfquery>
        <select name="appcat_sub_status_id" id="appcat_sub_status_id" style="width:150px;">
        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
		<cfoutput query="get_service_sub_status_appcat">
            <option value="#servicecat_sub_status_id#">#servicecat_sub_status#</option>
        </cfoutput>
        </select>
    <cfelse>
    	<select name="appcat_sub_status_id" id="appcat_sub_status_id" style="width:150px;">
        	<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
        </select>
    </cfif>
</cfif>
