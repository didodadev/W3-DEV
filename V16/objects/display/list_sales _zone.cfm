<cfquery name="GET_SALES_ZONE" datasource="#dsn#">
	SELECT ZONE_ID,ZONE_NAME FROM ZONE ORDER BY ZONE_NAME
</cfquery>
<script type="text/javascript">
	function gonder(zone_id,zone_name)
	{
	var kontrol =0;
	uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==zone_id){
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1)
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = zone_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = zone_name;
		</cfif>
		}
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='57767.Satış Bölgeleri'></td><td style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_add_insurance_company&is_detail=1','small');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id='44630.Ekle'>"></a></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
          <td class="form-title" width="178"><cf_get_lang dictionary_id='55188.Bölgeler'></td>
        </tr>
        <cfif get_sales_zone.recordcount>
          <cfoutput query="get_sales_zone">
            <tr height="20" onClick="this.bgColor='CCCCCC'" class="color-row">
              <td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#zone_id#,'#zone_name#')">#zone_name#</a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>

