<!--- 20121113 SG Yıllık Eğitim talebi--->
<cf_xml_page_edit fuseact="training_management.form_add_training_request">
    <cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
        <cfset attributes.train_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.train_req_id,accountKey:session.ep.userid)>
    </cfif>
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
    <cfsavecontent  variable="title">
        <cf_get_lang dictionary_id="31108.Yıllık Eğitim Talebi">
    </cfsavecontent>
    <cf_box title="#title#">
        <cfform name="add_request_annual" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_training_request_annual">
            <input type="hidden" name="pos_code_list" id="pos_code_list" value="<cfoutput>#pos_code_list#</cfoutput>">
            <input type="hidden" name="train_req_id" id="train_req_id" value="<cfoutput>#attributes.train_req_id#</cfoutput>">
            <input type="hidden" name="first_boss_valid_date" id="first_boss_valid_date" value="<cfoutput>#get_request_main.first_boss_valid_date#</cfoutput>">
            <input type="hidden" name="second_boss_valid_date" id="second_boss_valid_date" value="<cfoutput>#get_request_main.second_boss_valid_date#</cfoutput>">
            <input type="hidden" name="third_boss_valid_date" id="third_boss_valid_date" value="<cfoutput>#get_request_main.third_boss_valid_date#</cfoutput>">
            <input type="hidden" name="fourth_boss_valid_date" id="fourth_boss_valid_date" value="<cfoutput>#get_request_main.fourth_boss_valid_date#</cfoutput>">
            <input type="hidden" name="emp_valid_date" id="emp_valid_date" value="<cfoutput>#get_request_main.EMP_VALIDDATE#</cfoutput>">
            <cfset field_unchanged = 0>
            <cfif session.ep.userid neq get_request_main.employee_id and len(get_request_main.emp_validdate)><!--- bazı alanlar sadece talep eden calisan tarafından degistirilebilir--->
                <cfset field_unchanged = 1>	
            </cfif>
            <div class="row">
                <div class="col col-12 formContent">
                    <div class="row" type="row">
                        <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='1' select_value='#get_request_main.process_stage#'>
                                </div>
                            </div> 
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58472.Dönem">*</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif not len(get_request_main.first_boss_valid_date)>
                                        <select name="period" id="period" style="width:200px;" <cfif field_unchanged eq 1>disabled="disabled"</cfif>>
                                            <option value="">Seçiniz</option>
                                            <cfloop from="#year(now())#" to="#year(now())+1#" index="i">
                                                <option value="<cfoutput>#i#</cfoutput>" <cfif get_request_main.request_year eq i>selected</cfif>><cfoutput>#i#</cfoutput></option>
                                            </cfloop>
                                        </select>
                                    <cfelse>
                                        : <cfoutput>#get_request_main.request_year#</cfoutput>
                                        <input type="hidden" name="period" id="period" value="<cfoutput>#get_request_main.request_year#</cfoutput>">
                                    </cfif>
                                </div>
                            </div> 
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'><cf_get_lang dictionary_id='38555.Talep Eden'>:</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="request_emp_id" id="request_emp_id" value="<cfoutput>#get_request_main.employee_id#</cfoutput>">
                                    <input type="hidden" name="request_position_code" id="request_position_code" readonly="yes" value="<cfoutput>#get_request_main.position_code#</cfoutput>">
                                    <label><cfoutput>#get_emp_info(get_request_main.employee_id,0,0)#</cfoutput></label>                              
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'>1 :</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(get_request_main.first_boss_code)>
                                        <cfquery name="get_pos_code1" datasource="#dsn#">
                                            SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS ADSOYAD,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_request_main.first_boss_code#
                                        </cfquery>
                                        <input type="Hidden" name="validator_position_code_1" id="validator_position_code_1" value="<cfoutput>#get_request_main.first_boss_code#</cfoutput>">
                                        <!--- <input type="text" name="validator_position_1" id="validator_position_1" style="width:180px;" value="<cfoutput>#get_pos_code1.ADSOYAD#</cfoutput>" readonly> --->
                                        <cfoutput>#get_pos_code1.ADSOYAD# <cfif len(get_request_main.first_boss_valid_date)>(#dateformat(get_request_main.first_boss_valid_date,dateformat_style)#)</cfif></cfoutput>
                                    <cfelse>
                                        <input type="Hidden" name="validator_position_code_1" id="validator_position_code_1" value="">
                                        <!--- <input type="text" name="validator_position_1" id="validator_position_1" style="width:180px;" value="" readonly> --->
                                    </cfif>
                                </div>
                            </div>						
                            <cfif len(get_request_main.emp_validdate)>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif listfind(pos_code_list,get_request_main.first_boss_code,',') and not len(get_request_main.first_boss_valid_date)>	
                                            <textarea name="first_boss_detail" id="first_boss_detail"><cfoutput>#get_request_main.first_boss_detail#</cfoutput></textarea>
                                        <cfelse>
                                            <cfoutput>#get_request_main.first_boss_detail#</cfoutput>
                                        </cfif>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'>2 :</label>
                                <div class="col col-8 col-xs-12">
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
                            <cfif len(get_request_main.first_boss_valid_date)>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif listfind(pos_code_list,get_request_main.second_boss_code,',') and not len(get_request_main.second_boss_valid_date)>
                                            <textarea name="second_boss_detail" id="second_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.second_boss_detail#</cfoutput></textarea>
                                        <cfelse>
                                            : <cfoutput>#get_request_main.second_boss_detail#</cfoutput>
                                        </cfif>
                                    </div>
                                </div>
                            </cfif>	
                            <cfif len(get_request_main.third_boss_id) or (fusebox.circuit is 'training_management' and len(get_request_main.second_boss_valid_date))>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12">IK <cf_get_lang dictionary_id='57500.Onay'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput>#get_emp_info(get_request_main.third_boss_id,0,0)# <cfif len(get_request_main.third_boss_valid_date)>(#dateformat(get_request_main.third_boss_valid_date,dateformat_style)#)</cfif></cfoutput>
                                    </div>
                                </div>
                            </cfif>
                            <cfif len(get_request_main.third_boss_detail) or (fusebox.circuit is 'training_management' and len(get_request_main.second_boss_valid_date))>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif fusebox.circuit is 'training_management' and not len(get_request_main.third_boss_valid_date)>
                                            <textarea name="third_boss_detail" id="third_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.third_boss_detail#</cfoutput></textarea>
                                        <cfelse>
                                            <cfoutput>#get_request_main.third_boss_detail#</cfoutput>
                                        </cfif>
                                    </div>
                                </div>
                            </cfif>
                            <cfif len(get_request_main.fourth_boss_code)>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'><cf_get_lang dictionary_id='57500.Onay'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif len(get_request_main.fourth_boss_code)>
                                            <cfquery name="get_pos_code4" datasource="#dsn#">
                                                SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS ADSOYAD,POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_request_main.fourth_boss_code#
                                            </cfquery>
                                        <cfelse>
                                            <cfset get_pos_code4.adsoyad = "">
                                        </cfif>
                                        <input type="hidden" name="validator_position_code_4" id="validator_position_code_4" value="<cfoutput>#get_request_main.fourth_boss_code#</cfoutput>">
                                        <!--- <input type="text" name="validator_position_4" id="validator_position_4" style="width:180px;" value="<cfoutput>#get_pos_code4.adsoyad#</cfoutput>" readonly> --->
                                        <cfoutput>#get_pos_code4.adsoyad# <cfif len(get_request_main.fourth_boss_valid_date)>(#dateformat(get_request_main.fourth_boss_valid_date,dateformat_style)#)</cfif></cfoutput>
                                    </div>
                                </div>
                            </cfif>
                            <cfif len(get_request_main.third_boss_valid_date)>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif not listfind(pos_code_list,get_request_main.fourth_boss_code,',') or fusebox.circuit is 'training_management'>	
                                            <cfoutput>#get_request_main.fourth_boss_detail#</cfoutput>
                                        <cfelse>
                                            <textarea name="fourth_boss_detail" id="fourth_boss_detail" style="width:200px;height:50px;"><cfoutput>#get_request_main.fourth_boss_detail#</cfoutput></textarea>
                                        </cfif>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                        <div class="col col-6 col-xs-12">
    
                            <cfscript>
                                get_req_row_action = createObject("component","V16.training.cfc.get_training_request");
                                get_req_row_action.dsn = dsn;
                                get_request_row = get_req_row_action.get_request_rows_fnc
                                                (
                                                    module_name : fusebox.circuit,
                                                    train_req_id : get_request_main.TRAIN_REQUEST_ID
                                                );
                            </cfscript>
                                <cf_form_list>
                                    <input type="hidden" name="add_row_info" id="add_row_info" value="<cfoutput>#get_request_row.recordcount#</cfoutput>">
                                    <thead>
                                        <tr>
                                            <th colspan="4" class="txtbold">Eğitimler</th>
                                        </tr>
                                        <tr>
                                            <cfif get_request_main.employee_id eq session.ep.userid>
                                                <th><a href="javascript://" onclick="add_row();"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>	
                                            </cfif>					
                                            <th width="250">Konu</td>
                                            <th>Öncelik</td>
                                            <cfif len(get_request_main.emp_validdate)>
                                                <th>Onay 1</th>
                                            </cfif>
                                            <cfif len(get_request_main.first_boss_valid_date)>
                                                <th>Onay 2</th>
                                            </cfif>
                                            <cfif fusebox.circuit is 'training_management' or listfind(pos_code_list,get_request_main.fourth_boss_code,',')>
                                                <th>IK Onay</th>
                                            </cfif>
                                            <cfif len(get_request_main.third_boss_valid_date)>
                                                <th>Yönetici Onay</th>
                                            </cfif>
                                        </tr>
                                    </thead>
                                    <tbody id="row_info">
                                        <cfoutput query="get_request_row">
                                            <tr id="row_info_#currentrow#">
                                                <cfif get_request_main.employee_id eq session.ep.userid>
                                                    <td><input type="hidden" value="1" name="del_row_info#currentrow#" id="del_row_info#currentrow#"><a style="cursor:pointer" onclick="del_row(#currentrow#);"><img  src="images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id="57463.sil">" alt="<cf_get_lang dictionary_id="57463.sil">"></a></td>
                                                <cfelse>
                                                    <input type="hidden" value="1"  name="del_row_info#currentrow#" id="del_row_info#currentrow#">
                                                </cfif>
                                                <td>
                                                    <input type="hidden" name="train_id#currentrow#" id="train_id#currentrow#" value="#train_id#">
                                                    <cfif field_unchanged neq 1>
                                                        <input type="text" name="train_head#currentrow#" id="train_head#currentrow#" value="#train_head#" style="width:200px;">
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_list_training_subjects&field_id=add_request_annual.train_id#currentrow#&field_name=add_request_annual.train_head#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                                    <cfelse>
                                                        <input type="hidden" name="train_head#currentrow#" id="train_head#currentrow#" value="#train_head#" style="width:200px;">
                                                        #train_head#
                                                    </cfif>
                                                </td>
                                                <td>
                                                    <cfif field_unchanged neq 1>
                                                        <input type="text" name="priority#currentrow#" id="priority#currentrow#" value="#training_priority#" onkeyup="isNumber(this);" style="border:none;width:50px;">
                                                    <cfelse>
                                                        <input type="hidden" name="priority#currentrow#" id="priority#currentrow#" value="#training_priority#" onkeyup="isNumber(this);" style="width:50px;">
                                                        #training_priority#
                                                    </cfif>
                                                </td>
                                                <cfif len(get_request_main.emp_validdate)>
                                                <td>
                                                    <cfif listfind(pos_code_list,get_request_main.first_boss_code,',') and not len(get_request_main.first_boss_valid_date)>
                                                        <input type="checkbox" name="is_valid_#currentrow#" id="is_valid_#currentrow#" value="1" <cfif is_valid eq 1 or not len(is_valid) or is_valid eq 0>checked</cfif>>
                                                    <cfelse>
                                                        <cfif not len(get_request_main.first_boss_valid_date)>
                                                           Onay Bekleniyor
                                                        <cfelse>
                                                            <input type="hidden" name="is_valid_#currentrow#" id="is_valid_#currentrow#" <cfif is_valid eq 1>value="1"<cfelse>value="0"</cfif>>
                                                            <cfif is_valid eq 1>Onay<cfelse>Red</cfif>
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
                                                           Onay Bekleniyor
                                                        <cfelse>
                                                           <input type="hidden" name="is_valid2_#currentrow#" id="is_valid2_#currentrow#" <cfif is_valid2 eq 1>value="1"<cfelse>value="0"</cfif>>
                                                            <cfif is_valid2 eq 1>Onay<cfelse>Red</cfif>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                                </cfif>
                                                <!---IK Onay --->
                                                <cfif fusebox.circuit is 'training_management' or listfind(pos_code_list,get_request_main.fourth_boss_code,',')>
                                                <td>
                                                    <cfif len(get_request_main.third_boss_valid_date)>
                                                        <input type="hidden" name="is_valid3_#currentrow#" id="is_valid3_#currentrow#" <cfif is_valid3 eq 1>value="1"<cfelse>value="0"</cfif>>
                                                        <cfif is_valid3 eq 1>Onay<cfelse>Red</cfif>
                                                    <cfelseif not len(get_request_main.third_boss_valid_date) and fusebox.circuit is 'training_management'>
                                                        <input type="checkbox" name="is_valid3_#currentrow#" id="is_valid3_#currentrow#" value="1" <cfif is_valid3 eq 1 or not len(is_valid3)>checked</cfif>>
                                                    <cfelse>
                                                       Onay Bekleniyor
                                                    </cfif>
                                                </td>
                                                </cfif>
                                                <!--- yönetici onay--->
                                                <cfif (listfind('pos_code_list',get_request_main.fourth_boss_code) or len(get_request_main.third_boss_valid_date))>
                                                <td>
                                                    <cfif get_request_main.fourth_boss_code eq session.ep.position_code and not len(get_request_main.fourth_boss_valid_date)>
                                                      <input type="checkbox" name="is_valid4_#currentrow#" id="is_valid4_#currentrow#" value="1" <cfif is_valid4 eq 1 or not len(is_valid4)>checked</cfif>>
                                                    <cfelseif not len(get_request_main.fourth_boss_valid_date)>
                                                          Onay Bekleniyor
                                                    <cfelse>
                                                        <input type="hidden" name="is_valid4_#currentrow#" id="is_valid4_#currentrow#" <cfif is_valid4 eq 1>value="1"<cfelse>value="0"</cfif>>
                                                           <cfif is_valid4 eq 1>Onay<cfelse>Red</cfif>
                                                    </cfif>
                                                </td>
                                                </cfif>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </cf_form_list>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cfif fusebox.circuit is 'training_management'>
                                <cf_workcube_buttons type_format='1' is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_request_training&request_id=#attributes.train_req_id#'>
                            <cfelse>		
                                <cf_workcube_buttons type_format='1' is_upd='1' add_function='kontrol()' is_delete="0">
                            </cfif>                  
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        function kontrol()
        {
            if (!process_cat_control()) return false;
            if(document.getElementById('period').value == '')
            {
                alert("Dönem seçiniz");
                return false;
            }
            if(document.getElementById('add_row_info').value == 0 || document.getElementById('add_row_info').value == '')
            {
                alert("Konu Seçiniz");
                return false;
            }
            for (var r=1; r<=add_row_info;r++)
            {
                deger_my_value = eval("document.add_request_annual.train_id"+r);
                deger_my_valu2 = eval("document.add_request_annual.train_head"+r);
                oncelik = eval("document.add_request_annual.priority"+r);
                sil_row = eval("document.add_request_annual.del_row_info"+r);
                var sayac = 0;
                if (sil_row.value == 1)
                {
                    sayac+=1;
                    if(deger_my_value.value == "" || deger_my_valu2.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Konu!");
                        return false;
                        break;
                    }
                    if(oncelik.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Öncelik!");
                        return false;
                        break;
                    }
                }
            }
            if(sayac == 0)
            {
                alert("Konu Satırı Eklemelisiniz!");
                return false;
            }
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
                    <!--- <cfif fusebox.circuit neq 'training_management'> --->
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
                    <!--- </cfif> --->
                    <!--- <cfif fusebox.circuit is 'training_management'> --->
                    if(eval(document.getElementById("is_valid3_"+i)) != undefined)
                    {
                        if(eval(document.getElementById("is_valid3_"+i)).checked == false)
                        is_checked_control = 1;
                    }
                    <!--- </cfif> --->
                }
            }
            if(is_checked_control == 1)
            {
                if(confirm("Onaylamadığınız Eğitimler var, buna rağmen devam etmek istiyor musunuz?"));
                else return false;			
            }
            return true;
        }
        var add_row_info = document.getElementById("add_row_info").value;
        function add_row()
        {	
            add_row_info++;
            add_request_annual.add_row_info.value=add_row_info;
            var newRow;
            var newCell;
            newRow = document.getElementById("row_info").insertRow(document.getElementById("row_info").rows.length);
            newRow.setAttribute("name","row_info_" + add_row_info);
            newRow.setAttribute("id","row_info_" + add_row_info);
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<input type="hidden" value="1" name="del_row_info'+ add_row_info +'"><a style="cursor:pointer" onclick="del_row(' + add_row_info + ');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ="51.sil">"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<input type="hidden" name="train_id'+ add_row_info +'" id="train_id'+ add_row_info +'" value=""><input type="text" name="train_head'+ add_row_info +'" id="train_head'+ add_row_info +'" value="" style="width:200px;"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_id=add_request_annual.train_id"+add_row_info+"&field_name=add_request_annual.train_head"+add_row_info+"','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<input type="text" name="priority'+ add_row_info +'" id="priority'+ add_row_info +'" value="" onKeyUp="isNumber(this);" style="width:50px;border:none;">';
        }
        function del_row(dell)
        {
            var my_emement1=eval("add_request_annual.del_row_info"+dell);
            my_emement1.value=0;
            var my_element1=eval("row_info_"+dell);
            my_element1.style.display="none";
        }
    </script>
    
