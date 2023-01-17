<cfsavecontent variable="konuara"><cf_get_lang_main no='153.Konu Ara'></cfsavecontent>
<cfform name="search" action="#request.self#?fuseaction=objects2.search_result" method="post">
    <table>
        <input type="hidden" name="content_category" id="content_category" value="<cfif isdefined("attributes.search_content_category") and len(attributes.search_content_category)><cfoutput>#attributes.search_content_category#</cfoutput></cfif>">
        <tr> 
            <td>
                <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                    <cfinput type="text" name="keyword" id="keyword" style="width:115px; background-image:url(../../documents/templates/blog/resimler/urun_ara_btn.jpg); border-width:0px; width:155px; height:20px; padding-left:5px; padding-top:3px;" value="#attributes.keyword#" onFocus="this.value='';">
                <cfelse>
                    <cfinput type="text" name="keyword" id="keyword" style="width:115px; background-image:url(../../documents/templates/blog/resimler/urun_ara_btn.jpg); border-width:0px; width:155px; height:20px; padding-left:5px; padding-top:3px;" value="#konuara#" onFocus="this.value='';">
                </cfif>
            </td>
            <td><input type="image" src="../objects2/image/ara.gif"></td>
        </tr>
    </table>
</cfform>
