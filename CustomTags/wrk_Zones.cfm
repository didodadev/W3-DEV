<!---wrk_Zones Bolge Filtresi Customtag i 20110110 H.guL --->
<cfparam name="attributes.fieldId" default="action_type"><!--- alan adı --->
<cfparam name="attributes.width" default="100"><!--- genişlik --->
<cfparam name="attributes.selected_value" default=""><!--- Liste sayfaları için form değeri --->
<!--- 
Kullanimi : <cf_wrk_Zones fieldId='zone_id' selected_value='#attributes.zone_id#'>
 --->
<cfquery name="GET_ZONES" datasource="#CALLER.DSN#">
	SELECT
		ZONE_ID,
		ZONE_NAME
	FROM
		ZONE
	WHERE
		ZONE_ID IS NOT NULL AND 
        ZONE_STATUS = 1
	ORDER BY
		ZONE_NAME
</cfquery>
<cfoutput>
	<select name="#attributes.fieldId#" id="#attributes.fieldId#">
		<option value="" selected>#caller.getLang('main',580)#</option>  <!---Bölge--->
		<cfloop query="get_zones">
			<option value="#zone_id#" <cfif listfind(attributes.selected_value,get_zones.zone_id)>selected</cfif>>#get_zones.zone_name#</option>
		</cfloop>
	</select>
</cfoutput>

