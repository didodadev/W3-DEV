<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="DEL_ROWS" datasource="#DSN3#">
            DELETE FROM SUBSCRIPTION_INFO WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
        </cfquery>
		<cfloop from="1" to="#attributes.record_num1#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
					<cfquery name="add_par_rel" datasource="#DSN3#">
						INSERT INTO 
							SUBSCRIPTION_INFO 
						(
							SUBSCRIPTION_ID,
							DETAIL,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						) 
						VALUES 
						(
							#attributes.subscription_id#,
							<cfif len(evaluate("attributes.detail#i#"))><cfqueryparam value="#wrk_eval('attributes.detail#i#')#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#now()#
						)
					</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfabort>
