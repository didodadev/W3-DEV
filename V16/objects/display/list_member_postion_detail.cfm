<cfquery name="get_position" datasource="#dsn#">
SELECT 
POSITION_ID, POSITION_NAME 
FROM 
SETUP_CUSTOMER_POSITION 
ORDER BY 
POSITION_NAME 
</cfquery>
<script type="text/javascript">
	function gonder(position_id,position_name)
	{
	var kontrol =0;
	uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==position_id){
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1)
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = position_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = position_name;
		</cfif>
		}
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='56599.Hobiler'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
          <td class="form-title" width="178"><cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'></td>
        </tr>
        <cfif get_position.recordcount>
          <cfoutput query="get_position">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#position_id#,'#position_name#')">#position_name#</a></td>
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

