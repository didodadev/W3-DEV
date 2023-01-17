<cfif attributes.record_type eq 2>
    <cfquery name="add_" datasource="#dsn_dev#">
        UPDATE
        	SEARCH_TABLES_LAYOUTS
        SET
            HIDE_COLS = '#attributes.form_page_hide_col_list#',
            SORT_LIST = '#attributes.form_page_col_sort_list#',
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
            SEARCH_TABLES_LAYOUTS
            (
            LAYOUT_NAME,
            HIDE_COLS,
            SORT_LIST,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
            )
            VALUES
            (
            '#attributes.layout_name#',
            '#attributes.form_page_hide_col_list#',
            '#attributes.form_page_col_sort_list#',
            #NOW()#,
            #session.ep.userid#,
            '#cgi.REMOTE_ADDR#'
            )
    </cfquery>
    <cfset attributes.layout_id = donen.IDENTITYCOL>
</cfif>