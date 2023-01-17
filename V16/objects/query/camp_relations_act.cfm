<!--- Sistem - Kampanya ilişkileri kayıt eklemek içindir --->
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- ÖNCE SATIRLAR SİLİNİR --->
		<cfquery name="DEL_ROWS" datasource="#DSN3#">
			DELETE FROM CAMPAIGN_RELATION WHERE SUBSCRIPTION_ID = #attributes.system_id#
		</cfquery>
		<cfloop from="1" to="#attributes.record_num_camp#" index="i">
			<cfif isdefined("attributes.row_kontrol_camp_#i#") and evaluate("attributes.row_kontrol_camp_#i#") eq 1>
				<cfif len(evaluate('attributes.start_date#i#'))><cf_date tarih="attributes.start_date#i#"></cfif>
				<cfif len(evaluate('attributes.finish_date#i#'))><cf_date tarih="attributes.finish_date#i#"></cfif>
				<cfquery name="add_rel_camp" datasource="#DSN3#">
					INSERT INTO 
						CAMPAIGN_RELATION 
					(
						SUBSCRIPTION_ID,
						CAMP_ID,
						START_DATE,
						FINISH_DATE ,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					) 
					VALUES 
					(
						#attributes.system_id#,
						#evaluate("attributes.rel_camp_id#i#")#,
						<cfif len(evaluate('attributes.start_date#i#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.start_date#i#')#"><cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.start_date#i#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.finish_date#i#')#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<!---<cflocation url="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#attributes.system_id#">--->
