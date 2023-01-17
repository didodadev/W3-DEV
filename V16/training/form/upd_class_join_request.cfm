<cfinclude template="../query/get_trainin_join_request.cfm">
<!-- onur   : eğer talep rededdildiyse, red nedenini göster. Update formunu  disable et! -->
<cfif get_trainin_join_request.valid eq 0>
<cfform name="upd_class_join_request" method="post" action="#request.self#?fuseaction=training.emptypopup_upd_class_join_request">
<input type="hidden" name="REQUEST_ID" id="REQUEST_ID" value="<cfoutput>#get_trainin_join_request.TRAINING_JOIN_REQUEST_ID#</cfoutput>">
  <table width="100%" height="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr clasS="color-border">
      <td valign="top"> 
        <table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
          <tr class="color-list"> 
            <td height="35" class="headbold">Eğitim Talebi Güncelle</td>
          </tr>
          <tr class="color-row"> 
            <td valign="top"> <table  border="0" cellspacing="2" cellpadding="2">
                <tr> 
                  <td></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td><cf_get_lang_main no='7.Eğitim'></td>
                  <td>  <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#get_trainin_join_request.CLASS_ID#</cfoutput>">
				 <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                    <cfset attributes.CLASS_ID = get_trainin_join_request.CLASS_ID> 
                    <cfinclude template="../query/get_class.cfm">
					<input type="text" name="class_name" id="class_name" value="<cfoutput>#get_class.class_name#</cfoutput>" style="width:250px;" readonly="yes">
                    <!--- class="label"  --->
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_classes&field_id=upd_class_join_request.class_id&field_name=upd_class_join_request.class_name</cfoutput>','list');"> 
                    <img src="/images/plus_thin.gif"  border="0" align="absmiddle"> 
                    </a> </td>
                </tr>
                <tr> 
                  <td></td>
                  <td colspan="2" height="35"> <cf_workcube_buttons is_upd='1' add_function='kontrol()'  delete_page_url='#request.self#?fuseaction=training.emptypopup_del_class_join_request&request_id=#get_trainin_join_request.TRAINING_JOIN_REQUEST_ID#'> 
                  </td>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<cfelse> 
<table width="100" border="1" cellspacing="0" cellpadding="0">
  <tr>
    <td>Eğitim talebiniz reddedilmiştir!</td>
  </tr>
</table>
</cfif>
<script type="text/javascript">
function kontrol(){
	if (upd_class_join_request.class_id.value == '')
		{
		alert ('Eğitim seçmelisiniz !');
		return false;
		}
	else
		return true;
}
</script>

