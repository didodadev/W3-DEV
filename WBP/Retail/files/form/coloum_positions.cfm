<cfif len(attributes.layout_id)>
    <cfquery name="get_layout" datasource="#dsn_dev#">
        SELECT
            *
        FROM
            SEARCH_TABLES_LAYOUTS
        WHERE
            LAYOUT_ID = #attributes.layout_id#
    </cfquery>
    <cfset page_col_sort_list = get_layout.SORT_LIST>
    <cfset hide_col_list_numeric = listsort(get_layout.HIDE_COLS,'numeric','ASC')>
    <cfset kolon_sira = replace(page_col_sort_list,'kolon_','','all')>
    <cfif len(hide_col_list_numeric)>
    	<cfset hide_col_list = 'kolon_' & replace(hide_col_list_numeric,',',',kolon_','all')>
        <cfset hide_col_list_numeric = ',' & replace(hide_col_list_numeric,',',',,','all') & ','>
        <cfset hide_col_list_numeric = listsort(hide_col_list_numeric,'numeric')>
    <cfelse>
    	<cfset hide_col_list = "">
    </cfif>
<cfelse>
    <cfset kolon_sira = "7,8,50,1,2,3,4,5,65,66,67,59,9,58,57,71,14,15,64,74,73,62,47,19,6,63,61,45,60,24,25,72,10,43,28,29,68,44,20,21,12,26,48,69,70,23,13,11,30,31,46,42,49,16,18,17,33,40,22,32,36,34,35,51,53,55,56,39,37,38,52,54,27,41,75,76">
    <cfset page_col_sort_list = "">
    <cfloop from="1" to="76" index="ccc">
        <cfset page_col_sort_list = listappend(page_col_sort_list,'kolon_#ccc#')>
    </cfloop>
    <cfset hide_col_list = "">
    <cfset hide_col_list_numeric = "">
</cfif>