<cfquery name="GET_WRK_FUSEACTIONS" datasource="#DSN#">
	 SELECT
		MODUL_SHORT_NAME,
		FUSEACTION
	FROM
		WRK_OBJECTS
	WHERE 
		WRK_OBJECTS_ID = #attributes.woid#
</cfquery>
<cfquery name="GET_FUSEACTION_RELATION" datasource="#DSN#">
    SELECT
        WOR.*
    FROM
        WRK_OBJECTS_RELATION WOR
    WHERE
        WOR.FUSEACTION = '#GET_WRK_FUSEACTIONS.MODUL_SHORT_NAME#.#GET_WRK_FUSEACTIONS.FUSEACTION#'
</cfquery>
<cf_ajax_list>
    <thead>
        <th><b>Fuseaction</b></th>
        <th><b>Type</b></th>
        <th style="width:40px;"></th>
    </thead>
    <tbody>
        <cfset int_row = 0>
        <cfif get_fuseaction_relation.recordcount>
            <cfoutput query="get_fuseaction_relation">
                <cfset int_row=currentrow>
                <tr id="fuseaction_to_row#int_row#" name="fuseaction_to_row#int_row#" height="18">
                    <td>#RELATED_FUSEACTION#</td>
                    <td>#RELATION_TYPE#</td>
                    <td style="text-align:inherit;"><input type="hidden" name="relation_id#currentrow#" id="relation_id#currentrow#" value="#get_fuseaction_relation.relation_id#">
                        <a href="javascript://" onClick="javascript:if (confirm('Fuseaction İlişkisini Silmek İstediğinizden Emin Misiniz?')) windowopen('#request.self#?fuseaction=dev.emptypopup_del_fuseaction_relation&wrk_obj_id=#get_fuseaction_relation.relation_id#','small'); else return false;" class="tableyazi">
                        <img src="/images/delete_list.gif" alt="Sil" title="Sil" align="top" border="0"></a>
                        <a href="#request.self#?fuseaction=dev.upd_fuseaction&woid=#get_fuseaction_relation.relation_id#&show_related=1"><img src="/images/update_list.gif" alt="Güncelle" title="Güncelle" align="Top" border="0"></a>
                    </td>
                </tr>							
            </cfoutput>
        <cfelse>
            <tr id="fuseaction_to_row#int_row#" name="fuseaction_to_row#int_row#">
                <td colspan="3"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        <input type="hidden" name="tbl_to_names_row_count_" id="tbl_to_names_row_count_" value="<cfoutput>#int_row#</cfoutput>">
    </tbody>
</cf_ajax_list>
