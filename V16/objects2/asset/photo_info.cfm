<cf_box title="Bu Foto Hakkında">
<table border="0">
<tr>
  <td><cfoutput>#get_asset.ASSET_DETAIL#</cfoutput></td>
</tr>
<tr>
  <td><cf_get_lang_main no='74.Kategori'>: <cfoutput>#get_asset.ASSETCAT#</cfoutput></a></td>
</tr>
<tr>
  <td><cf_get_lang no='172.Ekleme'>: <cfoutput>#dateFormat(get_asset.RECORD_DATE,"dd.mm.yyyy")#</cfoutput></a></td>
</tr>
</table>
</cf_box>

