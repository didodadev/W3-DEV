<style>
    .removeFromList{
        background-color: #e43a45!important;
    }
    .waitlist{
        background-color: #FF9800!important;
    }
</style>
<cfparam name="attributes.attender_name" default="">
<cfparam name="attributes.attender_surname" default="">
<cfparam name="attributes.statu_filter" default="">
<cfquery name="get_train_groups" datasource="#dsn#">
	SELECT
	    TCG.TRAIN_GROUP_ID
	FROM
	    TRAINING_CLASS_GROUPS TCG
	WHERE
        1=1
        <cfif isDefined("attributes.train_group_id")>
            AND TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfif>
</cfquery>
<cfset train_list = valuelist(get_train_groups.train_group_id)>
<cfif LEN(train_list)>
    <cfquery name="get_emp_id" datasource="#dsn#">
        SELECT 
            EMP_ID 
        FROM 
            TRAINING_GROUP_ATTENDERS 
        WHERE 
            TRAINING_GROUP_ID IN (#train_list#)
            AND EMP_ID IS NOT NULL
    </cfquery>
    <cfquery name="get_par_id" datasource="#dsn#">
        SELECT 
            PAR_ID 
        FROM 
            TRAINING_GROUP_ATTENDERS 
        WHERE 
            TRAINING_GROUP_ID IN (#train_list#)
            AND PAR_ID IS NOT NULL
    </cfquery>
    <cfquery name="get_cons_id" datasource="#dsn#">
        SELECT 
            CON_ID 
        FROM 
            TRAINING_GROUP_ATTENDERS 
        WHERE 
            TRAINING_GROUP_ID IN (#train_list#)
            AND CON_ID IS NOT NULL
    </cfquery>
    <cfquery name="get_grp_id" datasource="#dsn#">
        SELECT 
            GRP_ID 
        FROM 
            TRAINING_GROUP_ATTENDERS 
        WHERE 
            TRAINING_GROUP_ID IN (#train_list#)
            AND GRP_ID IS NOT NULL
    </cfquery>
</cfif>
<cfquery name="get_leave_reason" datasource="#dsn#">
    SELECT TRAINING_EXCUSE_ID,EXCUSE_HEAD FROM SETUP_TRAINING_EXCUSES WHERE IS_ACTIVE = 1 AND REASON_TO_LEAVE = 1
</cfquery>
<cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
<div id="attender_list">
    <cf_box>
        <cfform name="attender_form" method="post">
            <cfinput type="hidden" name="train_group_id" id="train_group_id" value="#attributes.train_group_id#">
            <cfoutput>
                <div class="ui-form-list flex-list">
                    <div class="form-group medium">
                        <cfinput name="attender_name" id="attender_name" type="text" placeholder="#getLang('','İsim',44592)#" value="#attributes.attender_name#">
                    </div>
                    <div class="form-group medium">
                        <cfinput name="attender_surname" id="attender_surname" type="text" placeholder="#getLang('','Soyisim',44593)#" value="#attributes.attender_surname#">
                    </div>
                    <div class="form-group">
                        <select name="statu_filter" id="statu_filter">
                            <cfif isDefined("attributes.statu_filter")>
                                <option value=""><cf_get_lang dictionary_id='57894.Statü'></option>
                                <option value="0" <cfif attributes.statu_filter eq 0>selected</cfif>><cf_get_lang dictionary_id='30828.Talep'></option>
                                <option value="1" <cfif attributes.statu_filter eq 1>selected</cfif>><cf_get_lang dictionary_id='41402.Kesin Kayıt'></option>
                                <option value="2" <cfif attributes.statu_filter eq 2>selected</cfif>><cf_get_lang dictionary_id='30984.Beklemede'></option>
                                <option value="3" <cfif attributes.statu_filter eq 3>selected</cfif>><cf_get_lang dictionary_id='65250.Kabul Edilmedi'></option>
                            </cfif>
                        </select>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="search_attender()">
                    </div>
                </div>
            </cfoutput>
            <div id="show_attender_message"></div>
        </cfform>

        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='30243.Fotoğraf'></th>
                    <th width="15"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57558.Üye No'></th>
                    <th><cf_get_lang dictionary_id='55649.TC. Kimlik No'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='42014.Rol'></th>
                    <th><cf_get_lang dictionary_id='65246.Katılımcı Notu'></th>
                    <th><cf_get_lang dictionary_id='57894.Statü'></th>
                    <th width="15"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfinclude template="../query/get_training_group_attenders.cfm">
                <cfset max_len = 0>
                <cfif len(train_list)>
                    <cfset attributes.employee_ids = valuelist(get_emp_id.emp_id)>  
                    <cfset attributes.partner_ids = valuelist(get_par_id.par_id)> 
                    <cfset attributes.consumer_ids = valuelist(get_cons_id.con_id)>
                    <cfset attributes.group_ids = valuelist(get_grp_id.grp_id)>
                    <!--- <cfinclude template="../query/get_group_class_attenders.cfm"> --->
                    <cfif len(attributes.employee_ids) and get_attender_emps.recordcount>
                        <cfset max_len = max_len + get_attender_emps.RecordCount>
                        <cfoutput query="get_attender_emps">
                            <tr>
                                <td>
                                    <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_attender_emps.K_ID)>
                                    <cfif len(employee_photo.photo)>
                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                    <cfelseif employee_photo.sex eq 1>
                                        <cfset emp_photo ="images/male.jpg">
                                    <cfelse>
                                        <cfset emp_photo ="images/female.jpg">
                                    </cfif>
                                    <img src='#emp_photo#' width="50" />
                                </td>
                                <td>#currentrow#</td>
                                <td>#member_no#</td>
                                <td>#tc_no#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#k_id#','medium')">#ad# #soyad#</a></td>
                                <td>#position#</td>
                                <td><textarea name="attender_note" id="attender_note" onblur="add_note(this.value,#ATTENDER_ID#);">#ATTENDER_NOTE#</textarea></td>
                                <td>
                                    <cfif JOIN_STATU eq 0>
                                        <cf_get_lang dictionary_id='30828.Talep'>
                                    <cfelseif JOIN_STATU eq 1>
                                        <cf_get_lang dictionary_id='41402.Kesin Kayıt'>
                                    <cfelseif JOIN_STATU eq 2>
                                        <cf_get_lang dictionary_id='30984.Beklemede'>
                                    <cfelseif JOIN_STATU eq 3>
                                        <cf_get_lang dictionary_id='65250.Kabul Edilmedi'>
                                    </cfif>
                                </td>
                                <!--- <td>Süreç-Aşama</td> --->
                                <!--- <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_del_att_from_class&training_group_attenders_id=#attender_id#&train_group_id=#attributes.train_group_id#');"><i class="fa fa-minus"></i></a></td> --->
                                <td><input type="checkbox" name="attender_#currentrow#" id="attender_#currentrow#" value="#type#;#ids#" onclick="addToList('#type#','#ids#','#attender_id#')"></td>
                            </tr>
                        </cfoutput>
                    </cfif>
                    <cfif LEN(attributes.partner_ids) and get_attender_pars.recordcount>
                        <cfset max_len = max_len + get_attender_pars.RecordCount>
                        <cfoutput query="get_attender_pars">
                            <cfset no = get_attender_emps.recordcount + currentrow>
                            <tr>
                                <td>
                                    <cfif len(get_attender_pars.K_ID)>
                                        <cfset employee_photo = getComponent.PARTNER_PHOTO(partner_id:get_attender_pars.K_ID)>
                                    </cfif>
                                    <cfif isdefined("employee_photo.photo") and len(employee_photo.photo)>
                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                    <cfelseif isdefined("employee_photo.sex") and  employee_photo.sex eq 1>
                                        <cfset emp_photo ="images/male.jpg">
                                    <cfelse>
                                        <cfset emp_photo ="images/female.jpg">
                                    </cfif>
                                    <img src='#emp_photo#' width="50" />
                                </td>
                                <td>#no#</td>
                                <td>#member_no#</td>
                                <td>#tc_no#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#k_id#','medium')">#ad# #soyad#</a></td>
                                <td>#position#</td>
                                <td><textarea name="attender_note" id="attender_note" onblur="add_note(this.value,#ATTENDER_ID#);">#ATTENDER_NOTE#</textarea></td>
                                <td>
                                    <cfif JOIN_STATU eq 0>
                                        <cf_get_lang dictionary_id='30828.Talep'>
                                    <cfelseif JOIN_STATU eq 1>
                                        <cf_get_lang dictionary_id='41402.Kesin Kayıt'>
                                    <cfelseif JOIN_STATU eq 2>
                                        <cf_get_lang dictionary_id='30984.Beklemede'>
                                    <cfelseif JOIN_STATU eq 3>
                                        <cf_get_lang dictionary_id='65250.Kabul Edilmedi'>
                                    </cfif>
                                </td>
                                <!--- <td>Süreç-Aşama</td> --->
                                <!--- <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_del_att_from_class&training_group_attenders_id=#attender_id#&train_group_id=#attributes.train_group_id#','medium');"><i class="fa fa-minus"></i></a></td> --->
                                <td><input type="checkbox" name="attender_#no#" id="attender_#no#" value="#type#;#ids#" onclick="addToList('#type#','#ids#','#attender_id#')"></td>
                            </tr>
                        </cfoutput>
                    </cfif>
                    <cfif LEN(attributes.consumer_ids) and get_attender_cons.recordcount>
                        <cfset max_len = max_len + get_attender_cons.recordCount>
                        <cfoutput query="get_attender_cons">
                        <cfset no2 = get_attender_emps.recordcount + get_attender_pars.recordcount + currentrow>
                            <tr>
                                <td>
                                    <cfset employee_photo = getComponent.CONSUMER_PHOTO(consumer_id:get_attender_cons.K_ID)>
                                    <cfif len(employee_photo.PICTURE)>
                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PICTURE#">
                                    <cfelseif employee_photo.sex eq 1>
                                        <cfset emp_photo ="images/male.jpg">
                                    <cfelse>
                                        <cfset emp_photo ="images/female.jpg">
                                    </cfif>
                                    <img src='#emp_photo#' width="50" />
                                </td>
                                <td>#no2#</td>
                                <td>#member_no#</td>
                                <td>#tc_no#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_con_det&con_id=#k_id#','medium')">#ad# #soyad#</a></td>
                                <td>#position#</td>
                                <td><textarea name="attender_note" id="attender_note" onblur="add_note(this.value,#ATTENDER_ID#);">#ATTENDER_NOTE#</textarea></td>
                                <td>
                                    <cfif JOIN_STATU eq 0>
                                        <cf_get_lang dictionary_id='30828.Talep'>
                                    <cfelseif JOIN_STATU eq 1>
                                        <cf_get_lang dictionary_id='41402.Kesin Kayıt'>
                                    <cfelseif JOIN_STATU eq 2>
                                        <cf_get_lang dictionary_id='30984.Beklemede'>
                                    <cfelseif JOIN_STATU eq 3>
                                        <cf_get_lang dictionary_id='65250.Kabul Edilmedi'>
                                    </cfif>
                                </td>
                                <!--- <td>Süreç-Aşama</td> --->
                                <!--- <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_del_att_from_class&training_group_attenders_id=#attender_id#&train_group_id=#attributes.train_group_id#','medium');"><i class="fa fa-minus"></i></a></td> --->
                                <td><input type="checkbox" name="attender_#no2#" id="attender_#no2#" value="#type#;#ids#" onclick="addToList('#type#','#ids#','#attender_id#')"></td>
                            </tr>
                        </cfoutput>
                    </cfif>
                    <cfif LEN(attributes.group_ids) and get_attender_grps.recordcount>
                        <cfset max_len = max_len + get_attender_grps.recordCount>
                        <cfoutput query="get_attender_grps">
                        <cfset no3 = get_attender_emps.recordcount + get_attender_pars.recordcount + get_attender_cons.recordcount + currentrow>
                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                <td>
                                    <cfset employee_photo = getComponent.EMPLOYEE_PHOTO(employee_id:get_attender_grps.K_ID)>
                                    <cfif len(employee_photo.photo)>
                                        <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                                    <cfelseif employee_photo.sex eq 1>
                                        <cfset emp_photo ="images/male.jpg">
                                    <cfelse>
                                        <cfset emp_photo ="images/female.jpg">
                                    </cfif>
                                    <img src='#emp_photo#' width="50" />
                                </td>
                                <td>#no3#</td>
                                <td>#member_no#</td>
                                <td>#tc_no#</td>
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#k_id#')">#ad# #soyad#</a></td>
                                <td>#nick_name#</td>
                                <td>#position#</td>
                                <td><textarea name="attender_note" id="attender_note" onblur="add_note(this.value,#ATTENDER_ID#);">#ATTENDER_NOTE#</textarea></td>
                                <td>
                                    <cfif JOIN_STATU eq 0>
                                        <cf_get_lang dictionary_id='30828.Talep'>
                                    <cfelseif JOIN_STATU eq 1>
                                        <cf_get_lang dictionary_id='41402.Kesin Kayıt'>
                                    <cfelseif JOIN_STATU eq 2>
                                        <cf_get_lang dictionary_id='30984.Beklemede'>
                                    <cfelseif JOIN_STATU eq 3>
                                        <cf_get_lang dictionary_id='65250.Kabul Edilmedi'>
                                    </cfif>
                                </td>
                                <!--- <td>Süreç-Aşama</td> --->
                                <!--- <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_del_att_from_class&training_group_attenders_id=#attender_id#&train_group_id=#attributes.train_group_id#','medium');"><i class="fa fa-minus"></i></a></td> --->
                                <td><input type="checkbox" name="attender_#no3#" id="attender_#no3#" value="#type#;#ids#" onclick="addToList('#type#','#ids#','#attender_id#')"></td>
                            </tr>
                        </cfoutput>
                    </cfif>
                    <cfif isdefined("get_attenders_new") and get_attenders_new.recordcount>
                        <cfoutput query="get_attenders_new">                            
                            <cfset no3 = get_attender_emps.recordcount + get_attender_pars.recordcount + get_attender_cons.recordcount + get_attender_grps.recordcount + currentrow>
                            <tr>
                                <td>
                                    <img src='images/female.jpg' width="50" />
                                </td>
                                <td>#no3#</td>
                                <td><cf_get_lang dictionary_id='58981.Kayıtlı Değil'></td>
                                <td></td>
                                <td>#name#</td>
                                <td></td>
                                <td><textarea name="attender_note" id="attender_note"><cf_get_lang dictionary_id='39210.Email'>:#email#   <cf_get_lang dictionary_id='63896.Telefon'>:#phone#</textarea></td>
                                <td>
                                    <cfif JOIN_STATU eq 0>
                                        <cf_get_lang dictionary_id='30828.Talep'>
                                    <cfelseif JOIN_STATU eq 1>
                                        <cf_get_lang dictionary_id='41402.Kesin Kayıt'>
                                    <cfelseif JOIN_STATU eq 2>
                                        <cf_get_lang dictionary_id='30984.Beklemede'>
                                    <cfelseif JOIN_STATU eq 3>
                                        <cf_get_lang dictionary_id='65250.Kabul Edilmedi'>
                                    </cfif>
                                </td>
                                <td><input type="checkbox" name="attender_#no3#" id="attender_#no3#" value="new;0" onclick="addToList('new','0','#attender_id#')"></td>
                            </tr>
                        </cfoutput>
                    </cfif>
                <cfelse>
                    <tr>
                        <td colspan="8"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>! </td>
                    </tr>
                </cfif>
                <cfoutput>
                    <input type="hidden" name="maxlen" id="maxlen" value="#max_len#">
                    <cfif isDefined("attributes.train_group_id")>
                        <input type="hidden" name="train_group_id" id="train_group_id" value="#attributes.train_group_id#">
                    </cfif>
                </cfoutput>
                <cfif max_len eq 0>
                    <tr>
                        <td colspan="8"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>! </td>
                    </tr
                </cfif>
            </tbody>
            <div id="result_div"></div>
        </cf_flat_list>
        <cf_box_footer>
            <cf_workcube_buttons type_format=0 insert_info="#getLang('','Kesin Kayıt İşlemi Yap',65248)#" add_function="joinRequestProcess(1)">
            <cf_workcube_buttons type_format=0 insert_info="#getLang('','Bekleme Listesine Al',65249)#" class="waitlist" add_function="joinRequestProcess(2)">
            <cf_workcube_buttons type_format=0 insert_info="#getLang('','Katılımcı Listesinden Çıkar',65247)#" class="removeFromList" add_function="joinRequestProcess(3)">
        </cf_box_footer>
    </cf_box>
</div>
<script type="text/javascript">
    var empList = [];
    var parList = [];
    var conList = [];
    var attenderList = [];
    function addToList(type,id,attender_id){
        if( type === "employee" ){
            empList.push(id);
        }else if( type === "partner" ){
            parList.push(id);
        }else if( type === "consumer" ){
            conList.push(id);
        }
        attenderList.push(attender_id);
    }

    function joinRequestProcess(val){
        if( attenderList.length == 0 ){
            alert("<cfoutput>#getLang('','Lütfen kişi seçiniz',46329)#</cfoutput>");
            return false;
        }else{
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=training_management.popup_del_att_from_class&train_group_id=#attributes.train_group_id#</cfoutput>&reqType='+val+'&attenders_emp_id='+empList+'&attenders_par_id='+parList+'&attenders_con_id='+conList+'&training_group_attenders_id='+attenderList,'request_box','ui-draggable-box-medium');
        }
    }

    function add_note(attender_note, attender_id){
        var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_training_groups&event=addNote&attender_note='+ attender_note +'&attender_id='+attender_id;
        AjaxPageLoad(send_address,"result_div",1);
    }
    function reason_kontrol(i)
    {
        if(document.getElementById('complete_'+i).checked)
        {
            document.getElementById('leave_reason_id_'+i).value = '';
            document.getElementById('leave_reason_id_'+i).disabled = true;
        }
        else
        {
            document.getElementById('leave_reason_id_'+i).disabled = false;
        }
    }
    function acceptReq(userid){
        $.ajax({
            url: "/V16/training_management/cfc/training_groups.cfc?method=accept_request&user_id="+userid+"&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>",
            beforeSend: function(  ) {
                $("#loading").html('<cfoutput>#getLang('','İşleniyor',57705)#</cfoutput>...');
            }
        })
        .done(function() {
            $("#loading").html('<cfoutput>#getLang('','Tamamlandı',58786)#</cfoutput>');
            $.ajax({
                url: "/V16/training_management/cfc/training_groups.cfc?method=send_mail_for_requests&user_id="+userid+"&group_head=<cfoutput>#attributes.group_head#</cfoutput>&accept=1",
                beforeSend: function(  ) {
                    $("#loading").html("<cfoutput>#getLang('','Mail',29463)##getLang('','Gönderiliyor',54837)#</cfoutput>");
                }
            })
            .done(function() {
                $("#loading").html("<cfoutput>#getLang('','Mail',29463)##getLang('','Gönderildi',40102)#</cfoutput>");
            });
            
            
            setTimeout(function(){
                $("#attenders .catalyst-refresh").click();
            }, 3000)
        });
        
        return false;
    }
    function rejectReq(userid){
        $.ajax({
            url: "/V16/training_management/cfc/training_groups.cfc?method=reject_request&user_id="+userid+"&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>",
            beforeSend: function(  ) {
                $("#loading").html('<cfoutput>#getLang('','İşleniyor',57705)#</cfoutput>...');
            }
        })
        .done(function() {
            $("#loading").html('<cfoutput>#getLang('','Tamamlandı',58786)#</cfoutput>');
            $.ajax({
                url: "/V16/training_management/cfc/training_groups.cfc?method=send_mail_for_requests&user_id="+userid+"&accept=0&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>&group_head=<cfoutput>#attributes.group_head#</cfoutput>",
                beforeSend: function(  ) {
                    $("#loading").html('<cfoutput>#getLang('','İşleniyor',57705)#</cfoutput>...');
                }
            })
            .done(function() {
                $("#loading").html('<cfoutput>#getLang('','Tamamlandı',58786)#</cfoutput>');
            });
            setTimeout(function(){
                $("#attenders .catalyst-refresh").click();
            }, 3000)
        });
        return false;
    }

    function search_attender(){
        var statu_filter = $('#statu_filter').val();
        var url = "<cfoutput>#request.self#?fuseaction=training_management.popup_list_group_joiners&train_group_id=#attributes.train_group_id#&group_head=#attributes.group_head#</cfoutput>&attender_surname="+document.getElementById('attender_surname').value+"&attender_name="+document.getElementById('attender_name').value+"&statu_filter="+statu_filter;
        AjaxPageLoad(url, 'attender_list', 1);
    }
</script>