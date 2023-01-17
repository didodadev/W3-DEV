<cfif isdefined("event_id") and event_id IS 0>
  <cfquery name="GET_ASSETP_CATS_RESERVE" datasource="#DSN#">
	  SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT
  </cfquery>
<cfelse>
  <cfquery name="GET_ASSETP_CATS_RESERVE" datasource="#DSN#">
	  SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE ASSETP_RESERVE = 1
  </cfquery>
</cfif>

