<cfquery name="DEL_" datasource="#dsn_dev#">
	DELETE FROM SEARCH_TABLES_DEFINES
</cfquery>

<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	SEARCH_TABLES_DEFINES
        (
        LAYOUT_ID,
        ORDER_LAYOUT_ID,
        HOVER_COLOR,
        ROW_FOCUS_COLOR,
        FOCUS_COLOR,
        GROUP_COLOR,
        GROUP_FONT_COLOR,
        STOCK_COLOR,
        DEPARTMENT_COLOR,
        ACTIVE_PRICE_COLOR,
        NEXT_PRICE_COLOR,
        ORDER_DAY
        )
        VALUES
        (
        <cfif len(attributes.layout_id)>#attributes.layout_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.order_layout_id)>#attributes.order_layout_id#<cfelse>NULL</cfif>,
        '#attributes.HOVER_COLOR#',
        '#attributes.ROW_FOCUS_COLOR#',
        '#attributes.FOCUS_COLOR#',
        '#attributes.GROUP_COLOR#',
        '#attributes.GROUP_FONT_COLOR#',
        '#attributes.STOCK_COLOR#',
        '#attributes.DEPARTMENT_COLOR#',
        '#attributes.ACTIVE_PRICE_COLOR#',
        '#attributes.NEXT_PRICE_COLOR#',
        #attributes.order_day#
        )
</cfquery>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=retail.table_b2b_user</cfoutput>";
</script>