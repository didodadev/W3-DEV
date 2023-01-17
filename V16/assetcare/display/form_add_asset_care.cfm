<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <cfform  method="post" action="#request.self#?fuseaction=settings.popup_list_lang_settings">
    <tr>
      <td clasS="headbold"><cf_get_lang no='605.Fiziki Varlık Bakım'></td>
      <td style="text-align:right;">
        <table>
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="" maxlength="255"></td>
            <td><cf_wrk_search_button></td>
          </tr>
        </table>
      </td>
    </tr>
  </cfform>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td>
      <table cellpadding="2" cellspacing="1" border="0" width="100%">
        <tr clasS="color-header" height="22">
          <td class="form-title" width="125"><cf_get_lang_main no='217.Açıklama'></td>
          <td class="form-title" width="60"><cf_get_lang_main no='330.Tarih'></td>
		  <td class="form-title" width="60"><cf_get_lang no='42.Bakım Tipi'></td>
		  <td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_form_add_asset_care&asset_id=#url.assetp_id#</cfoutput>','list');"><img src="/images/calculate.gif" border="0" alt="<cf_get_lang no='14.Bakım Bilgisi'>" title="<cf_get_lang no='14.Bakım Bilgisi'>"></a></td>
        </tr>
            <tr class="color-row" height="20">
              <td>--</td>
              <td>--</td>
              <td>--</td>
            </tr>
      </table>
    </td>
  </tr>
</table>

