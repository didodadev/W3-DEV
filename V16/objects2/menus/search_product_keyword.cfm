<cfform name="search" action="#request.self#?fuseaction=objects2.view_product_list" method="post">
	<div align="center">
        <table border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td class="search_bg">
                    <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                        <cfinput type="text" name="keyword" id="keyword" class="search_input" value="#attributes.keyword#" onFocus="this.value='';" onBlur="return(search_char_control(this));">
                    <cfelse>
                        <cfsavecontent variable="message"><cf_get_lang_main no='154.Ürün Ara'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" class="search_input" value="#message#" onFocus="this.value='';" onBlur="return(search_char_control(this));">
                    </cfif>
                </td>
                <td><input type="image" src="/objects2/image/arax.jpg"></td>
            </tr>
        </table>
    </div>
</cfform>

