<cfquery name="GET_SECTOR_CATS" datasource="#dsn#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM  SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  	<tr>
    	<td height="35" class="headbold"><cf_get_lang dictionary_id="33222.Sektörler"></td>
  	</tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  	<tr class="color-border">
    	<td>
      	<table cellspacing="1" cellpadding="2" width="100%" border="0">
        	<tr height="22" class="color-header">
          		<td class="form-title" width="178"><cf_get_lang dictionary_id="57579.Sektör"></td>
			</tr>
		<cfif get_sector_cats.recordcount>
		  <cfoutput query="get_sector_cats">
			<tr id=#currentrow# height="20" class="color-row" onClick="this.bgColor='CCCCCC'">
			  <td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#sector_cat_id#,'#sector_cat#','#currentrow#')">#sector_cat#</a></td>
			</tr>
		  </cfoutput>
		<cfelse>
			<tr class="color-row">
				<td height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
        </cfif>
      	</table>
    	</td>
	</tr>
</table>

<script type="text/javascript">
function gonder(sector_cat_id,sector_cat,id)
{
	var kontrol =0;
	uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++)
	{
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==sector_cat_id)
		{
			kontrol=1;
		}
	}

	if(kontrol==0){
	<cfif isDefined("attributes.field_name")>
		x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
		opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
		opener. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = sector_cat_id;
		opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = sector_cat;
	</cfif>
	}
}
</script>
