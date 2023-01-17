<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT DUTY_TYPE_ID FROM SETUP_DUTY_TYPE WHERE CUSTOMER_TYPE_ID LIKE '%,#attributes.customer_type_id#,%'
</cfquery>
<cfquery name="GET_CONTROL_1" datasource="#DSN#">
	SELECT CUSTOMER_TYPE_ID FROM COMPANY_BRANCH_CONTRACT WHERE CUSTOMER_TYPE_ID = #attributes.customer_type_id#
</cfquery>
<cfif get_control.recordcount or get_control_1.recordcount>
	<cfif get_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2544.Bu Müşteri Tipi, Hizmet Tipinde Seçilmiş, Kontrol Ediniz'> !");
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2545.Bu Müşteri Tipi,Anlaşma Detayında Seçilmiş, Kontrol Ediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cflock timeout="60">
		<cftransaction>
			<cfquery name="UPD_CUSTOMER_TYPE" datasource="#DSN#">
				UPDATE 
					SETUP_CUSTOMER_TYPE
				SET 
					CUSTOMER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.customer_type#">,
					DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
					<cfif isdefined("attributes.is_control")>
						IS_CONTROL = 1,
						CONTROL_RATE = #attributes.control_rate#,
					<cfelse>
						IS_CONTROL = 0,
						CONTROL_RATE = NULL,
					</cfif>					
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#	 
				WHERE 
					CUSTOMER_TYPE_ID = #attributes.customer_type_id#
			</cfquery>
			<cfif (attributes.customer_type is not attributes.old_customer_type) or (attributes.detail is not attributes.old_detail)>
				<cfquery name="ADD_CUSTOMER_TYPE_HISTORY" datasource="#DSN#">
					INSERT INTO
						SETUP_CUSTOMER_TYPE_HISTORY
					(
						CUSTOMER_TYPE_ID,
						CUSTOMER_TYPE,
						IS_CONTROL,
						CONTROL_RATE,
						DETAIL,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#attributes.customer_type_id#,
						<cfif len(attributes.old_customer_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_customer_type#"><cfelse>NULL</cfif>,
						<cfif len(attributes.old_is_control)>#attributes.old_is_control#<cfelse>NULL</cfif>,
						<cfif len(attributes.old_control_rate)>#attributes.old_control_rate#<cfelse>NULL</cfif>,
						<cfif len(attributes.old_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_detail#"><cfelse>NULL</cfif>,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.add_customer_type" addtoken="no">
