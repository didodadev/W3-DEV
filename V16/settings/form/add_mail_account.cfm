<cfset gma = createObject("component","V16.settings.cfc.mail_accounts_settings")/>
<cfset GET_MAIL_SERVER= gma.SelectSN(<!--- SERVER_NAME_ID:attributes.server_name_id --->)/> 
<cfparam name="attributes.maid" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="formAddMailAccount">
            <cf_box_elements>
                <div class="col col-4 col-md-12 col-xs-12">
                    <input type="hidden" name="IS_ACTIVE" id="IS_ACTIVE" value='1'>
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>:</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee_name" id="employee_name" value="<cfif isDefined("attributes.employee_name") and len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>"  onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'0\'','EMPLOYEE_ID','employee_id','','3','225');"style="width:110px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=formAddMailAccount.employee_id&field_name=formAddMailAccount.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.formAddMailAccount.employee_name.value));return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-server_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44173.Mail Sunucu Adresi'>:</label>
                        <div class="col col-8 col-xs-12">
                            <select name="SERVER_NAME_ID" id="SERVER_NAME_ID">
                                <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_MAIL_SERVER"><option value="#SERVER_NAME_ID#">#SERVER_NAME#</option></cfoutput>
                            </select>      
                        </div>
                    </div>
                    <div class="form-group" id="item-mail_account">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55686.E Mail Adresi'>:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="MAIL_ACCOUNT" id="MAIL_ACCOUNT" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-mail_password">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="MAIL_PASSWORD" id="MAIL_PASSWORD" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-mail_account_quota">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39718.Kota'>:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="MAIL_ACCOUNT_QUOTA" id="MAIL_ACCOUNT_QUOTA" value="">
                        </div>
                    </div>
                    <!--- <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44435.E Mail Adresi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_active" id="is_active">
                                <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value='1' <!--- <cfif get_process_cat.profile_id eq 'TEMELFATURA'>selected="selected"</cfif> --->><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value='2' <!--- <cfif get_process_cat.profile_id eq 'TICARIFATURA'>selected="selected"</cfif> --->><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div> --->
                    <div class="form-group" id="item-is_authorized">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42191.Yetkiler'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="IS_AUTHORIZED" id="IS_AUTHORIZED">
                                <option value='1'><cf_get_lang dictionary_id='57930.Kullanıcı'></option>
                                <option value='2'><cf_get_lang dictionary_id='29511.Yönetici'></option>
                            </select>
                        </div>
                    </div><br>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
            </cf_box_footer>
        </cfform> 
    </cf_box>
</div>
<script>
    function kontrol()
    {       
        theMailAddress = document.getElementById('MAIL_ACCOUNT').value + "*" + document.getElementById('SERVER_NAME_ID').value;
        var getMailAddress = wrk_safe_query("mail_account_kontrol",'dsn',0,theMailAddress);
        if(getMailAddress.MAIL_ACCOUNT_ID != undefined)
        {
            alert("<cf_get_lang dictionary_id='51239.Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>");
            document.getElementById('MAIL_ACCOUNT').focus();
            return false;
        }

        if(document.getElementById('SERVER_NAME_ID').value == '0')
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='51238.Sunucu'><cf_get_lang dictionary_id='57897.Adı'>");
            return false;
        }
        if(document.getElementById('MAIL_ACCOUNT').value == '' || document.getElementById('MAIL_ACCOUNT').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='55686.E Mail Adresi'>");
            return false;
        }
        if(document.getElementById('MAIL_PASSWORD').value == '' || document.getElementById('MAIL_PASSWORD').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='57552.Şifre'>");
            return false;
        }
        if(document.getElementById('MAIL_ACCOUNT_QUOTA').value == '' || document.getElementById('MAIL_ACCOUNT_QUOTA').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='39718.Kota'>");
            return false;
        }
        var mailformat = /^\w+([\.-]?\w+)+$/;
        if(MAIL_ACCOUNT.value.match(mailformat))
        {
            document.formAddMailAccount.MAIL_ACCOUNT.focus();
            return true;
        }
        else
        {
            alert("<cf_get_lang dictionary_id='35743.Lütfen farklı bir kullanıcı adı giriniz'>");
            return false;
        }
        return true;
    }
    
</script>



