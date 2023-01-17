<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no)>
	<cfset attributes.product_serial_no = replace(attributes.product_serial_no,'*','-','all')>
</cfif>
<cfform name="search_serial" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
    <table>
        <tr style="height:25px;">
            <td colspan="3" class="formbold">
                <cf_get_lang no='621.Satın Aldığınız ürünün seri numarasını girerek garanti ve servis durumu hakkında bilgi alabilirsiniz'>!
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='225.Seri No'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang no='622.Seri No Girmelisiniz'> !</cfsavecontent>
            <cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no)>
                <cfinput type="text" name="product_serial_no" value="#attributes.product_serial_no#" required="yes" message="#message#" style="width:150px;" >
            <cfelse>
                <cfinput type="text" name="product_serial_no" value="" required="yes" message="#message#" style="width:150px;" >
            </cfif>
            <cf_wrk_search_button>
            </td>
            <cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and (not get_search_results_.recordcount and not get_search_results_free.recordcount)>
               <td class="txtbold">&nbsp;&nbsp;&nbsp;<font color="FF0000"><cf_get_lang no='623.Satış kapsamında bir seri no yok'> !</font></td>			   
            </cfif>
        </tr>  
	</table>
</cfform>

