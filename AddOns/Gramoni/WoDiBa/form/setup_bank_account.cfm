<!---
    File: setup_bank_account.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 29.07.2018
    Controller:
    Description:
		WoDiBa banka hesaplarının güvenlik ve kullanıcı bilgilerinin tanımlanması, güncellenmesi ve silinmesi için kullanılır.
        account_id gönderilmelidir
--->

<cfscript>
    cfparam(name='attributes.company_code', default='');

    include "../cfc/Functions.cfc";

    module_name = 'main';

    account_detail = GetBankAccountWithId(
        CompanyId = session.ep.company_id,
        AccountId = attributes.account_id
    );

    get_account = GetAccountInfo(AccountId=attributes.account_id);

    if (get_account.BANK_CODE is '0010' And Len(get_account.ACCOUNT_NO) Neq 13){
        writeOutput('<script type="text/javascript">alert("Ziraat bankası hesap numarası 00000000-0000 şeklinde 13 hanedem oluşmalıdır.\nHesap bilgilerini güncelleyin."); window.close();</script>');
        abort;
    }

    if(isDefined("attributes.form_submitted")){
        //Converter
        if(attributes.currency_id Eq 'TL'){
            currency_id = 'TRY';
        }

        if(isDefined('attributes.status')){
            status = true;
        }
        else{
            status = false;
        }

        /* Ziraat bankasında hesap numarası şubeno(4)-müşterino(8)-ekno(4) şeklinde tutulur
         banka servisinde ise müşterino(8)-ekno(4) şeklinde tutulduğu için wodiba banka hesaplarına kayıt esnasında
         hesap numarasını dönüştürüyoruz*/
        if (attributes.bank_code is '0010'){
            attributes.account_no   = Left(attributes.account_no,8) & '-' & Right(attributes.account_no,4);
        }

        // Kuveyttürk banka servisinde hesap no müşterino(8)-ekno(1) şeklinde tutulduğu için kayıt esnasında hesap numarasını dönüştürüyoruz. Mahmut 21.03.2021
         if (attributes.bank_code is '0205'){
            attributes.account_no   = attributes.company_code & '-' & Right(attributes.account_no,1);
        }

        if(account_detail.RecordCount){
            UpdateBankAccountWithId(
                Status      = status,
                CompanyId   = session.ep.company_id,
                AccountId   = attributes.account_id,
                BankaKodu   = attributes.bank_code,
                SubeKodu    = attributes.branch_code,
                HesapNo		= attributes.account_no,
                ApiUser		= attributes.api_user,
                ApiPassword = attributes.api_password,
				IsDelete	= attributes.delete_account
            );
        }
        else{
            AddBankAccount(
                Status      = status,
                CompanyId   = session.ep.company_id,
                AccountId   = attributes.account_id,
                BankaKodu   = attributes.bank_code,
                SubeKodu    = attributes.branch_code,
                HesapNo		= attributes.account_no,
                DovizTuru   = currency_id,
                ApiUser		= attributes.api_user,
                ApiPassword = attributes.api_password
            );
        }

        include "../cfc/WebService.cfc";

        //Ekstra parametreler
        args                    = structNew();
        args_bank_accounts      = GetBankAccountsWithBank(CompanyId=session.ep.company_id, BankaKodu=attributes.bank_code);

        if (attributes.bank_code is '0010' And args_bank_accounts.RecordCount) {//Ziraat bankası
            for (bank_account in args_bank_accounts) {
                'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
            }
        }
        else if (attributes.bank_code is '0012') {//Halkbank
            args.SirketKodu = attributes.company_code;
        }
        else if(attributes.bank_code is '0015' And args_bank_accounts.RecordCount){//Vakıfbank
            for (bank_account in args_bank_accounts) {
                'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
            }
        }
        else if(attributes.bank_code is '0032'){//Türk ekonomi bankası
            args.serviceID      = attributes.serviceID;
            args.environment    = 'P';
            args.serviceUser    = attributes.api_user;
            args.servicePwd     = attributes.api_password;
            if (args_bank_accounts.RecordCount) {
                for (bank_account in args_bank_accounts) {
                    'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
                }
            }
        }
        else if (attributes.bank_code is '0062'){//garanti bankası
            args.IP     = GetSettings(our_company_id: session.ep.company_id).WDB_API_SERVER_IP;
            args['Token']  = attributes.api_token;
        }
        else if (attributes.bank_code is '0067'){//Yapı kredi bankası
            if (args_bank_accounts.RecordCount) {
                for (bank_account in args_bank_accounts) {
                    'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
                }
            }
        }
        else if (attributes.bank_code is '0099'){//ING bank
            args.IP     = GetSettings(our_company_id: session.ep.company_id).WDB_API_SERVER_IP;
            args.Token  = attributes.api_token;
            if (args_bank_accounts.RecordCount) {
                for (bank_account in args_bank_accounts) {
                    'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
                }
            }
        }
        else if (attributes.bank_code is '0111'){//finansbank
            args['serviceName']    = attributes.service_name;
            args['namespace']      = attributes.name_space;
            if (args_bank_accounts.RecordCount) {
                for (bank_account in args_bank_accounts) {
                    'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
                }
            }
        }
        else if (attributes.bank_code is '0205') {//KuveytTürk
            args.SirketKodu = attributes.company_code;
        }
        else if (attributes.bank_code is '0206' And args_bank_accounts.RecordCount){//Finans katılım
            for (bank_account in args_bank_accounts) {
                'args.hesapNo_#args_bank_accounts.CurrentRow#'    = bank_account.HESAPNO;
            }
        }
        else if (attributes.bank_code is '0209'){//ziraat katılım
            args.ASSOCIATION_CODE    = attributes.company_code;//şirket kodu
        }

        init(our_company_id: session.ep.company_id);

        sirketHesap = SirketHesap(// gateway servisini çağırıp hesap bilgilerini güncelliyoruz
            vkn                 = '#attributes.tax_no#',
            erpSirketKodu       = session.ep.company_id,
            bankaKodu           = '#attributes.bank_code#',
            uid                 = '#attributes.api_user#',
            bankaAdi            = '#attributes.bank_name#',
            pwd                 = '#attributes.api_password#',
            sirketKodu          = '#attributes.company_code#',
            islemAraligi        = attributes.islemAraligi,
            islemAraligiGeri    = attributes.islemAraligiGeri,
            calismaAraligi      = attributes.calismaAraligi,
            ekstraParametreler  = args,
            aktif               = status,
            bankaId             = attributes.bank_id,
			deleteAccount		= attributes.delete_account
        );
        writeOutput('<script type="text/javascript">alert("#sirketHesap.mesaj#");</script>');
        location("#request.self#?fuseaction=bank.list_bank_account&event=upd&id=#attributes.account_id#","false");

    }

    account_detail = GetBankAccountWithId(// Güncellenmiş bilgileri tekrar çekiyoruz
        CompanyId = session.ep.company_id,
        AccountId = attributes.account_id
    );
</cfscript>

<cfquery name="get_company" datasource="#dsn3#">
    SELECT
        C.TAX_NO
    FROM
        #dsn_alias#.OUR_COMPANY AS C
    WHERE
        C.COMP_ID = #session.ep.company_id#
</cfquery>

<cfset get_account = GetAccountInfo(AccountId=attributes.account_id) />

<cfoutput>
<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='59358.WoDiBa Banka Hesap Tanımları'> - #get_account.ACCOUNT_NAME#</title>
</cfsavecontent>

<cfhtmlhead text="#head_text#" />

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('main','',59358,'WoDiBa Banka Hesap Tanımları')#: #get_account.ACCOUNT_NAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="wdb_bank_account" id="wdb_bank_account" method="post" action="#request.self#?fuseaction=bank.popup_wodiba_setup_bank_account&account_id=#attributes.account_id#">
            <input type="hidden" name="form_submitted" value="1" />
            <input type="hidden" name="delete_account" id="delete_account" value="0" />
            <input type="hidden" name="bank_id" value="#get_account.BANK_ID#" />
            <input type="hidden" name="bank_name" value="#get_account.BANK_NAME#" />
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <div class="col col-9 col-xs-12">
                            <label class="col col-3 col-xs-12" for="status"><input type="checkbox" name="status" id="status" <cfif account_detail.status eq 1>checked</cfif> /><cf_get_lang dictionary_id='57493.Aktif'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-tax_no">
                        <label class="col col-3 col-xs-12" for="tax_no"><cf_get_lang dictionary_id='57752.Vergi No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="tax_no" id="tax_no" value="#get_company.TAX_NO#" readonly="true" />
                            <small><cf_get_lang dictionary_id='64312.Şirket tanımlarından gelmelidir.'></small>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_code">
                        <label class="col col-3 col-xs-12" for="bank_code"><cf_get_lang dictionary_id='59006.Banka Kodu'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="bank_code" id="bank_code" value="#get_account.BANK_CODE#" readonly="true" />
                            <small><cf_get_lang dictionary_id='64313.Banka tanımlarından gelmelidir.'></small>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_code">
                        <label class="col col-3 col-xs-12" for="branch_code"><cf_get_lang dictionary_id='59005.Şube Kodu'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="branch_code" id="branch_code" value="#get_account.BRANCH_CODE#" readonly="true" />
                            <small><cf_get_lang dictionary_id='64314.Banka şube tanımlarından gelmelidir.'></small>
                        </div>
                    </div>
                    <div class="form-group" id="item-account_no">
                        <label class="col col-3 col-xs-12" for="account_no"><cf_get_lang dictionary_id='58178.Hesap No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="account_no" id="account_no" value="#get_account.ACCOUNT_NO#" readonly="true" />
                            <small><cf_get_lang dictionary_id='64315.Hesap tanımından gelmelidir.'></small>
                        </div>
                    </div>
                    <div class="form-group" id="item-currency_id">
                        <label class="col col-3 col-xs-12" for="currency_id"><cf_get_lang dictionary_id='29448.Döviz Cinsi'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="currency_id" id="currency_id" value="#get_account.ACCOUNT_CURRENCY_ID#" readonly="true" />
                            <small><cf_get_lang dictionary_id='64315.Hesap tanımından gelmelidir.'></small>
                        </div>
                    </div>
                    <cfif listFind('0010,0012,0015,0059,0062,0067,0123,0124,0134,0205,0209,0210',get_account.BANK_CODE)><!--- şirket kodu --->
                    <div class="form-group" id="item-company_code">
                        <label class="col col-3 col-xs-12" for="company_code"><cf_get_lang dictionary_id='47568'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="company_code" id="company_code" value="" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64316.Şirket Kodu ya da Müşteri No girilmelidir.'></small>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-api_user">
                        <label class="col col-3 col-xs-12" for="api_user">API <cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="api_user" id="api_user" value="#account_detail.API_USER#" onfocus="select();" />
                        </div>
                    </div>
                    <cfif Not listFind('0062',get_account.BANK_CODE)>
                    <div class="form-group" id="item-api_password">
                        <label class="col col-3 col-xs-12" for="api_password">API <cf_get_lang dictionary_id='57552.Şifre'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="password" name="api_password" id="api_password" value="#account_detail.API_PASSWORD#" onfocus="select();" />
                        </div>
                    </div>
                    </cfif>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-islemAraligi">
                        <label class="col col-3 col-xs-12" for="islemAraligi"><cf_get_lang dictionary_id='64317.İşlem Aralığı'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="islemAraligi" id="islemAraligi" value="86400" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64318.Varsayılan değer'> 86400.</small>
                        </div>
                    </div>
                    <div class="form-group" id="item-islemAraligiGeri">
                        <label class="col col-3 col-xs-12" for="islemAraligiGeri"><cf_get_lang dictionary_id='64319.İşlem Aralığı Geri'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="islemAraligiGeri" id="islemAraligiGeri" value="3600" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64318.Varsayılan değer'> 3600.</small>
                        </div>
                    </div>
                    <div class="form-group" id="item-calismaAraligi">
                        <label class="col col-3 col-xs-12" for="calismaAraligi"><cf_get_lang dictionary_id='36705.Çalışma Aralığı'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="calismaAraligi" id="calismaAraligi" value="300" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64318.Varsayılan değer'> 300 (5 <cf_get_lang dictionary_id='58127.Dakika'>).</small>
                        </div>
                    </div>
                    <cfif get_account.BANK_CODE Eq '0032'><!--- Türk ekonomi bankası --->
                    <div class="form-group" id="item-serviceID">
                        <label class="col col-3 col-xs-12" for="service_name">ServiceID</label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="serviceID" id="serviceID" value="" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64320.Banka tarafından paylaşılacaktır.'></small>
                        </div>
                    </div>
                    <cfelseif get_account.BANK_CODE Eq '0062'><!--- garanti bankası --->
                    <div class="form-group" id="item-api_token">
                        <label class="col col-3 col-xs-12" for="api_token">ID Hash</label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="api_token" id="api_token" value="" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64320.Banka tarafından paylaşılacaktır.'></small>
                        </div>
                    </div>
                    <cfelseif get_account.BANK_CODE Eq '0111'><!--- finansbank --->
                    <div class="form-group" id="item-service_name">
                        <label class="col col-3 col-xs-12" for="service_name">ServiceName</label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="service_name" id="service_name" value="" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64320.Banka tarafından paylaşılacaktır.'></small>
                        </div>
                    </div>
                    <div class="form-group" id="item-name_space">
                        <label class="col col-3 col-xs-12" for="name_space">NameSpace</label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="name_space" id="name_space" value="" onfocus="select();" />
                            <small><cf_get_lang dictionary_id='64320.Banka tarafından paylaşılacaktır.'></small>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12" for="detail"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea style="width:150px;height:30px;" name="detail" id="detail"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd=1 add_function="controlAddBank()" del_function="controlDelBank()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
</cfoutput>

<script type="text/javascript">
    function controlAddBank()
        {
            if(!$("#tax_no").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='57752.Vergi No'>');
                return false;	
            }
            if(!$("#bank_code").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='59006.Banka Kodu'>');
                return false;	
            }
            if(!$("#branch_code").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='59005.Şube Kodu'>');
                return false;	
            }
            if(!$("#account_no").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='58178.Hesap No'>');
                return false;	
            }

            <cfif (listFind('0064',get_account.BANK_CODE))>
                if ($("#account_no").val().length!=7) 
                {
                    alert('<cf_get_lang dictionary_id='64321.Hesap Numarası 7 Haneli Olmalıdır'>! <cf_get_lang dictionary_id='64322.Düzenlemeleri Banka Hesaplarından Yapınız.'>');
                    return false;
                }
                
            </cfif>
            <cfif listFind('0010,0012,0015,0059,0062,0067,0123,0124,0134,0205,0209,0210',get_account.BANK_CODE)>//şirket kodu
            if(!$("#company_code").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='47568'>!');
                $("#company_code").focus();
                return false;	
            }
            </cfif>
            
            <cfif !listFind('0062',get_account.BANK_CODE)>
                if(!$("#api_user").val().length)
                {
                    alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: API <cf_get_lang dictionary_id='57551.Kullanıcı Adı'>');
                    $("#api_user").focus();
                    return false;	
                }
                if(!$("#api_password").val().length)
                {
                    alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: API <cf_get_lang dictionary_id='57552.Şifre'>');
                    $("#api_password").focus();
                    return false;	
                }
            </cfif>
            if(!$("#islemAraligi").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='64317.İşlem Aralığı'>');
                $("#islemAraligi").focus();
                return false;	
            }
            if(!$("#islemAraligiGeri").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='64319.İşlem Aralığı Geri'>');
                $("#islemAraligiGeri").focus();
                return false;	
            }
            if(!$("#calismaAraligi").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='36705.Çalışma Aralığı'>');
                $("#calismaAraligi").focus();
                return false;	
            }
            <cfif get_account.BANK_CODE Eq '0032'>//Türk ekonomi bankası
            if(!$("#serviceID").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: ServiceID!');
                $("#serviceID").focus();
                return false;	
            }
            <cfelseif get_account.BANK_CODE Eq '0062'>//garanti bankası
            if(!$("#api_token").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: API Token\nGaranti Bankası Token uygulaması ile üretilen anahtarı girmelisiniz!');
                $("#api_token").focus();
                return false;	
            }
            <cfelseif get_account.BANK_CODE Eq '0111'>//finansbank
            if(!$("#service_name").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: ServiceName!');
                $("#service_name").focus();
                return false;	
            }
            if(!$("#name_space").val().length)
            {
                alert('<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>: NameSpace!');
                $("#name_space").focus();
                return false;	
            }
            </cfif>
            return true;
        }

    function controlDelBank() {
        $("#delete_account").val(1);
		$("#wdb_bank_account").submit();
    }

    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>