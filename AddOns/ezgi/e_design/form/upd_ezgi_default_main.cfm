<cfquery name="get_upd" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW_SETUP WHERE MAIN_ROW_SETUP_ID = #attributes.main_id#
</cfquery>
<cfquery name="get_delete_control" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_MAIN_ROW WHERE MAIN_ROW_SETUP_ID = #attributes.main_id#
</cfquery>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2834.Default Modül Güncelle'></td>
        <td class="dphb">
        	<cfoutput>
				<a href="#request.self#?fuseaction=prod.add_ezgi_default_main">
               		<img src="/images/plus_list.gif" style="text-align:center" title="<cf_get_lang_main no='2833.Default Modül Ekle'>">
            	</a>
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>	
            	<cfform name="upd_default_main" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_default_main">
                	<cfinput type="hidden" name="main_id" value="#attributes.main_id#">
                	 <table>
                     	<tr height="25px"  id="design_name_">
                            <td width="100px" valign="top" style="font-weight:bold"><cf_get_lang_main no='81.Aktif'></td>
                            <td width="290px" valign="top">
                                <input type="checkbox" id="status" name="status" value="1"<cfif get_upd.STATUS eq 1>checked</cfif>>
                            </td>
                      	</tr>
                     	<tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',429)# #getLang('objects',256)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_code" id="default_code"  value="#get_upd.MAIN_ROW_SETUP_CODE#" maxlength="20" style="width:50px;" >
                            </td>
                      	</tr>
                        <tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',429)# #getLang('main',485)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_type" id="default_type" value="#get_upd.MAIN_ROW_SETUP_NAME#" maxlength="50" style="width:240px;" >
                                <cf_language_info 
                                    table_name="EZGI_DESIGN_MAIN_ROW_SETUP" 
                                    column_name="MAIN_ROW_SETUP_NAME" 
                                    column_id_value="#attributes.main_id#" 
                                    maxlength="500" 
                                    datasource="#dsn3#" 
                                    column_id="MAIN_ROW_SETUP_ID" 
                                    control_type="0">
                            </td>
                      	</tr>
                    </table>
                    <cf_form_box_footer>
                    	<cfif not get_delete_control.recordcount>
                            <cf_workcube_buttons 
                                is_upd='1' 
                                delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_default_main&main_id=#attributes.main_id#'
                                add_function='kontrol()'>
                     	<cfelse>
                            <cf_workcube_buttons 
                                is_upd='1' 
                                is_delete = '0' 
                                add_function='kontrol()'>
                        </cfif>
                        <cf_record_info 
                            query_name="get_upd"
                            record_emp="RECORD_EMP" 
                            record_date="record_date"
                            update_emp="UPDATE_EMP"
                            update_date="update_date">
                    </cf_form_box_footer>
          		</cfform>
          	</cf_form_box>
      	</td>
  	</tr>
</table>
<script type="text/javascript">
	document.getElementById('default_type').focus();
	function kontrol()
	{
		if(document.getElementById("default_type").value == "")
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> <cf_get_lang_main no='2913.Modül Adı'> !");
			document.getElementById('default_type').focus();
			return false;
		}
	}
</script>