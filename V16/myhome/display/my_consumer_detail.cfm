<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT 
		CONSUMER.TC_IDENTY_NO,
        CONSUMER.CONSUMER_NAME,
        CONSUMER.CONSUMER_SURNAME,
        CONSUMER.BIRTHDATE,
        CONSUMER.BIRTHPLACE,
        CONSUMER.REF_POS_CODE,
        CONSUMER.PROPOSER_CONS_ID,
        CONSUMER.MOBIL_CODE,
        CONSUMER.MOBILTEL,
        CONSUMER.CONSUMER_ID,
        CONSUMER.CONSUMER_WORKTELCODE,
        CONSUMER.CONSUMER_WORKTEL,
        CONSUMER.CONSUMER_EMAIL,
        CONSUMER.SEX,
        CONSUMER.CONSUMER_CAT_ID,
        CONSUMER.CONSUMER_STATUS,
		CONSUMER_CAT.CONSCAT,
        CONSUMER.COMPANY,
        CONSUMER.HOMEPAGE,
        CONSUMER.CONSUMER_FAX,
        CONSUMER.CONSUMER_FAXCODE,
        CONSUMER.MOBIL_CODE_2,
        CONSUMER.MOBILTEL_2,
        CONSUMER.WORKADDRESS,
        CONSUMER.WORKPOSTCODE,
        CONSUMER.WORKSEMT,
        CONSUMER.WORK_COUNTY_ID,
        CONSUMER.WORK_CITY_ID,
        CONSUMER.WORK_COUNTRY_ID,
		ISNULL(CONSUMER_CAT.IS_PREMIUM,0) IS_PREMIUM
	FROM 
		CONSUMER,
		CONSUMER_CAT
	WHERE 
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND
		CONSUMER_CAT_ID = CONSCAT_ID
</cfquery>
<cfquery name="GET_WORKGROUP" datasource="#DSN#">
	SELECT POSITION_CODE FROM WORKGROUP_EMP_PAR WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND IS_MASTER = 1
</cfquery>
<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
	SELECT REVMETHOD_ID,CARD_REVMETHOD_ID,PRICE_CAT,IS_BLACKLIST,BLACKLIST_INFO FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfinclude template="../../member/query/get_mobilcat.cfm">
<cfparam name="attributes.totalrecords" default='#get_consumer.recordcount#'>
<cfoutput>

<cf_box title="#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#">
    <cfif isdefined("is_fast_display") and is_fast_display eq 1>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
            <cfform name="upd_dsp_consumer" action="#request.self#?fuseaction=myhome.emptypopup_upd_dsp_consumer" method="post">
                <input type="hidden" name="cons_id" id="cons_id" value="#attributes.cid#">
                    <div class="form-group" id="item-GET_LAW_REQUEST">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57571.Unvan'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.conscat#</label>
                        <cfquery name="GET_LAW_REQUEST" datasource="#DSN#">
                            SELECT CONSUMER_ID FROM COMPANY_LAW_REQUEST WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND REQUEST_STATUS = 1
                        </cfquery>
                    </div>
                    <div class="form-group" id="item-GET_BLOCK_REQUEST">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.tc_identy_no#</label>
                        <cfquery name="GET_BLOCK_REQUEST" datasource="#DSN#">
                            SELECT DISTINCT CB.BLOCK_GROUP_ID,BG.BLOCK_GROUP_NAME FROM COMPANY_BLOCK_REQUEST CB,BLOCK_GROUP BG WHERE CB.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND  CB.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND (CB.BLOCK_FINISH_DATE IS NULL OR CB.BLOCK_FINISH_DATE >=#now()#) 
                        </cfquery>
                    </div>
                    <div class="form-group" id="item-birthdate">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#dateformat(get_consumer.birthdate,dateformat_style)#</label>
                    </div>
                    <div class="form-group" id="item-birthplace">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.birthplace#</label>
                    </div>
                    <div class="form-group" id="item-position_code">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12"><cfif get_workgroup.recordcount>#get_emp_info(get_workgroup.position_code,1,0)#</cfif></label>
                    </div>
                    <div class="form-group" id="item-ref_pos_code">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58636.Referans Üye'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">  
                            <cfif len(get_consumer.ref_pos_code)>
                                <cfquery name="GET_ROW_CONS" datasource="#DSN#">
                                    SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.ref_pos_code#">
                                </cfquery>
                                #get_row_cons.consumer_name#&nbsp;#get_row_cons.consumer_surname#
                            </cfif>
                        </label>
                    </div>
                    <div class="form-group" id="item-proposer_cons_id">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='32272.Öneren Üye'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <cfif len(get_consumer.proposer_cons_id)>
                                <cfquery name="get_prop_cons" datasource="#DSN#">
                                    SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.proposer_cons_id#">
                                </cfquery>
                                #get_prop_cons.consumer_name#&nbsp;#get_prop_cons.consumer_surname#		
                            </cfif>
                        </label>
                    </div>
                    <div class="form-group" id="item-PAYMETHOD">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <cfif len(get_credit_limit.revmethod_id)>
                                <cfquery name="GET_PAY_MEYHOD" datasource="#DSN#">
                                    SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.revmethod_id#"> 
                                </cfquery>
                                <cfset revmethod_name_ = get_pay_meyhod.paymethod>
                            <cfelseif len(get_credit_limit.card_revmethod_id)>
                                <cfquery name="GET_PAY_MEYHOD" datasource="#DSN3#">
                                    SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.card_revmethod_id#"> 
                                </cfquery>
                                <cfset revmethod_name_ = get_pay_meyhod.card_no>
                            <cfelse>
                                <cfset revmethod_name_= ''>
                            </cfif>
                            #revmethod_name_#
                        </label>
                    </div>								
                <cfif is_update_consumer eq 1>
                    <div class="form-group" id="item-mobilcat_id">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58482.Mobil Kodu / Fax'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="input-group">
                                <select name="mobilcat_id" id="mobilcat_id" style="width:45px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_mobilcat">
                                        <option value="#get_mobilcat.mobilcat#"<cfif get_mobilcat.mobilcat eq get_consumer.mobil_code>selected</cfif>>#get_mobilcat.mobilcat#</option>
                                    </cfloop>
                                </select>
                                <span class="input-group-addon no-bg"></span>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/Mobil Tel Girmelisiniz !'></cfsavecontent>
                                <cfinput type="text" name="mobiltel" id="mobiltel" value="#get_consumer.mobiltel#" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:60px;">
                                <cfif len(get_consumer.mobiltel) and session.ep.our_company_info.sms eq 1><span class="input-group-addon btnPointer no-bg" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_send_sms&member_type=consumer&member_id=#GET_CONSUMER.CONSUMER_ID#&sms_action=#fuseaction#</cfoutput>','small');"><img src="/images/mobil.gif" title="<cf_get_lang dictionary_id ='58590.SMS Gönder'>"></span></cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_telcode">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58815.İş Telefonu'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='32273.Kod/ Telefon Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="text" name="work_telcode" id="work_telcode" value="#get_consumer.consumer_worktelcode#" maxlength="3" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:45px;">
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="work_tel" id="work_tel" value="#get_consumer.consumer_worktel#" maxlength="7" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:60px;">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-consumer_email">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57428.E-Mail'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58484.Lütfen Geçerli Bir E-mail Adresi Giriniz'></cfsavecontent>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12"><cfinput type="text" name="consumer_email" id="consumer_email" value="#get_consumer.consumer_email#" validate="email" maxlength="40" message="#message#" style="width:200px;"></div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57764.cinsiyet'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">  
                            <select name="sex" id="sex" style="width:200px;" tabindex="3">
                                <option value="1"<cfif get_consumer.sex eq 1> selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'></option>
                                <option value="0"<cfif get_consumer.sex eq 0> selected</cfif>><cf_get_lang dictionary_id='32271.Bayan'></option>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-show_info">
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12" id="show_info"></div>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12 text-right">						
                            <input type="button" name="button1" id="button1" value="Güncelle" onclick="AjaxFormSubmit('upd_dsp_consumer','SHOW_INFO',1,'Kaydediliyor','Kaydedildi');">
                        </div>
                    </div>
                <cfelse>
                    <div class="form-group" id="item-mobilKod">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58482.mobilKod / Fax'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.mobil_code# #get_consumer.mobiltel#</label>
                    </div>
                    <div class="form-group" id="item-consumer_worktelcode">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58815.İş Telefonu'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.consumer_worktelcode# #get_consumer.consumer_worktel#</label>
                    </div>
                    <div class="form-group" id="item-consumer_email2">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57428.E-Mail'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.consumer_email#</label>
                    </div>
                    <div class="form-group" id="item-sex">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57764.cinsiyet'></label>
                        <label class="col col-9 col-md-9 col-sm-9 col-xs-12">  
                            <cfif get_consumer.sex eq 1><cf_get_lang dictionary_id='58959.Erkek'></cfif>
                            <cfif get_consumer.sex eq 0><cf_get_lang dictionary_id='32271.Bayan'></cfif>
                        </label>
                    </div>
                </cfif>
                <cfif get_law_request.recordcount>
                    <div class="form-group" id="item-law_request">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold font-red"><cf_get_lang dictionary_id='32279.Icra Takip Kaydi Bulunmaktadir'></label>
                    </div>
                </cfif>
                <cfif get_block_request.recordcount>
                    <div class="form-group" id="item-block_request">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold font-red"><cf_get_lang dictionary_id='32278.Blok Takip Kaydı Bulunmaktadır'> &nbsp;(<cfloop query="get_block_request">#block_group_name# <cfif get_block_request.currentrow neq get_block_request.recordcount> ,</cfif></cfloop>)</label>
                    </div>
                    </cfif>	
                <cfif get_credit_limit.is_blacklist eq 1>
                    <div class="form-group" id="item-credit_limit">
                        <cfquery name="GET_BLACKLIST_INFO" datasource="#DSN#">
                            SELECT BLACKLIST_INFO_NAME FROM SETUP_BLACKLIST_INFO WHERE BLACKLIST_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.blacklist_info#">
                        </cfquery>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold font-red"><cf_get_lang dictionary_id='30758.Kara Liste Kaydı Bulunmaktadır'> &nbsp;<cfif get_blacklist_info.recordcount>(#get_blacklist_info.blacklist_info_name#)</cfif></b></font></label>
                    </div>
                </cfif>
            </cfform>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="false" index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
            <div class="row details_table_in_table">
                <cfif isdefined("attributes.cid") and len(attributes.cid)>
                    <cfquery name="GET_REMAINDER" datasource="#DSN2#">
                        SELECT * FROM CONSUMER_REMAINDER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> 
                    </cfquery>
                    <cfif get_remainder.recordcount>
                        <cfset borc = get_remainder.borc>
                        <cfset alacak = get_remainder.alacak>
                        <cfset bakiye = get_remainder.bakiye>
                    <cfelse>
                        <cfset borc = 0>
                        <cfset alacak = 0>
                        <cfset bakiye = 0>
                    </cfif>
                    <cfquery name="GET_COMPANY_RISK" datasource="#DSN2#">
                        SELECT 
                            BAKIYE,
                            CEK_ODENMEDI,
                            CEK_KARSILIKSIZ,
                            SENET_ODENMEDI,
                            SENET_KARSILIKSIZ,
                            ISNULL(TOTAL_RISK_LIMIT,0) TOTAL_RISK_LIMIT,
                            CONSUMER_ID
                        FROM 
                            CONSUMER_RISK
                        WHERE 
                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> 
                    </cfquery>
                    <cfoutput>
                        <div class="form-group">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id ='58085.Finansal Özet'></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57587.Borç'>:</label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12">#TLFormat(ABS(borc))#&nbsp;#session.ep.money#</label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57588.Alacak'>:</label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12">#TLFormat(ABS(alacak))#&nbsp;#session.ep.money# <br/></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57589.Bakiye'>:</label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12">#TLFormat(abs(bakiye))#&nbsp;#session.ep.money# <cfif borc gte alacak>(B)<cfelse>(A)</cfif></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'>:</label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif get_company_risk.recordcount>
                                    #TLFormat(get_company_risk.total_risk_limit - (get_company_risk.bakiye  + (get_company_risk.cek_odenmedi + get_company_risk.senet_odenmedi + get_company_risk.cek_karsiliksiz + get_company_risk.senet_karsiliksiz)))#
                                <cfelse>
                                    #TLFormat(0)#
                                </cfif> #session.ep.money#
                            </label>
                        </div>
                    </cfoutput>
                </cfif>
                <cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
                    <cfset attributes.price_catid = get_credit_limit.price_cat>
                <cfelse>		
                    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
                        SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer.consumer_cat_id#,%">
                    </cfquery>
                    <cfif get_price_cat.recordcount>
                        <cfset attributes.price_catid = get_price_cat.price_catid>
                    </cfif>		
                </cfif>
                <cfif get_consumer.consumer_status eq 1><!--- Pasif degilse verebilir --->
                    <cfif is_sales_for_self eq 1>
                    <div class="form-group">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><a href="#request.self#?fuseaction=objects2.basket_expres&consumer_id=#attributes.cid#" target="_blank"><cf_get_lang dictionary_id='32277.Kendi Adına Sipariş Giriş'><i class="fa fa-cube"></i></a></label>
                    </div>
                    </cfif>
                    <cfif get_consumer.is_premium eq 0>
                        <cfif is_sales_for_group eq 1>
                        <div class="form-group">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><a href="#request.self#?fuseaction=objects2.basket_expres&sales_cons_id=#attributes.cid#" target="_blank"><cf_get_lang dictionary_id='32276.Grubu Adına Sipariş Giriş'><i class="fa fa-cube"></i></a></label>
                        </div>
                        </cfif>
                    </cfif>
                </cfif>
                <cfif is_product_list eq 1>
                    <div class="form-group">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_view_product_list','wide2','popup_view_product_list');"><cf_get_lang dictionary_id='58942.Ürün Listesi'><i class="fa fa-cube"></i></a></label>
                    </div>
                </cfif>
                <cfif is_promotion_list eq 1 and session.ep.menu_id neq 0><!--- xml de secili ve site ise --->
                    <div class="form-group">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><a href="#request.self#?fuseaction=objects2.popup_list_detail_promotions&is_submitted=1<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>&price_catid=#attributes.price_catid#</cfif>" target="_blank"><cf_get_lang dictionary_id='32275.Promosyon Listesi'><i class="fa fa-cube"></i></a></label>
                    </div>
                </cfif>
                <div class="form-group">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><a href="#request.self#?fuseaction=call.list_service&event=add&consumer_id=#attributes.cid#" target="_blank"><cf_get_lang dictionary_id='31952.Başvuru Ekle'><i class="fa fa-cube"></i></a></label>
                </div>
                <div class="form-group">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><a href="javascript://" onclick="windowopen(<cfoutput>'#request.self#?fuseaction=objects.popup_form_add_note&action=consumer_id&action_id=#attributes.cid#&is_special=0&action_type=0','small'</cfoutput>);"><cf_get_lang dictionary_id='57465.Not Ekle'><i class="fa fa-cube"></i></a></label>
                </div>
            </div>
        </div>
    <cfelse>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
            <div class="form-group" id="">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57571.Unvan'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.company#</label>
            </div>
            <div class="form-group" id="">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58815.İş Telefonu'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.consumer_worktelcode# #get_consumer.consumer_worktel#</label>
            </div>
            
            <div class="form-group" id="">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='31391.Kod / Fax'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.consumer_faxcode# #get_consumer.consumer_fax#</label>
            </div>
            
            <div class="form-group" id="">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.mobil_code# #get_consumer.mobiltel# &nbsp;&nbsp;&nbsp;<cfif len(get_consumer.mobiltel) and session.ep.our_company_info.sms eq 1><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=consumer&member_id=#get_consumer.consumer_id#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" border="0" title="<cf_get_lang dictionary_id ='58590.SMS Gnder'>"></a></cfif></label>
            </div>
            <div class="form-group">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.mobil_code_2# #get_consumer.mobiltel_2#</label>
            </div>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#index#</cfoutput>" <cfset index = index + 1>>
            <div class="form-group">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='58079.Internet'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.homepage#</label>
            </div>
            <div class="form-group">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='57428.E-Mail'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">#get_consumer.consumer_email#</label>
            </div>
            <div class="form-group" id="">
                <label class="col col-3 col-md-3 col-sm-3 col-xs-12 bold"><cf_get_lang dictionary_id='31991.İş Adresi'></label>
                <label class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    #get_consumer.workaddress# #get_consumer.workpostcode#
                    #get_consumer.worksemt#
                    <cfif len(get_consumer.work_county_id)>
                        <cfquery name="GET_COUNTY" datasource="#DSN#">
                            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">  
                        </cfquery>
                        #get_county.county_name#
                    </cfif>								
                    <cfif len(get_consumer.work_city_id)>
                        <cfquery name="GET_CITY" datasource="#DSN#">
                            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">  
                        </cfquery>
                        #get_city.city_name#
                    </cfif>		
                    <cfif len(get_consumer.work_country_id)>
                        <cfquery name="GET_COUNTRY" datasource="#DSN#">
                            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">  
                        </cfquery>
                        #get_country.country_name#
                    </cfif>	
                </label>
            </div>	
        </div>
    </cfif>
</cf_box>
</cfoutput>
