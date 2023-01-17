<!--- 20121116 SG eğitim talebi ekleme Katalog ve Katalog dışı eğitim için--->
<cf_xml_page_edit fuseact="training_management.form_add_training_request">
    <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
        <cfset attributes.train_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.train_req_id,accountKey:session.ep.userid)>
    </cfif>
       <cf_catalystHeader>
    <cfscript>
        get_req_action = createObject("component","V16.training.cfc.get_training_request");
        get_req_action.dsn = dsn;
        get_request_main = get_req_action.get_training_request_fnc
                        (
                            module_name : fusebox.circuit,
                            train_req_id : attributes.train_req_id
                        );
    </cfscript>
    <cfquery name="get_all_positions" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfset pos_code_list = valuelist(get_all_positions.position_code)>
    <!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
    <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
        SELECT
            O.EMPLOYEE_ID,
            EP.POSITION_CODE
        FROM
            OFFTIME O,
            EMPLOYEE_POSITIONS EP
        WHERE
            O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            O.VALID = 1 AND
            #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
    </cfquery>
    <cfif Get_Offtime_Valid.recordcount>
        <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
        <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position1">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position2">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
        </cfquery>
        <cfoutput query="Get_StandBy_Position3">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
        </cfoutput>
    </cfif>
    <cfquery name="get_money" datasource="#dsn#">
        SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
    <cfform name="upd_training_request" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_training_request_emp">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box id="goster_row">
                <input type="hidden" name="pos_code_list" id="pos_code_list" value="<cfoutput>#pos_code_list#</cfoutput>">
                <input type="hidden" name="train_req_id" id="train_req_id" value="<cfoutput>#attributes.train_req_id#</cfoutput>">
                <input type="hidden" name="first_boss_valid_date" id="first_boss_valid_date" value="<cfoutput>#get_request_main.first_boss_valid_date#</cfoutput>">
                <input type="hidden" name="second_boss_valid_date" id="second_boss_valid_date" value="<cfoutput>#get_request_main.second_boss_valid_date#</cfoutput>">
                <input type="hidden" name="third_boss_valid_date" id="third_boss_valid_date" value="<cfoutput>#get_request_main.third_boss_valid_date#</cfoutput>">
                <input type="hidden" name="emp_valid_date" id="emp_valid_date" value="<cfoutput>#get_request_main.EMP_VALIDDATE#</cfoutput>">
                <cfset field_unchanged = 0>
                <cfif session.ep.userid neq get_request_main.employee_id and len(get_request_main.emp_validdate)><!--- bazı alanlar sadece talep eden calisan tarafından degistirilebilir--->
                    <cfset field_unchanged = 1>	
                </cfif>
                <div id="detail_search_div" style="display:table-row;"></div>
                <cf_box_elements>
                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_check">
                            <div class="col col-6 col-xs-12">
                                <label><cfif field_unchanged eq 1><input type="hidden" name="is_check" value="<cfoutput>#get_request_main.request_type#</cfoutput>"></cfif>
                                <input type="radio" name="is_check" id="is_check" <cfif field_unchanged eq 1>disabled="disabled"</cfif> value="1" onclick="getir(this.value);"<cfif get_request_main.request_type eq 1>checked</cfif>><cf_get_lang dictionary_id="31096.Katalog"></label>
                            </div>
                            <div class="col col-6 col-xs-12">
                                <label><input type="radio" name="is_check" id="is_check" <cfif field_unchanged eq 1>disabled="disabled"</cfif> value="2" onclick="getir(this.value);"<cfif get_request_main.request_type eq 2>checked</cfif>><cf_get_lang dictionary_id="31102.Katalog Dışı"></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='200' select_value='#get_request_main.process_stage#' is_detail='1'>
                            </div>
                        </div>  
                        <div class="form-group" id="is_train" <cfif get_request_main.request_type eq 2>style="display:none"</cfif>>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="hidden" name="train_id" id="train_id" value="<cfif len(get_request_main.train_id)><cfoutput>#get_request_main.train_id#</cfoutput></cfif>">
                                <cfif field_unchanged neq 1>
                                    <div class="input-group">
                                        <input type="text" name="train_head" id="train_head"  value="<cfif len(get_request_main.train_id)><cfoutput>#get_request_main.train_head#</cfoutput></cfif>" >
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_training_subjects&field_id=upd_training_request.train_id&field_name=upd_training_request.train_head</cfoutput>','list');"></span>
                                    </div>
                                <cfelse>
                                    <input type="hidden" name="train_head" id="train_head"  value="<cfif len(get_request_main.train_id)><cfoutput>#get_request_main.train_head#</cfoutput></cfif>">
                                    <cfoutput>#get_request_main.train_head#</cfoutput>
                                </cfif>
                            </div> 
                        </div> 
                        <div class="form-group" id="is_train_name"  <cfif get_request_main.request_type neq 2>style="display:none"</cfif>>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46072.Eğitim Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                    <input type="text" name="other_train_name" id="other_train_name" value="<cfif len(get_request_main.other_train_name)><cfoutput>#get_request_main.other_train_name#</cfoutput></cfif>" >
                                <cfelse>
                                    <input type="hidden" name="other_train_name" id="other_train_name"  value="<cfif len(get_request_main.other_train_name)><cfoutput>#get_request_main.other_train_name#</cfoutput></cfif>" >
                                    <cfoutput>#get_request_main.other_train_name#</cfoutput>
                                </cfif>
                            </div> 
                        </div> 
                        <div class="form-group" id="item-purpose">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="51538.Amacı"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                    <textarea name="purpose" id="purpose" style="width:200px;height:50px;"><cfif len(get_request_main.purpose)><cfoutput>#get_request_main.purpose#</cfoutput></cfif></textarea>
                                <cfelse>
                                    <input type="hidden" name="purpose" value="<cfoutput>#get_request_main.purpose#</cfoutput>">
                                    <cfoutput>#get_request_main.purpose#</cfoutput>
                                </cfif>
                            </div> 
                        </div> 
                    </div>
                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12" id="is_detail" <cfif get_request_main.request_type neq 2>style="display:none"</cfif> type="column" index="2" sort="true">
                        <div class="form-group" id="item-total_hour">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46377.Toplam Saat'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                <input type="text" name="total_hour" id="total_hour" <cfif field_unchanged eq 1>readonly="yes"</cfif> value="<cfoutput>#get_request_main.total_hour#</cfoutput>" onkeyup="isNumber(this);" style="width:70px;">
                                <cfelse>
                                : <cfoutput>#get_request_main.total_hour#</cfoutput>
                                <input type="hidden" name="total_hour" id="total_hour" value="<cfoutput>#get_request_main.total_hour#</cfoutput>"/>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-training_place">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46084.Eğitim Yeri'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                    <input type="text" name="training_place" id="training_place" value="<cfoutput>#get_request_main.training_place#</cfoutput>" style="width:200px;">
                                <cfelse>
                                    : <cfoutput>#get_request_main.training_place#</cfoutput>
                                    <input type="hidden" name="training_place" id="training_place" value="<cfoutput>#get_request_main.training_place#</cfoutput>" style="width:200px;">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-trainer">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58607.Firma'>, <cf_get_lang dictionary_id='46324.Eğitmen'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                    <input type="text" name="trainer" id="trainer" value="<cfoutput>#get_request_main.trainer#</cfoutput>" style="width:200px;">
                                <cfelse>
                                    <input type="hidden" name="trainer" id="trainer" <cfif field_unchanged eq 1>readonly="yes"</cfif> value="<cfoutput>#get_request_main.trainer#</cfoutput>" style="width:200px;">
                                : <cfoutput>#get_request_main.trainer#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-trainer">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58258.Maliyet'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                    <div class="col col-6 col-xs-12"><cfinput type="text" name="training_cost" id="training_cost" style="width:70px;" value="#get_request_main.training_cost#"  onkeyup="return(formatcurrency(this,event));" class="moneybox"></div>
                                    <div class="col col-6 col-xs-12"> 
                                        <select name="training_money" id="training_money" >
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_money">
                                                <option value="#money#"<cfif get_request_main.training_money eq '#money#'>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                <cfelse>
                                    <cfinput type="hidden" name="training_cost" id="training_cost" style="width:70px;" value="#get_request_main.training_cost#"   onkeyup="return(formatcurrency(this,event));" class="moneybox">
                                    <cfinput type="hidden" name="training_money" id="training_money" style="width:70px;" value="#get_request_main.training_money#">
                                    : <cfoutput>#get_request_main.training_cost# <cfif len(get_request_main.training_money)>#get_request_main.training_money#</cfif></cfoutput>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-start_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfif field_unchanged neq 1>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                        <cfinput validate="#validate_style#" type="text" name="start_date" id="start_date" value="#dateformat(get_request_main.start_date,dateformat_style)#" style="width:70px;" maxlength="10" required="yes" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                    </cfif>
                                </div> 
                            </div>   
                        </div>           
                        <div class="form-group" id="item-finish_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>           
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                    <cfinput validate="#validate_style#" type="text" name="finish_date" id="finish_date"  value="#dateformat(get_request_main.finish_date,dateformat_style)#" style="width:70px;" maxlength="10" required="yes" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                    <cfif field_unchanged eq 1>
                                        <cfoutput>#dateformat(get_request_main.start_date,dateformat_style)# - #dateformat(get_request_main.finish_date,dateformat_style)#</cfoutput>
                                        <input type="hidden"  name="start_date" value="<cfoutput>#dateformat(get_request_main.start_date,dateformat_style)#</cfoutput>"/>
                                        <input type="hidden"  name="finish_date" value="<cfoutput>#dateformat(get_request_main.finish_date,dateformat_style)#</cfoutput>"/>
                                    </cfif>
                                </div> 
                            </div>
                        </div>
                        <div class="form-group" id="item-request_emp_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38555.Talep Eden'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="hidden" name="request_emp_id" id="request_emp_id" value="<cfoutput>#get_request_main.EMPLOYEE_ID#</cfoutput>">
                                <input type="hidden" name="request_position_code" id="request_position_code" value="<cfoutput>#get_request_main.position_code#</cfoutput>">
                                <cfif field_unchanged neq 1>
                                    <input type="text" name="request_emp_name" id="request_emp_name" value="<cfoutput>#get_emp_info(get_request_main.EMPLOYEE_ID,0,0)#</cfoutput>">
                                <cfelse>
                                    <input type="hidden" name="request_emp_name" id="request_emp_name" readonly="yes" style="width:200px;" value="<cfoutput>#get_emp_info(get_request_main.EMPLOYEE_ID,0,0)#</cfoutput>">
                                <cfoutput>#get_emp_info(get_request_main.EMPLOYEE_ID,0,0)#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-position-type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfquery name="get_position_name" datasource="#dsn#">
                                    SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_request_main.EMPLOYEE_ID#
                                </cfquery>
                                <cfif get_position_name.recordcount>
                                    <cfoutput>#get_position_name.position_name#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif field_unchanged neq 1>
                                    <textarea name="detail" id="detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.detail#</cfoutput></textarea>
                                <cfelse>
                                    <input type="hidden" name="detail" value="<cfoutput>#get_request_main.detail#</cfoutput>">
                                    : <cfoutput>#get_request_main.detail#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-validator_position_1">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'> 1 :</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfif Len(get_request_main.first_boss_code)>
                                        <cfquery name="get_pos_code1" datasource="#dsn#">
                                            SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS ADSOYAD,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_request_main.first_boss_code#
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_pos_code1.adsoyad = "">
                                    </cfif>
                                    <input type="Hidden" name="validator_position_code_1" id="validator_position_code_1" value="<cfoutput>#get_request_main.first_boss_code#</cfoutput>">
                                    <cfif not len(get_request_main.first_boss_code)>
                                        <input type="text" name="validator_position_1" id="validator_position_1" style="width:180px;" value="<cfoutput>#get_pos_code1.ADSOYAD#</cfoutput>" readonly> 
                                    </cfif>
                                    <cfoutput>#get_pos_code1.ADSOYAD# <cfif len(get_request_main.first_boss_valid_date)>(#dateformat(get_request_main.first_boss_valid_date,dateformat_style)#)</cfif></cfoutput>
                                    <cfif not len(get_request_main.first_boss_code)><span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_training_request.validator_position_code_1&field_name=upd_training_request.validator_position_1','list');return false"></span></cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-validator_position_code_2">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'> 2 :</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_request_main.second_boss_code)>
                                    <cfquery name="get_pos_code2" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS ADSOYAD,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_request_main.second_boss_code#
                                    </cfquery>
                                <cfelse>
                                    <cfset get_pos_code2.adsoyad = "">
                                </cfif>
                                <input type="hidden" name="validator_position_code_2" id="validator_position_code_2" value="<cfoutput>#get_request_main.second_boss_code#</cfoutput>">
                                <!--- <input type="text" name="validator_position_2" id="validator_position_2" style="width:180px;" value="<cfoutput>#get_pos_code2.adsoyad#</cfoutput>" readonly> --->
                                <cfoutput>#get_pos_code2.adsoyad# <cfif len(get_request_main.second_boss_valid_date)>(#dateformat(get_request_main.second_boss_valid_date,dateformat_style)#)</cfif></cfoutput>
                            </div>
                        </div>
                        <!---
                            <cfif len(get_request_main.emp_validdate)>
                                <tr>
                                    <td valign="top">Açıklama</td>
                                    <td>
                                        <cfif not listfind(pos_code_list,get_request_main.first_boss_code,',')>	
                                            : <cfoutput>#get_request_main.first_boss_detail#</cfoutput>
                                        <cfelse>
                                            <textarea name="first_boss_detail" id="first_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.first_boss_detail#</cfoutput></textarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            !--->
                            <!---
                            <cfif len(get_request_main.first_boss_valid_date)>
                                <tr>
                                    <td valign="top">Açıklama</td>
                                    <td>
                                        <cfif not listfind(pos_code_list,get_request_main.second_boss_code,',')>	
                                            : <cfoutput>#get_request_main.second_boss_detail#</cfoutput>
                                        <cfelse>
                                            <cfif listfind(pos_code_list,get_request_main.second_boss_code,',') and not len(get_request_main.second_boss_valid_date)>
                                                <textarea name="second_boss_detail" id="second_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.second_boss_detail#</cfoutput></textarea>
                                            <cfelse>
                                                <input type="hidden" name="second_boss_detail" value="<cfoutput>#get_request_main.second_boss_detail#</cfoutput>">
                                            : <cfoutput>#get_request_main.second_boss_detail#</cfoutput>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <cfif len(get_request_main.third_boss_id) or (fusebox.circuit is 'training_management' and len(get_request_main.second_boss_valid_date))>
                            <tr>
                                <td>IK <cf_get_lang_main no='88.Onay'></td>
                                <td>: <cfoutput>#get_emp_info(get_request_main.third_boss_id,0,0)# <cfif len(get_request_main.third_boss_valid_date)>(#dateformat(get_request_main.third_boss_valid_date,dateformat_style)#)</cfif></cfoutput></td>
                            </tr>
                            </cfif>
                            <cfif len(get_request_main.third_boss_detail) or (fusebox.circuit is 'training_management' and len(get_request_main.second_boss_valid_date))>
                            <tr>
                                <td>Açıklama</td>
                                <td>
                                    <cfif fusebox.circuit is 'training_management' and not len(get_request_main.third_boss_valid_date)>
                                        <textarea name="third_boss_detail" id="third_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.third_boss_detail#</cfoutput></textarea>
                                    <cfelse>
                                        : <cfoutput>#get_request_main.third_boss_detail#</cfoutput>
                                    </cfif>
                                </td>
                            </tr>
                            </cfif>
                            <!---Yönetici onay --->
                            <cfif len(get_request_main.fourth_boss_code)>
                            <tr>
                                <cfif len(get_request_main.fourth_boss_code)>
                                    <cfquery name="get_pos_code4" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS ADSOYAD,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_request_main.fourth_boss_code#
                                    </cfquery>
                                <cfelse>
                                    <cfset get_pos_code4.adsoyad = "">
                                </cfif>
                                <td>Yönetici <cf_get_lang_main no='88.Onay'></td>
                                <td>:
                                    <input type="hidden" name="validator_position_code_4" id="validator_position_code_4" value="<cfoutput>#get_request_main.fourth_boss_code#</cfoutput>">
                                    <!--- <input type="text" name="validator_position_4" id="validator_position_4" style="width:180px;" value="<cfoutput>#get_pos_code4.adsoyad#</cfoutput>" readonly> --->
                                    <cfoutput>#get_pos_code4.adsoyad# <cfif len(get_request_main.fourth_boss_valid_date)>(#dateformat(get_request_main.fourth_boss_valid_date,dateformat_style)#)</cfif></cfoutput>
                                </td>
                            </tr>
                            </cfif>
                            <cfif len(get_request_main.third_boss_valid_date)>
                                <tr>
                                    <td valign="top">Açıklama</td>
                                    <td>
                                        <cfif not listfind(pos_code_list,get_request_main.fourth_boss_code,',') or fusebox.circuit is 'training_management'>	
                                            <cfoutput>#get_request_main.fourth_boss_detail#</cfoutput>
                                        <cfelse>
                                            <textarea name="fourth_boss_detail" id="fourth_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.fourth_boss_detail#</cfoutput></textarea>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            </table>
                            !--->
                    </div>
                    <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-katilimci">
                            <label style="display:none!important;"><cf_get_lang dictionary_id='57590.Katılımcılar'></label>
                            <cfscript>
                                get_req_row_action = createObject("component","V16.training.cfc.get_training_request");
                                get_req_row_action.dsn = dsn;
                                get_request_row = get_req_row_action.get_request_rows_fnc
                                                (
                                                    module_name : fusebox.circuit,
                                                    train_req_id : get_request_main.TRAIN_REQUEST_ID
                                                );
                            </cfscript>
                            <cf_grid_list sort="0" margin="0">
                                <thead>
                                    <tr><th colspan="3"><cf_get_lang dictionary_id='57590.Katılımcılar'></th></tr>
                                    <input type="hidden" name="add_row_info" id="add_row_info" value="<cfoutput>#get_request_row.recordcount#</cfoutput>">
                                    <tr>
                                        <cfif get_request_main.employee_id eq session.ep.userid and x_multiple_emp eq 1>
                                            <th><a href="javascript://" onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                        </cfif>					
                                        <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                                        <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                                        <cfif len(get_request_main.emp_validdate)>
                                            <th><cf_get_lang dictionary_id='57500.Onay'> 1</th>
                                        </cfif>
                                        <cfif len(get_request_main.first_boss_valid_date)>
                                            <th><cf_get_lang dictionary_id='57500.Onay'> 2</th>
                                        </cfif>
                                        <cfif (fusebox.circuit is 'training_management' and (listfind(pos_code_list,get_request_main.fourth_boss_code,',') or len(get_request_main.first_boss_valid_date))) or len(get_request_main.first_boss_valid_date)>
                                            <th><cf_get_lang dictionary_id='31588.IK Onay'></th>
                                        </cfif>
                                        <cfif len(get_request_main.third_boss_valid_date)>
                                            <th><cf_get_lang dictionary_id='61090.Yönetici Onay'></th>
                                        </cfif>
                                    </tr>
                                </thead>
                                <tbody id="row_info">
                                    <cfoutput query="get_request_row">
                                        <tr id="row_info_#currentrow#">
                                            <cfif get_request_main.employee_id eq session.ep.userid and x_multiple_emp eq 1>
                                                <td><input type="hidden" value="1" name="del_row_info#currentrow#" id="del_row_info#currentrow#"><a href="javascript://" onclick="del_row(#currentrow#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a></td>
                                            <cfelse>
                                                <input type="hidden" value="1"  name="del_row_info#currentrow#" id="del_row_info#currentrow#">
                                            </cfif>
                                            <td>
                                                <input type="hidden" value="#employee_id#" name="participant_emp_id_#currentrow#" id="participant_emp_id_#currentrow#">
                                                <div class="form-group"><input type="text" readonly="readonly" value="#NAMESURNAME#" name="participant_emp_name_#currentrow#" id="participant_emp_name_#currentrow#"></div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="text" readonly="readonly" value="#POSITION_NAME#" name="participant_pos_name_#currentrow#" id="participant_pos_name_#currentrow#"<cfif len(get_request_main.EMP_VALIDDATE)>readonly="yes"</cfif>>
                                                        <cfif not len(get_request_main.EMP_VALIDDATE)><!--- talep edilen onayı verildiginde degisiklik yapılamayacak--->
                                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_training_request.participant_emp_id_#currentrow#&field_name=upd_training_request.participant_emp_name_#currentrow#','list');"></span>
                                                        </cfif>
                                                    </div>
                                                </div>
                                            </td>
                                            <cfif len(get_request_main.emp_validdate)>
                                                <td>
                                                    <cfif listfind(pos_code_list,get_request_main.first_boss_code,',') and not len(get_request_main.first_boss_valid_date)>
                                                        <input type="checkbox" name="is_valid_#currentrow#" id="is_valid_#currentrow#" value="1" <cfif is_valid eq 1 or not len(is_valid) or is_valid eq 0>checked</cfif>>
                                                    <cfelse>
                                                        <cfif not len(get_request_main.first_boss_valid_date)>
                                                            <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                                                        <cfelse>
                                                            <input type="hidden" name="is_valid_#currentrow#" id="is_valid_#currentrow#" <cfif is_valid eq 1>value="1"<cfelse>value="0"</cfif>>
                                                            <cfif is_valid eq 1><cf_get_lang dictionary_id='57500.Onay'><cfelse><cf_get_lang dictionary_id='29537.Red'></cfif>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                            </cfif>
                                            <cfif len(get_request_main.first_boss_valid_date)>
                                                <td>
                                                    <cfif fusebox.circuit neq 'training_management' and listfind(pos_code_list,get_request_main.second_boss_code,',') and not len(get_request_main.second_boss_valid_date)>
                                                        <input type="checkbox" name="is_valid2_#currentrow#" id="is_valid2_#currentrow#" value="1" <cfif is_valid2 eq 1 or not len(is_valid2)>checked</cfif>>
                                                    <cfelse>
                                                        <cfif not len(get_request_main.second_boss_valid_date)>
                                                            <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                                                        <cfelse>
                                                            <input type="hidden" name="is_valid2_#currentrow#" id="is_valid2_#currentrow#" <cfif is_valid2 eq 1>value="1"<cfelse>value="0"</cfif>>
                                                            <cfif is_valid2 eq 1><cf_get_lang dictionary_id='57500.Onay'><cfelse><cf_get_lang dictionary_id='29537.Red'></cfif>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                            </cfif>
                                            <!---IK Onay --->
                                            <cfif (fusebox.circuit is 'training_management' and (listfind(pos_code_list,get_request_main.fourth_boss_code,',') or len(get_request_main.first_boss_valid_date))) or len(get_request_main.first_boss_valid_date)>
                                                <td>
                                                    <cfif len(get_request_main.third_boss_valid_date)>
                                                        <input type="hidden" name="is_valid3_#currentrow#" id="is_valid3_#currentrow#" <cfif is_valid3 eq 1>value="1"<cfelse>value="0"</cfif>>
                                                        <cfif is_valid3 eq 1><cf_get_lang dictionary_id='57500.Onay'><cfelse><cf_get_lang dictionary_id='29537.Red'></cfif>
                                                    <cfelseif not len(get_request_main.third_boss_valid_date) and fusebox.circuit is 'training_management'>
                                                        <input type="checkbox" name="is_valid3_#currentrow#" id="is_valid3_#currentrow#" value="1" <cfif is_valid3 eq 1 or not len(is_valid3)>checked</cfif>>
                                                    <cfelse>
                                                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                                                    </cfif>
                                                </td>
                                            </cfif>
                                            <!--- yönetici onay--->
                                            <cfif (listfind('pos_code_list',get_request_main.fourth_boss_code) or len(get_request_main.third_boss_valid_date))>
                                                <td>
                                                    <cfif get_request_main.fourth_boss_code eq session.ep.position_code and not len(get_request_main.fourth_boss_valid_date)>
                                                        <input type="checkbox" name="is_valid4_#currentrow#" id="is_valid4_#currentrow#" value="1" <cfif is_valid4 eq 1 or not len(is_valid4)>checked</cfif>>
                                                    <cfelseif not len(get_request_main.fourth_boss_valid_date)>
                                                        <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                                                    <cfelse>
                                                        <input type="hidden" name="is_valid4_#currentrow#" id="is_valid4_#currentrow#" <cfif is_valid4 eq 1>value="1"<cfelse>value="0"</cfif>>
                                                            <cfif is_valid4 eq 1><cf_get_lang dictionary_id='57500.Onay'><cfelse><cf_get_lang dictionary_id='29537.Red'></cfif>
                                                    </cfif>
                                                </td>
                                            </cfif>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                            </cf_grid_list>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_record_info query_name="get_request_main">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfif fusebox.circuit is 'training_management'>
                            <cf_workcube_buttons type_format='1' is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_request_training&request_id=#attributes.train_req_id#'>
                        <cfelse>
                            <cf_workcube_buttons type_format='1' is_upd='1' add_function='kontrol()' is_delete="0">
                        </cfif>
                    </div>
                </cf_box_footer>
            </cf_box>
        </div>
    </cfform>
    <script type="text/javascript">
        function getir(deger)
        {
            goster_row.style.display = '';
            if(deger == 1)//katalog egitimi ise
            {
                is_train.style.display = '';
                is_train_name.style.display = 'none';
                is_detail.style.display = 'none';
                document.getElementById('other_train_name').value = "";
            }
            else if(deger == 2) //Katalog dışı eğitim ise
            {
                is_train.style.display = 'none';
                is_train_name.style.display = '';
                is_detail.style.display = '';
                document.getElementById('train_id').value = "";
                document.getElementById('train_head').value = "";
                document.getElementById('other_train_name').value = "<cfif len(get_request_main.other_train_name)><cfoutput>#get_request_main.other_train_name#</cfoutput></cfif>";
            }
        }
        function kontrol()
        {   
            upd_training_request.training_cost.value = filterNum(upd_training_request.training_cost.value);
            if (!process_cat_control()) return false;
            
            if (!date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !"))
            return false;
    
            <cfif get_request_main.employee_id eq session.ep.userid>
                var sayac = 0;
                for(i=1; i <= document.getElementById("add_row_info").value; i++)
                {
                    if(eval(document.getElementById("del_row_info"+i)).value == 1 && (eval(document.getElementById("participant_emp_id_"+i)).value == "" || eval(document.getElementById("participant_emp_name_"+i)).value == ""))
                    {
                        alert("Çalışan Seçiniz");
                        return false;
                    }
                    if(eval(document.getElementById("del_row_info"+i)).value == 1 && eval(document.getElementById("participant_emp_id_"+i)).value != "" && eval(document.getElementById("participant_emp_name_"+i)).value != "")
                    {
                        sayac +=1;	
                    }
                }
                if(sayac == 0)
                {
                    alert("Çalışan eklemelisiniz");
                    return false;
                }
            </cfif>
            <cfif field_unchanged neq 1>
            if(document.all.is_check[0].checked == true && (document.getElementById('train_id').value == "" || document.getElementById('train_head').value == "")) //katalog eğitimi
            {
                alert("Eğitim Seçmelisiniz");
                return false;
            }
            if(document.all.is_check[1].checked == true  && document.getElementById('other_train_name').value == "")
            {
                alert("Eğitim Adı Girmelisiniz");
                return false;
            }
            </cfif>
            var is_checked_control = 0;
            var temp = new Array();
            temp = document.getElementById('pos_code_list').value.split(",");
            for(var y=0; y<temp.length; y++) 
            {
                for(i=1; i <= document.getElementById("add_row_info").value; i++)
                {  
                    if(eval(document.getElementById("is_valid_"+i)) != undefined && document.getElementById('validator_position_code_1').value == temp[y])
                    {
                        if(eval(document.getElementById("is_valid_"+i)).checked == false)
                        is_checked_control = 1;
                    }
                    <cfif fusebox.circuit neq 'training_management'>
                    if(eval(document.getElementById("is_valid2_"+i)) != undefined && document.getElementById('validator_position_code_2').value == temp[y])
                    {
                        if(eval(document.getElementById("is_valid2_"+i)).checked == false)
                        is_checked_control = 1;
                    }
                    if(eval(document.getElementById("is_valid4_"+i)) != undefined)
                    {
                        if(eval(document.getElementById("is_valid4_"+i)).checked == false)
                        is_checked_control = 1;
                    }
                    </cfif>
                    <cfif fusebox.circuit is 'training_management'>
                    if(eval(document.getElementById("is_valid3_"+i)) != undefined)
                    {
                        if(eval(document.getElementById("is_valid3_"+i)).checked == false)
                        is_checked_control = 1;
                    }
                    </cfif>
                }
            }
            if(is_checked_control == 1)
            {
                if(confirm("Onaylamadığınız katılımcılar var, buna rağmen devam etmek istiyor musunuz?"));
                else return false;			
            }
            return true;
        }
        var add_row_info = document.getElementById("add_row_info").value;
        function add_row()
        {	
            add_row_info++;
            upd_training_request.add_row_info.value=add_row_info;
            var newRow;
            var newCell;
            newRow = document.getElementById("row_info").insertRow(document.getElementById("row_info").rows.length);
            newRow.setAttribute("name","row_info_" + add_row_info);
            newRow.setAttribute("id","row_info_" + add_row_info);
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<input type="hidden" value="1" name="del_row_info'+ add_row_info +'" id="del_row_info'+ add_row_info +'"><a style="cursor:pointer" onclick="del_row(' + add_row_info + ');"><i class="fa fa-minus" alt="<cf_get_lang_main no ="51.sil">"></i></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<div class="form-group"><input type="hidden" value="" name="participant_emp_id_'+ add_row_info +'" id="participant_emp_id_'+ add_row_info +'"><input type="text" value="" name="participant_emp_name_'+ add_row_info +'" id="participant_emp_name_'+ add_row_info +'"></div>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="text" value="" name="participant_pos_name_'+ add_row_info +'" id="participant_pos_name_'+ add_row_info +'"> <span class="input-group-addon icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_training_request.participant_emp_id_" + add_row_info + "&field_name=upd_training_request.participant_emp_name_" + add_row_info + "&field_pos_name=upd_training_request.participant_pos_name_" + add_row_info + "','list');"+'"></span></div></div>';
        }
        function del_row(dell)
        {
                var my_emement1=eval("upd_training_request.del_row_info"+dell);
                my_emement1.value=0;
                var my_element1=eval("row_info_"+dell);
                my_element1.style.display="none";
        }
    </script>
    