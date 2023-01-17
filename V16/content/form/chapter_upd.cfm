<cfoutput query="chapter_list">
	<cfif listlen(hierarchy) is 1>
        <i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i> <cfif hierarchy eq get_chapter.hierarchy><strong>#chapter#</strong><cfelse>#chapter#</cfif><br/>
    <cfelseif listlen(hierarchy) is 2>
        <i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i> <cfif hierarchy eq get_chapter.hierarchy><strong>#chapter#</strong><cfelse>#chapter#</cfif><br/>
    <cfelseif listlen(hierarchy) is 3>
        <i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i> <cfif hierarchy eq get_chapter.hierarchy><strong>#chapter#</strong><cfelse>#chapter#</cfif><br/>
    <cfelseif listlen(hierarchy) is 4>
        <i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i> <cfif hierarchy eq get_chapter.hierarchy><strong>#chapter#</strong><cfelse>#chapter#</cfif><br/>
    </cfif>
</cfoutput>
