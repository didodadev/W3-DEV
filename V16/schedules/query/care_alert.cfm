<cfquery name="GET_NET_KM" datasource="#DSN#">
	SELECT
		(SUM(KM_FINISH - KM_START) - FIRST_KM) AS NET_KM, ASSET_P.ASSETP_ID
	FROM 
		ASSET_P_KM_CONTROL,
		ASSET_P
	WHERE
		ASSET_P.ASSETP_ID = #attributes.assetp_id#
		AND ASSET_P.ASSETP_ID = ASSET_P_KM_CONTROL.ASSETP_ID
		AND ASSET_P_KM_CONTROL.KM_FINISH IS NOT NULL
	GROUP BY 
		ASSETP,
		FIRST_KM,
		ASSET_P.ASSETP_ID
</cfquery>
<cfquery name="GET_NET_SURE" datasource="#DSN#" maxrows="1">
 	SELECT 
		DATEDIFF(DAY,SUP_COMPANY_ID,FINISH_DATE) AS NET_SURE
	FROM 
		ASSET_P_KM_CONTROL,
		ASSET_P
	WHERE
		ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#
		ASSET_P_KM_CONTROL.ASSETP_ID = ASSET_P.ASSETP_ID
	ORDER BY
		FINISH_DATE DESC
 </cfquery>
 <cfset ortalama_km = get_net_km.net_km / get_net_sure.net_sure>
 <cfquery name="GET_SON_CARE_KM" datasource="#DSN#">
 	SELECT
		MAX(CARE_KM) AS MAX_CARE_KM
	FROM
		ASSET_CARE_REPORT
	WHERE 
		ASSETP_ID = #attributes.assetp_id#
 </cfquery>
 <cfquery name="GET_PERIOD_KM" datasource="#DSN#">
 	SELECT 
		MAX(PERIOD_KM) AS PERIOD_KM
	FROM
		ASSET_P_CARE_REFERENCE
</cfquery>
<cfquery name="GET_LAST_KM" datasource="#DSN#">
	SELECT 
		MAX(KM_FINISH) AS SON_KM
	FROM
		ASSET_P_KM_CONTROL 
	WHERE
		ASSSETP_ID = #attributes.assetp_id#
</cfquery>
<cfset yeni_bakim_km = get_period_km.period_km + get_son_care_km.max_care_km>
<cfset uyari_gunu = (yeni_bakim_km - get_last_km.son_km) / ortalama_km>

 
