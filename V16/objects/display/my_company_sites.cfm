<cfquery name="company_domain" datasource="#DSN#">
		SELECT 
			SITE_DOMAIN
		FROM 
			MAIN_MENU_SETTINGS
		WHERE
			COMPANY_CAT_IDS LIKE '%#get_company.companycat_id#%'
</cfquery>

	<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
	  <tr class="color-header" height="22">
		<td colspan="2" class="form-title" width="235"><cf_get_lang dictionary_id='31908.Extranet ve İnternet Erişimi'></td>
	  </tr>	  
		<cfif company_domain.recordcount>
			<cfoutput query="company_domain">
				<tr class="color-row" id="b2bc">
					<td width="1%">#currentrow#</td>
					<td>#site_domain#</td>
				</tr>
			</cfoutput>
		<cfelse>	
			<tr class="color-row">
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</table>
	
