<cf_xml_page_edit fuseact="ehesap.popup_form_fire">
    <cfquery name="get_in_out" datasource="#dsn#">
        SELECT 
            EIO.START_DATE,
            EIO.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.KIDEM_DATE,
            (SELECT TOP 1 SD.DEFINITION FROM EMPLOYEES_IN_OUT_PERIOD EIOP INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SD ON EIOP.ACCOUNT_BILL_TYPE=SD.PAYROLL_ID WHERE IN_OUT_ID = EIO.IN_OUT_ID ORDER BY PERIOD_YEAR DESC) AS DEFINITION
        FROM 
            EMPLOYEES_IN_OUT EIO,
            EMPLOYEES E 
        WHERE 
            EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IN_OUT_ID#"> AND 
            EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
    </cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="1 - #getLang('','İşten Çıkarma','52993')#" scroll="1" collapsable="1" resize="1" popup_box="1">
            <cfform name="cari" id="cari" action="#request.self#?fuseaction=ehesap.popup_form_fire2" method="post">
                <input type="hidden" name="counter" id="counter">
                <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#ATTRIBUTES.IN_OUT_ID#</cfoutput>">
                <input type="hidden" name="x_tax_acc" id="x_tax_acc" value="<cfoutput>#x_tax_acc#</cfoutput>">
                <cfinput type="hidden" name="modal_id" value="#attributes.modal_id#">
                <input type="hidden" name="x_is_salaryparam_get_control" id="x_is_salaryparam_get_control" value="<cfoutput>#x_is_salaryparam_get_control#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_kidem_baz">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" value="1" name="is_kidem_baz" id="is_kidem_baz">
                                <label class="bold"><cf_get_lang dictionary_id ='53981.Hesaplamalarda Kıdem Baz Tarihini Kullan'></label>
                            </div>
                        </div>
                        <cfscript>
                            get_execution_cfc = createObject("component","V16.hr.ehesap.cfc.get_employees_execution");
                            get_execution_cfc.dsn = dsn;
                            get_execution = get_execution_cfc.get_execution(in_out_id:attributes.in_out_id);
                        </cfscript>
                        <cfif get_execution.recordcount>
                        <div class="form-group" id="item-is_kidem_ihbar_all_total">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" value="1" name="is_kidem_ihbar_all_total" id="is_kidem_ihbar_all_total">
                                <label class="bold"><cf_get_lang dictionary_id="59591.İcralarda Kıdem İhbarın Tamamını Al"></label>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-employee">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_in_out.employee_id#</cfoutput>">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.çalışan girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="employee" value="#get_in_out.employee_name# #get_in_out.employee_surname#" required="Yes" message="#message#" readonly="yes">
                            </div>
                        </div>
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53348.İşe Giriş Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input value="<cfoutput>#dateformat(get_in_out.start_date,dateformat_style)#</cfoutput>" type="text" name="startdate" id="startdate" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-kidem_baz">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53641.Kıdem Baz Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input value="<cfif len(get_in_out.kidem_date)><cfoutput>#dateformat(get_in_out.kidem_date,dateformat_style)#</cfoutput></cfif>" type="text" name="kidem_baz" id="kidem_baz" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-finish_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53642.İhbar Edilen Çıkış Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53224.Çıkış Tarihi Girmelisiniz'></cfsavecontent>
                                    <cfinput value="" type="text" name="finish_date" id="finish_date" required="Yes" message="#message#" validate="#validate_style#" onChange="nakil_tarih_change()">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-ihbardate">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53644.İhbar Bildirim Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput value="" type="text" name="ihbardate" validate="#validate_style#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ihbardate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-kidem_hesap">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="kidem_hesap" id="kidem_hesap" value="1">
                                <label><cf_get_lang dictionary_id='53359.Kıdem Tazminatı Hesapla'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-ihbar_hesap">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="ihbar_hesap" id="ihbar_hesap" value="1">
                                <label><cf_get_lang dictionary_id='53360.İhbar Tazminatı Hesapla'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-reason_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53643.Şirket İçi Gerekçe'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_combo 
                                query_name="GET_FIRE_REASONS"
                                name="reason_id"
                                option_value="reason_id"
                                option_name="reason"
                                width="150"
                                where="IS_ACTIVE=1 AND IS_IN_OUT=1"> <!---20131107--->
                            </div>
                        </div>
                        <div class="form-group" id="item-explanation_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52990.Gerekçe'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="explanation_id" id="explanation_id" onchange="is_check(this.value);">
                                <cfloop list="#reason_order_list()#" index="ccc">
                                    <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                    <cfset value_id_ = ccc>
                                    <cfoutput><option value="#value_id_#" <cfif value_id_ eq 2>selected</cfif>>#value_name_#</option></cfoutput>
                                </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-fire_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54355.Çıkış Açıklaması'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                <textarea name="fire_detail" id="fire_detail" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:100%;height:40px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="gizle1" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="entry_date" id="entry_date" maxlength="10" validate="#validate_style#" value="">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="entry_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="gizle2" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="hidden" name="branch_id" id="branch_id" value="">
                                <input type="text" name="branch_" id="branch_" value="" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="gizle3" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Department'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id" value="">
                                    <cfinput type="text" name="department" id="department" value="" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=cari.department_id&field_name=cari.department&field_branch_name=cari.branch_&field_branch_id=cari.branch_id</cfoutput>&run_function=get_bill_type()','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="gizle_kod_grubu" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#get_in_out.definition#</cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="gizle4" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="is_salary" id="is_salary" value="1">
                                <label><cf_get_lang dictionary_id='53211.Ücret Bilgileri Aktarılsın'></label>
                            </div>
                        </div>
                        <div class="form-group" id="gizle5" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="is_salary_detail" id="is_salary_detail" value="1">
                                <label><cf_get_lang dictionary_id='53225.Ödenek,Kesinti ve İstisnalar Aktarılsın'></label>
                            </div>
                        </div>
                        <div class="form-group" id="gizle6" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="is_accounting" id="is_accounting" value="1" onchange="get_bill_type()">
                                <label><cf_get_lang dictionary_id='53316.Muhasebe Bilgileri Aktarılsın'></label>
                            </div>
                        </div>
                        <div class="form-group" id="ACCOUNT_BILL_TYPE_PLACE">
                        </div>
                        <div class="form-group" id="gizle7" style="display:none">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="is_update_position" id="is_update_position" value="1">
                                <label><cf_get_lang dictionary_id='53418.Pozisyon bilgileri güncellensin'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-VALIDATOR_POSITION_CODE">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfquery name="GET_USER_NAME" datasource="#DSN#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                    </cfquery>
                                    <input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="<cfoutput>#session.ep.position_code#</cfoutput>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53395.onay verecek kişi girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="employee_" value="#get_user_name.employee_name# #get_user_name.employee_surname#" style="width:150px;" required="yes" message="#message#" readonly="yes">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=cari.VALIDATOR_POSITION_CODE&field_emp_name=cari.employee_</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <cfif isdefined('x_is_empty_position') and x_is_empty_position eq 1>
                            <div class="form-group" id="item-IS_EMPTY_POSITION">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="checkbox" name="IS_EMPTY_POSITION" id="IS_EMPTY_POSITION" value="1">
                                    <label><cf_get_lang dictionary_id='53419.Çıkış İşlemi Tamamlandığında Çalışan Pozisyonlarını da Boşalt'></label>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-IS_STATUS_EMPLOYEE">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="checkbox" name="IS_STATUS_EMPLOYEE" id="IS_STATUS_EMPLOYEE" value="1">
                                    <label><cf_get_lang dictionary_id='60352.Çıkış İşlemi Tamamlandığında Çalışan Profil Kartını Pasife Al'></label>
                                </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58998.Hesapla'></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' add_function="check_form()" insert_info='#message#'>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        function get_bill_type()
        {	
            if(document.getElementById('is_accounting').checked == true) //muhasebe bilgileri aktarılsın seçili ise çalışsın
            {
                if(document.getElementById('entry_date').value == "")
                {
                    alert("<cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'>");
                    return false;
                }
                var branch_id = document.getElementById('branch_id').value;
                var department_id = document.getElementById('department_id').value;
                var startdate =  document.getElementById('entry_date').value;
                if (branch_id != "" && department_id!= "")
                { 
                    var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_list_account_bill_type&branch_id="+branch_id+"&department_id="+department_id+"&startdate="+startdate;
                    AjaxPageLoad(send_address,'ACCOUNT_BILL_TYPE_PLACE',1,'İlişkili Kod Grupları');
                }
            }
        }
        /*karakter sınırı*/
        function check_form() 
        {
            
            if(cari.ihbar_hesap.checked==true && cari.ihbardate.value.length==0)
                {
                    alert("<cf_get_lang dictionary_id='54599.İhbar Hesaplanan Kişi İçin İhbar Tarihi Seçmelisiniz'>!");
                    return false;
                }
            if(cari.finish_date.value.length==0)
                {
                    alert("<cf_get_lang dictionary_id='53224.Çıkış Tarihi Girmelisiniz'>!");
                    return false;
                }
            if(cari.is_kidem_baz.checked==true && cari.kidem_baz.value.length==0)
                {
                    alert("<cf_get_lang dictionary_id ='53646.Kıdem Baz Tarihi Girilmemiş Çalışan İçin Bu İşlemi Gerçekleştiremezsiniz'>!");
                    return false;
                }
            if(document.getElementById('explanation_id').value == 18) //nakil işlemi ise
            {
                if(document.getElementById('entry_date').value == '' || document.getElementById('department_id').value == '')
                    {
                        alert("<cf_get_lang dictionary_id='54600.Başka Şubeye Geçiş Yapmak İçin Giriş Tarihi ve  Şube Seçmelisiniz'>!");
                        return false;
                    }
            }

            // eger şube veya departmana ait birden fazla tanımlı kod grubu var ise 1 tanesini seçmesi gerekiyor SG 20150413
            if(document.getElementById('account_bill_type_count')!= undefined && document.getElementById('account_bill_type_count').value > 0)
            {
                var account = "";
                for (i = 0; i < document.getElementById('account_bill_type_count').value; i++)
                {
                    if ( document.cari.account_bill_type[i].checked) 
                    {
                        account = document.cari.account_bill_type[i].value;
                        break;
                    }
                }
                if(account != undefined && account == "")
                {
                    alert("<cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>!");	
                    return false;
                }
            }
            
            StrLen = cari.fire_detail.value.length;
            if (StrLen == 1 && cari.fire_detail.value.substring(0,1) == " ") 
                {
                cari.fire_detail.value = "";
                StrLen = 0;
                }
            <cfif isDefined("attributes.draggable")>
                loadPopupBox('cari' , <cfoutput>#attributes.modal_id#</cfoutput>);
            </cfif>
            return false;
        }
       /*  function is_check(deger)
        {
            if(deger == 18)
            {
                document.cari.action = "";
                gizle1.style.display = '';
                gizle2.style.display = '';
                gizle3.style.display = '';
                gizle4.style.display = '';
                gizle5.style.display = '';
                gizle6.style.display = '';
                gizle7.style.display = '';
                gizle_kod_grubu.style.display = '';
                document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_fire</cfoutput>";//nakil ise direk kayıt ekranına yönlendir
            }
            else 
            {
                document.cari.action = "";
                gizle1.style.display = 'none';
                gizle2.style.display = 'none';
                gizle3.style.display = 'none';
                gizle4.style.display = 'none';
                gizle5.style.display = 'none';
                gizle6.style.display = 'none';
                gizle7.style.display = 'none';
                gizle_kod_grubu.style.display = 'none';
                document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.popup_form_fire2</cfoutput>";//nakil değil ise ücret işlemlerinin yapıldığı ekrana yönlendir
            }
        } */
        function nakil_tarih_change()
            {
                document.getElementById('entry_date').value = date_add('d',1,document.getElementById('finish_date').value);
                var finishdate = document.getElementById('finish_date').value;
            }
    </script>
    