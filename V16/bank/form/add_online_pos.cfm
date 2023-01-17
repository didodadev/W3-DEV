<cf_get_lang_set module_name="bank">
<cf_papers paper_type="creditcard_revenue">
<cf_xml_page_edit fuseact="bank.popup_add_online_pos">
<cfif use_https>
	<cfset url_link = https_domain>
<cfelse>
	<cfset url_link = "">
</cfif>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO,
		CPT.PAYMENT_RATE,
        CPT.PAYMENT_RATE_ACC,
		CPT.NUMBER_OF_INSTALMENT,
		OCPR.POS_ID POS_TYPE,
        OCPR.POS_TYPE POS_TYPE_ <!--- sanal pos tipi --->
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT,
		#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
	WHERE
		<cfif session.ep.period_year lt 2009>
			ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL' AND<!--- toplu pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
		</cfif>
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
		OCPR.POS_ID = CPT.POS_TYPE AND
		CPT.IS_ACTIVE = 1 AND
		CPT.POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
	<cfif session.ep.isBranchAuthorization>
		AND ACCOUNTS.ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
	</cfif>
UNION ALL
	SELECT
		0 AS ACCOUNT_ID,
		OCPR.POS_NAME AS ACCOUNT_NAME,
		'#session.ep.money#' AS ACCOUNT_CURRENCY_ID,
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO,
		CPT.PAYMENT_RATE,
        CPT.PAYMENT_RATE_ACC,
		CPT.NUMBER_OF_INSTALMENT,
		OCPR.POS_ID POS_TYPE,
        OCPR.POS_TYPE POS_TYPE_ <!--- sanal pos tipi --->
	FROM
		CREDITCARD_PAYMENT_TYPE CPT,
		#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
	WHERE
		OCPR.POS_ID = CPT.POS_TYPE AND
		CPT.IS_ACTIVE = 1 AND
		CPT.COMPANY_ID IS NOT NULL AND
		CPT.POS_TYPE IS NOT NULL
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfquery name="get_bank_type" datasource="#dsn#">
	SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<!--- provizyon ekranlarından sanal pos ekranına geçiş durumları içindir --->
<cfif isDefined("attributes.member_type") and attributes.member_type eq "0"><!--- company --->
	<cfquery name="GET_COMP_INFO" datasource="#dsn#">
		SELECT NICKNAME,MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.member_id#
	</cfquery>
	<cfset comp_id = attributes.member_id>
	<cfset par_id = GET_COMP_INFO.MANAGER_PARTNER_ID>
	<cfset cons_id = "">
	<cfset member_name = GET_COMP_INFO.NICKNAME>
	<cfset main_act_value = attributes.action_value>
	<cfif IsDefined("attributes.card_id_info") and len(attributes.card_id_info)>
		<cfquery name="GET_CARD_INFO" datasource="#dsn#"><!--- 2 query birleştirilmedi çünkü kart bilgilrinde bideğişiklik olabilir,üye bilgilerini etkilemesin --->
			SELECT COMPANY_CC_NUMBER,COMPANY_BANK_TYPE,COMPANY_CARD_OWNER,COMPANY_EX_MONTH,COMPANY_EX_YEAR,COMP_CVS FROM COMPANY_CC WHERE COMPANY_CC_ID = #attributes.card_id_info#
		</cfquery>
		<!--- 
			FA-09102013
			kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
			Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
		--->
		<cfscript>
			getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
			getCCNOKey.dsn = dsn;
			getCCNOKey1 = getCCNOKey.getCCNOKey1();
			getCCNOKey2 = getCCNOKey.getCCNOKey2();
		</cfscript>
		<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
		<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
			<!--- anahtarlar decode ediliyor --->
			<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
			<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
			<!--- kart no encode ediliyor --->
			<cfset cc_number = contentEncryptingandDecodingAES(isEncode:0,content:GET_CARD_INFO.COMPANY_CC_NUMBER,accountKey:comp_id,key1:ccno_key1,key2:ccno_key2) />
		<cfelse>
			<cfset cc_number = Decrypt(GET_CARD_INFO.COMPANY_CC_NUMBER,comp_id,"CFMX_COMPAT","Hex")>
		</cfif>
		<cfset c_bank_type = GET_CARD_INFO.COMPANY_BANK_TYPE>
		<cfset cc_owner = GET_CARD_INFO.COMPANY_CARD_OWNER>
		<cfset c_ex_m = GET_CARD_INFO.COMPANY_EX_MONTH>
		<cfset c_ex_y = GET_CARD_INFO.COMPANY_EX_YEAR>
		<cfset c_cvs = GET_CARD_INFO.COMP_CVS>
	<cfelse>
		<cfset cc_number = "">
		<cfset c_bank_type = "">
		<cfset cc_owner = "">
		<cfset c_ex_m = "">
		<cfset c_ex_y = dateFormat(now(),'yyyy')>
		<cfset c_cvs = "">
	</cfif>
	<cfif x_readonly_info eq 1>
		<cfset readonly_info ="yes">
	<cfelse>
		<cfset readonly_info ="no">
	</cfif>
<cfelseif isDefined("attributes.member_type") and attributes.member_type eq "1">
	<cfquery name="GET_COMP_INFO" datasource="#dsn#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.member_id#
	</cfquery>
	<cfset comp_id = "">
	<cfset par_id = "">
	<cfset cons_id = attributes.member_id>
	<cfset member_name = GET_COMP_INFO.CONSUMER_NAME & " " & GET_COMP_INFO.CONSUMER_SURNAME>
	<cfset main_act_value = attributes.action_value>
	<cfif len(attributes.card_id_info)>
		<cfquery name="GET_CARD_INFO" datasource="#dsn#"><!--- 2 query birleştirilmedi çünkü kart bilgilrinde bideğişiklik olabilir,üye bilgilerini etkilemesin --->
			SELECT CONSUMER_CC_NUMBER,CONSUMER_BANK_TYPE,CONSUMER_CARD_OWNER,CONSUMER_EX_MONTH,CONSUMER_EX_YEAR,CONS_CVS FROM CONSUMER_CC WHERE CONSUMER_CC_ID = #attributes.card_id_info#
		</cfquery>
		<!--- 
			FA-09102013
			kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
			Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
		--->
		<cfscript>
			getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
			getCCNOKey.dsn = dsn;
			getCCNOKey1 = getCCNOKey.getCCNOKey1();
			getCCNOKey2 = getCCNOKey.getCCNOKey2();
		</cfscript>
		<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
		<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
			<!--- anahtarlar decode ediliyor --->
			<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
			<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
			<!--- kart no encode ediliyor --->
			<cfset cc_number = contentEncryptingandDecodingAES(isEncode:0,content:GET_CARD_INFO.CONSUMER_CC_NUMBER,accountKey:cons_id,key1:ccno_key1,key2:ccno_key2) />
		<cfelse>
			<cfset cc_number = Decrypt(GET_CARD_INFO.CONSUMER_CC_NUMBER,cons_id,"CFMX_COMPAT","Hex")>
		</cfif>
		<cfset c_bank_type = GET_CARD_INFO.CONSUMER_BANK_TYPE>
		<cfset cc_owner = GET_CARD_INFO.CONSUMER_CARD_OWNER>
		<cfset c_ex_m = GET_CARD_INFO.CONSUMER_EX_MONTH>
		<cfset c_ex_y = GET_CARD_INFO.CONSUMER_EX_YEAR>
		<cfset c_cvs = GET_CARD_INFO.CONS_CVS>
	<cfelse>
		<cfset cc_number = "">
		<cfset c_bank_type = "">
		<cfset cc_owner = "">
		<cfset c_ex_m = "">
		<cfset c_ex_y = dateFormat(now(),'yyyy')>
		<cfset c_cvs = "">
	</cfif>
	<cfif x_readonly_info eq 1>
		<cfset readonly_info ="yes">
	<cfelse>
		<cfset readonly_info ="no">
	</cfif>
<cfelse>
	<cfset comp_id = "">
	<cfset par_id = "">
	<cfset cons_id = "">
	<cfset member_name = "">
	<cfset cc_number = "">
	<cfset c_bank_type = "">
	<cfset cc_owner = "">
	<cfset c_ex_m = "">
	<cfset c_ex_y = dateFormat(now(),'yyyy')>
	<cfset c_cvs = "">
	<cfset main_act_value = "">
	<cfset readonly_info ="no">
</cfif>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('bank',357)#">
        <cfform name="add_online_pos" method="post" action="#url_link##request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_online_pos_kontrol">
                <input type="hidden" name="x_is_add_ins_number" id="x_is_add_ins_number" value="<cfoutput>#x_is_add_ins_number#</cfoutput>">
                <input type="hidden" name="x_send_error_mail" id="x_send_error_mail" value="<cfoutput>#x_send_error_mail#</cfoutput>">
                <cfif isdefined('attributes.invoice_id') and len(attributes.invoice_id)>
                    <input type="hidden" name="subs_inv_id" id="subs_inv_id" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
                    <cfquery name="get_invoice_payment_id" datasource="#dsn2#">
                        SELECT ISNULL(CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
                    </cfquery>
                </cfif>
                <cfif isdefined('attributes.period_id') and len(attributes.period_id)>
                    <input type="hidden" name="period_id" id="period_id" value="<cfoutput>#attributes.period_id#</cfoutput>">
                </cfif>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-action_to_account_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'> / <cf_get_lang dictionary_id='
                            58516.Ödeme Yöntemi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <select name="action_to_account_id" id="action_to_account_id" onChange="kur_ekle_f_hesapla('action_to_account_id');gizle_goster(this.value);change_comm_value();">
                                <option value=""><cf_get_lang dictionary_id='48966.Hesap ve Ödeme Yöntemi Seçiniz'></option>
                                    <cfoutput query="GET_ACCOUNTS"><!---eleman sırası değişmesin AE--->
                                <option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#;#POS_TYPE#;#NUMBER_OF_INSTALMENT#;#PAYMENT_RATE#;#POS_TYPE_#;#PAYMENT_RATE_ACC#" <cfif isDefined("attributes.paym_id") and attributes.paym_id eq PAYMENT_TYPE_ID>selected</cfif>>#ACCOUNT_NAME# / #CARD_NO#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="240">
                        </div>
                    </div>
                    <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0> 
                    <div class="form-group" id="item-DepartmentBranch">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='240' is_default='1' is_deny_control='1'>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#cons_id#</cfoutput>">
                                <input type="hidden" name="par_id" id="par_id" value="<cfoutput>#par_id#</cfoutput>">
                                <input type="hidden" name="action_from_company_id" id="action_from_company_id" value="<cfoutput>#comp_id#</cfoutput>">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='48665.cari hesap girmelisini'></cfsavecontent>
                                <cfinput type="text" name="comp_name" id="comp_name" onFocus= "AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID','cons_id,action_from_company_id','','2','250','get_member_card();get_money_info(\'add_online_pos\',\'action_date\')');" required="yes" message="#message#" value="#member_name#">
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main dictionary_id='57519.cari Hesap'>" onClick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&call_function=get_member_card()&field_comp_id=add_online_pos.action_from_company_id&field_member_name=add_online_pos.comp_name&field_partner=add_online_pos.par_id&field_consumer=add_online_pos.cons_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>','list');"></span>
                            </div>      
                        </div>
                    </div>  
                    <cfif session.ep.our_company_info.project_followup eq 1 and x_is_project_display eq 1>         
                    <div class="form-group" id="item-project_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="Hidden" name="project_id" id="project_id" value="">
                                <cf_wrk_projects form_name='add_online_pos' project_id='project_id' project_name='project_name'>
                                <input type="text" name="project_name" id="project_name" value="" onkeyup="get_project_1();">
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58797.Proje Seçiniz'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_online_pos.project_name&project_id=add_online_pos.project_id</cfoutput>');"></span>                                
                            </div>
                        </div>
                    </div>  
                    </cfif> 
                    <cfif isDefined("attributes.member_type")>
                    <div class="form-group" id="item-bank_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57521.Banka'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="bank_type" id="bank_type">
                                <option value=""><cf_get_lang_main dictionary_id='57734.Seçiniz'>
                                    <cfoutput query="get_bank_type">
                                <option value="#BANK_ID#" <cfif BANK_ID eq c_bank_type>selected</cfif>>#BANK_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    </cfif>
                    <cfif x_select_credit_card eq 0 or (isdefined('attributes.member_id') and len(attributes.member_id) and len(cc_number))>
                    <div class="form-group" id="item-card_owner">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48894.Kart Hamili'></label>
                        <div class="col col-8 col-xs-12">
                            <input name="card_owner" id="card_owner" type="text" maxlength="30" value="<cfoutput>#left(cc_owner,30)#</cfoutput>">                               
                        </div>
                    </div>
                    </cfif>                         
                    <div class="form-group" id="item-member_card_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48854.Kart No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.member_id') and len(attributes.member_id) and len(cc_number)>
                                <cfset cc_number_dec = '#mid(cc_number,1,4)#********#mid(cc_number,Len(cc_number) - 3, Len(cc_number))#'>
                                <cfinput type="hidden" name="card_no" value="#cc_number#" />
                                <cfinput type="Text" name="card_no_dec" value="#cc_number_dec#" readonly="yes" />
                            <cfelse>
                            <cfif x_select_credit_card eq 0>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='48864.Lütfen Geçerli Kredi Kartı Giriniz'> !</cfsavecontent>
                                <cf_input_pcKlavye name="card_no" value="" type="text" numpad="true" accessible="true" maxlength="16" inputStyle="width:240px;" message="#message#" required="yes" validate="creditcard" onKeyUp="isNumber(this);">
                            <cfelse>
                                <div id="bank_list">
                                    <select name="member_card_id" id="member_card_id" >
                                        <option value=""><cf_get_lang_main dictionary_id='57734.Seçiniz'></option>
                                    </select>
                                </div>
                            </cfif>
                            </cfif>
                        </div>
                    </div>
                    <cfif x_select_credit_card eq 0 or (isdefined('attributes.member_id') and len(attributes.member_id) and len(cc_number))>                         
                        <div class="form-group" id="item-exp_month">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49020.CVV'>/ <cf_get_lang dictionary_id='49019.Son Kul Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined('attributes.member_id') and len(attributes.member_id) and len(cc_number)>
                                    <cfset cc_number_dec = '#mid(cc_number,1,4)#********#mid(cc_number,Len(cc_number) - 3, Len(cc_number))#'>
                                    <cfinput type="hidden" name="cvv_no" value="#c_cvs#" />
                                    <cfinput type="Text" name="cvv_no_dec" value="#Left(c_cvs, 1)#*#Right(c_cvs, 1)#" readonly="yes" />
                                <cfelse>
                                <cfif x_cvv_requerid eq 1>
                                    <cfsavecontent variable="msg"><cf_get_lang dictionary_id='49094.Lütfen CVV Numarası İçin Bir Nümerik Değer Giriniz'> !</cfsavecontent>
                                    <cf_input_pcKlavye name="cvv_no" value="#c_cvs#" type="text" numpad="true" accessible="true" maxlength="3" inputStyle="width:57px;" message="#msg#" required="yes" validate="integer" onKeyUp="isNumber(this);">
                                <cfelse>
                                    <cf_input_pcKlavye name="cvv_no" value="#c_cvs#" type="text" numpad="true" accessible="true" maxlength="3" inputStyle="width:57px;" validate="integer" onKeyUp="isNumber(this);">
                                </cfif>
                                </cfif>
                                    <span class="input-group-addon no-bg"></span>
                                <cfif isdefined('attributes.member_id') and len(attributes.member_id) and len(cc_number)>
                                    <select name="exp_month" id="exp_month" disabled="disabled">
                                        <cfloop from="1" to="12" index="k">
                                        <cfoutput><option value="#k#" <cfif k eq c_ex_m>selected</cfif>>#k#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                    <select name="exp_year" id="exp_year" disabled="disabled">
                                        <cfloop from="#dateFormat(now(),'yyyy')-2#" to="#dateFormat(now(),'yyyy')+10#" index="i">
                                            <cfoutput><option value="#i#" <cfif i eq c_ex_y>selected</cfif>>#i#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                    <input type="hidden" name="exp_month" id="exp_month" value="<cfoutput>#c_ex_m#</cfoutput>" />
                                    <input type="hidden" name="exp_year" id="exp_year" value="<cfoutput>#c_ex_y#</cfoutput>" />
                                <cfelse>
                                    <select name="exp_month" id="exp_month">
                                    <cfloop from="1" to="12" index="k">
                                        <cfoutput><option value="#k#" <cfif k eq c_ex_m>selected</cfif>>#k#</option></cfoutput>
                                    </cfloop>
                                    </select>
                                    <span class="input-group-addon no-bg"></span>
                                    <select name="exp_year" id="exp_year">
                                        <cfloop from="#dateFormat(now(),'yyyy')-2#" to="#dateFormat(now(),'yyyy')+10#" index="i">
                                            <cfoutput><option value="#i#" <cfif i eq c_ex_y>selected</cfif>>#i#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    </cfif>
                    <div id="joker_info" style="display:none;">
                        <label class="col col-4 col-xs-12"></label>
                        <div class="col col-8 col-xs-12">
                            <input name="joker_vada" id="joker_vada" type="checkbox"><cf_get_lang dictionary_id='49021.Joker Vada Kullanmak İstiyorum'>
                        </div>
                    </div>
                    <div class="form-group" id="item-action_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main dictionary_id='29535.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" value="#dateformat(now(),dateformat_style)#" readonly="yes" onblur="change_money_info('add_online_pos','action_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>                         
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_number" value="#paper_code & '-' & paper_number#">                               
                        </div>
                    </div>                         
                    <div class="form-group" id="item-sales_credit_comm">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                        <!---<cfsavecontent variable="message1"><cfoutput>#getLang('main',1738)#</cfoutput></cfsavecontent>--->
                            <cfif readonly_info>
                                <cfinput type="text" name="sales_credit_comm" class="moneybox" value="#TLFormat(main_act_value)#" onBlur="change_comm_value();" readonly>
                            <cfelse>
                                <cfinput type="text" name="sales_credit_comm" class="moneybox" value="#TLFormat(main_act_value)#" onBlur="change_comm_value();">
                            </cfif>
                        </div>
                    </div> 
                    <div class="form-group" id="item-sales_credit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48937.Komisyonlu Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='48744.Miktar giriniz'></cfsavecontent>
                            <cfif readonly_info>
                                <cfinput type="text" name="sales_credit" class="moneybox" readonly required="yes" message="#message#" value="" onBlur="kur_ekle_f_hesapla('action_to_account_id');"  onkeyup="return(FormatCurrency(this,event));"> 
                            <cfelse>
                                <cfinput type="text" name="sales_credit" class="moneybox" required="yes" message="#message#" value="#TLFormat(main_act_value)#" onBlur="kur_ekle_f_hesapla('action_to_account_id');"  onkeyup="return(FormatCurrency(this,event));"> 
                            </cfif>
                        </div>
                    </div>                         
                    <div class="form-group" id="item-other_value_sales_credit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif readonly_info>
                                <cfinput type="text" name="other_value_sales_credit" readonly class="moneybox" value="" onBlur="kur_ekle_f_hesapla('action_to_account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="other_value_sales_credit" class="moneybox" value="" onBlur="kur_ekle_f_hesapla('action_to_account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                            </cfif>
                        </div>
                    </div>                                               
                    <div class="form-group" id="item-action_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="action_detail" id="action_detail"></textarea>
                        </div>
                    </div>
                    <cfif isdefined('get_invoice_payment_id') and get_invoice_payment_id.recordcount and get_invoice_payment_id.CREDITCARD_PAYMENT_ID neq 0>
                    <div class="row" type="row">
                        <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="false">                       
                            <div class="form-group" id="item-">
                                <div class="col col-12">
                                    <label><font color="red"><b><cf_get_lang dictionary_id="56611.Tahsil Edilmiş Faturalar Bulunmaktadır">. <cf_get_lang dictionary_id="364.Lütfen Kontrol Ediniz">!</b></font></label>
                                </div>
                            </div>
                        </div>
                    </div>
                    </cfif>
                    </div>
                <div class="col col-4 col-md-4 col-sm-3 col-xs-12 scrollContent scroll-x2" type="column" index="2" sort="false">
                    <div class="form-group"> <label class="bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label></div>
                    <div class="form-group">                      
                        <div class="col col-12">
                            <cfscript>f_kur_ekle(process_type:0,base_value:'sales_credit',other_money_value:'other_value_sales_credit',form_name:'add_online_pos',select_input:'action_to_account_id');</cfscript>
                        </div>
                    </div>
                </div>  
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='49022.Online Tahsilat İşlemi Yapılacaktır,Devam Etmek İstiyormusunuz'></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()' insert_alert='#message#'>
                </div>  
            </cf_box_footer>  
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    <cfif use_https>
        window.defaultStatus="<cf_get_lang dictionary_id='49023.Bu sayfada SSL Kullanılmaktadır'>."
    </cfif>
    function change_comm_value()
    {
        var commission_acc_code = list_getat(document.getElementById('action_to_account_id').value,8,';');
        var payment_rate = list_getat(document.getElementById('action_to_account_id').value,6,';');
        var currency_id = list_getat(document.getElementById('action_to_account_id').value,2,';');
        if(commission_acc_code != "" && payment_rate != "" && payment_rate != 0 && document.getElementById('sales_credit_comm').value != "" && currency_id != "")
            document.getElementById('sales_credit').value = commaSplit(parseFloat(filterNum(document.getElementById('sales_credit_comm').value)) + (parseFloat(filterNum(document.getElementById('sales_credit_comm').value)) * (parseFloat(payment_rate)/100)));
        else
            document.getElementById('sales_credit').value = document.getElementById('sales_credit_comm').value;
        kur_ekle_f_hesapla('action_to_account_id');
    }
    function get_member_card()
    {
        <cfif x_select_credit_card eq 1>
            if(document.getElementById('member_card_id') != undefined && (document.getElementById('comp_name').value != ''&& (document.getElementById('action_from_company_id').value != '' || document.getElementById('cons_id').value != '')))
            {
                if(document.getElementById('action_from_company_id').value != '')
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.emptypopup_get_credit_card&x_select_active_cards=#x_select_active_cards#</cfoutput>&company_id='+document.getElementById('action_from_company_id').value ,'bank_list',1);	
                else
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.emptypopup_get_credit_card&x_select_active_cards=#x_select_active_cards#</cfoutput>&consumer_id='+document.getElementById('cons_id').value ,'bank_list',1);	
            }
        </cfif>
    }
    function gizle_goster(joker_inf)
    {
        pos_type = joker_inf.split(';')[6];//pos type i alır,Yapıkredide işlem olur sadece
        if(pos_type == 9 && joker_inf.split(';')[4] != undefined && joker_inf.split(';')[4] > 0)//ve taksitli işlemse
        {
            joker_info.style.display='';
            document.add_online_pos.joker_vada.checked = true;//joker vada gelsin
        }
        else
        {
            joker_info.style.display='none';
            document.add_online_pos.joker_vada.checked = false;
        }
    }
    function kontrol()
    {	
        if(!$("#action_to_account_id").val().length)
        {
            alertObject({message: "<cfoutput>#getLang('bank',370)#</cfoutput>"})    
            return false;
        }
        if(!$("#process_cat").val().length)
        {
            alertObject({message: "<cfoutput>#getLang('stock',323)#</cfoutput>"})    
            return false;
        }
        if(!$("#comp_name").val().length)
        {
            alertObject({message: "<cfoutput><cf_get_lang dictionary_id='48665.cari hesap girmelisini'></cfoutput>"})    
            return false;
        }
        if(!$("#action_date").val().length)
        {
            alertObject({message: "<cfoutput><cf_get_lang_main dictionary_id='58503.Lutfen Tarih Giriniz'></cfoutput>"})    
            return false;
        }
        if(document.getElementById('sales_credit_comm').value.length===0)
        {
            alertObject({message: "<cfoutput>#getLang('main',1738)#</cfoutput>"})    
            return false;
        }
        
        if (!chk_process_cat('add_online_pos')) return false;
        if(!check_display_files('add_online_pos')) return false;
        if(!chk_period(document.add_online_pos.action_date, 'İşlem')) return false;
        if(!paper_control(add_online_pos.paper_number,'CREDITCARD_REVENUE','1','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
        
        x = document.add_online_pos.action_to_account_id.selectedIndex;
        if (document.add_online_pos.action_to_account_id[x].value == "")
        { 
            alert ("<cf_get_lang dictionary_id='48838.Banka Hesap Kodunu Seçiniz'>!");
            return false;
        }
        
        <cfif x_cvv_requerid eq 1>
            if(document.add_online_pos.card_no.value != "")
            {
                if(document.add_online_pos.cvv_no.value == "")
                {
                    alert("<cf_get_lang dictionary_id='48867.CVV Numarası Giriniz'>!");
                    return false;
                }
            }
        </cfif>
        /* kredi kartı abonede seçilmemisse zorunlu kilar */
        if(document.getElementById("member_card_id") != undefined && document.getElementById("member_card_id").value == '')
        {
            alert("<cf_get_lang dictionary_id='48862.Lütfen Kredi Kartı Seçiniz'>!");
            return false;		
        }
        
        if(document.add_online_pos.sales_credit.value == 0 || document.add_online_pos.sales_credit.value == "")	
        {
            alert("<cf_get_lang_main dictionary_id='29535.Lutfen Tutar Giriniz'>");
            return false;
        }
        
        d = new Date();
        if(document.getElementById("exp_year").value < d.getFullYear())
        {
            alert("<cf_get_lang dictionary_id='49024.Geçerlilik Tarihi Bu Dönemden Küçük Olamaz'>!");
            return false;
        }
        return true;
    }
    kur_ekle_f_hesapla('action_to_account_id');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
