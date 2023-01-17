<cfset is_company_upd = true>
<cfquery name="GET_HIERARCHIES" datasource="#dsn#">
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
<cfif GET_HIERARCHIES.recordcount>
	<!--- satis bolgelerine ait yetki varsa (bolge yonetici veya satis grubu) satis bolgelerine hiyerarsi ile bakmali --->
	<cfquery name="GET_SALES_ZONES" datasource="#dsn#">
		SELECT
			SZ_ID,
			SZ_NAME,
			SZ_HIERARCHY
		FROM
			SALES_ZONES
		WHERE
			<cfloop query="GET_HIERARCHIES"><cfif GET_HIERARCHIES.currentrow gt 1>OR</cfif> SALES_ZONES.SZ_HIERARCHY+'.' LIKE '#GET_HIERARCHIES.SZ_HIERARCHY#%'</cfloop>
		ORDER BY
			SZ_HIERARCHY
	</cfquery>
<cfelse>
	<cfset GET_SALES_ZONES.recordcount = 0>
</cfif>
<cfquery name="get_comp_upd" datasource="#dsn#">
	SELECT
		COMPANY.COMPANY_ID
	FROM
		COMPANY
	WHERE
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		(
			COMPANY.IMS_CODE_ID IN
				(
				SELECT
					SIMS.IMS_CODE_ID
				FROM
					SETUP_IMS_CODE SIMS,
					SALES_ZONES_TEAM SZT,
					SALES_ZONES_TEAM_IMS_CODE SZIMS,
					SALES_ZONES_TEAM_ROLES SZTR
				WHERE
					SIMS.IMS_CODE_ID = SZIMS.IMS_ID
					AND SZIMS.TEAM_ID = SZT.TEAM_ID
					AND SZTR.TEAM_ID = SZT.TEAM_ID
					AND SZTR.POSITION_CODE = #session.ep.position_code#
				)
		OR
			COMPANY.COMPANY_ID IN
				(
				SELECT
					COMPANY_ID
				FROM
					COMPANY_BRANCH_RELATED
				WHERE
					MUSTERIDURUM IS NOT NULL AND
					OUR_COMPANY_ID = #session.ep.company_id# AND
					(
						ZONE_DIRECTOR = #session.ep.position_code# OR
						TEL_SALE_PREID = #session.ep.position_code# OR
						PLASIYER_ID = #session.ep.position_code#
					)
				)
	<cfif GET_SALES_ZONES.recordcount><!--- sadece satis bolgelerine ait yetki varsa satis bolgelerinden hareketle IMS bakmali --->
		OR
			COMPANY.IMS_CODE_ID IN
			(
			SELECT
				SIMS.IMS_CODE_ID
			FROM
				SETUP_IMS_CODE SIMS,
				SALES_ZONES SZ,
				SALES_ZONES_TEAM SZT,
				SALES_ZONES_TEAM_IMS_CODE SZIMS
			WHERE
				SIMS.IMS_CODE_ID = SZIMS.IMS_ID AND
				SZIMS.TEAM_ID = SZT.TEAM_ID AND
				SZ.SZ_ID = SZT.SALES_ZONES AND
				SZ.SZ_ID IN (#valuelist(GET_SALES_ZONES.SZ_ID)#)
			)
	</cfif>
	)
</cfquery>
<cfif not get_comp_upd.recordcount>
	<cfset is_company_upd = false>
</cfif>
