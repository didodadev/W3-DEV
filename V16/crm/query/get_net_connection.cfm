<cfquery name="GET_NET_CONNECTION" datasource="#dsn#">
	SELECT CONNECTION_ID, CONNECTION_NAME FROM SETUP_NET_CONNECTION ORDER BY CONNECTION_ID
</cfquery>
<cfquery name="GET_PC_NUMBER" datasource="#dsn#">
	SELECT UNIT_ID, UNIT_NAME FROM SETUP_PC_NUMBER ORDER BY UNIT_ID
</cfquery>
<cfquery name="GET_ZONE" datasource="#dsn#">
	SELECT ZONE_ID, ZONE_NAME FROM ZONE ORDER BY ZONE_NAME
</cfquery>
<cfquery name="GET_MOBILCAT" datasource="#dsn#">
	SELECT MOBILCAT_ID, MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT
</cfquery>
<cfquery name="GET_CITY" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_HOBBY" datasource="#dsn#">
	SELECT HOBBY_ID, HOBBY_NAME FROM SETUP_HOBBY ORDER BY HOBBY_NAME
</cfquery>
<cfquery name="GET_UNIVERSTY" datasource="#dsn#">
	SELECT UNIVERSITY_ID, UNIVERSITY_NAME FROM SETUP_UNIVERSITY ORDER BY UNIVERSITY_NAME
</cfquery>
<cfquery name="GET_CUSTS" datasource="#dsn#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT_ID
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>