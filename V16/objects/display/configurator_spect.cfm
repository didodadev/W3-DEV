<cfif IsDefined("attributes.set_basket") and attributes.set_basket eq 1><!--- Spekt listesi modalından baskete değer atamak için kullanılır --->
    <cfinclude template = "list_spect_js.cfm">
    <cfabort>
</cfif>
<cfset url_str="">
<cfloop index="i" from="2" to="#ListLen(CGI.QUERY_STRING,'&')#">
<cfif ListGetAt(CGI.QUERY_STRING,i,"&") eq 'draggable=1'><cfbreak>
</cfif>
  <cfset url_str=url_str&"&"&ListGetAt(CGI.QUERY_STRING,i,"&")>
</cfloop>
<cfparam name="attributes.is_search" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.origin" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.form_submitted" default="1">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

<cfif not len(attributes.stock_id) and isdefined('attributes.product_id')>
    <cfquery name="GET_STK" datasource="#DSN3#" maxrows="1">
        SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
    </cfquery>
    <cfset attributes.stock_id = get_stk.stock_id>
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
    <cf_date tarih = "attributes.start_date">
<cfelse>
    <cfset attributes.start_date="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
    <cf_date tarih = "attributes.finish_date">
<cfelse>
    <cfset attributes.finish_date="">
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
    SELECT	RATE1,RATE2,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
</cfquery>
<cfset queryString = "">
<cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
    <cfset queryString = "#queryString#&create_main_spect_and_add_new_spect_id=#attributes.create_main_spect_and_add_new_spect_id#">
</cfif>
<cfif isdefined("attributes.row_id")>
    <cfset queryString = "#queryString#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
    <cfset queryString = "#queryString#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
    <cfset queryString = "#queryString#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
    <cfset queryString = "#queryString#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.basket_id")>
    <cfset queryString = "#queryString#&basket_id=#attributes.basket_id#">
</cfif>
<cfif isdefined("attributes.is_refresh")>
    <cfset queryString = "#queryString#&is_refresh=#attributes.is_refresh#">
</cfif>
<cfif isdefined("attributes.form_name")>
    <cfset queryString = "#queryString#&form_name=#attributes.form_name#">
</cfif>
<cfif isdefined("attributes.company_id")>
    <cfset queryString = "#queryString#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
    <cfset queryString = "#queryString#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.main_stock_amount")>
    <cfset queryString = "#queryString#&main_stock_amount=#attributes.main_stock_amount#">
</cfif>
<cfif isdefined("attributes.paper_department")>
    <cfset queryString = "#queryString#&paper_department=#attributes.paper_department#">
</cfif>
<cfif isdefined("attributes.paper_location")>
    <cfset queryString = "#queryString#&paper_location=#attributes.paper_location#">
</cfif>
<cfif isdefined("attributes.sepet_process_type")>
    <cfset queryString = "#queryString#&sepet_process_type=#attributes.sepet_process_type#">
</cfif>
<cfloop query="get_money">
    <cfif isdefined("attributes.#money#") >
        <cfset queryString = "#queryString#&#money#=#evaluate("attributes.#money#")#">
    </cfif>
</cfloop>
<cfif isdefined("attributes.search_process_date")>
    <cfset queryString = "#queryString#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.only_list") and len(attributes.only_list)><!--- spec tiklandidinda detayina gidecekse yoksa baskete atar--->
    <cfset queryString="&only_list=#attributes.only_list#">
</cfif>
<cfif isdefined("attributes.modal_id")>
    <cfset queryString = "#queryString#&modal_id=#attributes.modal_id#">
</cfif>
<cfif len(attributes.stock_id)>
    <cfquery name="PRODUCT_NAMES" datasource="#DSN3#">
        SELECT
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.PROPERTY,
            STOCKS.PRODUCT_NAME,
            STOCKS.IS_PROTOTYPE,
            STOCKS.IS_PRODUCTION
        FROM
            STOCKS
        WHERE
            STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
    </cfquery>
    <cfset attributes.product_name = product_names.product_name>
</cfif>

<cfset attributes.spect_type="objects.popup_add_spect_list">

<cfif isdefined("attributes.form_submitted")>
    <cfinclude  template="../query/get_spect_var.cfm">
<cfelse>
    <cfset get_spect_var.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default="#get_spect_var.query_count?:get_spect_var.recordcount#">

<cfif attributes.is_search eq 0>
    <cfform name="form_search" action="#request.self#?fuseaction=objects.popup_configurator_spect#queryString#" method="post">
        <cf_box_search>
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <input type="hidden" name="is_search" id="is_search" value="1">
            <div class="form-group" id="price_change">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <cfinput type="text" name="keyword" id="keyword" style="width:70px;" placeholder="#message#" value="#attributes.keyword#">
            </div>
            <div class="form-group" id="item-origin">
                <select name="origin">
                    <option value=""><cf_get_lang dictionary_id='62469.Origin'></option>
                    <option value="1" <cfoutput>#attributes.origin eq 1 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='36365.Ürün Ağacı'></option>
                    <option value="2" <cfoutput>#attributes.origin eq 2 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='34010.Karma Koli'></option>
                    <option value="3" <cfoutput>#attributes.origin eq 3 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='58233.Tanım'></option>
                    <option value="4" <cfoutput>#attributes.origin eq 4 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='61176.Widget'></option>

                </select>
            </div>
            <div class="form-group" id="item-price_change">
                <div class="input-group x-4">		
                    <label class="col col-12"><div style="float:left;"><input type="checkbox" name="price_change" id="price_change" value="1" style="margin: 0 5px 0 0;"></div><div style="float:left; padding-top: 4px;"><cf_get_lang dictionary_id ='33935.Fiyat Güncelle'></div></label> 
                </div>
            </div>
            <div class="form-group x-3_5">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="input_control() && searchSpect()">
            </div>
        </cf_box_search>
        <cf_box_search_detail search_function = "input_control() && searchSpect()">
            <div class="form-group col col-3 col-md-3 col-sm-6 col xs-12" id="stock_id">
                <div class="input-group">	
                    <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                    <input type="text" name="product_name" id="product_name"  placeholder="<cfoutput>#message#</cfoutput>"  style="width:80px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','2','200');" autocomplete="off" value="<cfoutput>#attributes.product_name#</cfoutput>">
                    <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=form_search.product_name&field_id=form_search.stock_id&keyword='+encodeURIComponent(document.form_search.product_name.value),'list');"></span>
                </div>
            </div>	
            <div class="form-group col col-3 col-md-3 col-sm-6 col xs-12" id="item-start_date">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='34005.Başlama Tarihi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                </div>
            </div>
            <div class="form-group col col-3 col-md-3 col-sm-6 col xs-12" id="item-finish_date">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                </div>
            </div>
        </cf_box_search_detail>
    </cfform>
    <cfquery name="GET_SPECTS_PRODUCT" datasource="#DSN3#" maxrows="1">
        SELECT 
            P.PRODUCT_ID,
            PU.UNIT_MULTIPLIER,
            PU.PRODUCT_UNIT_ID,
            S.STOCK_CODE,
            S.BARCOD,
            S.MANUFACT_CODE,
            P.PRODUCT_NAME,
            S.TAX
        FROM
            STOCKS S,
            PRODUCT P,
            PRODUCT_UNIT PU
        WHERE
            S.PRODUCT_ID=P.PRODUCT_ID
            AND P.PRODUCT_ID=PU.PRODUCT_ID
            AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
    </cfquery>
    <form name="form_gonder_spect" method="post" action="<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_js</cfoutput>">
        <input type="hidden" name="spect_id" id="spect_id">
        <input type="hidden" name="spect_main_id" id="spect_main_id">
        <input type="hidden" name="price_change" id="price_change">
        <input type="hidden" name="set_basket" id="set_basket" value="1">
        <cfif isdefined("attributes.row_id")>
            <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.field_id")>
            <input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.field_main_id")>
            <input type="hidden" name="field_main_id" id="field_main_id" value="<cfoutput>#attributes.field_main_id#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.field_name")>
            <input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.basket_id")>
            <input type="hidden" name="basket_id" id="basket_id" value="<cfoutput>#attributes.basket_id#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.is_refresh")>
            <input type="hidden" name="is_refresh" id="is_refresh" value="<cfoutput>#attributes.is_refresh#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.form_name")>
            <input type="hidden" name="form_name" id="form_name" value="<cfoutput>#attributes.form_name#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.company_id")>
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
        </cfif>
        <cfif isdefined("attributes.consumer_id")>
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
        </cfif>
        <cfoutput>
            <cfloop query="get_money">
                <cfif isdefined("attributes.#money#") >
                    <input type="hidden" name="#money#" id="#money#" value="#evaluate('attributes.#money#')#">
                </cfif>
            </cfloop>
        <input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
        <input type="hidden" name="product_id" id="product_id" value="#GET_SPECTS_PRODUCT.product_id#">
        <input type="hidden" name="unit_multiplier" id="unit_multiplier" value="#GET_SPECTS_PRODUCT.UNIT_MULTIPLIER#">
        <input type="hidden" name="unit_id" id="unit_id" value="#GET_SPECTS_PRODUCT.PRODUCT_UNIT_ID#">
        <input type="hidden" name="stock_code" id="stock_code" value="#GET_SPECTS_PRODUCT.stock_code#">
        <input type="hidden" name="barcod" id="barcod" value="#GET_SPECTS_PRODUCT.barcod#">
        <input type="hidden" name="manufact_code" id="manufact_code" value="#GET_SPECTS_PRODUCT.manufact_code#">
        <input type="hidden" name="product_name" id="product_name" value="#GET_SPECTS_PRODUCT.product_name#">
        <input type="hidden" name="tax" id="tax" value="#GET_SPECTS_PRODUCT.tax#">
        <input type="hidden" name="amount" id="amount" value="1">
        <input type="hidden" name="price_catid" id="price_catid" value="-2">
        <input type="hidden" name="specer_return_value_list" id="specer_return_value_list" value="">
    </cfoutput>
    </form>
    <div id = "searchResult">
</cfif>

        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id ='34006.Main Spec'> <cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                    <th><cf_get_lang dictionary_id='62469.Origin'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <cfif not isdefined("attributes.from_product_config")>
                    <th width="20"><i class="fa fa-cubes" title="<cf_get_lang dictionary_id='33920.Konfigüratör'>"></i></th>
                    </cfif>
                    <th width="20"><i class="fa fa-shopping-basket" title="<cf_get_lang dictionary_id='52116.Sepete Ekle'>"></i></th>
                    <th width="20"><i class="fa fa-get-pocket" title="<cf_get_lang dictionary_id='57777.İşlemler'>"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_spect_var.recordcount>
                    <cfoutput query="get_spect_var">
                        <tr>
                            <td>#spect_var_id#</td>
                            <td>#spect_main_id#</td>
                            <td>#spect_var_name#</td>
                            <td>
                            <cfif origin_id eq 1><cf_get_lang dictionary_id='36365.Ürün Ağacı'>
                            <cfelseif origin_id eq 2><cf_get_lang dictionary_id='34010.Karma Koli'> 
                            <cfelseif origin_id eq 3><cf_get_lang dictionary_id='58233.Tanım'>
                            <cfelseif origin_id eq 4><cf_get_lang dictionary_id='61176.Widget'>
                            <cfelse>
                                <cfif len(is_mix_product) and is_mix_product eq 1><cf_get_lang dictionary_id='34010.Karma Koli'><cfelse><cf_get_lang dictionary_id='36365.Ürün Ağacı'></cfif>
                             </cfif>
                            </td>
                            <td>
                                <cfif len(record_emp)>
                                    #get_emp_info(record_emp,0,0)#
                                <cfelseif len(record_par)>
                                    #get_par_info(record_par,0,0,0)#
                                <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                    #get_cons_info(record_cons,0,0)# 
                            </cfif>
                            </td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                            <cfif not isdefined("attributes.from_product_config")> 
                                <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_configurator&id=#spect_var_id#&stock_id=#stock_id#&is_upd=0&type=upd#queryString#','#attributes.modal_id#')"><i class="fa fa-cubes" title="<cf_get_lang dictionary_id='33920.Konfigüratör'>"></i></a></td>
                                <td><a href="javascript://" onclick="setBasket('#spect_var_id#'<cfif isdefined('attributes.field_main_id')>,'#spect_main_id#'</cfif>)"><i class="fa fa-shopping-basket" title="<cf_get_lang dictionary_id='52116.Sepete Ekle'>"></i></a></td>
                            <cfelse>
                                <td><a href="javascript://" onclick="setBasket('#spect_var_id#','#spect_main_id#','#spect_var_name#')"><i class="fa fa-shopping-basket" title="<cf_get_lang dictionary_id='52116.Sepete Ekle'>"></i></a></td>
                            </cfif>
                            <td><a href="#request.self#?fuseaction=stock.list_purchase&spect_var_id=#spect_var_id#&is_form_submitted=1&listing_type=2" target="_blank"><i class="fa fa-get-pocket" title="<cf_get_lang dictionary_id='57777.İşlemler'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfif isdefined("attributes.stock_id")>
                <cfset queryString = "#queryString#&stock_id=#attributes.stock_id#">
            </cfif>
            <cfif isdefined("attributes.finish_date")>
                <cfset queryString = "#queryString#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif isdefined("attributes.start_date")>
                <cfset queryString = "#queryString#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
                <cfset queryString = "#queryString#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cfif isdefined("attributes.keyword")>
                <cfset queryString = "#queryString#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.origin")>
                <cfset queryString = "#queryString#&origin=#attributes.origin#">
            </cfif>
            <cfif isdefined("attributes.modal_id")>
                <cfset queryString = "#queryString#&modal_id=#attributes.modal_id#">
            </cfif>
            <cfif isdefined("attributes.is_search")>
                <cfset queryString = "#queryString#&is_search=#attributes.is_search#">
            </cfif>
            <cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction#&#queryString#" isAjax="1" target="searchResult">
        </cfif>
<cfif attributes.is_search eq 0>
    </div>
<cfelse>
    <cfabort>
</cfif>

<cfif attributes.is_search eq 0>
    <script type="text/javascript">
        <cfif isdefined("attributes.from_product_config")>
        url_str=add_spect_variations.basket_add_parameters.value;
        </cfif>
        function input_control()
        {
            if(trim(document.getElementById('product_name').value)=='') document.getElementById('stock_id').value='';
            return true;
        }
        function setBasket(id, main_id,var_name)
        {
            <cfif not isdefined("attributes.from_product_config")>
                if(document.form_search.price_change.checked==true) document.form_gonder_spect.price_change.value = 1;
                document.form_gonder_spect.spect_id.value = id;
                document.form_gonder_spect.spect_main_id.value = main_id;//spect main id
                loadPopupBox('form_gonder_spect',<cfoutput>#attributes.modal_id#</cfoutput>);
            <cfelse>
                form_gonder_spect.specer_return_value_list.value=main_id+","+id+","+var_name;
                form_gonder_spect.action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_add_basket_row&from_product_config=1"+url_str;
                loadPopupBox('form_gonder_spect',<cfoutput>#attributes.modal_id#</cfoutput>);
            </cfif>

        }
        function searchSpect(){
            var form = $( "form[ name = form_search ]" );
            AjaxPageLoad( form.attr('action') + '&' + form.serialize(), 'searchResult' );
            return false;
        }
    </script>
</cfif>