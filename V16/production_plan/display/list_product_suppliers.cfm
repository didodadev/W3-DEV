<cfinclude template="../query/get_product_suppliers.cfm">
<table cellspacing="0" cellpadding="0" width="96%" border="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" width="250" style="cursor:pointer;" onclick="gizle_goster(supply);"><cf_get_lang dictionary_id='29533.Tedarikçi'></td>
          <td align="center" width="30"> </td>
        </tr>
        <tr class="color-row" style="display:visible;" id="supply" height="20">
          <td colspan="2">
            <cfif get_suppliers.recordcount>
              <table width="100%">
                <cfoutput query="get_suppliers">
                  <tr>
                    <td> <a  class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','list');"> #NICKNAME# </a> </td>
                    <td></td>
                    <td align="center" width="10%"></td>
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

