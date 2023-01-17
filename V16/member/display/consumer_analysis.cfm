<cfsavecontent variable="title"><cf_get_lang dictionary_id ='58799.Analizler'></cfsavecontent>
<cfset rs = "">
<cfif isDefined("result_status") and Len(result_status)>
	<cfset rs = attributes.result_status>
</cfif>
<!---unload_body="0"
	box_page="#request.self#?fuseaction=member.emptypopup_list_consumer_analysis&result_status=#rs#&cid=#attributes.cid#&consumer_cat_id=#get_consumer.consumer_cat_id#"--->
<cf_box
	id="cons_analysis"
	title="#title#"
	closable="0">
		<cf_ajax_list>
        	<tbody>
                <tr>
                    <td style="text-align:right;">
                        <select name="result_status" id="result_status" style="width:60px;">
                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1" <cfif isdefined("attributes.result_status") and attributes.result_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                            <option value="0" <cfif isdefined("attributes.result_status") and attributes.result_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        </select>
                        <input type="button" value="Ara" onClick="list_analysis();">
                    </td>
               </tr>
               <tr id="perform" class="nohover">
                    <td width="100%"><div id="perform_list"></div></td>
               </tr> 
           </tbody>
		</cf_ajax_list>
</cf_box>
<script language="javascript">
	function list_analysis()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=member.emptypopup_list_consumer_analysis&result_status='+document.all.result_status.value+'&cid=#attributes.cid#&consumer_cat_id=#get_consumer.consumer_cat_id#</cfoutput>','perform_list',1);
	}
	list_analysis();
</script>
