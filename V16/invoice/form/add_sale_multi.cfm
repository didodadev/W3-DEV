<!--- cift kayitlari onlemek icin gerekli silmeyiniz FA --->
<cfscript>
	session.ep.add_invoice_multi = 0;
</cfscript>
<cf_xml_page_edit fuseact="invoice.popup_form_add_sale_multi">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.multi_sale_grup" default="1">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.invoice_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.open_form" default="0">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.subscription_type" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.is_einvoice" default="">
<cfparam name="attributes.subs_add_option" default="">
<cfquery name="GET_SERVICE_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
    SELECT 
        <cfif xml_money_type eq 1>
            ISNULL(RATE3,RATE2) RATE2_
        <cfelseif xml_money_type eq 3>
            ISNULL(EFFECTIVE_PUR,EFFECTIVE_PUR) RATE2_
        <cfelseif xml_money_type eq 4>
            ISNULL(EFFECTIVE_SALE,EFFECTIVE_SALE) RATE2_
        <cfelse>
            RATE2 RATE2_
        </cfif>,
        * 
    FROM 
        SETUP_MONEY
</cfquery>
<!--- fatura tarihindeki kur alınıyor --->
<cfset kur_date = attributes.invoice_date>
<cf_date tarih="kur_date">
<cfif kur_date neq dateFormat(now(),dateformat_style)> 
    <cfquery name="GET_MONEY_INFO_" datasource="#DSN2#">
        SELECT 
            <cfif xml_money_type eq 1>
                ISNULL(RATE3,RATE2) RATE2_
            <cfelseif xml_money_type eq 3>
                ISNULL(EFFECTIVE_PUR,EFFECTIVE_PUR) RATE2_
            <cfelseif xml_money_type eq 4>
                ISNULL(EFFECTIVE_SALE,EFFECTIVE_SALE) RATE2_
            <cfelse>
                RATE2 RATE2_
            </cfif>,
            * 
        FROM 
            #dsn_alias#.MONEY_HISTORY
        WHERE
            PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            AND VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#kur_date#">
    </cfquery>
    <cfif GET_MONEY_INFO_.recordCount>
        <cfoutput query="GET_MONEY_INFO">
            <cfquery name="qoq_money" dbtype="query">
                SELECT * FROM GET_MONEY_INFO_ WHERE MONEY = '#GET_MONEY_INFO.MONEY#'
            </cfquery>
            <cfif qoq_money.recordCount>
                <cfset GET_MONEY_INFO.RATE2_ = qoq_money.RATE2_>
            </cfif>
        </cfoutput>
    </cfif>
</cfif>
<cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
<cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
 <cfset GET_SUBSCRIPTION_TYPE= gsa.SelectSubscription()/>

<cfif xml_select_subs_add_option eq 1>
    <cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
    <cfset GET_SUBS_ADD_OPTION = contract_cmp.GET_SUBS_ADD_OPTION(dsn3:dsn3)>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57017.Abone Toplu Fatura İşlemi"></cfsavecontent>
<cf_box title="#message#">
    <cfform name="form_basket" method="post" action="">
        <input type="hidden" name="open_form" id="open_form" value="<cfoutput>#attributes.open_form#</cfoutput>">
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">                
                <div class="form-group" id="item-islem-tipi">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='57800.İşlem Tipi'> *
                    </label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat process_cat="#attributes.process_cat#">
                    </div>
                </div>
                <div class="form-group" id="item-baslangic-tarihi">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='57655.Başlangıç Tarihi'> *
                    </label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='39354.Başlangıç tarihini yazınız'> !</cfsavecontent>
                            <cfinput type="text" name="start_date" style="width:110px;" required="Yes" message="#message#" value="#attributes.start_date#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div> 
                    </div>
                </div>
                <div class="form-group" id="item-bitis-tarihi">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *
                    </label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş tarihini yazınız'> !</cfsavecontent>
                            <cfinput type="text" name="finish_date" style="width:110px;" required="Yes" message="#message#" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div> 
                    </div>
                </div>
                <div class="form-group" id="item-fatura-tarihi">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='58759.Fatura Tarihi'> *
                    </label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="invoice_date" style="width:110px;" required="Yes" message="#message#" value="#attributes.invoice_date#" validate="#validate_style#" onchange="kurGetir(this,'pay_plan_rows')" maxlength="10" readonly>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_date"></span>
                        </div>
                    </div>
                </div>
                <cfif xml_select_sub_type eq 1>
                    <div class="form-group" id="item-kategori">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id ='57486.Kategori'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="subscription_type" id="subscription_type">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="get_subscription_type">
                                        <option value="#subscription_type_id#" <cfif attributes.subscription_type eq subscription_type_id>selected</cfif>>#subscription_type#</option>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif>
                <cfif xml_select_subs_add_option eq 1>
                    <div class="form-group" id="form_ul_subs_add_option">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='40946.Abone Özel Tanım'></label>
                        <div class="col col col-8 col-xs-12">
                            <select name="subs_add_option" id="subs_add_option">
                                <option value=""><cf_get_lang dictionary_id ='40946.Abone Özel Tanım'></option>
                                    <cfoutput query="get_subs_add_option">
                                        <option value="#subscription_add_option_id#" <cfif attributes.subs_add_option eq subscription_add_option_id>selected</cfif>>#subscription_add_option_name#</option>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif>
                <cfif session.ep.our_company_info.is_efatura>
                    <div class="form-group" id="item-efatura">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29872.E-Fatura"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_einvoice" id="is_einvoice">
                                <option value="" selected="selected"><cf_get_lang dictionary_id="57734.Seçiniz"> !</option>
                                <option value="1" <cfif attributes.is_einvoice eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="38801.Kullananlar"></option>
                                <option value="0" <cfif attributes.is_einvoice eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="38804.Kullanmayanlar"></option>
                                <cfif xml_receipt eq 1>
                                    <option value="2" <cfif (xml_receipt eq 1 and attributes.is_einvoice eq "") or attributes.is_einvoice eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="58062.Dekont"></option>
                                </cfif>
                            </select>
                        </div>
                        </div>
                </cfif>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-musteri-tipi">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='57292.Müşteri Tipi'>
                    </label>
                    <div class="col col-8 col-xs-12">
                        <select name="member_type" id="member_type" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1" <cfif attributes.member_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
                            <option value="2" <cfif attributes.member_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-depo">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang_main no='1351.Depo'>*
                    </label>
                    <div class="col col-8 col-xs-12">
                        <cfset user_dep_id = listgetat(session.ep.user_location, 1,'-')>
                        <cfquery name="GET_DEPARTMENT_NAME" datasource="#DSN#">
                            SELECT 
                                DEPARTMENT_HEAD,
                                STOCKS_LOCATION.LOCATION_ID,
                                BRANCH_ID
                            FROM
                                DEPARTMENT,
                                STOCKS_LOCATION
                            WHERE
                                DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID AND
                                DEPARTMENT.DEPARTMENT_ID = #user_dep_id# AND
                                DEPARTMENT.IS_STORE <> 2 AND
                                STOCKS_LOCATION.PRIORITY = 1
                        </cfquery>
                        <cfif GET_DEPARTMENT_NAME.recordcount>
                            <cfset dept_name=GET_DEPARTMENT_NAME.DEPARTMENT_HEAD>
                        <cfelse>
                            <cfset dept_name="#attributes.department_name#">
                        </cfif>
                        <cfif len(attributes.location_id)>
                            <cf_wrkdepartmentlocation
                                returnInputValue="location_id,department_name,department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="department_name"
                                fieldId="location_id"
                                department_fldId="department_id"
                                branch_fldId="branch_id"
                                branch_id="#attributes.branch_id#"
                                department_id="#attributes.department_id#"
                                location_id="#attributes.location_id#"
                                location_name="#attributes.department_name#"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="150">
                        <cfelse>
                            <cf_wrkdepartmentlocation
                                returnInputValue="location_id,department_name,department_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="department_name"
                                fieldId="location_id"
                                department_fldId="department_id"
                                branch_fldId="branch_id"
                                branch_id="#GET_DEPARTMENT_NAME.BRANCH_ID#"
                                department_id="#user_dep_id#"
                                location_id="#GET_DEPARTMENT_NAME.LOCATION_ID#"
                                location_name="#dept_name#"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="150">
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-odeme-yontemi">
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>
                    </label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfoutput>#attributes.card_paymethod_id#</cfoutput>">
                            <input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfoutput>#attributes.payment_type_id#</cfoutput>">
                            <input type="hidden" name="pay_due_day" id="pay_due_day" value="<cfif isdefined('attributes.pay_due_day') and len(attributes.pay_due_day)><cfoutput>#attributes.pay_due_day#</cfoutput></cfif>" />
                            <input type="text" name="payment_type" id="payment_type" value="<cfoutput>#attributes.payment_type#</cfoutput>" style="width:150px;" onkeyup="form_basket.payment_type_id.value='';form_basket.card_paymethod_id.value=''">
                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=form_basket.payment_type_id&field_name=form_basket.payment_type&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.payment_type&field_dueday=form_basket.pay_due_day','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>

                        </div>
                    </div>
                </div>
                <cfif xml_multi_group eq 1>
                    <div class="form-group" id="item-toplu-fatura-gruplama">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id="57407.Toplu Faturalama Grup">
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="multi_sale_grup" id="multi_sale_grup">
                            <option value="1" <cfif attributes.multi_sale_grup eq 1>selected</cfif>><cf_get_lang dictionary_id="59603.Abone Bazında"></option>
                            <option value="2" <cfif attributes.multi_sale_grup eq 2>selected</cfif>><cf_get_lang dictionary_id="39075.Cari Bazında"></option>
                        </select>
                        </div>
                    </div>
                </cfif>                
                <cfif xml_select_stage eq 1>
                    <div class="form-group" id="item-asama">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id ='57482.Asama'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <select name="process_stage_type" id="process_stage_type" >
                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <cfoutput query="get_service_stage">
                                    <option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif> 
                <div class="form-group" id="item-grup-faturalama">
                    <label class="col col-12 col-xs-12">
                        <cf_get_lang dictionary_id='57295.Grup Faturalama'>
                        <input type="checkbox" name="is_group_inv" id="is_group_inv" <cfif isDefined("attributes.is_group_inv")>checked</cfif> onclick="ayarla_gizle_goster();">
                    </label>
                </div>                
                <div class="form-group" id="cari_sec2" <cfif not isDefined("attributes.is_group_inv")>style="display:none"</cfif>>
                    <label class="col col-4 col-xs-12">
                        <cf_get_lang dictionary_id='57519.Cari Hesap'>
                    </label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="cons_id" id="cons_id" value="<cfif isDefined("attributes.is_group_inv")><cfoutput>#attributes.cons_id#</cfoutput></cfif>">
                            <input type="hidden" name="par_id" id="par_id" value="<cfif isDefined("attributes.is_group_inv")><cfoutput>#attributes.par_id#</cfoutput></cfif>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif isDefined("attributes.is_group_inv")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                            <input type="text" name="comp_name" id="comp_name" value="<cfif isDefined("attributes.is_group_inv")><cfoutput>#attributes.comp_name#</cfoutput></cfif>" style="width:150px;" readonly>
                            <span class="input-group-addon icon-ellipsis" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=form_basket.company_id&field_member_name=form_basket.comp_name&field_partner=form_basket.par_id&field_consumer=form_basket.cons_id&call_function=kontrol_efatura()</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="cari_sec1" <cfif not isDefined("attributes.is_group_inv")>style="display:none"</cfif>>
                    <label class="col col-xs-12">
                        <cf_get_lang dictionary_id='57352.Grup Faturalamada Ort Fiyat Hesaplamasın'>
                            <input type="checkbox" name="is_avg_price" id="is_avg_price"  <cfif isDefined("attributes.is_avg_price")>checked</cfif>>
                    </label>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58715.Listele'></cfsavecontent>
            <cf_workcube_buttons insert_info='#message#' add_function='kontrol()' is_cancel='0'>
        </cf_box_footer>
    </cfform>
</cf_box>
<cfif attributes.open_form eq 1>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cf_date tarih='attributes.invoice_date'>
<cfquery name="get_process_type_" datasource="#dsn3#">
    SELECT 
        PROCESS_TYPE
    FROM 
        SETUP_PROCESS_CAT 
    WHERE 
        PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>
<cfset invoice_cat = get_process_type_.PROCESS_TYPE>
<cfquery name="GET_PAYMENT_PLAN" datasource="#dsn3#" maxrows="10000"><!--- maxrows="4000" --->
	SELECT
		SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
        SPR.PAYMENT_DATE,
		SPR.SUBSCRIPTION_ID,
		SPR.PAYMETHOD_ID,
		SPR.CARD_PAYMETHOD_ID,
		SPR.MONEY_TYPE,
        SPR.STOCK_ID,
		SPR.UNIT_ID,
        SPR.UNIT,
		SPR.DETAIL,
		SPR.DISCOUNT,
        SPR.DISCOUNT_AMOUNT,
        SPR.AMOUNT,
        SPR.QUANTITY,
        SPR.ROW_TOTAL,
        SPR.ROW_NET_TOTAL,
        SPR.RATE,
        SPR.BSMV_RATE,
        ISNULL(SPR.BSMV_AMOUNT,0) AS BSMV_AMOUNT,
        SPR.OIV_RATE,
        SPR.OIV_AMOUNT,
        SPR.TEVKIFAT_RATE,
        SPR.TEVKIFAT_AMOUNT,
        SPR.REASON_CODE,
        PRODUCT_PERIOD.EXPENSE_CENTER_ID,
        PRODUCT_PERIOD.INCOME_ITEM_ID,
        PRODUCT_PERIOD.INCOME_ACTIVITY_TYPE_ID,
        <cfif invoice_cat eq 531>
            PRODUCT_PERIOD.ACCOUNT_YURTDISI AS ACCOUNT_CODE,
        <cfelseif invoice_cat eq 561>
            PRODUCT_PERIOD.PROVIDED_PROGRESS_CODE AS ACCOUNT_CODE,
        <cfelseif invoice_cat eq 533>
            PRODUCT_PERIOD.EXE_VAT_SALE_INVOICE AS ACCOUNT_CODE,
        <cfelse>
            ACCOUNT_CODE,
        </cfif>	
        ACCOUNT_DISCOUNT,
        SC.CONSUMER_ID,
        SC.PARTNER_ID,
        SC.PROJECT_ID,
        SC.COMPANY_ID,
        SC.INVOICE_CONSUMER_ID,
        SC.INVOICE_PARTNER_ID,
        SC.INVOICE_COMPANY_ID,
		SC.SUBSCRIPTION_NO,
        CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
        C.FULLNAME,
		C.COMPANY_STATUS,
		CONS.CONSUMER_STATUS,
        CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME AS CONS_NAME,
        PRO.PROJECT_HEAD,
        (CASE WHEN SPR.PAYMETHOD_ID IS NOT NULL 
            THEN (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = SPR.PAYMETHOD_ID)
            ELSE NULL END
        ) AS PAY_METHOD_NAME,
        (CASE WHEN SPR.CARD_PAYMETHOD_ID IS NOT NULL 
            THEN (SELECT CARD_NO PAYMETHOD FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID)
            ELSE NULL END
        ) AS CARD_PAYMETHOD_NAME
	FROM
		SUBSCRIPTION_PAYMENT_PLAN_ROW SPR
			RIGHT JOIN SUBSCRIPTION_CONTRACT SC ON SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
			LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SC.PARTNER_ID
			LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = SC.INVOICE_COMPANY_ID
			LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = SC.INVOICE_CONSUMER_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS PRO ON PRO.PROJECT_ID = SC.PROJECT_ID
            LEFT JOIN PRODUCT_PERIOD ON PRODUCT_PERIOD.PRODUCT_ID = SPR.PRODUCT_ID  AND PRODUCT_PERIOD.PERIOD_ID = #session.ep.period_id#
	WHERE
		SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
		SPR.IS_BILLED = 0 AND<!---faturalanmamıs--->
		SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
	<cfif isDefined("is_group_inv")>
		SPR.IS_GROUP_INVOICE = 1 AND<!---grup fat. dahil--->
		SPR.IS_COLLECTED_INVOICE = 0 AND
	<cfelse>
		SPR.IS_COLLECTED_INVOICE = 1 AND<!---toplu fat. dahil--->
		SPR.IS_GROUP_INVOICE = 0 AND
	</cfif>
		SC.IS_ACTIVE = 1<!--- aktif olan abonelikler --->
	<cfif isDefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
		AND SPR.PAYMETHOD_ID = #attributes.payment_type_id#
	<cfelseif isDefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
		AND SPR.CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#
	</cfif>
	<cfif isDefined("attributes.member_type") and attributes.member_type eq 1>
		AND SC.INVOICE_COMPANY_ID IS NOT NULL
	<cfelseif isDefined("attributes.member_type") and attributes.member_type eq 2>
		AND SC.INVOICE_CONSUMER_ID IS NOT NULL 
	</cfif>
	<cfif len(trim(attributes.company_id)) and len(trim(attributes.comp_name))>
		AND SC.INVOICE_COMPANY_ID = #attributes.company_id#
	<cfelseif len(trim(attributes.cons_id)) and len(trim(attributes.comp_name))>
		AND SC.INVOICE_CONSUMER_ID = #attributes.cons_id#
	</cfif>
	<cfif isdefined('attributes.subscription_type') and len(attributes.subscription_type)> 
		AND SC.SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_type#">
	</cfif>
	<cfif isdefined('attributes.process_stage_type') and len(attributes.process_stage_type)> 
		AND SC.SUBSCRIPTION_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
	</cfif>
	<cfif session.ep.our_company_info.is_efatura>
		<cfif isdefined("attributes.is_einvoice") and attributes.is_einvoice eq 1>
			AND
			( 
				(C.USE_EFATURA = 1 AND C.EFATURA_DATE <= #attributes.invoice_date#) OR (CONS.USE_EFATURA = 1 AND CONS.EFATURA_DATE <= #attributes.invoice_date#)
			)
		<cfelseif isdefined("attributes.is_einvoice") and attributes.is_einvoice eq 0>
			AND
			( 
				(C.USE_EFATURA = 0 OR CONS.USE_EFATURA = 0 OR C.EFATURA_DATE > #attributes.invoice_date# OR CONS.EFATURA_DATE > #attributes.invoice_date#)
			)
		</cfif>
    </cfif>
    <cfif isdefined("attributes.subs_add_option") and len(attributes.subs_add_option)>
        AND SUBSCRIPTION_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subs_add_option#">
    </cfif>
		AND SPR.AMOUNT > 0
		AND SPR.QUANTITY > 0
	ORDER BY<!--- order by sırası değişmemeli cunku actionda çok satırlı işlemler buna göre değişiyor AE20060628 --->
    <cfif isDefined("is_group_inv")>
        <cfif isdefined("xml_sortby_subscription_no") and xml_sortby_subscription_no eq 1 and (isdefined("attributes.multi_sale_grup") and attributes.multi_sale_grup eq 1)>
            CONVERT(INT, LEFT(SUBSCRIPTION_NO, PATINDEX('%[^0-9]%', SUBSCRIPTION_NO+'z')-1)),
        </cfif>
        SC.INVOICE_CONSUMER_ID,
        SC.INVOICE_PARTNER_ID,
        SC.INVOICE_COMPANY_ID,
        SC.SUBSCRIPTION_ID,
		SPR.STOCK_ID,
		SPR.UNIT_ID,
		SPR.DETAIL,
		SPR.MONEY_TYPE,
		SPR.DISCOUNT
		<cfif isDefined("is_avg_price")>
			,SPR.AMOUNT
        </cfif>
    <cfelse>
        <cfif isdefined("xml_sortby_subscription_no") and xml_sortby_subscription_no>
            CONVERT(INT, LEFT(SUBSCRIPTION_NO, PATINDEX('%[^0-9]%', SUBSCRIPTION_NO+'z')-1)),
        </cfif>
        SPR.PAYMENT_DATE,
		SPR.SUBSCRIPTION_ID,
		SPR.PAYMETHOD_ID,
		SPR.CARD_PAYMETHOD_ID,
		SPR.MONEY_TYPE
	</cfif>
</cfquery>
<cfif isdefined("xml_min_total_value") and len(xml_min_total_value)>
    <cfquery name="get_min_value_control" dbtype="query">
        SELECT
            SUM(ROW_TOTAL + BSMV_AMOUNT) TOPLAM_TUTAR,
            INVOICE_CONSUMER_ID,
            INVOICE_PARTNER_ID,
            INVOICE_COMPANY_ID,
            <cfif attributes.multi_sale_grup eq 1>SUBSCRIPTION_ID<cfelse>''</cfif> SUBSCRIPTION_ID
            <cfif not isdefined("is_group_inv")>
                ,PAYMENT_DATE,
                PAYMETHOD_ID,
                CARD_PAYMETHOD_ID
            </cfif>
            ,<cfif isdefined("is_group_inv")>''<cfelse>MONEY_TYPE</cfif> MONEY_TYPE
        FROM 
            GET_PAYMENT_PLAN
        GROUP BY
            INVOICE_CONSUMER_ID,
            INVOICE_PARTNER_ID,
            INVOICE_COMPANY_ID,
            SUBSCRIPTION_ID
            <cfif not isdefined("is_group_inv")>
                ,PAYMENT_DATE,
                PAYMETHOD_ID,
                CARD_PAYMETHOD_ID
            </cfif>
            ,MONEY_TYPE
        HAVING 
            TOPLAM_TUTAR < #xml_min_total_value#
    </cfquery>
<!--- xml_min_total_value minimum faturalanacka tutar değerine göre satırları siler
    alternatif olarak checkboxlar disable yapıldı yöntem satırların gelmemesi olursa açılmalı
    <cfoutput query="GET_PAYMENT_PLAN">        
        <cfloop query="get_min_value_control">
            <cfif GET_PAYMENT_PLAN.INVOICE_CONSUMER_ID eq get_min_value_control.INVOICE_CONSUMER_ID
                AND GET_PAYMENT_PLAN.INVOICE_PARTNER_ID eq get_min_value_control.INVOICE_PARTNER_ID 
                AND GET_PAYMENT_PLAN.INVOICE_COMPANY_ID eq get_min_value_control.INVOICE_COMPANY_ID 
                AND GET_PAYMENT_PLAN.SUBSCRIPTION_ID eq get_min_value_control.SUBSCRIPTION_ID
                AND (
                    not isdefined("is_group_inv")
                    AND GET_PAYMENT_PLAN.PAYMENT_DATE eq get_min_value_control.PAYMENT_DATE
                    AND GET_PAYMENT_PLAN.PAYMETHOD_ID eq get_min_value_control.PAYMETHOD_ID
                    AND GET_PAYMENT_PLAN.CARD_PAYMETHOD_ID eq get_min_value_control.CARD_PAYMETHOD_ID
                    AND GET_PAYMENT_PLAN.MONEY_TYPE eq get_min_value_control.MONEY_TYPE
                ) >
                <cfset QueryDeleteRow(GET_PAYMENT_PLAN,GET_PAYMENT_PLAN.currentRow)>
            </cfif>
        </cfloop>
    </cfoutput>
--->
</cfif>
<cfform name="pay_plan_rows" method="post" action="#request.self#?fuseaction=invoice.emptypopupflush_add_sale_multi">
	<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#GET_MONEY_INFO.recordcount#</cfoutput>">
    <table align="center" width="99%">
        <tr>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57296.Kur Bilgisi"></cfsavecontent>
                <cf_box closable="0" title="#message#">
                	<div class="col col-12 scrollContent scroll-x2">
                    <table>
                        <cfoutput query="GET_MONEY_INFO">
                            <tr>
                                <cfif xml_other_money eq 4>
                                    <td><input type="radio" name="select_money_type" id="select_money_type" <cfif not isdefined("attributes.select_money_type") and session.ep.money eq GET_MONEY_INFO.MONEY>checked="checked"<cfelseif isdefined("attributes.select_money_type") and attributes.select_money_type eq GET_MONEY_INFO.MONEY>checked="checked"</cfif>  value="#GET_MONEY_INFO.MONEY#"></td>
                                </cfif>
                                <td>#GET_MONEY_INFO.MONEY#</td>
                                <td><input type="hidden" name="money_type_#currentrow#" id="money_type_#currentrow#" value="#GET_MONEY_INFO.MONEY#">
                                    <input type="hidden" name="money_rate1_#currentrow#" id="money_rate1_#currentrow#" value="#GET_MONEY_INFO.RATE1#">
                                      <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#GET_MONEY_INFO.money#">
                                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#GET_MONEY_INFO.RATE1#">
                                    <input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#"  value="<cfif GET_MONEY_INFO.MONEY eq session.ep.money>#tlformat(1,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(GET_MONEY_INFO.RATE2_,session.ep.our_company_info.rate_round_num)#</cfif>">
                                  
                                    <cfsavecontent variable="mesage"><cf_get_lang dictionary_id ='57353.Kur Giriniz'></cfsavecontent>
                                    <input type="text" name="money_rate2_#currentrow#" id="money_rate2_#currentrow#" style="width:65px;" required="yes" value="<cfif GET_MONEY_INFO.MONEY eq session.ep.money>#tlformat(1,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(GET_MONEY_INFO.RATE2_,session.ep.our_company_info.rate_round_num)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" message="#mesage#" <cfif GET_MONEY_INFO.MONEY eq session.ep.money>readonly</cfif>>
                                </td>
                            </tr>
                        </cfoutput>
                    </table>
                    </div>
                </cf_box>
            </td>
        </tr>
    </table>
	<cfoutput>
        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
        <input type="hidden" name="invoice_date" id="invoice_date" value="#attributes.invoice_date#">
        <input type="hidden" name="start_date" id="start_date" value="#attributes.start_date#">
        <input type="hidden" name="finish_date" id="finish_date" value="#attributes.finish_date#">
        <input type="hidden" name="process_cat" id="process_cat" value="#attributes.process_cat#">
        <input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
        <input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
        <input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
        <input type="hidden" name="payment_type_id" id="payment_type_id" value="#attributes.payment_type_id#">
        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#attributes.card_paymethod_id#">
        <input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
        <input type="hidden" name="xml_paper_no_info" id="xml_paper_no_info" value="#xml_paper_no_info#">
        <input type="hidden" name="xml_money_type" id="xml_money_type" value="#xml_money_type#">
        <input type="hidden" name="xml_other_money" id="xml_other_money" value="#xml_other_money#">
        <input type="hidden" name="form_is_einvoice" id="form_is_einvoice" value="#attributes.is_einvoice#">
        <input type="hidden" name="multi_sale_grup" id="multi_sale_grup" value="#attributes.multi_sale_grup#">
        <cfif isDefined("is_group_inv")>
            <input type="hidden" name="is_group_inv" id="is_group_inv" value="1">
            <cfif isDefined("is_avg_price")><input type="hidden" name="is_avg_price" id="is_avg_price"></cfif>
            <input type="hidden" name="cons_id" id="cons_id" value="#attributes.cons_id#">
            <input type="hidden" name="par_id" id="par_id" value="#attributes.par_id#">
            <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
            <input type="hidden" name="comp_name" id="comp_name" value="#attributes.comp_name#">
            <input type="hidden" name="pay_due_day" id="pay_due_day" value="<cfif isdefined('attributes.pay_due_day') and len(attributes.pay_due_day)>#attributes.pay_due_day#</cfif>" />
        </cfif>
        <!--- xml parametreleri --->
        <input name="xml_multi_invoice_row" id="xml_multi_invoice_row" type="hidden" value="#xml_multi_invoice_row#">
    </cfoutput>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58917.Faturalar"></cfsavecontent>
    <cf_box title="#message#">
        <cfif xml_multi_invoice_row eq 1 or isdefined('attributes.is_group_inv')>
            <cfif GET_PAYMENT_PLAN.recordcount>
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><input type="checkbox" name="hepsi" id="hepsi" value="1" onclick="check_all(this.checked);" checked></th>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                            <th><cf_get_lang dictionary_id='59774.Sistem No'></th>
                            <th><cf_get_lang dictionary_id='58832.Abone'></th>
                            <th><cf_get_lang dictionary_id='57416.Proje'></th>
                            <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                            <th><cf_get_lang dictionary_id='57636.Birim'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th><cf_get_lang dictionary_id='57489.Para Br'></th>
                            <cfif isDefined("is_group_inv")>
                                <th><cf_get_lang dictionary_id='57648.Kur'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
                            <th><cf_get_lang dictionary_id='57641.İskonto'> <cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th><cf_get_lang dictionary_id='57641.İskonto'> %</th>
                            <th><cf_get_lang dictionary_id='57642.Net Toplam'></th>
                        </tr>
                    </thead>
                    <input name="all_records" id="all_records" type="hidden" value="<cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>">
                    <tbody>
                        <cfset paymethod_comp = createObject("component","cfc.paymethod_calc")>
                        <cfoutput query="GET_PAYMENT_PLAN">
                            <cfset row_readonly=0>
                            <cfif isdefined("xml_min_total_value") and len(xml_min_total_value)>
                                <cfloop query="get_min_value_control">
                                    <cfif not isdefined("is_group_inv")>
                                        <cfif GET_PAYMENT_PLAN.INVOICE_CONSUMER_ID eq get_min_value_control.INVOICE_CONSUMER_ID
                                            AND GET_PAYMENT_PLAN.INVOICE_PARTNER_ID eq get_min_value_control.INVOICE_PARTNER_ID 
                                            AND GET_PAYMENT_PLAN.INVOICE_COMPANY_ID eq get_min_value_control.INVOICE_COMPANY_ID 
                                            AND GET_PAYMENT_PLAN.SUBSCRIPTION_ID eq get_min_value_control.SUBSCRIPTION_ID
                                            AND GET_PAYMENT_PLAN.PAYMENT_DATE eq get_min_value_control.PAYMENT_DATE
                                            AND GET_PAYMENT_PLAN.PAYMETHOD_ID eq get_min_value_control.PAYMETHOD_ID
                                            AND GET_PAYMENT_PLAN.CARD_PAYMETHOD_ID eq get_min_value_control.CARD_PAYMETHOD_ID
                                            AND GET_PAYMENT_PLAN.MONEY_TYPE eq get_min_value_control.MONEY_TYPE
                                            >
                                            <cfset row_readonly=1>
                                        </cfif>
                                    <cfelse>
                                        <cfif GET_PAYMENT_PLAN.INVOICE_CONSUMER_ID eq get_min_value_control.INVOICE_CONSUMER_ID
                                            AND GET_PAYMENT_PLAN.INVOICE_PARTNER_ID eq get_min_value_control.INVOICE_PARTNER_ID 
                                            AND GET_PAYMENT_PLAN.INVOICE_COMPANY_ID eq get_min_value_control.INVOICE_COMPANY_ID 
                                            AND GET_PAYMENT_PLAN.SUBSCRIPTION_ID eq get_min_value_control.SUBSCRIPTION_ID
                                            >
                                            <cfset row_readonly=1>
                                        </cfif>
                                    </cfif>
                                </cfloop>
                            </cfif>
                             <cfif COMPANY_STATUS EQ 0 or CONSUMER_STATUS EQ 0>
								<cfset row_readonly=1>
								<tr style="background-color:##FFFF00">
							<cfelse>
								<tr>
							</cfif>
                                <cfif row_readonly>
                <!---                    <input type="hidden" name="bsmv_rate#currentrow#" id="bsmv_rate#currentrow#" value="#BSMV_RATE#"> 
                                    <input type="hidden" name="bsmv_amount#currentrow#" id="bsmv_amount#currentrow#" value="#BSMV_AMOUNT#">
                                    <input type="hidden" name="oiv_rate#currentrow#" id="oiv_rate#currentrow#" value="#OIV_RATE#">
                                    <input type="hidden" name="oiv_amount#currentrow#" id="oiv_amount#currentrow#" value="#OIV_AMOUNT#">
                                    <input type="hidden" name="tevkifat_rate#currentrow#" id="tevkifat_rate#currentrow#" value="#TEVKIFAT_RATE#">
                                    <input type="hidden" name="tevkifat_amount#currentrow#" id="tevkifat_amount#currentrow#" value="#TEVKIFAT_AMOUNT#">
                                    <input type="hidden" name="reason_code#currentrow#" id="reason_code#currentrow#" value="#reason_code#">
                                
                                    <input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
                                    <input type="hidden" name="income_item_id#currentrow#" id="income_item_id#currentrow#" value="#income_item_id#">
                                    <input type="hidden" name="income_activity_type_id#currentrow#" id="income_activity_type_id#currentrow#" value="#income_activity_type_id#">
                --->
                                </cfif>
                                <td width="15"><input type="checkbox" name="payment_row#currentrow#" id="payment_row#currentrow#" value="#SUBSCRIPTION_PAYMENT_ROW_ID#" <cfif row_readonly eq 1>disabled<cfelse>checked</cfif>></td>
                                <td>#currentrow#</td>
                                <td>#dateformat(PAYMENT_DATE,dateformat_style)#</td>
                                <td>#SUBSCRIPTION_NO#</td>                              
								<td>
								<cfif len(consumer_id)>
									#cons_name#
									<input type="hidden" name="subs_name#currentrow#" id="subs_name#currentrow#" value="#cons_name#">
								<cfelse>
									<cfif len(company_id)>#FULLNAME#</cfif>
									<cfif len(partner_id)>  - #partner_name#</cfif>
									<input type="hidden" name="subs_name#currentrow#" id="subs_name#currentrow#" value="#FULLNAME#">
								</cfif>
									</td>
                                <td><cfif len(PROJECT_ID)>#project_head#</cfif></td>
                                <td><cfif len(pay_method_name)>#pay_method_name#<cfelseif len(CARD_PAYMETHOD_NAME)>#CARD_PAYMETHOD_NAME#</cfif></td>
                                <td>#DETAIL#</td>
                                <cfif not len(ACCOUNT_CODE)><!--- or (DISCOUNT_AMOUNT gt 0 and not len(ACCOUNT_DISCOUNT))--->
                                    <td colspan="4" style="background-color:##FFFF00"><cf_get_lang dictionary_id='57731.Satırdaki Ürünün Muhasebe Kodu Tanımlanmamış'></td>
                                <cfelse>
                                    <td>#UNIT#</td>
                                    <td>#QUANTITY#</td>
                                    <td style="text-align:right;">#TLFormat(AMOUNT)#</td>
                                    <td>#MONEY_TYPE#</td>
                                </cfif>
                                <cfif isDefined("is_group_inv")>
                                    <td style="text-align:right;">#tlFormat(rate)#</td>
                                </cfif>
                                <td style="text-align:right;">#TLFormat(ROW_TOTAL)#</td>
                                <td style="text-align:right;"><cfif len(DISCOUNT_AMOUNT)>#TLFormat(DISCOUNT_AMOUNT)#<cfelse>#tlformat(0)#</cfif></td>
                                <td style="text-align:right;">#TLFormat(DISCOUNT)#</td>
                                <td style="text-align:right;">#TLFormat(ROW_NET_TOTAL)#</td>
                                <cfif isDefined("is_group_inv")>
                                    <input type="hidden" name="row_subscription_id#currentrow#" id="row_subscription_id#currentrow#" value="#SUBSCRIPTION_ID#">
                                    <input type="hidden" name="row_company_id#currentrow#" id="row_company_id#currentrow#" value="#INVOICE_COMPANY_ID#">
                                    <input type="hidden" name="row_consumer_id#currentrow#" id="row_consumer_id#currentrow#" value="#INVOICE_CONSUMER_ID#">
                                    <input type="hidden" name="row_partner_id#currentrow#" id="row_partner_id#currentrow#" value="#INVOICE_PARTNER_ID#">
                                    <!---
                                    <input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
                                    <input type="hidden" name="product_name#currentrow#" id="product_name#currentrow#" value="#DETAIL#">
                                    --->
                                    <input type="hidden" name="money_type#currentrow#" id="money_type#currentrow#" value="#MONEY_TYPE#">
                                    <!---<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#UNIT_ID#">
                                    <input type="hidden" name="discount#currentrow#" id="discount#currentrow#" value="#DISCOUNT#">
                                    <input type="hidden" name="amount#currentrow#" id="amount#currentrow#" value="#AMOUNT#">
                                    --->
                                    <input type="hidden" name="rate#currentrow#" id="rate#currentrow#" value="#rate#">
                                </cfif>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="7"><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></b></td>
                            <td colspan="10">
                                <cfquery name="GET_TOTAL" dbtype="query">
                                    SELECT 
                                        SUM(ROW_NET_TOTAL) TOTAL,
                                        MONEY_TYPE
                                    FROM 
                                        GET_PAYMENT_PLAN
                                    GROUP BY
                                        MONEY_TYPE
                                </cfquery>
                                <cfoutput query="GET_TOTAL">
                                    <b>#TLFormat(TOTAL)# #MONEY_TYPE#</b>&nbsp;&nbsp;&nbsp;
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="17" style="text-align:right;">
                                <cfif isDefined("is_group_inv")>
                                    <cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>
                                    <input type="hidden" name="inv_card_paymethod_id" id="inv_card_paymethod_id" value="<cfif len(attributes.card_paymethod_id)><cfoutput>#attributes.card_paymethod_id#</cfoutput></cfif>" />
                                    <input type="hidden" name="inv_payment_type_id" id="inv_payment_type_id" value="<cfif len(attributes.payment_type_id)><cfoutput>#attributes.payment_type_id#</cfoutput></cfif>" />
                                    <input type="hidden" name="inv_pay_due_day" id="inv_pay_due_day" value="<cfif len(attributes.pay_due_day)><cfoutput>#attributes.pay_due_day#</cfoutput></cfif>" />
                                    <input type="text" name="inv_payment_type" id="inv_payment_type" value="<cfif len(attributes.payment_type)><cfoutput>#attributes.payment_type#</cfoutput></cfif>" style="width:150px;" onkeyup="pay_plan_rows.inv_payment_type_id.value='';pay_plan_rows.inv_card_paymethod_id.value=''" />
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=pay_plan_rows.inv_payment_type_id&field_name=pay_plan_rows.inv_payment_type&field_card_payment_id=pay_plan_rows.inv_card_paymethod_id&field_card_payment_name=pay_plan_rows.inv_payment_type&field_dueday=pay_plan_rows.inv_pay_due_day','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                    &nbsp;&nbsp;
                                </cfif>
                                <div class="form-group">
                                    <cf_workcube_buttons is_upd='0' insert_info = 'Fatura Oluştur' add_function='input_control()' type_format="1">
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </cf_grid_list>
            <cfelse>
                <cf_grid_list>
                    <tbody>
                        <tr>
                            <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </cfif>
        <cfelse>
            <input name="all_records" id="all_records" type="hidden" value="<cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>">
            <cf_grid_list>
                <cfquery name="get_total_row" dbtype="query">
                    SELECT SUM(ROW_NET_TOTAL) AS TOPLAM_TUTAR,MONEY_TYPE FROM get_payment_plan GROUP BY MONEY_TYPE
                </cfquery>
                <cfquery name="get_total_invoice_count" dbtype="query">
                    SELECT 
                        COUNT(SUBSCRIPTION_PAYMENT_ROW_ID) 
                    FROM 
                        get_payment_plan 
                    GROUP BY 
                        PAYMENT_DATE,
                        PAYMETHOD_ID,
                        CARD_PAYMETHOD_ID,
                        MONEY_TYPE,
                        INVOICE_COMPANY_ID,
                        INVOICE_CONSUMER_ID
                        <cfif attributes.multi_sale_grup eq 1>
                            ,SUBSCRIPTION_ID
                        </cfif>
                        <!---<cfif len(get_payment_plan.COMPANY_ID)>
                            ,COMPANY_ID
                        <cfelseif len(get_payment_plan.CONSUMER_ID)>
                            ,CONSUMER_ID
                        <cfelse>
                            ,SUBSCRIPTION_ID
                        </cfif>--->
                </cfquery>
                <tr>
                    <td width="200" class="txtboldblue"><cf_get_lang dictionary_id="48811.Toplam Satır Sayısı"> :</td> 
                    <td><cfoutput>#get_payment_plan.recordcount#</cfoutput></td>
                </tr>
                <tr>
                    <td width="200" class="txtboldblue"><cf_get_lang dictionary_id="48809.Toplam Fatura Sayısı"> :</td> 
                    <td><cfoutput>#get_total_invoice_count.recordcount#</cfoutput></td>
                </tr>
                <cfif get_total_row.recordcount>
                    <tr>
                        <td width="200" class="txtboldblue" valign="top"><cf_get_lang dictionary_id="29534.Toplam Tutar"> :</td> 
                        <td><cfoutput query="get_total_row">
                                #TLFormat(toplam_tutar)# #money_type#<br />
                            </cfoutput>
                        </td>
                    </tr>
                </cfif>
                <tr>
                    <td colspan="2" style="text-align:right;">
                        <cf_workcube_buttons is_upd='0' insert_info = 'Fatura Oluştur' add_function='input_control()' type_format="1">
                    </td>
                </tr>   
            </cf_grid_list>  
        </cfif>
    </cf_box>
</cfform>
<script type="text/javascript">
function check_all(deger)
{
	<cfif GET_PAYMENT_PLAN.recordcount >
		if(pay_plan_rows.hepsi.checked)
		{
			for (var i=1; i <= <cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>; i++)
			{
                var form_field = eval("document.pay_plan_rows.payment_row" + i);
                if(form_field.disabled == false)
                    form_field.checked = true;
                else
                    form_field.checked = false;
				//eval('pay_plan_rows.payment_row'+i).focus();
			}
		}
		else
		{
			for (var i=1; i <= <cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>; i++)
			{
                form_field = eval("document.pay_plan_rows.payment_row" + i);
			    form_field.checked = false;
				//eval('pay_plan_rows.payment_row'+i).focus();
			}				
		}
	</cfif>
}
</script>
</cfif>
<script type="text/javascript">
function kurGetir(obj,form_name_info){
    <cfif attributes.open_form eq 1>
    <cfif isdefined("session.ep.our_company_info.rate_round_num")>
        rate_round = <cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>;
    <cfelse>
        rate_round = 4;
    </cfif>
    var rate_type = <cfoutput>#xml_money_type#</cfoutput>;
    var validate_date = js_date(obj.value);
	var get_money_info = wrk_safe_query("js_get_money_info",'dsn',0,validate_date);
    if(get_money_info.recordcount){
        for(var mon_i=0;mon_i<get_money_info.recordcount; mon_i++){
            for(var j=1;j<=eval(form_name_info + '.kur_say').value;j++){
                if(get_money_info.MONEY_TYPE[mon_i] == eval(form_name_info + '.hidden_rd_money_' + j).value)
                {
                    eval(form_name_info + '.txt_rate1_' + j).value = commaSplit(get_money_info.RATE1[mon_i],rate_round);
                    if(rate_type!= undefined)
                    {
                        if(rate_type == 1)
                            eval(form_name_info + '.money_rate2_' + j).value = eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE3[mon_i],rate_round);
                        else if(rate_type == 3)
                            eval(form_name_info + '.money_rate2_' + j).value = eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.EFFECTIVE_PUR[mon_i],rate_round);
                        else if(rate_type == 4)
                            eval(form_name_info + '.money_rate2_' + j).value = eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.EFFECTIVE_SALE[mon_i],rate_round);
                        else
                            eval(form_name_info + '.money_rate2_' + j).value = eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE2[mon_i],rate_round);
                    }
                    else
                        eval(form_name_info + '.money_rate2_' + j).value = eval(form_name_info + '.txt_rate2_' + j).value = commaSplit(get_money_info.RATE2[mon_i],rate_round);
                }
            }
        }
    }
    <cfelse>
        return true;
    </cfif>
}

function kontrol()
{
	try
	{
		<cfif session.ep.our_company_info.is_efatura>
			if(document.getElementById('is_einvoice').value == '')
			{
				alert("<cf_get_lang dictionary_id='59814.E-Fatura Tipi Seçiniz'>!");
				return false;
			}
		</cfif>
		if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(document.getElementById('department_id').value=="" || document.getElementById('department_name').value=="")
		{
			alert("<cf_get_lang dictionary_id='57284.Depo Seçiniz'>!");
			return false;
		}
		//if(document.getElementById('is_group_inv').checked && (document.getElementById('company_id').value == "" && document.getElementById('cons_id').value==""))
		//{
			//alert("<cf_get_lang no='181.Cari Hesap Seçiniz'>!");
			//return false;
		//}
		
		document.form_basket.open_form.value = 1;
       $('#open_form').value("1");
	}
	catch(any)
	{
		if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if(document.getElementById('department_id').value=="" || document.getElementById('department_name').value=="")
		{
			alert("<cf_get_lang dictionary_id='57284.Depo Seçiniz'>!");
			return false;
		}
		//if(document.getElementById('is_group_inv').checked && (document.getElementById('company_id').value == "" && document.getElementById('cons_id').value==""))
		//{
			//alert("<cf_get_lang no='181.Cari Hesap Seçiniz'>!");
			//return false;
		//}
		document.form_basket.open_form.value = 1;
        $('#open_form').value("1");
	}
	return true;
}
function ayarla_gizle_goster()
{
	if(form_basket.is_group_inv.checked)
	{
		cari_sec1.style.display='';
		cari_sec2.style.display='';
	}
	else
	{
		document.getElementById('is_einvoice').disabled=false;
		document.getElementById('is_einvoice').value="";
		document.getElementById('company_id').value="";
		document.getElementById('comp_name').value="";
		document.getElementById('cons_id').value="";
		cari_sec1.style.display='none';
		cari_sec2.style.display='none';
	}
}
function input_control()
{
	<cfif xml_multi_invoice_row eq 1>
		var checked_info = false;
		var toplam = document.pay_plan_rows.all_records.value;
		for(var i=1; i<=toplam; i++)
		{
			if(eval('pay_plan_rows.payment_row'+i).checked){
				checked_info = true;
				i = toplam+1;
			}
		}
		if(!checked_info)
		{
			alert("<cf_get_lang dictionary_id='57280.Seçim Yapınız'>!");
			return false;
		}
	<cfelse>
		if(document.getElementById('all_records').value == 0)
		{
			alert("<cf_get_lang dictionary_id='57280.Seçim Yapınız'>!");
			return false;	
		}
	</cfif>
	// grup faturalamada farklı kurlara ait satirlarin faturalanmasi
	<cfif xml_diff_rate eq 0 or xml_diff_rate eq 2>
		var checked_rate = false;
		for(var i=1; i<=document.getElementById("all_records").value; i++)
		{
			if(document.getElementById("payment_row"+i).checked)
			{
				if(document.getElementById("rate"+i).value.length == 0) 
					rate_row = filterNum(commaSplit(0,4),4); 
				else 
					rate_row = filterNum(commaSplit(document.getElementById("rate"+i).value,4),4);
				if(first_rate != undefined && first_rate != rate_row)
				{
					checked_rate = true;
				}
				var first_rate = rate_row;
			}
		}
		<cfif xml_diff_rate eq 0>
			if(checked_rate)
			{
				alert("<cf_get_lang dictionary_id='59857.Farklı Kurlara Ait Satırlar Fatura Edilemez'>!");
				return false;
			}
		<cfelse>
			if(checked_rate)
				alert("<cf_get_lang dictionary_id='59858.Farklı Kurlara Ait Satırlar Mevcut'>!");
		</cfif>
	</cfif>
	// grup faturalamada farklı işlem dövizine ait satirlarin faturalanmasi
	<cfif xml_diff_money eq 0 or xml_diff_money eq 2>
		var checked_money = false;
		for(var j=1; j<=document.getElementById("all_records").value; j++)
		{
			if(document.getElementById("payment_row"+j).checked)
			{
				if(first_money != undefined && first_money != document.getElementById("money_type"+j).value)
					checked_money = true;	
				var first_money = document.getElementById("money_type"+j).value;
			}
		}
		<cfif xml_diff_money eq 0>
			if(checked_money)
			{
				alert("<cf_get_lang dictionary_id='59859.Farklı İşlem Dövizine Ait Satırlar Fatura Edilemez'>!");
				return false;
			}
		<cfelse>
			if(checked_money)
				alert("<cf_get_lang dictionary_id='59860.Farklı İşlem Dövizine Ait Satırlar Mevcut'>!");
		</cfif>
	</cfif>
	
	if(document.pay_plan_rows.kur_say.value == 0)
	{
		alert("<cf_get_lang dictionary_id='57301.Kur Bilgisi Giriniz'>!");
		return false;
	}
	<cfoutput query="get_money_info">
		var temp_control_rate =#get_money_info.rate2/get_money_info.rate1#;
		var temp_basket_rate2_ = filterNum(document.all.money_rate2_#currentrow#.value)/filterNum(document.all.money_rate1_#currentrow#.value);
		if(temp_basket_rate2_ > ((temp_control_rate/100)*250) ) // belge geri donuslerindeki kur dagılmalarını engellemek icin rate2 artısları kontrol ediliyor
		{
			alert('#get_money_info.money# <cf_get_lang dictionary_id="59861.Kur Bilgisinde %100 den Fazla Artış Var">');
			return false;
		}
	</cfoutput>	
	
	<cfif xml_group_inv_paymethod eq 1>
		if(form_basket.is_group_inv.checked && pay_plan_rows.inv_card_paymethod_id.value == "" && pay_plan_rows.inv_payment_type_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='58027.Lütfen Ödeme Yöntemi Seçiniz '>!");
			return false;
		}
	</cfif>
	if(document.getElementById('is_einvoice') != undefined)
	{
		document.getElementById('is_einvoice').disabled=false;
		if(document.getElementById('is_einvoice').value == 1)
            document.getElementById('form_is_einvoice').value = 1;
        else if(document.getElementById('is_einvoice').value == 2)
			document.getElementById('form_is_einvoice').value = 2;
		else
			document.getElementById('form_is_einvoice').value = 0;
	}
	
	unformat_fields();
	
	return true;
}
function unformat_fields()
{
    <cfif isdefined("GET_MONEY_INFO.recordcount")>
	for(var i=1; i<=<cfoutput>#GET_MONEY_INFO.recordcount#</cfoutput>; i++)
	{
		eval('pay_plan_rows.money_rate2_'+i).value = filterNum(eval('pay_plan_rows.money_rate2_'+i ).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
    }
    </cfif>
}
function kontrol_efatura()
{
    <cfif session.ep.our_company_info.is_efatura>
        if(document.getElementById('is_einvoice').value != 2){
            if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
                var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
            else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
                var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
            if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
            {
                document.getElementById('is_einvoice').value=1;
                document.getElementById('is_einvoice').disabled=true;
            }	
            else if(get_member_control != undefined && get_member_control.USE_EFATURA == 0 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
            {
               document.getElementById('is_einvoice').value=0;
               document.getElementById('is_einvoice').disabled=false;
            }
        }
	</cfif>	
}
if(document.getElementById('is_group_inv').checked == true)
    kontrol_efatura();
</script>

