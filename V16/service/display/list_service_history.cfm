<cfquery name="GET_SERVICE_HISTORY" datasource="#DSN3#">
	SELECT
		SERVICE_HISTORY.SERVICE_ID,
		SERVICE_HISTORY.UPDATE_DATE,
		SERVICE_HISTORY.SERVICECAT_ID,
		SERVICE_HISTORY.SERVICE_STATUS_ID,
		SERVICE_HISTORY.SERVICE_SUBSTATUS_ID,
		SERVICE_HISTORY.UPDATE_MEMBER,
		SERVICE_HISTORY.UPDATE_PAR,
		SERVICE_HISTORY.APPLICATOR_NAME,
		SERVICE_HISTORY.SERVICE_DETAIL,
		SERVICE_HISTORY.SERVICE_HISTORY_ID,
		SERVICE_HISTORY.RECORD_DATE,
		SERVICE_HISTORY.RECORD_MEMBER,
        SERVICE_HISTORY.START_DATE,
        SERVICE_HISTORY.APPLY_DATE,
        SERVICE_HISTORY.FINISH_DATE,
        SERVICE_HISTORY.INTERVENTION_DATE,
		SERVICE.SERVICE_NO,
		B.BRANCH_NAME
	FROM
		SERVICE_HISTORY LEFT JOIN #dsn_alias#.BRANCH B ON SERVICE_HISTORY.SERVICE_BRANCH_ID = B.BRANCH_ID,
		SERVICE 
	WHERE
        SERVICE_HISTORY.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.service_id#"> AND SERVICE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.service_id#">
	ORDER BY <!--- order seklini degistirmeyin yo30102009--->
		SERVICE_HISTORY.UPDATE_DATE DESC,
		SERVICE_HISTORY.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN3#">
	SELECT 
		SERVICECAT,
		SERVICECAT_ID 
	FROM 
		SERVICE_APPCAT 
</cfquery>
<cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
	SELECT 
		SERVICE_SUBSTATUS_ID,SERVICE_SUBSTATUS 
	FROM 
		SERVICE_SUBSTATUS
</cfquery>
<cfif get_cat.recordcount>
	<cfset cat_ids = valuelist(get_cat.servicecat_id)>
	<cfset cat_names = valuelist(get_cat.servicecat)>
</cfif>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS ORDER BY PROCESS_ROW_ID
</cfquery>

<cfparam name="attributes.modal_id" default="">

<cf_box title="#getLang('main',61)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfset counter = 1>
    <cfif get_service_history.recordcount>
        <cfset temp_ = 0>
        <cfoutput query="get_service_history" > 
            <cfset temp_ = temp_ +1>
            <cfsavecontent variable="header_txt">
                <cfif len(get_service_history.record_date) and not len(get_service_history.update_date)>
                    #dateformat(record_date,dateformat_style)# (#timeformat(record_date,timeformat_style)#)
                <cfelse>
                    #dateformat(update_date,dateformat_style)# (#timeformat(update_date,timeformat_style)#)
                </cfif> -  
                <cfif len(get_service_history.update_member)>
                    #get_emp_info(get_service_history.update_member,0,0)#
                <cfelseif len(get_service_history.update_par)>
                    #get_par_info(get_service_history.update_par,0,0,0)#
                <cfelseif len(get_service_history.record_member)>
                    #get_emp_info(get_service_history.record_member,0,0)#
                </cfif>
            </cfsavecontent>
            <cf_seperator id="history_#temp_#" header="#header_txt#" is_closed="1">
            <cf_box_elements id="history_#temp_#" style="display:none;">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57487.No'></label>
                        <div class="col col-8 col-sm-12">
                            #service_no#
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_service_history.update_date)>
                                #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)
                            <cfelseif len(get_service_history.record_date)>
                                #dateformat(date_add('h',session.ep.time_zone,get_service_history.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)
                            </cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='41671.Başvuru Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_service_history.apply_date)>
                                #dateformat(date_add('h',session.ep.time_zone,apply_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#)
                            </cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='38749.Kabul Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_service_history.start_date)>
                                #dateformat(date_add('h',session.ep.time_zone,start_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,start_date),timeformat_style)#)
                            </cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='41706.Müdahale Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_service_history.start_date)>
                                <cfif len(get_service_history.intervention_date)>
                                    #dateformat(date_add('h',session.ep.time_zone,intervention_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,intervention_date),timeformat_style)#)
                                </cfif>
                            </cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_service_history.finish_date)>
                                #dateformat(date_add('h',session.ep.time_zone,finish_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,finish_date),timeformat_style)#)
                            </cfif>
                        </div>                
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                        <div class="col col-8 col-sm-12">
                            <!---<cfif len(service_branch_id)>
                                <cfset attributes.branch_id = service_branch_id>
                                <cfinclude template="../query/get_branch.cfm">
                                #get_branch.branch_name#
                            </cfif>--->
                            <cfif len(branch_name)>#branch_name#</cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-sm-12">
                            <!---#GET_CAT.SERVICECAT#--->
                            <cfif listfindnocase(cat_ids,servicecat_id) neq 0 and (listlen(cat_names) neq 0)>
                                #listgetat(cat_names,listfindnocase(cat_ids,servicecat_id))#
                            </cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                        <div class="col col-8 col-sm-12">
                            <!---#GET_STATUS.SERVICE_STATUS#--->
                            <cfif len(service_status_id)>
                                <cfquery name="GET_STATUS_ROW" dbtype="query">
                                    SELECT * FROM GET_STATUS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_status_id#">
                                </cfquery>
                                <cfif get_status_row.recordcount>
                                    #get_status_row.stage#
                                </cfif>
                            </cfif>
                            <!--- <cfif listfindnocase(status_ids,service_status_id) neq 0 and (listlen(status_names) neq 0)>
                                #listgetat(status_names,listfindnocase(status_ids,service_status_id))#
                            </cfif> --->
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58973.Alt Aşama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(service_substatus_id)>
                                <cfquery name="GET_SUBSTATUS" dbtype="query">
                                    SELECT * FROM GET_SERVICE_SUBSTATUS WHERE SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_substatus_id#">
                                </cfquery>
                                #get_substatus.service_substatus#
                            </cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                        <div class="col col-8 col-sm-12">
                            #applicator_name#
                        </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            #service_detail#
                        </div>                
                    </div>
                </div>
            </cf_box_elements>
        </cfoutput>
    </cfif>
 </cf_box>
