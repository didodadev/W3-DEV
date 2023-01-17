<cfif attributes.record_type eq 1>
	<cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	SEARCH_LISTS
        SET
            UPDATE_DATE = #now()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.remote_addr#'
    	WHERE
        	LIST_ID = #attributes.list_id#
    </cfquery>
    <cfquery name="del_rows" datasource="#dsn_dev#">
    	DELETE FROM SEARCH_LISTS_ROWS WHERE LIST_ID = #attributes.list_id#
    </cfquery>
    <cfloop from="1" to="#listlen(attributes.list_all_product_list)#" index="ccc">
    	<cfset p_id_ = listgetat(attributes.list_all_product_list,ccc)>
        <cfquery name="add_" datasource="#dsn_dev#">
        	INSERT INTO
            	SEARCH_LISTS_ROWS
                (
                LIST_ID,
                PRODUCT_ID,
                LINE_NUMBER
                )
                VALUES
                (
                #attributes.list_id#,
                #p_id_#,
                #ccc#
                )
        </cfquery>
    </cfloop>
<cfelse>
	<cfquery name="add_" datasource="#dsn_dev#" result="sonuc">
    	INSERT INTO
        	SEARCH_LISTS
            (
            LIST_NAME,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
            )
            VALUES
            (
            '#attributes.list_name#',
            #now()#,
            #session.ep.userid#,
            '#cgi.remote_addr#'
            )
    </cfquery>
    <cfloop from="1" to="#listlen(attributes.list_all_product_list)#" index="ccc">
    	<cfset p_id_ = listgetat(attributes.list_all_product_list,ccc)>
        <cfquery name="add_" datasource="#dsn_dev#">
        	INSERT INTO
            	SEARCH_LISTS_ROWS
                (
                LIST_ID,
                PRODUCT_ID,
                LINE_NUMBER
                )
                VALUES
                (
                #sonuc.identitycol#,
                #p_id_#,
                #ccc#
                )
        </cfquery>
    </cfloop>
    <cfset attributes.list_id = sonuc.identitycol>
</cfif>
Kayıt Edildi.