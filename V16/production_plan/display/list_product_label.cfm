<cfquery name="GET_LABELS" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRODUCT_LABEL 
	WHERE 
		STOCK_ID= #URL.STOCK_ID#
</cfquery>

<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" width="250" style="cursor:pointer;" onclick="gizle_goster(pro_label);"><cf_get_lang dictionary_id='36610.Etiket Bilgisi'></td>
          <td align="center" width="10"> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_form_add_pro_label&stock_id=#attributes.STOCK_ID#</cfoutput>','small');"> <img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"> </a> </td>
        </tr>
        <tr class="color-row" style="display:visible;" id="pro_label" height="20">
          <td colspan="2">
            <cfif GET_LABELS.recordcount>
              <table width="100%">
                <cfoutput query="GET_LABELS">
                  <tr>
                    <td> #GET_LABELS.PRODUCT_LABEL_BARCOD# </td>
                    <td align="right" style="text-align:right;"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_pro_label&stock_id=#attributes.STOCK_ID#&label_id=#PRODUCT_LABEL_ID#','small');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='36612.Etiket Bilgisi Güncelle'>" border="0"></a> </td>
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

