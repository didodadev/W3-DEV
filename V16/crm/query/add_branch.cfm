<cfquery name="CHECK_BRANCH" datasource="#dsn#">
	SELECT
		*
	FROM
		COMPANY_BRANCH
	WHERE 
		COMPBRANCH__NAME ='#TRIM(COMPBRANCH__NAME)#' AND 
		COMPANY_ID = #attributes.COMPANY_ID#
</cfquery>
<cfif check_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='39.Aynı Adlı Şube Kaydı Var ! Şube Adını Değişiniz !'>");
		window.history.go(-1);
	</script>
<cfelse>
	<cfquery name="add_branch" datasource="#dsn#">
		INSERT INTO
			COMPANY_BRANCH
		(
			COMPBRANCH_STATUS,
			COMPANY_ID,	
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>POS_CODE,</cfif>
			COMPBRANCH__NAME,
			<cfif isdefined("attributes.COMPBRANCH__NICKNAME")>
			COMPBRANCH__NICKNAME,
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_EMAIL")>	
			COMPBRANCH_EMAIL,
			</cfif>
			COMPBRANCH_TELCODE,	
			COMPBRANCH_TEL1,	
			<cfif isdefined("attributes.COMPBRANCH_TEL2") and len(attributes.COMPBRANCH_TEL2)>
			COMPBRANCH_TEL2,
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_TEL3") and len(attributes.COMPBRANCH_TEL3)>	
			COMPBRANCH_TEL3,
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_FAX") and len(attributes.COMPBRANCH_FAX)>	
			COMPBRANCH_FAX,
			</cfif>
			<cfif isdefined("attributes.homepage")>	
			HOMEPAGE,
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_ADDRESS")>	
			COMPBRANCH_ADDRESS,
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_POSTCODE")>	
			COMPBRANCH_POSTCODE,
			</cfif>
			<cfif isdefined("attributes.COUNTY")>	
			COUNTY,
			</cfif>
			<cfif isdefined("attributes.city")>	
			CITY,
			</cfif>
			<cfif isdefined("attributes.county")>	
			COUNTY,
			</cfif>
			<cfif isdefined("attributes.manager_partner_id") and len(attributes.manager_partner_id)>
			MANAGER_PARTNER_ID,
			</cfif>
			RECORD_DATE,	
			RECORD_MEMBER
		)
		VALUES
		(
			<cfif isdefined("attributes.COMPBRANCH_STATUS")>1,<cfelse>0,</cfif>
			#attributes.COMPANY_ID#,
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>#attributes.POS_CODE#,</cfif>
			'#attributes.COMPBRANCH__NAME#',
			<cfif isdefined("attributes.COMPBRANCH__NICKNAME")>
			'#attributes.COMPBRANCH__NICKNAME#',
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_EMAIL")>
			'#attributes.COMPBRANCH_EMAIL#',
			</cfif>
			'#attributes.COMPBRANCH_TELCODE#',
			'#attributes.COMPBRANCH_TEL1#',
			<cfif isdefined("attributes.COMPBRANCH_TEL2") and len(attributes.COMPBRANCH_TEL2)>	
			'#attributes.COMPBRANCH_TEL2#',
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_TEL3") and len(attributes.COMPBRANCH_TEL3)>
			'#attributes.COMPBRANCH_TEL3#',
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_FAX") and len(attributes.COMPBRANCH_fax)>
			'#attributes.COMPBRANCH_FAX#',
			</cfif>
			<cfif isdefined("attributes.homepage")>
			'#attributes.HOMEPAGE#',
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_ADDRESS")>
			'#attributes.COMPBRANCH_ADDRESS#',
			</cfif>
			<cfif isdefined("attributes.COMPBRANCH_POSTCODE")>
			'#attributes.COMPBRANCH_POSTCODE#',
			</cfif>
			<cfif isdefined("attributes.COUNTY")>
			'#attributes.COUNTY#',
			</cfif>
			<cfif isdefined("attributes.city")>
			'#attributes.CITY#',
			</cfif>
			<cfif isdefined("attributes.county")>
			'#attributes.COUNTY#',
			</cfif>
			<cfif isdefined("attributes.manager_partner_id") and len(attributes.manager_partner_id)>
			#attributes.MANAGER_PARNER_ID#,
			</cfif>
			#NOW()#,
			#SESSION.EP.USERID#
		)
	</cfquery>
	<cflocation url="#request.self#?fuseaction=crm.detail_company&cpid=#attributes.company_id#" addtoken="No">
</cfif>
