<cfquery name="GET_VEHICLE_CAT" datasource="#DSN#">
	SELECT 
		ASSETP_CATID,
 		ASSETP_CAT
	FROM
		ASSET_P_CAT
	WHERE
		MOTORIZED_VEHICLE = 1
	ORDER BY
		ASSETP_CAT
</cfquery>
