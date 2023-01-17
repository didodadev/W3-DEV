<cfquery name="get_max" datasource="#dsn3#">
	SELECT MAX(MAIN_ROW_SETUP_ID) AS MAX_ID FROM EZGI_DESIGN_MAIN_ROW_SETUP
</cfquery>
<cfif not len(get_max.max_id)>
	<cfset  sira = '001'>
<cfelseif len(get_max.max_id) eq 1>
	<cfset  sira = '00#get_max.max_id+1#'>
<cfelseif len(get_max.max_id) eq 2>
	<cfset  sira = '0#get_max.max_id+1#'>
<cfelse>
	<cfset  sira = '#get_max.max_id+1#'>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2833.Default Modül Ekle'></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>	
            	<cfform name="add_default_main" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_default_main">
                	 <table>
                     	<tr height="25px"  id="design_name_">
                            <td width="100px" valign="top" style="font-weight:bold"><cf_get_lang_main no='81.Aktif'></td>
                            <td width="250px" valign="top">
                                <cfinput type="checkbox" id="status" name="status" value="1" checked="yes">
                            </td>
                      	</tr>
                     	<tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',429)# #getLang('objects',256)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_code" id="default_code"  value="#sira#" maxlength="20" style="width:50px;" >
                            </td>
                      	</tr>
                        <tr height="25px"  id="design_name_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',429)# #getLang('main',485)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="default_type" id="default_type" value="" maxlength="50" style="width:240px;" >
                            </td>
                      	</tr>
                    </table>
                    <cf_form_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
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