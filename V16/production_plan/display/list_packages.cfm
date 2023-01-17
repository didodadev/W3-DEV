<cfquery name="GET_PACKAGES" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRODUCT_PACKAGE 
	WHERE 
		STOCK_ID= #URL.STOCK_ID#
</cfquery>
<table cellspacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" width="250" style="cursor:pointer;" onclick="gizle_goster(package);"><cf_get_lang dictionary_id='36590.Paket Bilgisi'></td>
          <td align="center" width="10"> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_form_add_pro_package&stock_id=#attributes.STOCK_ID#</cfoutput>','small');"> <img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"> </a> </td>
        </tr>
        <tr class="color-row" style="display:visible;" id="package" height="20">
          <td colspan="2">
            <cfif GET_PACKAGES.recordcount>
              <table width="100%">
                <cfoutput query="GET_PACKAGES">
                  <tr>
                    <td>
                      <cfquery name="GET_CAT" datasource="#DSN#">
						  SELECT 
							  PACKAGE_TYPE 
						  FROM 
							  SETUP_PACKAGE_TYPE 
						  WHERE 
							  PACKAGE_TYPE_ID = #PACKAGE_TYPE_ID#
                      </cfquery>
                      #GET_CAT.PACKAGE_TYPE# </td>
                    <td align="right" style="text-align:right;"> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_upd_pro_package&stock_id=#attributes.STOCK_ID#&package_id=#PACKAGE_ID#</cfoutput>','small');"> <img src="/images/update_list.gif" border="0"> </a> </td>
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
	        
