<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ,
		SALES_ZONE_GROUP SZG
	WHERE
		SZG.SZ_ID = SZ.SZ_ID AND
		SZG.POSITION_CODE = #session.ep.position_code#
	UNION
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ
	WHERE
		SZ.RESPONSIBLE_POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset row_block = 500>
<cfif get_hierarchies.recordcount>
	<!--- satis bolgelerine ait yetki varsa (bolge yonetici veya satis grubu) satis bolgelerine hiyerarsi ile bakmali --->
	<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
		SELECT
			SZ_ID,
			SZ_NAME,
			SZ_HIERARCHY
		FROM
			SALES_ZONES
		WHERE
			<cfloop query="get_hierarchies"><cfif get_hierarchies.currentrow gt 1>OR</cfif> SALES_ZONES.SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy#%'</cfloop>
		ORDER BY
			SZ_HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_sales_zones.recordcount = 0>
</cfif>
<cfif not isdefined("attributes.is_sales")>
	<cfscript>
		if (len(attributes.fullname))
		{
			fullname_1 = replacelist(attributes.fullname,"ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö","u,g,i,s,c,o,U,G,I,S,C,O");
			fullname_2 = replacelist(attributes.fullname,"u,g,i,s,c,o,U,G,I,S,C,O","ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö");
		}
	</cfscript>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			SETUP_CITY.CITY_NAME,
			SETUP_COUNTY.COUNTY_NAME,
			COMPANY.FULLNAME,
			COMPANY_PARTNER.PARTNER_ID, 
            COMPANY_PARTNER.COUNTY PARTNER_COUNTY, 
            COMPANY_PARTNER.SEMT PARTNER_SEMT, 
            COMPANY_PARTNER.CITY PARTNER_CITY, 
			COMPANY.COMPANY_ID,
			SETUP_IMS_CODE.IMS_CODE,
			SETUP_IMS_CODE.IMS_CODE_NAME,
			COMPANY.COMPANY_TELCODE,
			COMPANY.COMPANY_TEL1,
			COMPANY.TAXNO,
			COMPANY.ISPOTANTIAL,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY.SEMT
		FROM
			COMPANY,
			COMPANY_PARTNER,
			SETUP_IMS_CODE,
			SETUP_CITY,
			SETUP_COUNTY
		WHERE
		<cfif len(attributes.hedefkodu)>COMPANY.COMPANY_ID = #attributes.hedefkodu# AND</cfif>
		<cfif len(attributes.tc_kimlik_no)>COMPANY_PARTNER.TC_IDENTITY = '#attributes.tc_kimlik_no#' AND</cfif>
		<cfif len(attributes.county) and len(attributes.county_id)>COMPANY.COUNTY = #attributes.county_id# AND</cfif>
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>COMPANY.IMS_CODE_ID = #attributes.ims_code_id# AND</cfif>
		<cfif len(attributes.pro_rows)>COMPANY.COMPANY_STATE = #attributes.pro_rows# AND</cfif>
		<cfif len(attributes.city)>SETUP_CITY.CITY_ID = #attributes.city# AND</cfif>
		<cfif len(attributes.vergi_no)>COMPANY.TAXNO = '#attributes.vergi_no#' AND</cfif>
		<cfif len(attributes.customer_type) and len(attributes.customer_type_id)>COMPANY.COMPANYCAT_ID IN (#attributes.customer_type_id#) AND</cfif>
		<cfif len(attributes.cp_name)>COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.cp_name#%"> AND</cfif>
		<cfif len(attributes.is_active)>COMPANY.COMPANY_STATUS = #attributes.is_active# AND</cfif>
			COMPANY.COMPANY_ID IN
				(
				SELECT
					CBR.COMPANY_ID
				FROM
					COMPANY_BRANCH_RELATED CBR,
					EMPLOYEE_POSITION_BRANCHES EPB
				WHERE
					CBR.DEPOT_DAK IS NOT NULL AND
					EPB.POSITION_CODE = #session.ep.position_code# AND
					<cfif len(attributes.branch_id)>CBR.BRANCH_ID = #attributes.branch_id# AND</cfif>
					<cfif len(attributes.branch_state)>CBR.MUSTERIDURUM = #attributes.branch_state# AND</cfif>
					<cfif len(attributes.carihesapkod)>CBR.CARIHESAPKOD = '#attributes.carihesapkod#' AND</cfif>
					EPB.BRANCH_ID = CBR.BRANCH_ID
				) AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
			SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
			COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
			SETUP_CITY.CITY_ID = COMPANY.CITY AND
			SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY
			<cfif len(attributes.fullname)>AND ( COMPANY.FULLNAME LIKE '%#attributes.fullname#%' OR COMPANY.FULLNAME LIKE '%#fullname_1#%' OR COMPANY.FULLNAME LIKE '%#fullname_2#%' )</cfif>
		<cfif fusebox.use_period and isdefined("attributes.period_id") and len(attributes.period_id)>
			AND COMPANY.COMPANY_ID IN (
									SELECT
										CPE.COMPANY_ID
									FROM
										COMPANY_PERIOD CPE
									WHERE
										COMPANY.COMPANY_ID = CPE.COMPANY_ID AND
										<cfif isdefined('attributes.period_id') and Len(attributes.period_id) and listgetat(attributes.period_id,1,';') eq 1>
											CPE.PERIOD_ID = #listgetat(attributes.period_id,3,';')#
										<cfelseif isdefined('attributes.period_id') and Len(attributes.period_id)>
											CPE.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(attributes.period_id,2,';')#)
										<cfelse>
											CPE.PERIOD_ID IN (#period_id_list#)
										</cfif>
								)
			</cfif>
		ORDER BY
			COMPANY.FULLNAME
	</cfquery>
	<cfquery name="GET_COMPANY_ACCOUNT" datasource="#DSN#">
		SELECT
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.IS_SELECT,
			SETUP_MEMBERSHIP_STAGES.TR_NAME AS TR_NAME
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED,
			OUR_COMPANY,
			SETUP_MEMBERSHIP_STAGES
		WHERE
			SETUP_MEMBERSHIP_STAGES.TR_ID = COMPANY_BRANCH_RELATED.MUSTERIDURUM AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
			OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	UNION ALL
		SELECT
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.IS_SELECT,
			'' AS TR_NAME
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED,
			OUR_COMPANY
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NULL AND
			COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
			OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	</cfquery>
<cfelse>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			COMPANY.FULLNAME,
			COMPANY_PARTNER.PARTNER_ID,
			COMPANY.COMPANY_ID,
			COMPANY.COMPANY_TELCODE,
			COMPANY.COMPANY_TEL1,
			COMPANY.TAXNO,
			COMPANY.IMS_CODE_ID,
			COMPANY.COUNTY,
			COMPANY.CITY,
			COMPANY_PARTNER.COUNTY PARTNER_COUNTY,
			COMPANY_PARTNER.CITY PARTNER_CITY,
			COMPANY_PARTNER.SEMT PARTNER_SEMT,
			COMPANY.ISPOTANTIAL,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY_CAT.COMPANYCAT,
			COMPANY_PARTNER.TITLE
		FROM
			COMPANY,
			COMPANY_PARTNER,
			COMPANY_CAT
		WHERE
			COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
			COMPANY.COMPANY_STATUS = #attributes.is_active# AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
			COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
			<cfif len(attributes.county) and len(attributes.county_id)>AND COMPANY.COUNTY = #attributes.county_id#</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND COMPANY.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
			<cfif len(attributes.pro_rows)>AND COMPANY.COMPANY_STATE = #attributes.pro_rows#</cfif>
			<cfif len(attributes.city)>AND COMPANY.CITY = #attributes.city#</cfif>
			<cfif len(attributes.vergi_no)>AND COMPANY.TAXNO = '#attributes.vergi_no#'</cfif>
			<cfif len(attributes.customer_type) and len(attributes.customer_type_id)>AND COMPANY.COMPANYCAT_ID IN (#attributes.customer_type_id#)</cfif>
			<cfif len(attributes.cp_name)>AND COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.cp_name#%"></cfif>
			<cfif len(attributes.fullname)>AND COMPANY.FULLNAME LIKE '%#attributes.fullname#%'</cfif>
			<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
				AND COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
			</cfif>
			<cfif isdefined("attributes.companycat") and len(attributes.companycat)>AND COMPANY.COMPANYCAT_ID = #attributes.companycat#</cfif>
			<cfif isdefined("attributes.company_sector") and len(attributes.company_sector)>AND COMPANY.SECTOR_CAT_ID = #attributes.company_sector#</cfif>
			<cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>AND COMPANY.SALES_COUNTY = #attributes.sales_county#</cfif>
			<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>AND COMPANY.COMPANY_VALUE_ID = #attributes.customer_value#</cfif>
			<cfif fusebox.use_period and isdefined("attributes.period_id") and len(attributes.period_id)>
				AND COMPANY.COMPANY_ID IN (
									SELECT
										CPE.COMPANY_ID
									FROM
										COMPANY_PERIOD CPE
									WHERE
										COMPANY.COMPANY_ID = CPE.COMPANY_ID AND
										<cfif isdefined('attributes.period_id') and Len(attributes.period_id) and listgetat(attributes.period_id,1,';') eq 1>
											CPE.PERIOD_ID = #listgetat(attributes.period_id,3,';')#
										<cfelseif isdefined('attributes.period_id') and Len(attributes.period_id)>
											CPE.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(attributes.period_id,2,';')#)
										<cfelse>
											CPE.PERIOD_ID IN (#period_id_list#)
										</cfif>
								)
			</cfif>
			<cfif isdefined('session.ep.our_company_info.sales_zone_followup') and session.ep.our_company_info.sales_zone_followup eq 1>
				<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
				AND 
				(
					COMPANY.IMS_CODE_ID IN (
										SELECT
											IMS_ID
										FROM
											SALES_ZONES_ALL_2
										WHERE
											POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
											AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(COMPANY.COMPANYCAT_ID AS NVARCHAR)+',%'))
									 )
				<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
				<cfif get_hierarchies.recordcount>
				OR COMPANY.IMS_CODE_ID IN (
										SELECT
											IMS_ID
										FROM
											SALES_ZONES_ALL_1
										WHERE											
											<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
												<cfset start_row=(page_stock*row_block)+1>	
												<cfset end_row=start_row+(row_block-1)>
												<cfif (end_row) gte get_hierarchies.recordcount>
													<cfset end_row=get_hierarchies.recordcount>
												</cfif>
													(
													<cfloop index="add_stock" from="#start_row#" to="#end_row#">
														<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
													</cfloop>
													
													)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
											</cfloop>											
									)
				  </cfif>						
				)
			</cfif>
		ORDER BY
			COMPANY.FULLNAME
	</cfquery>
</cfif>
