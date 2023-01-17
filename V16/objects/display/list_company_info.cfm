<cfif isdefined("attributes.r_id")>
	<cfquery name="GET_RIVALS" datasource="#dsn#">
		SELECT 
			RIVAL_NAME
		FROM
			SETUP_RIVALS 
		WHERE
			R_ID = #attributes.r_id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.ims_id")>
	<cfquery name="GET_IMS_CODE" datasource="#dsn#">
		SELECT
			IMS_CODE,
			IMS_CODE_NAME
		FROM
			SETUP_IMS_CODE
		WHERE
			IMS_CODE_ID = #attributes.ims_id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.team_id")>
	<cfquery name="GET_TEAM_NAME" datasource="#dsn#">
		SELECT 
			TEAM_NAME 
		FROM
			SALES_ZONES_TEAM
		WHERE
			TEAM_ID = #attributes.team_id#
	</cfquery>
</cfif>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_EMAIL,
		COMPANY.COMPANY_TEL1,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_FAX,
		COMPANY_CAT.COMPANYCAT,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.IMS_CODE_ID,
		COMPANY.TAXNO,
		COMPANY.COMPANY_EMAIL,
		COMPANY.COMPANY_FAX_CODE,
		SETUP_IMS_CODE.IMS_CODE,
		SETUP_IMS_CODE.IMS_CODE_NAME
	FROM
		COMPANY,
		COMPANY_CAT,
		COMPANY_PARTNER,
		SETUP_IMS_CODE
	WHERE
		SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
		<cfif isdefined("attributes.r_id")>
		AND COMPANY.COMPANY_ID IN
		(
			SELECT 
				COMPANY_ID
			FROM
				COMPANY_PARTNER_RIVAL
			WHERE
				RIVAL_ID = #attributes.r_id#
		)
		</cfif>
		<cfif isdefined("attributes.ims_id")>
		AND COMPANY.IMS_CODE_ID = #attributes.ims_id#
		</cfif>
  		<cfif isdefined("attributes.team_id")>
		AND 
		(
			COMPANY.COMPANY_ID IN (
					SELECT
						COMPANY_BRANCH_RELATED.COMPANY_ID
					FROM
						SALES_ZONES_TEAM_ROLES,
						COMPANY_BRANCH_RELATED
					WHERE
						SALES_ZONES_TEAM_ROLES.TEAM_ID = #attributes.team_id# AND
						COMPANY_BRANCH_RELATED.SALES_DIRECTOR = SALES_ZONES_TEAM_ROLES.EMP_ID )
		OR
			COMPANY.IMS_CODE_ID IN (
				SELECT
					SALES_ZONES_TEAM_IMS_CODE.IMS_ID
				FROM
					 SALES_ZONES_TEAM_IMS_CODE
				WHERE
					TEAM_ID = #attributes.team_id# )
		)
		</cfif>
		<cfif isdefined("attributes.position_code")>
			AND
			(
			COMPANY.COMPANY_ID IN (
								SELECT 
									COMPANY_ID
								FROM
									COMPANY_BRANCH_RELATED
								WHERE
								(
									PLASIYER_ID =  #attributes.position_code# OR
									SALES_DIRECTOR = #attributes.position_code# OR
									TEL_SALE_PREID = #attributes.position_code# 
								)
						)
			)
		</cfif>
	ORDER BY 
		FULLNAME
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_company.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head">
	<cfif isdefined("attributes.r_id")><cf_get_lang dictionary_id ='34011.Çalıştığı Müşteriler'> : <cfoutput>#get_rivals.rival_name#</cfoutput></cfif>
		<cfif isdefined("attributes.ims_id")><cf_get_lang dictionary_id ='34012.IMS Bölgesi Müşterileri'> : <cfoutput>#get_ims_code.ims_code# #get_ims_code.ims_code_name#</cfoutput></cfif>
		<cfif isdefined("attributes.team_id")><cf_get_lang dictionary_id ='34013.Takım Müşterileri'> : <cfoutput>#get_team_name.team_name#</cfoutput></cfif>
		<cfif isdefined("attributes.position_code")><cf_get_lang dictionary_id ='58673.Müşteriler'> : <cfoutput>#get_emp_info(attributes.position_code,1,0)#</cfoutput></cfif>
</cfsavecontent>
<cf_box title='#head#' popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				<th><cf_get_lang dictionary_id='29511.Yönetici'></th>
				<th><cf_get_lang dictionary_id='30678.IMS Bölge Kodu'></th>
				<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
				<th width="70"><cf_get_lang dictionary_id='58143.İletişim'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_company.recordcount>
			<cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<td width="25">#currentrow#</td>
					<td>#get_par_info(company_id,1,1,1)#</td>
					<td>#companycat#</td>
					<td>#company_partner_name# #company_partner_surname#</td>
					<td>#ims_code# #ims_code_name#</td>
					<td>#taxno#</td>
					<td width="70">
						<cfif len(company_email)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#COMPANY_EMAIL#','list')"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='33839.Mail Olarak Yolla'>" border="0"></i></a></cfif>
						<cfif len(company_tel1)><a href="javascript://"><i class="fa fa-phone" border="0" title="<cf_get_lang dictionary_id ='57499.Telefon'>:#company_telcode# - #company_tel1#"></i></a></cfif>
						<cfif len(company_fax)><a href="javascript://"><i class="fa fa-fax"  title="Fax:#company_fax_code# - #company_fax#" border="0"></i></a></cfif>
					</td>
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_string = "">
		<cfif isdefined("attributes.r_id")>
			<cfset url_string = "#url_string#&r_id=#attributes.r_id#">
		</cfif>
		<cfif isdefined("attributes.ims_id")>
			<cfset url_string = "#url_string#&ims_id=#attributes.ims_id#">
		</cfif>
		<cfif isdefined("attributes.team_id")>
			<cfset url_string = "#url_string#&team_id=#attributes.team_id#">
		</cfif>
		<cfif isdefined("attributes.position_code")>
			<cfset url_string = "#url_string#&position_code=#attributes.position_code#">
		</cfif>
		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="objects.popup_list_company_info#url_string#"> 
	</cfif>
</cf_box>
