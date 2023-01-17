<cfset attributes.mode = 6>
<cfquery name="get_headers" datasource="#dsn_dev#">
    SELECT  *,1 AS KOLON_SHOW FROM SEARCH_TABLES_COLOUMS ORDER BY ROW_ID ASC
</cfquery>

<cfif len(attributes.layout_id)>
	<cfquery name="get_layout_info" datasource="#dsn_dev#">
    	SELECT * FROM SEARCH_TABLES_LAYOUTS_NEW WHERE LAYOUT_ID = #attributes.layout_id#
    </cfquery>
    <cfif get_layout_info.recordcount and len(get_layout_info.sort_list)>
    		<cfset sort_list = get_layout_info.sort_list>
            
            <cfoutput query="get_headers">
                <cfset sira_ = row_id>

                <cfif sira_ lte listlen(sort_list)>
                	<cfset ozellik_ = listgetat(sort_list,sira_)>
                    
                    <cfset row_sira_ = listgetat(ozellik_,2,'*')>
                    <cfset row_show_ = listgetat(ozellik_,3,'*')>
                    
                    <cfif row_show_ is 'hide'>
                   			<cfset querysetcell(get_headers,'KOLON_SHOW','0',currentrow)>
                    <cfelse>
                    		<cfset querysetcell(get_headers,'KOLON_SHOW','1',currentrow)>
                    </cfif>
                </cfif>
            </cfoutput>
    </cfif>
</cfif>

<table width="100%" cellpadding="5" cellspacing="5">
<cfoutput query="get_headers">
    <cfif currentrow eq 1 or currentrow  mod attributes.mode eq 1><tr></cfif>
        <td width="#100/attributes.mode#%">
            <input type="checkbox" name="sh_#kolon_ad#" id="sh_#kolon_ad#" <cfif KOLON_SHOW eq 1>checked</cfif> onclick="change_table_col_sh('#kolon_ad#');">
            #replace(kolon_ozelad,'<br>','','all')#
        </td>
    <cfif currentrow eq get_headers.recordcount or currentrow  mod attributes.mode eq 0></tr></cfif>
 </cfoutput>
</table>
