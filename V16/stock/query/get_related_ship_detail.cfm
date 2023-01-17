<!--- irsaliyeye cekilmis konsinye irsaliyeleri getirir --->
<cfscript>
	pre_period_related_ships='';
	pre_period_id='';
	actif_period_related_ships='';
	related_ship_id_with_period='';
	related_ship_numbers='';
	to_ship_id_list_='';
</cfscript>

<cfquery name="GET_SHIP_RELATION" datasource="#dsn2#">
	SELECT
		FROM_SHIP_ID,
		FROM_SHIP_PERIOD
	FROM
		SHIP_TO_SHIP
	WHERE
		TO_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#">
</cfquery>
<!--- faturaya cekilen irsaliyeler ve bu irsaliyelerin period_id lerini tutar --->
<cfset related_ship_id_with_period = "">
<cfset related_ship_project_id_with_period = "">
<cfloop query="GET_SHIP_RELATION">
	<cfquery name="GET_PERIOD_INFO" datasource="#DSN#">
		SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#from_ship_period#">
	</cfquery>
	<cfquery name="GET_SHIP_INFO" datasource="#DSN2#">
		SELECT ISNULL(PROJECT_ID,0) PROJECT_ID FROM #dsn#_#get_period_info.period_year#_#session.ep.company_id#.SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_relation.from_ship_id#">
	</cfquery>
	<cfif from_ship_period neq session.ep.period_id>
		<cfset pre_period_related_ships = listappend(pre_period_related_ships,get_ship_relation.from_ship_id)>
		<cfset pre_period_id=get_ship_relation.from_ship_period>
	<cfelse>
		<cfset actif_period_related_ships= listappend(actif_period_related_ships,get_ship_relation.from_ship_id)>
	</cfif>
	<cfset related_ship_project_id_with_period = listappend(related_ship_project_id_with_period,'#get_ship_info.project_id#')>
	<cfset related_ship_id_with_period = listappend(related_ship_id_with_period,'#get_ship_relation.from_ship_id#;#get_ship_relation.from_ship_period#')>
</cfloop>

<cfif len(actif_period_related_ships)> <!--- aktif donemdeki ilişkili irsaliye bilgileri alınıyor --->
	<cfquery name="GET_CONSIGMENT_IRS" datasource="#DSN2#">
		SELECT DISTINCT SHIP_NUMBER,SHIP_ID FROM SHIP WHERE SHIP_ID IN (#actif_period_related_ships#) ORDER BY SHIP_ID
	</cfquery>
	<cfset related_ship_numbers=valuelist(GET_CONSIGMENT_IRS.SHIP_NUMBER)>
</cfif>
<cfif len(pre_period_related_ships) and len(pre_period_id)> <!--- varsa onceki donemden cekilmis irsaliyeleri getiriyor--->
	<cfquery name="GET_PERIOD" datasource="#DSN2#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID= #pre_period_id# AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery> 
	<cfif GET_PERIOD.recordcount>
		<cfset pre_period_dsn = '#dsn#_#GET_PERIOD.PERIOD_YEAR#_#GET_PERIOD.OUR_COMPANY_ID#'>
		<cfquery name="GET_CONSIGMENT_IRS2" datasource="#DSN2#">
			SELECT DISTINCT SHIP_NUMBER,SHIP_ID FROM #pre_period_dsn#.SHIP WHERE SHIP_ID IN (#pre_period_related_ships#) ORDER BY SHIP_ID
		</cfquery>
		<cfset related_ship_numbers=listappend(related_ship_numbers,valuelist(GET_CONSIGMENT_IRS2.SHIP_NUMBER))>
	</cfif>
</cfif>
<!--- irsaliyeden olusturulmus baska irsaliye varmı kontrol ediliyor --->
<cfquery name="CONTROL_SHIP_TO_SHIP" datasource="#DSN2#">
	SELECT
		S.SHIP_ID,
		S.SHIP_NUMBER
	FROM
		SHIP_TO_SHIP STS,
		SHIP S
	WHERE
		STS.TO_SHIP_ID = S.SHIP_ID
		AND STS.FROM_SHIP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#">
		AND STS.FROM_SHIP_PERIOD=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">

	UNION ALL

	SELECT
		S.SHIP_ID,
		S.SHIP_NUMBER
	FROM
		SHIP_TO_SHIP STS,
		SHIP S
	WHERE
		STS.FROM_SHIP_ID = S.SHIP_ID
		AND STS.TO_SHIP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#">
		AND STS.FROM_SHIP_PERIOD=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfset to_ship_id_list_ = listdeleteduplicates(valuelist(control_ship_to_ship.ship_number))>


