<cf_papers paper_type="EMPLOYEE">
<cf_xml_page_edit fuseact="hr.form_upd_emp">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfset employee_no = system_paper_no>
<cfinclude template="../query/get_languages.cfm">
<cfinclude template="../query/get_titles.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfinclude template="../../objects/query/get_user_groups.cfm">
<cfset cmp = createObject("component","V16.hr.cfc.add_rapid_emp")>
<cfset GET_PASSWORD_STYLE = cmp.pass_control()>
<cfset GET_POSITION_DETAIL = cmp.GET_POS_DETAIL()>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="55170.Çalışan Ekle"></cfsavecontent>
<cf_box id="add_emp" title="#message#" closable="0">
    <cfform name="rapid_add_emp" method="post" action="" enctype="multipart/form-data">
        <cf_box_elements>
            <!--- ÇALIŞAN BİLGİLERİ --->
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                <input type="hidden" name="system_paper_no" id="system_paper_no" value="<cfif isdefined('system_paper_no')><cfoutput>#system_paper_no#</cfoutput></cfif>">
                <input type="hidden" name="system_paper_no_add" id="system_paper_no_add" value="<cfif isdefined('system_paper_no_add')><cfoutput>#system_paper_no_add#</cfoutput></cfif>">
                <input type="hidden" name="employee_no" id="employee_no" value="<cfoutput>#employee_no#</cfoutput>" maxlength="50">
                <input type="hidden" name="Design_ID" id="Design_ID" value="4" />
                <div class="form-group" id="item-sex">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'> *</label>
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <input type="radio" name="sex" id="sex" value="1" checked> <cf_get_lang dictionary_id='58959.Erkek'>
                    </label>
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <input type="radio" name="sex" id="sex" value="0"> <cf_get_lang dictionary_id='58958.Kadın'>
                    </label>
                </div>
                <div class="form-group" id="item-tc_identy_no">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" maxlength="11" onKeyup="isNumber(this);" value="">
                    </div>
                </div>
                <div class="form-group" id="item-employee_name">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput type="text" name="employee_name" id="employee_name" maxlength="50" onkeyup="isCharacter(this,1,45);" value="">
                    </div>
                </div>
                <div class="form-group" id="item-employee_surname">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput name="employee_surname" id="employee_surname" type="text" maxlength="50" onkeyup="isCharacter(this,0,45);" value="">
                    </div>
                </div>
                <div class="form-group" id="item-employee_username">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput value="" type="text" name="employee_username" id="employee_username" maxlength="20">
                    </div>
                </div>
                <div class="form-group" id="item-password">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55439.Şifre (karakter duyarlı)	'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfif isdefined("use_active_directory") and use_active_directory neq 3>
                                <cfinput value="" type="text" class="input-type-password" name="employee_password" id="employee_password" maxlength="16">
                            <cfelse>
                                <cfinput value="" type="text" class="input-type-password" name="employee_password" id="employee_password" maxlength="16" readonly="yes">
                            </cfif>
                            <span class="input-group-addon showPassword" onclick="showPasswordClass('employee_password')"><i class="fa fa-eye"></i></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-employee_email_spc">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput type="text" name="employee_email_spc" id="employee_email_spc" maxlength="50" validate="email" message="#getLang('call',27)#">
                    </div>
                </div>
                <div class="form-group" id="item-language">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="language" id="language">
                            <cfoutput query="get_languages">
                                <option value="#language_short#">#language_set#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-time_zone">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58880.Time Zone'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cf_wrkTimeZone width="445">
                    </div>
                </div>
                <div class="form-group" id="item-process_stage">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                    </div>
                </div>
            </div>
            <!--- --->
            <!--- POZİSYON BİLGİLERİ --->
            <cfinclude template="../query/get_user_groups.cfm">
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                <input type="hidden" name="employee_id" id="employee_id" value="">
                <input type="hidden" name="group_id1" id="group_id1" value="<cfoutput>#get_user_groups.user_group_id#</cfoutput>">
                <div class="form-group" id="item-branch">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'><i class="catalyst-question" title="Şube alanı departman seçildikten sonra otomatik olarak gelmektedir."></i></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="hidden" name="branch_id" id="branch_id" value="">
                        <input type="text" name="branch" id="branch" value="" readonly>
                    </div>                
                </div>
                <div class="form-group" id="item-department">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="department_id" id="department_id" value="">
                            <input type="text" name="department" id="department" value="" readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=rapid_add_emp.department_id&field_name=rapid_add_emp.department&field_branch_name=rapid_add_emp.branch&field_branch_id=rapid_add_emp.branch_id</cfoutput>','list');"></span>              
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-position_name">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="position_id" id="position_id" value="" maxlength="50">
                            <cfinput type="text" name="position_name" id="position_name" value="" maxlength="50">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_names&field_name=rapid_add_emp.position_name&field_id_3=rapid_add_emp.position_id&field_pos_name=rapid_add_emp.position_name&empty_pos=1&field_dep_id=rapid_add_emp.department_id&field_dep_name=rapid_add_emp.department&field_pos_cat_id=rapid_add_emp.position_cat_id&from_add_rapid=1&field_title_id=rapid_add_emp.title_id&select_list=1&position_cat_id_name=1&field_branch_name=rapid_add_emp.branch','list');"></span>              
                        </div>
                    </div>                
                </div>
                <div class="form-group" id="item-position_cat_id">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                        <div class="input-group">
                            <select name="position_cat_id" id="position_cat_id" onchange="change_fields();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_position_cats">
                                    <option value="<cfoutput>#POSITION_CAT_ID#;#POSITION_CAT#</cfoutput>"><cfoutput>#POSITION_CAT#</cfoutput></option>
                                </cfloop>
                            </select>
                            <span class="input-group-addon btnPointer icon-question" onclick="open_position_norm();"></span>              
                        </div>
                    </div>                
                </div>
                <div class="form-group" id="item-title_id">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="title_id" id="title_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="titles">
                                <option value="<cfoutput>#title_ID#</cfoutput>"><cfoutput>#title#</cfoutput></option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-process_stage2">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">- <cf_get_lang dictionary_id="58497.Pozisyon"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                    </div>
                </div>
            </div>
            <!--- --->
            <!--- YETKİNLİK BİLGİLERİ --->
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                <cfinclude template="../../objects/query/get_user_groups.cfm">
                <div id="td_group" style="display:<cfif len(get_position_detail.user_group_id)>''<cfelse>'none'</cfif>;">
                    <div class="form-group" id="item-group_id2">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32897.Kullanıcı Grubu'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfset menus="0">
                            <cfif len(get_position_detail.user_group_id)>
                                <cfset attributes.user_group_id = get_position_detail.user_group_id>
                                <cfinclude template="../query/get_user_group_name.cfm">
                            </cfif>
                            <cfif get_module_user(64)>
                                <select name="group_id2" id="group_id2" onchange="get_menus_select($(this));">
                                <option value=""><cf_get_lang dictionary_id='32983.Yetki Grubu'>
                                <cfoutput query="get_user_groups">
                                    <option value="#user_group_id#" <cfif user_group_id eq get_position_detail.user_group_id> selected</cfif>>#user_group_name#</option>
                                        <cfif user_group_id eq get_position_detail.user_group_id and len(wrk_menu)>
                                            <cfset menus = wrk_menu>
                                        </cfif>
                                </cfoutput>
                                </select>
                            <cfelse>
                                <input type="hidden" name="group_id2" id="group_id2" value="<cfoutput>#get_position_detail.user_group_id#</cfoutput>">
                                <cfif len(get_position_detail.user_group_id)>
                                    <cfoutput>#get_user_group_name.user_group_name#</cfoutput>
                                </cfif>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div id="item-emp_period_check">
                    <div class="form-group" id="item-period">
                        <cfset attributes.position_id = session.ep.POSITION_CODE>
                        <cfinclude template="../../objects/query/get_emp_period_details.cfm">
                        <cfset period_selected = ValueList(get_emp_periods.period_id)>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_grid_list>
                                <thead>
                                    <tr><th colspan="6"><b><cf_get_lang dictionary_id="59012.Çalışma Dönemi"></b></th></tr>
                                    <tr>
                                        <th width="3%"><cf_get_lang dictionary_id='57487.No'></th>
                                        <th><cf_get_lang dictionary_id='57574.Firma'></th>
                                        <th style="width:140px;"><cf_get_lang dictionary_id='32691.Period'></th>
                                        <th style="width:70px;"><cf_get_lang dictionary_id='32693.Period Yıl'></th>
                                        <th style="width:150px;"><cf_get_lang dictionary_id='32709.Tarih Kısıtı'></th>
                                        <th style="width:20px;"><cf_get_lang dictionary_id='58693.Seç'></th>
                                    </tr>
                                </thead>
                                <input type="hidden" name="auth_emps_pos" id="auth_emps_pos" value="">
                                <input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
                                <cfif isdefined("attributes.is_hr")><input type="hidden" name="is_hr" id="is_hr" value="1"></cfif>
                                <input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
                                <cfif get_other_companies.recordcount>
                                    <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_other_companies.recordcount#</cfoutput>">
                                    <cfoutput query="get_other_companies">
                                    <tbody>
                                        <tr>
                                            <td>#currentrow#</td>
                                            <td>#nick_name#</td>
                                            <td>#period#</td>
                                            <td>#period_year#</td>
                                                <cfquery name="get_date" dbtype="query">
                                                    SELECT PROCESS_DATE, PERIOD_DATE FROM GET_EMP_PERIODS WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#">
                                                </cfquery>
                                            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id="56283.Tarih Girmelisiniz"></cfsavecontent>
                                                <div class="form-group">
                                                <div class="input-group">
                                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="action_date#period_id#" value="#dateformat(get_date.period_date,dateformat_style)#">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="action_date#period_id#"></span>
                                                </div>
                                                </div>
                                            </td>
                                            <td><input type="radio" name="periods" id="periods" value="#period_id#" <cfif (get_emp_periods.default_period is get_other_companies.period_id) and (len(get_emp_periods.default_period) or len(get_other_companies.period_id))>Checked</cfif>></td>
                                        </tr>
                                    </tbody>
                                    </cfoutput>
                                </cfif>
                            </cf_grid_list>
                        </div>
                    </div>
                </div>
            </div>
            <!--- --->
        </cf_box_elements>
        <div class="ui-form-list-btn">
            <cf_workcube_buttons is_upd='0' add_function='kontrol_page()'>
        </div>
    </cfform>
</cf_box>

<script type="text/javascript">


    function kontrol_page(){
        var emp_no = $('#employee_no').val();
        var get_employee_no_query = wrk_safe_query('hr_employee_no_qry','dsn',0,emp_no);
        if(get_employee_no_query.recordcount)
        {
            alert("<cf_get_lang dictionary_id='56835.Aynı Çalışan No İle Kayıt Var'>!  <cf_get_lang dictionary_id='55971.Yeni Numara Atanacaktır'>!");
            var run_query = wrk_safe_query('hr_emp_detail','dsn',0,'<cfoutput>#paper_code#</cfoutput>');
            var emp_num = parseFloat(run_query.BIGGEST_NUMBER)+ 1;
            var emp_num_join = '<cfoutput>#paper_code#</cfoutput>' + '-' +emp_num;
            document.getElementById('employee_no').value = emp_num_join;
            document.getElementById('system_paper_no_add').value = emp_num;
        }
        if(document.getElementById('TC_IDENTY_NO').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.zorunlu alan'> : <cf_get_lang dictionary_id='58025.TC Kimlik No'>!");
            document.getElementById('TC_IDENTY_NO').focus();
            return false;
        }
        var get_emp_tc = wrk_safe_query("hr_get_tc_control",'dsn',0,document.getElementById('TC_IDENTY_NO').value);
        if(get_emp_tc.TC_IDENTY_NO != undefined){
            alert(get_emp_tc.EMP_NAME + "<cf_get_lang dictionary_id ='55090.Adlı Çalışan Aynı TC Kimlik No İle Kayıtlı'>! <cf_get_lang dictionary_id ='55091.Lütfen Düzeltiniz'>!");
            document.getElementById('TC_IDENTY_NO').focus();
            return false;
        }
        if(document.getElementById('employee_name').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.zorunlu alan'> : <cf_get_lang dictionary_id='57631.Ad'>!");
            document.getElementById('employee_name').focus();
            return false;
        }
        if(document.getElementById('employee_surname').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.zorunlu alan'> : <cf_get_lang dictionary_id='58726.Soyad'>!");
            document.getElementById('employee_surname').focus();
            return false;
        }
        listParam = document.getElementById('employee_name').value + "*" + document.getElementById('employee_surname').value;
        var get_emp_name = wrk_safe_query("hr_get_name_control",'dsn',0,listParam);
        if(get_emp_name.EMPLOYEE_ID != undefined){
            if(!(confirm(document.getElementById('employee_name').value + " " + document.getElementById('employee_surname').value + " <cfoutput>adında bir çalışan kaydı daha var!\n Kaydetmek istediğinizen emin misiniz?</cfoutput>")))
            {
                document.getElementById('employee_name').focus();
                return false;
            }
        }
        if(document.getElementById('employee_username').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='57551.Kullanıcı Adı'>!");
            document.getElementById('employee_username').focus();
            return false;
        }
        var get_emp_username = wrk_safe_query("hr_get_username_control",'dsn',0,document.getElementById('employee_username').value);
        if(get_emp_username.EMPLOYEE_ID != undefined){
            alert("<cf_get_lang dictionary_id ='56812.Lütfen Başka Bir Kullanıcı Adı Girin'>!");
            document.getElementById('employee_username').focus();
            return false;
        }
        if(document.getElementById('employee_password').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='55439.Şifre*(karakter duyarlı)'>!");
            document.getElementById('employee_password').focus();
            return false;
        }
        if(document.getElementById('employee_email_spc').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='57428.E-mail'>!");
            document.getElementById('employee_email_spc').focus();
            return false;
        }
        if ($('#employee_password').val().indexOf(" ") != -1)
        {
            alert("<cf_get_lang dictionary_id='38682.Şifre boşluk karakterini içeremez'>");
            $('#employee_password').focus();
            return false;
        }
        if(($('#employee_username').val() != "") && ($('#employee_password').val() != "") && ($('#employee_username').val() == $('#employee_password').val()))
        {
            alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz'>!");
            $('#employee_password').focus();
            return false;
        }
        if ($('#employee_password').val() != "")
        {
            <cfif GET_PASSWORD_STYLE.recordcount>
                var number="0123456789";
                var lowercase = "abcdefghijklmnopqrstuvwxyz";
                var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
                
                var containsNumberCase = contains($('#employee_password').val(),number);
                var containsLowerCase = contains($('#employee_password').val(),lowercase);
                var containsUpperCase = contains($('#employee_password').val(),uppercase);
                var ozl = contains($('#employee_password').val(),ozel);
                
                <cfoutput>
                    if(document.getElementById('employee_password').value.length < #get_password_style.password_length#)
                    {
                        alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'> ! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
                        document.getElementById('employee_password').focus();				
                        return false;
                    }
                    
                    if(#get_password_style.password_number_length# > containsNumberCase)
                    {
                        alert("<cf_get_lang dictionary_id='30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
                        document.getElementById('employee_password').focus();
                        return false;
                    }
                    
                    if(#get_password_style.password_lowercase_length# > containsLowerCase)
                    {
                        alert("<cf_get_lang dictionary_id='30947.Şifrede Olması Gereken Küçük Harf Sayısı'>:#get_password_style.password_lowercase_length#");
                        document.getElementById('employee_password').focus();				
                        return false;
                    }
                    
                    if(#get_password_style.password_uppercase_length# > containsUpperCase)
                    {
                        alert("<cf_get_lang dictionary_id='30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
                        document.getElementById('employee_password').focus();
                        return false;
                    }
                    
                    if(#get_password_style.password_special_length# > ozl)
                    {
                        alert("<cf_get_lang dictionary_id='30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
                        document.getElementById('employee_password').focus();
                        return false;
                    }
                </cfoutput>
            </cfif>
        }
        if(document.getElementById('branch').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id ='57453.Şube'>!");
            document.getElementById('branch').focus();
            return false;
        }
        if(document.getElementById('department').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='57572.Departman'>!");
            document.getElementById('department').focus();
            return false;
        }
        if(document.getElementById('position_name').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='58497.Pozisyon'>!");
            document.getElementById('position_name').focus();
            return false;
        }
        if(document.getElementById('position_cat_id').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='59004.Pozisyon Tipi'>!");
            document.getElementById('position_cat_id').focus();
            return false;
        }
        if(document.getElementById('title_id').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'> : <cf_get_lang dictionary_id='57571.Ünvan'>!");
            document.getElementById('title_id').focus();
            return false;
        }
        get_auth_emps(1,1,0);
        return true;
    }

    function change_fields(){
		var dizi = document.rapid_add_emp.position_cat_id.value.split(';');
		$("#title_id").find("option").prop('selected',false);
		if(dizi[0] != '')
		{
			var pos_cat_det = wrk_query('SELECT TITLE_ID FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = '+dizi[0],'dsn');
			if (pos_cat_det)
			{
				if (pos_cat_det.TITLE_ID != '')
					$("#title_id").find("option[value="+pos_cat_det.TITLE_ID+"]").prop("selected","selected");
			}
		}
    }
    
    function open_position_norm(){
		mk = document.getElementById('position_cat_id').selectedIndex;
		if(document.rapid_add_emp.position_cat_id[mk].value == "")
			alert("<cf_get_lang dictionary_id ='56323.Pozisyon Tipi Seçmelisiniz'>!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cat_norms&position_cat_id=' + list_getat(document.rapid_add_emp.position_cat_id[mk].value,1,';'),'horizantal');
    }

    function contains(deger,validChars){
		var sayac=0;				             
		for (i = 0; i < deger.length; i++)
		{
			var char = deger.charAt(i);
			if (validChars.indexOf(char) > -1)    
				sayac++;
		}
		return(sayac);				
    }
    
    function kontrol_default_period(){
        temp1=0;
        <cfif GET_OTHER_COMPANIES.recordcount eq 1>
            if (rapid_add_emp.periods.checked)
                temp1 = 1;
        <cfelse>
            for(i=0;i<rapid_add_emp.periods.length;i++)
                if (rapid_add_emp.periods[i].checked)
                    temp1 = 1;
        </cfif>
        if (temp1 == 0)
        {
            if(rapid_add_emp.periods.value == 1)
                return true;
                
            alert("<cf_get_lang dictionary_id='33372.Öncelik Kolonundan Standart Bir Dönem Seçmelisiniz'>!");
            return false;
        }
    }

    function get_auth_emps(x,y,z,w){
		temp_str_pos="";
		temp_str_pos_codes="";
		temp_str="";
		temp_control = 0;
		temp_count = $('#tbl_to_names_row_count').val()-1;
		for(i=0;i<=temp_count;i++)
		{
			if(((x == 1 && $('input[name=to_emp_ids]').get(i) && $('input[name=to_emp_ids]').get(i).value.length) || x == 0) && ((y == 1 && $('input[name=to_pos_ids]').get(i) && $('input[name=to_pos_ids]').get(i).value.length) || y == 0) && ((z == 1 && $('input[name=to_pos_codes]').get(i) && $('input[name=to_pos_codes]').get(i).value.length) || z == 0))
			{
				if(temp_control == 1)
				{
					if (x == 1)
						temp_str = temp_str + ',' + $('input[name=to_emp_ids]').get(i).value;
					if (y == 1)
						temp_str_pos = temp_str_pos + ',' + $('input[name=to_pos_ids]').get(i).value;
					if (z == 1)
						temp_str_pos_codes = temp_str_pos_codes + ',' + $('input[name=to_pos_codes]').get(i).value;
				}
				else
				{
					if (x == 1)
						temp_str = temp_str + $('input[name=to_emp_ids]').get(i).value;
					if (y == 1)
						temp_str_pos = temp_str_pos + $('input[name=to_pos_ids]').get(i).value;
					if (z == 1)
						temp_str_pos = temp_str_pos_codes + $('input[name=to_pos_codes]').get(i).value;
					temp_control = 1;
				}
			}
		}
		if (x == 1)
			$('input[name=auth_emps_id]').val(temp_str);
		if (y == 1)
			$('input[name=auth_emps_pos]').val(temp_str_pos);
		if (z == 1)
			$('input[name=auth_emps_pos_codes]').val(temp_str_pos);
		<cfif isdefined('attributes.from_sec') and attributes.from_sec eq 1>
			if (w == 1)
				$('input[name=from_sec]').val(1);
		</cfif>
	}
</script>