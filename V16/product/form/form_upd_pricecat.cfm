<cfset xml_page_control_list = 'is_multi_branch,is_calculate_type'>
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND PRICE_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#">
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfquery name="POSITION_CATEGORIES" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
        PRICE_CATID,
        PRICE_CAT_STATUS,
        GUEST,
        COMPANY_CAT,
        CONSUMER_CAT,
        BRANCH,
        #dsn#.Get_Dynamic_Language(PRICE_CATID,'#session.ep.language#','PRICE_CAT','PRICE_CAT',NULL,NULL,PRICE_CAT) AS PRICE_CAT,
        DISCOUNT,
        IS_KDV,
        TARGET_MARGIN,
        TARGET_MARGIN_ID,
        MARGIN,
        STARTDATE,
        FINISHDATE,
        VALID_DATE,
        VALID_EMP,
        MONEY_ID,
        ROUNDING,
        NUMBER_OF_INSTALLMENT,
        AVG_DUE_DAY,
        DUE_DIFF_VALUE,
        PAYMETHOD,
        EARLY_PAYMENT,
        TARGET_DUE_DATE,
        IS_CALC_PRODUCTCAT,
        IS_SALES,
        IS_PURCHASE,
        POSITION_CAT,
        RECORD_EMP,
        RECORD_DATE,
        RECORD_IP,
        UPDATE_EMP,
        UPDATE_DATE,
        UPDATE_IP
    FROM 
        PRICE_CAT 
    WHERE 
        PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#"> 
    ORDER BY PRICE_CAT
</cfquery>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_add_pricecat">
<cfinclude template="../query/get_branch.cfm">
<cfparam name="modal_id" default="">
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_add_pricecat"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent>
<!--- <cf_catalystHeader> --->
    <cf_box id="box_updprice" title="#getLang('','Fiyat Listeleri',37028)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_upd_pricecat" method="post" action="#request.self#?fuseaction=product.emptypopup_create_list">
        <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>"> 
        <input type="hidden" name="pcat_id" id="pcat_id" value="<cfoutput>#attributes.pcat_id#</cfoutput>" />
        <input type="hidden" name="go_val" id="go_val">
        <input type="hidden" name="is_multi_branch" id="is_multi_branch" value="<cfoutput>#is_multi_branch#</cfoutput>"> 
        <input type="hidden" name="is_calculate_type" id="is_calculate_type" value="<cfif isdefined("is_calculate_type")><cfoutput>#is_calculate_type#</cfoutput><cfelse>0</cfif>"> 
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="false">                    	
                <label class="col col-12 bold"><cf_get_lang dictionary_id='37140.Yayın Alanı'></label>    
                <ul class="ui-list">
                    <li>
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-collaboration"></span>
                                <cf_get_lang dictionary_id='29408.Kurumsal Üyeler'>
                            </div>
                            <div class="ui-list-right">
                                <i class="fa fa-chevron-down"></i>
                            </div>
                        </a>
                        <ul>
                                    <li>
                                        <a href="javascript:void(0)">
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                                                <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                                            </div>
                                            <div class="ui-list-right">
                                                <input type="checkbox" name="all_company_cat" id="all_company_cat" value="1" onclick="wrk_select_all('all_company_cat','COMPANY_CAT')">
                                            </div>
                                        </a>
                                       </li>
                                    <li>
                            <cfoutput query="get_company_cat">
                                    <a href="javascript:void(0)">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-collaboration"></span>
                                            #companycat#
                                        </div>
                                        <div class="ui-list-right">
                                            <input type="checkbox" name="COMPANY_CAT" id="COMPANY_CAT" value="#companycat_id#" <cfif listfind(get_price_cat.company_cat,companycat_id)> checked</cfif>>
                                        </div>
                                    </a>
                                   </li>
                            </cfoutput>
                         
                        </ul>
                    </li>
                    <li>
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-network-1"></span>
                                <cf_get_lang dictionary_id='29406.Bireysel Üyeler'>
                            </div>
                            <div class="ui-list-right">
                                <i class="fa fa-chevron-down"></i>
                            </div>
                        </a>
                        <ul>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                                    <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                                </div>
                                <div class="ui-list-right">
                                    <input type="checkbox" name="all_consumer_cat" id="all_consumer_cat" value="1" onclick="wrk_select_all('all_consumer_cat','consumer_cat')">                                    </div>
                            </a>
                            </li>
                        <li>
                            <cfoutput query="get_consumer_cat">
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-network-1"></span>
                                #conscat#
                            </div>
                            <div class="ui-list-right">
                                <input type="checkbox" name="consumer_cat" id="consumer_cat" value="#conscat_id#" <cfif listfind(get_price_cat.CONSUMER_CAT,conscat_id)> checked</cfif>>
                            </div>
                        </a>
                        </li>
                         </cfoutput>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-banks"></span>
                                <cf_get_lang dictionary_id='29434.Şubeler'>
                            </div>
                            <div class="ui-list-right">
                                <i class="fa fa-chevron-down"></i>
                            </div>
                        </a>
                        <ul>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                                    <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                                </div>
                                <div class="ui-list-right">
                                    <input type="checkbox" name="all_branch" id="all_branch" value="1" onclick="wrk_select_all('all_branch','branch')">                                  
                                    </div>
                            </a>
                            </li>
                        <li>
                            <cfoutput query="get_branch">
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-banks"></span>
                                #branch_name#
                            </div>
                            <div class="ui-list-right">
                                <input type="checkbox" name="branch" id="branch" value="#branch_id#" <cfif listfind(get_price_cat.branch,branch_id)> checked</cfif>>
                            </div>
                        </a>
                        </li>
                </cfoutput>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-stats-3"></span>
                                <cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'>
                            </div>
                            <div class="ui-list-right">
                                <i class="fa fa-chevron-down"></i>
                            </div>
                        </a>
                        <ul>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-maps-and-flags-3"></span>
                                    <cf_get_lang dictionary_id='37814.Hepsini Seç'>
                                </div>
                                <div class="ui-list-right">
                                    <input type="checkbox" name="all_position_cat" id="all_position_cat" value="1" onclick="wrk_select_all('all_position_cat','position_cat')">                                    </div>
                            </a>
                            </li>
                        <li>
                            <cfoutput query="position_categories">
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-stats-3"></span>
                                #position_cat# 
                            </div>
                            <div class="ui-list-right">
                                <input type="checkbox" name="position_cat" id="position_cat" value="#position_cat_id#" <cfif listfind(get_price_cat.position_cat,position_cat_id)> checked</cfif>>                         </div>
                        </a>
                        </li>
                </cfoutput>
                        </ul>
                    </li>
                </ul>
            </div>       
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                            <div class="row">
                                <div class="col col-12">
                                    <div class="form-group" id="item-is_purchase">
                                        <label class="col col-4" class="hide"><cf_get_lang dictionary_id='59088.Tip'></label>
                                        <label class="col col-4"><cf_get_lang dictionary_id='58176.Alış'><input type="checkbox" name="is_purchase" id="is_purchase" value="1" <cfif get_price_cat.is_purchase eq 1>checked</cfif>></label>
                                        <label class="col col-4"><cf_get_lang dictionary_id='57448.Satış'><input type="checkbox" name="is_sales" id="is_sales" value="1" <cfif get_price_cat.is_sales eq 1>checked</cfif>></label>
                                    </div>
                                    <div class="form-group" id="item-price_cat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37144.Liste Adı'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37405.Liste Girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="price_cat" value="#get_price_cat.price_cat#" required="yes" message="#message#" style="width:215px;" maxlength="100">
                                                <span class="input-group-addon">
                                                    <cf_language_info 
                                                        table_name="PRICE_CAT" 
                                                        column_name="PRICE_CAT" 
                                                        column_id_value="#attributes.pcat_id#" 
                                                        maxlength="50" 
                                                        datasource="#dsn3#" 
                                                        column_id="PRICE_CATID" 
                                                        control_type="0">
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-price_cat_status">
                                        <label class="col col-4">
                                            <cf_get_lang dictionary_id='38006.Fiyat Eklenmesin'>
                                            </label><label class="col col-8"><input type="checkbox" name="price_cat_status" id="price_cat_status" value="1" <cfif get_price_cat.price_cat_status eq 1>checked</cfif>></label>
                                    </div>
                                    <cfif isdefined	("is_product_date")	and is_product_date EQ 1 >
                                        <div class="form-group" id="item-product_startdate">
                                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="col col-6">
                                                <div class="input-group">
                                                    <cfinput type="text" name="product_startdate" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes"  style="width:65px;">
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="product_startdate"></span>
                                                    </div></div><div class="col col-6"> <div class="input-group">
                                                    <cfinput type="text" name="product_finishdate" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" style="width:65px;">
                                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="product_finishdate"></span>
                                                </div>
                                            </div>
                                            </div>
                                        </div>
                                    </cfif>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col col-12">
                                	<div class="form-group" id="item-label_price">
                                    	<label class="col col-12 bold"><cf_get_lang dictionary_id='37145.Fiyatlandırma Yöntemi'></label>
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <div class="form-group" id="item-target_margin">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37819.Düzenleme Oranı'> (+/-)</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-6">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37820.Düzenleme Oranı Girmelisiniz'> !</cfsavecontent>
                                                <cfinput type="text" name="margin" value="#get_price_cat.margin#" validate="float" message="#message#" style="width:30px;">
                                                </div>  <div class="col col-6">
                                                <select name="target_margin" id="target_margin" style="width:180px;">
                                                    <option value="-5" <cfif get_price_cat.target_margin_id eq -5> selected</cfif>><cf_get_lang dictionary_id='37083.Son Alış Fiyatı'></option>
                                                    <option value="-4" <cfif get_price_cat.target_margin_id eq -4> selected</cfif>><cf_get_lang dictionary_id='37816.Ortalama Alış Fiyatı'></option>
                                                    <option value="-3" <cfif get_price_cat.target_margin_id eq -3> selected</cfif>><cf_get_lang dictionary_id='37817.Maliyet Fiyatı'></option>
                                                    <option value="-1" <cfif get_price_cat.target_margin_id eq -1> selected</cfif>><cf_get_lang dictionary_id='37818.Standart Alış Fiyatı'></option>
                                                    <option value="-2" <cfif get_price_cat.target_margin_id eq -2> selected</cfif>><cf_get_lang dictionary_id='37600.Standart Satış Fiyatı'></option>
                                                    <cfoutput query="get_price_cats">
                                                        <option value="#get_price_cats.price_catid#" <cfif get_price_cat.target_margin_id eq get_price_cats.price_catid>selected</cfif>>#price_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-is_price_from_category">
                                        <label class="col col-4"><cf_get_lang dictionary_id='38007.Ürün Kategori Marjından Hesapla'></label><label class="col col-8"><input type="checkbox" name="is_price_from_category" id="is_price_from_category" value="1" <cfif len(get_price_cat.is_calc_productcat) and get_price_cat.is_calc_productcat>checked</cfif>></label>
                                    </div>
                                    <div class="form-group" id="item-start_date">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="startdate" value="#dateformat(get_price_cat.startdate,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                            </div></div>
                                            <div class="col col-3">
                                                <cfif hour(get_price_Cat.startdate)> 
                                                <cf_wrkTimeFormat name="start_clock" value="#hour(get_price_Cat.startdate)#">
                                                <cfelse>
                                                <cf_wrkTimeFormat name="start_clock" value="">
                                                </cfif>
                                            </div>
                                            <div class="col col-3">
                                                <select name="start_min" id="start_min" style="width:40px;">
                                                    <cfloop from="0" to="55" index="i" step="5">
                                                        <cfoutput><option value="#i#" <cfif i eq minute(get_price_cat.startdate)> selected</cfif>>#NumberFormat(i,00)#</option></cfoutput>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-rounding">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57710.Yuvarlama'></label>
                                        <div class="col col-8 col-xs-12">
                                            <select name="ROUNDING"  id="ROUNDING">
                                                <cfloop from="0" to="3" index="round_no">
                                                    <cfoutput>
                                                        <option value="#round_no#" <cfif get_price_cat.rounding is round_no>selected</cfif>>#round_no#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-is_kdv">
                                        <label class="col col-4"><cf_get_lang dictionary_id='37365.KDV Dahil'></label><label class="col col-8"><input type="checkbox" name="IS_KDV" id="IS_KDV" value="" <cfif get_price_cat.is_kdv is 1>checked</cfif>></label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                            	<div class="col col-12">
                                	<div class="form-group" id="item-label_due">
                                    	<label class="col col-12 bold"><cf_get_lang dictionary_id='37550.Vadelendirme Yöntemi'></label>
                                    </div>
                                </div>
                                
                                <div class="col col-12">
                                    <div class="form-group" id="item-number_of_installment">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37551.Taksit Sayısı'></label>
                                        <div class="col col-8 col-xs-12">
                                            <input name="number_of_installment" id="number_of_installment" type="text" value="<cfoutput>#get_price_cat.number_of_installment#</cfoutput>" onBlur="hesapla_vade();empty_due_day(1);" onKeyUp="return(FormatCurrency(this,event,0));">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-target_due_date">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57861.Ortalama Vade'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-6">
                                                <input name="avg_due_day" id="avg_due_day" type="text"  value="<cfoutput>#get_price_cat.avg_due_day#</cfoutput>" onKeyUp="empty_due_day(2);return(FormatCurrency(this,event,0));" style="width:35px;">
                                            </div> <div class="col col-6">
                                                <div class="input-group">
                                                <cfinput type="text" name="TARGET_DUE_DATE"  value="#DateFormat(get_price_cat.target_due_date,dateformat_style)#" message="#message#" validate="#validate_style#" style="width:65px;" onChange="empty_due_day(3);">
                                                <span class="input-group-addon btnPointer">
                                                    <cf_wrk_date_image date_field="TARGET_DUE_DATE">
                                                </span>
                                            </div></div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-due_diff_value">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58501.Vade Farkı'> %</label>
                                        <div class="col col-8 col-xs-12">
                                            <input name="due_diff_value" id="due_diff_value" type="text" value="<cfoutput>#TLFormat(get_price_cat.due_diff_value)#</cfoutput>"  onKeyUp="return(FormatCurrency(this,event));" style="width:35px;">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-early_payment">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37608.Erken Ödeme'> %</label>
                                        <div class="col col-8 col-xs-12">
                                            <input name="early_payment" id="early_payment" type="text" value="<cfoutput>#TLFormat(get_price_cat.early_payment)#</cfoutput>"onKeyUp="return(FormatCurrency(this,event));" style="width:35px;">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-paymethod">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="4" <cfif get_price_cat.paymethod eq 4>checked</cfif>><cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
                                            <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="1" <cfif get_price_cat.paymethod eq 1>checked</cfif>><cf_get_lang dictionary_id='58007.Çek'></label>
                                            <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="2" <cfif get_price_cat.paymethod eq 2>checked</cfif>><cf_get_lang dictionary_id='58008.Senet'></label>
                                            <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="3" <cfif get_price_cat.paymethod eq 3>checked</cfif>><cf_get_lang dictionary_id='37610.Havale'></label>
                                            <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="6" <cfif get_price_cat.paymethod eq 6>checked</cfif>><cf_get_lang dictionary_id='58645.Nakit'></label>
                                            <label class="col col-12"><input type="radio" name="paymethod" id="paymethod" value="8" <cfif get_price_cat.paymethod eq 8>checked</cfif>><cf_get_lang dictionary_id='42985.DBS'></label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-9 col-xs-12" type="column" index="3" sort="false">
							<cfif len(listsort(get_price_cat.company_cat,'Numeric'))>
                                <cfquery name="GET_COMPANY_RECORD" datasource="#DSN#">
                                    SELECT 
                                        COMPANYCAT 
                                    FROM 
                                        COMPANY_CAT 
                                    WHERE 
                                        COMPANYCAT_ID IN (#listsort(get_price_cat.company_cat,'Numeric')#)
                                </cfquery>
                            <cfelse>
                                <cfset get_company_record.recordcount = 0>
                            </cfif>
                            <cfif len(listsort(get_price_cat.consumer_cat,'Numeric'))>
                                <cfquery name="GET_CONSUMER_RECORD" datasource="#DSN#">
                                    SELECT 
                                      CONSCAT 
                                    FROM 
                                      CONSUMER_CAT 
                                    WHERE 
                                      CONSCAT_ID IN (#listsort(get_price_cat.consumer_cat,'Numeric')#)
                                </cfquery>
                            <cfelse>
                                <cfset get_consumer_record.recordcount = 0>
                            </cfif> 
                            <cfif len(listsort(get_price_cat.branch,'Numeric'))>
                                <cfquery name="GET_BRANCH_RECORD" datasource="#DSN#">
                                  SELECT 
                                      BRANCH_NAME 
                                  FROM 
                                      BRANCH 
                                  WHERE 
                                      BRANCH_ID IN (#listsort(get_price_cat.branch,'Numeric')#)
                                </cfquery>
                            <cfelse>
                                <cfset get_branch_record.recordcount = 0>
                            </cfif>
                            <br/><br/>
                            <table>
                                <tr>
                                    <td class="formbold"><cf_get_lang dictionary_id='37193.Bu Fiyat Kategorisinin Kullanıcıları'></td>
                                </tr>
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'> :</b>
                                        <cfif get_company_record.recordcount><cfoutput query="get_company_record">#companycat#,&nbsp;</cfoutput></cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'> :</b>
                                        <cfif get_consumer_record.recordcount><cfoutput query="get_consumer_record">#conscat#,&nbsp;</cfoutput></cfif>
                                    </td>
                                </tr>													
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='29434.Şubeler'> : </b>
                                        <cfif get_branch_record.recordcount><cfoutput query="get_branch_record">#branch_name#,&nbsp;</cfoutput></cfif>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </cf_box_elements>
                   <cf_box_footer>
                        <cf_record_info query_name='get_price_cat'>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37012.Liste Oluştur'></cfsavecontent>
                            <cf_workcube_buttons class="ui-wrk-btn ui-wrk-btn-extra" is_upd='0' is_cancel='0' add_function='kontrol_(1)' insert_info='#message#' insert_alert=''>
                            <cfif session.ep.admin>
                                <cf_workcube_buttons  add_function="kontrol_(0)" is_upd='1' delete_page_url='#request.self#?fuseaction=product.del_pricecat&pcat_id=#attributes.pcat_id#&head=#get_price_cat.price_cat#'>
                            <cfelse>
                                <cf_workcube_buttons add_function="kontrol_(0)" is_upd='1' is_delete='0'>
                            </cfif>
                    </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">		
	function kontrol_(type_)
	{
		//Coklu sube secim kontrolu
		if(document.form_upd_pricecat.is_multi_branch.value==0)
		{
			sayac = 0;
			if(document.form_upd_pricecat.branch!= undefined && document.form_upd_pricecat.branch.length != undefined)
			{
				for (i=0; i < form_upd_pricecat.branch.length; i++)
				{
					if(form_upd_pricecat.branch[i].checked==true)
						sayac = sayac + 1;
				}
			}		
			if(sayac > 1)
			{
				alert("<cf_get_lang dictionary_id ='37790.Yapılan Tanımdan Dolayı Listede Çoklu Şube Şeçimi Yapamazsınız'> !");
				return false;
			}
		}	
		if ((document.form_upd_pricecat.avg_due_day.value == '' && document.form_upd_pricecat.TARGET_DUE_DATE.value == ''))
		{
			alert("<cf_get_lang dictionary_id ='37792.Ortalama Vade ve Vade Tarihi alanları aynı anda boş olamaz'> !");
			return false;
		}	
		if (document.form_upd_pricecat.margin.value > 10000 && document.form_upd_pricecat.margin.value == '')
		{
			window.alert("<cf_get_lang dictionary_id ='37821.Girdiğiniz Düzenleme Oranı Yanlış! Lütfen Değiştirin'> !");
			return false;
		}
		
		if (type_ == 1)
			document.form_upd_pricecat.go_val.value = "1";
		else
			document.form_upd_pricecat.go_val.value = "0";
			
		var str_me = form_upd_pricecat.number_of_installment;if(str_me!= null)str_me.value=filterNum(str_me.value);	
		var str_me = form_upd_pricecat.avg_due_day;if(str_me!= null)str_me.value=filterNum(str_me.value);	
		var str_me = form_upd_pricecat.due_diff_value;if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me = form_upd_pricecat.early_payment;if(str_me!= null)str_me.value=filterNum(str_me.value);		
		return true;
	}
	function hesapla_vade()
	{
		document.form_upd_pricecat.avg_due_day.value = (30+(document.form_upd_pricecat.number_of_installment.value*30))/2;
	}
	function empty_due_day(deger)
	{
		if(deger==1)//taksit sayısından geliyo
			document.form_upd_pricecat.TARGET_DUE_DATE.value = '';
		else if(deger==2)//ortalama vadeden geliyorsa
			document.form_upd_pricecat.TARGET_DUE_DATE.value='';
		else if (deger==3)
		{
			document.form_upd_pricecat.avg_due_day.value='';
			document.form_upd_pricecat.number_of_installment.value='';
		}
	}
    $('.ui-list li a i.fa-chevron-down').click(function(){
                $(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
                $(this).closest('li').find("> ul").fadeToggle();
      });
</script>
