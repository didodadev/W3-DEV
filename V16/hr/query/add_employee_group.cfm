<!--- Yetkili olunan satirlarda islem yapilmasi icin eklendi FB20070531
		gelen company_id veya consumer_id ye gore kayit atiyor--->

		<cfloop index="i" from="1" to="#attributes.record_num#">  
			<cflock timeout="60">
				<cftransaction>
					<cfif len(evaluate("attributes.wrk_row_id#i#"))>
						<cfif evaluate("attributes.row_kontrol#i#")>
							<cfquery name="upd_emp_par" datasource="#dsn#">
								UPDATE
									WORKGROUP_EMP_PAR
								SET
									ROLE_ID = <cfif len(evaluate("attributes.get_role#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.get_role#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
									EMPLOYEE_ID = #evaluate("attributes.employee_id#i#")#,
									MAIN_EMPLOYEE_ID = #attributes.MAIN_EMPLOYEE_ID#,
									UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
									UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								WHERE
									WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.wrk_row_id#i#')#">
							</cfquery>
						<cfelse>
							<!--- Guncelleme ekraninda olup - tusu ile silinen kayitlar --->
							<cfquery name="del_emp_par" datasource="#dsn#">
								DELETE FROM
									WORKGROUP_EMP_PAR
								WHERE
									WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.wrk_row_id#i#')#">
							</cfquery>
						</cfif>
					<cfelse>
						<cfquery name="add_worker_emp" datasource="#DSN#">
							INSERT INTO 
								WORKGROUP_EMP_PAR
							(
								MAIN_EMPLOYEE_ID,
								ROLE_ID,
								EMPLOYEE_ID,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE
							)
							VALUES
							(
								#attributes.MAIN_EMPLOYEE_ID#,
								<cfif len(evaluate("attributes.get_role#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.get_role#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
								<cfif len(evaluate("attributes.employee_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_id#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							)
						</cfquery>
					</cfif>
				</cftransaction>
			</cflock>
	</cfloop>
	
	<script type="text/javascript">
	location.href=document.referrer
	wrk_opener_reload();
	window.close();
	</script>
	