<cfinclude template="../query/get_product_ws_detail.cfm">
<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" width="235" style="cursor:pointer;" onclick="gizle_goster(urun);"><cf_get_lang dictionary_id='36632.İstasyon-Kapasite/Saat'></td>
           <td align="center" width="20"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_ws_product&is_add_workstation=1&stock_id=#attributes.stock_main_id#</cfoutput>','small');"><img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></a></td>
        </tr>
        <tr class="color-row" style="display:visible;" id="urun" height="20">
        <td colspan="2">
<cfif get_pro.recordcount>
		  <table width="100%">
			<cfoutput query="GET_PRO">
			  <tr>
				<td><a  class="tableyazi" href="#request.self#?fuseaction=prod.upd_workstation&station_id=#WS_ID#"> #STATION_NAME# </a> </td>
				<td>#CAPACITY# - #MAIN_UNIT#</td>
				<td align="center" width="15%" nowrap="nowrap">
					<a href="#request.self#?fuseaction=prod.emptypopup_add_ws_product_process&del=#WS_P_ID#"><img src="/images/delete_list.gif" border="0"></a>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ws_product&ws_id=#WS_ID#&upd=#WS_P_ID#','small');" class="tableyazi"><img src="/images/update_list.gif" border="0"></a>
				</td>
			  </tr>
			</cfoutput>
		  </table>
<cfelse>
          <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
</cfif>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<!--- products --->

