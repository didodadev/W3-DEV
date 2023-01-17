<cf_xml_page_edit fuseact="objects.popup_add_event_plan_result">
<cfif fusebox.use_period eq false>
	<cfset dsn2 = dsn>
</cfif>
    <cfquery name="GET_PLAN_ROW" datasource="#DSN#">
        SELECT
            1 TYPE,
            EVENT_PLAN.EVENT_PLAN_HEAD,
            EVENT_PLAN.ANALYSE_ID, 
            EVENT_PLAN_ROW.SUB_EXPENSE_ID,
            EVENT_PLAN_ROW.SUB_EST_LIMIT,
            EVENT_PLAN_ROW.SUB_MONEY,
            EVENT_PLAN_ROW.WARNING_ID,
            EVENT_PLAN_ROW.START_DATE,
            EVENT_PLAN_ROW.FINISH_DATE, 
            EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
            EVENT_PLAN_ROW.VISIT_STAGE,
            EVENT_PLAN_ROW.EXPENSE,
            EVENT_PLAN_ROW.MONEY_CURRENCY,
            EVENT_PLAN_ROW.EXPENSE_ITEM,
            EVENT_PLAN_ROW.PARTNER_ID,
            EVENT_PLAN_ROW.IS_SALES,
            COMPANY.FULLNAME,
            COMPANY.COMPANY_ID MEMBER_ID,
            COMPANY_PARTNER.PARTNER_ID PARTNER_ID,
            COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_PARTNER_NAME,
            EVENT_PLAN_ROW.WARNING_ID,
            EVENT_PLAN.EVENT_CAT,
            EVENT_PLAN_ROW.RESULT_DETAIL,
            EVENT_PLAN_ROW.ASSET_ID,
			EVENT_PLAN_ROW.EXECUTE_STARTDATE
        FROM
            COMPANY,
            COMPANY_PARTNER,
            EVENT_PLAN,
            EVENT_PLAN_ROW
        WHERE 
            EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#"> AND 
            COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
            EVENT_PLAN_ROW.COMPANY_ID = COMPANY.COMPANY_ID AND
            EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID
        
        UNION ALL
            
        SELECT
            2 TYPE,
            EVENT_PLAN.EVENT_PLAN_HEAD,
            EVENT_PLAN.ANALYSE_ID, 
            EVENT_PLAN_ROW.SUB_EXPENSE_ID,
            EVENT_PLAN_ROW.SUB_EST_LIMIT,
            EVENT_PLAN_ROW.SUB_MONEY,
            EVENT_PLAN_ROW.WARNING_ID,
            EVENT_PLAN_ROW.START_DATE,
            EVENT_PLAN_ROW.FINISH_DATE, 
            EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
            EVENT_PLAN_ROW.VISIT_STAGE,
            EVENT_PLAN_ROW.EXPENSE,
            EVENT_PLAN_ROW.MONEY_CURRENCY,
            EVENT_PLAN_ROW.EXPENSE_ITEM,
            EVENT_PLAN_ROW.PARTNER_ID,
            EVENT_PLAN_ROW.IS_SALES,
            CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME FULLNAME,
            CONSUMER.CONSUMER_ID MEMBER_ID,
            '' PARTNER_ID,
            CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME MEMBER_PARTNER_NAME,
            EVENT_PLAN_ROW.WARNING_ID,
            EVENT_PLAN.EVENT_CAT,
            EVENT_PLAN_ROW.RESULT_DETAIL,
            EVENT_PLAN_ROW.ASSET_ID,
			EVENT_PLAN_ROW.EXECUTE_STARTDATE
        FROM
            CONSUMER,
            EVENT_PLAN,
            EVENT_PLAN_ROW
        WHERE 
            EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#"> AND 
            EVENT_PLAN_ROW.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
            EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID
    </cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ziyaret Sonucu Ekle',34031)#" collapsable="1" resize="0" <!--- right_images="#right_#"  ---> popup_box="1" >
        <cfform name="event_result" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_event_plan_result">
            <input type="hidden" name="eventid" id="eventid" value="<cfoutput>#attributes.eventid#</cfoutput>">
            <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
            <input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
            <cf_box_elements vertical="1">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="32669.Plan"></label>
                    <div class="col col-8 col-sm-12">
                        <cfoutput>#get_plan_row.event_plan_head#</cfoutput>
                    </div> 
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
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
                        <cfoutput>#dateformat(get_plan_row.start_date,dateformat_style)# #timeformat(get_plan_row.start_date,timeformat_style)#</cfoutput> - <cfoutput>#timeformat(get_plan_row.finish_date,timeformat_style)#</cfoutput>    
                    </div> 
                </div> 
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34029.Ziyaret Edilen'></label>
                    <div class="col col-8 col-sm-12">
                        <cfif GET_PLAN_ROW.type eq 1>
                            <cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_plan_row.member_id#','medium');" class="tableyazi">#get_plan_row.fullname#</a></cfoutput>
                        <cfelse>
                            <cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&consumer_id=#get_plan_row.member_id#','medium');" class="tableyazi">#get_plan_row.fullname#</a></cfoutput>
                        </cfif>     
                    </div>   
                </div>  
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
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
                                    <cfif Len(get_plan_row.member_id) and get_plan_row.type eq 1>
                                        MAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.member_id#"> AND
                                        MAR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.partner_id#">
                                    <cfelseif Len(get_plan_row.member_id) and get_plan_row.type eq 2>
                                        MAR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.member_id#">
                                    </cfif>
                            </cfquery>
                            <cfif get_analyse_member.recordcount>
                                <cfset Analyse_Link = "#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=MEMBER&analysis_id=#get_plan_row.analyse_id#&result_id=#get_analyse_member.result_id#">
                                <cfif Len(get_plan_row.member_id) and get_plan_row.type eq 1>
                                    <cfset Analyse_Link = Analyse_Link & "&member_type=partner&company_id=#get_plan_row.member_id#&partner_id=#get_plan_row.partner_id#">
                                <cfelse>
                                    <cfset Analyse_Link = Analyse_Link & "&member_type=consumer&consumer_id=#get_plan_row.member_id#">
                                </cfif>
                            <cfelse>
                                <cfquery name="get_analyse_member" datasource="#dsn#">
                                    SELECT ANALYSIS_ID, ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.analyse_id#">
                                </cfquery>
                                <cfif get_analyse_member.recordcount>
                                    <cfset Analyse_Link = "#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=MEMBER&action_type_id=&analysis_id=#get_analyse_member.analysis_id#">
                                    <cfif Len(get_plan_row.member_id) and get_plan_row.type eq 1>
                                        <cfset Analyse_Link = Analyse_Link & "&member_type=partner&company_id=#get_plan_row.member_id#&partner_id=#get_plan_row.partner_id#">
                                    <cfelse>
                                        <cfset Analyse_Link = Analyse_Link & "&member_type=consumer&consumer_id=#get_plan_row.member_id#">
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif Len(Analyse_Link)>
                                <cfoutput><a href="javascript://" onClick="windowopen('#Analyse_Link#','list');">#get_analyse_member.analysis_head#&nbsp;</a></cfoutput>
                            </cfif>
                        </cfif>     
                    </div>                
                </div> 
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57590.Katılımcılar'></label>
                    <div class="col col-8 col-sm-12">
                        <cfquery name="GET_POSIDS" datasource="#DSN#">
                            SELECT EVENT_POS_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = #event_plan_row_id#
                        </cfquery>
                        <cfset get_posids_list = valuelist(get_posids.event_pos_id, ',')>
                        <cfoutput>				
                        <cfloop query="get_posids">#get_emp_info(event_pos_id,1,0)#<cfif get_posids.currentrow neq get_posids.recordcount>,</cfif></cfloop></cfoutput>     
                    </div>
                </div>
                <cfif listfind(get_posids_list, session.ep.position_code, ',')>
                    <cfquery name="GET_MONEY" datasource="#DSN#">
                        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
                    </cfquery>
                    <cfquery name="GET_STAGE" datasource="#DSN#">
                        SELECT * FROM SETUP_VISIT_STAGES
                    </cfquery>
                    <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
                    </cfquery>
                    <div class="col col-12" id="editor_id_1">
                        <cf_seperator title="Açıklama" id="detail_seperator">
                        <div style="display:none;" id="detail_seperator">
                            <div class="col col-12" id="editor_id_1">
                                <div class="form-group" id="item-editor_1">
                                    <label style="display:none!important">Detail</label>
                                    <input type="hidden" name="detail_old_length" id="detail_old_length" value=""> 
                                    <cfmodule template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="result"
                                    valign="top"
                                    value=""
                                    maxCharCount="400"
                                    width="100%"
                                    height="180"> 
                                </div>
                            </div> 
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                            <div class="col col-3 col-sm-12"> 
                                <cf_workcube_process is_upd='0' process_cat_width='190' is_detail='0'>
                            </div>
                            <label class="col col-1 col-sm-12"><cf_get_lang dictionary_id="57482.Aşama">*</label>
                            <div class="col col-3 col-sm-12">
                                <select name="visit_stage" id="visit_stage" >
                                    <option value=""><cf_get_lang dictionary_id="57482.Aşama"></option>
                                    <cfoutput query="get_stage">
                                        <option value="#visit_stage_id#" <cfif get_plan_row.visit_stage eq visit_stage_id>selected</cfif>>#visit_stage#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <cfif xml_is_result_category eq 1> 
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="item-getResultCats"> 
                                    <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id ='57684.Sonuç'>*</label>
                                    <div class="col col-3 col-sm-12">
                                        <cfquery datasource="#dsn#" name="getResultCats">
                                            SELECT VISIT_RESULT_ID,VISIT_RESULT FROM SETUP_VISIT_RESULT WHERE VISIT_TYPE_ID = #get_visit_type.visit_type_id# AND IS_ACTIVE = 1 
                                        </cfquery>
                                        <select name="visit_result_category" id="visit_result_category" >
                                            <cfoutput query="getResultCats">
                                                <option value="#visit_result_id#">#visit_result#</option>
                                            </cfoutput>
                                        </select>
                                    </div>                
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <cfif xml_is_result_category eq 1> 
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="7" sort="true">
                            <div class="form-group" id="item-visit_expense">
                                <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id ='34024.Harcama'></label>
                                <div class="col col-3 col-sm-12">			
                                    <select name="expense_item" id="expense_item" >
                                        <option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
                                        <cfoutput query="get_expense">
                                            <option value="#expense_item_id#">#expense_item_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>   
                                <div class="col col-1 col-sm-12">
                                    
                                    <cfinput type="text" id="visit_expense" name="visit_expense" validate="float" onKeyup="return(FormatCurrency(this,event));" value="0" class="moneybox">
                                </div>
                                <div class="col col-1 col-sm-12">
                                    <select name="money_name" id="money_name" style="width:58px;">
                                        <cfoutput query="get_money">
                                            <option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>		
                                </div>     
                            </div>
                        </div>
                    </cfif> 
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
                        <div class="form-group" id="item-execute_startdate">
                            <label class="col col-2 col-sm-12"><cf_get_lang dictionary_id ='34025.Gerçekleşme Tarihi'>*</label>
                            <div class="col col-3 col-sm-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='34005.Başlama Tarihi Giriniz'></cfsavecontent>
                                    <cfinput type="text"  name="execute_startdate" validate="#validate_style#" message="#message#" value="#dateformat(get_plan_row.execute_startdate,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="execute_startdate" ></span>
                                </div>
                            </div>
                            <cfoutput>
                                <div class="col col-1 col-sm-12">
                                    <cf_wrkTimeFormat name="execute_start_clock" value="0">
                                </div>
                                <div class="col col-1 col-sm-12">
                                    <select name="execute_start_minute" id="execute_start_minute" >
                                        <cfloop from="0" to="55" step="5" index="sm">
                                            <option value="#NumberFormat(sm,00)#">#NumberFormat(sm,00)#</option>
                                        </cfloop>
                                    </select>
                                </div>
                                <div class="col col-1 col-sm-12">
                                    <cf_wrkTimeFormat name="execute_finish_clock" value="0">
                                </div> 
                                    <div class="col col-1 col-sm-12">
                                    <select name="execute_finish_minute" id="execute_finish_minute" >
                                        <cfloop from="0" to="55" step="5" index="fm">
                                            <option value="#NumberFormat(fm,00)#">#NumberFormat(fm,00)#</option>
                                        </cfloop>
                                    </select>
                                </div>  
                            </cfoutput>              
                        </div>
                    </div>
                <cfelse> 
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput>#get_plan_row.result_detail#</cfoutput>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57684.Sonuç'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_plan_row.visit_stage)>
                                <cfquery name="GET_STAGE" datasource="#DSN#">
                                    SELECT * FROM SETUP_VISIT_STAGES WHERE VISIT_STAGE_ID = #get_plan_row.visit_stage#
                                </cfquery>
                                <cfoutput>#get_stage.visit_stage#</cfoutput>
                            </cfif>
                        </div> 
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34025.Gerçekleşme Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                        </div>                
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_plan_row.expense_item)>
                                <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                                    SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_plan_row.expense_item#
                                </cfquery>
                                <cfoutput>#get_expense.expense_item_name#</cfoutput>
                            </cfif>
                        </div>    
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='34024.Harcama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput>#tlformat(get_plan_row.expense)# #get_plan_row.money_currency#</cfoutput>
                        </div> 
                    </div>
                </cfif> 
            </cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol()
    {
        
        if(document.getElementById('execute_startdate').value == "")
          {
              alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang dictionary_id ='34025.Gerçekleşme Tarihi'>!");
              document.getElementById('execute_startdate').focus();
              return false;
          }
        <cfif xml_is_result_category eq 1>
            if(!multiselect_validate(document.getElementById('visit_result_category')))
            {
                alert("<cf_get_lang dictionary_id='60194.Lütfen Sonuç Kategorisi Seçiniz'>");
                return false;
            }
            function multiselect_validate(select) 
            {  
                var valid = false;  
                for(var i = 0; i < select.options.length; i++) {  
                    if(select.options[i].selected) {  
                        valid = true;  
                        break;  
                    }  
                }  
              
                return valid;  
            }  
        </cfif>
        x = document.event_result.visit_stage.selectedIndex;
       
        tarih1_ = event_result.execute_startdate.value.substr(6,4) + event_result.execute_startdate.value.substr(3,2) + event_result.execute_startdate.value.substr(0,2);
        tarih2_ = event_result.today_value_.value.substr(6,4) + event_result.today_value_.value.substr(3,2) + event_result.today_value_.value.substr(0,2);
        if((event_result.execute_startdate.value != "") && (tarih1_ > tarih2_))
        {
            alert("<cf_get_lang dictionary_id ='34022.Lütfen Gerçekleşme Tarihini Bugünden Önce Giriniz'>!");
            return false;
        }
        if(process_cat_control())
        {
            event_result.visit_expense.value = filterNum(event_result.visit_expense.value);
            return true;
        }
        else
            return false;
    }
</script>
    