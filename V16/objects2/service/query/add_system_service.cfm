<cfquery name="get_stage" datasource="#dsn#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		<cfif isdefined("session.pp")>
			PTR.IS_PARTNER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTR.IS_CONSUMER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
	ORDER BY
		PTR.PROCESS_ROW_ID
</cfquery>
<cfif not get_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1503.Servis Durumu Bulunamadı! Müşteri Hizmetlerine Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cftransaction>
	<cf_papers paper_type="SERVICE_APP">
	<cfset system_paper_no=paper_code & '-' & paper_number>
	<cfset system_paper_no_add=paper_number>
	
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE
			GENERAL_PAPERS
		SET
			SERVICE_APP_NUMBER = #system_paper_no_add#
		WHERE
			SERVICE_APP_NUMBER IS NOT NULL
	</cfquery>
</cftransaction>


<cflock name="#CREATEUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="ADD_SERVICE" datasource="#dsn3#" result="MAX_ID">
		INSERT INTO
			SERVICE
			(
				SERVICE_NO,
				SUBSCRIPTION_ID,
				SALE_ADD_OPTION_ID,
				SERVICE_STATUS_ID,
				COMMETHOD_ID,
				PRIORITY_ID,
				SERVICE_ACTIVE,
				ISREAD,
				SERVICE_COMPANY_ID,
				SERVICE_PARTNER_ID,
				SERVICE_CONSUMER_ID,
			<cfif len(APPCAT)>
				SERVICECAT_ID,
			</cfif>
				APPLICATOR_NAME,
				APPLICATOR_COMP_NAME,
				SERVICE_HEAD,
				SERVICE_DETAIL,
				APPLY_DATE,
				START_DATE,
				RECORD_DATE,
				RECORD_PAR,
				RECORD_CONS,
				SERVICE_ADDRESS
			)
			VALUES
			(
				'#system_paper_no#',
				<cfif len(attributes.SUBSCRIPTION_ID)>#attributes.SUBSCRIPTION_ID#,<cfelse>NULL,</cfif>
				<cfif len(attributes.SALE_ADD_OPTION_ID)>#attributes.SALE_ADD_OPTION_ID#,<cfelse>NULL,</cfif>
				#get_stage.PROCESS_ROW_ID#,
				6,
				1,
				1,
				0,
				<cfif isdefined("attributes.company_id")>
					#attributes.company_id#,
					#attributes.partner_id#,
				<cfelse>
					NULL,
					NULL,
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					#attributes.consumer_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif len(APPCAT)>
					#APPCAT#,
				</cfif>
				<cfif isdefined("session.pp")>'#session.pp.name# #session.pp.surname#',<cfelse>'#session.ww.name# #session.ww.surname#',</cfif>
				<cfif isdefined("session.pp")>'#session.pp.company_nick#',<cfelse>NULL,</cfif>
				'#attributes.service_head#',
				'#CRM_DETAIL#',
				#now()#,
				#now()#,
				#now()#,
				<cfif isdefined("session.pp")>#session.pp.userid#,<cfelse>NULL,</cfif>
				<cfif isdefined("session.ww.userid")>#session.ww.userid#,<cfelse>NULL,</cfif>
				'#attributes.service_address#'
			)
	</cfquery>
  </cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects2.upd_service&service_id=#MAX_ID.IDENTITYCOL#" addtoken="No">
