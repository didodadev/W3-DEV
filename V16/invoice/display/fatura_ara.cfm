<cfform name="form_gitfatura" id="form_gitfatura" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_git_fatura">					
    <table style="text-align:right;">
        <tr>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57308.Fatura Nosu Eksik'>!</cfsavecontent>
            <td><cfinput type="text" name="fatura_no" is="fatura_no" required="yes" message="#message#"></td>
            <td><cf_wrk_search_button is_excel='0'></td>
        </tr>
    </table>
</cfform>

