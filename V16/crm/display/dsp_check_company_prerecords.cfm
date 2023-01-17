<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.company_partner_name = trim(attributes.company_partner_name);
	attributes.company_partner_surname = trim(attributes.company_partner_surname);
	attributes.tax_num = trim(attributes.tax_num);
	attributes.tel1 = trim(attributes.tel1);
	attributes.telcod = trim(attributes.telcod);
</cfscript>
<cfquery name="GET_COMP_KONTROL" datasource="#dsn#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_STATE,
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
			<cfif len(attributes.tel1)>OR COMPANY.COMPANY_TEL1 = '#attributes.tel1#'</cfif>
			<cfif len(attributes.tax_num)>OR (COMPANY_PARTNER.TC_IDENTITY = '#attributes.tax_num#' OR COMPANY.TAXNO = '#attributes.tax_num#')</cfif>
		)
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
</cfif>
<cf_box title="#getLang('','Benzer Kriterlerde Kayıtlar',52089)#"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang_main no='75.No'></th>
				<th nowrap><cf_get_lang_main no='338.İşyeri Adı'></th>
				<th nowrap><cf_get_lang_main no='74.Kategori'></th>
				<th nowrap><cf_get_lang_main no='158.Ad Soyad'></th>
				<th><cf_get_lang_main no='340.Vergi No'></th>
				<th nowrap><cf_get_lang_main no='87.Telefon'></th>
				<th><cf_get_lang no='472.Grupla Çalistigi Şubeler'></th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
		  <form name="search_" method="post" action="">
		  <cfif get_comp_kontrol.recordcount>
			  <cfoutput query="get_comp_kontrol">
				<cfquery dbtype="query" name="GET_COMPANY_BRANCH">
					SELECT
						*
					FROM
						GET_COMPANY_BRANCH_ALL
					WHERE
						COMPANY_ID = #get_comp_kontrol.company_id#
				</cfquery>
				<tr>
					<td>#currentrow#</td>
					<td nowrap><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></td>
					<td nowrap>#companycat#</td>
					<td nowrap><cfif attributes.company_partner_name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
					<cfif attributes.company_partner_surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif></td>
					<td><cfif attributes.tax_num eq trim(taxno)><font color="##990000">#taxno#</font><cfelse>#taxno#</cfif></td>
					<td nowrap><cfif attributes.tel1 eq trim(company_tel1)><font color="##990000">#company_telcode# #company_tel1#</font><cfelse>#company_telcode# #company_tel1#</cfif></td>
					<td><cfloop query="get_company_branch">#nick_name# / #branch_name#<br/></cfloop></td>
					<td  style="text-align:right;">
						<input type="submit" name="Devam" value="<cf_get_lang no='15.Şubeyi İlişkilendir'>" style="width=120;" onClick="control(2,#company_id#,#companycat_type#);">
					</td>
				</tr>
			</cfoutput>
			<cfif attributes.return_id eq 0>
				<tr>
					<td height="35" colspan="8"  style="text-align:right;"><input type="submit" name="Devam" value="<cf_get_lang no='16.Varolan Kayıtları Gözardi Et'>" onClick="control(3,0);"></td>
				</tr>
			</cfif>
			<cfelse>
				<tr>
					<td colspan="8"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
				</tr>
			</cfif>
			</form>
		</tbody>
	</cf_grid_list>
</cf_box>

<script type="text/javascript">
<cfif attributes.return_id eq 0>
	<cfif not get_comp_kontrol.recordcount>
		opener.form_add_company.submit();
		window.close();
	</cfif>
</cfif>
function control(id,value,compcat_id)
{
	if(id==1)
	{
		if(compcat_id == 1)
			opener.location.href='<cfoutput>#request.self#?fuseaction=member.detail_company&is_search=1&cpid=</cfoutput>' + value; 
		else
			opener.location.href='<cfoutput>#request.self#?fuseaction=crm.detail_company&is_search=1&cpid=</cfoutput>' + value; 
		window.close();
	}
	if(id==2)
	{
		<cfoutput>document.search_.action='#request.self#?fuseaction=crm.popup_add_company_workbranch&cpid='+value+'&branch_id=#attributes.branch_id#&telefon_satis_id=#attributes.telefon_satis_id#&plasiyer_id=#attributes.plasiyer_id#&satis_muduru_id=#attributes.satis_muduru_id#&risk_limit=#attributes.risk_limit#&money_type=#attributes.money_type#&resource=#attributes.resource#&status=#attributes.status#&itriyat_id=#attributes.itriyat_id#&tahsilatci_id=#attributes.tahsilatci_id#';</cfoutput>
		document.search_.submit();
		opener.location.href='<cfoutput>#request.self#?fuseaction=crm.detail_company&cpid='+value+'&is_branch=1</cfoutput>';
	}
	if(id==3)
	{
		opener.form_add_company.submit();
		window.close();
	}
}
</script>
