<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT
		SZ_NAME,
		OZEL_KOD
	FROM
		SALES_ZONES
	WHERE
		(SZ_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sz_name#"> <cfif len(attributes.ozel_kod)>OR OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#"></cfif>)
</cfquery>
<cfif get_sales_zones.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='192.Bu Bölge Adına veya Özel Koda Ait Kayıt Vardır Lütfen Kontrol Ediniz'>!");
		history.back();
  	</script>
	<cfabort>
</cfif>

<cfset main_sz_id = listlast(attributes.sz_hierarchy, ',')>
<cfset main_sz_hierarchy = listfirst(attributes.sz_hierarchy, ',')>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SALES_ZONE" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				SALES_ZONES
				(
					SZ_DETAIL,
					KEY_ACCOUNT_ID,
					RESPONSIBLE_BRANCH_ID,
					RESPONSIBLE_POSITION_CODE,
					RESPONSIBLE_PAR_ID,
					RESPONSIBLE_COMPANY_ID,
					SZ_NAME,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					SALES_ZONE,
					OZEL_KOD,
					IS_ACTIVE
				)
				VALUES
				(
					<cfif isDefined("attributes.sz_detail")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sz_detail#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
					<cfif len(attributes.key_account_id) and len(attributes.key_account)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.key_account_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
					<cfif len(attributes.responsible_branch) and (attributes.responsible_branch_id neq 0)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.responsible_branch_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
					<cfif len(attributes.responsible_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.responsible_position_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
					<cfif len(attributes.responsible_par) and len(attributes.responsible_par_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.responsible_par_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
					<cfif len(attributes.responsible_company) and len(attributes.responsible_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.responsible_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sz_name#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">,
					<cfif isdefined('attributes.is_active')><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>
				)
		</cfquery>
		<cfquery name="UPD_SALES_ZONE_HIERARCHY" datasource="#dsn#">
			UPDATE
				SALES_ZONES
			SET
				SZ_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#main_sz_hierarchy#.#MAX_ID.IDENTITYCOL#">
			WHERE
				SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
		</cfquery>
		<cfif main_sz_hierarchy neq 0>
			<cfset search_sz_ids = main_sz_hierarchy>
			<cfloop from="1" to="#listlen(main_sz_hierarchy, '.')#" index="i">
				<cfquery name="GET_SZ_ID" datasource="#dsn#">
					SELECT SZ_ID FROM SALES_ZONES WHERE SZ_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#search_sz_ids#">
				</cfquery>
				<cfif get_sz_id.recordcount>
					<cfquery name="ADD_HIERARCHY" datasource="#dsn#">
						INSERT INTO
							SALES_ZONES_HIERARCHY						
							(
								MAIN_SZ_ID,
								SUB_SZ_ID
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_sz_id.sz_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
							)
					</cfquery>
				</cfif>
				<cfset search_sz_ids = listdeleteat(search_sz_ids,((listlen(main_sz_hierarchy, '.')+1)-i), '.')>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cfset attributes.actionId = MAX_ID.IDENTITYCOL>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
