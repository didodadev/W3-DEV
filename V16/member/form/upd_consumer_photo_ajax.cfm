<cfif isnumeric(attributes.cid)>
	<cfinclude template="../query/get_consumer.cfm">
<cfelse>
	<cfset get_consumer.recordcount = 0>
</cfif>
<table align="center" class="ajax_list">
    <tr>
        <td style="text-align:center">
            <cfif not len(get_consumer.picture)>
                <cfif get_consumer.sex eq 1>
                    <img src="/images/male.jpg" alt="<cf_get_lang dictionary_id='58546.Yok'>" title="<cf_get_lang dictionary_id='58546.Yok'>">
                <cfelse>
                    <img src="/images/female.jpg" alt="<cf_get_lang dictionary_id='58546.Yok'>" title="<cf_get_lang dictionary_id='58546.Yok'>">
                </cfif>             
            <cfelse>
                <cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" image_width="120" image_height="150">
            </cfif>
        </td>
    </tr>
</table>
