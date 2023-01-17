<!---
    File:\V16\product\form\add_product_sample.cfm
    Controller:WBO\controller\ProductSampleController.cfm
    Author:Fatma Zehra Dere
    Date: 2021-07-25
    Description:Numune Ürünlerin Eklendiği ve Güncellendiği Sayfadır.
--->
<cfset comp = createObject("component","V16.product.cfc.product_sample") />
<cfif isdefined("attributes.product_sample_id") and attributes.event eq 'add'>
    <cfset DATA_PRODUCT_SAMPLE = createObject("component","V16.product.cfc.product_sample").get(argumentCollection = attributes) />
  
    <cfset data_product_sample.product_sample_name = data_product_sample.product_sample_name & " - Kopya - #dateformat(now(),dateformat_style)#">
<cfelseif isDefined("attributes.product_sample_id")>
    <cfset GET_PRODUCT_SAMPLE = comp.GET_PRODUCT_SAMPLE(product_sample_id : attributes.product_sample_id)/>
    <cfset GET_OPPORTUNITY_SAMPLE = comp.GET_OPPORTUNITY_SAMPLE(product_sample_id : attributes.product_sample_id)/>
    <cfset sample_relation = comp.get_relation_sample(product_sample_id : attributes.product_sample_id)>
    <cfif sample_relation.recordcount>
        <cfset get_stock = comp.get_stock(product_id : sample_relation.product_id, barcod : sample_relation.barcod )>
        <cfset get_product = comp.get_product(stock_id: get_stock.stock_id)>
    </cfif>
</cfif>
<cfparam  name="attributes.brand_id" default="">
<cfif not isdefined("attributes.draggable")>
    <cf_catalystHeader>
</cfif>
<cfif isdefined("attributes.draggable")>
    <cfinclude template="../../sales/query/get_opportunity.cfm">
<cfset LIST_PRODUCT_SAMPLE = comp.LIST_PRODUCT_SAMPLE(opp_id : attributes.opp_id )/>
</cfif>
<cfif isdefined("attributes.product_sample_id") and isDefined("attributes.event") and attributes.event neq 'add'><div class="col col-9 col-md-9 col-sm-9 col-xs12"><cfelse><div class="col col-12 col-md-12 col-sm-12 col-xs-12"></cfif>
    <cf_box id="add_sample" name="add_sample" title="#getlang('','numune','62603')#" popup_box="1">
        <cf_box_data asname="get_product_sample_cat" function="V16.product.cfc.product_sample:get_product_sample_cat"> 
        <cf_box_data asname="GET_PRODUCT_CAT" function="V16.product.cfc.product_sample:GET_PRODUCT_CAT"> 
        <cf_box_data asname="GET_MONEYS" function="V16.product.cfc.product_sample:GET_MONEYS"> 
        <cf_box_data asname="GET_PRODUCT_UNIT" function="V16.product.cfc.product_sample:GET_PRODUCT_UNIT"> 
        <cf_box_data asname="GET_OPPORTUNITY_" function="V16.product.cfc.product_sample:GET_OPPORTUNITY">
        <cfform method="post" name="add_prodct_sample">
            <cf_box_elements vertical="1">
            <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <cfif isdefined("attributes.product_sample_id")>
                    <cfif isdefined("GET_PRODUCT_SAMPLE.brand_id") and  len(GET_PRODUCT_SAMPLE.brand_id)>
                        <cfset brand_id_="#GET_PRODUCT_SAMPLE.brand_id#">
                    <cfelse>
                        <cfset brand_id_=0>
                    </cfif>
                    <cfif isdefined("GET_PRODUCT_SAMPLE.product_cat_id") and  len(GET_PRODUCT_SAMPLE.product_cat_id)>
                        <cfset product_cat_id_="#GET_PRODUCT_SAMPLE.product_cat_id#">
                    <cfelse>
                        <cfset product_cat_id_=0>
                    </cfif>
                    <cf_duxi name="product_sample_id" type="hidden" data="attributes.product_sample_id"></cfif>
                <cfif isdefined("data_product_sample.product_sample_name")>
                    <cf_duxi name="product_sample_name"  required="yes" type="text" id="product_sample_name" label="62603+57897" hint="Numune Adı*" data="data_product_sample.product_sample_name">
                <cfelse>
                    <cf_duxi name="product_sample_name"  required="yes" type="text" id="product_sample_name" label="62603+57897" hint="Numune Adı*">
                </cfif>
                <cfif isdefined("data_product_sample.product_sample_cat_id")>
                    <cf_duxi name="product_sample_cat_id" placeholder="57734" type="selectbox" value="get_product_sample_cat.product_sample_cat_id" data="data_product_sample.product_sample_cat_id" required="yes" option="get_product_sample_cat.product_sample_cat"  label="62603+57486" hint="Numune Kategori">   
                <cfelse>
                    <cf_duxi name="product_sample_cat_id" placeholder="57734" type="selectbox" value="get_product_sample_cat.product_sample_cat_id"   option="get_product_sample_cat.product_sample_cat" required="yes" label="62603+57486" hint="Numune Kategori">   
                </cfif>
               
                <cfif isdefined("data_product_sample.brand_id")>
                    <cf_duxi name="brand_id" label="58847" hint="Marka" >
                        <cf_wrkproductbrand
                        width="120"
                        compenent_name="getProductBrand"               
                        boxwidth="240"
                        boxheight="150"
                        brand_id="#data_product_sample.brand_id#">
                    </cf_duxi>
                <cfelse>
                    <cf_duxi name="brand_id" label="58847" hint="Marka" >
                        <cf_wrkproductbrand
                        width="120"
                        compenent_name="getProductBrand"               
                        boxwidth="240"
                        boxheight="150"
                        brand_id="#attributes.brand_id#">
                    </cf_duxi>
                </cfif>
                <cfif isdefined("data_product_sample.product_cat_id")>
                    <cfset GET_PRODUCT_CAT_ = comp.GET_PRODUCT_CAT(product_catid : data_product_sample.product_cat_id )/>
                    <cf_duxi type="hidden" name="product_cat_id" id="product_cat_id" data="data_product_sample.product_cat_id">
                    <cf_duxi name="product_cat" id="product_cat" placeholder="57734" data="GET_PRODUCT_CAT_.product_cat" label="29401" hint="Ürün Kategori"  threepoint="#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_prodct_sample.product_cat_id&field_name=add_prodct_sample.product_cat">  
                <cfelse> 
                    <cf_duxi type="hidden" name="product_cat_id" id="product_cat_id">
                    <cf_duxi name="product_cat" id="product_cat" placeholder="57734" type="text" label="29401" hint="Ürün Kategori" threepoint="#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_prodct_sample.product_cat_id&field_name=add_prodct_sample.product_cat">  
                </cfif>
                <cfif isdefined("data_product_sample.designer_emp_id") and isdefined("attributes.product_sample_id")>
                    <cf_duxi type="hidden" name="designer_emp_id" id="designer_emp_id" data="data_product_sample.designer_emp_id" >
                    <cf_duxi  type="text" name="designer_emp" id="designer_emp" hint="tasarımcı" label="61924" value="#get_emp_info(data_product_sample.designer_emp_id,0,0)#"  threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_prodct_sample.designer_emp_id&field_name=add_prodct_sample.designer_emp&select_list=1">
                <cfelse>
                    <cf_duxi type="hidden" name="designer_emp_id" id="designer_emp_id" >
                    <cf_duxi  type="text" name="designer_emp" id="designer_emp" label="61924" hint="tasarımcı" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_prodct_sample.designer_emp_id&field_name=add_prodct_sample.designer_emp&select_list=1">
                </cfif>
            </div>
            <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                <cfif isdefined("data_product_sample.product_sample_id")>
                    <cf_duxi name="process_stage" type="hidden" label="58859" data="data_product_sample.process_stage_id" hint="süreç*" required="yes"> <cf_workcube_process is_upd='0' select_value = '#data_product_sample.process_stage_id#' is_detail='1' process_cat_width='140'></cf_duxi>
                <cfelse>
                    <cf_duxi name="process_stage" type="hidden" label="58859"  required="yes" hint="süreç*"> <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'></cf_duxi>
                </cfif>
                <cfif isdefined("data_product_sample.customer_model_no")> 
                    <cf_duxi name="customer_model_no" type="text" id="customer_model_no" maxlength="250"  label="57457+58800" hint="Müşteri ürün kodu " data="data_product_sample.customer_model_no">
                <cfelse>
                    <cf_duxi name="customer_model_no" type="text" id="customer_model_no" maxlength="250"   label="57457+58800" hint="Müşteri ürün kodu" >
                </cfif>
                <cfif isdefined("data_product_sample.target_price") >
                    <cf_duxi name="target_price" id="target_price_currency" type="text" data_control="money" currencyname="target_price_currency" currencyvalue="data_product_sample.target_price_currency" value="#tlformat(data_product_sample.target_price)#"  hint="hedef fiyat"  label="62606" >
                <cfelse>
                    <cf_duxi name="target_price" id="target_price_currency" type="text" data_control="money" currencyname="target_price_currency" currencyvalue="data_product_sample.target_price_currency"   hint="hedef fiyat"  label="62606" > 
                </cfif>
                <cfif isdefined("data_product_sample.sales_price") >
                    <cf_duxi name="sales_price" id="sales_price_currency" type="text" data_control="money" currencyname="sales_price_currency" currencyvalue="data_product_sample.sales_price_currency" value="#tlformat(data_product_sample.sales_price)#"  hint="satış fiyatı"  label="48183" >
                <cfelse>
                    <cf_duxi name="sales_price" id="sales_price_currency" type="text" data_control="money" currencyname="sales_price_currency" currencyvalue="data_product_sample.sales_price_currency"  hint="satış fiyatı" label="48183" > 
                </cfif>
                <cfif isdefined("data_product_sample.target_amount")> 
                    <cf_duxi name="target_amount" type="text" hint="hedef birim"  data_control="unit" currencyname="TARGET_AMOUNT_UNITY" currencyvalue="data_product_sample.TARGET_AMOUNT_UNITY"   label="62607" value="#data_product_sample.target_amount#"  onkeyup="isNumber(this);" >
                <cfelse>
                    <cf_duxi name="target_amount" type="text" hint="hedef birim"  data_control="unit" currencyname="TARGET_AMOUNT_UNITY" currencyvalue="data_product_sample.TARGET_AMOUNT_UNITY"    label="62607" onkeyup="isNumber(this);" >
                </cfif>
                <cfif isdefined("data_product_sample.target_delivery_date")> 
                    <cf_duxi name="target_delivery_date" type="text" data_control="date"    hint="Hedef teslim tarihi *" label="57951+57645" data="data_product_sample.target_delivery_date" >  
                <cfelse> 
                    <cf_duxi name="target_delivery_date" type="text" data_control="date"    hint="Hedef teslim tarihi *" label="57951+57645">  
                </cfif>
            </div>
            <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                <cfif isdefined("data_product_sample.reference_product_id")>
                    <cf_duxi type="hidden" name="reference_product_id" id="reference_product_id" data="data_product_sample.reference_product_id">
                    <cf_duxi  type="text" name="product_name" id="product_name" label="58784+44019" hint="referans ürün"  data="data_product_sample.product_name"  threepoint="#request.self#?fuseaction=objects.popup_product_names&product_id=add_prodct_sample.reference_product_id&field_name=add_prodct_sample.product_name">
                <cfelse>
                    <cf_duxi type="hidden" name="reference_product_id" id="reference_product_id" >
                    <cf_duxi  type="text" name="product_name" id="product_name" label="58784+44019" hint="referans ürün"   threepoint="#request.self#?fuseaction=objects.popup_product_names&product_id=add_prodct_sample.reference_product_id&field_name=add_prodct_sample.product_name">
                </cfif>
                <cf_duxi type="hidden" name="offer_id" id="offer_id" value="">
                <cf_duxi type="hidden" name="order_id" id="order_id" value="">
                <cfif  isdefined("data_product_sample.opportunity_id")> 
                    <cf_duxi type="hidden" name="opportunity_id" id="opportunity_id" data="data_product_sample.opportunity_id" >
                    <cf_duxi  type="text" name="opp_head_" id="opp_head_" label="38161" hint="ilişkili fırsat*" data="data_product_sample.opp_no" threepoint="#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=add_prodct_sample.opportunity_id&field_opp_head=add_prodct_sample.opp_head_&field_comp_id=add_prodct_sample.company_id&field_cons_id=add_prodct_sample.consumer_id&field_cons_name=add_prodct_sample.company_name&field_company_name=add_prodct_sample.company_name&field_partner=add_prodct_sample.member">
                    <cfif isdefined("data_product_sample.sales_emp_id") and len(data_product_sample.sales_emp_id)>
                        <cf_duxi type="text" name="sales_emp" id="sales_emp" label="57457+57908" hint="müşteri temsilci(fıtsat detaydan gelir)" value="#get_emp_info(data_product_sample.sales_emp_id,0,0)#"  readonly="yes"> 
                    </cfif>
                    <cfif isdefined("data_product_sample.sales_partner_id") and len(data_product_sample.sales_partner_id)>
                        <cf_duxi type="text" name="sales_partner_id" id="sales_partner_id" label="40904" hint="müşteri temsilci(fıtsat detaydan gelir)" value="#get_par_info(data_product_sample.sales_partner_id,0,-1,0)#"  readonly="yes"> 
                    </cfif>
                <cfelseif isdefined("attributes.draggable") and isDefined('attributes.opp_id')>
                    <cf_duxi type="hidden" name="opportunity_id" id="opportunity_id" value="#attributes.opp_id#" >
                    <cf_duxi  type="text" name="opp_head_" id="opp_head_" label="38161" hint="ilişkili fırsat*" required="yes"  value="#get_opportunity.opp_no#"  threepoint="#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=add_prodct_sample.opportunity_id&field_opp_head=add_prodct_sample.opp_head_">
                <cfelse>
                    <cf_duxi type="hidden" name="opportunity_id" id="opportunity_id">
                    <cf_duxi  type="text" name="opp_head_" id="opp_head_" label="38161" hint="ilişkili fırsat*"  threepoint="#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=add_prodct_sample.opportunity_id&field_opp_head=add_prodct_sample.opp_head_&field_comp_id=add_prodct_sample.company_id&field_cons_id=add_prodct_sample.consumer_id&field_cons_name=add_prodct_sample.company_name&field_company_name=add_prodct_sample.company_name&field_partner=add_prodct_sample.member">
                </cfif>
            <cfif isdefined("GET_OPPORTUNITY_SAMPLE.company_id") and len(GET_OPPORTUNITY_SAMPLE.company_id)>
                <cf_duxi type="hidden" name="partner_id" id="partner_id"  value="#GET_OPPORTUNITY_SAMPLE.partner_id#">
                <cf_duxi type="hidden" name="company_id" id="company_id"  value="#GET_OPPORTUNITY_SAMPLE.company_id#">
                <cf_duxi name="company_name" id="company_name" type="text"  value="#get_par_info(GET_OPPORTUNITY_SAMPLE.company_id,1,1,0)#" hint="müşteri" label="57457"threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_par_info(GET_OPPORTUNITY_SAMPLE.partner_id,0,-1,0)#" readonly>
            <cfelseif  isdefined("GET_OPPORTUNITY_SAMPLE.CONSUMER_ID") and len(GET_OPPORTUNITY_SAMPLE.CONSUMER_ID)>
                <cf_duxi type="hidden" name="partner_id" id="partner_id" data="GET_OPPORTUNITY_SAMPLE.consumer_id">
                <cf_duxi type="hidden" name="consumer_id" id="consumer_id" data="GET_OPPORTUNITY_SAMPLE.consumer_id">
                <cf_duxi name="company_name" id="company_name" type="text" value="#get_cons_info(GET_OPPORTUNITY_SAMPLE.consumer_id,0,0)#" hint="müşteri" label="57457" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_cons_info(GET_OPPORTUNITY_SAMPLE.CONSUMER_ID,0,0,0)#" readonly>
            <cfelseif isdefined("data_product_sample.company_id") and len(data_product_sample.company_id)>
                <cf_duxi type="hidden" name="partner_id" id="partner_id"  data="data_product_sample.partner_id">
                <cf_duxi type="hidden" name="company_id" id="company_id" data="data_product_sample.company_id">
                <cf_duxi name="company_name" id="company_name" type="text"  value="#get_par_info(data_product_sample.company_id,1,1,0)#" hint="müşteri" label="57457"threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_par_info(data_product_sample.partner_id,0,-1,0)#" readonly>
            <cfelseif  isdefined("data_product_sample.CONSUMER_ID") and len(data_product_sample.CONSUMER_ID)>
                <cf_duxi type="hidden" name="partner_id" id="partner_id" data="data_product_sample.consumer_id">
                <cf_duxi type="hidden" name="consumer_id" id="consumer_id" data="data_product_sample.consumer_id">
                <cf_duxi name="company_name" id="company_name" type="text" value="#get_cons_info(data_product_sample.consumer_id,0,0)#" hint="müşteri" label="57457" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_cons_info(data_product_sample.CONSUMER_ID,0,0,0)#" readonly>
                <cfelseif isdefined("attributes.draggable") and isDefined('attributes.opp_id')>
                    <cfif isdefined("get_opportunity.company_id") and len(get_opportunity.company_id)>
                        <cf_duxi type="hidden" name="partner_id" id="partner_id" value="#get_opportunity.partner_id#">
                        <cf_duxi type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
                        <cfset member_name = '#get_par_info(get_opportunity.company_id,1,1,0)#'>
                        <cf_duxi name="company_name" id="company_name" type="text"  value="#member_name#" hint="müşteri" label="57457"  threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                        <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_par_info(get_opportunity.partner_id,0,-1,0)#" readonly>
                    <cfelseif isdefined("get_opportunity.consumer_id") and len(get_opportunity.consumer_id)>
                        <cf_duxi type="hidden" name="partner_id" id="partner_id" value="#get_opportunity.consumer_id#">
                        <cf_duxi type="hidden" name="consumer_id" id="consumer_id" value="#get_opportunity.consumer_id#">
                        <cfset member_name = '#get_cons_info(get_opportunity.consumer_id,0,0)#'>
                        <cf_duxi name="company_name" id="company_name" type="text"  value="#member_name#" hint="müşteri" label="57457"  threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                        <cf_duxi type="text" name="member" id="member"label="57457+57578" hint="müşteri yetkili" value="#get_cons_info(get_opportunity.consumer_id,0,0,0)#" readonly>
                     <cfelse>
                        <cfset member_name = ''>
                        <cf_duxi name="company_name" id="company_name" type="text"  value="#member_name#" hint="müşteri" label="57457"  threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                        <cf_duxi type="text" name="member" id="member"label="57457+57578" hint="müşteri yetkili" value="" readonly>
                    </cfif>
                <cfelse>
                    <cf_duxi type="hidden" name="partner_id" id="partner_id">
                    <cf_duxi type="hidden" name="company_id" id="company_id">
                    <cf_duxi type="hidden" name="consumer_id" id="consumer_id">
                    <cf_duxi type="text"  name="company_name" id="company_name" value="" hint="müşteri" label="57457" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                    <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="" readonly>
                </cfif>
                
                <cfif isdefined("data_product_sample.product_sample_detail")> 
                    <cf_duxi name="product_sample_detail" type="textarea" hint="detaylar" maxlength="250" label="33077" data="data_product_sample.product_sample_detail">  
                <cfelse>
                    <cf_duxi name="product_sample_detail" type="textarea" hint="detaylar" maxlength="250" label="33077" > 
                </cfif>
                
            </div>
            </cf_box_elements>
            <cfif not isdefined("attributes.draggable")>
                <cfset nextpagee="#request.self#?fuseaction=#attributes.fuseaction#&event=upd&product_sample_id=">
            <cfelseif isdefined("attributes.draggable")>
                <cfset nextpagee="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#attributes.opp_id#&opp_no=FN-#attributes.opp_id#">
            </cfif> 
            <cf_box_footer> 
                <cfif isdefined("attributes.product_sample_id") and isDefined("attributes.event") and attributes.event neq 'add'>
                    <div class="col col-6 col-xs-12">
                        <cfoutput>
                            <cf_record_info query_name="data_product_sample" record_emp="RECORD_EMP" udate_emp="UPDATE_EMP">
                        </cfoutput>
                    </div>
                    <div class="col col-6 col-xs-12">
                        <cfif not len(sample_relation.P_SAMPLE_ID)> 
                            <a href="javascript://" class="ui-ripple-btn btn-success" style="float:right;" onclick="CreateProd()"><cf_get_lang dictionary_id='63593.Ürün Tasarla'></a>
                        </cfif>
                        <cf_workcube_buttons is_upd='1'
                        data_action ="/V16/product/cfc/product_sample:DET_PRODUCT_SAMPLE"
                        next_page="#request.self#?fuseaction=#attributes.fuseaction#&event=upd&product_sample_id=#data_product_sample.product_sample_id#"
                        del_action= '/V16/product/cfc/product_sample:DEL_PRODUCT_SAMPLE:product_sample_id=#data_product_sample.product_sample_id#'
                        del_next_page="#request.self#?fuseaction=#attributes.fuseaction#"
                        add_function='product_sample_()'>
                        
                    </div>
                <cfelse>
                    <cf_workcube_buttons is_upd='0' 
                     data_action ="/V16/product/cfc/product_sample:ADD_PRODUCT_SAMPLE"
                      next_page="#nextpagee#"
                      add_function='product_sample_()'>
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <cfif(isDefined("get_stock.recordcount") and get_stock.recordcount) and isdefined("attributes.product_sample_id") and attributes.event neq 'add'>
    <cf_xml_page_edit fuseact ="prod.add_product_tree" default_value="0">
        <cfsetting showdebugoutput="no">
        <cfparam name="attributes.stock_id_" default="#get_stock.stock_id#">
        <cfparam name="old_main_spec_id" default="0">
        <cfparam name="attributes.is_used_rate" default="0">
        <cfparam name="attributes.stock_id" default="#attributes.stock_id_#">
        <cfparam name="attributes.approach" default="1">
        <cfset attributes.stock_main_id = attributes.stock_id>
        <cfset getComponent = createObject('component','V16.production_plan.cfc.get_tree')>
        <cfset GET_PRO_TREE_ID = getComponent.GET_PRO_TREE_ID(stock_id : attributes.stock_id)>
        <cfset GET_PROCESS_STAGE = getComponent.GET_PROCESS_STAGE()>
        <cfif not isDefined("attributes.product_id")><cfset attributes.product_id = get_product.product_id></cfif>
        <cfquery name="get_alternative_questions" datasource="#dsn#">
            SELECT QUESTION_ID,QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS
        </cfquery>
        <cfquery name="get_tree_types" datasource="#dsn#">
            SELECT TYPE_ID, #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
             FROM PRODUCT_TREE_TYPE
        </cfquery>
        <cfif isdefined("attributes.product_id") and len(attributes.product_id)>
            <cfquery name="get_product_info" datasource="#dsn1#">
                SELECT IS_PRODUCTION, PRODUCT_CODE, IS_TERAZI, IS_INVENTORY, PRODUCT_STATUS FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfquery>
        </cfif>
        <cfif isdefined('attributes.product_tree_id')>
            <cfset _product_tree_id_ = attributes.product_tree_id>
        <cfelse>
            <cfset _product_tree_id_ =0>
        </cfif>
        <cfquery name="get_order_xml" datasource="#dsn#">
            SELECT 
                PROPERTY_VALUE,
                PROPERTY_NAME
            FROM
                FUSEACTION_PROPERTY
            WHERE
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
                FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="product.product_sample"> AND
                PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="is_line_number">
        </cfquery>
        <cfif get_order_xml.recordcount>
            <cfset is_line_number = get_order_xml.PROPERTY_VALUE>
        <cfelse>
            <cfset is_line_number = 0>
        </cfif>
        <cfquery name="get_product_conf" datasource="#dsn3#">
            SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE CONFIGURATOR_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
        </cfquery>
        <cfif isdefined('attributes.product_tree_id') and attributes.product_tree_id gt 0>
            <cfquery name="get_operation_name" datasource="#dsn3#">
                SELECT 
                    (SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPES.OPERATION_TYPE_ID = PRODUCT_TREE.OPERATION_TYPE_ID) AS OPERATION,
                    PRODUCT_TREE.OPERATION_TYPE_ID
                FROM 
                    PRODUCT_TREE 
                WHERE PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_tree_id#">
            </cfquery>
            <!---<cf_get_lang dictionary_id='1622.Operasyon'> : <cfoutput><font color="BLUE"><a target="_blank" href="#request.self#?fuseaction=prod.upd_operationtype&operation_type_id=#get_operation_name.OPERATION_TYPE_ID#">#get_operation_name.OPERATION#</a></font></cfoutput>--->
        </cfif>
    <cf_box title="#getLang('','Bileşen Ekle',48515)#" popup_box="1">	
        <cfform name="add_sample_product" action="#request.self#?fuseaction=prod.emptypopup_add_sub_product" method="post">
            <input type="hidden" name="product_Sample_id" id="product_Sample_id" value="<cfif isdefined("attributes.product_Sample_id")><cfoutput>#attributes.product_Sample_id#</cfoutput></cfif>"/>
            <input type="hidden" name="history_stock" id="history_stock" value="<cfif isdefined("attributes.main_stock_id")><cfoutput>#attributes.main_stock_id#</cfoutput></cfif>"/>
            <input type="hidden" name="main_product_id" id="main_product_id" value="<cfif isdefined('attributes.product_id')><cfoutput>#attributes.product_id#</cfoutput></cfif>">
            <input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
            <input type="hidden" name="operation_main_stock_id" id="operation_main_stock_id" value="<cfif isdefined("attributes.main_stock_id")><cfoutput>#attributes.main_stock_id#</cfoutput></cfif>">
            <input type="hidden" name="product_id" id="product_id" value="">
            <input type="hidden" name="is_show_line_number" id="is_show_line_number" value="<cfoutput>#is_line_number#</cfoutput>">
            <input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined('attributes.stock_id')><cfoutput>#attributes.stock_id#</cfoutput></cfif>">
            <input type="hidden" name="unit_id" id="unit_id" value="">
            <input type="hidden" name="process_stage_" id="process_stage_" value="<cfoutput>#GET_PRO_TREE_ID.process_stage#</cfoutput>">
            <input type="hidden" name="product_tree_id" id="product_tree_id" value="<cfif isdefined('attributes.product_tree_id')><cfoutput>#attributes.product_tree_id#</cfoutput></cfif>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <cfif is_used_tree_type eq 1>
                        <div class="form-group" id="form_ul_tree_types">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='63502.Bileşen Tipi'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="tree_types" id="tree_types">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfloop query="get_tree_types">
                                        <cfoutput><option value="#TYPE_ID#">#TYPE#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </cfif> 
                    <div class="form-group">
                        <label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <select name="product_process_stage" id="product_process_stage" style="width:150px">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                               <cfoutput query="GET_PROCESS_STAGE">
                                   <option value="#PROCESS_ROW_ID#"  <cfif PROCESS_ROW_ID eq GET_PRO_TREE_ID.process_stage>selected="selected"</cfif>>#stage#</option>
                               </cfoutput>
                           </select>
                        </div>
                    </div>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                    <div class="form-group" id="form_ul_product_name">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="add_stock_id" id="add_stock_id" value="">
                                    <input type="text" name="product_name" id="product_name">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names<cfoutput>#xml_str#</cfoutput>&stock_and_spect=1&field_spect_main_id=add_sample_product.spect_main_id&field_spect_main_name=add_sample_product.spect_main_name&field_id=add_sample_product.add_stock_id&field_name=add_sample_product.product_name&product_id=add_sample_product.product_id&field_unit=add_sample_product.unit_id')"></span>
                            </div>						
                        </div>						
                    </div>
                    <div class="form-group" id="form_ul_spect_main_name">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="spect_main_name" id="spect_main_name" readonly="yes">
                                    <input type="text" name="spect_main_id" id="spect_main_id" readonly>
                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec();"></span>
                            </div>						
                        </div>
                    </div>
                    
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="form_ul_operationtype">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'></label>
                        <div class="col col-9 col-xs-12">                                        
                            <cf_wrkoperationtype width='110' control_status='1'>                                        					
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_line_number">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58577.Sıra'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="line_number" id="line_number" style="width:110px;text-align:right;">						
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_amount">
                        <cfif attributes.is_used_rate eq 0>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <cfelse>
                            <label class="col col-3 col-xs-12"><input type="hidden" name="main_product_unit" id="main_product_unit" value="<cfoutput>#get_product.MAIN_UNIT#</cfoutput>">%</label>
                        </cfif>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
                            <cfinput name="amount" id="amount" type="text" value="1" onKeyUp="fire_control();return(FormatCurrency(this,event,8))" style="width:110px;text-align:right;" required="yes" validate="float" message="#message#">				
                        </div>
                    </div>
                    <cfif is_used_abh eq 1>
                        <div class="form-group" id="form_ul_abh">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42999.A*b*h'></label>
                            <div class="col col-9 col-xs-12">                                        
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="text" class="" name="product_width">
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="text" class="" name="product_length">
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="text" class="" name="product_height">
                                </div>                                   					
                            </div>
                        </div>
                    </cfif>
                    
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                    <div class="form-group" id="form_ul_alternative_questions">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'></label>
                        <div class="col col-9 col-xs-12">
                            <select name="alternative_questions" id="alternative_questions" style="width:110px;">
                                <option value=""><cf_get_lang dictionary_id='36616.Alternatif Soru Seçiniz'>!</option>
                                <cfloop query="get_alternative_questions">
                                    <cfoutput><option value="#QUESTION_ID#">#QUESTION_NAME#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_fire_amount">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='36356.Fire Miktarı'></label>
                        <div class="col col-9 col-xs-12">
                            <cfinput name="fire_amount" id="fire_amount" type="text" value="" onKeyUp="fire_control();return(FormatCurrency(this,event,8))" style="width:40px;text-align:right;" validate="float">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_fire_rate">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='36357.Fire Oranı'></label>
                        <div class="col col-9 col-xs-12">
                            <cfinput name="fire_rate" id="fire_rate" type="text" value="" onKeyUp="return(FormatCurrency(this,event,8))" style="width:40px;text-align:right;" validate="float" readonly="yes">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" style="width:250px;" name="detail" id="detail" maxlength="150">
                        </div>
                    </div>
                    
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='36615.Sevkte Birleştir'></cfsavecontent>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfif is_show_sb eq 1>
                            <label>
                                <input type="checkbox" name="is_sevk" id="is_sevk" value="1">
                                <cf_get_lang dictionary_id='36615.Sevkte Birleştir'>
                            </label>
                        </cfif>
                    </div>
                    <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label>
                            <input type="checkbox" name="is_free_amount" id="is_free_amount" value="1">
                            <cf_get_lang dictionary_id='36355.Miktardan Bağımsız'>
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="8" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cfif x_is_phantom_tree eq 1>
                            <label>
                                <input type="checkbox" name="is_phantom" id="is_phantom" value="1">
                                <cf_get_lang dictionary_id='36362.Bu Ürün İçin Üretim Emri Oluşturma'>
                            </label>
                        </cfif>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="9" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                        <label>
                            <input type="checkbox" name="is_configure" id="is_configure" value="1" <cfif is_select_configure eq 1>checked="checked"</cfif>>
                            <cf_get_lang dictionary_id='36799.Konfigure edilmez'>
                        </label>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'  add_function='addkontrol()' insert_info='#getLang('','Bileşen Ekle',48515)#'>
            </cf_box_footer>
        </cfform>
    </cf_box>
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id="35700.Bileşenler"></cfsavecontent>
            
        <cf_box title="#head#" widget_load="NumuneComponents"
        widget_parameters="&stock_id=#attributes.stock_id##iif(isdefined('attributes.main_stock_id'),DE('&main_stock_id=##attributes.main_stock_id##'),DE(''))#&_product_tree_id_=#_product_tree_id_#&is_line_number=#is_line_number#&old_main_spec_id=#old_main_spec_id#&fuseaction_=#attributes.fuseaction#&is_used_rate=#attributes.is_used_rate#"></cf_box>
    </cfif>
    <cfif  isdefined("attributes.product_sample_id") and attributes.event neq 'add'>
        <cf_box
            title="#getLang('','Takipler',40864)#"
            id="box_followup_sample"
            closable="0"
            box_page="#request.self#?fuseaction=sales.list_opportunity_plus&product_sample_id=#attributes.product_sample_id#"
            add_href="openBoxDraggable('#request.self#?fuseaction=sales.popup_form_add_opp_plus&product_sample_id=#attributes.product_sample_id#')"
            unload_body = "1"
            add_href_size="project">
        </cf_box>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
            <cfset adres_ = "#request.self#?fuseaction=project.emptypopup_ajax_project_works&product_sample_id=#attributes.product_sample_id#">
            <cfif listFindNoCase(session.ep.user_level,1)>
                <cf_box title="#message#" box_page="#adres_#" closable="0" id="box_works_b"></cf_box>
            </cfif>
    </cfif>
</div>
<cfif  isdefined("attributes.product_sample_id") and attributes.event neq 'add'>
    <div class="col col-3">
        <cf_wrk_images product_sample_id="#attributes.product_sample_id#" type="sample"> 
        <cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='5' action_section='PRODUCT_SAMPLE_ID' action_id='#attributes.product_sample_id#'>
        <cf_box
        title="#getLang('','Laboratuvar İşlemleri','64096')#"
        box_page="#request.self#?fuseaction=product.list_lab_sample_analysis&product_sample_id=#attributes.product_sample_id#"
        add_href="#request.self#?fuseaction=lab.sample_analysis&event=add&product_sample_id=#attributes.product_sample_id#"></cf_box>
    </div>
 </cfif>
<script>
    function product_sample_()
        {
        if((document.getElementById("product_sample_cat_id").value == '') )
            {
                alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='62603.Numune'><cf_get_lang dictionary_id='57486.Kategori'>");
                return false;
            }
            if
            ((document.getElementById("opportunity_id").value != '') && ( document.getElementById("company_id").value =='' &&  document.getElementById("consumer_id").value ==''))
            {
            
                alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57457.Müşteri'>");
                    return false;
                }
            
        }
    <cfif isdefined("attributes.product_sample_id") and attributes.event neq 'add'>
        function CreateProd() {
            if( confirm( $("#product_sample_name").val() + " - Numune Adında Prototip Bir Ürün Oluşturulacaktır. Devam Etmek İstiyor musunuz ?")) {
                var data = new FormData();  
                    data.append("product_name", $("#product_sample_name").val());
                    data.append("product_catid", <cfoutput>#product_cat_id_#</cfoutput>);
                    data.append("brand_id", <cfoutput>#brand_id_#</cfoutput>);
                    data.append("product_code", <cfoutput>#get_product_no(action_type:'product_no')#</cfoutput>);
                    data.append("barcod", <cfoutput>#get_barcode_no()#</cfoutput>);
                    data.append("product_sample_id", <cfoutput>#attributes.product_sample_id#</cfoutput>);
                    AjaxControlPostDataJson("V16/product/cfc/product_sample.cfc?method=create_sample_product", data, function(response){
                        if( response.STATUS ){
                            alert(response.MESSAGE);
                            location.reload();
                        }else{
                            alert(response.MESSAGE);
                        }
                    });
                return false;
            }else{  
                return false;
            }
        }
        <cfif isDefined("get_stock.recordcount") and get_stock.recordcount>
            function open_spec()
            {
                if(document.getElementById("add_stock_id").value!='' && document.getElementById("product_name").value!='')
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id&stock_id='+document.getElementById("add_stock_id").value,'list')
                else
                    alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
            }
          
           	
	function fire_control()
	{
		
        var amount_=parseFloat(filterNum(document.add_sample_product.amount.value,8));
        var fire_amount_= parseFloat(filterNum(document.add_sample_product.fire_amount.value,8));
	
       
		if(document.add_sample_product.amount.value != '' && document.add_sample_product.fire_amount.value!='')
		{
			var fire_operation=(100* fire_amount_)/amount_;
			fire_operation=fire_operation.toFixed(2);
			document.add_sample_product.fire_rate.value=fire_operation;
		
		}
		else{
			document.add_sample_product.fire_rate.value=''
			
		}
	
	}
            
                function addkontrol()
            {
               
                    if(document.add_sample_product.fire_amount != ''  && document.add_sample_product.amount.value != ''){
                       
                    var amount_ = parseFloat(filterNum(document.add_sample_product.amount.value,8));
                    var fire_amount_ = parseFloat(filterNum(document.add_sample_product.fire_amount.value,8));
                    if(fire_amount_ >= amount_){
                        alert("<cf_get_lang dictionary_id='51075.Fire miktarı bileşen miktarından büyük veya eşit olamaz'>");
                        return false;
                    }
                   
                }
               
                <cfif isdefined("attributes.is_used_rate")>
                    if(<cfoutput>#attributes.is_used_rate#</cfoutput>== 1){
                        var product_tree_sum = parseFloat(document.getElementById('genel_toplam').value)+(parseFloat(filterNum(document.getElementById('amount').value)*100));
                        if(product_tree_sum > 100){
                            alert("<cf_get_lang dictionary_id='36623.% Kullanarak Ürün Ağacı Tasarlanırken Ağaca Eklenen Ürün Oranlarının Toplamı %100den fazla olamaz'> !");
                            return false;
                        }	
                    }
                </cfif>
                if((document.getElementById("add_stock_id").value == '' ) && (document.getElementById('operation_type_id').value ==''))
                {
                    alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='29419.Operasyon'>");
                    return false;
                }
                if((document.getElementById("add_stock_id").value != '' ) && (document.getElementById('operation_type_id').value!=''))
                {
                    alert("<cf_get_lang dictionary_id='36712.Ürün ve operasyon birlikte seçilemez Lütfen sadece bir tanesini seçiniz'>");
                    return false;
                }
                
                if(filterNum(document.getElementById("amount").value,8) == 0)
                {
                    alert("<cf_get_lang dictionary_id='36359.Miktar Sıfırdan Büyük Olmalıdır'> !");
                    return false;
                }
                
                if((document.getElementById("add_stock_id").value == '' && document.getElementById("product_name").value == '') && document.getElementById("add_stock_id").value == document.getElementById("main_stock_id").value)
                {
                    alert("<cf_get_lang dictionary_id='36941.Ürüne Kendisini Ekleyemezsiniz'>!"); 
                    return false;
                }
                document.getElementById("amount").value=filterNum(document.getElementById("amount").value,8);
                document.getElementById("fire_amount").value=filterNum(document.getElementById("fire_amount").value,8);
                document.getElementById("process_stage_").value = document.getElementById("product_process_stage").value;
            }
            function kontrol_process_2()
            {
                if(process_cat_control())
                    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=copy_product_func&is_production=1&run_function_param=id');
                else
                    return false;
            }
            function kontrol_process_3()
            {
                if(process_cat_control())
                {
                    if(confirm("<cf_get_lang dictionary_id='36366.Ürün Ağacının Bileşenleri Silinecektir'> , <cf_get_lang dictionary_id='36367.Yaptığınız İşlem Geri Alınamaz'> ! <cf_get_lang dictionary_id='58588.Emin misiniz'>?"))
                    {
                        add_versiyon.action='<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_product_tree</cfoutput>';
                        add_versiyon.submit();
                    }
                    else
                        return false;
                }
                else
                    return false;
            }
            function kontrol_process()
            {
                if(!process_cat_control())
                    return false;
                else
                    AjaxFormSubmit("add_versiyon",'SHOW_PRODUCT_TREE','','','','','','1');
            }
            function goto_page()
            {
                for (var i = 0; i < add_sub_product.stock_select.options.length; i++){
                if (add_sub_product.stock_select.options[i].selected)
                    my_val=add_sub_product.stock_select.options[i].value;
                }
                if(my_val!=0)
                window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_product_tree&event=upd&stock_id=" + my_val;
            }
        
            function pencere(say)
            {
                str_link="<cfoutput>#request.self#?fuseaction=prod.popup_upd_sub_product#xml_str#&history_stock=#attributes.stock_id#</cfoutput>&pro_tree_id=" + say;
                openBoxDraggable(str_link);
            
            }
        </cfif>
    </cfif>
</script>
   
    





