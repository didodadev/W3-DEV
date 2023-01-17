
<cfparam name="attributes.form_submitted" default="0">
<cfif attributes.form_submitted eq 1>    
	<cfswitch expression="#attributes.objectType#">
    	<cfcase value="1">
        	<cfquery name="updObject" datasource="#dsn#" result="r">
            	UPDATE
                	WRK_SOLUTION
                SET
                	SOLUTION = '#attributes.solution#',
                    SOLUTION_DICTIONARY_ID = <cfif len(attributes.solution_dictionary_id)>#attributes.solution_dictionary_id#<cfelse>NULL</cfif>,
                    SOLUTION_TYPE = #attributes.solution_type#,
                    WIKI = <cfif len(attributes.wiki)>#attributes.wiki#<cfelse>NULL</cfif>,
                    VIDEO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace("#attributes.video#", "|", "=", "All")#">,
                    IS_MENU = #iif(attributes.is_menu,1,0)#
                    <cfif isdefined('attributes.iconS') and len(attributes.iconS)>
                        ,ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconS#">
                    </cfif>
                WHERE
                	WRK_SOLUTION_ID = #attributes.id#
            </cfquery>
        </cfcase>
        <cfcase value="-1">
            <cfquery name="updObject" datasource="#dsn#">
                INSERT INTO
                    WRK_SOLUTION
                (
                    SOLUTION,
                    SOLUTION_DICTIONARY_ID,
                    SOLUTION_TYPE,
                    IS_MENU
                    <cfif isdefined('attributes.iconS') and len(attributes.iconS)>
                    ,ICON
                    </cfif>
                )
                VALUES
                (
                    '#attributes.SOLUTION#',
                    <cfif len(attributes.solution_dictionary_id)>#attributes.solution_dictionary_id#<cfelse>NULL</cfif>,
                    #attributes.solution_type#,
                    #iif(attributes.is_menu,1,0)#
                    <cfif isdefined('attributes.iconS') and len(attributes.iconS)>
                    ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconS#">
                    </cfif>
                )
            </cfquery>
		</cfcase>
    	<cfcase value="2">
            <cfquery name="updObject" datasource="#dsn#">
                UPDATE
                    WRK_FAMILY
                SET
                    FAMILY = '#attributes.family#',
                    FAMILY_DICTIONARY_ID = <cfif len(attributes.family_dictionary_id)>#attributes.family_dictionary_id#<cfelse>NULL</cfif>,
                    FAMILY_TYPE = #attributes.family_type#,
                    WIKI = <cfif len(attributes.wiki)>#attributes.wiki#<cfelse>NULL</cfif>,
                    VIDEO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace("#attributes.video#", "|", "=", "All")#">,
                    IS_MENU = #iif(attributes.is_menu,1,0)#
                    <cfif isdefined('attributes.iconF') and len(attributes.iconF)>
                    ,ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconF#">
                    </cfif>
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">                   
                WHERE
                    WRK_FAMILY_ID = #attributes.id#
            </cfquery>
        </cfcase>
        <cfcase value="-2">
            <cfquery name="updObject" datasource="#dsn#">
                INSERT INTO
                    WRK_FAMILY
                (
                    FAMILY,
                    FAMILY_DICTIONARY_ID,
                    FAMILY_TYPE,
                    IS_MENU,
                    WRK_SOLUTION_ID
                    <cfif isdefined('attributes.iconF') and len(attributes.iconF)>
                    ,ICON
                    </cfif>
                )
                VALUES
                (
                    '#attributes.family#',
                    <cfif len(attributes.family_dictionary_id)>#attributes.family_dictionary_id#<cfelse>NULL</cfif>,
                    #attributes.family_type#,
                    #iif(attributes.is_menu,1,0)#,
                    #Replace(attributes.relatedSolution,'_','')#
                    <cfif isdefined('attributes.iconF') and len(attributes.iconF)>
                    ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconF#">
                    </cfif>
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery>
		</cfcase>
    	<cfcase value="3">
        	<cfquery name="updObject" datasource="#dsn#">
            	UPDATE
                	WRK_MODULE
                SET
                    MODULE_DICTIONARY_ID = <cfif len(attributes.module_dictionary_id)>#attributes.module_dictionary_id#<cfelse>NULL</cfif>,
                    MODULE_TYPE = #attributes.module_type#,
                    WIKI = <cfif len(attributes.wiki)>#attributes.wiki#<cfelse>NULL</cfif>,
                    VIDEO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace("#attributes.video#", "|", "=", "All")#">,
                    IS_MENU = #iif(attributes.is_menu,1,0)#
                    <cfif isdefined('attributes.iconM') and len(attributes.iconM)>
                    ,ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconM#">
                    </cfif>
                WHERE
                	MODULE_ID = #attributes.id#
            </cfquery>
        </cfcase>
        <cfcase value="-3">
        	<cfquery name="GET_MODULE_NO" datasource="#dsn#">
            	SELECT MAX(MODULE_NO) AS MAXMODULE FROM WRK_MODULE
            </cfquery>
            <cfquery name="updObject" datasource="#dsn#">
                INSERT INTO
                    WRK_MODULE
                (
                	MODULE,
                    MODULE_NO,
                    MODULE_DICTIONARY_ID,
                    MODULE_TYPE,
                    IS_MENU,
                    FAMILY_ID
                    <cfif isdefined('attributes.iconM') and len(attributes.iconM)>
                    ,ICON
                    </cfif>
                )
                VALUES
                (
                	'#attributes.module#',
                    #GET_MODULE_NO.MAXMODULE+1#,
                	<cfif len(attributes.module_dictionary_id)>#attributes.module_dictionary_id#<cfelse>NULL</cfif>,
                    #attributes.module_type#,
                    #iif(attributes.is_menu,1,0)#,
                    #Replace(attributes.relatedFamily,'_','')#
                    <cfif isdefined('attributes.iconM') and len(attributes.iconM)>
                    ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconM#">
                    </cfif>
                )
            </cfquery>  
            <!--- <cfquery name="updObject" datasource="#dsn#">
                INSERT INTO
                    MODULES
                (
                    MODULE_ID,
                    MODULE,
                	MODULE_NAME,
                    MODULE_NAME_TR,
                    MODULE_SHORT_NAME,
                    MODUL_NO,
                    MODULE_TYPE,
                    FAMILY_ID,
                    MODULE_DICTIONARY_ID,
                    IS_MENU
                )
                VALUES
                (
                    #GET_MODULE_NO.MAXMODULE+1#,
                    '#attributes.module#',
                   '#attributes.module#',
                   '#attributes.module#',
                   '#attributes.module#',
                	#GET_MODULE_NO.MAXMODULE+1#,
                     #attributes.module_type#,
                   #Replace(attributes.relatedFamily,'_','')#,
                    <cfif len(attributes.module_dictionary_id)>#attributes.module_dictionary_id#<cfelse>NULL</cfif>,
                    #iif(attributes.is_menu,1,0)#
                )
            </cfquery>    --->   
		</cfcase>
    	<cfcase value="4">
        	<cfquery name="updObject" datasource="#dsn#" result="r">
            	UPDATE
                	WRK_OBJECTS
                SET
                	HEAD = '#attributes.object#',
                    DICTIONARY_ID = #attributes.object_dictionary_id#,
                    IS_MENU = #iif(attributes.is_menu,1,0)#,
                    EVENT_DEFAULT = '#attributes.event_default#',
                    WIKI = <cfif isDefined('attributes.wiki') And Len(attributes.wiki)>#attributes.wiki#<cfelse>NULL</cfif>,
                    VIDEO = <cfif isDefined('attributes.video') And Len(attributes.video)>'#attributes.video#'<cfelse>NULL</cfif>,
                    LICENCE = #attributes.object_type#
                    <cfif isdefined('attributes.iconO') and len(attributes.iconO)>
                    ,ICON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.iconO#">
                    </cfif>
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                	WRK_OBJECTS_ID = #id#
            </cfquery>
        </cfcase>
    </cfswitch>
    <cfdirectory directory="#upload_folder#personal_settings#dir_seperator#" name="files" filter="userGroup*" action="list"><!--- Workcube kurulumu icindeki klasorler alınıyor --->
    <cfoutput query="files">
        <cffile action="delete" file="#upload_folder#personal_settings#dir_seperator##files.name#">
    </cfoutput>
    <script>
		$("#<cfoutput>#attributes.divId#</cfoutput>").css('display','');
	</script>
    <cf_get_lang dictionary_id='58890.Kaydedildi'>
<cfelse>
	<cfscript>
        wdo = createObject("component","WDO.modalModuleMenu");
        getObjects = WDO.getObjects();
    </cfscript>
    <cf_catalystHeader>
    <cf_box title="#getLang('','Standart Menu',63835)#">
    <div id="menuDesigner">
       
            <!--- <div class="MMListHead">
                <label class="modeleMenu_toggle">&nbsp;</label>
                <label class="moduleMenu_name">Solution</label>
                <label class="moduleMenu_name x-5">Dictionary</label>
                <label class="moduleMenu_type">Type</label>
                <label class="modelMenu_isMenu">Is Menu?</label>
                <label class="moduleMenu_icon">Icon</label>
                <label class="modeleMenu_submit">&nbsp;</label>
            </div> --->
            <ul style="margin:0;padding:0;list-style-type:none;" id="sorterSolution">
                <cfoutput query="getObjects">
                    <li id="wrkSolution#WRK_SOLUTION_ID#">
                        <div class="ui-form-list flex-list">
                            <div class="form-group">
                                <a style="padding:0!important;width:30px;" href="javascript://" class="ui-btn ui-btn-update" id="handleSolution"><i class="fa fa-sort"></i></a>
                            </div>
                            <div class="form-group">
                                <a style="background-color:##36918b;padding:0!important;width:30px;" href="javascript://" class="ui-btn" onclick="subElements(1,#wrk_solution_id#)">S</a>
                            </div>				
                            <div class="form-group large">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='63830.Solution Name'></div>
                                    <input type="text" name="solution_t1id#wrk_solution_id#" id="solution_t1id#wrk_solution_id#" value="#SOLUTION#" />
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group medium">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='63831.Dictionary Id'></div>
                                    <input type="text" name="solution_dictionary_id_t1id#wrk_solution_id#" id="solution_dictionary_id_t1id#wrk_solution_id#" value="#SOLUTION_DICTIONARY_ID#" />
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_lang_item&dictionary_id=#SOLUTION_DICTIONARY_ID#&is_page=0','medium');"></span>			
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group medium">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='52735.Type'></div>
                                    <select name="solution_type_t1id#wrk_solution_id#" id="solution_type_t1id#wrk_solution_id#">
                                        <option value="0" <cfif solution_type eq 0>selected</cfif>><cf_get_lang dictionary_id='63832.Standard'></option>
                                        <option value="1" <cfif solution_type eq 1>selected</cfif>><cf_get_lang dictionary_id='60146.Add-On'></option>
                                    </select>
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group medium">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='63833.Is Menu'></div>
                                    <select name="is_menu_t1id#wrk_solution_id#" id="is_menu_t1id#wrk_solution_id#" >
                                        <option value="0" <cfif is_menu eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
                                        <option value="1" <cfif is_menu eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>  
                                    </select>
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group medium">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='63834.Icon'></div>
                                    <input type="text" name="iconS_t1id#wrk_solution_id#" id="iconS_t1id#wrk_solution_id#" value="#ICON#" />
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iconS_t1id#wrk_solution_id#','medium');"></span>
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group medium">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='60721.Wiki'></div>
                                    <input type="text" name="wiki_t1id#wrk_solution_id#" id="wiki_t1id#wrk_solution_id#" value="#WIKI#" />
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group medium">
                                <div class="input-group">
                                    <div class="input-group_tooltip input-group_tooltip_v2"><cf_get_lang dictionary_id='46931.Video'></div>
                                    <input type="text" name="video_t1id#wrk_solution_id#" id="video_t1id#wrk_solution_id#" value="#VIDEO#" />
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <a href="javascript://" class="ui-btn ui-btn-success" onclick="saveObject(1,#wrk_solution_id#)"><cf_get_lang dictionary_id='57461.Kaydet'></a>
                            </div>
                            <div id="solutionSubElementsTr#wrk_solution_id#" style="display:none">            	
                                <div id = "solutionSubElementsDiv#wrk_solution_id#"></div>            
                             </div>
                        </div>
                    </li>
                </cfoutput>
            </ul>	
        
    </div>
</cf_box>
    <script type="text/javascript">
     
        function saveObject(objectType,id) { // types---> 1 : solution, 2: family, 3: module, 4: object
            switch(objectType) {
                case 1:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&solution=' + $('#solution_t1id'+ id).val() + '&solution_dictionary_id=' + $('#solution_dictionary_id_t1id'+ id).val() + '&solution_type=' + $('#solution_type_t1id'+ id).val() + '&is_menu=' + $('#is_menu_t1id'+ id).val()+ '&iconS=' + $('#iconS_t1id' + id).val() +'&divId=solutionSubElementsTr'+id + '&wiki=' + $('#wiki_t1id'+ id).val() + '&video=' + ($('#video_t1id'+ id).val()).replace(/=/g, "|"),'solutionSubElementsDiv'+id);
                    break;
                case 2:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&family=' + $('#family_t2id'+ id).val() + '&family_dictionary_id=' + $('#family_dictionary_id_t2id'+ id).val() + '&family_type=' + $('#family_type_t2id'+ id).val() + '&is_menu=' + $('#is_menu_t2id'+ id).val()+ '&iconF=' + $('#iconF_t2id' + id).val() +'&divId=familySubElementsTr'+id + '&wiki=' + $('#wiki_t2id'+ id).val() + '&video=' + ($('#video_t2id'+ id).val()).replace(/=/g, "|"),'familySubElementsDiv'+id);
                    break;
                case 3:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&module=' + $('#module_t3id'+ id).val() + '&solution_dictionary_id=' + $('#solution_dictionary_id_t3id'+ id).val() + '&family_dictionary_id=' + $('#family_dictionary_id_t3id'+ id).val() + '&module_dictionary_id=' + $('#module_dictionary_id_t3id'+ id).val() + '&module_type=' + $('#module_type_t3id'+ id).val() + '&is_menu=' + $('#is_menu_t3id'+ id).val()+ '&iconM=' + $('#iconM_t3id' + id).val() +'&divId=moduleSubElementsTr'+id + '&wiki=' + $('#wiki_t3id'+ id).val() + '&video=' + ($('#video_t3id'+ id).val()).replace(/=/g, "|"),'moduleSubElementsDiv'+id);
                    break;
                case 4:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&object=' + $('#object_t4id'+ id).val() + '&object_dictionary_id=' + $('#object_dictionary_id_t4id'+ id).val() + '&object_type=' + $('#object_type_t4id'+ id).val() + '&is_menu=' + $('#is_menu_t4id'+ id).val() + '&event_default=' + $('#object_default_t4id'+ id).val()+ '&iconO=' + $('#iconO_t4id' + id).val() +'&divId=objectsTr_'+id + '&wiki=' + $('#wiki_t4id'+ id).val() + '&video=' + $('#video_t4id'+ id).val(),'objectsTrDiv_'+id);
                    break;
                case -1: // Yeni solution kaydı
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&solution=' + $('#solution_t1id'+ id).val() + '&solution_dictionary_id=' + $('#solution_dictionary_id_t1id'+ id).val() + '&solution_type=' + $('#solution_type_t1id'+ id).val() + '&is_menu=' + $('#is_menu_t1id'+ id).val()+ '&iconS=' + $('#iconS_t1id' + id).val() +'&divId=solutionSubElementsTr'+id,'solutionSubElementsDiv'+id);
                    break;
                case -2: // Yeni family kaydı
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&family=' + $('#family_t2id'+ id).val() + '&family_dictionary_id=' + $('#family_dictionary_id_t2id'+ id).val() + '&family_type=' + $('#family_type_t2id'+ id).val() + '&is_menu=' + $('#is_menu_t2id'+ id).val()+ '&iconF=' + $('#iconF_t2id' + id).val() +'&relatedSolution='+id+'&divId=familySubElementsTr'+id,'familySubElementsDiv'+id);
                    break;
                case -3: // Yeni module kaydı
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mm&form_submitted=1&objectType=' + objectType + '&id=' + id + '&module=' + $('#module_t3id'+ id).val() + '&module_dictionary_id=' + $('#module_dictionary_id_t3id'+ id).val() + '&module_type=' + $('#module_type_t3id'+ id).val() + '&is_menu=' + $('#is_menu_t3id'+ id).val()+ '&iconM=' + $('#iconM_t3id' + id).val() +'&relatedFamily='+id+'&divId=moduleSubElementsTr'+id,'moduleSubElementsDiv'+id);
                    break;
            }
        }
        function subElements(objectType,id) { // types---> 1 : solution, 2: family, 3: module, 4: object
            switch(objectType) {
                case 1:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements&type=' + objectType + '&id=' + id,'solutionSubElementsDiv' + id);
                    $('#solutionSubElementsTr' + id).toggle();
                    break;
                case 2:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements&type=' + objectType + '&id=' + id,'familySubElementsDiv' + id);
                    $('#familySubElementsTr' + id).toggle();
                    break;
                case 3:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements&type=' + objectType + '&id=' + id,'moduleSubElementsDiv' + id);
                    $('#moduleSubElementsTr' + id).toggle();
                    break;
                case -1:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements&type=1&relatedSolution='+id+'&id=' + id,'solutionSubElementsDiv' + id);
                    $('#solutionSubElementsTr' + id).toggle();
                    break;
                case -2:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements&type=2&relatedFamily=' + id + '&id=' + id,'familySubElementsDiv' + id);
                    $('#familySubElementsTr' + id).toggle();
                    break;
            }
        }	
        
        $("#sorterSolution").sortable({
            connectWith		: '#sorterSolution',
            items			: 'li',
            handle			: '#handleSolution',
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
                sorterSave('s');
            }//stop
        });	
        
        var set ={solution:[],familie:[],module:[],object:[]};
        
        function sorterSave(type,list){	
            switch(type) {
                case 's':
                            
                        set.solution=[];			
                        $('ul#sorterSolution').children('li').each(function(index) {			
                            var id = $(this).attr('id').split('wrkSolution')[1];
                            set.solution.push({'solutionId':id,'value':index+1});			
                        });
                        var data = {'solutions' : JSON.stringify(set.solution)};
                        $.ajax({
                            url 	: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mmsorter&sorttype=solution",
                            type	: "POST",
                            data	:	data,
                            success: function(data, textStatus, jqXHR)
                            {
                                //console.log(data);
                            },
                            error: function (jqXHR, textStatus, errorThrown)
                            {
                         
                            }
                        });
                    
                    break;
                    
                case 'f':
                
                        set.familie=[];			
                        $('#'+list).children('li').each(function(index) {			
                            var id = $(this).attr('id').split('wrkFamilie')[1];
                            set.familie.push({'familieId':id,'value':index+1});			
                        });
                        var data = {'familie' : JSON.stringify(set.familie)};
                        $.ajax({
                            url 	: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mmsorter&sorttype=familie",
                            type	: "POST",
                            data	:	data,
                            success: function(data, textStatus, jqXHR)
                            {
                                //console.log(data);
                            },
                            error: function (jqXHR, textStatus, errorThrown)
                            {
                         
                            }
                        });
                    
                    break;
                    
                case 'm':
                
                        set.module=[];			
                        $('#'+list).children('li').each(function(index) {			
                            var id = $(this).attr('id').split('wrkModule')[1];
                            set.module.push({'moduleId':id,'value':index+1});			
                        });
                        var data = {'module' : JSON.stringify(set.module)};
                        console.log(data);
                        $.ajax({
                            url 	: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mmsorter&sorttype=module",
                            type	: "POST",
                            data	:	data,
                            success: function(data, textStatus, jqXHR)
                            {
                                //console.log(data);
                            },
                            error: function (jqXHR, textStatus, errorThrown)
                            {
                         
                            }
                        });
                    
                    break;
                    
                case 'o':
                        set.object=[];			
                        $('#'+list).children('li').each(function(index) {			
                            var id = $(this).attr('id').split('wrkObject')[1];
                            set.object.push({'objectId':id,'value':index+1});			
                        });
                        var data = {'object' : JSON.stringify(set.object)};
                        $.ajax({
                            url 	: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=mmsorter&sorttype=object",
                            type	: "POST",
                            data	:	data,
                            success: function(data, textStatus, jqXHR)
                            {
                                //console.log(data);
                            },
                            error: function (jqXHR, textStatus, errorThrown)
                            {
                         
                            }
                        });
                    
                    break;
                    
                default:
                    console.log('Sorter Save Default');
            }
            
        };
          
        $(function() {		
            $('#sorterSolution').children('li').each(function(index) {				
                $(this).children().children().children('.fa-sort').empty();
                $(this).children().children().children('.fa-sort').append(index+1);
            });
        });//ready       
    </script>
</cfif>