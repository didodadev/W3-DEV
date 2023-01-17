<cfinclude template="../../training_management/scorm_engine/core.cfm">
<cfscript>
	get_class_action = createObject("component","V16.training.cfc.get_class");
	get_class_action.dsn = dsn;
	get_class = get_class_action.get_class_fnc
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
					);
</cfscript>
<cfscript>
	get_training_sco_action = createObject("component","V16.training.cfc.get_training_sco");
	get_training_sco_action.dsn = dsn;
	get_training_sco = get_training_sco_action.get_training_sco_fnc
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
					);
</cfscript>
<cfquery name="GET_RELATED_CLASSES" datasource="#DSN#">
	SELECT ACTION_TYPE_ID, CLASS_ID FROM CLASS_RELATION WHERE ACTION_TYPE = 'CLASS_ID' AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery>
<cf_ajax_list>
	<tbody>
	<cfif get_training_sco.recordcount>
		<cfoutput query="get_training_sco">
        	<tr>
            	<td valign="top" width="20">#currentrow# - </td>
                <td>
                    <!---İlişkili eğitim var ise o eğitime bağlı içerikler tamamlandı ise bu eğitim izlenebilir SG 20120703--->
                    <cfset is_not_completed_say = 0>
                    <cfif get_related_classes.recordcount>
                    	<cfloop query="get_related_classes">
							<cfscript>
                                get_sco_action = createObject("component","V16.training.cfc.get_training_sco");
                                get_sco_action.dsn = dsn;
                                get_sco = get_sco_action.get_training_sco_fnc
                                                (
                                                    module_name : fusebox.circuit,
                                                    class_id :get_related_classes.class_id
                                                );
                            </cfscript>
                            <cfloop query="get_sco">
                                <cfscript>
                                    get_sco_data_action = createObject("component","V16.training.cfc.get_training_class_scodata");
                                    get_sco_data_action.dsn = dsn;
                                    get_sco_data = get_sco_data_action.get_training_class_scodata_fnc
                                                    (
                                                        module_name : fusebox.circuit,
                                                        sco_id :get_sco.sco_id,
                                                        user_id:session.ep.userid,
                                                        is_completed_status :1
                                                    );
                                </cfscript>
                                <cfif get_sco_data.recordcount>
                                    <cfloop query="get_sco_data">
                                        <cfif completion_status neq 'completed'>
                                            <cfset is_not_completed_say = is_not_completed_say+1>
                                        </cfif>
                                    </cfloop>
                                <cfelse>
                                    <cfset is_not_completed_say = is_not_completed_say+1>
                                </cfif>
                            </cfloop>
                        </cfloop>
                    </cfif><!---eger iliskili egitimlerden herhangi bir icerigi izlemediyse "is_not_completed_say" degeri 0 dan büyük olarak gonderilir ve kontrol edilir.--->
                    <cfset encId = encrypt(get_training_sco.sco_id, 'trainingSCO','CFMX_COMPAT','hex')>
                    <a href="javascript://" onclick="openCourse('#encId#', event,#is_not_completed_say#);" class="tableyazi">#NAME#</a>&nbsp;
                    <cfquery name="GET_COMPLETION_STATUS" datasource="#DSN#">
                        SELECT ISNULL(VAR_VALUE, '') AS COMPLETION_STATUS FROM TRAINING_CLASS_SCO_DATA WHERE SCO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_training_sco.sco_id#"> AND USER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'completionStatus', version: get_training_sco.version)#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    #get_completion_status.completion_status#&nbsp;
                    <cfquery name="get_success_status" datasource="#APPLICATION_DB#">
                        SELECT ISNULL(VAR_VALUE, '') AS SUCCESS_STATUS FROM TRAINING_CLASS_SCO_DATA WHERE SCO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_training_sco.sco_id#"> AND USER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'successStatus', version: get_training_sco.version)#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    #get_success_status.success_status#&nbsp;
                    <cfquery name="GET_PROGRESS" datasource="#APPLICATION_DB#">
                        SELECT ISNULL(VAR_VALUE, '0') AS PROGRESS FROM #TABLE_SCO_DATA# WHERE SCO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sco_id#"> AND USER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'progress', version: get_training_sco.VERSION)#" cfsqltype="cf_sql_varchar">
                    </cfquery>
                    <cfif isNumeric(get_progress.progress)>% #round(get_progress.progress * 100)#<cfelse>#get_progress.progress#</cfif>
                </td>
            </tr>
            <tr>
                <td colspan="5"><hr size="1"></td>
            </tr>
        </cfoutput>
    <cfelse>
         <tr>
             <td height="20" colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
         </tr>
     </cfif>
 </tbody>
</cf_ajax_list>
