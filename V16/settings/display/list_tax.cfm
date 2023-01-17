<cfset gtax = createObject("component","V16.settings.cfc.tax")/>
<cfset get_tax= gtax.Select()/>	
<table>
    <cfif get_tax.recordcount>
		<cfset tax_list=''>
        <cfoutput query="get_tax">
			<cfif not listfind(tax_list,tax)>
				<cfset tax_list=listappend(tax_list,tax)>
            </cfif>
            <tr>
                <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>  
                <td width="380"><a href="#request.self#?fuseaction=settings.list_tax&event=upd&tid=#tax_ID#" clasS="tableyazi">#tax#</a></td>
            </tr>
        </cfoutput>
        <cfset tax_list=listsort(tax_list,"numeric")>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>  
            <td width="380"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>