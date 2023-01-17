<cfquery name="GET_PARTNER" datasource="#dsn#">
   SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
</cfquery>
<cfif get_partner.recordcount>
	<cfif not isDefined('attributes.station_id')>
		<cfquery name="GET_WORKSTATIONS" datasource="#dsn#">
			SELECT
				WORKSTATIONS.STATION_ID,
				WORKSTATIONS.STATION_NAME,
				WORKSTATIONS.OUTSOURCE_PARTNER,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES.EMPLOYEE_ID,
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME
			FROM
				#dsn3_alias#.WORKSTATIONS AS WORKSTATIONS,
				EMPLOYEES AS EMPLOYEES,
				BRANCH AS BRANCH
			WHERE
				WORKSTATIONS.EMP_ID LIKE '%,' + CAST(EMPLOYEES.EMPLOYEE_ID AS NVARCHAR) + ',%' AND
				WORKSTATIONS.BRANCH = BRANCH.BRANCH_ID
				<cfif isdefined("attributes.up_search") and len(attributes.up_search)>AND WORKSTATIONS.UP_STATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.up_search#"> AND</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND WORKSTATIONS.BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"></cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND WORKSTATIONS.STATION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>	
				<cfif isdefined("attributes.is_active") and len(attributes.is_active)>AND WORKSTATIONS.ACTIVE = <cfqueryparam cfsqltype="cf_sql_bigint" value="#attributes.is_active#"></cfif>
				<cfif get_partner.recordcount>AND WORKSTATIONS.OUTSOURCE_PARTNER IN (#valuelist(get_partner.partner_id,',')#)</cfif>
			ORDER BY
				WORKSTATIONS.STATION_NAME
		</cfquery>
	<cfelse>
		<cfquery name="GET_WORKSTATIONS" datasource="#dsn#">
			SELECT 
				WORKSTATIONS.STATION_ID,
				WORKSTATIONS.STATION_NAME,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES.EMPLOYEE_ID
			FROM
				#dsn3_alias#.WORKSTATIONS AS WORKSTATIONS,
				EMPLOYEES AS EMPLOYEES
			WHERE
				WORKSTATIONS.EMP_ID LIKE '%,' + CAST(EMPLOYEES.EMPLOYEE_ID AS NVARCHAR) + ',%' AND
				<cfif isdefined('attributes.station_id')>AND WORKSTATIONS.UP_STATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#"></cfif>
				<cfif isdefined('attributes.station_id')>AND WORKSTATIONS.STATION_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#"></cfif>
				<cfif get_partner.recordcount>AND WORKSTATIONS.OUTSOURCE_PARTNER IN (#valuelist(get_partner.partner_id,',')#)</cfif>
			GROUP BY
				WORKSTATIONS.STATION_ID,
				WORKSTATIONS.STATION_NAME,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES.EMPLOYEE_ID
		</cfquery>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='15.Seçtiğiniz Üyenin Kayıtlı Çalışanı Yoktur ! Önce Çalışan Ekleyiniz !'>");
		window.close();
	</script>
	<cfabort>
</cfif>
