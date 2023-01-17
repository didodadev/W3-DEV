<cfquery name="GET_INS" datasource="#DSN#">
SELECT ASSETP_ID FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id# 
</cfquery>
