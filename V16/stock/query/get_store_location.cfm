<!------bu sorgu upd_fis ve satis icin kullanılacak ...------->
<cfif isDefined('attributes.loc_id') and len(attributes.loc_id)>
	<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
		SELECT  
			D.DEPARTMENT_HEAD,
			SL.COMMENT
		FROM 
			DEPARTMENT D,
			STOCKS_LOCATION SL
		WHERE 
			D.IS_STORE=1
			AND D.DEPARTMENT_ID =SL.DEPARTMENT_ID
			AND SL.LOCATION_ID=#attributes.loc_id#  
			AND SL.DEPARTMENT_ID=#attributes.department_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
		SELECT  
			D.DEPARTMENT_HEAD,
			'' AS COMMENT
		FROM 
			DEPARTMENT D
		WHERE 
			D.IS_STORE=1
			AND D.DEPARTMENT_ID = #attributes.department_id#
	</cfquery>
</cfif>

