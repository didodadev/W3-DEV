<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_BOYUT_DEPO_CONTROL.RECORD_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		COMPANY,
		COMPANY_PARTNER,
		EMPLOYEES,
		COMPANY_BOYUT_DEPO_CONTROL
	WHERE
		COMPANY_BOYUT_DEPO_CONTROL.IS_ACTIVE = 0 AND
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
		COMPANY_BOYUT_DEPO_CONTROL.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND
		COMPANY_BOYUT_DEPO_CONTROL.COMPANY_ID = COMPANY.COMPANY_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_company.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','Boyuta Aktarılmamış Müşteriler',52122)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
	 	<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='52057.Eczane Adı'></th>
				<th><cf_get_lang dictionary_id='52048.Eczacı'></th>
				<th><cf_get_lang dictionary_id='55812.Kayıt Eden'></th>
				<th><cf_get_lang dictionary_id='52124.Aktarım Tarihi'></th>
				<th width="20" class="header_icn_none"><a><img src="/images/devam.gif" title="<cf_get_lang dictionary_id='65146.boyuta aktar'>" border="0"></a></th>
			</tr>
		</thead>
		<tbody>
		<cfif get_company.recordcount>
			<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td>#currentrow#</td>
					<td>#fullname#</td>
					<td>#company_partner_name# #company_partner_surname#</td>
					<td>#employee_name# #employee_surname#</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td><a href="#request.self#?fuseaction=crm.emptypopup_add_company_boyut_kod&company_id=#company_id#" class="tableyazi"><img src="/images/devam.gif" title="<cf_get_lang dictionary_id='65146.boyuta aktar'>" border="0"></a></td>
				</tr>
			</cfoutput>
		<cfelse>			
			<tr> 
			  <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
		</tbody>
	</cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="crm.popup_dsp_company_boyut_depo_kod_control"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
</cf_box>
