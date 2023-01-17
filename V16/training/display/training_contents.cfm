<cfscript>
	get_training_content_action = createObject("component","V16.training.cfc.get_training_content");
	get_training_content_action.dsn = dsn;
	get_training_content = get_training_content_action.get_training_content_fnc
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
                    );
                    GET_CLASS=get_training_content_action.get_class_fnc(
        class_id : attributes.class_id
        
    );
</cfscript>
<cf_ajax_list>
    <tbody>
		<cfif GET_CLASS.recordcount>
            <cfoutput query="GET_CLASS">
                <tr>
                   <!---  <td valign="left" width="20">#CLASS_OBJECTIVE# </td> --->
                    <td>
                       <!---  <b><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_content&cntid=#class_id#','medium');" class="tableyazi"> --->#CLASS_OBJECTIVE#<!--- </a></b> --->
                       <!---  <br/>
                            #CLASS_OBJECTIVE#
                        <br/> --->
                            <cf_record_info query_name="GET_CLASS">
                        <br/>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
             <tr>
                 <td height="20" colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
             </tr>
         </cfif>
     </tbody>
</cf_ajax_list>
