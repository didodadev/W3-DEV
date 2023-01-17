<cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT 
	WHERE
		COMPANYCAT_TYPE IS NOT NULL
		<cfif isdefined("attributes.customer_type") and (attributes.customer_type eq 1)>
		AND COMPANYCAT_TYPE = 0
		<cfelseif isdefined("attributes.customer_type") and (attributes.customer_type eq 2)>
		AND COMPANYCAT_TYPE = 1
		</cfif>
	ORDER BY 
		COMPANYCAT
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='39242.Müşteri Kategorileri'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">

        <cfif get_partner_positions.recordcount>
          <cfoutput query="get_partner_positions">
            <tr id=#currentrow# height="20" class="color-row" onClick="this.bgColor='CCCCCC'">
              <td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#companycat_id#,'#companycat#','#currentrow#')">#companycat#</a></td>
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


