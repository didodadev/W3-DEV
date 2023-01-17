<cfif attributes.type eq 0>
	<cfset temp_title = "#getLang('settings',2857)#">
<cfelseif attributes.type eq 1>
	<cfset temp_title = "#getLang('settings',2858)#">
<cfelseif attributes.type eq 2>
	<cfset temp_title = "#getLang('settings',2859)#">
</cfif>
<cf_box title="#temp_title#">
    <cfquery name="get_types" datasource="#dsn#">
        SELECT
        <cfif attributes.type eq 0>
            POSITION_CAT_ID AS TYPE_ID,
            #DSN#.#dsn#.Get_Dynamic_Language(POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,SETUP_POSITION_CAT.POSITION_CAT) AS TYPE_NAME
        <cfelseif attributes.type eq 1>
            COMPANYCAT_ID AS TYPE_ID,
            #DSN#.#dsn#.Get_Dynamic_Language(COMPANYCAT_ID,'#session.ep.language#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANY_CAT.COMPANYCAT) AS TYPE_NAME
        <cfelseif attributes.type eq 2>
            CONSCAT_ID AS TYPE_ID,
            #DSN#.#dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session.ep.language#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSUMER_CAT.CONSCAT) AS TYPE_NAME
        </cfif>
        FROM
        <cfif attributes.type eq 0>
            SETUP_POSITION_CAT
        <cfelseif attributes.type eq 1>
            COMPANY_CAT
        <cfelseif attributes.type eq 2>
            CONSUMER_CAT
        </cfif>
        ORDER BY
        <cfif attributes.type eq 0>
            POSITION_CAT
        <cfelseif attributes.type eq 1>
            COMPANYCAT
        <cfelseif attributes.type eq 2>
            CONSCAT
        </cfif>
    </cfquery>
    <cfquery name="GET_OLDS" datasource="#DSN#">
        SELECT 
    	    ROW_ID, 
            TYPE_ID, 
            TYPE, 
            MESSAGE 
        FROM 
	        SETUP_STOP_LOGINS 
        WHERE 
        	TYPE = #attributes.type#
    </cfquery>
    <cfif get_olds.recordcount>
        <cfset old_list = valuelist(get_olds.type_id)>
        <cfset old_message = get_olds.message>
    <cfelse>
        <cfset old_list = ''>
        <cfset old_message = ''>
    </cfif>
    <cfset attributes.mode = 4>

	<cfform name="add_stop_login" id="add_stop_login" action="#request.self#?fuseaction=settings.emptypopup_stop_logins">
		<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>">
        <cf_area>	
            <table>
            <tr>
                <td><input type="checkbox" name="all_power_user" id="all_power_user" value="1" onclick="hepsi_view();"><cf_get_lang no ='705.Hepsini Seç'></td>
            </tr>
            <span class="table_warning">* <cf_get_lang no='2863.Seçili Olan Kategoriye Dahil Kişiler / Üyeler Sisteme Giriş Yapamazlar'>!</span>
            <cfoutput query="get_types">
                <cfif currentrow eq 1 or currentrow mod attributes.mode eq 1><tr></cfif>
            		<input type="hidden" name="number" id="number" value="#get_types.recordcount#" />
                    <td><input type="checkbox" name="type_id" id="type_id" value="#type_id#" <cfif listlen(old_list) and listfindnocase(old_list,type_id)>checked</cfif>>#type_name#</td>
                <cfif currentrow eq recordcount or currentrow mod attributes.mode eq 0></tr></cfif>
                </cfoutput>
                <tr>
                    <td colspan="<cfoutput>#attributes.mode#</cfoutput>" height="30">
                        <table>
                            <tr>
                                <td valign="top"><cf_get_lang_main no='131.Mesaj'></td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea style="width:380px; height:150px;" name="message" id="message"><cfoutput>#old_message#</cfoutput></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </cf_area>
        <cf_form_box_footer>
        	<cf_workcube_buttons is_upd='1' is_delete='0'>
        </cf_form_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function hepsi_view()
	{
		if (document.getElementById("all_power_user").checked)
		{
			for(i=0; i<document.getElementById("number").value; i++)
				document.add_stop_login.type_id[i].checked = true;
		}
		else
		{
			for(i=0; i<document.getElementById("number").value; i++)
				document.add_stop_login.type_id[i].checked = false;
		}
	}
</script>
