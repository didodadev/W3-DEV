<cfinclude template="../query/get_customer_type.cfm">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
    	<td height="35" class="headbold"><cf_get_lang dictionary_id='33173.Müşteri Tipleri'></td>
	</tr>	
</table>

<table cellspacing="1" cellpadding="2" align="center" width="98%" border="0" class="color-border">
	<tr height="22" class="color-header">
		<td class="form-title" width="178"><cf_get_lang dictionary_id='32539.Tipler'></td>
	</tr>
  <cfif get_customer_type.recordcount>
	<cfoutput query="get_customer_type">
	<tr height="20"  onClick="this.bgColor='CCCCCC'" class="color-row">
		<td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#customer_type_id#,'#customer_type#')">#customer_type#</a></td>
	</tr>
	</cfoutput>
  <cfelse>
  	<tr class="color-row">
		<td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
	</tr>
</cfif>
</table>

<script type="text/javascript">
	function gonder(customer_type_id,customer_type)
	{
	var kontrol =0;
	uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++)
	{
		if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==customer_type_id)
			kontrol=1;
	}
	
	if(kontrol==0)
	{
		<cfif isDefined("attributes.field_name")>
			x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = customer_type_id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = customer_type;
		</cfif>
		}
	}
	
</script>
