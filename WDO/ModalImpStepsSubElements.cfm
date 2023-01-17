<cfswitch expression="#attributes.type#">
	<cfcase value="1">	
    	<cfquery name="getFamilies" datasource="#dsn#">
        	SELECT
            	W.WRK_FAMILY_ID,
                W.FAMILY_TYPE,
                W.IS_MENU,
                W.FAMILY_DICTIONARY_ID,
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
		<ul style="margin:0;padding:0;list-style-type:none;" id="sorterFamilie<cfoutput>#attributes.id#</cfoutput>">
			<cfoutput query="getFamilies">
                <li id="wrkFamilie#WRK_FAMILY_ID#">
                    <div class="ui-form-list flex-list">
                        <div class="form-group">
                            <a href="javascript://" style="background-color:##8BC34A;padding:0!important;width:30px;" class="ui-btn" onclick="subElements(2,#wrk_family_id#);">F</a>
                        </div>
                        <div class="form-group large">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Family Name</div>
                                <input type="text" name="family_t2id#wrk_family_id#" id="family_t2id#wrk_family_id#" value="#LANG#" disabled />
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>				
                        <div id="familySubElementsTr#wrk_family_id#" style="display:none">            	
                            <div id = "familySubElementsDiv#wrk_family_id#"></div>            
                        </div>
                    </div>
				</li>
			</cfoutput>
        </ul>
        <script>
            $(function(){
                $(".input-group-tooltip").mouseover(function() {
		            $( this ).closest("div.input-group").css("position","relative");
		            $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
	            }).mouseout(function() {
		            $( this ).closest("div.input-group").css("position","initial");
		            $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
	            });	
            })
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
		<ul style="margin:0;padding:0;list-style-type:none;" id="sorterModule<cfoutput>#attributes.id#</cfoutput>">
			<cfoutput query="getModules">
                <li id="wrkModule#MODULE_ID#">
                    <div class="ui-form-list flex-list">
                        <div class="form-group">
                            <a href="javascript://" style="background-color:##607d8b;padding:0!important;width:30px;" class="ui-btn" onclick="subElements(3,#MODULE_ID#);">M</a>
                        </div>
                        <div class="form-group large">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Module Name</div>
                                <input type="text" name="module_t3id#MODULE_ID#" id="module_t3id#MODULE_ID#" value="#LANG#" disabled/>
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <a href="javascript://" class="ui-btn ui-btn-success" onclick="subElements(-1,#MODULE_ID#)">#getLang('main',170)#</a>
                        </div>
                        <div id="moduleSubElementsTr#MODULE_ID#" class="text-left" style="display:block">            	
                            <div id = "moduleSubElementsDiv#MODULE_ID#"></div>            
                        </div>
                    </div>
				</li>
			</cfoutput>
        </ul>
        <script>
            $(function(){
                $(".input-group-tooltip").mouseover(function() {
		            $( this ).closest("div.input-group").css("position","relative");
		            $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
	            }).mouseout(function() {
		            $( this ).closest("div.input-group").css("position","initial");
		            $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
	            });	
            })
        </script>
    </cfcase>
	<cfcase value="3">
    	<cfquery name="getObjects" datasource="#dsn#">
        	SELECT
            	WIS.*
            FROM
            	WRK_IMPLEMENTATION_STEP AS WIS
                LEFT JOIN WRK_MODULE AS WM ON WIS.WRK_MODUL_ID = WM.MODULE_NO
            WHERE
            	WM.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                --AND W.IS_MENU = 1
            ORDER BY
            	ISNULL(WIS.RANK_NUMBER,100)
        </cfquery>
        <cfform name="relatedmodules#attributes.id#">	
		<ul style="margin:0;padding:0;list-style-type:none;" id="sorterObject<cfoutput>#attributes.id#</cfoutput>">
            <cfoutput query="getObjects">
                <cfquery name="get_lang" datasource="#dsn#">
                    SELECT S.ITEM_#UCase(session.ep.language)# AS ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# AS S WHERE S.DICTIONARY_ID IN (#WRK_IMPLEMENTATION_TASK#)
                </cfquery>
                <li id="wrkObject#WRK_IMPLEMENTATION_STEP_ID#">	
                    <div class="ui-form-list flex-list">
                        <div class="form-group">
                            <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleObject#attributes.id#"><i class="fa fa-sort"></i></a>
                        </div>
                        <div class="form-group">
                            <a href="javascript://" style="background-color:##ff5722;padding:0!important;width:30px;" class="ui-btn">T</a>
                        </div>
                        <div class="form-group large">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Task</div>
                                <input type="text" name="upd_tool_head_#WRK_IMPLEMENTATION_STEP_ID#" id="upd_tool_head_#WRK_IMPLEMENTATION_STEP_ID#" value="#valuelist(get_lang.ITEM)#" readonly="readonly">
                                <input type="hidden" name="upd_dictionary_id_#WRK_IMPLEMENTATION_STEP_ID#"  id="upd_dictionary_id_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_IMPLEMENTATION_TASK#">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=relatedmodules#attributes.id#.upd_dictionary_id_#WRK_IMPLEMENTATION_STEP_ID#&lang_item_name=relatedmodules#attributes.id#.upd_tool_head_#WRK_IMPLEMENTATION_STEP_ID#&moreWord=1','list');return false"></span>
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Wo</div>
                                <input type="text" name="upd_wo_name_#WRK_IMPLEMENTATION_STEP_ID#"  id="upd_wo_name_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_OBJECTS#">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=relatedmodules#attributes.id#.upd_wo_name_#WRK_IMPLEMENTATION_STEP_ID#&is_upd=0&choice=1','list');return false;"></span>  
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Related Wbo</div>
                                <input type="text" name="upd_related_wo_#WRK_IMPLEMENTATION_STEP_ID#"  id="upd_related_wo_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_RELATED_OBJECTS#">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('index.cfm?fuseaction=process.popup_dsp_faction_list&field_name=relatedmodules#attributes.id#.upd_related_wo_#WRK_IMPLEMENTATION_STEP_ID#&is_upd=0&choice=0','list');return false;"></span>
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group medium">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Type</div>
                                <select name="upd_task_type_#WRK_IMPLEMENTATION_STEP_ID#" id="upd_task_type_#WRK_IMPLEMENTATION_STEP_ID#">
                                    <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                    <option value="0" <cfif WRK_IMPLEMENTATION_TYPE eq 0> selected</cfif>>Dictionary</option>
                                    <option value="1" <cfif WRK_IMPLEMENTATION_TYPE eq 1> selected</cfif>>Extension</option>
                                    <option value="2" <cfif WRK_IMPLEMENTATION_TYPE eq 2> selected</cfif>>Implementation Step</option>
                                    <option value="3" <cfif WRK_IMPLEMENTATION_TYPE eq 3> selected</cfif>>Master Data</option>
                                    <option value="4" <cfif WRK_IMPLEMENTATION_TYPE eq 4> selected</cfif>>Menu</option>
                                    <option value="5" <cfif WRK_IMPLEMENTATION_TYPE eq 5> selected</cfif>>Module</option>
                                    <option value="6" <cfif WRK_IMPLEMENTATION_TYPE eq 6>selected</cfif>>Output Template</option>
                                    <option value="7" <cfif WRK_IMPLEMENTATION_TYPE eq 7> selected</cfif>>Page Designer</option>
                                    <option value="8" <cfif WRK_IMPLEMENTATION_TYPE eq 8> selected</cfif>>Param</option>
                                    <option value="9" <cfif WRK_IMPLEMENTATION_TYPE eq 9> selected</cfif>>Process Cat</option>
                                    <option value="10" <cfif WRK_IMPLEMENTATION_TYPE eq 10> selected</cfif>>Process Stage</option>
                                    <option value="11" <cfif WRK_IMPLEMENTATION_TYPE eq 11> selected</cfif>>Process Template</option>
                                    <option value="12" <cfif WRK_IMPLEMENTATION_TYPE eq 12> selected</cfif>>Wex</option>
                                    <option value="13" <cfif WRK_IMPLEMENTATION_TYPE eq 13> selected</cfif>>Widget</option>
                                    <option value="14" <cfif WRK_IMPLEMENTATION_TYPE eq 14>selected</cfif>>Wo</option>
                                    <option value="15" <cfif WRK_IMPLEMENTATION_TYPE eq 15> selected</cfif>>Xml Setup</option>
                                </select>
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div> 
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Related Table</div>
                                <input type="hidden" name="upd_related_schema_#WRK_IMPLEMENTATION_STEP_ID#" id="upd_related_schema_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_RELATED_SCHEMA_NAME#" readonly="readonly">
                                <input type="text" name="upd_related_table_#WRK_IMPLEMENTATION_STEP_ID#" id="upd_related_table_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_RELATED_TABLE_NAME#" readonly="readonly">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('index.cfm?fuseaction=objects.emptypopup_systemPopup&types=dbs&columnChoice=0&field_table_name=relatedmodules#attributes.id#.upd_related_table_#WRK_IMPLEMENTATION_STEP_ID#&field_schema_name=relatedmodules#attributes.id#.upd_related_schema_#WRK_IMPLEMENTATION_STEP_ID#&field_column_name=relatedmodules#attributes.id#.upd_related_table_column_#WRK_IMPLEMENTATION_STEP_ID#','list');return false;"></span>
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group medium">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Column</div>
                                <input type="text" name="upd_related_table_column_#WRK_IMPLEMENTATION_STEP_ID#" id="upd_related_table_column_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_RELATED_TABLE_COLUMN#" readonly="readonly">
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group medium">
                            <div class="input-group">
                                <div class="input-group_tooltip input-group_tooltip_v2">Where-In</div>
                                <input type="text" name="upd_where_in_#WRK_IMPLEMENTATION_STEP_ID#" id="upd_where_in_#WRK_IMPLEMENTATION_STEP_ID#" value="#WRK_CONDITION#">
                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(1,'#attributes.id#',#WRK_IMPLEMENTATION_STEP_ID#)">Update</a>
                        </div>
                        <div class="form-group">
                            <a href="javascript://" class="ui-btn ui-btn-delete" onclick="deleteObject(#WRK_IMPLEMENTATION_STEP_ID#,'#attributes.id#')">Delete</a>
                        </div>
                        <div id="objectsTr_#WRK_MODUL_ID#" style="display:none">            	
                            <div id = "objectsTrDiv_#WRK_MODUL_ID#"></div>            
                        </div>
                    </div>
				</li>
			</cfoutput>
            <cfif isdefined("attributes.relatedModule") and len(attributes.relatedModule)>
                    <cfoutput> 
                        <li id="wrkObject_#attributes.id#">
                            <div class="ui-form-list flex-list">
                                <div class="form-group">
                                    <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleModule_#attributes.id#"><i class="fa fa-sort"></i></a>
                                </div>
                                <div class="form-group">
                                    <a href="javascript://" style="background-color:##ff5722;padding:0!important;width:30px;" class="ui-btn">T</a>
                                </div>
                                <input type="hidden" name="relatedModule_#attributes.id#" id="relatedModule_#attributes.id#" value="<cfoutput>#attributes.relatedModule#</cfoutput>" />	
                                <div class="form-group large">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Task</div>
                                        <input type="text" name="tool_head_#attributes.id#"  id="tool_head_#attributes.id#" value="" readonly="readonly">
                                        <input type="hidden" name="dictionary_id_#attributes.id#"  id="dictionary_id_#attributes.id#" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=relatedmodules#attributes.id#.dictionary_id_#attributes.id#&lang_item_name=relatedmodules#attributes.id#.tool_head_#attributes.id#&moreWord=1','list');return false"></span>
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                                <div class="form-group medium">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Wo</div>
                                        <input type="text" name="wo_name_#attributes.id#"  id="wo_name_#attributes.id#" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=relatedmodules#attributes.id#.wo_name_#attributes.id#&is_upd=0&choice=1','list');return false;"></span>  
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                                <div class="form-group medium">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Related Wbo</div>
                                        <input type="text" name="related_wo_#attributes.id#"  id="related_wo_#attributes.id#" value="" readonly="readonly">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('index.cfm?fuseaction=process.popup_dsp_faction_list&field_name=relatedmodules#attributes.id#.related_wo_#attributes.id#&is_upd=0&choice=0','list');return false;"></span>
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                                <div class="form-group medium">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Type</div>
                                        <select name="task_type_#attributes.id#" id="task_type_#attributes.id#">
                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                            <option value="0">WBO</option>
                                            <option value="1">Param</option>           
                                            <option value="2">System</option>
                                            <option value="3">Import</option>
                                            <option value="4">Period</option>
                                            <option value="5">Maintenance</option>
                                            <option value="6">Utility</option>
                                            <option value="7">Dev</option>
                                            <option value="8">Report</option>
                                            <option value="9">General</option>
                                            <option value="10">Child WO</option>
                                            <option value="11">Query-Backend</option>
                                            <option value="12">Export</option>
                                            <option value="13">Dashboard</option>
                                            <option value="14">Output Template</option>
                                            <option value="15">Process</option>
                                        </select>
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                                <div class="form-group medium">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Related Table</div>
                                        <input type="hidden" name="related_schema_#attributes.id#"  id="related_schema_#attributes.id#" value="" readonly="readonly">
                                        <input type="text" name="related_table_#attributes.id#"  id="related_table_#attributes.id#" value="" readonly="readonly">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('index.cfm?fuseaction=objects.emptypopup_systemPopup&types=dbs&columnChoice=0&field_table_name=relatedmodules#attributes.id#.related_table_#attributes.id#&field_schema_name=relatedmodules#attributes.id#.related_schema_#attributes.id#&field_column_name=relatedmodules#attributes.id#.related_table_column_#attributes.id#','list');return false;"></span>
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div> 
                                <div class="form-group medium">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Column</div>
                                        <input type="text" name="related_table_column_#attributes.id#" id="related_table_column_#attributes.id#" value="" readonly="readonly">
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                                <div class="form-group medium">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Where-In</div>
                                        <input type="text" name="where_in_#attributes.id#" id="where_in_#attributes.id#">
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(-1,'#attributes.id#')">Kaydet</a>
                                </div>
                                <div class="form-group">
                                    <a href="javascript://" class="ui-btn ui-btn-success" onclick="subElements(3,'#attributes.id#')">Geri</a>
                                </div>
                                <div id="objectsTr__#attributes.id#" style="display:none">            	
                                    <div id = "objectsTrDiv__#attributes.id#"></div>            
                                </div> 
                            </div> 
                        </li>
                    </cfoutput>
            </cfif>
		</ul>
        </cfform>
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

