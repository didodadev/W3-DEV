<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT TARGET_PERIOD_ID FROM COMPANY_BRANCH_CONTRACT_ROW WHERE TARGET_PERIOD_ID = #attributes.target_period_id#
</cfquery>

<cfif get_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2549.Bu Hedef Dönemi Anlaşma İçeriğinde Seçilmiş, Kontrol Ediniz'> !");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cflock timeout="60">
		<cftransaction>
			<cfquery name="UPD_TARGET_PERIOD" datasource="#DSN#">
				UPDATE
					SETUP_TARGET_PERIOD
				SET 
					TARGET_PERIOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.target_period#">,
					COEFFICIENT = #attributes.coefficient#,
					DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">, 
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#	 
				WHERE 
					TARGET_PERIOD_ID = #attributes.target_period_id#
			</cfquery>
			<cfif (attributes.target_period is not attributes.old_target_period) or (attributes.detail is not attributes.old_detail) or (attributes.coefficient is not attributes.old_coefficient)>
				<cfquery name="ADD_TARGET_PERIOD_HISTORY" datasource="#DSN#">
					INSERT INTO
						SETUP_TARGET_PERIOD_HISTORY
					(
						TARGET_PERIOD_ID,
						TARGET_PERIOD,
						COEFFICIENT,
						DETAIL,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#attributes.target_period_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_target_period#">,
						#attributes.old_coefficient#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_detail#">,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.add_target_period" addtoken="no">
