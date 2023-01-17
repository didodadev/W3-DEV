<cfsetting showdebugoutput="no">
<cfquery name="GET_REL_CLASSES" datasource="#DSN#">
    SELECT 
    	CR.RELATION_ID,
    	CR.ACTION_TYPE,
        CR.ACTION_TYPE_ID,
        CR.CLASS_ID,
        TC.CLASS_NAME 
    FROM 
        CLASS_RELATION CR,
        TRAINING_CLASS TC
    WHERE
        CR.CLASS_ID = TC.CLASS_ID AND
        CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery>
<cf_ajax_list>
	<thead>
        <tr></tr>
    </thead>
    <tbody>
	<cfif get_rel_classes.recordcount>
		<cfoutput query="get_rel_classes">
			<td><!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_content&cntid=#content_id#','medium');" class="tableyazi">--->#class_name#<!---</a>---></td>
            <cfsavecontent variable="message2"><cf_get_lang dictionary_id='64428.Eğitim Bağlantısını Siliyorsunuz. Emin misiniz?'></cfsavecontent>
            <td style="text-align:right;"><a href="javascript://"  onClick="if(confirm('#message2#')) windowopen('#request.self#?fuseaction=training_management.emptypopup_del_class_relation&relation_id=#relation_id#','content_list',1); else return false;"><img src="/images/delete_list.gif" border="0" title="Bağlantı Sil"></a></td> 
            </tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
		</tr>		
	</cfif>	
    </tbody>
</cf_ajax_list>
