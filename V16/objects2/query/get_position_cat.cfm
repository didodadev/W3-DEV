<cfquery name="GET_POSITION_CAT" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT 
	WHERE 
		POSITION_CAT_ID IN (#ListSort(attributes.position_cat_id,"numeric")#)
</cfquery>
