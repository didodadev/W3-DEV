<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.is_delete') and attributes.is_delete eq 1>
    <cfquery name="DEL_COMMENT" datasource="#attributes.data_source#">
    DELETE 
    FROM
        #attributes.table_name#
    WHERE
        #attributes.col_comment_id# = #attributes.upd_row_id#
    </cfquery>
<cfelse>
    <cfquery name="UPD_COMMENT" datasource="#attributes.data_source#">
        UPDATE 
            #attributes.table_name#
        SET
            #attributes.col_name# = '#attributes.upd_comment#'
        WHERE
            #attributes.col_comment_id# =#attributes.upd_row_id#
    </cfquery>
</cfif>

