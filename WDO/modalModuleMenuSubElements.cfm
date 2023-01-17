<cfswitch expression="#attributes.type#">
	<cfcase value="1">	
    	<cfquery name="getFamilies" datasource="#dsn#">
        	SELECT
            	W.WRK_FAMILY_ID,
                W.FAMILY_TYPE,
                W.IS_MENU,
                W.FAMILY_DICTIONARY_ID,
				W.ICON,
				W.WIKI,
				W.VIDEO,
                ISNULL(S.ITEM_#UCase(session.ep.language)#,W.FAMILY) AS LANG
            FROM
            	WRK_FAMILY W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = W.FAMILY_DICTIONARY_ID
            WHERE
            	W.WRK_SOLUTION_ID = #attributes.id#
            ORDER BY
            	ISNULL(W.RANK_NUMBER,100),
            	S.ITEM_#UCase(session.ep.language)#
        </cfquery>
		<!--- <div class="MMListHead">
			<label class="modeleMenu_toggle">&nbsp;</label>
			<label class="moduleMenu_name">Family</label>
            <label class="moduleMenu_name x-5">Dictionary</label>
			<label class="moduleMenu_type">Type</label>
			<label class="modelMenu_isMenu">Is Menu?</label>
			<label class="moduleMenu_icon">Icon</label>
			<label class="modeleMenu_submit">&nbsp;</label>
		</div>	 --->			
		<ul style="margin:0;padding:0;list-style-type:none;" id="sorterFamilie<cfoutput>#attributes.id#</cfoutput>">
			<cfoutput query="getFamilies">
				<li id="wrkFamilie#WRK_FAMILY_ID#">
                    <div class="ui-form-list flex-list">
                        <div class="form-group">
                            <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleFamilie#attributes.id#"><i class="fa fa-sort"></i></a>
                        </div>
						<div class="form-group">
							<a style="background-color:##8BC34A;padding:0!important;width:30px;" href="javascript://" class="ui-btn" onclick="subElements(2,#wrk_family_id#);" >F</a>
						</div>				
						<div class="form-group large">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Family Name</div>
								<input type="text" name="family_t2id#wrk_family_id#" id="family_t2id#wrk_family_id#" value="#LANG#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Dictionary Id</div>
								<input type="text" name="family_dictionary_id_t2id#wrk_family_id#" id="family_dictionary_id_t2id#wrk_family_id#" value="#FAMILY_DICTIONARY_ID#" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_lang_item&dictionary_id=#FAMILY_DICTIONARY_ID#&is_page=0','medium');"></span>
								<span class="input-group-addon icon-question input-group-tooltip"></span>			
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Type</div>
								<select name="family_type_t2id#wrk_family_id#" id="family_type_t2id#wrk_family_id#">
									<option value="0" <cfif family_type eq 0>selected</cfif>>Standard</option>
									<option value="1" <cfif family_type eq 1>selected</cfif>>Add-On</option>								
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>	
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Is Menu</div>
								<select name="is_menu_t2id#wrk_family_id#" id="is_menu_t2id#wrk_family_id#" >
									<option value="0" <cfif is_menu eq 0>selected</cfif>>Hayır</option>
									<option value="1" <cfif is_menu eq 1>selected</cfif>>Evet</option>
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Icon</div>
								<input type="text" name="iconF_t2id#wrk_family_id#" id="iconF_t2id#wrk_family_id#" value="#ICON#" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iconF_t2id#wrk_family_id#','medium');"></span>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='60721.Wiki'></div>
								<input type="text" name="wiki_t2id#wrk_family_id#" id="wiki_t2id#wrk_family_id#" value="#WIKI#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='46931.Video'></div>
								<input type="text" name="video_t2id#wrk_family_id#" id="video_t2id#wrk_family_id#" value="#VIDEO#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group">
							<a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(2,#wrk_family_id#);">#getLang('main',49)#</a>
						</div>
						<div id="familySubElementsTr#wrk_family_id#" style="display:none">            	
							<div id = "familySubElementsDiv#wrk_family_id#"></div>            
						</div>
					</div>
				</li>
			</cfoutput>
            <cfif isdefined("attributes.relatedSolution") and len(attributes.relatedSolution)>
				<cfoutput>
                    <li id="wrkFamilie_#attributes.id#">
                        <div class="ui-form-list flex-list">
                            <div class="form-group">
                                <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleFamilie_#attributes.id#"><i class="fa fa-sort"></i></a>
                            </div>
							<div class="form-group">
								<a style="background-color:##8BC34A;padding:0!important;width:30px;" href="javascript://" class="ui-btn">F</a>
							</div>				
							<div class="form-group large">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Family Name</div>
									<input type="text" name="family_t2id_#attributes.id#" id="family_t2id_#attributes.id#" value="" />
									<input type="hidden" name="relatedSolution" id="relatedSolution" value="<cfoutput>#attributes.relatedSolution#</cfoutput>" />
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Dictionary Id</div>
									<input type="text" name="family_dictionary_id_t2id_#attributes.id#" id="family_dictionary_id_t2id_#attributes.id#" value="" />
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Type</div>
									<select name="family_type_t2id_#attributes.id#" id="family_type_t2id_#attributes.id#">
										<option value="0" selected="selected">Standard</option>
										<option value="1">Add-On</option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Is Menu</div>
									<select name="is_menu_t2id_#attributes.id#" id="is_menu_t2id_#attributes.id#">
										<option value="0" selected="selected">Hayır</option>
										<option value="1">Evet</option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Icon</div>
									<input type="text" name="iconF_t2id#attributes.id#" id="iconF_t2id#attributes.id#" />
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iconF_t2id#attributes.id#','medium');"></span>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group">
								<a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(-2,'_#attributes.id#');">#getLang('main',170)#</a>
							</div>
							<div id="familySubElementsTr_#attributes.id#" class="text-left" style="display:none">            	
								<div id = "familySubElementsDiv_#attributes.id#"></div>            
							</div>
						</div>
                    </li>
                </cfoutput>
            </cfif>
		</ul>	
		<script type="text/javascript">	
			$("#sorterFamilie<cfoutput>#attributes.id#</cfoutput>").sortable({
				connectWith		: '#sorterFamilie<cfoutput>#attributes.id#</cfoutput>',
				items			: 'li',
				handle			: '#handleFamilie<cfoutput>#attributes.id#</cfoutput>',
				cursor			: 'move',
				opacity			: '0.6',
				placeholder		: 'elementSortAreaTr',
				revert			: 300,
				start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());},
				stop: function(e, ui ) {
					var ul = $(e.toElement).closest('ul');
						$(ul).children('li').each(function(index) {				
							$(this).children().children().children('.fa-sort').empty();
							$(this).children().children().children('.fa-sort').append(index+1);
						});
					sorterSave('f','sorterFamilie<cfoutput>#attributes.id#</cfoutput>');
				}//stop
			});
			$('#sorterFamilie<cfoutput>#attributes.id#</cfoutput>').children('li').each(function(index) {				
				$(this).children().children().children('.fa-sort').empty();
				$(this).children().children().children('.fa-sort').append(index+1);				
			});	
			$(".input-group-tooltip").mouseover(function() {
				$( this ).closest("div.input-group").css("position","relative");
				$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
				}).mouseout(function() {
				$( this ).closest("div.input-group").css("position","initial");
				$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
			});	
		</script>	
    </cfcase>	
	<cfcase value="2">
    	<cfquery name="getModules" datasource="#dsn#">
        	SELECT
            	W.*,
                ISNULL(S.ITEM_#UCase(session.ep.language)#,W.MODULE) AS LANG
            FROM
            	WRK_MODULE AS W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON W.MODULE_DICTIONARY_ID = S.DICTIONARY_ID
            WHERE
            	W.FAMILY_ID = #attributes.id#
            ORDER BY
            	ISNULL(W.RANK_NUMBER,100),
            	S.ITEM_#UCase(session.ep.language)#
        </cfquery>
		<!--- <div class="MMListHead">
			<label class="modeleMenu_toggle">&nbsp;</label>
			<label class="moduleMenu_name">Module</label>
            <label class="moduleMenu_name x-5">Dictionary</label>
			<label class="moduleMenu_type">Type</label>
			<label class="modelMenu_isMenu">Is Menu?</label>
			<label class="moduleMenu_icon">Icon</label>
			<label class="modeleMenu_submit">&nbsp;</label>
		</div>	 --->	
		<ul style="margin:0;padding:0;list-style-type:none;" id="sorterModule<cfoutput>#attributes.id#</cfoutput>">
			<cfoutput query="getModules">
				<li id="wrkModule#MODULE_ID#">
					<div class="ui-form-list flex-list">
						<div class="form-group">
                            <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleModule#attributes.id#"><i class="fa fa-sort"></i></a>
                        </div>
						<div class="form-group">
							<a style="background-color:##607d8b;padding:0!important;width:30px;" href="javascript://" class="ui-btn" onclick="subElements(3,#MODULE_ID#);">M</a>
						</div>				
						<div class="form-group large">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Module Name</div>
								<input type="text" name="module_t3id#MODULE_ID#" id="module_t3id#MODULE_ID#" value="#LANG#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Dictionary Id</div>
								<input type="text" name="module_dictionary_id_t3id#MODULE_ID#" id="module_dictionary_id_t3id#MODULE_ID#" value="#MODULE_DICTIONARY_ID#" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_lang_item&dictionary_id=#MODULE_DICTIONARY_ID#&is_page=0','medium');"></span>			
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Type</div>
								<select name="module_type_t3id#MODULE_ID#" id="module_type_t3id#MODULE_ID#">
									<option value="1" <cfif module_type eq 1>selected</cfif>>Standard</option>
									<option value="2" <cfif module_type eq 2>selected</cfif>>Add-On</option>
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Is Menu</div>
								<select name="is_menu_t3id#MODULE_ID#" id="is_menu_t3id#MODULE_ID#" >
									<option value="0" <cfif is_menu eq 0>selected</cfif>>Hayır</option>
									<option value="1" <cfif is_menu eq 1>selected</cfif>>Evet</option>
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Icon</div>
								<input type="text" name="iconM_t3id#MODULE_ID#" id="iconM_t3id#MODULE_ID#" value="#ICON#" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iconM_t3id#MODULE_ID#','medium');"></span>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='60721.Wiki'></div>
								<input type="text" name="wiki_t3id#MODULE_ID#" id="wiki_t3id#MODULE_ID#" value="#WIKI#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='46931.Video'></div>
								<input type="text" name="video_t3id#MODULE_ID#" id="video_t3id#MODULE_ID#" value="#VIDEO#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group">
							<a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(3,#MODULE_ID#)">#getLang('','kaydet',59031)#</a>
						</div>
						<div id="moduleSubElementsTr#MODULE_ID#" style="display:none">            	
							<div id = "moduleSubElementsDiv#MODULE_ID#"></div>            
						</div>
					</div>
				</li>
			</cfoutput>
			<cfif isdefined("attributes.relatedFamily") and len(attributes.relatedFamily)>
            	<cfoutput>
                    <li id="wrkModule_#attributes.id#">
						<div class="ui-form-list flex-list">
                            <div class="form-group">
                                <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleModule_#attributes.id#"><i class="fa fa-sort"></i></a>
                            </div>
							<div class="form-group">
								<a style="background-color:##607d8b;padding:0!important;width:30px;" href="javascript://" class="ui-btn" onclick="subElements(3,'_#attributes.id#');">M</a>
							</div>				
							<div class="form-group large">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Module Name</div>
									<input type="text" name="module_t3id_#attributes.id#" id="module_t3id_#attributes.id#" value="" />
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Dictionary Id</div>
									<input type="text" name="module_dictionary_id_t3id_#attributes.id#" id="module_dictionary_id_t3id_#attributes.id#" value="" />
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Type</div>
									<select name="module_type_t3id_#attributes.id#" id="module_type_t3id_#attributes.id#">
										<option value="1" selected>Standard</option>
										<option value="2">Add-On</option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Is Menu</div>
									<select name="is_menu_t3id_#attributes.id#" id="is_menu_t3id_#attributes.id#">
										<option value="0">Hayır</option>
										<option value="1">Evet</option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group medium">
								<div class="input-group">
									<div class="input-group_tooltip input-group_tooltip_v2">Icon</div>
									<input type="text" name="iconM_t3id#attributes.id#" id="iconM_t3id#attributes.id#" />
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iconM_t3id#attributes.id#','medium');"></span>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
							<div class="form-group">
								<a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(-3,'_#attributes.id#')">#getLang('','kaydet',59031)#</a>
						   </div>
							<div id="moduleSubElementsTr_#attributes.id#" style="display:none">            	
								<div id = "moduleSubElementsDiv_#attributes.id#"></div>            
							</div>
						</div>
                    </li>
                </cfoutput>
            </cfif>
		</ul>
		<script type="text/javascript">	
			$("#sorterModule<cfoutput>#attributes.id#</cfoutput>").sortable({
				connectWith		: '#sorterModule<cfoutput>#attributes.id#</cfoutput>',
				items			: 'li',
				handle			: '#handleModule<cfoutput>#attributes.id#</cfoutput>',
				cursor			: 'move',
				opacity			: '0.6',
				placeholder		: 'elementSortAreaTr',
				revert			: 300,
				start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());},
				stop: function(e, ui ) {
					var ul = $(e.toElement).closest('ul');
						$(ul).children('li').each(function(index) {				
							$(this).children().children().children('.fa-sort').empty();
							$(this).children().children().children('.fa-sort').append(index+1);
						});
					sorterSave('m','sorterModule<cfoutput>#attributes.id#</cfoutput>');
				}//stop
			});	
			$('#sorterModule<cfoutput>#attributes.id#</cfoutput>').children('li').each(function(index) {				
				$(this).children().children().children('.fa-sort').empty();
				$(this).children().children().children('.fa-sort').append(index+1);				
			});	
			$(".input-group-tooltip").mouseover(function() {
		        $( this ).closest("div.input-group").css("position","relative");
		        $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
	        }).mouseout(function() {
		        $( this ).closest("div.input-group").css("position","initial");
		        $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
	        });	
			
		</script>
    </cfcase>
	<cfcase value="3">
    	<cfquery name="getObjects" datasource="#dsn#">
        	SELECT
            	W.*,
                ISNULL(Replace(S.ITEM_#UCASE(session.ep.language)#,'''',''),W.HEAD) AS LANG
            FROM
            	WRK_OBJECTS AS W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = W.DICTIONARY_ID
                LEFT JOIN WRK_MODULE AS WM ON W.MODULE_NO = WM.MODULE_NO
            WHERE
            	WM.MODULE_ID = #attributes.id#
                AND W.IS_MENU = 1
            ORDER BY
            	ISNULL(W.RANK_NUMBER,100),
            	LANG
        </cfquery>
		<!--- <div class="MMListHead">
			<label class="modeleMenu_toggle">&nbsp;</label>			
			<label class="moduleMenu_name">Object</label>
            <label class="moduleMenu_name x-5">Dictionary</label>
			<label class="moduleMenu_type">Type</label>
			<label class="modelMenu_isMenu">Is Menu?</label>
			<label class="moduleMenu_icon">Icon</label>
			<label class="modeleMenu_default">Default</label>
			<label class="modeleMenu_submit">&nbsp;</label>
		</div> --->
		<ul style="margin:0;padding:0;list-style-type:none;" id="sorterObject<cfoutput>#attributes.id#</cfoutput>">
			<cfoutput query="getObjects">
				<li id="wrkObject#WRK_OBJECTS_ID#">	
					<div class="ui-form-list flex-list">
						<div class="form-group">
                            <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleObject#attributes.id#"><i class="fa fa-sort"></i></a>
                        </div>
						<div class="form-group">
							<a href="javascript://" style="background-color:##BF55EC;padding:0!important;width:30px;" class="ui-btn">O</a>
						</div>
						<div class="form-group large">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Object Name</div>
								<input type="text" name="object_t4id#WRK_OBJECTS_ID#" id="object_t4id#WRK_OBJECTS_ID#" value="#LANG#" />
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Dictionary Id</div>
								<input type="text" name="object_dictionary_id_t4id#WRK_OBJECTS_ID#" id="object_dictionary_id_t4id#WRK_OBJECTS_ID#" value="#DICTIONARY_ID#" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_lang_item&dictionary_id=#DICTIONARY_ID#&is_page=0','medium');"></span>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Type</div>
								<select name="object_type_t4id#WRK_OBJECTS_ID#" id="object_type_t4id#WRK_OBJECTS_ID#">
									<option value="1" <cfif type eq 1>selected</cfif>>Standard</option>
									<option value="2" <cfif type eq 2>selected</cfif>>Add-On</option>
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Is Menu</div>
								<select name="is_menu_t4id#WRK_OBJECTS_ID#" id="is_menu_t4id#WRK_OBJECTS_ID#" >
									<option value="0" <cfif IS_MENU eq 0>selected</cfif>>Hayır</option>
									<option value="1" <cfif IS_MENU eq 1>selected</cfif>>Evet</option>
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Icon</div>
								<input type="text" name="iconO_t4id#WRK_OBJECTS_ID#" id="iconO_t4id#WRK_OBJECTS_ID#" value="#ICON#" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iconO_t4id#WRK_OBJECTS_ID#','medium');"></span>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group medium">
							<div class="input-group">
								<div class="input-group_tooltip input-group_tooltip_v2">Default</div>
								<select name="object_default_t4id#WRK_OBJECTS_ID#" id="object_default_t4id#WRK_OBJECTS_ID#">
									<option value="add" <cfif event_default eq 'add'>selected</cfif>>Add</option>
									<option value="list" <cfif event_default eq 'list'>selected</cfif>>List</option>
									<option value="dashboard" <cfif event_default eq 'dashboard'>selected</cfif>>Dashboard</option>
								</select>
								<span class="input-group-addon icon-question input-group-tooltip"></span>
							</div>
						</div>
						<div class="form-group">
							<a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(4,#WRK_OBJECTS_ID#)">#getLang('','kaydet',59031)#</a>
						</div>
						<div id="objectsTr_#WRK_OBJECTS_ID#" style="display:none">            	
							<div id = "objectsTrDiv_#WRK_OBJECTS_ID#"></div>            
						</div>
					</div>
				</li>
			</cfoutput>
		</ul>
		<script type="text/javascript">	
			$("#sorterObject<cfoutput>#attributes.id#</cfoutput>").sortable({
				connectWith		: '#sorterObject<cfoutput>#attributes.id#</cfoutput>',
				items			: 'li',
				handle			: '#handleObject<cfoutput>#attributes.id#</cfoutput>',
				cursor			: 'move',
				opacity			: '0.6',
				placeholder		: 'elementSortAreaTr',
				revert			: 300,
				start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());},
				stop: function(e, ui ) {
					var ul = $(e.toElement).closest('ul');
						$(ul).children('li').each(function(index) {				
							$(this).children().children().children('.fa-sort').empty();
							$(this).children().children().children('.fa-sort').append(index+1);
						});
					sorterSave('o','sorterObject<cfoutput>#attributes.id#</cfoutput>')
				}//stop
			});	
			$('#sorterObject<cfoutput>#attributes.id#</cfoutput>').children('li').each(function(index) {				
				$(this).children().children().children('.fa-sort').empty();
				$(this).children().children().children('.fa-sort').append(index+1);
			});	
			$(".input-group-tooltip").mouseover(function() {
		        $( this ).closest("div.input-group").css("position","relative");
		        $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
	        }).mouseout(function() {
		        $( this ).closest("div.input-group").css("position","initial");
		        $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
	        });	
		</script>
    </cfcase>
</cfswitch>