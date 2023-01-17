<cfscript>
	attributes.action_section  = 'COMPANY_ID';
	module = 'member';
	module_id = 4;
	action = 'COMPANY_ID';
</cfscript>
<cfquery name="GET_NOTE" datasource="#DSN#">
	SELECT 
		*
	FROM 
		NOTES
	WHERE 
		NOTES.COMPANY_ID = #session.ep.company_id# AND
		NOTES.ACTION_ID = #attributes.cpid# AND
		NOTES.ACTION_SECTION = '#ucase(attributes.action_section)#'
	ORDER BY	
		ACTION_ID
</cfquery>
<cfparam name="attributes.design_id" default="1">
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cfif attributes.design_id is 0>
 	<cf_ajax_list>
    	<thead>
            <tr>
				<cfoutput>
                    <th class="txtboldblue" height="22"><cf_get_lang_main no='10.Notlar'></th>
                    <th width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_note&module=#module#&module_id=#module_id#&action=#action#&action_id=#attributes.cpid#&action_type=0','small')"><img src="/images/add_not.gif" border="0" title="<cf_get_lang_main no='53.Not Ekle'>" align="absmiddle"></a></th>
                </cfoutput>
            </tr>
        </thead>
    <cfoutput query="get_note">
    	<tbody>
            <tr>
                <td><a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&module=crm&module_id=52&action=#attributes.action_section#&action_id=#attributes.cpid#','small')" class="tableyazi">#note_head#</a></td>
                <td>1</td>
            </tr>
        </tbody>
    </cfoutput>
  	</cf_ajax_list>
<cfelse>
    <cf_ajax_list>
    	<thead>
            <tr>
                <cfoutput>
                <th class="form-title" width="100%"><cf_get_lang_main no='10.Notlar'></th>
                <th style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_note&module=#module#&module_id=#module_id#&action=#action#&action_id=#attributes.cpid#&action_type=0','small')"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>" align="absmiddle"></a></th>
                </cfoutput>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_note">
                <tr>
                    <td><a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&module=crm&module_id=52&action=#attributes.action_section#&action_id=#attributes.cpid#','small')" class="tableyazi">#note_head#</a></td>
                    <td style="text-align:right;"><a href="javascript:" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_note&note_id=#note_id#&module=crm&module_id=52&action=#attributes.action_section#&action_id=#attributes.cpid#','small')" class="tableyazi"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                </tr>
            </cfoutput>
            <cfif not get_note.recordcount>
                <tr>
                    <td colspan="2"><cfoutput><cf_get_lang_main no='72.Kayıt Yok'> !</cfoutput></td>
                </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>
</cfif>
<cfscript>
	attributes.action_section  = 'COMPANY_ID';
</cfscript>
<cfquery name="get_asset" datasource="#DSN#">
	SELECT
		*
	FROM
		ASSET,
		CONTENT_PROPERTY CP
	WHERE
		ASSET.ACTION_SECTION = '#ucase(attributes.action_section)#' AND
		ASSET.ACTION_ID = #attributes.cpid# AND
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND 
		COMPANY_ID = #session.ep.company_id#
	ORDER BY 
		ASSET.ACTION_ID	
</cfquery>
<cfparam name="attributes.design_id" default="1">
<cfparam name="attributes.is_add" default="1">
<cfif attributes.design_id is 0>
 	<cf_ajax_list>
    	<thead>
            <tr>
                <cfoutput>
                  <th width="100%"><cf_get_lang_main no='156.Belgeler'></th>
                  <cfif attributes.is_add eq 1>
                      <th nowrap style="text-align:right;">
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_asset&module=member&module_id=4&action=#attributes.action_section#&action_id=#attributes.cpid#&asset_cat_id=-9','small')"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>" ></a>
                      </th>
                 </cfif>
                </cfoutput>
            </tr>
        </thead>
        <tbody>
		<cfoutput query="get_asset">
		  <tr>
			<td width="100%">
			  <a href="#caller.file_web_path##MODULE_NAME#/#ASSET_FILE_NAME#"><img src="/images/attach.gif" title="Download" border="0" align="absmiddle"></a>
			  <a href="javascript:" onClick="windowopen('#caller.file_web_path##MODULE_NAME#/#ASSET_FILE_NAME#','small')" title="#ASSET_DETAIL#" class="tableyazi">#ASSET_NAME#</a> 
			  <cfif currentrow is 1>
			   (#name#)
			  <cfelse>
				<cfset old_row = currentrow - 1 >
				<cfif name neq name[old_row]>
				  (#name#)
				</cfif>
			  </cfif>
			  </td>
			<cfif attributes.is_add eq 1>
			<td style="text-align:right;">
				<a style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_asset&asset_id=#ASSET_ID#&module=member&module_id=4&action=#attributes.action_section#&action_id=#attributes.cpid#&asset_cat_id=-9','wide');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
				<cfsavecontent variable="message"><cf_get_lang_main no ='1057.Kayıtlı Belgeyi Siliyorsunuz! Emin misiniz'></cfsavecontent>
				<a style="cursor:pointer;" onclick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=member&file_name=#ASSET_FILE_NAME#&file_server_id=#ASSET_FILE_SERVER_ID#','small'); else return false;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.Sil'>"></a>
			</td>
			</cfif>
		  </tr>
		</cfoutput>
        </tbody>
	  </cf_ajax_list>
<cfelse>
	  <cf_ajax_list>
      	<thead>
            <tr>
                <cfoutput>
                  <th width="100%"><cf_get_lang_main no='156.Belgeler'></th>
                  <cfif attributes.is_add eq 1>
                  <th>
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_asset&module=member&module_id=4&action=#attributes.action_section#&action_id=#attributes.cpid#&asset_cat_id=-9','wide')"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>"></a>
                  </th>
                  </cfif>
                </cfoutput>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_asset">
              <tr>
                <td>
                  <a href="#file_web_path##MODULE_NAME#/#ASSET_FILE_NAME#"><img src="/images/attach.gif" title="Download" border="0" align="absmiddle"></a>
                  <a href="javascript:" onClick="windowopen('#file_web_path##MODULE_NAME#/#ASSET_FILE_NAME#','small')" title="#ASSET_DETAIL#" class="tableyazi">#ASSET_NAME#</a> 
                  <cfif currentrow is 1>
                   (#name#)
                  <cfelse>
                    <cfset old_row = currentrow - 1 >
                    <cfif name neq name[old_row]>
                      (#name#)
                    </cfif>
                  </cfif>
                  </td>
                <cfif attributes.is_add eq 1>
                <td nowrap style="text-align:right;">
                    <a style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_asset&asset_id=#ASSET_ID#&module=member&module_id=4&action=#attributes.action_section#&action_id=#attributes.cpid#&asset_cat_id=-9','small');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                    <cfsavecontent variable="message"><cf_get_lang_main no ='1057.Kayıtlı Belgeyi Siliyorsunuz! Emin misiniz'></cfsavecontent>
                    <a style="cursor:pointer;" onclick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=member&file_name=#ASSET_FILE_NAME#&file_server_id=#ASSET_FILE_SERVER_ID#','small'); else return false;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.Sil'>"></a>
                </td>
                </cfif>
              </tr>
            </cfoutput>
            <cfif not get_asset.recordcount>
              <tr>
                <td colspan="2"><cfoutput><cf_get_lang_main no='72.Kayıt Yok'></cfoutput> !</td>
              </tr>		
            </cfif>
         </tbody>
	  </cf_ajax_list>
</cfif>
