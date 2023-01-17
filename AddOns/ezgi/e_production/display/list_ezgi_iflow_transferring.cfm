<cfparam name="attributes.transfer_type" default="">
<cfparam name="attributes.operation_type_id" default="">
<br />
<cfquery name="get_operations" datasource="#dsn3#">
	SELECT OPERATION_TYPE_ID, OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_STATUS = 1 ORDER BY OPERATION_TYPE
</cfquery>
<cf_form_box title="#getLang('pos',12)#">
    <cfform name="search__" action="" method="post">
        <input type="hidden" name="is_submitted" id="is_submitted" value="0">
        <cf_area>
            <table>
                    <tr>
                        <td class="txtbold" nowrap="nowrap"><cf_get_lang_main no='2947.Export Edilecek Dosya Tipi'></td>
                        <td>
                            <select name="transfer_type" id="transfer_type" style="width:190px; height:20px">
                                <option value="1" <cfif attributes.transfer_type eq 1>selected</cfif>><cf_get_lang_main no='3477.PARÇA KESİM LİSTESİ'></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    	<td class="txtbold" nowrap="nowrap"><cf_get_lang_main no='3204.İlişkili Operasyonlar'></td>
                        <td>
                            <select name="operation_type_id" id="operation_type_id" style="width:190px; height:20px">
                            	<option value="" <cfif attributes.operation_type_id eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_operations">
                                	<option value="#OPERATION_TYPE_ID#" <cfif attributes.operation_type_id eq OPERATION_TYPE_ID>selected</cfif>>#OPERATION_TYPE#</option>
                                </cfoutput>
                            </select>
                            <cf_get_lang_main no='2259.Olmayanlar'>
                            <input name="reverse_answer" type="checkbox" <cfif isdefined('attributes.reverse_answer')>selected</cfif>>
                        </td>
                    </tr>
            </table>
        </cf_area>
        <cf_form_box_footer>
            <cfsavecontent variable="message"><cf_get_lang_main no='1554.Oluştur'></cfsavecontent>
            <cf_workcube_buttons is_upd=1 insert_info='#message#' is_delete=0 add_function='kontrol()'>
        </cf_form_box_footer>
    </cfform>
</cf_form_box>
<cfif isdefined('attributes.transfer_type') and attributes.transfer_type eq 1>
	<cfinclude template="/V16/add_options/ezgi/e_furniture/exp_cutting_list.cfm">	
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		search__.target='';
		search__.action='';
		return true;
	}
</script>