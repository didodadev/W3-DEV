<cf_xml_page_edit fuseact="assetcare.vehicle_detail">
<cfparam name="get_vehicles.property" default="">
<cfif not isnumeric(attributes.assetp_id)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfquery name="GET_ASSETP" datasource="#DSN#">
	SELECT 
		ASSET_P.ASSETP,
		ASSET_P.PROPERTY,
		ASSET_P_CAT.MOTORIZED_VEHICLE,
		ASSET_P_CAT.ASSETP_RESERVE,
        ASSET_P.ASSETP_CATID
	FROM
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#"> AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
</cfquery>
