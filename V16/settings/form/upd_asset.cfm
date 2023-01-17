      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td class="headbold"><cf_get_lang no='590.Logo Güncelle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2"> <br/>
                  <table>
                    <form name="upd_asset" id="upd_asset"	method="POST" enctype="multipart/form-data" action="<cfoutput>#request.self#?fuseaction=settings.emptypopup_proupd_asset</cfoutput>"  >
                      <cfquery name="GET_ASSET" datasource="#dsn#">
                      SELECT ASSET_NAME,ASSET_FILE_NAME,ASSET_DETAIL FROM OUR_COMPANY_ASSET
                      WHERE ASSET_ID=#URL.ID2#
                      </cfquery>
                      <input type="Hidden" value="<cfoutput>#URL.ID2#</cfoutput>" name="asset_id" id="asset_id">
                      <cfset #asset_id#=#URL.ID2#>
                      <cfoutput  query="get_asset">
                        <tr>
                          <td><cf_get_lang no='287.Logo Adı'></td>
                          <td>
                            <input type="text" value="#asset_name#" name="asset_name" id="asset_name" style="width:250px;">
                          </td>
                        </tr>
                        <tr>
                          <td><cf_get_lang_main no='1688.Doküman'></td>
                          <td>
                            <input type="FILE" style="width:250px;" name="asset" id="asset">
                          </td>
                        </tr>
                        <tr>
                          <td valign="top"><cf_get_lang no='289.Keywords'></td>
                          <td>
                            <textarea name="ASSET_DETAIL" id="ASSET_DETAIL" style="width:250px;height:100px;">#asset_detail#</textarea>
                          </td>
                        </tr>
                      </cfoutput>
                      <tr>
                        <td align="right" height="35" class="txt" colspan="2">
						<cf_workcube_buttons is_upd='0' add_function='control()'>
                        </td>
                      </tr>
                    </form>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

<script type="text/javascript">
 function control()
 {
 	if(document.upd_asset.asset.value=='')
	{
	   alert("Döküman adı giriniz ");
	   return(false);
	}
	return(true);
 }
</script>
  

