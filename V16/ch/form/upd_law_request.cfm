<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
</cfquery>
<cfset components = createObject('component','V16.objects.cfc.income_cost')>
<cfset getCollectionLaw = components.getCollectionExpenseLaw(process_type:121,lawRequestId:attributes.id)>
<cfset getExpenseLaw = components.getCollectionExpenseLaw(process_type : 120,lawRequestId:attributes.id)>
<cfquery name="get_law_request" datasource="#dsn#">
	SELECT 
    	LAW_REQUEST_ID, 
        REQUEST_STATUS, 
        COMPANY_ID, 
        CONSUMER_ID, 
        BRANCH_ID, 
        RELATED_ID, 
        PROCESS_CAT, 
        DETAIL, 
        GUARANTOR_DETAIL, 
        MORTGAGE_DETAIL, 
        PAWN_DETAIL, 
        PERFORM_PAY_NETTOTAL1, 
        PERFORM_PAY_NETTOTAL2, 
        IS_MUACCELLIYET, 
        TOTAL_AMOUNT, 
        MONEY_CURRENCY, 
        FILE_NUMBER, 
        FILE_STAGE, 
        LAW_STAGE, 
        LAW_ADWOCATE,
        LAW_ADWOCATE_COMPANY,
        REVENUE_TYPE, 
        REVENUE_DATE, 
        REVENUE_ADWOCATE, 
        REVENUE_ADWOCATE_COMPANY,
        TOTAL_REVENUE, 
        TOTAL_REVENUE_MONEY_CURRENCY, 
        KALAN_REVENUE, 
        DEFAULT_RATE,
        KALAN_REVENUE_MONEY_CURRENCY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE, 
        IS_SUBMIT,
        OBLIGEE_COMPANY_ID,
        OBLIGEE_PARTNER_ID,
        OBLIGEE_CONSUMER_ID,
        OBLIGEE_DETAIL, 
        PROCESS_STAGE,
        CARI_ACTION_ID,
        CREDIT_DATE,
        ACCOUNT_CODE
    FROM 
    	COMPANY_LAW_REQUEST 
    WHERE 
    	LAW_REQUEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfif len(get_law_request.cari_action_id)>
    <cfquery name="get_note" datasource="#dsn2#">
        SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_law_request.cari_action_id#">
    </cfquery>
<cfelseif len(get_law_request.process_cat)>
    <cfquery name="get_note" datasource="#dsn#">
        SELECT LAW_REQUEST_ID AS ACTION_ID,(SELECT PROCESS_TYPE FROM #dsn3#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_law_request.process_cat#">) ACTION_TYPE_ID FROM COMPANY_LAW_REQUEST WHERE LAW_REQUEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
</cfif>
<cfif len(get_law_request.company_id)>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #get_law_request.company_id#
	</cfquery>
	<cfset member_name = '#get_company.fullname#'>
	<cfset member_id = get_law_request.company_id>
	<cfset member_type = 'partner'>
<cfelse>
	<cfquery name="get_consumer" datasource="#dsn#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #get_law_request.consumer_id#
	</cfquery>
	<cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
	<cfset member_id = get_law_request.consumer_id>
	<cfset member_type = 'consumer'>
</cfif>
<cf_catalystHeader>	
<div class="col col-9 col-xs-12">
<cfform name="upd_law_request" method="post" action="#request.self#?fuseaction=ch.emptypopup_upd_law_request">
    <cf_box>
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
        <input type="hidden" name="del_req_id" id="del_req_id" value="0">
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-request_status">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="request_status" id="request_status" <cfif get_law_request.request_status eq 1>checked</cfif>>
                    </div>
                </div>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.İşlem tipi"></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat slct_width="140px" process_cat="#get_law_request.process_cat#">
                    </div>
                </div>
                <div class="form-group" id="item-member_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
                    <div class="col col-8 col-xs-12">
                        <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#member_type#</cfoutput>">
                        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#member_id#</cfoutput>">
                        <input type="text" name="member_name" id="member_name" value="<cfoutput>#member_name#</cfoutput>"  readonly>
                    </div>
                </div>
                <div class="form-group" id="item-process">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' select_value='#get_law_request.process_stage#' process_cat_width='150' is_detail='1'>
                    </div>
                </div>
                <div class="form-group" id="item-obligee_company">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61427.Lehdar'><cf_get_lang dictionary_id='57574.Şirket'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="obligee_consumer_id" id="obligee_consumer_id"  value="#get_law_request.obligee_consumer_id#">
                            <cfinput type="hidden" name="obligee_company_id" id="obligee_company_id" value="#get_law_request.obligee_company_id#" >
                            <cfif len(get_law_request.obligee_company_id) and len(get_law_request.obligee_partner_id)>
                                <input type="text" name="obligee_company" id="obligee_company" value="<cfoutput>#get_par_info(get_law_request.obligee_company_id,1,-1,0)#</cfoutput>"  onfocus="AutoComplete_Create('obligee_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID','obligee_par_name,obligee_consumer_id,obligee_partner_id,obligee_company_id','','3','250');" autocomplete="off">						
                            <cfelseif not len(get_law_request.obligee_company_id) and len(get_law_request.obligee_consumer_id)>
                                <input type="text" name="obligee_company" id="obligee_company" value="<cfoutput>#get_cons_info(get_law_request.obligee_consumer_id,0,0)#</cfoutput>"  onfocus="AutoComplete_Create('obligee_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID','obligee_par_name,obligee_consumer_id,obligee_partner_id,obligee_company_id','','3','250');" autocomplete="off">					
                            <cfelse>
                                <input type="text" name="obligee_company" id="obligee_company" value="" onblur="CheckShow()" onfocus="AutoComplete_Create('obligee_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID','obligee_par_name,obligee_consumer_id,obligee_partner_id,obligee_company_id','','3','250');" autocomplete="off">						
                            </cfif>
                            <span class="input-group-addon icon-ellipsis btnPointer" id="span_dis1" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_law_request.obligee_company_id&is_period_kontrol=0&field_comp_name=upd_law_request.obligee_company&field_partner=upd_law_request.obligee_partner_id&field_consumer=upd_law_request.obligee_consumer_id&field_name=upd_law_request.obligee_par_name&par_con=1&function_name=CheckShow&select_list=2,3</cfoutput>')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-obligee_par_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61427.Lehdar'><cf_get_lang dictionary_id='57578.Yetkili'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="hidden" name="obligee_partner_id" id="obligee_partner_id" value="#get_law_request.obligee_partner_id#">
                     <cfif len(get_law_request.obligee_company_id) and len(get_law_request.obligee_partner_id)>
                        <cfoutput><input type="text" name="obligee_par_name" id="obligee_par_name" value="#get_par_info(get_law_request.obligee_partner_id,0,-1,0)#"></cfoutput>
                    <cfelseif not len(get_law_request.obligee_company_id)  and len(get_law_request.obligee_consumer_id)>
                        <cfoutput><input type="text" name="obligee_par_name" id="obligee_par_name" value="#get_cons_info(get_law_request.obligee_consumer_id,0,0,0)#"></cfoutput>
                    <cfelse>
                        <cfoutput><input type="text" name="obligee_par_name" id="obligee_par_name" value=""></cfoutput>
                    </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-obligee_detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61428.Lehdar Bilgisi'></label>
                    <div class="col col-8 col-xs-12">
                       <cfoutput> <textarea name="obligee_detail" id="obligee_detail"><cfif len(get_law_request.obligee_detail) and  get_law_request.obligee_detail neq 'NULL'> #get_law_request.obligee_detail#</cfif></textarea></cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-acc_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="acc_code" id="acc_code" value="#get_law_request.ACCOUNT_CODE#" onblur="CheckAcc()" onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
                            <span class="input-group-addon btnPointer icon-ellipsis" id="span_dis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=upd_law_request.acc_code&changeFunction=CheckAcc&keyword='+encodeURIComponent(upd_law_request.acc_code.value));"></span>
                        </div>
                    </div>
                </div>                
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-law_name">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',158)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="law_name" id="law_name" value="<cfoutput>#get_law_request.law_stage#</cfoutput>" >
                    </div>
                </div>
                <div class="form-group" id="item-file_number">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',159)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="file_number" id="file_number" value="<cfoutput>#get_law_request.file_number#</cfoutput>" maxlength="50" >
                    </div>
                </div>
                <div class="form-group" id="item-revenue_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarih'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Tarihi Giriniz'></cfsavecontent>
                            <cfinput type="text" name="revenue_date" validate="#validate_style#" required="yes" message="#message#" value="#dateformat(get_law_request.revenue_date,dateformat_style)#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="revenue_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-file_stage">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50130.Dosya Durumu'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="file_stage" id="file_stage" value="<cfoutput>#get_law_request.file_stage#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="item-law_adwocate">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',155)#</cfoutput>1</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="law_adwocate_comp" value="#get_law_request.law_adwocate_company#">
                            <cfinput type="hidden" name="law_adwocate_id" value="#get_law_request.law_adwocate#">
                            <input type="text" name="law_adwocate" id="law_adwocate" value="<cfif len(get_law_request.law_adwocate) and not len(get_law_request.law_adwocate_company)><cfoutput>#get_cons_info(get_law_request.law_adwocate,0,0)#</cfoutput><cfelse><cfoutput>#get_par_info(get_law_request.law_adwocate,0,0,0)#</cfoutput></cfif>" >
                            <span class="input-group-addon icon-ellipsis btnPointer" tiitle="<cf_get_lang dictionary_id='50128.Avukat'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=upd_law_request.law_adwocate&field_id=upd_law_request.law_adwocate_id&field_comp_id=upd_law_request.law_adwocate_comp&select_list=2,3','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-revenue_adwocate">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',155)#</cfoutput>2</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="hidden" name="revenue_adwocate_comp" value="#get_law_request.revenue_adwocate_company#">
                            <cfinput type="hidden" name="revenue_adwocate_id" value="#get_law_request.revenue_adwocate#">
                            <input type="text" name="revenue_adwocate" id="revenue_adwocate" value="<cfif len(get_law_request.revenue_adwocate) and not len(get_law_request.revenue_adwocate_company)><cfoutput>#get_cons_info(get_law_request.revenue_adwocate,0,0)#</cfoutput><cfelse><cfoutput>#get_par_info(get_law_request.revenue_adwocate,0,0,0)#</cfoutput></cfif>" >
                            <span class="input-group-addon icon-ellipsis btnPointer" tiitle="<cf_get_lang dictionary_id='50128.Avukat'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=upd_law_request.revenue_adwocate&&field_id=upd_law_request.revenue_adwocate_id&field_comp_id=upd_law_request.revenue_adwocate_comp&select_list=2,3','list');"></span>
                        </div>
                    </div>
                </div>  
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="detail"  id="detail"><cfoutput>#get_law_request.detail#</cfoutput></textarea>
                    </div>
                </div>              
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-credite_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65235.Alacak Tarih'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="credite_date" validate="#validate_style#" value="#dateformat(get_law_request.CREDIT_DATE,dateformat_style)#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="credite_date"></span>
                        </div>
                    </div>
                </div>           
                <div class="form-group" id="item-total_credit">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('ch',154)#</cfoutput>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="total_credit" class="moneybox" value="#tlformat(get_law_request.total_amount,2)#" onkeyup="return(FormatCurrency(this,event));" onBlur="kalan();">
                            <span class="input-group-addon width">
                                <select name="money_currency" id="money_currency">
                                    <cfoutput query="get_money">
                                        <option value="#get_money.money#" <cfif get_money.money eq get_law_request.money_currency>selected</cfif>>#get_money.money#</option>
                                    </cfoutput>
                                </select>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-total_revenue">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57845.Tahsilat'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="total_revenue" class="moneybox" value="#tlformat(get_law_request.total_revenue,2)#" readonly onkeyup="return(FormatCurrency(this,event));" onBlur="kalan();">
                    </div>
                </div>
                <div class="form-group" id="item-kalan_revenue">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58444.Kalan'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="kalan_revenue" class="moneybox" value="#tlformat(get_law_request.kalan_revenue,2)#" onkeyup="return(FormatCurrency(this,event));" onBlur="kalan();">
                    </div>
                </div>
                <div class="form-group" id="item-default_rate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64369.Temerrüt Oranı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="default_rate" id="default_rate" class="moneybox" value="#tlformat(get_law_request.DEFAULT_RATE,2)#">
                    </div>
                </div>                
            </div>
        </cf_box_elements>
        <cf_box_footer>	
            <div class="col col-6 col-xs-12">
                <cf_record_info query_name="get_law_request">
            </div>
            <div class="col col-6 col-xs-12">
                <cf_workcube_buttons 
                    type_format="1" 
                    is_upd='1' 
                    add_function='kontrol()' 
                    del_page_url='#request.self#?fuseaction=ch.emptypopup_upd_law_request&del_req_id=#attributes.id#'
                    del_function='del_kontrol()'
                    >
            </div>
        </cf_box_footer> 
    </cf_box>
    <!--- tahsilat ve harcamalar title="#getLang('','',57845)# #getLang('','',47900)#"--->
    <cf_box>
        <cf_seperator id="collection" header="#getLang('','',57845)#">
        <div id="collection">
        <cfset totalCollection = 0>
            <cf_grid_list>
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id ='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id ='57946.Fiş No'></th>
                        <th><cf_get_lang dictionary_id ="57800.İşlem tipi"></th>
                        <th><cf_get_lang dictionary_id ="58173.Gelir Kalemi"></th>
                        <th><cf_get_lang dictionary_id ="58811.Muhasebe Kodu"></th>
                        <th><cf_get_lang dictionary_id ='57845.Tahsilat'></th>
                        <th><cf_get_lang dictionary_id ='57589.Bakiye'></th>
                        <th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
                        <cfoutput><th width="20" class="header_icn_none" nowrap="nowrap"><a href="#request.self#?fuseaction=cost.add_income_cost&law_request_id=#attributes.id#"  target="blank_" ><i class="fa fa-plus" title="#getLang('','',58065)# #getLang('','',57582)#"></i></a></th></cfoutput>
                    </tr>
                </thead>
                <cfif getCollectionLaw.recordcount>
                    <tbody>
                        <cfoutput query="getCollectionLaw">
                            <tr>
                                <td>#dateformat(expense_date,dateformat_style)#</td>
                                <td>#PAPER_NO#</td>
                                <td>#PROCESS_CAT#</td>
                                <td>#EXPENSE_ITEM_NAME#</td>
                                <td>#ACCOUNT_CODE#</td>
                                <td style="text-align:right;">#TLFormat(TOTAL_AMOUNT)#<cfset totalCollection += total_amount></td>
                                <td style="text-align:right;">#TLFormat(TOTAL_CREDIT-totalCollection)#</td>
                                <td>#KALAN_REVENUE_MONEY_CURRENCY#</td>
                                <td><a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#expense_id#" target="blank"><i class="fa fa-pencil" title="#getLang('','',58065)# #getLang('','',57464)#"></i></a></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <cfoutput>
                            <tr>
                                <td colspan="5"><cf_get_lang dictionary_id='39894.Toplam Tahsilat'></td>
                                <td  style="text-align:right;">#tlformat(totalCollection)#</td>
                                <cfinput name = "totalCollection_" id="totalCollection_" type = "hidden" value="#TLFormat(totalCollection,2)#">
                            </tr>
                        </cfoutput>
                    </tfoot>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="7">
                                <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                            </td>
                        </tr>
                    </tbody>
                </cfif>
            </cf_grid_list>
        </div>
        <cf_seperator id="expense" header="#getLang('','',51532)#">
        <div id="expense">
            <cf_grid_list>
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id ='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id ='57946.Fiş No'></th>
                        <th><cf_get_lang dictionary_id ="57800.İşlem tipi"></th>
                        <th><cf_get_lang dictionary_id ="58551.Gider Kalemi"></th>
                        <th><cf_get_lang dictionary_id ="58811.Muhasebe Kodu"></th>
                        <th><cf_get_lang dictionary_id ='51532.Harcama'></th>
                        <th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
                        <cfoutput><th width="20" class="header_icn_none" nowrap="nowrap"><a href="#request.self#?fuseaction=cost.form_add_expense_cost&law_request_id=#attributes.id#" target="blank_"><i class="fa fa-plus" title="#getLang('','',58064)# #getLang('','',57582)#"></i></a></th></cfoutput>
                    </tr>
                </thead>
                <tbody>
                    <cfif getExpenseLaw.recordcount>
                        <cfoutput query="getExpenseLaw">
                            <tr>
                                <td>#dateformat(expense_date,dateformat_style)#</td>
                                <td>#PAPER_NO#</td>
                                <td>#PROCESS_CAT#</td>
                                <td>#EXPENSE#</td>
                                <td>#ACCOUNT_CODE#</td>
                                <td style="text-align:right;">#TLFormat(TOTAL_AMOUNT)#</td>
                                <td>#session.ep.money#</td>
                                <td><a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#" target="blank"><i class="fa fa-pencil" title="#getLang('','',58064)# #getLang('','',57464)#"></i></a></td>
                            </tr>
                        </cfoutput>                
                    <cfelse>
                        <tr>
                            <td colspan="7">
                                <cf_get_lang dictionary_id='57484.Kayıt Yok'>
                            </td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
    </cf_box>
    <cf_box>
        <div class="col col-12">
            <div class="form-group" id="item-show_company_info">
                <div class="col col-12">
                    <div id="show_company_info"></div>
                    <script type="text/javascript">
                        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ch.ajax_popup_view_cheque_voucher&member_id=#member_id#&member_type=#member_type#</cfoutput>','show_company_info',1);
                    </script>
                </div>
            </div>
        </div>
    </cf_box>
</cfform>
</div>	
<div class="col col-3 col-xs-12">
    <!--- Notlar title="#getLang('','',57845)# #getLang('','',47900)#"--->
    <cf_get_workcube_note action_section='LAW_REQUEST_ID' action_id='#attributes.id#' style='1'>
    <!--- Belgeler --->
    <cf_get_workcube_asset asset_cat_id="-7" module_id='23' action_section='LAW_REQUEST_ID' action_id='#attributes.id#'>
    <!--- ajanda --->
    <cf_get_related_events action_section='LAW_REQUEST_ID' action_id='#url.id#' company_id='#session.ep.company_id#'>
</div>
<script type="text/javascript">
    $( document ).ready(function() {
        if($('#totalCollection_').val()) 
            document.upd_law_request.total_revenue.value = commaSplit(parseInt(filterNum($('#totalCollection_').val(),2)),2);
        if($('#total_revenue').val()!="") 
            var totalRevenue = $('#total_revenue').val();
        else 
            var totalRevenue = 0;
        document.upd_law_request.kalan_revenue.value = commaSplit(filterNum(document.upd_law_request.total_credit.value,2) - filterNum(totalRevenue,2),2);
        if($('#acc_code').val()!="") 
            $("span#span_dis1,input#obligee_company").css("pointer-events", "none");
        else if ($('#obligee_company').val()!="") 
            $("span#span_dis,input#acc_code").css("pointer-events", "none");
    });
	function del_kontrol()
	{
		document.getElementById('del_req_id').value = '<cfoutput>#attributes.id#</cfoutput>';
		document.getElementById('upd_law_request').submit();
	}
	function kontrol()
	{
        if(!chk_process_cat('upd_law_request')) return false;
		if(document.upd_law_request.member_name.value == "" )
		{
			alert("<cf_get_lang dictionary_id='50081.Lütfen Cari Hesap Seçiniz'> !");
			return false;
        }
        if((($('#obligee_company_id').val()=="" && $('#obligee_consumer_id').val()=="") || $('#obligee_company').val()=="") && (($('#law_adwocate_id').val()=="" && $('#law_adwocate_comp').val()=="") || $('#law_adwocate').val()=="")  && (($('#revenue_adwocate_id').val()=="" && $('#revenue_adwocate_comp').val()=="") || $('#revenue_adwocate').val()=="") && ($('#acc_code').val()==""))   
        {
            alert("<cf_get_lang dictionary_id='61451.Lütfen Lehdar Şirketi veya Avukat seçiniz'> ");
            return false;
        }
		if(document.upd_law_request.file_number.value == "")
		{
			alert("<cf_get_lang dictionary_id='50080.Lütfen Dosya No Giriniz'> !");
			return false;
        }
        if(document.upd_law_request.total_credit.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> :  <cf_get_lang dictionary_id='50127.Alacak Tutar'>!");
			return false;
		}
        if(document.upd_law_request.total_revenue.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57845.Tahsilat'>!");
			return false;
		}
		var kontrol = 0;
		for (var i=1; i <= document.all.record_num1.value; i++)
		{
			var form_field = eval("document.all.cheque_row1" + i);
			if(form_field.checked == true)
				kontrol = 1;
		}
		for (var i=1; i <= document.all.record_num1_2.value; i++)
		{
			var form_field = eval("document.all.cheque_row1_2" + i);
			if(form_field.checked == true)
				kontrol = 1;
		}
		for (var i=1; i <= document.all.record_num2.value; i++)
		{
			var form_field = eval("document.all.cheque_row2" + i);
			if(form_field.checked == true)
				kontrol = 1;
		}
		for (var i=1; i <= document.all.record_num2_2.value; i++)
		{
			var form_field = eval("document.all.cheque_row2_2" + i);
			if(form_field.checked == true)
				kontrol = 1;
		}
		document.upd_law_request.total_credit.value = filterNum(document.upd_law_request.total_credit.value);
		document.upd_law_request.total_revenue.value = filterNum(document.upd_law_request.total_revenue.value);
		document.upd_law_request.kalan_revenue.value = filterNum(document.upd_law_request.kalan_revenue.value);
		if(process_cat_control()==false)
			return false;
		else
		{
			if(kontrol == 1)
				if(confirm("<cf_get_lang dictionary_id='50076.Seçtiğiniz Çek ve Senetler İcra Aşamasına Getirilecektir Emin misiniz'>?") == true)
					return true;
				else
					return false;
        }
	}
	function kontrol2()
	{
		upd_law_request.del_req_id.value = <cfoutput>#attributes.id#</cfoutput>;
		return true;
	}
	function kalan()
	{
		document.upd_law_request.kalan_revenue.value = commaSplit(filterNum(document.upd_law_request.total_credit.value,2) - filterNum(document.upd_law_request.total_revenue.value,2),2);
	}
	function sayfa_getir(id,type)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=ch.ajax_popup_view_cheque_voucher&member_type='+type+'&member_id='+id+'','show_company_info');
	}
    function CheckShow() {
            $("span#span_dis,input#acc_code").css("pointer-events", "none");
        }
    function CheckAcc() {
        $("span#span_dis1,input#obligee_company").css("pointer-events", "none");
    }
</script>
