<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.company_partner_name = trim(attributes.company_partner_name);
	attributes.company_partner_surname = trim(attributes.company_partner_surname);
	attributes.tax_num = trim(attributes.tax_num);
	attributes.tel = trim(attributes.tel);
	attributes.tc_identity_no = trim(attributes.tc_identity_no);
	attributes.il = trim(attributes.il);
</cfscript>

<cfif len(attributes.il)>		
	<cfquery name="GET_CITY_TRANSFER" datasource="#DSN#">
		SELECT 
			CITY_ID
		FROM 
			SETUP_CITY
		WHERE 
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CITY_NAME, 'Ğ', 'G'), 'i', 'I'), 'Ş', 'S'), 'Ü', 'U'), 'Ç', 'C'), 'Ö', 'O') LIKE '%#attributes.il#%'
	</cfquery>
</cfif>
<cfquery name="GET_COMP_KONTROL" datasource="#DSN#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.TC_IDENTITY,
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_STATE,
		COMPANY.CITY,
		COMPANY.SEMT,
		COMPANY_CAT.COMPANYCAT_TYPE,
		COMPANY_CAT.COMPANYCAT
	FROM 
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_CAT
	WHERE 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		(
			1=0
			<cfif len(attributes.fullname)>OR COMPANY.FULLNAME LIKE '#attributes.fullname#%'</cfif>
			<cfif len(attributes.company_partner_name) gt 1 and len(attributes.company_partner_surname) gt 1>OR (COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '#attributes.company_partner_name#%' AND COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '#attributes.company_partner_surname#%')</cfif>
			<cfif len(attributes.tel)>OR COMPANY.COMPANY_TEL1 = '#attributes.tel#'</cfif>
			<cfif len(attributes.tax_num)>OR (COMPANY_PARTNER.TC_IDENTITY = '#attributes.tax_num#' OR COMPANY.TAXNO = '#attributes.tax_num#')</cfif>
			<cfif len(attributes.tc_identity_no)>OR (COMPANY_PARTNER.TC_IDENTITY = '#attributes.tc_identity_no#' OR COMPANY.TAXNO = '#attributes.tc_identity_no#')</cfif>
		)
	<cfif isdefined('get_city_transfer') and get_city_transfer.recordcount>
		AND COMPANY.CITY IN(#valuelist(get_city_transfer.city_id)#)
	</cfif>
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<cfif get_comp_kontrol.recordcount>
	<cfquery name="GET_COMPANY_BRANCH_ALL" datasource="#DSN#">
		SELECT
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			OUR_COMPANY.COMPANY_NAME,
			OUR_COMPANY.NICK_NAME,
			COMPANY_BRANCH_RELATED.MUSTERIDURUM
		FROM
			OUR_COMPANY,
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			COMPANY_BRANCH_RELATED.COMPANY_ID IN (#valuelist(get_comp_kontrol.company_id,',')#)
	</cfquery>
	<cfquery name="get_city_all" datasource="#dsn#">
		SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#valuelist(get_comp_kontrol.city,',')#)
	</cfquery>
</cfif>

<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td height="35" class="headbold"><cf_get_lang no='642.Benzer Kriterlerde Kayıtlar'></td>
  	</tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
	<tr height="22" class="color-header">
		<td class="form-title" width="25"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" nowrap><cf_get_lang no='668.Hedef Kodu'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='338.İşyeri Adı'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='74.Kategori'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='158.Ad Soyad'></td>
		<td class="form-title"><cf_get_lang_main no='340.Vergi No'></td>
		<td class="form-title"><cf_get_lang_main no='613.TC Kimlik No'></td>
		<td class="form-title"><cf_get_lang_main no='720.Semt'></td>
		<td class="form-title"><cf_get_lang_main no='1196.İl'></td>
		<td class="form-title" nowrap><cf_get_lang_main no='87.Telefon'></td>
		<td class="form-title"><cf_get_lang no='472.Grupla Çalistigi Şubeler'></td>
		<td></td>
	</tr>
	<form name="search_" method="post" action="">
		<cfif get_comp_kontrol.recordcount>
		  <cfoutput query="get_comp_kontrol">
			<cfquery  name="GET_COMPANY_BRANCH" dbtype="query">
				SELECT * FROM GET_COMPANY_BRANCH_ALL WHERE COMPANY_ID = #get_comp_kontrol.company_id#
			</cfquery>
			<cfquery name="get_city" dbtype="query">
				SELECT * FROM get_city_all WHERE CITY_ID = #get_comp_kontrol.city#
			</cfquery>
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#currentrow#</td>
				<td>#company_id#</td>
				<td nowrap><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></td>
				<td nowrap>#companycat#</td>
				<td nowrap>
					<cfif attributes.company_partner_name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
					<cfif attributes.company_partner_surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif>
				</td>
				<td><cfif attributes.tax_num eq trim(taxno)><font color="##990000">#taxno#</font><cfelse>#taxno#</cfif></td>
				<td><cfif attributes.tc_identity_no eq trim(tc_identity_no)><font color="##990000">#get_comp_kontrol.tc_identity#</font><cfelse>#get_comp_kontrol.tc_identity#</cfif></td>
				<td>#semt#</td>
				<td>#get_city.city_name#</td>
				<td nowrap><cfif attributes.tel eq trim(company_tel1)><font color="##990000">#company_telcode# #company_tel1#</font><cfelse>#company_telcode# #company_tel1#</cfif></td>
				<td><cfloop query="get_company_branch">#nick_name# / #branch_name#<br/></cfloop></td>
				<td style="text-align:right;">
					<cfif not isdefined("attributes.is_transfer")>
						<input type="submit" name="Devam" value=" Şubeyi İlişkilendir  " style="width=120;" onClick="control(2,#company_id#,#companycat_type#);">
					</cfif>
				</td>
			</tr>
		  </cfoutput>
		<cfelse>
			<tr class="color-row">
				<td height="20" colspan="12"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
			</tr>
		</cfif>
	</form>
</table>
<script type="text/javascript">
function control(id,value,compcat_id)
{
	<cfoutput>document.search_.action='#request.self#?fuseaction=crm.popup_add_company_workbranch&cpid='+value+'&transfer_branch_id=#attributes.transfer_branch_id#&kayitno=#attributes.kayitno#';</cfoutput>
	document.search_.submit();
	//opener.location.href='<cfoutput>#request.self#?fuseaction=crm.detail_company&cpid='+value+'&is_branch=1</cfoutput>';
}
</script>
