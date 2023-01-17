<cfif isdefined("url.cid")>
	<cfquery name="DEL_CC" datasource="#dsn#">
		DELETE 
			FROM 
			COMPANY
		WHERE 	
			COMPANY.COMPANY_ID = #URL.CID#
		DELETE 	
		FROM 
			COMPANY_BRANCH
		WHERE 	
			COMPANY_BRANCH.COMPANY_ID = #URL.CID#
		DELETE 	
		FROM 
			COMPANY_PARTNER
		WHERE 	
			COMPANY_PARTNER.COMPANY_ID = #URL.CID#
		DELETE 	
		FROM 
			COMPANY_CREDIT
		WHERE 	
			#URL.CID# = COMPANY_CREDIT.COMPANY_ID
		DELETE 	
		FROM 
			COMPANY_CC
		WHERE 	
			#URL.CID# = COMPANY_CC.COMPANY_ID
		DELETE 	
		FROM 
			COMPANY_BANK
		WHERE 	
			#URL.CID# = COMPANY_BANK.COMPANY_ID
		DELETE 
			FROM TARGET
		WHERE 	
			#URL.CID# = TARGET.COMPANY_ID
	</cfquery>
	<cfset attributes.action_section="COMPANY_ID">
	<cfset attributes.action_id=attributes.CID>
	<cfinclude template="../../objects/query/del_assets.cfm">
	<cfinclude template="../../objects/query/del_notes.cfm">
</cfif>
<cfif isDefined("url.brid")>
	<cfquery name="UPD_PARTNER" datasource="#dsn#">
		UPDATE 
		COMPANY_PARTNER 
		SET 
		COMPBRANCH_ID = 0
		WHERE 	
		COMPANY_PARTNER.COMPBRANCH_ID = #URL.BRID#
	</cfquery>
	<cfquery name="DEL_BRANCH" datasource="#dsn#">
		DELETE 	
		FROM 
			COMPANY_BRANCH
		WHERE 	
			COMPANY_BRANCH.COMPBRANCH_ID = #URL.BRID#
		DELETE 	
		FROM 
			TARGET
		WHERE 	
			#URL.BRID# = TARGET.BRANCH_ID
	</cfquery>
	<cfset attributes.action_section="COMPANY_BRANCH_ID">
	<cfset attributes.action_id=attributes.BRID>
	<cfinclude template="../../objects/query/del_assets.cfm">
	<cfinclude template="../../objects/query/del_notes.cfm">
	<cflocation url="#request.self#?fuseaction=crm.detail_company&cpid=#attributes.company_id#" addtoken="no">
</cfif>
<cfif isDefined("url.pid")>
	<cfquery name="GET_PHOTO" datasource="#dsn#">
		SELECT 
			PHOTO,
			PHOTO_SERVER_ID
		FROM 
			COMPANY_PARTNER 
		WHERE 
			PARTNER_ID = #URL.PID#
	</cfquery>
	<cfif get_photo.recordcount or len(get_photo.photo) neq 0>
		<cfoutput>#upload_folder#member\#get_photo.photo#</cfoutput>
		<cfif FileExists("#upload_folder#member\#get_photo.photo#")>
			<!--- <cffile action="DELETE" file="#upload_folder#member#dir_seperator##get_photo.photo#">   --->
			<cf_del_server_file output_file="member/#get_photo.photo#" output_server="#get_photo.photo_server_id#">
		<cfelse>
			<cf_get_lang no='109.Yok'>
		</cfif>		
	</cfif>
	<cfquery name="DEL_PARTNER" datasource="#dsn#">
		DELETE 	
		FROM 
			COMPANY_PARTNER
		WHERE 	
			COMPANY_PARTNER.PARTNER_ID = #URL.PID#
		DELETE 
		FROM 
			TARGET
		WHERE 	
			#URL.PID# = TARGET.PARTNER_ID
	</cfquery>
	<cfset attributes.action_section="PARTNER_ID">
	<cfset attributes.action_id=attributes.PID>
	<cfinclude template="../../objects/query/del_assets.cfm">
	<cfinclude template="../../objects/query/del_notes.cfm">
</cfif>
<cflocation url="#request.self#?fuseaction=crm.welcome" addtoken="no">
