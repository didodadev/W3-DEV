<!--- Sayfa kendi icerisinde hem popup hem ajax ile cagrilmaktadir, dikkate aliniz FBS 20120308 --->
<cfsetting showdebugoutput="no">
<cfif isDefined("attributes.help_id")>
	<cfif not fusebox.fuseaction contains 'ajax'>
		<cfif isDefined("attributes.relation_help_id") and Len(attributes.relation_help_id)>
			<cfparam name="attributes.relation_help_id" default="#attributes.relation_help_id#">
		<cfelse>
			<cfparam name="attributes.relation_help_id" default="#attributes.help_id#">
		</cfif>
	</cfif>
	<cfinclude template="../query/get_help.cfm">
	<cfparam name="attributes.help_language" default="#get_help.help_language#">
	<cfsavecontent variable="txt">
	<cf_get_lang no='5.Yardım Güncelle'>: <cfoutput>#get_help.help_circuit#.#get_help.help_fuseaction#</cfoutput>
	</cfsavecontent>
	<cfsavecontent variable="right">
		<CF_NP tablename="HELP_DESK" primary_key="HELP_ID" pointer="HELP_ID=#HELP_ID#">
		<a href="##" onClick="history.go(-1);"><img name="back" src="/images/back.gif" border="0" title="<cf_get_lang_main no ='20.Geri'>" align="top"></a>
	</cfsavecontent>
	<!---Ajax değilse --->
	<cfif not fusebox.fuseaction contains 'ajax'>
		<!--- Diger Diller Blogu --->
		<cf_popup_box title="#txt#" right_images="#right#">
		<cfsavecontent variable="title_"><cf_get_lang dictionary_id="33574.Diğer Diller"></cfsavecontent>
		<cf_box id="other_languages" title="#title_#" collapsed="1" closable="0" add_href_size="small" 
			add_href="AjaxPageLoad('#request.self#?fuseaction=help.popup_ajax_add_help&help=#get_help.help_circuit#.#get_help.help_fuseaction#&help_id=#get_help.help_id#&help_language=#attributes.help_language#','detail_help_info',1);">
			<table width="99%">
				<tr>
					<td class="txtboldblue" style="width:50px;"><cf_get_lang_main no='1584.Dil'></td>
					<td class="txtboldblue"><cf_get_lang_main no='68.Konu'></td>
					<td class="txtboldblue" style="width:50px;text-align:right;"></td>
				</tr>
				<cfoutput query="get_help">
					<tr>
						<td>#help_language#</td>
						<td><a href="javascript://" onclick="reload_help_content('#help_language#',#help_id#,'#relation_help_id#')" class="tableyazi">#help_head#</a></td>
						<td style="text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=help.popup_help_history&help_id=#help_id#','medium','popup_help_history')" class="tableyazi"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" title="<cf_get_lang_main no='61.Tarihçe'>" align="top" border="0"></a></td>
					</tr>
				</cfoutput>
			</table>
		</cf_box>
		<div id="detail_help_info"></div>
		</cf_popup_box>
		<!--- //Diger Diller Blogu --->
	</cfif>
	<!--- Ajax ise --->
	<cfif fusebox.fuseaction contains 'ajax'>
		<!--- WHERE <cfif isDefined("attributes.help_language")>LANGUAGE_SHORT = '#attributes.help_language#'</cfif>  --->
		<cfquery name="get_help_language" datasource="#dsn#">
			SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_SET
		</cfquery>
		<cfform name="upd_help" action="#request.self#?fuseaction=help.emptypopup_upd_help&help_id=#attributes.help_id#" method="POST">
			<cf_popup_box>
				<table>
					<cfoutput>
						<input type="hidden" name="help_id"  id="help_id"value="#attributes.help_id#">
						<tr>
							<td><cf_get_lang_main no='1584.Dil'></td>
							<td>
								<select name="help_language" id="help_language" style="width:90px;" <cfif attributes.help_language eq session.ep.language>disabled</cfif>>
									<cfloop query="get_help_language">
										<option value="#language_short#" <cfif get_help_language.language_short is attributes.help_language>selected</cfif>>#language_set#</option>
									</cfloop>
								</select>
								<cf_get_lang_main no='169.Sayfa'>
								<cfinput type="text" name="modul_name" id="modul_name" value="#get_help.help_circuit#" style="width:100px;">
								<cfinput type="text" name="faction" id="faction" value="#get_help.help_fuseaction#" style="width:150px;">
								<input type="hidden" name="faction_id" id="faction_id" value="">
								<cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>	
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=upd_help.faction_id&field_faction=upd_help.faction&field_modul=upd_help.modul_name','medium');"><img src="/images/plus_thin.gif" title="<cf_get_lang no='16.Fuseaction Ekle'>"></a>
								</cfif>
								<cfif get_module_power_user(45)>
								 <input type="checkbox" value="1" name="is_internet" id="is_internet" <cfif get_help.is_internet eq 1>checked</cfif>><cf_get_lang_main no='1682.Yayın'>
								</cfif>
								<input type="checkbox" value="1" name="is_faq" id="is_faq" <cfif get_help.is_faq eq 1>checked</cfif>><cf_get_lang no='2.SSS'>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='68.Konu'></td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang no='8.Yardım Başlığı Girmediniz !'></cfsavecontent>
								<cfinput name="help_head" id="help_head" type="text" value="#get_help.help_head#" required="Yes" message="#message#" maxlength="100"  style="width:520px;">
							</td>
						</tr>
						<tr>
							<td colspan="2">
							<cfmodule
								template="/fckeditor/fckeditor.cfm"
								toolbarSet="WRKContent"
								basePath="/fckeditor/"
								instanceName="help_topic"
								valign="top"
								value="#get_help.help_topic#"
								width="735"
								height="360">  
							</td>
						</tr>
					</cfoutput>
				</table>
				<cf_popup_box_footer>
					<cf_record_info query_name="GET_HELP" record_emp="RECORD_ID" update_emp="UPDATE_ID"> 
					<cfif not(GET_HELP.IS_INTERNET eq 1)>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=help.emptypopup_del_help&help_id=#attributes.help_id#'><!--- add_function='OnFormSubmit()' --->&nbsp;&nbsp;&nbsp;
					<cfelseif GET_HELP.IS_INTERNET eq 1 and get_module_power_user(45)>
						<cf_workcube_buttons is_upd='1' is_delete='0'><!---  add_function='OnFormSubmit()' --->
					</cfif>
				</cf_popup_box_footer>
			</cf_popup_box>
		</cfform>
	</cfif>
	<script language="javascript" type="text/javascript">
		<cfif not fusebox.fuseaction contains 'ajax'>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=help.popup_ajax_upd_help&help_id=#attributes.help_id#&help_language=#attributes.help_language#</cfoutput>','detail_help_info',1);
		</cfif>
		
		function reload_help_content(lang,id,relation_id)
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=help.popup_ajax_upd_help&help_id='+id+'&relation_help_id='+relation_id+'&help_language='+lang,'detail_help_info',1);
			return false;
		}
	</script>
</cfif>
