<cfparam name="attributes.form_submitted" default="0">
<cfif attributes.form_submitted eq 1>
	<cfswitch expression="#attributes.objectType#">
        <cfcase value="1">
            <cfif attributes.upd_related_schema eq '#dsn#'>
                <cfset attributes.upd_related_schema = 'dsn'>
            <cfelseif attributes.upd_related_schema eq '#dsn3#'>
                <cfset attributes.upd_related_schema = 'dsn3'>
            <cfelseif attributes.upd_related_schema eq '#dsn2#'>
                <cfset attributes.upd_related_schema = 'dsn2'>
            <cfelseif attributes.upd_related_schema eq '#dsn1#'>
                <cfset attributes.upd_related_schema = 'dsn1'>
            </cfif>
        	<cfquery name="updTask" datasource="#dsn#" result="r">
            	UPDATE
                	WRK_IMPLEMENTATION_STEP
                SET
                	WRK_IMPLEMENTATION_TASK = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.upd_dictionary_id#">,
                    WRK_IMPLEMENTATION_TYPE = <cfif len(upd_task_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_task_type#"><cfelse>NULL</cfif>,
                    WRK_OBJECTS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upd_wo_name#">,
                    WRK_RELATED_OBJECTS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upd_related_wo#">,
                    WRK_RELATED_TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upd_related_table#">,
                    WRK_RELATED_SCHEMA_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upd_related_schema#">,
                    WRK_RELATED_TABLE_COLUMN = <cfif len(attributes.upd_related_table_column)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upd_related_table_column#"><cfelse>NULL</cfif>,
                    WRK_CONDITION = <cfif len(attributes.upd_condition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.upd_condition#"><cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE
                	WRK_IMPLEMENTATION_STEP_ID = #attributes.step_id#
            </cfquery>
        </cfcase>
        <cfcase value="-1">
            <cfif attributes.related_schema eq '#dsn#'>
                <cfset attributes.related_schema = 'dsn'>
            <cfelseif attributes.related_schema eq '#dsn3#'>
                <cfset attributes.related_schema = 'dsn3'>
            <cfelseif attributes.related_schema eq '#dsn2#'>
                <cfset attributes.related_schema = 'dsn2'>
            <cfelseif attributes.related_schema eq '#dsn1#'>
                <cfset attributes.related_schema = 'dsn1'>
            </cfif>
            <cfquery name="updTask" datasource="#dsn#">
                INSERT INTO
                    WRK_IMPLEMENTATION_STEP
                (
                    WRK_MODUL_ID,
                    WRK_IMPLEMENTATION_TASK,
                    WRK_IMPLEMENTATION_TYPE,
                    WRK_OBJECTS,
                    WRK_RELATED_OBJECTS,
                    WRK_RELATED_TABLE_NAME,
                    WRK_RELATED_TABLE_COLUMN,
                    WRK_RELATED_SCHEMA_NAME,
                    WRK_IMPLEMENTATION_TASK_COMPLETE,
                    WRK_CONDITION,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.module#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#right(attributes.dictionary_id,-1)#">,
                    <cfif len(attributes.task_type) ><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_type#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.wo_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_wo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_table#">,
                    <cfif len(attributes.related_table_column) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_table_column#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_schema#">,
                    0, 
                    <cfif len(attributes.where_in) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.where_in#"><cfelse>NULL</cfif>,
                    #now()#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
            </cfquery>
		</cfcase>
        <cfcase value="-2">
            <cfquery name="delTask" datasource="#dsn#">
                DELETE FROM WRK_IMPLEMENTATION_STEP WHERE WRK_IMPLEMENTATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.step_id#">
            </cfquery>
        </cfcase>
    </cfswitch>
    <script>
		$("#<cfoutput>#attributes.divId#</cfoutput>").css('display','');
	</script>
    Kaydedildi
<cfelse>
	<cfscript>
        wdo = createObject("component","WDO.modalModuleMenu");
        getObjects = WDO.getObjects();
    </cfscript>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="Step By Step Implementation Design Tool">
            <div id="menuDesigner">
                <ul style="margin:0;padding:0;list-style-type:none;" id="sorterSolution">
                    <cfoutput query="getObjects">
                        <li id="wrkSolution#WRK_SOLUTION_ID#">
                            <div class="ui-form-list flex-list">
                                <div class="form-group">
                                    <a href="javascript://" style="background-color:##BF55EC;padding:0!important;width:30px;" class="ui-btn" onclick="subElements(1,#wrk_solution_id#)">O</a>
                                </div>
                                <div class="form-group large">
                                    <div class="input-group">
                                        <div class="input-group_tooltip input-group_tooltip_v2">Object Name</div>
                                        <input type="text" name="solution_t1id#wrk_solution_id#" id="solution_t1id#wrk_solution_id#" value="#SOLUTION#" disabled />
                                        <span class="input-group-addon icon-question input-group-tooltip"></span>
                                    </div>
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
    </div>

    <script type="text/javascript">
     
        function saveObject(objectType,id,step_id) {
            switch(objectType) {
                case 1:  // task update
                var data = new FormData();
                data.append("type", "is");
                data.append("form_submitted", 1);
                data.append("step_id", step_id);
                data.append("objectType", objectType);
                data.append("id", id);
                data.append("upd_dictionary_id", $('#upd_dictionary_id_'+ step_id).val());
                data.append("upd_task_type", $('#upd_task_type_'+ step_id).val());
                data.append("upd_wo_name", $('#upd_wo_name_'+ step_id).val());
                data.append("upd_related_wo", $('#upd_related_wo_'+ step_id).val());
                data.append("upd_related_table", $('#upd_related_table_'+ step_id).val());
                data.append("upd_related_schema", $('#upd_related_schema_'+ step_id).val());
                data.append("upd_condition", $('#upd_where_in_'+ step_id).val());
                data.append("upd_related_table_column", $('#upd_related_table_column_'+ step_id).val());
                data.append("divId", 'moduleSubElementsTr'+id);

                AjaxControlPostData('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system</cfoutput>',data,function(response) {
                    alert("<cf_get_lang dictionary_id='35811.Güncelleme işlemi Başarılı'>");
                    return false;
                });
                break;
                case -1: // Yeni task kaydı
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=is&form_submitted=1&objectType=' + objectType + '&id=' + id + '&module=' + $('#relatedModule_'+ id).val() + '&dictionary_id=' + $('#dictionary_id_'+ id).val() + '&task_type=' + $('#task_type_'+ id).val() + '&wo_name=' + $('#wo_name_'+ id).val() + '&related_wo=' + $('#related_wo_'+ id).val() + '&related_table=' + $('#related_table_'+ id).val() + '&related_table_column=' + $('#related_table_column_'+ id).val() + '&related_schema='+ $('#related_schema_'+ id).val() + '&where_in='+ $('#where_in_'+ id).val() +'&divId=moduleSubElementsTr'+id,'moduleSubElementsDiv'+id);
                    break;
            }
        }
        function subElements(objectType,id) { // types---> 1 : solution, 2: family, 3: module, 4: object
            switch(objectType) {
                case 1:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements_impsteps&type=' + objectType + '&id=' + id,'solutionSubElementsDiv' + id);
                    $('#solutionSubElementsTr' + id).toggle();
                    break;
                case 2:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements_impsteps&type=' + objectType + '&id=' + id,'familySubElementsDiv' + id);
                    $('#familySubElementsTr' + id).toggle();
                    break;
                case 3:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements_impsteps&type=' + objectType + '&id=' + id,'moduleSubElementsDiv' + id);
                    //$('#moduleSubElementsTr' + id).toggle();
                    break;
                case -1:
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_menu_sub_elements_impsteps&type=3&relatedModule='+id+'&id=' + id,'moduleSubElementsDiv' + id);
                    //$('#moduleSubElementsTr' + id).toggle();
                    break;
            }
        }

        function deleteObject(step_id,id){
            var rtn = confirm("Task Will be Deleted.");
            if(rtn){
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=is&form_submitted=1&step_id='+ step_id +'&objectType=-2'+'&divId=moduleSubElementsTr'+id,'moduleSubElementsDiv'+id);
            }
        }

        var set ={object:[]};
        
        function sorterSave(type,list){	
            switch(type) {
                case 'o':
                        set.object=[];			
                        $('#'+list).children('li').each(function(index) {			
                            var id = $(this).attr('id').split('wrkObject')[1];
                            set.object.push({'objectId':id,'value':index+1});			
                        });
                        var data = {'object' : JSON.stringify(set.object)};
                        $.ajax({
                            url 	: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=issorter&sorttype=task",
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