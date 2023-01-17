<!--- Yetkili olunan satirlarda islem yapilmasi icin eklendi FB20070531
		gelen company_id veya consumer_id ye gore kayit atiyor--->
<cfloop index="i" from="1" to="#attributes.record_number#">  
	<cfif evaluate("attributes.authorized#i#") neq 0>
		<cflock timeout="60">
			<cftransaction>
				<cfif evaluate("attributes.authorized#i#") neq 0 and len(evaluate("attributes.wrk_row_id#i#"))>
					<cfif evaluate("attributes.row_kontrol#i#")>
						<cfquery name="upd_emp_par" datasource="#dsn#">
							UPDATE
								WORKGROUP_EMP_PAR
							SET
							<cfif len(attributes.company_id)>
								COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
							<cfelseif len(attributes.consumer_id)>
								CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">,
							</cfif>
								OUR_COMPANY_ID = <cfif len(evaluate("attributes.our_company_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.our_company_id#i#')#">,</cfif>
								POSITION_CODE = <cfif len(evaluate("attributes.position_code#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
								PARTNER_ID = <cfif len(evaluate("attributes.partner_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.partner_id#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
								ROLE_ID = <cfif len(evaluate("attributes.get_role#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.get_role#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
								IS_MASTER = <cfif isdefined("attributes.is_master#i#")>1<cfelse>0</cfif>,
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
				<cfelseif evaluate("attributes.authorized#i#") neq 0 and evaluate("attributes.row_kontrol#i#")>
					<cfquery name="add_worker_emp" datasource="#DSN#">
						INSERT INTO 
							WORKGROUP_EMP_PAR
						(
							COMPANY_ID,
							CONSUMER_ID,
							OUR_COMPANY_ID,
							POSITION_CODE,
							PARTNER_ID,
							ROLE_ID,
							IS_MASTER,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
						VALUES
						(
							<cfif len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
							<cfif len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
							<cfif len(evaluate("attributes.our_company_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.our_company_id#i#')#"></cfif>,
							<cfif len(evaluate("attributes.position_code#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
							<cfif len(evaluate("attributes.partner_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.partner_id#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
							<cfif len(evaluate("attributes.get_role#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.get_role#i#')#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_varchar"></cfif>,
							<cfif isdefined("attributes.is_master#i#")>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery>
				</cfif>
			</cftransaction>
		</cflock>
	</cfif>
</cfloop>

<script type="text/javascript">
	location.href = document.referrer;
</script>
