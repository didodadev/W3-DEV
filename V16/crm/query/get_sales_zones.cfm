<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ,
		SALES_ZONE_GROUP SZG
	WHERE
		SZG.SZ_ID = SZ.SZ_ID AND
		SZG.POSITION_CODE = #session.ep.position_code#
	UNION
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ
	WHERE
		SZ.RESPONSIBLE_POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT
		SZ_ID,
		SZ_NAME,
		SZ_HIERARCHY
	FROM
		SALES_ZONES
	WHERE 
		SALES_ZONES.SZ_ID IN
				(
				SELECT
					SZ.SZ_ID
				FROM
					SETUP_IMS_CODE SIMS,
					SALES_ZONES SZ,
					SALES_ZONES_TEAM SZT,
					SALES_ZONES_TEAM_IMS_CODE SZIMS,
					SALES_ZONES_TEAM_ROLES SZTR
				WHERE
					SIMS.IMS_CODE_ID = SZIMS.IMS_ID
					AND SZIMS.TEAM_ID = SZT.TEAM_ID
					AND SZTR.TEAM_ID = SZT.TEAM_ID
					AND SZ.SZ_ID = SZT.SALES_ZONES
					AND SZTR.POSITION_CODE = #session.ep.position_code#
				)
		<cfif get_hierarchies.recordcount>
			<cfloop query="get_hierarchies"> OR SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy#%'</cfloop>
		</cfif>
	ORDER BY
		SZ_HIERARCHY
</cfquery>
