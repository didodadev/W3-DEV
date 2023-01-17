<!--- Bu sayfanin action sayfası Dore firmasi icin add_options da calismaktadir. BK 20101015 --->
<cf_xml_page_edit fuseact ="bank.popup_add_autopayment_export">
<cfparam name="attributes.start_date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.bank_name" default="">
<cfparam name="attributes.open_form" default="0">
<cfparam name="attributes.pay_method" default="">
<cfparam name="attributes.card_pay_method" default="">
<cfparam name="attributes.prov_period" default="#session.ep.period_year#;#session.ep.company_id#;#session.ep.period_id#">
<!--- fatura ödeme planı için oluşturuldu. --->
<cfparam name="attributes.source" default="1">
<cfparam name="attributes.document_status" default="0">
<cfparam name="attributes.money_type" default="">
<cfparam name="attributes.bank" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfif attributes.open_form eq 0><cfset attributes.status = 1></cfif>
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="GET_PAY_METHOD" datasource="#DSN3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE ORDER BY CARD_NO
</cfquery>
<cfquery name="GET_S_PAY_METHOD" datasource="#DSN#">
	SELECT 
		SP.PAYMETHOD,
		SP.PAYMETHOD_ID 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_PERIODS" datasource="#DSN#">
	SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID,PERIOD FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<cfif is_file_from_manuelpaper eq 1>
	<cfset action_url_info = "#request.self#?fuseaction=bank.emptypopupflush_add_autopayment_export#xml_str#">
<cfelse>
	<cfset action_url_info = "">
</cfif>

<cf_box title="#getLang('','otomatik ödeme işlemleri','48875')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#" id="add_autopayments">
    <cfform name="add_autopaym" method="post" action="#action_url_info#">
        <cf_basket_form id="add_form">
            <input type="hidden" name="open_form" id="open_form" value="<cfoutput>#attributes.open_form#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-source">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48799.Kaynak'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="source" id="source" onChange="display_();">
                                <option value="1" <cfif attributes.source eq 1>selected</cfif>><cf_get_lang dictionary_id='50014.Sistem Ödeme Planı'></option>
                                <option value="2" <cfif attributes.source eq 2>selected</cfif>><cf_get_lang dictionary_id='57140.Fatura Ödeme Planı'></option>
                            </select>                            	
                        </div>
                    </div>
                    <div class="form-group" id="cari_" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group" id="cari_2" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                                <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                <input type="text" name="company" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,MEMBER_TYPE','company_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=add_autopaym.company&field_comp_id=add_autopaym.company_id&field_member_name=add_autopaym.company&field_name=add_autopaym.company&field_type=add_autopaym.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2</cfoutput>&keyword='+encodeURIComponent(document.add_autopaym.company.value),'list')" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></span>                         	
                            </div>
                        </div>
                    </div>                         
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <!---<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'> !</cfsavecontent>--->
                                <cfinput type="text" name="start_date"  required="Yes" value="#attributes.start_date#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                             
                            
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="finish_date"  required="Yes" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"> </span> 
                            </div>
                        </div>
                    </div>
                    <div id="money_" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                        <div class="form-group" id="item-money_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                            
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="money_2" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                                    <cfinclude template="../query/get_money_rate.cfm">
                                    <select name="money_type" id="money_type">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_money_rate">
                                            <option value="#money#" <cfif attributes.money_type eq money>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                           
                        </div> 
                        </div> 
                        <cfif (session.ep.admin or get_module_power_user(19)) and is_show_related_inv_period eq 1><!--- sadece yıl sonunda ve pronet için uzman bilgisinde yapılması gerektigi icin admine bağlanmıstır...Aysenur200614  ayrıca xml kontrolü de eklendi--->              
                            <div id="inv_period_" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                            <div class="form-group" id="item-prov_period">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48956.İlişkili Fatura Dönemi'></label>
                                <div id="inv_period_2" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="prov_period" id="prov_period" style="width:150px;">
                                        <cfoutput query="get_periods">
                                            <option value="#period_year#;#our_company_id#;#period_id#" <cfif attributes.prov_period eq "#period_year#;#our_company_id#;#period_id#">selected</cfif>>#period# - (#period_year#)</option>
                                        </cfoutput>
                                    </select>                                
                                </div>
                                </div>
                            </div> 
                            </div>                     	
                            </cfif>
                    </div>
                                <div id="document_" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                                    <div class="form-group" id="item-document_status">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="document_2" <cfif attributes.source eq 1>style="display:none;"</cfif>>                         	 
                                            <select name="document_status" id="document_status">
                                                <option value="-1"><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="1" <cfif attributes.document_status eq 1>selected</cfif>><cf_get_lang dictionary_id='59184.Oluşturuldu'></option>
                                                <option value="0" <cfif attributes.document_status eq 0>selected</cfif>><cf_get_lang dictionary_id='59185.Oluşturulmadı'></option>
                                            </select>                             	
                                        </div>
                                </div> 
                                <div id="bank_" <cfif attributes.source eq 1>style="display:none;"</cfif>>              
                                    <div class="form-group" id="item-bank">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48695.Banka Adı'> *</label>
                                        
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"id="bank_2" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                                            <select name="bank" id="bank" onChange="set_bank_paymethod(this.value);">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_bank_names">
                                                    <option value="#bank_id#" <cfif attributes.bank eq bank_id>selected</cfif>>#bank_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div id="status_" <cfif attributes.source eq 1>style="display:none;"</cfif>>                  	
                                    <div class="form-group" id="item-status">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48808.İptal Edilenler Gönderilsin'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" >
                                            <input type="checkbox" name="status" id="status" value="1" <cfif isDefined("attributes.status") and attributes.status eq 1>checked</cfif>>
                                        </div>
                                    </div> 
                                </div> 

                                             	       
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-pay_method">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="pay_method" id="pay_method"  multiple="multiple">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif attributes.source eq 1>
                                    <cfoutput query="get_s_pay_method">
                                        <option value="#paymethod_id#" <cfif listfind(attributes.pay_method,get_s_pay_method.paymethod_id,',')>selected</cfif>>#paymethod#</option>
                                    </cfoutput>
                                <cfelse>
                                    <cfif isdefined("attributes.bank") and len(attributes.bank)>
                                        <cfquery name="get_dbs_paymethod" datasource="#dsn#">
                                            SELECT 
                                                SP.PAYMETHOD,
                                                SP.PAYMETHOD_ID 
                                            FROM 
                                                SETUP_PAYMETHOD SP,
                                                SETUP_PAYMETHOD_OUR_COMPANY SPOC
                                            WHERE 
                                                SP.BANK_ID = #attributes.bank#
                                                AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
                                                AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                        </cfquery>
                                    </cfif>
                                    <cfoutput query="get_dbs_paymethod">
                                        <option value="#paymethod_id#" <cfif listfind(attributes.pay_method,get_dbs_paymethod.paymethod_id,',')>selected</cfif>>#paymethod#</option>
                                    </cfoutput>
                                </cfif>
                            </select>		                            	
                        </div>
                        </div>
                        <div id="pos_" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                        <div class="form-group" id="item-bank_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='39615.Pos Tipi'> *</label>
                            
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="pos_2" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                                    <select name="bank_name" id="bank_name">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="17" <cfif attributes.bank_name eq 17>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
                                        <option value="20" <cfif attributes.bank_name eq 20>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
                                        <option value="11" <cfif attributes.bank_name eq 11>selected</cfif>><cf_get_lang dictionary_id="48765.Finansbank"></option>
                                        <option value="21" <cfif attributes.bank_name eq 21>selected</cfif>><cf_get_lang dictionary_id="48776.Fortis"></option>
                                        <option value="13" <cfif attributes.bank_name eq 13>selected</cfif>><cf_get_lang dictionary_id="57717.Garanti"></option>
                                        <option value="23" <cfif attributes.bank_name eq 23>selected</cfif>><cf_get_lang dictionary_id = "42726.Halkbank"></option>
                                        <option value="10" <cfif attributes.bank_name eq 10>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
                                        <option value="24" <cfif attributes.bank_name eq 24>selected</cfif>><cf_get_lang dictionary_id = "51519.Odeabank"></option>
                                        <option value="12" <cfif attributes.bank_name eq 12>selected</cfif>><cf_get_lang dictionary_id="48730.İşBankası"></option>
                                        <option value="14" <cfif attributes.bank_name eq 14>selected</cfif>><cf_get_lang dictionary_id="48766.OyakBank"></option>
                                        <option value="18" <cfif attributes.bank_name eq 18>selected</cfif>><cf_get_lang dictionary_id="48771.PTT"></option>
                                        <option value="25" <cfif attributes.bank_name eq 25>selected</cfif>><cf_get_lang dictionary_id = "51551.Şekerbank"></option>
                                        <option value="15" <cfif attributes.bank_name eq 15>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
                                        <option value="22" <cfif attributes.bank_name eq 22>selected</cfif>><cf_get_lang dictionary_id="48760.Vakıf Bank"></option>
                                        <option value="16" <cfif attributes.bank_name eq 16>selected</cfif>><cf_get_lang dictionary_id="48784.YKB"></option>
                                        <option value="19" <cfif attributes.bank_name eq 19>selected</cfif>><cf_get_lang dictionary_id="48774.Ziraat Bankası"></option>
                                    </select>
                                </div>
                                
                            </div>
                            </div>
                        </div>  
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                    <div id="credit_card_" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                        <div class="form-group" id="item-card_pay_method">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54853.Kredi Kartı Ödeme Yöntemi'></label>
                            <div id="credit_card_2" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="card_pay_method" id="card_pay_method" multiple="multiple">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_pay_method">
                                            <option value="#payment_type_id#" <cfif listfind(attributes.card_pay_method,get_pay_method.payment_type_id,',')> selected</cfif>>#card_no#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div> 
                    </div> 
                    
                   
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                <!---<cfsavecontent variable="message"><cf_get_lang_main no='1303.Listele'></cfsavecontent>--->
                <cf_workcube_buttons insert_info='#getLang('main',1303)#' add_function='kontrol()' is_cancel='0'>                        
                </div>  
            </cf_box_footer>   
        </cf_basket_form>
    </cfform>
</cf_box>
<!--- sistem ödeme planı satirlarini getirir. --->
<cfif attributes.open_form eq 1 and attributes.source eq 1>
	<cf_date tarih='attributes.start_date'>
	<cf_date tarih='attributes.finish_date'>
    <cfquery name="get_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID,
            PERIOD_YEAR,
            OUR_COMPANY_ID 
        FROM 
            SETUP_PERIOD 
        WHERE 
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            <cfif isDefined("attributes.prov_period") and len(attributes.prov_period) and is_show_related_inv_period eq 1>
				AND PERIOD_ID = #listlast(attributes.prov_period,';')#
			</cfif>
         ORDER BY 
         	PERIOD_YEAR DESC
   	</cfquery>
    <cfquery name="GET_PAYMENT_PLAN" datasource="#DSN3#">
    	SELECT
        	*
        FROM
        (
            <cfloop query="get_period">
                <cfset new_dsn2 = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                <cfset period_id = get_period.period_id>
                SELECT
                    SPR.*,
                    SC.SUBSCRIPTION_NO,
                    I.NETTOTAL,
                    I.INVOICE_NUMBER,
                    I.INVOICE_DATE INV_DATE,
					I.DUE_DATE,
                    C.FULLNAME MEMBER_NAME,
					ISNULL(I.BANK_ACTION_ID,0) BANK_ACTION_ID
                FROM
                    SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                    SUBSCRIPTION_CONTRACT SC,
                    #new_dsn2#.INVOICE I,
                    #dsn_alias#.COMPANY C
                WHERE
                    SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                    I.INVOICE_ID = SPR.INVOICE_ID AND
                    I.COMPANY_ID = C.COMPANY_ID AND
                    SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
					<cfif len(attributes.pay_method) and not len(attributes.card_pay_method)><!---ödeme yöntemi--->
						SPR.PAYMETHOD_ID IN (#attributes.pay_method#) AND
					<cfelseif len(attributes.card_pay_method) and not len(attributes.pay_method)>
						SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#) AND
					<cfelse>
						(
							SPR.PAYMETHOD_ID IN (#attributes.pay_method#) OR SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#)
						) AND
               		</cfif>
                    SPR.PERIOD_ID = #period_id# AND
                    SPR.IS_BILLED = 1 AND<!--- faturalandı --->
                    SPR.IS_PAID = 0 AND<!--- ödenmedi --->
                    SPR.IS_COLLECTED_PROVISION = 0 AND<!---toplu provizyon oluşturulmadı olanlar gelecek otomatik ödemede --->
                    SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                    I.NETTOTAL > 0 AND
                    I.IS_IPTAL = 0 AND
                    I.INVOICE_CAT <> 57 <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
                    
                UNION ALL
                
                SELECT
                    SPR.*,
                    SC.SUBSCRIPTION_NO,
                    I.NETTOTAL,
                    I.INVOICE_NUMBER,
                    I.INVOICE_DATE INV_DATE,
					I.DUE_DATE,
                    C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME MEMBER_NAME,
					ISNULL(I.BANK_ACTION_ID,0) BANK_ACTION_ID
                FROM
                    SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                    SUBSCRIPTION_CONTRACT SC,
                    #new_dsn2#.INVOICE I,
                    #dsn_alias#.CONSUMER C
                WHERE
                    SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                    I.INVOICE_ID = SPR.INVOICE_ID AND
                    I.CONSUMER_ID = C.CONSUMER_ID AND
                    SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
                <cfif len(attributes.pay_method) and not len(attributes.card_pay_method)><!---ödeme yöntemi--->
                    SPR.PAYMETHOD_ID IN (#attributes.pay_method#) AND
                <cfelseif len(attributes.card_pay_method) and not len(attributes.pay_method)>
                    SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#) AND
                <cfelse>
                    (
                        SPR.PAYMETHOD_ID IN (#attributes.pay_method#) OR
                        SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#)
                    ) AND
                </cfif>
                    SPR.PERIOD_ID = #period_id# AND
                    SPR.IS_BILLED = 1 AND<!--- faturalandı --->
                    SPR.IS_PAID = 0 AND<!--- ödenmedi --->
                    SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı olanlar gelecek otomatik ödemede--->
                    SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                    I.NETTOTAL > 0 AND
                    I.IS_IPTAL = 0 AND
                    I.INVOICE_CAT <> 57 <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
            <cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
            </cfloop>
        )T1	
		ORDER BY
			INVOICE_ID,
			PERIOD_ID
	</cfquery>
	<cfform name="provision_rows" method="post" action="#request.self#?fuseaction=bank.emptypopupflush_add_autopayment_export">
		<cf_basket id="add_form_row">
        	<input name="all_records" id="all_records" type="hidden" value="<cfoutput>#get_payment_plan.recordcount#</cfoutput>">
            <!--- filtre elemanlari --->
			<input name="start_date" id="start_date" type="hidden" value="<cfif isDefined('attributes.start_date') and Len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>">
			<input name="finish_date" id="finish_date" type="hidden" value="<cfif isDefined('attributes.finish_date') and Len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>">
            <input name="bank_name" id="bank_name" type="hidden" value="<cfoutput>#attributes.bank_name#</cfoutput>">
            <input name="prov_period" id="prov_period" type="hidden" value="<cfoutput>#attributes.prov_period#</cfoutput>">
            <input name="source" id="source" type="hidden" value="<cfoutput>#attributes.source#</cfoutput>">
            <input name="pay_method" id="pay_method" type="hidden" value="<cfoutput>#attributes.pay_method#</cfoutput>">
            <input name="card_pay_method" id="card_pay_method" type="hidden" value="<cfoutput>#attributes.card_pay_method#</cfoutput>">
            <input name="open_form" id="open_form" type="hidden" value="<cfoutput>#attributes.open_form#</cfoutput>">
            <input name="prov_period" id="prov_period" type="hidden" value="<cfoutput>#attributes.prov_period#</cfoutput>">
			<!--- XML parametreleri --->
            <input name="is_process_check" id="is_process_check" type="hidden" value="<cfoutput>#is_process_check#</cfoutput>">
			<input name="is_file_from_manuelpaper" id="is_file_from_manuelpaper" type="hidden" value="<cfoutput>#is_file_from_manuelpaper#</cfoutput>">
            <input name="is_show_related_inv_period" id="is_show_related_inv_period" type="hidden" value="<cfoutput>#is_show_related_inv_period#</cfoutput>">
            
			<cf_grid_list class="detail_basket_list">
				<cfif is_process_check eq 1>
					<cfif get_payment_plan.recordcount>
                        <thead>
                             <tr>
                                <th><input type="checkbox" name="hepsi" id="hepsi" value="1" onClick="check_all(this.checked);" checked></th>
                                <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                <th><cf_get_lang dictionary_id='57742.Tarih'></th> 
                                <th><cf_get_lang dictionary_id='29502.Sistem No'></th>
                                <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                <th><cf_get_lang dictionary_id='57636.Birim'></th>
                                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                                <th><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
                                <th><cf_get_lang dictionary_id='57641.İskonto'> %</th>
                                <th><cf_get_lang dictionary_id='57642.Net Toplam'></th>
                                <th><cf_get_lang dictionary_id='48962.Fatura Toplamı'></th>
                            </tr>
                        </thead>
                        <tbody>
							<cfset kontrol_invoice =0>
                            <cfoutput query="get_payment_plan">
								<cfif get_payment_plan.invoice_id eq get_payment_plan.invoice_id[currentrow-1] and get_payment_plan.period_id eq get_payment_plan.period_id[currentrow-1]>
                                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.bgColor='E0E0E0';" bgcolor="E0E0E0">
                                    <td width="15"><input type="checkbox" name="payment_row#currentrow#" id="payment_row#currentrow#" value="#subscription_payment_row_id#" checked disabled></td>
                                <cfelse>
                                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                    <td width="15"><input type="checkbox" name="payment_row#currentrow#" id="payment_row#currentrow#" id="payment_row#currentrow#" value="#subscription_payment_row_id#" checked></td>
                                </cfif>
                                    <input type="hidden" name="invoice_id#currentrow#" id="invoice_id#currentrow#" value="#invoice_id#">
                                    <input type="hidden" name="invoice_number#currentrow#" id="invoice_number#currentrow#" value="#invoice_number#">
                                    <input type="hidden" name="nettotal#currentrow#" id="nettotal#currentrow#" value="#wrk_round(nettotal)#">
                                    <input type="hidden" name="subs_no#currentrow#" id="subs_no#currentrow#" value="#subscription_no#">
									<input type="hidden" name="due_date#currentrow#" id="due_date#currentrow#" value="#due_date#">
                                    <input type="hidden" name="invoice_date#currentrow#" id="invoice_date#currentrow#" value="#inv_date#">
                                    <input type="hidden" name="member_name#currentrow#" id="member_name#currentrow#" value="#member_name#">
                                    <input type="hidden" name="payment_date#currentrow#" id="payment_date#currentrow#" value="#payment_date#">
									<!--- eğer bank_action_id olan faturalar varsa tahsil edilmiş demektir. --->
									<cfif bank_action_id neq 0><cfset kontrol_invoice =1><cfset font_color = 'red'><cfelse><cfset font_color = ''></cfif>
                                    <td><font color="#font_color#">#currentrow#</font></td>
                                    <td><font color="#font_color#">#dateformat(payment_date,dateformat_style)#</font></td>
                                    <td><font color="#font_color#">#subscription_no#</font></td>
                                    <td><font color="#font_color#">#invoice_number#</font></td>
                                    <td><font color="#font_color#">#detail#</font></td>
                                    <td><font color="#font_color#">#unit#</font></td>
                                    <td><font color="#font_color#">#quantity#</font></td>
                                    <td><font color="#font_color#">#TLFormat(amount)#</font></td>
                                    <td><font color="#font_color#">#money_type#</font></td>
                                    <td style="text-align:right;"><font color="#font_color#">#TLFormat(row_total)#</font></td>
                                    <td style="text-align:right;"><font color="#font_color#">#TLFormat(discount)#</font></td>
                                    <td style="text-align:right;"><font color="#font_color#">#TLFormat(row_net_total)#</font></td>
                                    <td style="text-align:right;"><font color="#font_color#">#TLFormat(nettotal)# #session.ep.money#</font></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="10"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td>
                        </tr>
                    </cfif>
                <cfelse>
                	<cfset toplam_tutar = 0>
                    <cfset fatura_sayisi = 0>
					<cfoutput query="get_payment_plan">
						<cfif bank_action_id neq 0><cfset kontrol_invoice =1></cfif>
                    	<cfif get_payment_plan.invoice_id eq get_payment_plan.invoice_id[currentrow-1] and get_payment_plan.period_id eq get_payment_plan.period_id[currentrow-1]>
                        <cfelse>
							<cfset toplam_tutar = toplam_tutar+nettotal>
                            <cfset fatura_sayisi = fatura_sayisi+1>
                        </cfif>
                    </cfoutput>
                	<tr>
                    	<td width="200" class="txtboldblue"><cf_get_lang dictionary_id='48809.Toplam Fatura Sayısı'> :</td> 
                        <td><cfoutput>#fatura_sayisi#</cfoutput></td>
                    </tr>
                    <tr>
                    	<td width="200" class="txtboldblue"><cf_get_lang dictionary_id='48811.Toplam Satır Sayısı'> :</td> 
                        <td><cfoutput>#get_payment_plan.recordcount#</cfoutput></td>
                    </tr>
                    <tr>
                        <td width="200" class="txtboldblue"><cf_get_lang dictionary_id='29534.Toplam Tutar'> :</td> 
                        <td><cfoutput>#TLFormat(toplam_tutar)# #session.ep.money#</cfoutput></td>
                    </tr>
                </cfif>
			</cf_grid_list>
			<cfif get_payment_plan.recordcount>
                <cf_basket_footer height="23">
                    <div class="row">
                        <div class="row">
                            <div class="col col-12 form-inline" type="column" sort="false">
                                <cfoutput>
                                    <cfif is_due_date eq 1 and attributes.source eq 1>
                                        <div class="form-group x-15">
                                            <label>#getLang('main',469)#</label>
                                            <div class="input-group">
                                                <cfinput type="text" name="due_date"  required="Yes" message="#getLang('main',469)#" value="" validate="#validate_style#" maxlength="10">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date"></span>
                                            </div>
                                        </div>
                                    </cfif>
                                    <cfif is_encrypt_file eq 1>
                                    	<div class="form-group x-15">
                                        	<label>#getLang('bank',257)#</label>
                                            <div class="input-group">
                                            	<input name="key_type" id="key_type" type="password" autocomplete="off">
                                            </div>
                                        </div>
                                    </cfif>
                                    <cfif isdefined("kontrol_invoice") and kontrol_invoice eq 1>
                                        <font color="red"><b>Tahsil Edilmiş Faturalar Bulunmaktadır. Lütfen Kontrol Ediniz !</b></font>
                                    </cfif>
                                    <div class="form-group pull-right">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29477.Belge Oluştur'></cfsavecontent>
                    					<cf_workcube_buttons is_upd='0' insert_info = '#message#' add_function='input_control()'>
                                    </div>
                                </cfoutput>
                            </div>
                        </div>
                    </div>             
                </cf_basket_footer>
            </cfif>
		</cf_basket>
	</cfform>
<!--- fatura ödeme planı satirlarini getirir --->
<cfelseif attributes.open_form eq 1 and attributes.source eq 2>
	<cf_date tarih='attributes.start_date'>
	<cf_date tarih='attributes.finish_date'>
	<cfquery name="get_payment_plan" datasource="#dsn3#">
    	SELECT
			INVOICE_PAYMENT_PLAN_ID,
       		INVOICE_NUMBER,
			INVOICE_DATE,
			DUE_DATE,
			ACTION_DETAIL,
			(SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = PAYMENT_METHOD_ROW) PAYMETHOD,
			OTHER_ACTION_VALUE,
			OTHER_MONEY,
			IS_BANK,
			IS_ACTIVE,
			IS_PAID,
            ISNULL(COMPANY.FULLNAME,ISNULL(CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME,EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME)) MEMBER_NAME,
			ISNULL(COMPANY.MEMBER_CODE,ISNULL(CONSUMER.MEMBER_CODE,EMPLOYEES.MEMBER_CODE)) MEMBER_CODE,
			INVOICE_PAYMENT_PLAN.COMPANY_ID
		FROM 
			INVOICE_PAYMENT_PLAN
			LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE_PAYMENT_PLAN.COMPANY_ID AND INVOICE_PAYMENT_PLAN.COMPANY_ID IS NOT NULL
            LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = INVOICE_PAYMENT_PLAN.CONSUMER_ID AND INVOICE_PAYMENT_PLAN.CONSUMER_ID IS NOT NULL
            LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = INVOICE_PAYMENT_PLAN.EMPLOYEE_ID AND INVOICE_PAYMENT_PLAN.EMPLOYEE_ID IS NOT NULL
		WHERE
			IS_PAID = 0 AND
			IS_BANK_IPTAL = 0 AND
			ISNULL(INVOICE_PAYMENT_PLAN.UPDATE_DATE,INVOICE_PAYMENT_PLAN.RECORD_DATE) BETWEEN #attributes.start_date# AND #DATEADD('d',1,attributes.finish_date)#
			<cfif len(attributes.pay_method)>
				AND PAYMENT_METHOD_ROW IN (#attributes.pay_method#)
			</cfif>
			<cfif len(attributes.money_type)>
				AND OTHER_MONEY = '#attributes.money_type#'
			</cfif>
			<cfif len(attributes.document_status) and attributes.document_status neq -1 and isdefined("attributes.status")>
				AND (IS_BANK = #attributes.document_status# OR IS_ACTIVE = 0)
			</cfif>
			<cfif len(attributes.document_status) and attributes.document_status neq -1 and not isdefined("attributes.status")>
				AND IS_BANK = #attributes.document_status# AND IS_ACTIVE = 1	
			</cfif>
			<cfif len(attributes.document_status) and attributes.document_status eq -1 and not isdefined("attributes.status")>
				AND IS_ACTIVE = 1
			</cfif>
			<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
				AND INVOICE_PAYMENT_PLAN.COMPANY_ID = #attributes.company_id#
			</cfif>
            AND INVOICE_PAYMENT_PLAN_ID NOT IN (SELECT INVOICE_PAYMENT_PLAN_ID FROM INVOICE_PAYMENT_PLAN WHERE IS_BANK = 0  AND IS_ACTIVE = 0)
	</cfquery>
	<cfform name="provision_rows" method="post" action="#request.self#?fuseaction=bank.emptypopupflush_add_autopayment_export">
		<cf_basket id="add_form_row">
			<cfoutput>
				<cfquery name="get_bank_" datasource="#dsn#">
					SELECT BANK_ID,BANK_NAME,BANK_CODE FROM SETUP_BANK_TYPES WHERE BANK_ID = #attributes.bank#
				</cfquery>
                <input name="bank_code_" id="bank_code_" type="hidden" value="#get_bank_.bank_code#">	
				<input name="bank_name_" id="bank_name_" type="hidden" value="#get_bank_.bank_name#">
				<input name="all_records" id="all_records" type="hidden" value="#get_payment_plan.recordcount#">
				<!--- form elemanlari --->
                <input name="start_date" id="start_date" type="hidden" value="<cfif isDefined('attributes.start_date') and Len(attributes.start_date)>#dateformat(attributes.start_date,dateformat_style)#</cfif>">
				<input name="finish_date" id="finish_date" type="hidden" value="<cfif isDefined('attributes.finish_date') and Len(attributes.finish_date)>#dateformat(attributes.finish_date,dateformat_style)#</cfif>">
				<input name="source" id="source" type="hidden" value="#attributes.source#">
				<input name="bank" id="bank" type="hidden" value="#attributes.bank#">	
				<input name="money_type" id="money_type" type="hidden" value="#attributes.money_type#">
                <input name="pay_method" id="pay_method" type="hidden" value="#attributes.pay_method#">
                <input name="status" id="status" type="hidden" value="<cfif isDefined('attributes.status') and attributes.status eq 1>1<cfelse>0</cfif>">
                <input name="document_status" type="hidden" value="#attributes.document_status#">
                <input name="open_form" type="hidden" value="#attributes.open_form#">
                <!--- XML parametreleri --->
                <input name="is_process_check" id="is_process_check" type="hidden" value="<cfoutput>#is_process_check#</cfoutput>">
				<input name="is_file_from_manuelpaper" id="is_file_from_manuelpaper" type="hidden" value="<cfoutput>#is_file_from_manuelpaper#</cfoutput>">
			</cfoutput>
           	<cf_grid_list class="detail_basket_list">
                <cfif is_process_check eq 1>
					<cfif get_payment_plan.recordcount>
                        <thead>
                            <tr>
                                <th><input type="checkbox" name="hepsi" id="hepsi" value="1" onClick="check_all(this.checked);" checked="checked"></th>
                                <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                                <th><cf_get_lang dictionary_id='57742.Tarih'></th> 
								<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                                <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                                <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                                <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="get_payment_plan">
                                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.bgColor='E0E0E0';" bgcolor="E0E0E0">
                                    <input type="hidden" name="pay_type#currentrow#" id="pay_type#currentrow#" value="<cfif is_bank eq 1 and is_active eq 1>G<cfelseif is_bank eq 0 and is_active eq 1>Y<cfelse>I</cfif>">
                                    <input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="#member_code#">
                                    <input type="hidden" name="member_name#currentrow#" id="member_name#currentrow#" value="#member_name#">
                                    <input type="hidden" name="due_date#currentrow#" id="due_date#currentrow#" value="#due_date#">
                                    <input type="hidden" name="invoice_number#currentrow#" id="invoice_number#currentrow#" value="#invoice_number#">
                                    <input type="hidden" name="invoice_date#currentrow#" id="invoice_date#currentrow#" value="#invoice_date#">
                                    <input type="hidden" name="nettotal#currentrow#" id="nettotal#currentrow#" value="#wrk_round(other_action_value)#">
                                    <input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#other_money#">
                                    <input type="hidden" name="invoice_payment_plan_id#currentrow#" id="invoice_payment_plan_id#currentrow#" value="#invoice_payment_plan_id#">                                    
                                    <td width="15"><input type="checkbox" name="payment_row#currentrow#" id="payment_row#currentrow#" value="#invoice_payment_plan_id#" checked="checked"></td>
                                    <td>#currentrow#</td>
                                    <td>#dateformat(invoice_date,dateformat_style)#</td>
									<td><cfif len(company_id)>#get_par_info(company_id,1,1,1)#</cfif></td>
                                    <td>#invoice_number#</td>
                                    <td>#action_detail#</td>
                                    <td>#paymethod#</td>
                                    <td>#dateformat(due_date,dateformat_style)#</td>
                                    <td style="text-align:right;">#TLFormat(other_action_value)#</td>
                                    <td>#other_money#</td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="9"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td>
                        </tr>
                    </cfif>
                <cfelse>
					<cfset toplam_tutar = 0>
                    <cfoutput query="get_payment_plan">
                        <cfset toplam_tutar = toplam_tutar+other_action_value>
                    </cfoutput>
                    <tr>
                        <td width="200" class="txtboldblue"><cf_get_lang dictionary_id='48811.Toplam Satır Sayısı'> :</td> 
                        <td><cfoutput>#get_payment_plan.recordcount#</cfoutput></td>
                    </tr>
                    <tr>
                        <td width="200" class="txtboldblue"><cf_get_lang dictionary_id='29534.Toplam Tutar'> :</td> 
                        <td><cfoutput>#TLFormat(toplam_tutar)# #session.ep.money#</cfoutput></td>
                    </tr>
                </cfif>
			</cf_grid_list>
			<cfif get_payment_plan.recordcount>
                <cf_basket_footer height="23">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29477.Belge Oluştur'></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' insert_info = '#message#' add_function='input_control()'>
                </cf_basket_footer>
            </cfif>
		</cf_basket>
	</cfform>
</cfif>
<script type="text/javascript">
	function check_all(deger)
	{
		<cfif isdefined("get_payment_plan") and get_payment_plan.recordcount>
			if(provision_rows.hepsi.checked)
			{
				for (var i=1; i <= <cfoutput>#get_payment_plan.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.provision_rows.payment_row" + i);
					form_field.checked = true;
					eval('provision_rows.payment_row'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_payment_plan.recordcount#</cfoutput>; i++)
				{
					form_field = eval("document.provision_rows.payment_row" + i);
					form_field.checked = false;
					eval('provision_rows.payment_row'+i).focus();
				}				
			}
		</cfif>
	}
	function kontrol()
	{
		if(document.getElementById('source').value == 1)
		{
			if(add_autopaym.bank_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='48963.Pos Tipi Seçiniz'>");
				return false;
			}
			var pay_method_list='';
			var card_pay_method_list='';
			
			for(kk=0;kk<document.add_autopaym.pay_method.length; kk++)
			{
				if(add_autopaym.pay_method[kk].selected && add_autopaym.pay_method.options[kk].value.length!='')
					pay_method_list= pay_method_list + ',' + add_autopaym.pay_method.options[kk].value;
			}
			for(jj=0;jj<add_autopaym.card_pay_method.length; jj++)
			{
				if(add_autopaym.card_pay_method[jj].selected && add_autopaym.card_pay_method.options[jj].value.length!='')
					card_pay_method_list = card_pay_method_list + ',' + add_autopaym.card_pay_method.options[jj].value;
			}
			if(pay_method_list=="" && card_pay_method_list=="")
			{
				alert('<cfoutput>#getLang('crm',1078)#</cfoutput>');
				return false;
			}
		}
		else
		{
			if(document.getElementById('bank').value == '')
			{
				alert('<cfoutput>#getLang('bank',88)#</cfoutput>');
				return false;
			}
			var pay_method_list='';
			for(kk=0;kk<document.add_autopaym.pay_method.length; kk++)
			{
				if(add_autopaym.pay_method[kk].selected && add_autopaym.pay_method.options[kk].value.length!='')
					pay_method_list= pay_method_list + ',' + add_autopaym.pay_method.options[kk].value;
			}
			if(pay_method_list=="")
			{
				alert('<cfoutput>#getLang('cheque',262)#</cfoutput>');
				return false;
			}
		}
		<cfoutput>
			var manuel_control = #is_file_from_manuelpaper#;
			var row_control = #is_process_check#;
		</cfoutput>
		if(manuel_control == 1 && row_control == 1)
		{
			alert('<cfoutput>#getLang('hr',1209)#</cfoutput>');
			return false;
		}
		document.add_autopaym.open_form.value = 1;
	}
	function input_control()
	{
		<cfif is_due_date eq 1 and attributes.source eq 1>
			if(document.all.due_date.value=="")
			{
				alert('<cfoutput>#getLang('crm',1079)#</cfoutput>');
				return false;
			}
			due_date_ = document.getElementById('due_date').value.substr(6,4) +document.getElementById('due_date').value.substr(3,2) + document.getElementById('due_date').value.substr(0,2);
			today_date_ = new Date();
			today_date_ = today_date_.getYear()+''+(today_date_.getMonth()+1)+''+today_date_.getDate();
			if(today_date_ > due_date_)
			{
				alert('<cfoutput>#getLang('cubetv',70)#</cfoutput>');
				return false;
			}
		</cfif>
		<cfif is_encrypt_file eq 1 and attributes.source eq 1>
			if(document.all.key_type.value == "")
			{
				alert("<cf_get_lang dictionary_id='48964.Anahtar Giriniz'>");
				return false;
			}
		</cfif>
		<cfif is_process_check eq 1>
			var checked_info = false;
			var toplam = document.provision_rows.all_records.value;
			for(var i=1; i<=toplam; i++)
			{
				if(eval('provision_rows.payment_row'+i).checked){
					checked_info = true;
					i = toplam+1;
				}
			}
			if(!checked_info)
			{
				alert("<cf_get_lang dictionary_id='56947.Seçim Yapmadınız'>!");
				return false;
			}
		</cfif>
		return true;
	}
	/* Kaynak: Sistem Odeme Plani veya Fatura Odeme Plani */
	function display_()
	{
		if (document.getElementById('source').value == 1)
		{
			set_paymethod();
			gizle(bank_);
			gizle(bank_2);
			gizle(money_);
			gizle(money_2);
			gizle(status_);
			gizle(document_);
			gizle(document_2);
			gizle(cari_);
			gizle(cari_2);
			goster(pos_);
			goster(pos_2);
			goster(credit_card_);
			goster(credit_card_2);
			<cfif is_show_related_inv_period eq 1>
				goster(inv_period_);
				goster(inv_period_2);
			</cfif>
		}
		else
		{
			set_paymethod_default();
			if(document.getElementById('bank') != undefined && document.getElementById('bank').value != '')
				set_bank_paymethod(document.getElementById('bank').value);	
			goster(bank_);
			goster(bank_2);
			goster(money_);
			goster(money_2);
			goster(status_);
			goster(document_);
			goster(document_2);
			goster(cari_);
			goster(cari_2);
			gizle(pos_);
			gizle(pos_2);
			gizle(credit_card_);
			gizle(credit_card_2);
			<cfif is_show_related_inv_period eq 1>
				gizle(inv_period_);
				gizle(inv_period_2);
			</cfif>
		}
	}
	/* Sistem odeme planina bagli odeme yontemlerinin tamamini getirir */
	function set_paymethod()
	{
		var system_paymethods = wrk_safe_query('bnk_get_paymethod_2',"dsn",0);
		
		var option_count = document.getElementById('pay_method').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('pay_method').options[x] = null;
		
		if(system_paymethods.recordcount != 0)
		{	
			document.getElementById('pay_method').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<system_paymethods.recordcount;xx++)
				document.getElementById('pay_method').options[xx+1]=new Option(system_paymethods.PAYMETHOD[xx],system_paymethods.PAYMETHOD_ID[xx]);
		}
		else
			document.getElementById('pay_method').options[0] = new Option('Seçiniz','');	
	}
	/* Fatura odeme planinda optionlari sifirlar */
	function set_paymethod_default()
	{
		var option_count = document.getElementById('pay_method').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('pay_method').options[x] = null;
		document.getElementById('pay_method').options[0] = new Option('Seçiniz','');
	}
	/* Fatura odeme planinda bankaya gore odeme yontemlerini getirir */
	function set_bank_paymethod(xyz)
	{
		var bank_paymethods = wrk_safe_query('bnk_get_paymethod',"dsn",0,xyz);
		
		var option_count = document.getElementById('pay_method').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('pay_method').options[x] = null;
		
		if(bank_paymethods.recordcount != 0)
		{	
			document.getElementById('pay_method').options[0] = new Option('Seçiniz','');
			for(var xx=0;xx<bank_paymethods.recordcount;xx++)
				document.getElementById('pay_method').options[xx+1]=new Option(bank_paymethods.PAYMETHOD[xx],bank_paymethods.PAYMETHOD_ID[xx]);
		}
		else
			document.getElementById('pay_method').options[0] = new Option('Seçiniz','');
	}
</script>

