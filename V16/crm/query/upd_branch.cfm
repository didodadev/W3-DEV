<cfif not isDefined("form.COMPBRANCH_STATUS")>
	<cfset form.COMPBRANCH_STATUS=0>
</cfif>
<cfquery datasource="#dsn#" name="upd_branch">
	UPDATE	
	COMPANY_BRANCH
	SET	
		<cfif isdefined("attributes.pos_code") and LEN(attributes.POS_CODE)>	
		POS_CODE =	#attributes.POS_CODE#,
		</cfif>
		COMPBRANCH__NAME='#attributes.COMPBRANCH__NAME#',
		<cfif isdefined("attributes.COMPBRANCH__NICKNAME")>
		COMPBRANCH__NICKNAME='#attributes.COMPBRANCH__NICKNAME#',
		</cfif>
		<cfif isdefined("attributes.manager_partner_id") AND len(attributes.manager_partner_id)>
		MANAGER_PARTNER_ID=#attributes.manager_partner_id#,
		</cfif>
		<cfif isdefined("attributes.COMPBRANCH_EMAIL")>	
		COMPBRANCH_EMAIL='#attributes.COMPBRANCH_EMAIL#',
		</cfif>
		COMPBRANCH_TELCODE='#attributes.COMPBRANCH_TELCODE#',	
		COMPBRANCH_TEL1=	'#attributes.COMPBRANCH_TEL1#',	
		<cfif isdefined("attributes.COMPBRANCH_TEL2") and len(attributes.COMPBRANCH_TEL2)>
		COMPBRANCH_TEL2='#attributes.COMPBRANCH_TEL2#',
		</cfif>
		<cfif isdefined("attributes.COMPBRANCH_TEL3") and len(attributes.COMPBRANCH_TEL3)>	
		COMPBRANCH_TEL3='#attributes.COMPBRANCH_TEL3#',
		</cfif>
		<cfif isdefined("attributes.COMPBRANCH_FAX") and len(attributes.COMPBRANCH_FAX)>	
		COMPBRANCH_FAX='#attributes.COMPBRANCH_FAX#',
		</cfif>
		<cfif isdefined("attributes.homepage")>	
		HOMEPAGE='#attributes.homepage#',
		</cfif>
		<cfif isdefined("attributes.COMPBRANCH_ADDRESS")>	
		COMPBRANCH_ADDRESS='#attributes.COMPBRANCH_ADDRESS#',
		</cfif>
		<cfif isdefined("attributes.COMPBRANCH_POSTCODE")>	
		COMPBRANCH_POSTCODE='#attributes.COMPBRANCH_POSTCODE#',
		</cfif>
		<cfif isdefined("attributes.COUNTY")>	
		COUNTY='#attributes.county#',
		</cfif>
		<cfif isdefined("attributes.city")>	
		CITY='#attributes.city#',
		</cfif>
		<cfif isdefined("attributes.county")>	
		COUNTY='#attributes.county#',
		</cfif>
		<cfif isdefined("attributes.COMPBRANCH_STATUS")>
		COMPBRANCH_STATUS=1,
		<cfelse>
		COMPBRANCH_STATUS=0,
		</cfif>
	
		RECORD_DATE=#NOW()#,	
		<!--- MEMBER_TYPE, --->	
		RECORD_MEMBER=#SESSION.EP.USERID#
		where 
		COMPBRANCH_ID=#attributes.COMPBRANCH_ID#
	</cfquery>
<cflocation url="#request.self#?fuseaction=crm.detail_company&cpid=#attributes.company_id#" addtoken="No">
