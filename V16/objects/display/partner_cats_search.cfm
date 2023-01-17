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
<script type="text/javascript">
	function add_pos(id,name)
	{
		var x = opener.<cfoutput>#attributes.field_id#</cfoutput>.value;
		var y = opener.<cfoutput>#attributes.field_name#</cfoutput>.value;
		var z = opener.<cfoutput>#attributes.click_count#</cfoutput>.value;
		
		if (z==0)
		{	
			x = "";
			y = "";
			opener.<cfoutput>#attributes.click_count#</cfoutput>.value = 1;
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value = x + id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value = y + name;
		}
		else
		{	
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value = x + ',' + id;
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value = y + ',' + name;
		}
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='59290.Üye Kategorileri'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
       
        <cfif get_partner_positions.recordcount>
          <cfoutput query="get_partner_positions">
            <tr id=#currentrow# height="20" class="color-row" onClick="this.bgColor='CCCCCC'">
              <td width="178"><a href="javascript://" class="tableyazi"  onClick="add_pos(#companycat_id#,'#companycat#')">#companycat#</a></td>
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


