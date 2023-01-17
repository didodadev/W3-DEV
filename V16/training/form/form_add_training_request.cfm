<!--- 20121113 SG eğitim talebi ekleme Katalog ve Katalog dışı eğitim için--->

<cf_xml_page_edit fuseact="training_management.form_add_training_request">
    <cfquery name="get_position_detail" datasource="#dsn#">
        SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID =  #session.ep.userid# AND IS_MASTER = 1
    </cfquery>
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
    <cf_catalystHeader>
    <cfsavecontent  variable="title">
        <cf_get_lang dictionary_id='57419.Eğitim'>
    </cfsavecontent>
    <cf_box>
        <cfform name="add_training_request" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_training_request_emp">
            <input type="hidden" name="pos_code_list" id="pos_code_list" value="<cfoutput>#pos_code_list#</cfoutput>">
            <input type="hidden" name="first_boss_valid_date" id="first_boss_valid_date" value="">
            <input type="hidden" name="second_boss_valid_date" id="second_boss_valid_date" value="">
            <input type="hidden" name="third_boss_valid_date" id="third_boss_valid_date" value="">
            <input type="hidden" name="emp_valid_date" id="emp_valid_date" value="">
            <cf_box_elements id="goster_row">
                <div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-is_check">
                        <div class="col col-12 col-xs-12">
                            <label><input type="radio" name="is_check" id="is_check" value="1" onclick="getir(this.value);" checked="checked"><cf_get_lang dictionary_id="31096.Katalog"></label>
                        </div>
                        <div class="col col-12 col-xs-12">
                            <label><input type="radio" name="is_check" id="is_check" value="2" onclick="getir(this.value);"><cf_get_lang dictionary_id="31102.Katalog Dışı"></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="is_train">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="train_id" id="train_id" value="">
                                <input type="text" name="train_head" id="train_head" value="" style="width:200px;;">
                                <a class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_training_subjects&field_id=add_training_request.train_id&field_name=add_training_request.train_head</cfoutput>','list');"></a>                                    
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="is_train_name" style="display:none;">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46072.Eğitim Adı'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="other_train_name" id="other_train_name" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-purpose">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="51538.Amacı"></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="purpose" id="purpose"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-3 col-sm-6 col-xs-12"  id="is_detail" style="display:none;" index="2" type="column" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46377.Toplam Saat'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <input type="text" name="total_hour" id="total_hour" value="" onkeyup="isNumber(this);">        
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46084.Eğitim Yeri'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <input type="text" name="training_place" id="training_place" value="">        
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58607.Firma'>, <cf_get_lang dictionary_id='46324.Eğitmen'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <input type="text" name="trainer" id="trainer" value="">        
                        </div>
                    </div>	
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58258.Maliyet'></label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <cfinput type="text" name="training_cost" id="training_cost" value=""  onkeyup="return(formatcurrency(this,event));" class="moneybox">
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
                            <select name="training_money" id="training_money" style="width:100px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_money">
                                    <option value="#money#">#money#</option>
                                </cfoutput>
                            </select>      
                        </div>
                    </div>	
                </div>
                <div class="col col-3 col-md-3 col-sm-6 col-xs-12"  index="3" type="column" sort="true">
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">                                    
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                <cfinput validate="#validate_style#" type="text" name="start_date" id="start_date" required="yes" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>          
                        </div>
                    </div>
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">                                    
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfinput validate="#validate_style#" type="text" name="finish_date" id="finish_date" required="yes" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>          
                        </div>
                    </div>
                    <div class="form-group" id="request_emp">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38555.Talep Eden'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="hidden" name="request_emp_id" id="request_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                            <input type="hidden" name="request_position_code" id="request_position_code" value="<cfoutput>#session.ep.position_code#</cfoutput>">
                            <input type="text" name="request_emp_name" id="request_emp_name" readonly="yes" style="width:200px;" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">                                   
                        </div>                             
                    </div>
                    <div class="form-group" id="position_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfquery name="get_position_name" datasource="#dsn#">
                                SELECT 
                                    PC.POSITION_CAT 
                                FROM 
                                    EMPLOYEE_POSITIONS EP 
                                    INNER JOIN SETUP_POSITION_CAT PC ON EP.POSITION_CAT_ID = PC.POSITION_CAT_ID 
                                WHERE 
                                    EMPLOYEE_ID = #session.ep.userid#
                            </cfquery>
                            <cfif get_position_name.recordcount>
                                <cfoutput>#get_position_name.POSITION_CAT#</cfoutput>
                            </cfif>                                  
                        </div>                             
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
                            <textarea name="detail" id="detail"></textarea>                               
                        </div>                             
                    </div>
                    <cfif len(x_manager_code)>
                        <div class="form-group" id="validator_position_four">                                
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'><cf_get_lang dictionary_id='57500.Onay'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="hidden" name="validator_position_code_4" id="validator_position_code_4" value="<cfoutput>#x_manager_code#</cfoutput>">
                                <input type="text" name="validator_position_4" id="validator_position_4" value="<cfoutput>#get_emp_info(x_manager_code,1,0)#</cfoutput>" readonly> 
                            </div>                        
                        </div>
                    </cfif>			
                </div>
                <div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="4" type="column" sort="true">
                    <div class="form-group" id="item-katilimci">
                        <label style="display:none!important;"><cf_get_lang dictionary_id='57590.Katılımcılar'></label>
                        <cf_grid_list sort="0" margin="0">
                            <input type="hidden" name="add_row_info" id="add_row_info" value="1">
                            <thead>
                                <tr>
                                    <th colspan="3"><cf_get_lang dictionary_id='57590.Katılımcılar'></th>
                                </tr>
                                <tr>
                                    <cfif x_multiple_emp eq 1>
                                        <th><a href="javascript://" onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>						
                                    </cfif>
                                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                                </tr>
                            </thead>
                            <tbody id="row_info">
                                <tr id="row_info1">
                                    <cfif x_multiple_emp eq 1>
                                    <td>
                                        <input type="hidden" value="1" name="del_row_info1" id="del_row_info1">
                                        <a href="javascript://" onclick="del_row(1);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a>
                                    </td>
                                    <cfelse>
                                        <input type="hidden" value="1" name="del_row_info1" id="del_row_info1">
                                    </cfif>
                                    <td>
                                        <div class="form-group">
                                            <input type="hidden" value="<cfoutput>#session.ep.userid#</cfoutput>" name="participant_emp_id_1" id="participant_emp_id_1">
                                            <input type="text" readonly="readonly" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" name="participant_emp_name_1" id="participant_emp_name_1">
                                        </div>
                                    </td>
                                    <td>
                                        <cfquery name="get_pos_name" datasource="#dsn#">
                                            SELECT 
                                                PC.POSITION_CAT
                                                FROM 
                                                EMPLOYEE_POSITIONS EP 
                                                INNER JOIN SETUP_POSITION_CAT PC ON EP.POSITION_CAT_ID = PC.POSITION_CAT_ID 
                                                WHERE 
                                                EP.POSITION_CODE = #session.ep.position_code#
                                        </cfquery>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="text" readonly="readonly" value="<cfoutput>#get_pos_name.POSITION_CAT#</cfoutput>" name="participant_pos_name_1" id="participant_pos_name_1">
                                                <cfif x_multiple_emp eq 1>		
                                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_training_request.participant_emp_id_1&field_name=add_training_request.participant_emp_name_1&field_pos_cat_name=add_training_request.participant_pos_name_1&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1','list');"></span>
                                            </div>
                                        </div>
                                        </cfif>
                                    </td>
                                </tr>
                            </tbody>
                        </cf_grid_list>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>  
            </cf_box_footer>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        function getir(deger)
        {
            goster_row.style.display = '';
            if(deger == 1)//katalog egitimi ise
            {
                is_train.style.display = '';
                is_train_name.style.display = 'none';
                is_detail.style.display = 'none';
            }
            else if(deger == 2) //Katalog dışı eğitim ise
            {
                is_train.style.display = 'none';
                is_train_name.style.display = '';
                is_detail.style.display = '';
            }
        }
        function kontrol()
        {
            add_training_request.training_cost.value = filterNum(add_training_request.training_cost.value);
            if (!process_cat_control()) return false;
            
            if (!date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !"))
            return false;
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
            if(document.all.is_check[0].checked == true && (document.getElementById('train_id').value == "" || document.getElementById('train_head').value == "")) //katalog eğitimi
            {
                alert("Eğitim Adı Girmelisiniz");
                return false;
            }
            if(document.all.is_check[1].checked == true && document.getElementById('other_train_name').value == "")
            {
                alert("Eğitim Adı Giriniz");
                return false;
            }
            return true;
        }
        var add_row_info = 1;
        function add_row()
        {	
            add_row_info++;
            add_training_request.add_row_info.value=add_row_info;
            var newRow;
            var newCell;
            newRow = document.getElementById("row_info").insertRow(document.getElementById("row_info").rows.length);
            newRow.setAttribute("name","row_info" + add_row_info);
            newRow.setAttribute("id","row_info" + add_row_info);
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<input type="hidden" value="1" name="del_row_info'+ add_row_info +'" id="del_row_info'+ add_row_info +'"><a style="cursor:pointer" onclick="del_row(' + add_row_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id="57463.sil">"></i></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<div class="form-group"><input type="hidden" value="" name="participant_emp_id_'+ add_row_info +'" id="participant_emp_id_'+ add_row_info +'"><input type="text" value="" name="participant_emp_name_'+ add_row_info +'" id="participant_emp_name_'+ add_row_info +'"></div>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="text" value="" name="participant_pos_name_'+ add_row_info +'" id="participant_pos_name_'+ add_row_info +'"> <span class="input-group-addon icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_training_request.participant_emp_id_" + add_row_info + "&field_name=add_training_request.participant_emp_name_" + add_row_info + "&field_pos_name=add_training_request.participant_pos_name_" + add_row_info + "','list');"+'"></span></div></div>';
        }
        function del_row(dell)
        {
                var my_emement1=eval("add_training_request.del_row_info"+dell);
                my_emement1.value=0;
                var my_element1=eval("row_info"+dell);
                my_element1.style.display="none";
        }
    </script>
    
