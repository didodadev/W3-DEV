<cf_xml_page_edit fuseact="bank.list_assign_order" default_value="1">
<cfparam name="attributes.keyword_list" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date2" default="">
<cfparam name="attributes.finish_date2" default="">
<cfparam name="attributes.bank_order_type" default="">
<cfparam name="attributes.list_order_type" default="1">
<cfparam name="attributes.bank_action_date" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.file_status" default="">
<cfparam name="attributes.account_id_list" default="">
<cfparam name="attributes.is_havale" default="#xml_is_havale#">
<cfparam name="attributes.special_definition_id" default="">
<cfinclude template="../query/get_accounts.cfm">
<cfquery name="GET_MONEY" datasource="#DSN2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
	<cfset 'toplam_2_#money#' = 0>
</cfoutput>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date2") and isdate(attributes.finish_date2)>
	<cf_date tarih="attributes.finish_date2">
</cfif>
<cfif isdefined("attributes.start_date2") and isdate(attributes.start_date2)>
	<cf_date tarih="attributes.start_date2">
</cfif>
<cfif isdefined("attributes.bank_action_date") and isdate(attributes.bank_action_date)>
	<cf_date tarih="attributes.bank_action_date">
</cfif>
<cfif isdefined("attributes.form_varmi")>
<cfset attributes.acc_type_id = ''> 
<cfscript>
	if(isDefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
	<cfset arama_yapilmali = 0>
	<cfquery name="get_orders" datasource="#DSN2#">
		SELECT 
			BON.*,
            <!--- company --->
            C.MEMBER_CODE COMPANY_MEMBER_CODE,
            ISNULL(COMPANY_REMAINDER.BAKIYE,0) COMPANY_BAKIYE,
            <cfif xml_show_iban_no eq 1>
            	CB.COMPANY_IBAN_CODE AS COMPANY_IBAN_CODE,
            </cfif>
            <!--- consumer --->
            CR.MEMBER_CODE CONSUMER_MEMBER_CODE,
            ISNULL(CONSUMER_REMAINDER.BAKIYE,0) CONSUMER_BAKIYE,
            <cfif xml_show_iban_no eq 1>
            	CNB.CONSUMER_IBAN_CODE AS CONSUMER_IBAN_CODE,
            </cfif>
            <!--- employee --->
            EMP.MEMBER_CODE EMPLOYEE_MEMBER_CODE,
            ISNULL(EMPLOYEE_REMAINDER.BAKIYE,0) EMPLOYEE_BAKIYE,
            <!--- odeme yapan --->
            R_CP.COMPANY_PARTNER_NAME +' '+ R_CP.COMPANY_PARTNER_SURNAME RECORD_COMP_NAME,
            R_CR.CONSUMER_NAME +' '+ R_CR.CONSUMER_SURNAME RECORD_CONS_NAME,
            R_EMP.EMPLOYEE_NAME +' '+ R_EMP.EMPLOYEE_SURNAME RECORD_EMP_NAME,
        	<!--- temsilci --->
            <cfif xml_show_bsy>
            	EP.EMPLOYEE_NAME +' '+ EP.EMPLOYEE_SURNAME TEMSILCI,
		    </cfif>       
            PRO_PROJECTS.PROJECT_HEAD,
			A.ACCOUNT_NAME,
			A.ACCOUNT_NO
            <cfif xml_payment_type>
            	,SD.SPECIAL_DEFINITION
            </cfif>
		FROM 
			BANK_ORDERS BON
            	LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = BON.COMPANY_ID
                <cfif xml_show_iban_no eq 1><!--- iban numarası XML'e bagli gelir --->
                	LEFT JOIN #dsn_alias#.COMPANY_BANK CB ON CB.COMPANY_ID = BON.COMPANY_ID AND BON.ACTION_BANK_ACCOUNT = CB.COMPANY_BANK_ID
                    LEFT JOIN #dsn_alias#.CONSUMER_BANK CNB ON CNB.CONSUMER_ID = BON.CONSUMER_ID AND BON.ACTION_BANK_ACCOUNT = CNB.CONSUMER_BANK_ID
                </cfif>
                LEFT JOIN #dsn2_alias#.COMPANY_REMAINDER ON COMPANY_REMAINDER.COMPANY_ID = BON.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER CR ON CR.CONSUMER_ID = BON.CONSUMER_ID
                LEFT JOIN #dsn2_alias#.CONSUMER_REMAINDER ON CONSUMER_REMAINDER.CONSUMER_ID = BON.CONSUMER_ID
                <cfif xml_show_bsy><!--- temsilci XML'e bagli gelir --->
                	LEFT JOIN #dsn_alias#.WORKGROUP_EMP_PAR WEP ON WEP.CONSUMER_ID IS NOT NULL AND WEP.CONSUMER_ID = CR.CONSUMER_ID AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                	LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = WEP.POSITION_CODE AND EP.POSITION_STATUS = 1
                </cfif>
                LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = BON.EMPLOYEE_ID
                LEFT JOIN #dsn2_alias#.EMPLOYEE_REMAINDER ON  EMPLOYEE_REMAINDER.EMPLOYEE_ID = BON.EMPLOYEE_ID AND EMPLOYEE_REMAINDER.ACC_TYPE_ID = BON.ACC_TYPE_ID
                <!--- odeme yapan --->
            	LEFT JOIN #dsn_alias#.COMPANY_PARTNER R_CP ON R_CP.COMPANY_ID = BON.RECORD_PAR
                LEFT JOIN #dsn_alias#.CONSUMER R_CR ON R_CR.CONSUMER_ID = BON.RECORD_CONS
                LEFT JOIN #dsn_alias#.EMPLOYEES R_EMP ON R_EMP.EMPLOYEE_ID = BON.RECORD_EMP
                LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = BON.PROJECT_ID
                <cfif xml_payment_type>
                	LEFT JOIN #dsn_alias#.SETUP_SPECIAL_DEFINITION SD ON BON.SPECIAL_DEFINITION_ID=SD.SPECIAL_DEFINITION_ID
                </cfif>
			,#dsn3_alias#.ACCOUNTS AS A
		WHERE 		
			A.ACCOUNT_ID = BON.ACCOUNT_ID
			<cfif len(attributes.company) and len(attributes.company_id)>
                AND BON.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            <cfelseif len(attributes.company) and len(attributes.consumer_id)>
                AND BON.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            <cfelseif len(attributes.company) and len(attributes.employee_id)>
                AND BON.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            </cfif>
            <cfif len(attributes.acc_type_id)>
                AND BON.ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#">
            </cfif>
            <cfif isdefined("attributes.account_id_list") and len(attributes.account_id_list)>
                AND A.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.account_id_list,';')#">
            </cfif>
            <cfif len(attributes.keyword_list)>
                AND
                    (
                        BON.SERI_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_list#%"> OR
                        A.ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="<cfif len(attributes.keyword_list) gte 3>%</cfif>#attributes.keyword_list#%"> OR
                        (BON.FILE_EXPORT_ID IN (SELECT FI.E_ID FROM FILE_EXPORTS FI WHERE FI.E_ID = BON.FILE_EXPORT_ID AND FI.FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_list#%">))
                    )
            </cfif>
            <cfif attributes.is_havale eq 1>
                AND	BON.IS_PAID = 1
            <cfelseif attributes.is_havale eq 2>
                AND	(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
            </cfif>
            <cfif attributes.file_status eq 1>
                AND	BON.FILE_EXPORT_ID IS NOT NULL
            <cfelseif attributes.file_status eq 0>
                AND	BON.FILE_EXPORT_ID IS NULL
            </cfif>
            <cfif len(attributes.bank_order_type)>
                AND BON.BANK_ORDER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_order_type#">
            </cfif>
            <cfif isdate(attributes.start_date)>
                AND BON.PAYMENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            </cfif>
            <cfif isdate(attributes.finish_date)>
                AND BON.PAYMENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
            </cfif>
            <cfif isdate(attributes.start_date2)>
                AND BON.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date2#">
            </cfif>
            <cfif isdate(attributes.finish_date2)>
                AND BON.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date2#">
            </cfif>
            <cfif isdate(attributes.bank_action_date)>
                AND BON.BANK_ORDER_ID IN(SELECT BA.BANK_ORDER_ID FROM BANK_ACTIONS BA WHERE BA.ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.bank_action_date#"> AND BA.BANK_ORDER_ID IS NOT NULL)
            </cfif>
            <cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
                AND BON.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
            </cfif>
            <cfif isdefined('attributes.special_definition_id') and len(attributes.special_definition_id)>
            	AND BON.SPECIAL_DEFINITION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition_id#">
            </cfif>
            ORDER BY 
			<cfif isdefined("attributes.list_order_type") and len(attributes.list_order_type) and attributes.list_order_type eq 2>
                ISNULL(ISNULL(BON.COMPANY_ID,BON.CONSUMER_ID),BON.EMPLOYEE_ID)
            <cfelse>
                BON.BANK_ORDER_ID DESC
            </cfif>
	</cfquery>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_orders.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_orders.recordcount#">
<div class="col col-12 col-xs-12">
    <cfform name="form_bank" action="#request.self#?fuseaction=bank.list_assign_order" method="post">
        <input name="form_varmi" id="form_varmi" value="1" type="hidden">
        <cf_box>       
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword_list" id="keyword_list" value="#attributes.keyword_list#" placeholder="#getLang('main', 48)#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="is_havale" id="is_havale">
                        <option value="" <cfif not len(attributes.is_havale)>selected</cfif>><cfoutput>#getLang("bank",36,"Havale Durumu")#</cfoutput></option>
                        <option value="1" <cfif attributes.is_havale eq 1>selected</cfif>><cfoutput>#getLang('bank', 143)#</cfoutput></option>
                        <option value="2" <cfif attributes.is_havale eq 2>selected</cfif>><cfoutput>#getLang('bank', 146)#</cfoutput></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="list_order_type" id="list_order_type">
                        <option value="" <cfif not len(attributes.list_order_type)>selected</cfif>><cfoutput>#getLang('main', 1512)#</cfoutput></option>
                        <option value="1" <cfif attributes.list_order_type eq 1>selected</cfif>><cfoutput>#getLang('main', 1513)#</cfoutput></option>
                        <option value="2" <cfif attributes.list_order_type eq 2>selected</cfif>><cfoutput>#getLang('main', 1514)#</cfoutput></option>
                    </select>
                </div>
                <cfif xml_payment_type>
                    <div class="form-group">
                        <cf_wrk_special_definition width_info='150' list_filter_info='1' field_id="special_definition_id">
                    </div>
                </cfif>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3">
                </div>
                
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='input_control()'>
                </div> 
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-bank_action_date">
                        <label class="col col-12"><cfoutput>#getLang('bank',429)#</cfoutput></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="bank_action_date" value="#dateformat(attributes.bank_action_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="bank_action_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-account_id_list">
                        <label class="col col-12"><cfoutput>#getLang('main', 1652)#</cfoutput></label>
                        <div class="col col-12">
                            <select name="account_id_list" id="account_id_list">
                                <option value=""><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                <cfoutput query="get_accounts">
                                    <option value="#account_id#;#account_currency_id#" <cfif isdefined("attributes.account_id_list") and (listfirst(attributes.account_id_list,';') eq account_id)>selected</cfif>>#account_name#-#account_currency_id#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-company">
                        <label class="col col-12"><cfoutput>#getLang('main', 107)#</cfoutput></label>
                        <div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                            <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                            <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                            <input type="text" name="company"  id="company" style="width:110px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,MEMBER_ID','company_id,consumer_id,employee_id','','3','250','get_money_info(\'add_costplan\',\'expense_date\');');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_consumer=form_bank.consumer_id&field_member_name=form_bank.company&field_comp_name=form_bank.company&field_name=form_bank.company&field_comp_id=form_bank.company_id&field_emp_id=form_bank.employee_id&select_list=1,2,3</cfoutput>&keyword='+encodeURIComponent(document.form_bank.company.value),'list')"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-12"><cfoutput>#getLang('main', 4)#</cfoutput></label>
                            <cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                            <cfset project_id_ = #attributes.project_id#>
                            <cfelse>
                                <cfset project_id_ = ''>
                            </cfif>
                                <cf_wrkproject
                                project_id="#project_id_#"
                                width="110"
                                agreementno="1" customer="2" employee="3" priority="4" stage="5"
                                boxwidth="600"
                                boxheight="400">
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" index="3" type="column" sort="true">
                    <div class="form-group" id="item-file_status">
                        <label class="col col-12"><cfoutput>#getLang('main', 279)#</cfoutput></label>
                        <div class="col col-12">
                            <select name="file_status" id="file_status">
                                <option value="" <cfif not len(attributes.file_status)>selected</cfif>><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                <option value="1" <cfif attributes.file_status eq 1>selected</cfif>><cfoutput>#getLang('main', 2673)#</cfoutput></option>
                                <option value="0" <cfif attributes.file_status eq 0>selected</cfif>><cfoutput>#getLang('main', 2674)#</cfoutput></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_order_type">
                        <label class="col col-12"><cfoutput>#getLang('main', 1562)#</cfoutput>/<cfoutput>#getLang('main', 1563)#</cfoutput></label>
                        <div class="col col-12">
                            <select name="bank_order_type" id="bank_order_type" >
                                <option value="" <cfif not len(attributes.bank_order_type)>selected</cfif>><cfoutput>#getLang('main', 322)#</cfoutput></option>
                                <option value="260" <cfif attributes.bank_order_type eq 260>selected</cfif>><cfoutput>#getLang('main', 1563)#</cfoutput></option>
                                <option value="251" <cfif attributes.bank_order_type eq 251>selected</cfif>><cfoutput>#getLang('main', 1562)#</cfoutput></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" index="4" type="column" sort="true">
                    <div class="form-group" id="item-islem_tarihi">
                        <label class="col col-12"><cfoutput>#getLang('main', 467)#</cfoutput></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="start_date2" id="start_date2" value="#dateformat(attributes.start_date2,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date2"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="finish_date2" id="finish_date2" value="#dateformat(attributes.finish_date2,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date2"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-odeme_tarihi">
                        <label class="col col-12"><cfoutput>#getLang('main', 1439)#</cfoutput></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cf_box>
    </cfform>
    <cfform name="formBank" id="formBank" action="#request.self#?fuseaction=bank.list_assign_order" method="post">
        <cf_box title="#getLang('bank',160)#" uidrop="1" hide_table_column="1" scroll="1" woc_setting = "#{ checkbox_name : 'print_assign_id', print_type : 157 }#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <cfset col_first = 10>
                        <cfset col_second = 14>
                        <th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='35377.İşlem Adı'></th> 
                        <th><cf_get_lang dictionary_id='58585.Kodu'></th>        
                        <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                        <cfif xml_show_iban_no eq 1>
                            <cfset col_first ++>
                            <cfset col_second ++>
                            <th><cf_get_lang dictionary_id='59007.IBAN Kodu'></th> 
                        </cfif>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th>
                        <cfif xml_show_bsy>
                            <cfset col_first ++>
                            <cfset col_second ++>
                            <th><cf_get_lang dictionary_id='57908.Temsilci'></th>
                        </cfif>
                        <cfif xml_payment_type>
                            <th><cf_get_lang dictionary_id="57845.Tahsilat"> / <cf_get_lang dictionary_id="58928.Ödeme Tipi"></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='31166.Ödeme Yapan'></th>
                        <th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
                        <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                        <th><cf_get_lang dictionary_id='57847.Ödeme'></th>
                        <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th><cf_get_lang dictionary_id='57489.Para Br'></th>
                        <cfif isdefined("is_show_bakiye") and is_show_bakiye eq 1>
                            <cfset col_second = col_second + 2>
                            <th><cf_get_lang dictionary_id='57589.Bakiye'></th>
                            <th><cf_get_lang dictionary_id='48775.İşlem Sonrası Bakiye'></th>
                        </cfif>
                        <!-- sil -->
                        <th width="20">
                            <cfif not listfindnocase(denied_pages,'bank.popup_assign_order')>
                                <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_assign_order&event=add_assign"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='48928.Giden Talimat Ekle'>" title="<cf_get_lang dictionary_id='48928.Giden Talimat Ekle'>"></i></a>
                            </cfif>
                        </th>
                        <th width="20">
                            <cfif not listfindnocase(denied_pages,'bank.popup_incoming_bank_order')>
                                <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_assign_order&event=add_incoming"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='48929.Gelen Talimat Ekle'>" title="<cf_get_lang dictionary_id='48929.Gelen Talimat Ekle'>"></i></a>
                            </cfif>
                        </th>
                        <cfif get_orders.recordcount><th width="20" class="text-center"><input type="checkbox" name="checked_value_main" id="checked_value_main" value="1" onclick="wrk_select_change();"></th></cfif>
                        <cfif  get_orders.recordcount>
                            <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                                <cfif get_orders.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
                                <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_assign_id');">
                            </th>
                
                        </cfif>
                        
                        <!-- sil -->
                    </tr>
                </thead>
                <cfif get_orders.recordcount> 
                    <tbody>
                        <cfif attributes.page neq 1>
                            <cfoutput query="get_orders" startrow="1" maxrows="#attributes.startrow-1#">
                                <cfif len(action_value)>
                                    <cfset 'toplam_#action_money#' = evaluate('toplam_#action_money#') +action_value>
                                </cfif>
                            </cfoutput>				  
                        </cfif>
                        <cfoutput query="get_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td width="20">#currentrow#</td>
                                <td>#seri_no#</td>
                                <td nowrap>
                                    <cfif bank_order_type eq 260>
                                        <a href="#request.self#?fuseaction=bank.list_assign_order&event=upd_assign&bank_order_id=#bank_order_id#" class="tableyazi"><cf_get_lang dictionary_id='58167.Giden Banka Talimatı'></a>
                                    <cfelseif bank_order_type eq 251>
                                        <a href="#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=#bank_order_id#" class="tableyazi"><cf_get_lang dictionary_id='58165.Gelen Banka Talimatı'></a>
                                    </cfif>
                                </td>
                                <td>
                                    <cfif len(company_id)>
                                        #company_member_code#
                                    <cfelseif len(consumer_id)>
                                        #consumer_member_code#
                                    <cfelseif len(employee_id)>
                                        #employee_member_code#
                                    </cfif>
                                </td>   
                                <td style="min-width:150px"><cfif len(company_id)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_orders.company_id#','medium');" class="tableyazi">#get_par_info(company_id,1,1,0)#</a>
                                    <cfelseif len(consumer_id)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_orders.consumer_id#','medium');" class="tableyazi">#get_cons_info(consumer_id,0,0)#</a>
                                    <cfelseif len(employee_id)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_orders.employee_id#','medium');" class="tableyazi">#get_emp_info(employee_id,0,0,0,acc_type_id)#</a>
                                    </cfif>
                                </td>
                                <cfif xml_show_iban_no eq 1>
                                    <td>
                                        <cfif len(get_orders.company_id)>
                                            #company_iban_code#
                                        <cfelseif len(get_orders.consumer_id)>
                                            #consumer_iban_code#
                                        </cfif>
                                    </td>
                                </cfif>
                                <td style="min-width:100px"><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a></td>
                                <cfif xml_show_bsy>
                                    <td>#temsilci#</td>
                                </cfif>
                                <cfif xml_payment_type>
                                    <td style="min-width:200px">#SPECIAL_DEFINITION#</td>
                                </cfif>
                                <td style="min-width:100px">
                                    <cfif len(record_emp)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_orders.record_emp#','medium');" class="tableyazi">#record_emp_name#</a>
                                    <cfelseif len(record_par)>
                                        #record_par_name#
                                    <cfelseif len(record_cons)>
                                        #record_cons_name#
                                    </cfif>
                                </td>
                                <td style="min-width:200px">#account_name# (#account_no#)</td>
                                <td>#dateformat(action_date,dateformat_style)#</td>
                                <td>#dateformat(payment_date,dateformat_style)#</td>
                                <td class="moneybox" style="min-width:70px">#TLFormat(action_value)# </td>
                                <td style="min-width:75px">&nbsp;#action_money#</td>
                                <cfif len(action_value)>
                                    <cfset 'toplam_#action_money#' = evaluate('toplam_#action_money#') +action_value>
                                    <cfset 'toplam_2_#action_money#' = evaluate('toplam_2_#action_money#') +action_value>
                                </cfif>
                                <cfif isdefined("is_show_bakiye") and is_show_bakiye eq 1>
                                    <td class="moneybox" style="min-width:100px">
                                        <cfif len(company_id)>
                                            #TLFormat(company_bakiye)#
                                            <cfset bakiye_info = company_bakiye>
                                        <cfelseif len(consumer_id)>
                                            #TLFormat(consumer_bakiye)#
                                            <cfset bakiye_info = consumer_bakiye>
                                        <cfelseif len(employee_id)>
                                            #TLFormat(employee_bakiye)#
                                            <cfset bakiye_info = employee_bakiye>
                                        </cfif>
                                        <cfif bakiye_info gte 0>(B)<cfelse>(A)</cfif>
                                    </td>
                                    <td class="moneybox" style="min-width:150px">
                                        <cfif get_orders.bank_order_type eq 251>
                                            #TLFormat(abs(bakiye_info-action_value))#
                                            <cfif bakiye_info-action_value gte 0>(B)<cfelse>(A)</cfif>
                                        <cfelse>
                                            #TLFormat(abs(bakiye_info+action_value))#
                                            <cfif bakiye_info+action_value gte 0>(B)<cfelse>(A)</cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                                <!-- sil -->
                                <td  width="20">
                                    <cfif get_orders.bank_order_type eq 251>
                                        <a href="#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=#bank_order_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=bank.list_assign_order&event=upd_assign&bank_order_id=#bank_order_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    </cfif>
                                </td>
                                <td width="20">
                                    <cfif get_orders.is_paid neq 1 and get_orders.bank_order_type eq 260>
                                        <a href="#request.self#?fuseaction=bank.form_add_gidenh&bank_order_id=#bank_order_id#&from_assign_order=1<cfif len(project_id)>&project_id=#project_id#</cfif><cfif len(company_id)>&is_company=1<cfelseif len(consumer_id)>&is_consumer=1<cfelseif len(employee_id)>&is_employee=1</cfif>" target="_blank"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='48759.Giden Havale Ekle'>" title="<cf_get_lang dictionary_id='48759.Giden Havale Ekle'>"></i></a>
                                    <cfelseif get_orders.is_paid neq 1 and get_orders.bank_order_type eq 251>
                                        <a href="#request.self#?fuseaction=bank.form_add_gelenh&bank_order_id=#bank_order_id#&from_bank_order=1<cfif len(project_id)>&project_id=#project_id#</cfif><cfif len(company_id)>&is_company=1<cfelseif len(consumer_id)>&is_consumer=1<cfelseif len(employee_id)>&is_employee=1</cfif>" target="_blank"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='48722.Gelen Havale Ekle'>" title="<cf_get_lang dictionary_id='48722.Gelen Havale Ekle'>"></i></a>
                                    </cfif>
                                </td>
                                <td class="text-center"><!--- havaleye dönüştürülmiş ve giden talimatsa şimdilik,toplu havale oluşturmayı açıyorz --->
                                    <input type="hidden" name="money_info_" id="money_info_" value="#action_money#">
                                    <input type="hidden" id="account_id#currentrow#" name="account_id" value="#account_id#">
                                    <input type="hidden" id="bank_order_type_" name="bank_order_type_" value="#bank_order_type#">
                                    <cfif xml_add_multi_files eq 1 and len(file_export_id)>
                                        <cfset file_kontrol = 1>
                                    <cfelse>
                                        <cfset file_kontrol = 0>
                                    </cfif>
                                    <input type="hidden" id="is_control_info" name="is_control_info" value="<cfif get_orders.is_paid neq 1 and get_orders.bank_order_type eq 260 and file_kontrol eq 0>0<cfelse>1</cfif>">
                                    <input type="checkbox" name="checked_value#currentrow-((attributes.page-1)*attributes.maxrows)#" id="checked_value#currentrow-((attributes.page-1)*attributes.maxrows)#" value="#bank_order_id#">
                                </td> 
                                <td style="text-align:center"><input type="checkbox" name="print_assign_id" id="print_assign_id" value="#bank_order_id#"></td>
                                <!-- sil -->
                            </tr>
                            <cfif isdefined("is_show_bakiye") and is_show_bakiye eq 1 and isdefined("attributes.list_order_type") and len(attributes.list_order_type) and attributes.list_order_type eq 2 and ((len(get_orders.company_id) and get_orders.company_id neq get_orders.company_id[currentrow+1]) or (len(get_orders.consumer_id) and get_orders.consumer_id neq get_orders.consumer_id[currentrow+1]) or (len(get_orders.employee_id) and get_orders.employee_id neq get_orders.employee_id[currentrow+1]))>
                                <tr>
                                    <td colspan="#col_first+1#" class="bold moneybox"></td>
                                    <td class="bold moneybox">
                                        <cfset total_value = 0>
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_2_#get_money.money#') gt 0>
                                                #Tlformat(evaluate('toplam_2_#get_money.money#'))#<br/>
                                                <cfif get_money.money eq session.ep.money>
                                                    <cfset total_value = evaluate('toplam_2_#get_money.money#')>
                                                </cfif>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="bold">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_2_#get_money.money#') gt 0>&nbsp;#get_money.money#<br></cfif>
                                            <cfset "toplam_2_#get_money.money#" = 0>
                                        </cfloop>
                                    </td>
                                    <td class="bold moneybox">
                                        <cfif len(company_id)>
                                            #TLFormat(company_bakiye)#
                                            <cfset bakiye_info = company_bakiye>
                                        <cfelseif len(consumer_id)>
                                            #TLFormat(consumer_bakiye)#
                                            <cfset bakiye_info = consumer_bakiye>
                                        <cfelseif len(employee_id)>
                                            #TLFormat(employee_bakiye)#
                                            <cfset bakiye_info = employee_bakiye>
                                        </cfif>
                                        <cfif bakiye_info gte 0>(B)<cfelse>(A)</cfif>
                                    </td>
                                    <td class="bold moneybox" nowrap="nowrap">
                                        <cfif get_orders.bank_order_type eq 251>
                                            #TLFormat(abs(bakiye_info-total_value))#
                                            <cfif bakiye_info-total_value gte 0>(B)<cfelse>(A)</cfif>
                                        <cfelse>
                                            #TLFormat(abs(bakiye_info+total_value))#
                                            <cfif bakiye_info+total_value gte 0>(B)<cfelse>(A)</cfif>
                                        </cfif>
                                    </td>
                                    <td colspan="4" align="center" nowrap="nowrap"></td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan=" <cfif xml_payment_type><cfoutput>#col_second-7+1#</cfoutput><cfelse><cfoutput>#col_second-7#</cfoutput></cfif>" nowrap="nowrap">
                            </td>
                            <td class="bold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfif evaluate('toplam_#money#') gt 0>
                                        #Tlformat(evaluate('toplam_#money#'))#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td>
                                <cfoutput query="get_money">
                                    <cfif evaluate('toplam_#money#') gt 0>&nbsp;#money#<br/></cfif>
                                </cfoutput>
                            </td>
                            <td colspan="4"></td>
                            <!-- sil -->
                            <td width="65" nowrap="nowrap" class="moneybox">
                                <input type="hidden" name="checked_value" id="checked_value" value="" /><!--- Checkbox degistirildigi icin bu degere atanarak form submit edilir --->
                                <a href="javascript://" onclick="open_bank_file();"><i class="fa fa-file-text" alt="<cf_get_lang dictionary_id='48748.Talimat Dosyası Oluştur'>" title="<cf_get_lang dictionary_id='48748.Talimat Dosyası Oluştur'>"></i></a>
                            </td>
                            
                            <td width="65" nowrap="nowrap" class="moneybox">
                                <a href="javascript://" onclick="open_print();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                            </td>
                            <!-- sil -->
                        </tr>
                    </tfoot>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="<cfoutput>#col_second+1#</cfoutput>"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz!'>!</cfif></td>
                        </tr>
                    </tbody>    
                </cfif>
            </cf_grid_list>
                
            <cfset url_str="bank.list_assign_order">
            <cfif isdefined("attributes.form_varmi")>
                <cfset url_str = '#url_str#&form_varmi=#attributes.form_varmi#'>
            </cfif>
            <cfif isdefined("attributes.is_havale")>
                <cfset url_str = '#url_str#&is_havale=#attributes.is_havale#'>
            </cfif>		
            <cfif len(attributes.keyword_list)>
                <cfset url_str = "#url_str#&keyword_list=#attributes.keyword_list#">
            </cfif>
            <cfif len(attributes.company) and len(attributes.company_id)>
                <cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
            <cfelseif len(attributes.company) and len(attributes.consumer_id)>
                <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
            </cfif>
            <cfif isdate(attributes.start_date)>
                <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif isdate(attributes.finish_date)>
                <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif isdate(attributes.bank_action_date)>
                <cfset url_str = "#url_str#&bank_action_date=#dateformat(attributes.bank_action_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.account_id_list)>
                <cfset url_str = "#url_str#&account_id_list=#attributes.account_id_list#">
            </cfif>
            <cfif len(attributes.bank_order_type)>
                <cfset url_str = "#url_str#&bank_order_type=#attributes.bank_order_type#">
            </cfif>
            <cfif len(attributes.list_order_type)>
                <cfset url_str = "#url_str#&list_order_type=#attributes.list_order_type#">
            </cfif>
            <cfif len(attributes.file_status)>
                <cfset url_str = "#url_str#&file_status=#attributes.file_status#">
            </cfif>
            <cfif isDefined('attributes.project_id') and len(attributes.project_id)>
                <cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
            </cfif>
            <cfif isDefined('attributes.project_head') and len(attributes.project_head)>
                <cfset url_str = '#url_str#&project_head=#attributes.project_head#'>
            </cfif>
            <cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>
                <cfset url_str = '#url_str#&employee_id=#attributes.employee_id#'>
            </cfif>
            <cf_paging 
                name="formBank"
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#url_str#"
                is_form="1">
        </cf_box>
        <cfif get_orders.recordcount> 
            <cf_box>
                <cf_box_elements vertical="1">
                    <div class="form-group col col-3">
                        <cfif attributes.bank_order_type eq 260>
                            <cf_workcube_process_cat slct_width="150" is_default="0" process_type_info="25,253">
                        <cfelseif attributes.bank_order_type eq 251>
                            <cf_workcube_process_cat slct_width="150" is_default="0" process_type_info="24,240">
                        <cfelse>
                            <cf_workcube_process_cat slct_width="150" is_default="0">
                        </cfif>	
                    </div>
                    <div class="form-group col col-3"> 
                        <select name="action_to_account_id" id="action_to_account_id" placeholder="">
                            <option value=""><cf_get_lang dictionary_id='48706.Banka/Hesap'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_accounts">
                                <option value="#account_id#;#account_currency_id#;#listgetat(session.ep.user_location,2,'-')#">#account_name#-#account_currency_id#</option>
                            </cfoutput>
                        </select>
                    </div>              
                </cf_box_elements>
                <cf_box_footer>
                    <input type="button" class="ui-wrk-btn ui-wrk-btn-success" onclick="open_auto_transfer();" name="collacted_havale" id="collacted_havale" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
                </cf_box_footer>
            </cf_box>
        </cfif>
    </cfform>
</div>
<script type="text/javascript">
	document.getElementById('keyword_list').focus();

	function input_control()
	{
		<cfif xml_select_acc_member>
			temp_account_id_list = document.getElementById("account_id_list").selectedIndex;
						
			if (document.getElementById("account_id_list").options[temp_account_id_list].value.length == 0 &&  document.getElementById("company_id").value.length == 0 &&  document.getElementById("company").value.length == 0 && document.getElementById("consumer_id").value.length == 0)				
			{
				alert("<cf_get_lang dictionary_id='49084.Cari veya Banka Seçiniz '> !");
				return false;
			}
		</cfif>
		return true;
	}
	
	function wrk_select_change()
	{
		var uzunluk = document.getElementsByName('is_control_info').length;
		for(var zz=1; zz<=uzunluk; zz++)
		{
			if(document.getElementById("checked_value"+zz) != undefined)
			{
				if(document.getElementById("checked_value_main").checked == true)
					document.getElementById("checked_value"+zz).checked = true;
				else
					document.getElementById("checked_value"+zz).checked = false;
			}
		}
	}

	function open_bank_file()
	{
		account_list_ = '';
		var uzunluk = document.getElementsByName('is_control_info').length;
        document.getElementById("checked_value").value = "";
        for(ci=0;ci<uzunluk;ci++)
		{
			my_obj=(uzunluk==1)?document.getElementById('is_control_info'):document.getElementsByName('is_control_info')[ci];
			//account_id_= (uzunluk==1)?document.getElementById('account_id'):document.getElementsByName('account_id')[ci];
            account_id_= document.getElementsByName('account_id')[ci];
			if(document.getElementById('checked_value'+(ci+1)) != undefined && document.getElementById('checked_value'+(ci+1)).checked==true)
			{
                
				if(document.getElementById("checked_value").value == "")
					document.getElementById("checked_value").value = document.getElementById("checked_value"+(ci+1)).value;
				else
					document.getElementById("checked_value").value = document.getElementById("checked_value").value + ',' + document.getElementById("checked_value"+(ci+1)).value;
				
				if(! list_find(account_list_,account_id_.value)) account_list_+=account_id_.value+',';
                   
			}
		}
		if(account_list_ != '')
		{
			account_list_ = account_list_.substr(0,(account_list_.length-1));
		}
		if(list_len(account_list_) > 1)
		{
			alert("<cf_get_lang dictionary_id='48694.Farklı Banka Hesabına Ait Islemleri Birlikte Secemezsiniz '> !");
			return false;
		}
		
		windowopen('','small','cc_paym');
		formBank.action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_make_bankorder_file';
		formBank.target='cc_paym';
		formBank.submit();
		formBank.action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_assign_order';
		formBank.target='';
		return true;
	}
	
	function open_print()
	{
		temp_checked_value = 0;
		var order_id_list = '';
		var control_list= new Array();
		var uzunluk = document.getElementsByName('is_control_info').length;
		document.getElementById("checked_value").value = "";
		for (i=1; i <= uzunluk; i++)
		{
			if(document.getElementById("checked_value"+i) != undefined && document.getElementById("checked_value"+i).checked == true)
			{
				if(document.getElementById("checked_value").value == ""){
					document.getElementById("checked_value").value = document.getElementById("checked_value"+i).value;
					control_list[i] = i;
				}
				else
				{	
					control_list[i]= i;
					document.getElementById("checked_value").value = document.getElementById("checked_value").value + ',' + document.getElementById("checked_value"+i).value;
				}
				temp_checked_value = 1;
				
				//break;
			}	
		}
		order_id_list=document.getElementById("checked_value").value;
		for(j in control_list){
			for(x in control_list){
				if(document.getElementById("account_id"+j).value != document.getElementById("account_id"+x).value){
					alert("<cf_get_lang dictionary_id = "51445.Aynı banka hesabına ait talimatları seçmelisiniz !">");	
					return false;
				}
			}	
		}
		//en az bir talimat secilmeli
		if(temp_checked_value == 0)
		{
			alert("<cf_get_lang dictionary_id ="51497.Listeden En Az Bir Tane Yazdırılacak Belge Seçmelisiniz !">");
			return false;
		}
		else
		{
			/* windowopen('','medium','cc_paym','woc'); */
            formBank.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=150&action_id='+order_id_list+''; 
			formBank.target='cc_paym';
			formBank.submit();
			formBank.action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_assign_order';
			formBank.target='';
			return true;
		}
	}
	function open_auto_transfer()
	{
		money_list = '';
		bank_order_type_list = '';
		collacted_havale_list = '';
		temp_checked_value = 0;
		var uzunluk = document.getElementsByName('is_control_info').length;
		for(ci=0;ci<uzunluk;ci++)
		{
			check_my_obj = document.getElementById('checked_value'+(ci+1));
			if(check_my_obj.disabled == true)
			{
				check_my_obj.disabled = false;
				check_my_obj.checked = false;
			}
			money_info_=(uzunluk==1)?document.getElementById('money_info_'):document.getElementsByName('money_info_')[ci];
			bank_order_info_=(uzunluk==1)?document.getElementById('bank_order_type_'):document.getElementsByName('bank_order_type_')[ci];
			if(check_my_obj.checked==true)
			{
				if(! list_find(money_list,money_info_.value))
					money_list+=money_info_.value+',';
				if(! list_find(bank_order_type_list,bank_order_info_.value))
					bank_order_type_list+=bank_order_info_.value+',';
				collacted_havale_list += check_my_obj.value+',';
			}
		}
		if(collacted_havale_list.length>0)	collacted_havale_list = collacted_havale_list.slice(0,collacted_havale_list.length-1);
		if(money_list != '')
		{
			money_list = money_list.substr(0,(money_list.length-1));
		}
		
		if(bank_order_type_list != '')
		{
			bank_order_type_list = bank_order_type_list.substr(0,(bank_order_type_list.length-1));
		}
		
		for (i=1; i <= uzunluk; i++)
		{
			if(document.getElementById('checked_value'+i).checked == true)
			{
				temp_checked_value = 1;
				break;
			}	
		}
		//en az bir talimat secilmeli
		if(temp_checked_value == 0)
		{
			alert("<cf_get_lang dictionary_id='48696.Talimat Seciniz'> !");
			return false;
		}
		
		//talimatlardan havale kaydi olusturabilmek icin havale edilmeyen ve gelen/giden havaleler listelenmelidir.
		if(document.getElementById("is_havale").value != 2)
		{
			alert("<cf_get_lang dictionary_id = "51498.Havale Filtresinden Oluşturulmadı Olanları Listeleyiniz !">");
			return false;
		}
		if(document.getElementById("bank_order_type").value == "")
		{
			alert("<cf_get_lang dictionary_id = "51513.Gelen ya da Giden Talimat Seçmelisiniz !">");
			return false;
		}
		if(!chk_process_cat('formBank')) return false;
		var pro_cat = document.getElementById("process_cat").value;
		if (!(document.getElementById('action_to_account_id').value == '' && list_find("24;25",document.getElementById("ct_process_type_"+pro_cat).value,";")))
		{
			if(list_len(money_list) > 1)
			{
				alert("<cf_get_lang dictionary_id='48691.Farklı Para Birimlerine Ait Islemleri Birlikte Secemezsiniz '> !");
				return false;
			}
		}
		if(list_len(bank_order_type_list) > 1)
		{
			alert("<cf_get_lang dictionary_id='48692.Gelen ve Giden Talimat Islemlerini Birlikte Secemezsiniz '> !");
			return false;
		}
		if(document.getElementById("process_cat").value == "")
		{
			alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById("action_to_account_id").value == "")
		{
			alert("<cfoutput>#getLang('ch',47)#</cfoutput>");
			return false;
		}
		
		if(list_len(money_list) == 1)
		{
			if(list_getat(document.getElementById("action_to_account_id").value,2,';') != "" && money_list != list_getat(document.getElementById("action_to_account_id").value,2,';'))
			{
				alert("<cf_get_lang dictionary_id ="51517.Seçilen İşlemler ile Banka Hesabına Ait Para Birimleri Aynı Olmalıdır !">");
				return false;
			}
		}
		//toplu gelen veya giden; ya da tekil havale kaydi olusturulacak.
		if(bank_order_type_list == 260) bank_order_type = 1; else bank_order_type = 0;
		
		//secili satirlari checked_value degerine atar
		document.getElementById("checked_value").value = "";
		for (i=1; i <= uzunluk; i++)
		{
			if(document.getElementById("checked_value"+i) != undefined && document.getElementById("checked_value"+i).checked == true)
			{
				if(document.getElementById("checked_value").value == "")
					document.getElementById("checked_value").value = document.getElementById("checked_value"+i).value;
				else
					document.getElementById("checked_value").value = document.getElementById("checked_value").value + ',' + document.getElementById("checked_value"+i).value;
			}	
		}
		
		if(list_find("24;25",document.getElementById("ct_process_type_"+pro_cat).value,";"))
		{
			windowopen('','small','add_gelen_giden');
			document.getElementById('formBank').action='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopupflush_add_autopayment_import&bank_order_type='+bank_order_type+'&money_type='+money_list+'&from_list=1';
			document.getElementById('formBank').target='add_gelen_giden';
			document.getElementById('formBank').submit();
		}
		else if(document.getElementById("ct_process_type_"+pro_cat).value == 240)
			windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=bank.add_collacted_gelenh&is_copy=1&from_assign_order=1&collacted_havale_list="+collacted_havale_list+"&collacted_process_cat="+pro_cat+"&collacted_bank_account="+list_getat(document.getElementById('action_to_account_id').value,1,';'),"wwide");
		else if(document.getElementById("ct_process_type_"+pro_cat).value == 253)
			windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=bank.add_collacted_gidenh&is_copy=1&from_assign_order=1&collacted_havale_list="+collacted_havale_list+"&collacted_process_cat="+pro_cat+"&collacted_bank_account="+list_getat(document.getElementById('action_to_account_id').value,1,';'),"wwide");
		return true;
	}
</script>
