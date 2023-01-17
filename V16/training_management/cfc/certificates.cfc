<!---10.11.2020 - Gülbahar - sertifikalar cfc dosyası insert,delete,update,select işlemleri eklendi --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_training_certificates" access="remote">
		<cfargument name="employee_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument  name="partner_id" default="">
		<cfargument  name="certificate_id" default="">
		<cfargument name="date_of_validity" default="">
		<cfargument name="prepared_by" default="">
		<cfargument name="approved_by" default="">
		<cfargument name="approved_by_2" default="">
		<cfargument name="prepared_date" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
	    <cftransaction>
	        <cfquery name="get_training_certificates" datasource="#dsn#" result="query">
	            SELECT 
				TRAINING_CERTIFICATE.*,
				SC.CERTIFICATE_NAME
				FROM 
					TRAINING_CERTIFICATE, 
					SETTINGS_CERTIFICATE SC
				WHERE 
					SC.CERTIFICATE_ID = TRAINING_CERTIFICATE.CERTIFICATE_ID
				<cfif isdefined("arguments.employee_id") and len(arguments.employee_id) and len(arguments.employee_name)>
					AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
				</cfif>
				<cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and len(arguments.employee_name)>
					AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
				</cfif>
				<cfif isdefined("arguments.partner_id") and len(arguments.partner_id) and len(arguments.employee_name)>
					AND PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
				</cfif>
				<cfif isdefined("arguments.certificate_id") and len(arguments.certificate_id)>
					AND TRAINING_CERTIFICATE.CERTIFICATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.certificate_id#">
				</cfif>
				<cfif isdefined("arguments.date_of_validity") and len(arguments.date_of_validity)>
					AND TRAINING_CERTIFICATE.DATE_OF_VALIDITY = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date_of_validity#">
				</cfif>
            </cfquery>
	        <cfreturn get_training_certificates>
	    </cftransaction>
	</cffunction>
	<cffunction name="get_certificates" access="remote">
	    <cftransaction>
	        <cfquery name="get_certificates" datasource="#dsn#" result="query">
	            SELECT * FROM SETTINGS_CERTIFICATE
            </cfquery>
	        <cfreturn get_certificates>
	    </cftransaction>
	</cffunction>
	<cffunction name="ADD_TRAINING_CERTIFICATE" access="remote" returnFormat="json">
		<cfargument  name="certificate_id" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument  name="partner_id" default="">
		<cfargument name="get_date" default="">
		<cfargument name="date_of_validity" default="">
		<cfargument name="detail" default="">
		<cfargument name="prepared_by" default="">
		<cfargument name="approved_by" default="">
		<cfargument name="approved_by_2" default="">
		<cfargument name="prepared_date" default="">
		<cfargument name="process_stage" default="">

	        <cfquery name="add_training_certificates" datasource="#dsn#" result="MAX_ID">
	            INSERT INTO TRAINING_CERTIFICATE
					(
						CERTIFICATE_ID
						,PARTNER_ID
						,CONSUMER_ID
						,EMPLOYEE_ID
						,GET_DATE
						,DATE_OF_VALIDITY
						,DETAIL
						,RECORD_EMP
						,RECORD_IP
						,RECORD_DATE
						,PREPARED_BY 
						,APPROVED_BY
						,APPROVED_BY_2
						,PREPARED_DATE
						,STATUS_ID
					)
    		    VALUES
					(
						<cfif len(arguments.certificate_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.certificate_id#"><cfelse>NULL</cfif>,
						<cfif len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>,
						<cfif len(arguments.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
						<cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
						<cfif len(arguments.get_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.get_date#"><cfelse>NULL</cfif>,
						<cfif len(arguments.date_of_validity)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date_of_validity#"><cfelse>NULL</cfif>,
						<cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfif len(arguments.prepared_by)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prepared_by#"><cfelse>NULL</cfif>,
						<cfif len(arguments.approved_by)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approved_by#"><cfelse>NULL</cfif>,
						<cfif len(arguments.approved_by_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approved_by_2#"><cfelse>NULL</cfif>,
						<cfif len(arguments.prepared_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.prepared_date#"><cfelse>NULL</cfif>,
						<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
					)
            </cfquery>
			 <cfquery name="get_max_id" datasource="#dsn#">
				SELECT MAX(TRAINING_CERTIFICATE_ID) AS TRAINING_CERTIFICATE_ID   FROM TRAINING_CERTIFICATE
			</cfquery>
			<script>
			window.location.href='<cfoutput>/index.cfm?fuseaction=training_management.certificates&event=upd&training_certificate_id=#get_max_id.TRAINING_CERTIFICATE_ID#</cfoutput>';
			</script><cfreturn Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" ) />
	</cffunction>
	<cffunction name="UPD_TRAINING_CERTIFICATE" access="remote" returnFormat="json">
		<cfargument  name="training_certificate_id" default="">
		<cfargument  name="certificate_id" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument  name="partner_id" default="">
		<cfargument name="get_date" default="">
		<cfargument name="date_of_validity" default="">
		<cfargument name="detail" default="">
		<cfargument name="prepared_by" default="">
		<cfargument name="approved_by" default="">
		<cfargument name="approved_by_2" default="">
		<cfargument name="prepared_date" default="">
		<cfargument name="process_stage" default="">
		<cfquery name="upd_training_certificates" datasource="#dsn#" result="query">
			UPDATE TRAINING_CERTIFICATE
				SET CERTIFICATE_ID = <cfif len(arguments.certificate_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.certificate_id#"><cfelse>NULL</cfif>
					,PARTNER_ID = <cfif len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>
					,CONSUMER_ID = <cfif len(arguments.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>
					,EMPLOYEE_ID = <cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>
					,GET_DATE = <cfif len(arguments.get_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.get_date#"><cfelse>NULL</cfif>
					,DATE_OF_VALIDITY = <cfif len(arguments.date_of_validity)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date_of_validity#"><cfelse>NULL</cfif>
					,DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>
					,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					,PREPARED_BY = <cfif len(arguments.prepared_by)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prepared_by#"><cfelse>NULL</cfif>
					,APPROVED_BY = <cfif len(arguments.approved_by)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approved_by#"><cfelse>NULL</cfif>
					,APPROVED_BY_2 = <cfif len(arguments.approved_by_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approved_by_2#"><cfelse>NULL</cfif>
					,PREPARED_DATE = <cfif len(arguments.prepared_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.prepared_date#"><cfelse>NULL</cfif>
					,STATUS_ID = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
				WHERE TRAINING_CERTIFICATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_certificate_id#">
		</cfquery>
		<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
			<cf_workcube_process 
			is_upd='1' 
			process_stage='#arguments.process_stage#' 
			record_member='#session.ep.userid#'
			record_date='#now()#' 
			action_table='TRAINING_CERTIFICATE'
			action_column='TRAINING_CERTIFICATE_ID'
			action_id='#arguments.training_certificate_id#' 
			action_page='#request.self#?fuseaction=training_management.certificates&event=upd&training_certificate_id=#arguments.training_certificate_id#' 
			<!--- warning_description='<strong>#get_service1.service_head#</strong><br/><br/>#get_service1.service_detail#' --->>
		</cfif>	
	    <cfreturn upd_training_certificates>
			
			<script>
				location.href = document.referrer;
			</script>
	</cffunction>
	<cffunction name="DEL_TRAINING_CERTIFICATE" access="remote"  returntype="any" returnFormat="json">
		<cfargument name="training_certificate_id" default="">
	    <cftransaction>
	        <cfquery name="DEL_TRAINING_CERTIFICATE" datasource="#dsn#">
	            DELETE FROM TRAINING_CERTIFICATE WHERE TRAINING_CERTIFICATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_certificate_id#">
            </cfquery>
	        <script type="text/javascript">
				window.location.href="/index.cfm?fuseaction=training_management.certificates";
			</script>
	    </cftransaction>
	</cffunction>
	<cffunction name="get_list_certificates" access="remote">
		<cfargument name="training_certificate_id" default="">
	    <cftransaction>
	        <cfquery name="get_list_certificates" datasource="#dsn#" result="query">
	            SELECT * FROM TRAINING_CERTIFICATE WHERE TRAINING_CERTIFICATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_certificate_id#">
            </cfquery>
	        <cfreturn get_list_certificates>
	    </cftransaction>
	</cffunction>
</cfcomponent>