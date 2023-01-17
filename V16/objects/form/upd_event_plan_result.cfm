<cf_xml_page_edit fuseact="objects.popup_upd_event_plan_result">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_STAGE_ROWS" datasource="#DSN#">
	SELECT VISIT_STAGE_ID, VISIT_STAGE FROM SETUP_VISIT_STAGES ORDER BY VISIT_STAGE
</cfquery>
<cfquery name="GET_EXPENSE_ROWS" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>
<cfquery name="GET_ROWS" datasource="#DSN#">
	SELECT * FROM EVENT_PLAN_ROW where EVENT_PLAN_ROW_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#">
</cfquery>
<cfquery name="GET_PLAN_ROW" datasource="#DSN#">
	SELECT
		2 TYPE,
		EVENT_PLAN_ROW.*,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.EXPENSE_ID,
		EVENT_PLAN.EST_LIMIT,
		EVENT_PLAN.EVENT_CAT,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN.EVENT_PLAN_ID,
		EVENT_PLAN.MAIN_START_DATE,
		EVENT_PLAN.MAIN_FINISH_DATE,
		CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME FULLNAME,
		CONSUMER.CONSUMER_ID,
		'CONSUMER' MEMBER_TYPE,
		CONSUMER.CONSUMER_ID MEMBER_ID,
		'' COMPANY_ID,
		'' PARTNER_ID,
		CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME MEMBER_PARTNER_NAME,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN.ANALYSE_ID
	FROM
		CONSUMER,
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN_ROW.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#">
		
	UNION ALL
	
	SELECT
		1 TYPE,
		EVENT_PLAN_ROW.*,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.EXPENSE_ID,
		EVENT_PLAN.EST_LIMIT,
		EVENT_PLAN.EVENT_CAT,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN.EVENT_PLAN_ID,
		EVENT_PLAN.MAIN_START_DATE,
		EVENT_PLAN.MAIN_FINISH_DATE,
		COMPANY.FULLNAME,
		'' CONSUMER_ID,
		'PARTNER' MEMBER_TYPE,
		COMPANY.COMPANY_ID MEMBER_ID,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER.PARTNER_ID PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_PARTNER_NAME,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN.ANALYSE_ID
	FROM
		COMPANY,
		COMPANY_PARTNER,
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN_ROW.COMPANY_ID = COMPANY.COMPANY_ID AND
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#">
</cfquery>
<cfparam  name="attributes.member_id" default="">
<cfparam  name="attributes.fullname" default="">
<cfparam  name="attributes.partner_id" default="">
<cfparam  name="attributes.event_plan_row_id" default="">
<cfparam  name="attributes.member_partner_name" default="">
<cfparam  name="attributes.asset_id" default="">
<cfparam  name="attributes.eventid" default="">
<cfparam  name="attributes.result_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='34178.Ziyaret Sonucu Güncelle'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-10">
  
    <cf_box title="#message#:#attributes.event_plan_row_id#" collapsable="1" resize="0"  add_href="openBoxDraggable('#request.self#?fuseaction=objects.event_plan_result&event=add&event_plan_row_id=#attributes.event_plan_row_id#&eventid=#attributes.eventid#');"popup_box="1" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#url.event_plan_row_id#&action_row_id=0&print_type=75">    
    <cfform name="event_result" action="#request.self#?fuseaction=objects.emptypopup_upd_event_plan_result" method="post">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <label class="col col-12 col-sm-12"><cf_get_lang dictionary_id="62324. Ziyaret sonucu aşağıdaki aksiyonları eklemek içim tıklayınız!"></label>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12 icons" >
            <cfinclude template="../form/plan_event_icon.cfm">
        </div>
        <cfsavecontent variable="title1"><cf_get_lang dictionary_id='58131.Temel Bilgiler'></cfsavecontent>
        <cfsavecontent variable="title2"><cf_get_lang dictionary_id='30219.Ek Bilgiler'></cfsavecontent>
        <cf_tab divID = "sayfa_1,sayfa_2" defaultOpen="sayfa_1" divLang = "#title1#;#title2#" tabcolor = "fff">
            <div id="unique_sayfa_1" class="scroll uniqueBox">
                <cf_box_elements id="genel_bilgiler" vertical="1">
                    <input type="hidden" name="eventid" id="eventid" value="<cfoutput>#attributes.eventid#</cfoutput>">
                    <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
                    <input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="32669.Plan"></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput>#get_plan_row.event_plan_head#</cfoutput>
                        </div>   
                    </div>  
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34030.Ziyaret Nedeni'></label>
                        <div class="col col-8 col-sm-12">
                            <cfquery name="GET_VISIT_TYPE" datasource="#DSN#">
                                SELECT VISIT_TYPE,VISIT_TYPE_ID FROM SETUP_VISIT_TYPES WHERE VISIT_TYPE_ID = #get_plan_row.warning_id#
                            </cfquery>
                            <cfoutput>#get_visit_type.visit_type#</cfoutput>  
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58881.Plan Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput>#dateformat(get_plan_row.start_date,dateformat_style)# #timeformat(get_plan_row.start_date,timeformat_style)#</cfoutput> -   
                            <cfoutput>#timeformat(get_plan_row.finish_date,timeformat_style)#</cfoutput>    
                        </div> 
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34029.Ziyaret Edilen'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif GET_PLAN_ROW.type eq 1>
                                <cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_plan_row.member_id#','medium');" class="tableyazi">#get_plan_row.fullname#</a></cfoutput>
                            <cfelse>
                                <cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&consumer_id=#get_plan_row.member_id#','medium');" class="tableyazi">#get_plan_row.fullname#</a></cfoutput>
                            </cfif>     
                        </div>  
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">         
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34028.Ziyaret Formu'></label>
                        <div class="col col-8 col-sm-12">
                                <cfif len(get_plan_row.analyse_id)>
                                    <cfset Analyse_Link = "">
                                    <cfquery name="get_analyse_member" datasource="#dsn#">
                                        SELECT
                                            MAR.RESULT_ID,
                                            MA.ANALYSIS_ID,
                                            MA.ANALYSIS_HEAD
                                        FROM
                                            MEMBER_ANALYSIS MA,
                                            MEMBER_ANALYSIS_RESULTS MAR
                                        WHERE
                                            MA.ANALYSIS_ID = MAR.ANALYSIS_ID AND
                                            MA.ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.analyse_id#"> AND
                                            <cfif Len(get_plan_row.company_id)>
                                                MAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.company_id#"> AND
                                                MAR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.partner_id#">
                                            <cfelseif Len(get_plan_row.consumer_id)>
                                                MAR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.consumer_id#">
                                            </cfif>
                                    </cfquery>
                                    <cfif get_analyse_member.recordcount>
                                        <cfset Analyse_Link = "#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=MEMBER&analysis_id=#get_plan_row.analyse_id#&result_id=#get_analyse_member.result_id#">
                                        <cfif Len(get_plan_row.company_id)>
                                            <cfset Analyse_Link = Analyse_Link & "&member_type=partner&company_id=#get_plan_row.company_id#&partner_id=#get_plan_row.partner_id#">
                                        <cfelse>
                                            <cfset Analyse_Link = Analyse_Link & "&member_type=consumer&consumer_id=#get_plan_row.consumer_id#">
                                        </cfif>
                                    <cfelse>
                                        <cfquery name="get_analyse_member" datasource="#dsn#">
                                            SELECT ANALYSIS_ID, ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.analyse_id#">
                                        </cfquery>
                                        <cfif get_analyse_member.recordcount>
                                            <cfset Analyse_Link = "#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=MEMBER&action_type_id=&analysis_id=#get_analyse_member.analysis_id#">
                                            <cfif Len(get_plan_row.company_id)>
                                                <cfset Analyse_Link = Analyse_Link & "&member_type=partner&company_id=#get_plan_row.company_id#&partner_id=#get_plan_row.partner_id#">
                                            <cfelse>
                                                <cfset Analyse_Link = Analyse_Link & "&member_type=consumer&consumer_id=#get_plan_row.consumer_id#">
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                    <cfif Len(Analyse_Link)>
                                        <cfoutput><a href="javascript://" onclick="windowopen('#Analyse_Link#','list');">#get_analyse_member.analysis_head#&nbsp;</a></cfoutput>
                                    </cfif>
                                </cfif>
                        </div>                
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">    
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57590.Katılımcılar'></label>
                        <div class="col col-8 col-sm-12"> 
                            <cfquery name="GET_POSIDS" datasource="#DSN#">
                                SELECT EVENT_POS_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#event_plan_row_id#">
                            </cfquery>
                            <cfset get_posids_list = Valuelist(GET_POSIDS.event_pos_id,',')>
                            <cfoutput query="GET_POSIDS">#get_emp_info(event_pos_id,1,0)#<cfif get_posids.currentrow neq get_posids.recordcount>,</cfif></cfoutput>
                        </div> 
                    </div>
                    <cfif listfind(get_posids_list, session.ep.position_code, ',')> 
                        <div class="col col-12">
                        <cf_seperator title="Açıklama" id="detail_seperator">
                            <div style="display:none;" id="detail_seperator">
                                <div class="col col-12">
                                    <div class="form-group" id="item-editor">
                                        <label style="display:none!important">Detail</label>
                                        <div class="col col-12" id="editor_id">
                                            <cfmodule template="/fckeditor/fckeditor.cfm"
                                            toolbarset="Basic"
                                            basepath="/fckeditor/"
                                            instancename="result"
                                            valign="top"
                                            value="#get_plan_row.result_detail#"
                                            maxCharCount="400"
                                            width="100%"
                                            height="180"> 
                                        </div>
                                    </div>
                                    </div>
                                </div>
                            </div>
                    
                    <cfelse>  
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" > 
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                                <div class="col col-8 col-sm-12">
                                <cfoutput>#get_plan_row.result_detail#</cfoutput>
                                </div>
                            </div> 
                    </cfif> 
                    <cfif listfind(get_posids_list, session.ep.position_code, ',')>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12"<!--- type="column" index="5" sort="true" --->>
                            <div class="form-group" id="item-process_stage">
                            <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-3 col-sm-12">    
                                    <cfif Len(get_plan_row.result_process_stage)>
                                        <cf_workcube_process is_upd='0' process_cat_width='180' select_value='#get_plan_row.result_process_stage#' is_detail='1'>
                                    <cfelse>
                                        <cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>
                                    </cfif>
                                </div>
                            
                                <label class="col col-1 col-sm-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
                                <div class="col col-3 col-sm-12"> 
                                    <select name="visit_stage" id="visit_stage">
                                        <option value=""><cf_get_lang dictionary_id="57482.Aşama"></option>
                                        <cfoutput query="get_stage_rows">
                                            <option value="#visit_stage_id#" <cfif visit_stage_id eq get_plan_row.visit_stage>selected</cfif>>#visit_stage#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                        </div>
                    </div>
                    <cfelse> 
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                            <div class=" col col-8 col-sm-12">  
                                <cfif len(get_plan_row.result_process_stage)>
                                    <cfquery name="get_process_row_name" datasource="#DSN#">
                                        SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.result_process_stage#">
                                    </cfquery>
                                    <cfoutput>#get_process_row_name.stage#</cfoutput>
                                </cfif>  
                            </div>
                        </div>
                    
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" <!--- type="column" index="5" sort="true" --->>
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
                            <div class="col col-8 col-sm-12">
                                <cfoutput query="get_stage_rows">
                                    <cfif visit_stage_id eq get_plan_row.visit_stage>#visit_stage#</cfif>
                                </cfoutput>
                            </div>
                        </div>
                    </cfif> 
                    <cfif xml_is_result_category eq 1> 
                        <cfquery datasource="#dsn#" name="getResultCats">
                            SELECT VISIT_RESULT_ID,VISIT_RESULT FROM SETUP_VISIT_RESULT WHERE VISIT_TYPE_ID = #get_visit_type.visit_type_id# AND IS_ACTIVE = 1
                        </cfquery>
                        <cfif listfind(get_posids_list, session.ep.position_code, ',')>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" ><!--- type="column" index="6" sort="true" --->
                                <div class="form-group" id="item-visit_stage">
                                    <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id ='57684.Sonuç'></label>
                                    <div class="col col-3 col-sm-12">
                                        <select name="visit_result_category" id="visit_result_category"  >
                                            <cfoutput query="getResultCats">
                                                <option value="#visit_result_id#" <cfif ListFindNoCase(get_plan_row.visit_result_id,visit_result_id)>selected</cfif>>#visit_result#</option>
                                            </cfoutput>
                                        </select>
                                    </div> 
                                </div> 
                            </div>
                        <cfelse>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" <!--- type="column" index="6" sort="true" --->>
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57684.Sonuç'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfoutput query="getResultCats">
                                        <cfif ListFindNoCase(get_plan_row.visit_result_id,visit_result_id)>#visit_result# <br /></cfif>
                                    </cfoutput>
                                </div> 
                            </div>
                        </cfif> 
                    
                    </cfif>
                    <cfif xml_is_result_category eq 1>    
                        <cfif listfind(get_posids_list, session.ep.position_code, ',')> 
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" <!--- type="column" index="7" sort="true" --->>
                                    <div class="form-group" id="item-expense"> 
                                        <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id ='34024.Harcama'></label>
                                        <div class="col col-3 col-sm-12">
                                            <select name="expense_item" id="expense_item" >
                                                <option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
                                                <cfoutput query="get_expense_rows">
                                                    <option value="#expense_item_id#" <cfif expense_item_id eq get_plan_row.expense_item>selected</cfif>>#expense_item_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                        <div class="col col-1 col-sm-12">
                                        
                                            <cfinput type="text" name="visit_expense" value="#get_plan_row.expense#" onKeyup='return(FormatCurrency(this,event));' class="moneybox" >
                                        </div>
                                        <div class="col col-1 col-sm-12">
                                            <select name="money_name" id="money_name" >
                                                <cfoutput query="get_money">
                                                    <option value="#money#" <cfif money eq get_plan_row.money_currency>selected</cfif>>#money#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            <cfelse> 
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34024.Harcama'></label>
                                    <div class="col col-8 col-sm-12">
                                        <cfoutput>#tlformat(get_plan_row.expense)# #get_plan_row.money_currency#</cfoutput>
                                    </div>
                                </div>
                            </cfif>  
                        </cfif>
                        <cfif listfind(get_posids_list, session.ep.position_code, ',')> 
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
                                <div class="form-group" id="item-execute_startdate"> 
                                    <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id ='34025.Gerçekleşme Tarihi'>*</label>
                                    <div class="col col-3 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                                            <cfinput validate="#validate_style#"  type="text"  name="execute_startdate" id="execute_startdate" message="#alert#" value="#dateformat(get_plan_row.execute_startdate,dateformat_style)#"  >
                                            <span class="input-group-addon "><cf_wrk_date_image date_field="execute_startdate" c_position="Tl"></span>
                                                
                                        </div>
                                    </div>
                                    
                                    <div class="col col-1 col-sm-12">
                                        <cf_wrkTimeFormat name="execute_start_clock" value="#timeformat(get_plan_row.execute_startdate,"HH")#"> 
                                        </div>
                                    <div class="col col-1 col-sm-12">
                                        <select name="execute_start_minute" id="execute_start_minute" >
                                            <option value="00" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 00>selected</cfif>>00</option>
                                            <option value="05" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 05>selected</cfif>>05</option>
                                            <option value="10" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 10>selected</cfif>>10</option>
                                            <option value="15" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 15>selected</cfif>>15</option>
                                            <option value="20" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 20>selected</cfif>>20</option>
                                            <option value="25" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 25>selected</cfif>>25</option>
                                            <option value="30" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 30>selected</cfif>>30</option>
                                            <option value="35" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 35>selected</cfif>>35</option>
                                            <option value="40" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 40>selected</cfif>>40</option>
                                            <option value="45" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 45>selected</cfif>>45</option>
                                            <option value="50" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 50>selected</cfif>>50</option>
                                            <option value="55" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 55>selected</cfif>>55</option>
                                        </select>
                                    </div>
                                    <div class="col col-1 col-sm-12">
                                        <cf_wrkTimeFormat name="execute_finish_clock" value="#timeformat(get_plan_row.execute_finishdate,"HH")#">
                                    </div>
                                    <div class="col col-1 col-sm-12">
                                        <select name="execute_finish_minute" id="execute_finish_minute" >
                                            <option value="00" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 00>selected</cfif>>00</option>
                                            <option value="05" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 05>selected</cfif>>05</option>
                                            <option value="10" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 10>selected</cfif>>10</option>
                                            <option value="15" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 15>selected</cfif>>15</option>
                                            <option value="20" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 20>selected</cfif>>20</option>
                                            <option value="25" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 25>selected</cfif>>25</option>
                                            <option value="30" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 30>selected</cfif>>30</option>
                                            <option value="35" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 35>selected</cfif>>35</option>
                                            <option value="40" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 40>selected</cfif>>40</option>
                                            <option value="45" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 45>selected</cfif>>45</option>
                                            <option value="50" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 50>selected</cfif>>50</option>
                                            <option value="55" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 55>selected</cfif>>55</option>
                                        </select>
                                    </div> 
                                </div>
                            </div>
                    <cfelse> 
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" <!--- type="column" index="8" sort="true" --->>
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34025.Gerçekleşme Tarihi'>*</label>
                            <div class="col col-8 col-sm-12">
                                <cfoutput><cfif len(get_plan_row.execute_startdate)>#dateformat(get_plan_row.execute_startdate, dateformat_style)# #timeformat(get_plan_row.execute_startdate, timeformat_style)#</cfif></cfoutput>
                            </div>
                        </div>
                    </cfif>  
                </cf_box_elements>
            </div>    
                <div id="unique_sayfa_2" class="scroll uniqueBox">
                    <cf_box_elements id="temel bilgiler" verticable="1">
                    <cfif x_physical_reservation eq 1>
                        <cf_grid_list>
                            <thead>
                                <tr>
                                    
                                    <th width="102"><cf_get_lang dictionary_id='29452.Varlık'></th>
                                    <th width="235"><cf_get_lang dictionary_id='33160.Rezervasyon'></th>
                                    <th width="15"></th>
                                    <th width="15"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_assets&eventid=#attributes.eventid#&type=event_plan</cfoutput>" target="blank_"><i class="fa fa-plus" alt="<cf_get_lang no='503.Formu Doldur'>" title="<cf_get_lang_main no='170.Ekle'>" ></i></a></th>
                                    
                                </tr>
                            </thead>
                            <tbody>
                                <cfquery name="EVENT_ASSETP" datasource="#dsn#">
                                    SELECT 
                                        ASSET_P.ASSETP_ID,
                                        ASSET_P.ASSETP,
                                        ASSET_P_RESERVE.ASSETP_RESID,
                                        ASSET_P_RESERVE.STARTDATE,
                                        ASSET_P_RESERVE.FINISHDATE
                                    FROM 
                                        ASSET_P,
                                        ASSET_P_RESERVE
                                    WHERE
                                        ASSET_P_RESERVE.EVENT_PLAN_ID = #attributes.eventid# AND
                                        ASSET_P_RESERVE.ASSETP_ID = ASSET_P.ASSETP_ID
                                </cfquery>
                                <cfquery name="GET_EVENT" datasource="#dsn#">
                                    SELECT * FROM EVENT_PLAN WHERE EVENT_PLAN_ID = #attributes.eventid#
                                </cfquery>
                                <cfif EVENT_ASSETP.recordcount>
                                <cfoutput query="event_assetp">
                                    <tr>
                                        <td>#assetp#</td>
                                        <td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
                                        <td align="center"><a href="javascript:windowopen('#request.self#?fuseaction=assetcare.popup_form_upd_assetp_reserve&ASSETP_RESID=#ASSETP_RESID#&ASSETP_ID=#ASSETP_ID#','small');"><img src="/images/update_list.gif" border="0"></a></td>
                                        <td align="center"><a href="#request.self#?fuseaction=agenda.del_event_assetp&ASSETP_RESID=#ASSETP_RESID#"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id='58506.İptal'>" border="0"></a></td>
                                        <td align="center"><a href="javascript:windowopen('#request.self#?fuseaction=assetcare.popup_form_upd_assetp_reserve&ASSETP_RESID=#ASSETP_RESID#&ASSETP_ID=#ASSETP_ID#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>   
                                        </a>
                                    </td>
                                    </tr>
                                </cfoutput>
                            </tbody>  
                        <cfelse>  
                            <tbody> 
                                <tr>
                                    <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                                </tr>
                            </tbody> 
                        
                        </cfif>
                            <!---  <tfoot>   
                                <tr id="assetp_reserve">
                                    <td colspan="4"> 
                                        <cfoutput><input type="button" value="<cf_get_lang dictionary_id ='34180.Fiziki Varlık Rezervasyon'>" style="width:140px;" onclick="windowopen('#request.self#?fuseaction=objects.popup_assets&eventid=#attributes.eventid#&type=event_plan<!--- <cfif len(get_event.link_id)>&link_id=#get_event.link_id#&warning_type='+document.upd_event.warning_type.value+'</cfif> --->','project');"></cfoutput>
                                    </td>
                                </tr>
                            </tfoot>        --->
                        </cf_grid_list>
                    </cfif>
                    <cfif x_event_related_ship_info eq 1 or x_event_related_order_info eq 1>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="50%">
                                    <cfif Len(get_plan_row.company_id)>
                                        <cfset add_link_ = "&company_id=#get_plan_row.company_id#&partner_id=#get_plan_row.partner_id#">
                                    <cfelse>
                                        <cfset add_link_ = "&consumer_id=#get_plan_row.consumer_id#">
                                    </cfif>
                                    <cfset add_link_ = "#add_link_#&related_action_table=EVENT_PLAN_ROW&related_action_id=#get_plan_row.event_plan_row_id#">
                                    <!--- &process_cat=193 default islem tipi gonderilmek istendiginde bu sekilde parametre gonderilebilir --->
                                    <cfif x_event_related_ship_info eq 1>
                                        <cfquery name="get_related_ships" datasource="#dsn2#">
                                            SELECT TOP 20
                                                S.SHIP_ID PAPER_ID,
                                                S.SHIP_NUMBER PAPER_NUMBER,
                                                S.SHIP_DATE PAPER_DATE,
                                                S.PURCHASE_SALES PAPER_TYPE,
                                                SUM(SR.AMOUNT) PAPER_AMOUNT,
                                                S.NETTOTAL PAPER_NETTOTAL
                                            FROM
                                                SHIP S,
                                                SHIP_ROW SR
                                            WHERE
                                                S.SHIP_ID = SR.SHIP_ID AND
                                                SR.RELATED_ACTION_TABLE = 'EVENT_PLAN_ROW' AND
                                                SR.RELATED_ACTION_ID = #get_plan_row.event_plan_row_id# AND
                                                <cfif Len(get_plan_row.company_id)>
                                                    S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.company_id#">
                                                <cfelse>
                                                    S.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.consumer_id#">
                                                </cfif>
                                            GROUP BY
                                                S.SHIP_ID,
                                                S.SHIP_NUMBER,
                                                S.SHIP_DATE,
                                                S.PURCHASE_SALES,
                                                S.NETTOTAL
                                            ORDER BY
                                                PAPER_DATE DESC
                                        </cfquery>
                                        <cf_grid_list margin="0">
                                            <thead>
                                                <tr>
                                                    <th colspan="5">
                                                        <cf_get_lang dictionary_id='32676.Numune Verilen Ürünler'>
                                                    </th>
                                                </tr>
                                                <tr>
                                                
                                                
                                                    <th width="100"><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
                                                    <th width="85" style="text-align:right;"><cf_get_lang dictionary_id='58777.Ürün Miktarı'></th>
                                                    <th width="85" style="text-align:right;"><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>  <th width="65" style="text-align:right;"><cf_get_lang dictionary_id='57742.Tarih'></th><th width="15"><a href="<cfoutput>#request.self#?fuseaction=stock.form_add_sale#add_link_#</cfoutput>" target="blank_"><i class="fa fa-plus" alt="<cf_get_lang no='503.Formu Doldur'>" title="<cf_get_lang_main no='170.Ekle'>" ></i></a></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <cfif get_related_ships.recordcount>
                                                    <cfoutput query="get_related_ships">
                                                    <tr>
                                                        
                                                    
                                                        <td style="text-align:right;"><cfif paper_type eq 1><!--- Satis --->
                                                                <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#paper_id#" target="blank_" class="tableyazi">#paper_number#</a>
                                                            </cfif>
                                                        </td>
                                                        <td style="text-align:right;">#TLFormat(paper_amount)#</td>
                                                        <td style="text-align:right;">#TLFormat(paper_nettotal)#</td> 
                                                        <td style="text-align:right;">#DateFormat(paper_date,dateformat_style)#</td>
                                                        <td> <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#paper_id#" target="blank_" class="tableyazi"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>   
                                                        </a>
                                                    </td>
                                                    </tr>
                                                    </cfoutput>
                                                <cfelse>
                                                    <tbody> 
                                                        <tr>
                                                            <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                                                        </tr>
                                                    </tbody> 
                                                
                                                </cfif>
                                            </tbody>
                                        </cf_grid_list>
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td width="50%">
                                    <cfif x_event_related_order_info eq 1>
                                        <cfquery name="get_related_orders" datasource="#dsn3#">
                                            SELECT TOP 20
                                                O.ORDER_ID PAPER_ID,
                                                O.ORDER_NUMBER PAPER_NUMBER,
                                                O.ORDER_DATE PAPER_DATE,
                                                O.PURCHASE_SALES PAPER_TYPE,
                                                SUM(OW.QUANTITY) PAPER_AMOUNT,
                                                O.NETTOTAL PAPER_NETTOTAL
                                            FROM
                                                ORDERS O,
                                                ORDER_ROW OW
                                            WHERE
                                                O.ORDER_ID = OW.ORDER_ID AND
                                                OW.RELATED_ACTION_TABLE = 'EVENT_PLAN_ROW' AND
                                                OW.RELATED_ACTION_ID = #get_plan_row.event_plan_row_id# AND
                                                <cfif Len(get_plan_row.company_id)>
                                                    O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.company_id#">
                                                <cfelse>
                                                    O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.consumer_id#">
                                                </cfif>
                                            GROUP BY
                                                O.ORDER_ID,
                                                O.ORDER_NUMBER,
                                                O.ORDER_DATE,
                                                O.PURCHASE_SALES,
                                                O.NETTOTAL
                                            ORDER BY
                                                PAPER_DATE DESC
                                        </cfquery>
                                        <cf_grid_list margin="0">
                                            <thead>
                                                <tr>
                                                    <th colspan="5">
                                                        <cf_get_lang dictionary_id='32679.Sipariş Alınan Ürünler'>
                                                    </th>
                                                </tr>
                                                <tr>
                                                
                                                
                                                    <th width="100"><cf_get_lang dictionary_id='58211.Sipariş No'></th>
                                                    <th width="85" style="text-align:right;"><cf_get_lang dictionary_id='58777.Ürün Miktarı'></th>
                                                    <th width="85" style="text-align:right;"><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>  <th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th> 
                                                    <th width="15"><a href="<cfoutput>#request.self#?fuseaction=sales.list_order&event=add#add_link_#</cfoutput>" target="blank_"><i class="fa fa-plus" alt="<cf_get_lang no='503.Formu Doldur'>" title="<cf_get_lang_main no='170.Ekle'>" ></i></a></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <cfif get_related_orders.recordcount>
                                                    <cfoutput query="get_related_orders">
                                                    <tr>
                                                        
                                                    
                                                        <td><cfif paper_type eq 1><!--- Satis --->
                                                                <a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#paper_id#" target="blank_" class="tableyazi">#paper_number#</a>
                                                            <cfelse><!--- Alis --->
                                                                <a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#paper_id#" target="blank_" class="tableyazi">#paper_number#</a>
                                                            </cfif>
                                                        </td>
                                                        <td style="text-align:right;">#TLFormat(paper_amount)#</td>
                                                        <td style="text-align:right;">#TLFormat(paper_nettotal)#</td> 
                                                        <td>#DateFormat(paper_date,dateformat_style)#</td>
                                                        <td><cfif paper_type eq 1><!--- Satis --->
                                                            <a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#paper_id#" target="blank_" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>   
                                                            </a>
                                                    
                                                        <cfelse><!--- Alis --->
                                                            <a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#paper_id#" target="blank_" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>   
                                                            </a>
                                                        </td>
                                                        </cfif>
                                                    </td>
                                                    </tr>
                                                    </cfoutput>
                                                <cfelse>
                                                    <tbody> 
                                                        <tr>
                                                            <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                                                        </tr>
                                                    </tbody> 
                                            
                                                </cfif>
                                            </tbody>
                                        </cf_grid_list>
                                    </cfif>
                                </td> 
                            </tr>
                        </table>
                    </cfif>
                    <!--- İlişkili Fırsatlar--->
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th width="300"><cf_get_lang dictionary_id="57612.Fırsat"></th>
                                <th width="100"><cf_get_lang dictionary_id="57612.Fırsat"><cf_get_lang dictionary_id='58593.Tarihi'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfquery name="GET_OPP" datasource="#dsn3#">
                                SELECT
                                    OPP_ID,
                                    OPP_HEAD,
                                    OPP_DATE
                                FROM 
                                    OPPORTUNITIES
                                WHERE
                                    EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
                                    AND OPP_STATUS = 1
                            </cfquery>
                            <cfif GET_OPP.recordcount>
                                <cfoutput query="GET_OPP">
                                    <tr>
                                        <td><a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#opp_id#" target="_blank">#OPP_HEAD# </a></td>
                                        <td style="text-align:right;">#dateformat(OPP_DATE,dateformat_style)#</td>
                                    </tr>
                                </cfoutput>
                        
                    <cfelse>
                        
                            <tr>
                                <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                            </tr>
                        </tbody>  
                    </cfif>  
                    </cf_grid_list>
                    <!--- İlişkili Teklifler--->
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th width="300"><cf_get_lang dictionary_id="57545.Teklif"></th>
                                <th width="100"><cf_get_lang dictionary_id="32818.Teklif Tarihi"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfquery name="GET_OFFERS" datasource="#dsn3#">
                                SELECT
                                    OFFER_ID,
                                    OFFER_NUMBER,
                                    OFFER_DATE
                                FROM 
                                    OFFER
                                WHERE
                                    EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
                                    AND OFFER_STATUS = 1
                            </cfquery>
                                <cfif GET_OPP.recordcount>
                                <cfoutput query="GET_OFFERS">
                                    <tr>
                                        <td><a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" target="_blank">#OFFER_NUMBER#</a></td>
                                        <td style="text-align:right;">#dateformat(OFFER_DATE,dateformat_style)#</td>
                                    </tr>
                                </cfoutput>
                            <cfelse>
                            <tbody> 
                                <tr>
                                    <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                                </tr>
                            </tbody>  
                        </cfif>  
                        </tbody>    
                    </cf_grid_list>
                    <!--- İlişkili İşler--->
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th width="180"><cf_get_lang dictionary_id="58445.İş"></th>
                                <th width="104"><cf_get_lang dictionary_id="57655.Başlama Tarihi"></th>
                                <th width="100"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></th>
                            </tr>
                        </thead> 
                        
                            <tbody>
                                <cfquery name="GET_WORKS" datasource="#dsn#">
                                    SELECT
                                        WORK_ID,
                                        WORK_HEAD,
                                        TARGET_START,
                                        TARGET_FINISH
                                    FROM 
                                        PRO_WORKS
                                    WHERE
                                        EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
                                        AND WORK_STATUS = 1
                                </cfquery>
                                <cfif GET_WORKS.recordcount>
                                <cfoutput query="GET_WORKS">
                                    <tr>
                                        <td><a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" target="_blank">#WORK_HEAD#</a></td>
                                        <td style="text-align:right;">#dateformat(TARGET_START,dateformat_style)#</td>
                                        <td style="text-align:right;">#dateformat(TARGET_FINISH,dateformat_style)#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>    
                            <cfelse>
                                <tbody> 
                                    <tr>
                                        <td colspan="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                                    </tr>
                                </tbody>  
                            </cfif>     
                    </cf_grid_list>
                    
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <!--- Belgeler --->
                <cf_get_workcube_asset asset_cat_id="-13" module_id='11' action_section='EVENT_PLAN_ROW_ID' action_id='#attributes.event_plan_row_id#'>
                </div>
                <!--- Notlar --->
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_get_workcube_note action_section='EVENT_PLAN_ROW_ID' action_id='#attributes.event_plan_row_id#' style='0'>
                </div>  
            </cf_box_elements>
                </div>  
            
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>  
                    <cf_record_info query_name="GET_ROWS" record_emp="RESULT_RECORD_EMP" update_emp="RESULT_UPDATE_EMP" is_partner='1'>
                    <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete="0"></td>
                </cf_box_footer>
            </div>
        
        </cf_tab>
    </cfform>  
    </cf_box>

</div>
<script>

    function kontrol()
     {
          if(document.getElementById('execute_startdate').value == "")
          {
              alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id ='34025.Gerçekleşme Tarihi'>!");
              document.getElementById('execute_startdate').focus();
              return false;
          }
        
      }
  </script> 
  
  

