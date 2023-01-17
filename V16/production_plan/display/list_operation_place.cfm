<cfquery name="get_operation_place" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		OPERATION_PLACE
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top" width="135"><cfinclude template="prod_plan_definition_left_menu.cfm">
    </td>
    <td valign="top">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td height="35" class="headbold"><cf_get_lang dictionary_id='36337.İşlem Yerleri'></td>
          <td align="right" style="text-align:right;"></td>
        </tr>
      </table>
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr class="color-border">
          <td>
            <table width="100%" border="0" cellspacing="1" cellpadding="2">
              <tr class="color-header" height="22">
                <td class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='36573.İşlem Yeri'></td>
                <td class="form-title" width="10"> <a href="<cfoutput>#request.self#?fuseaction=prod.add_operation_place</cfoutput>"><img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='36336.İşlem Yeri Ekle'>" border="0"></a> </td>
              </tr>
              <cfif get_operation_place.recordcount>
                <cfoutput query="get_operation_place">
                 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#CURRENTROW#</td>
                    <td><a href="#request.self#?fuseaction=prod.upd_operation_place&operation_place_id=#get_operation_place.OPERATION_PLACE_ID#" class="TABLEYAZI">#OPERATION_PLACE#</a></td>
                    <td><a href="#request.self#?fuseaction=prod.upd_operation_place&operation_place_id=#get_operation_place.operation_place_Id#"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57692.İşlem Yeri Güncelle'>" border="0"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>

