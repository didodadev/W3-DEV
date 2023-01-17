<!---
    File: bank_actions.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 15.10.2018
    Controller: WodibaBankActionsController.cfm
    Description:
        WoDiBa banka işlemlerinin listelendiği ve kayıt edildiği ekrandır.
        
        21	İşlem (Para Yatırma)
        22	İşlem (Para Çekme)
        23	Virman
        24	Gelen Havale
        25	Giden Havale
        120	Harcama Fişi
        121	Gelir Fişi
        243	Kredi Kartı Hesaba Geçiş
        244	Kredi Kartı Borcu Ödeme
        247	Kredi Kartı Hesaba Geçiş İptal
        248	Kredi Kartı Borcu Ödeme İptal
        291	Kredi Ödemesi
        292	Kredi Tahsilatı
        1043	Çek İşlemi Tahsil Bankaya
        1044	Çek İşlemi Ödeme Bankadan
        1051	Senet İşlemi Ödeme Bankadan
        1053	Senet İşlemi Tahsil Bankaya
        2501	Çek/Senet Banka Ödeme
--->
<style>.fa-angle-down{cursor:pointer;}.activeTr{background:#f5f5f5;}.flagTrue{color:green;}.flagFalse{color:red;}.flagWarning{color:orange;}</style>
<cf_get_lang_set module_name="bank">

    <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions">
    <cfif isDefined('attributes.date1') and isdate(attributes.date1)>
        <cfset adres = '#adres#&date1=#attributes.date1#'>
    </cfif>
    <cfif isDefined('attributes.date2') and isdate(attributes.date2)>
        <cfset adres = '#adres#&date2=#attributes.date2#'>
    </cfif>
    <cfif isDefined('attributes.page_action_type')>
        <cfset adres = '#adres#&page_action_type=#attributes.page_action_type#'>
    </cfif>
    <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
        <cfset adres = '#adres#&keyword=#attributes.keyword#'>
    </cfif>
    <cfif isDefined('attributes.islemkodu') and len(attributes.islemkodu)>
        <cfset adres = '#adres#&islemkodu=#attributes.islemkodu#'>
    </cfif>
    <cfif isDefined('attributes.account')>
        <cfset adres = '#adres#&account=#attributes.account#'>
    </cfif>
    <cfif isDefined('attributes.oby') and len(attributes.oby)>
        <cfset adres = '#adres#&oby=#attributes.oby#'>
    </cfif>
    <cfif isDefined('attributes.in_out') and len(attributes.in_out)>
        <cfset adres = '#adres#&in_out=#attributes.in_out#'>
    </cfif>
    <cfif isdefined('attributes.form_submitted') and len(attributes.form_submitted)>
        <cfset adres = adres&"&form_submitted=1" />
    </cfif>
    <cfif isdefined('attributes.record_status') and len(attributes.record_status)>
        <cfset adres = adres&"&record_status=#attributes.record_status#" />
    </cfif>
    <cfif isdefined('attributes.bank_code') and len(attributes.bank_code)>
        <cfset adres = adres&"&bank_code=#attributes.bank_code#" />
    </cfif>
    <cfif isdefined('attributes.min_amount') and len(attributes.min_amount)>
        <cfset adres = adres&"&min_amount=#attributes.min_amount#" />
    </cfif>
    <cfif isdefined('attributes.max_amount') and len(attributes.max_amount)>
        <cfset adres = adres&"&max_amount=#attributes.max_amount#" />
    </cfif>
    
    <cfparam name="attributes.search_id" default="" />
    <cfparam name="attributes.search_name" default="" />
    <cfparam name="attributes.search_type" default="" />
    <cfparam name="attributes.emp_type" default="" />
    <cfparam name="attributes.emp_name" default="" />
    <cfparam name="attributes.emp_id" default="" />
    <cfparam name="attributes.record_emp_id" default="" />
    <cfparam name="attributes.record_emp_name" default="" />
    <cfparam name="attributes.date1" default="" />
    <cfparam name="attributes.date2" default="" />
    <cfparam name="attributes.oby" default="1" />
    <cfparam name="attributes.action_bank" default="2" />
    <cfparam name="attributes.project_head" default="" />
    <cfparam name="attributes.project_id" default="" />
    <cfparam name="attributes.keyword" default="" />
    <cfparam name="attributes.page_action_type" default="" />
    <cfparam name="attributes.in_out" default="0" />
    <cfparam name="attributes.account" default="" />
    <cfparam name="attributes.record_status" default="" />
    <cfparam name="attributes.page" default=1 />
    <cfparam name="attributes.startrow" default=1 />
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#' />
    <cfparam name="attributes.bank_code" default="" />
    <cfparam name="attributes.max_amount" default="" />
    <cfparam name="attributes.min_amount" default="" />
    <cfparam name="attributes.islemkodu" default=""/>
    
    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
        SELECT
            ACCOUNT_ID,
        <cfif session.ep.period_year lt 2009>
            CASE WHEN(ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
        <cfelse>
            ACCOUNT_CURRENCY_ID,
        </cfif>
            ACCOUNT_NAME
        FROM
            ACCOUNTS
        WHERE
			ACCOUNT_STATUS = 1
        ORDER BY
            ACCOUNT_NAME
    </cfquery>
    
    <cfset cat_list = '21,22,23,24,25,120,121,243,244,247,248,291,292,1043,1044,1051,1053,2501' />
    <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#cat_list#) ORDER BY PROCESS_TYPE
    </cfquery>
    
    <cfquery name="get_bank_names" datasource="#dsn#">
        SELECT BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
    </cfquery>
    
    <cfscript>
        if(Not isDefined('attributes.date1')){
            attributes.date1 = '';
        }
        else{
            attributes.date1 = dateFormat(attributes.date1,dateformat_style);
        }
        if(Not isDefined('attributes.date2')){
            attributes.date2 = '';
        }
        else{
            attributes.date2 = dateFormat(attributes.date2,dateformat_style);
        }
    </cfscript>
    <cfif isDefined("attributes.form_submitted")>
        <cfif isdefined("attributes.page_action_type") And Len(attributes.page_action_type)>
            <cfquery name="get_transaction_codes" datasource="#dsn#">
                SELECT TRANSACTION_CODE FROM WODIBA_BANK_TRANSACTION_TYPES WHERE PROCESS_TYPE = #listFirst(attributes.page_action_type,'-')#
                    UNION ALL
                SELECT TRANSACTION_CODE2 FROM WODIBA_BANK_TRANSACTION_TYPES WHERE PROCESS_TYPE = #listFirst(attributes.page_action_type,'-')#
            </cfquery>
        </cfif>
        <cfquery name="get_bank_actions" datasource="#dsn#">
            SELECT
                WBA.WDB_ACTION_ID,
                WBA.ACCOUNT_ID,
                WBA.PERIOD_ID,
                WBA.BANK_ACTION_ID,
                WBA.DOCUMENT_ID,
                WBA.UID,
                WBA.BANKAKODU,
                WBA.HESAPNO,
                WBA.MUSTERINO,
                WBA.SUBEKODU,
                WBA.TARIH,
                WBA.ISL_ID,
                WBA.DEKONTNO,
                WBA.MIKTAR,
                WBA.DOVIZTURU,
                WBA.ACIKLAMA,
                WBA.KARSIVKN,
                WBA.KARSIIBAN,
                ISNULL(wba.ISLEMKODU,0) AS ISLEMKODU
            FROM
                WODIBA_BANK_ACTIONS AS WBA
            WHERE
                WBA.ACCOUNT_ID <> 0
                AND WBA.MIKTAR <> 0
                AND WBA.PERIOD_ID = #session.ep.period_id#
                <cfif Len(attributes.keyword)>
                AND (
                        WBA.DEKONTNO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        OR WBA.ACIKLAMA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        OR WBA.KARSIIBAN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        OR WBA.KARSIVKN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        
                    )
                </cfif>
                <cfif Len(attributes.islemkodu)>
                    AND (WBA.ISLEMKODU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.islemkodu#">)
                </cfif>
                <cfif isdefined("attributes.min_amount") And Len(attributes.min_amount)>
                AND  abs(WBA.MIKTAR) >= abs(<cfqueryparam cfsqltype="cf_sql_integer" value="#replace(attributes.min_amount,".","")#">)
                </cfif>
                <cfif isdefined("attributes.max_amount") And Len(attributes.max_amount)>
                AND  abs(WBA.MIKTAR) <= abs(<cfqueryparam cfsqltype="cf_sql_integer" value="#replace(attributes.max_amount,".","")#">)
                </cfif>
                <cfif isdefined("attributes.page_action_type") And Len(attributes.page_action_type)>
                AND WBA.ISLEMKODU IN(#quotedValueList(get_transaction_codes.TRANSACTION_CODE)#)
                AND LEN(WBA.ISLEMKODU) > 0
                </cfif>
                <cfif attributes.in_out Neq 0>
                    <cfif attributes.in_out Eq 1>
                    AND WBA.MIKTAR > 0
                    <cfelse>
                    AND WBA.MIKTAR < 0
                    </cfif>
                </cfif>
                <cfif Len(attributes.account)>
                AND WBA.ACCOUNT_ID = #attributes.account#
                </cfif>
                <cfif len(attributes.date1)>
                    AND WBA.TARIH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif len(attributes.date2)>
                    AND WBA.TARIH <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                <cfif Len(attributes.record_status) And attributes.record_status Eq 1>
                    AND WBA.BANK_ACTION_ID IS NOT NULL
                <cfelseif Len(attributes.record_status) And attributes.record_status Eq 2>
                    AND WBA.BANK_ACTION_ID IS NULL
                </cfif>
                <cfif isdefined("attributes.bank_code") And Len(attributes.bank_code)>
                    AND WBA.BANKAKODU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_code#">
                </cfif>
            ORDER BY
                <cfif attributes.oby Eq 1>
                WBA.TARIH DESC
                <cfelseif attributes.oby Eq 2>
                WBA.TARIH ASC
                <cfelse>
                WBA.ISLEMKODU
                </cfif>
        </cfquery>
    
        <cfscript>
            include "../cfc/Functions.cfc";
            attributes.totalrecords  = get_bank_actions.RecordCount;
            attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
            attributes.endrow = attributes.startrow + attributes.maxrows - 1;
            if(attributes.totalrecords lt attributes.endrow){
                attributes.endrow = attributes.totalrecords;
            }
        </cfscript>
    <cfelse>
        <cfset attributes.totalrecords  = 0 />
    </cfif>
	<cfform name="bank_action_list" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions" method="POST">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
		<cf_box>
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<div class="input-group x-15">
							<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#" onclick="select();">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="islemkodu" id="islemkodu" style="width:80px;" value="#attributes.islemkodu#" maxlength="50" placeholder="#getLang(48886)#" onclick="select();">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group x-10">
							<select name="oby" id="oby">
								<option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
								<option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
								<option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang no='225.İşlem kodu'></option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group x-4_5">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button>
						<a href="<cfoutput>#request.self#?fuseaction=bank.wodiba_bank_actions&event=dashboard</cfoutput>" target="_blank">&nbsp; <i class="fa fa-dashboard" style="font-size: 23px; margin-left:6px; color: black;" title="<cf_get_lang dictionary_id='63588.Dashboard'>"></i></a>
						<a href="<cfoutput>#request.self#?fuseaction=bank.wodiba_bank_actions&event=history</cfoutput>" target="_blank">&nbsp;<i class="fa fa-history" style="font-size: 23px; margin-left:8px; color: black;" title="<cf_get_lang dictionary_id='61102.İşlem Geçmişi'>"></i></a>
						<a href="<cfoutput>#request.self#?fuseaction=bank.wodiba_bank_actions&event=logs</cfoutput>" target="_blank">&nbsp;<i class="fa fa-list-alt" style="font-size: 23px; margin-left:8px; margin-top:1px; color: black;" title="<cf_get_lang dictionary_id='61330.Log Records'>"></i></a>
					</div>
				</cfoutput>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="row" type="row">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-in_out">
							<label class="col col-12"><cf_get_lang_main no='142.Giriş'>/<cf_get_lang_main no='19.Çıkış'></label>
							<div class="col col-12">
								<select name="in_out" id="in_out">
									<option value="0"><cf_get_lang_main no='142.Giriş'>/<cf_get_lang_main no='19.Çıkış'></option>
									<option value="1"<cfif isDefined("attributes.in_out") and (attributes.in_out eq 1)> selected</cfif>><cf_get_lang_main no='142.Giriş'></option>
									<option value="2"<cfif isDefined("attributes.in_out") and (attributes.in_out eq 2)> selected</cfif>><cf_get_lang_main no='19.Çıkış'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-page_action_type">
							<label class="col col-12"><cf_get_lang_main no='388.İşlem Tipi'></label>
							<div class="col col-12">
								<select name="page_action_type" id="page_action_type" style="width:225px;">
									<option value="" selected><cf_get_lang_main no='388.İşlem Tipi'></option>
									<cfoutput query="get_process_cat" group="process_type">
										<option value="#process_type#-0" <cfif isdefined("attributes.page_action_type") and ('#process_type#-0' is attributes.page_action_type)> selected</cfif>>#get_process_name(process_type)#</option>										
										<cfoutput>
											<option value="#process_type#-#process_cat_id#" <cfif isdefined("attributes.page_action_type") and (attributes.page_action_type is '#process_type#-#process_cat_id#')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-account">
							<label class="col col-12"><cf_get_lang_main no='240.Hesap'></label>
							<div class="col col-12">
								<select name="account" id="account" style="width:225px">
									<option value=""><cf_get_lang_main no='240.Hesap'></option>
									<cfoutput query="get_accounts">
										<option value="#account_id#" <cfif isDefined("attributes.account") and attributes.account eq get_accounts.account_id>selected</cfif>>#account_name#-#account_currency_id#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-emp_type">
							<label class="col col-12"><cf_get_lang_main no='107.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="emp_type" id="emp_type" value="<cfif len(attributes.emp_type)><cfoutput>#attributes.emp_type#</cfoutput></cfif>">
									<input type="hidden" name="emp_id" id="emp_id" value="<cfif len(attributes.emp_id)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
									<input type="hidden" name="search_type" id="search_type" value="<cfif len(attributes.search_type)><cfoutput>#attributes.search_type#</cfoutput></cfif>">
									<input type="hidden" name="search_id" id="search_id"  value="<cfif len(attributes.search_id)><cfoutput>#attributes.search_id#</cfoutput></cfif>">
									<input type="text" name="emp_name" id="emp_name" style="width:120px;"  onClick="hesap_sec();" value="<cfif len(attributes.emp_name)><cfoutput>#attributes.emp_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','MEMBER_TYPE,EMPLOYEE_ID,MEMBER_ID','search_type,emp_id,search_id','','3','135');">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_name=bank_action_list.emp_name&field_comp_id=bank_action_list.search_id&field_emp_id=bank_action_list.emp_id&field_type=bank_action_list.search_type&field_consumer=bank_action_list.search_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9,2,3');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-project_id">
							<label class="col col-12"><cf_get_lang_main no='4.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
									<input type="text" name="project_head" id="project_head" style="width:145px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-record_status">
							<label class="col col-12"><cf_get_lang_main no='344.Durum'></label>
							<div class="col col-12">
								<select name="record_status" id="record_status">
									<option value="0"><cf_get_lang_main no='344.Durum'></option>
									<option value="1"<cfif isDefined("attributes.record_status") and (attributes.record_status eq 1)> selected</cfif>>Kayıt Edildi</option>
									<option value="2"<cfif isDefined("attributes.record_status") and (attributes.record_status eq 2)> selected</cfif>>Kayıt Edilmedi</option>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-bank_code">
							<label class="col col-12"><cf_get_lang no='34.Banka Adı'></label>
							<div class="col col-12">
								<select name="bank_code" id="bank_code" style="width:150px;">
									<option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>  
									<cfoutput query="get_bank_names">
										<option <cfif isdefined('attributes.bank_code') and attributes.bank_code eq BANK_CODE>selected</cfif> value="#BANK_CODE#">#bank_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-date1">
							<label class="col col-12"><cf_get_lang_main no='467.İşlem Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
									<cfinput type="text" maxlength="10" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
									<cfinput type="text" maxlength="10" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-date1">
							<label class="col col-12" for="min_amount"><cf_get_lang dictionary_id='40460.Tutar Aralığı'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="text" name="min_amount" id="min_amount" class="moneybox" placeholder="min" onkeyup="return(FormatCurrency(this,event));" value="<cfif len(attributes.min_amount)><cfoutput>#attributes.min_amount#</cfoutput></cfif>">
									<span class="input-group-addon no-bg"></span>
									<input type="text" name="max_amount" id="max_amount" class="moneybox" placeholder="max"onkeyup="return(FormatCurrency(this,event));" value="<cfif len(attributes.max_amount)><cfoutput>#attributes.max_amount#</cfoutput></cfif>">  
								</div>
							</div>
						</div>
	
					</div>
				</div>
			</cf_box_search_detail>
		</cf_box>
	</cfform>
	<cf_box title="#ListGetAt(lang_array_all.item[48852],1,'█')#" >
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no='1165.Sıra'></th>
					<th><cf_get_lang_main no='240.Hesap'></th>
					<th><cf_get_lang no='225.İşlem Kodu'></th>
					<th><cf_get_lang_main no='1166.Belge Türü'></th>
					<th><cf_get_lang_main no='650.Dekont'></th>
					<th><cf_get_lang_main no='330.Tarih'></th>
					<th><cf_get_lang_main no='217.Açıklama'></th>
					<th><cf_get_lang_main no='107.Cari hesap'></th>
					<th>IBAN</th>
					<th>VKN</th>
					<th><cf_get_lang_main no='261.Tutar'></th>
					<th>PB</th>
					<th><cf_get_lang_main no='344.Durum'></th>
				<!---  <th>Log</th> --->
					<th>&nbsp;</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfif isDefined("attributes.form_submitted") And get_bank_actions.RecordCount>
				<cfoutput>
				<cfloop query="get_bank_actions" startrow="#attributes.startrow#" endrow="#attributes.endrow#">
				<cfif Not Len(ISLEMKODU)><cfset ISLEMKODU = 0 /></cfif><!--- İşlem kodu gelmeyen hareketler için --->
				<cfif MIKTAR Gt 0><cfset in_out = 'IN' /><cfelse><cfset in_out = 'OUT' /></cfif>
				<cfset get_process_type = GetProcessType(BankCode=GetAccountInfo(AccountId=ACCOUNT_ID).BANK_CODE, TransactionCode=ISLEMKODU, InOut=in_out, WDB_ACTION_ID=WDB_ACTION_ID, BANK_ACTION_ID=BANK_ACTION_ID, DOCUMENT_ID=DOCUMENT_ID) />
				<cfscript>
					action_value    = replace(MIKTAR, "-", "");
					action_date     = dateFormat(TARIH,"dd.mm.YYYY");
		
					switch (get_process_type.PROCESS_TYPE){
						case '21'://Para yatırma işlemi
							action_edit_addrr   = 'bank.form_add_invest_money&event=upd&id=';
							action_save_addrr   = 'bank.form_add_invest_money';
							window_size         = 'medium';
						break;
		
						case '22'://Para çekme işlemi
							action_edit_addrr   = 'bank.form_add_get_money&event=upd&id=';
							action_save_addrr   = 'bank.form_add_get_money';
							window_size         = 'medium';
						break;
		
						case '23'://Döviz Alış Satış Virman İşlemi
							action_edit_addrr   = 'bank.form_add_virman&event=upd&id=';
							action_save_addrr   = 'bank.form_add_virman';
							window_size         = 'medium';
						break;
						
						case '24'://Gelen havale
							action_edit_addrr   = 'bank.form_add_gelenh&event=upd&id=';
							action_save_addrr   = 'bank.form_add_gelenh&paper_number=#DEKONTNO#&account_id=#ACCOUNT_ID#&action_value=#action_value#&action_date=#action_date#&action_currency=#DOVIZTURU#';
							window_size         = 'project';
						break;
		
						case '25'://Giden havale
							action_edit_addrr   = 'bank.form_add_gidenh&event=upd&id=';
							action_save_addrr   = 'bank.form_add_gidenh&paper_number=#DEKONTNO#&account_id=#ACCOUNT_ID#&action_value=#action_value#&action_date=#action_date#&action_currency=#DOVIZTURU#';
							window_size         = 'project';
						break;
		
						case '120'://Masraf fişi
							action_edit_addrr   = 'cost.form_add_expense_cost&event=upd&expense_id=';
							action_save_addrr   = 'cost.form_add_expense_cost';
							window_size         = 'wwide';
						break;
		
						case '121'://Gelir fişi
							action_edit_addrr   = 'cost.add_income_cost&event=upd&expense_id=';
							action_save_addrr   = 'cost.add_income_cost';
							window_size         = 'wwide';
						break;
						
						case '243'://Kredi Kartı Hesaba Geçiş
							action_edit_addrr   = 'bank.popup_upd_bank_cc_payment&id=';
							action_save_addrr   = 'bank.list_payment_credit_cards&event=add';
							window_size         = 'medium';
						break;
						
						case '244'://Kredi Kartı Borcu Ödeme
							action_edit_addrr   = 'bank.list_credit_card_expense&event=updDebit&id=';
							action_save_addrr   = 'bank.list_credit_card_expense&event=addDebit&x_interim_payments=1&process_type=244&exp_count=0&cc_info=1';
							window_size         = 'medium';
						break;
						
						case '247'://Kredi Kartı Hesaba Geçiş İptal
							action_edit_addrr   = '';
							action_save_addrr   = '';
							window_size         = 'medium';
						break;
						
						case '248'://Kredi Kartı Borcu Ödeme İptal
							action_edit_addrr   = '';
							action_save_addrr   = '';
							window_size         = 'medium';
						break;
						
						case '291'://Kredi Ödemesi
							action_edit_addrr   = 'credit.popup_dsp_credit_payment&action_id=';
							action_save_addrr   = 'credit.list_credit_contract&event=addPayment&credit_contract_id=1&project_id=-1';
							window_size         = 'medium';
						break;
						
						case '292'://Kredi Tahsilatı
							action_edit_addrr   = 'credit.popup_dsp_credit_payment&action_id=';
							action_save_addrr   = 'credit.list_credit_contract&event=addRevenue&credit_contract_id=1&project_id=-1';
							window_size         = 'medium';
						break;
						
						case '1043'://Çek İşlemi Tahsil Bankaya
							action_edit_addrr   = '';
							action_save_addrr   = '';
							window_size         = 'medium';
						break;
						
						case '1044'://Çek İşlemi Ödeme Bankadan
							action_edit_addrr   = 'ch.popup_check_preview&id=';
							action_save_addrr   = '';
							window_size         = 'small';
						break;
						
						case '1051'://Senet İşlemi Ödeme Bankadan
							action_edit_addrr   = '';
							action_save_addrr   = '';
							window_size         = 'medium';
						break;
						
						case '1053'://Senet İşlemi Tahsil Bankaya
							action_edit_addrr   = '';
							action_save_addrr   = '';
							window_size         = 'medium';
						break;
						
						case '2501'://Çek/Senet Banka Ödeme
							action_edit_addrr   = '';
							action_save_addrr   = '';
							window_size         = 'medium';
						break;
		
						default:
							action_edit_addrr   = 'bank.wodiba_bank_actions';
							action_save_addrr   = 'bank.wodiba_bank_actions';
							window_size         = 'medium';
					}
				</cfscript>
				<cfquery name="GET_RULE_ID" datasource="#dsn#">
					SELECT
						RULE_ID
					FROM
						WODIBA_RULE_SETS
					WHERE
						PROCESS_TYPE = '#get_process_type.PROCESS_TYPE#' AND
						PROCESS_TYPE IN (21,22,23,24,25,120,121,243,244,247,248,291,292,1043,1044,1051,1053,2501)
				</cfquery>
				<tr>
					<td>#CurrentRow#</td>
					<td nowrap="nowrap">#GetAccountInfo(AccountId=ACCOUNT_ID).ACCOUNT_NAME#</td>
					<td>#ISLEMKODU#</td>
					<td>#get_process_type.PROCESS_CAT#</td>
					<td>
						<cfif Len(BANK_ACTION_ID) And Len(DOCUMENT_ID) And Len(get_process_type.PROCESS_TYPE)>
							<a href="#request.self#?fuseaction=#action_edit_addrr##DOCUMENT_ID#" target="_blank" class="tableyazi">#DEKONTNO#</a>
						<cfelseif Len(BANK_ACTION_ID) And Len(DOCUMENT_ID) And Not Len(get_process_type.PROCESS_TYPE)>
							<a href="javascript:(alert('<cf_get_lang dictionary_id='35224.Kayıt Silinmiş Olabilir Detayı Gösterilemiyor'>'));" class="tableyazi">#DEKONTNO#</a><cfif session.ep.ADMIN Eq 1> <a href="javascript:void(0);" onclick="if (confirm('<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>')) windowopen('#request.self#?fuseaction=bank.wodiba_bank_actions&event=delcon&id=#WDB_ACTION_ID#','small');" class="tableyazi"><img src="images/exit.gif" title="<cf_get_lang dictionary_id='34244.Bağlantı Sil'>" /></a></cfif>
						<cfelse>
							#DEKONTNO#
						</cfif>
					</td>
					<td nowrap="nowrap">#dateFormat(TARIH,"dd.mm.YYYY")# #timeFormat(TARIH,"HH:mm")#</td>
					<td><span title="#ACIKLAMA#">#Left(ACIKLAMA,60)#</span></td>
					<cfset member_name = '' />
					<cfset member_page = '' />
					<cfif Len(bank_action_id)>
						<cfquery name="get_action_member" datasource="#dsn2#">
							SELECT
								ISNULL(ACTION_FROM_COMPANY_ID,ACTION_TO_COMPANY_ID) AS COMPANY_ID,
								ISNULL(ACTION_FROM_CONSUMER_ID,ACTION_TO_CONSUMER_ID) AS CONSUMER_ID,
								ISNULL(ACTION_FROM_EMPLOYEE_ID,ACTION_TO_EMPLOYEE_ID) AS EMPLOYEE_ID
							FROM
								BANK_ACTIONS
							WHERE
								ACTION_ID = #BANK_ACTION_ID#
						</cfquery>
						<cfif Len(get_action_member.COMPANY_ID)>
							<cfquery name="get_member_detail" datasource="#dsn#">
								SELECT NICKNAME AS MEMBER_NAME FROM COMPANY WHERE COMPANY_ID = #get_action_member.COMPANY_ID#
							</cfquery>
							<cfset member_name = get_member_detail.MEMBER_NAME />
							<cfset member_page = 'objects.popup_com_det&company_id=#get_action_member.COMPANY_ID#' />
						<cfelseif Len(get_action_member.CONSUMER_ID)>
							<cfquery name="get_member_detail" datasource="#dsn#">
								SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID = #get_action_member.CONSUMER_ID#
							</cfquery>
							<cfset member_name = get_member_detail.MEMBER_NAME />
							<cfset member_page = 'objects.popup_con_det&con_id=#get_action_member.CONSUMER_ID#' />
						<cfelseif Len(get_action_member.EMPLOYEE_ID)>
							<cfquery name="get_member_detail" datasource="#dsn#">
								SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS MEMBER_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_action_member.EMPLOYEE_ID#
							</cfquery>
							<cfset member_name = get_member_detail.MEMBER_NAME />
							<cfset member_page = 'objects.popup_emp_det&emp_id=#get_action_member.EMPLOYEE_ID#' />
						</cfif>
					</cfif>
					<td><cfif Len(bank_action_id) And (Len(get_action_member.COMPANY_ID) Or Len(get_action_member.CONSUMER_ID) Or Len(get_action_member.EMPLOYEE_ID))><a href="javascript:openBoxDraggable('#request.self#?fuseaction=#member_page#','','ui-draggable-box-medium');">#member_name#</a></cfif></td>
					<td>#KARSIIBAN#</td>
					<td><cfif Len(KARSIVKN) Gt 1>#KARSIVKN#</cfif></td>
					<cfif DOVIZTURU Eq 'TRY'><cfset DOVIZTURU = 'TL' /><cfelse><cfset DOVIZTURU = DOVIZTURU /></cfif>
					<cfif Len(bank_action_id) And (Len(get_action_member.COMPANY_ID) Or Len(get_action_member.CONSUMER_ID))><cfset sensitive_label = 6 /><cfelse><cfset sensitive_label = 7 /></cfif>
					<td style="text-align:right;" nowrap="nowrap"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="#sensitive_label#" data="#TLFormat(MIKTAR)#"><cfif MIKTAR Gt 0>&nbsp;<i class="fa fa-caret-down" style="color:green;font-size:18px;"></i><cfelse><i class="fa fa-caret-up" style="color:red;font-size:18px;"></cfif></td>
					<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="#sensitive_label#" data="#DOVIZTURU#"></td>
					<td style="text-align:center;"><cfif Len(BANK_ACTION_ID)><i class="fa fa-2x fa-bookmark flagTrue"></i><cfelse><i class="fa fa-2x fa-bookmark flagFalse" onclick="openBoxDraggable('#request.self#?fuseaction=bank.wodiba_bank_actions&event=log_detail&id=#WDB_ACTION_ID#','','ui-draggable-box-medium');"></i></cfif></td>
					<!--- <td><a href="javascript:void(0);" title="Wodiba Log" onclick="cfmodal('#request.self#?fuseaction=bank.wodiba_bank_actions&event=log_detail&id=#WDB_ACTION_ID#','warning_modal');"><i class="catalyst-question" style="font-size:18px;"></i></a></td> --->
					<td><cfif Len(DOCUMENT_ID)><a href="#request.self#?fuseaction=#action_edit_addrr##DOCUMENT_ID#" target="_blank" class="tableyazi"><i class="fa fa-edit" style="font-size:18px;" title="<cf_get_lang_main no='1306.Düzenle'>"></i></a><cfelse><a href="javascript:void(0);" onclick="openBoxDraggable('#request.self#?fuseaction=bank.wodiba_bank_actions&event=add_action&id=#WDB_ACTION_ID#','','ui-draggable-box-medium');" class="tableyazi"><i class="fa fa-save" style="font-size:18px;" title="<cf_get_lang_main no='49.Kaydet'>"></i></a></cfif></td>
					<td><a href="javascript:openBoxDraggable('#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=add&id=#GET_RULE_ID.RULE_ID#&act_id=#WDB_ACTION_ID#','','ui-draggable-box-medium');"><i class="fa fa-magic" style="font-size:18px;" title="<cf_get_lang dictionary_id='48684.Kural Ekle'>"></i></a></td>    
				</tr>
				</cfloop>
				</cfoutput>
				<cfelse>
				<tr>
					<cfset colspan_info = 15>
					<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cfif isDefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isDefined('attributes.search_id') and len(attributes.search_id)>
			<cfset adres = '#adres#&search_id=#attributes.search_id#'>
		</cfif>
		<cfif isDefined('attributes.emp_id') and len(attributes.emp_id)>
			<cfset adres = '#adres#&emp_id=#attributes.emp_id#'>
		</cfif>
		<cfif isDefined('attributes.emp_name') and len(attributes.emp_name)>
			<cfset adres = '#adres#&emp_name=#attributes.emp_name#'>
		</cfif>
		<cfif isDefined('attributes.record_emp_name') and len(attributes.record_emp_name)>
			<cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
			<cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
		</cfif>
		<cfif isDefined('attributes.search_name') and len(attributes.search_name)>
			<cfset adres = '#adres#&search_name=#attributes.search_name#'>
		</cfif>
		<cfif isDefined ("attributes.date1")>
			<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#" />
		</cfif>
		<cfif isDefined ("attributes.date2")>
			<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#" />
		</cfif>
		<cfif isDefined('attributes.action_bank')>
			<cfset adres = '#adres#&action_bank=#attributes.action_bank#'>
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif len(attributes.project_head)>
			<cfset adres = "#adres#&project_head=#attributes.project_head#">
		</cfif>
		<cfif isDefined('attributes.search_type') and len(attributes.search_type)>
			<cfif attributes.search_type is 'employee'>
				<cfset attributes.emp_name = get_emp_info(emp_id,0,0)>
			</cfif>
			<cfif attributes.search_type is 'partner'>
				<cfset attributes.search_name = get_par_info(search_id,1,1,0)>
			<cfelseif attributes.search_type is 'consumer'>
				<cfset attributes.search_name = get_cons_info(search_id,0,0)> 
			</cfif>
			<cfset adres = '#adres#&search_type=#attributes.search_type#'>
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
	
    <script type="text/javascript" language="javascript">
        $('#keyword').select();
    </script>