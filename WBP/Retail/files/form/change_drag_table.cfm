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
<cfset hide_col_list_numeric_ilk = listsort(get_layout.HIDE_COLS,'numeric','ASC')>
<cfset kolon_sira = "['" & replace(page_col_sort_list,",","','","all") & "']">
<cfif len(hide_col_list_numeric)>
	<cfset hide_col_list = 'kolon_' & replace(hide_col_list_numeric,',',',kolon_','all')>
	<cfset hide_col_list_numeric = ',' & replace(hide_col_list_numeric,',',',,','all') & ','>
	<cfset hide_col_list_numeric = listsort(hide_col_list_numeric,'numeric')>
<cfelse>
	<cfset hide_col_list = "">
</cfif>
<script>
hide_col_list_numeric_ilk = <cfoutput>'#hide_col_list_numeric_ilk#'</cfoutput>;
	$('#manage_table').dragtable('order',<cfoutput>#kolon_sira#</cfoutput>);
	for (var col=1; col <= 76; col++)
	{
		rel_ = "rel='kolon_" + col + "'";
		col1 = $("#manage_table tr th[" + rel_ + "]");
		col2 = $("#manage_table tr td[" + rel_ + "]");	
		
		if(hide_col_list_numeric_ilk != '' && list_find(hide_col_list_numeric_ilk,col))
		{
		col1.hide();
		col2.hide();
		}
		else
		{
		col1.show();
		col2.show();	
		}
	}
	document.getElementById('page_hide_col_list').value = '<cfoutput>#hide_col_list_numeric#</cfoutput>';
	document.getElementById('page_col_sort_list').value = '<cfoutput>#page_col_sort_list#</cfoutput>';
	document.info_form.layout_id.value = '<cfoutput>#attributes.layout_id#</cfoutput>';
	hide('message_div_main');
	//hide_col_list
</script>