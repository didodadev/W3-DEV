<cfif attributes.record_type eq 2>
    <cfquery name="add_" datasource="#dsn_dev#">
        UPDATE
        	SEARCH_TABLES_LAYOUTS_NEW
        SET
            SORT_LIST = '#attributes.sort_list#',
            UPDATE_DATE = #NOW()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.REMOTE_ADDR#'
        WHERE
        	LAYOUT_ID = #attributes.old_layout_id#   
    </cfquery>
    <cfset attributes.layout_id = attributes.old_layout_id>
<cfelse>
	<cfquery name="add_" datasource="#dsn_dev#" result="donen">
        INSERT INTO
            SEARCH_TABLES_LAYOUTS_NEW
            (
            LAYOUT_NAME,
            SORT_LIST,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
            )
            VALUES
            (
            '#attributes.layout_name#',
            '#attributes.sort_list#',
            #NOW()#,
            #session.ep.userid#,
            '#cgi.REMOTE_ADDR#'
            )
    </cfquery>
    <cfset attributes.layout_id = donen.IDENTITYCOL>
</cfif>