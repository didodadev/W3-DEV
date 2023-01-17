<cfquery name="get_search_lists" datasource="#dsn_dev#">
	SELECT
    	LIST_ID,
        LIST_NAME
    FROM
    	SEARCH_LISTS
    ORDER BY
    	LIST_NAME
</cfquery>
<select name="search_list_id" id="search_list_id">
    <option value="">Seçiniz</option>
    <cfoutput query="get_search_lists">
        <option value="#list_id#" <cfif isdefined("attributes.search_list_id") and attributes.search_list_id eq list_id>selected</cfif>>#list_name#</option>
    </cfoutput>
</select>