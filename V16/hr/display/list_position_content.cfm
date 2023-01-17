<cfinclude template="../query/get_positioncat_content.cfm">
<cfinclude template="../query/get_position_content.cfm">

<cf_box title="#getLang('','Görev Tanımları',47117)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="20" class="text-right"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_form_add_position_content&position_id=#attributes.position_id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='55226.Yetki ve Sorumluluk Ekle'>"></i></a></th>
                <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            </tr>
        </thead>
        <tbody>
            <cfform name="list_position_content" method="post" action="">
				<cfif GET_POSITIONCAT_CONTENT.recordcount or GET_POSITION_CONTENT.recordcount>
					<cfoutput query="GET_POSITIONCAT_CONTENT">
                        <tr>
                            <td width="20"><a href="#request.self#?fuseaction=hr.list_contents&event=upd&authority_id=#GET_POSITIONCAT_CONTENT.authority_id#" target="blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <td>#GET_POSITIONCAT_CONTENT.AUTHORITY_HEAD#(<cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>)</td>
                        </tr>
					</cfoutput>
                    <cfoutput query="GET_POSITION_CONTENT">
                        <tr>
                            <cfsavecontent variable="del_alert"><cf_get_lang dictionary_id="56791.Kayıtlı İçeriği Siliyorsunuz Emin misiniz"></cfsavecontent>
                            <td width="20"><a href="javascript://" onClick="if (confirm('#del_alert#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_position_content&AUTHORITY_ID= #GET_POSITION_CONTENT.AUTHORITY_ID#','small'); else return;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_form_upd_pos_authority&authority_id=#GET_POSITION_CONTENT.authority_id#&position_id=#url.position_id#','large')" class="tableyazi"> #GET_POSITION_CONTENT.AUTHORITY_HEAD#</a> (<cf_get_lang dictionary_id='58497.Pozisyon'>)</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                    	<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                    </tr>
                </cfif>
            </cfform>
        </tbody>
    </cf_grid_list>
</cf_box>
