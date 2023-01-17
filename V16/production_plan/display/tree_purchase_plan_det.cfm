<cf_xml_page_edit fuseact="prod.tree_purchase_plan">
<cfinclude template="../query/get_product_info.cfm">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfset getComponent = createObject('component','V16.production_plan.cfc.get_tree')>
<cfset GET_PRO_TREE = getComponent.GET_TREE_GROUP_TYPE(stock_id : attributes.stock_id)>
<cfparam  name="attributes.brand_id" default="">

<cfif isdefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
    <cfset comp = createObject("component","V16.product.cfc.product_sample") />
    <cfset GET_PRODUCT_SAMPLE = comp.GET_PRODUCT_SAMPLE(product_sample_id : attributes.product_sample_id)/>
    <cfset sample_relation = comp.get_relation_sample(product_sample_id : attributes.product_sample_id)>
    <cfif sample_relation.recordcount>
        <cfset get_stock = comp.get_stock(product_id : sample_relation.product_id, barcod : sample_relation.barcod )>
    </cfif>
</cfif>

<cf_catalystHeader>
    <div class="col col-12 col-xs-12">
        <cf_box>
            <div class="ui-info-bottom">
                <div class="col col-3 col-md-2 col-xs-12">
                    <p><b><cf_get_lang dictionary_id='44019.Ürün'> :</b> <cfoutput>#get_product.PRODUCT_NAME#</cfoutput></p>
                </div>
                <div class="col col-3 col-md-3 col-xs-12">
                    <p><b><cf_get_lang dictionary_id='58800.Ürün Kodu'> :</b> <cfoutput>#get_product.STOCK_CODE#</cfoutput></p>
                </div>
                <div class="col col-3 col-md-3 col-xs-12">
                    <p><b><cf_get_lang dictionary_id='63453.Ana Stok Kodu'> :</b> <cfoutput>#get_product.STOCK_CODE#</cfoutput></p>
                </div>
            </div>
            
        </cf_box>

        <cfif isdefined("attributes.product_sample_id") and len(attributes.product_sample_id) and is_sample_upd eq 1>
            <cf_box id="add_sample" title="#getlang('','numune','62603')#" popup_box="1">
                <cf_box_data asname="get_product_sample_cat" function="v16.product.cfc.product_sample:get_product_sample_cat"> 
                <cf_box_data asname="GET_PRODUCT_CAT" function="v16.product.cfc.product_sample:GET_PRODUCT_CAT"> 
                <cf_box_data asname="GET_MONEYS" function="v16.product.cfc.product_sample:GET_MONEYS"> 
                <cf_box_data asname="GET_PRODUCT_UNIT" function="v16.product.cfc.product_sample:GET_PRODUCT_UNIT"> 
                <cf_box_data asname="GET_OPPORTUNITY_" function="v16.product.cfc.product_sample:GET_OPPORTUNITY">
                <cfform method="post" name="add_prodct_sample">
                    <cf_box_elements vertical="1">
                    <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <cfif isdefined("attributes.product_sample_id")>
                            <cf_duxi name="product_sample_id" type="hidden" data="attributes.product_sample_id"></cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.product_sample_name")>
                            <cf_duxi name="product_sample_name"  required="yes" type="text" id="product_sample_name" label="62603+57897" hint="Numune Adı*" data="GET_PRODUCT_SAMPLE.product_sample_name">
                        <cfelse>
                            <cf_duxi name="product_sample_name"  required="yes" type="text" id="product_sample_name" label="62603+57897" hint="Numune Adı*">
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.product_sample_cat_id")>
                            <cf_duxi name="product_sample_cat_id" placeholder="57734" type="selectbox" value="get_product_sample_cat.product_sample_cat_id" data="GET_PRODUCT_SAMPLE.product_sample_cat_id" required="yes" option="get_product_sample_cat.product_sample_cat"  label="62603+57486" hint="Numune Kategori">   
                        <cfelse>
                            <cf_duxi name="product_sample_cat_id" placeholder="57734" type="selectbox" value="get_product_sample_cat.product_sample_cat_id"   option="get_product_sample_cat.product_sample_cat" required="yes" label="62603+57486" hint="Numune Kategori">   
                        </cfif>
                    
                        <cfif isdefined("GET_PRODUCT_SAMPLE.brand_id")>
                            <cf_duxi name="brand_id" label="58847" hint="Marka" >
                                <cf_wrkproductbrand
                                width="120"
                                compenent_name="getProductBrand"               
                                boxwidth="240"
                                boxheight="150"
                                brand_id="#GET_PRODUCT_SAMPLE.brand_id#">
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
                        <cfif isdefined("GET_PRODUCT_SAMPLE.product_cat_id")>
                            <cfset GET_PRODUCT_CAT_ = comp.GET_PRODUCT_CAT(product_catid : GET_PRODUCT_SAMPLE.product_cat_id )/>
                            <cf_duxi type="hidden" name="product_cat_id" id="product_cat_id" data="GET_PRODUCT_SAMPLE.product_cat_id">
                            <cf_duxi name="product_cat" id="product_cat" placeholder="57734" data="GET_PRODUCT_CAT_.product_cat" label="29401" hint="Ürün Kategori"  threepoint="#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_prodct_sample.product_cat_id&field_name=add_prodct_sample.product_cat">  
                        <cfelse> 
                            <cf_duxi type="hidden" name="product_cat_id" id="product_cat_id">
                            <cf_duxi name="product_cat" id="product_cat" placeholder="57734" type="text" label="29401" hint="Ürün Kategori" threepoint="#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_prodct_sample.product_cat_id&field_name=add_prodct_sample.product_cat">  
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.designer_emp_id") and isdefined("attributes.product_sample_id")>
                            <cf_duxi type="hidden" name="designer_emp_id" id="designer_emp_id" data="GET_PRODUCT_SAMPLE.designer_emp_id" >
                            <cf_duxi  type="text" name="designer_emp" id="designer_emp"  hint="tasarımcı" label="61924" value="#get_emp_info(GET_PRODUCT_SAMPLE.designer_emp_id,0,0)#"  threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_prodct_sample.designer_emp_id&field_name=add_prodct_sample.designer_emp&select_list=1">
                        <cfelse>
                            <cf_duxi type="hidden" name="designer_emp_id" id="designer_emp_id" >
                            <cf_duxi  type="text" name="designer_emp" id="designer_emp" label="61924" hint="tasarımcı" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_prodct_sample.designer_emp_id&field_name=add_prodct_sample.designer_emp&select_list=1">
                        </cfif>
                        <cfif  isdefined("GET_PRODUCT_SAMPLE.opportunity_id")> 
                            <cfif isdefined("GET_PRODUCT_SAMPLE.sales_partner_id") and len(GET_PRODUCT_SAMPLE.sales_partner_id)>
                                <cf_duxi type="text" name="sales_partner_id" id="sales_partner_id" label="40904" hint="müşteri temsilci(fıtsat detaydan gelir)" value="#get_par_info(GET_PRODUCT_SAMPLE.sales_partner_id,0,-1,0)#"  readonly="yes"> 
                            <cfelseif isdefined("GET_PRODUCT_SAMPLE.sales_consumer_id") and len(GET_PRODUCT_SAMPLE.sales_consumer_id)>
                                <cf_duxi type="text" name="sales_consumer_id" id="sales_consumer_id" label="57457+57908" hint="müşteri temsilci(fıtsat detaydan gelir)" value="#get_cons_info(GET_PRODUCT_SAMPLE.sales_consumer_id,0,0)#"  readonly="yes"> 
                            </cfif>
                        </cfif>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                        <cfif  isdefined("attributes.product_sample_id")>
                            <cf_duxi name="process_stage" type="hidden" label="58859" data="GET_PRODUCT_SAMPLE.process_stage_id" hint="süreç*" required="yes"> <cf_workcube_process is_upd='0' select_value = '#GET_PRODUCT_SAMPLE.process_stage_id#' is_detail='1' process_cat_width='140' fusepath='product.product_sample'></cf_duxi>
                        <cfelse>
                            <cf_duxi name="process_stage" type="hidden" label="58859"  required="yes" hint="süreç*"> <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0' fusepath='product.product_sample'></cf_duxi>
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.customer_model_no")> 
                            <cf_duxi name="customer_model_no" type="text" id="customer_model_no" maxlength="250"  label="62569" hint="Müşteri model no" data="GET_PRODUCT_SAMPLE.customer_model_no">
                        <cfelse>
                            <cf_duxi name="customer_model_no" type="text" id="customer_model_no" maxlength="250"   label="62569" hint="Müşteri model no" >
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.target_price") >
                            <cf_duxi name="target_price" id="target_price_currency" type="text" data_control="money" currencyname="target_price_currency" currencyvalue="GET_PRODUCT_SAMPLE.target_price_currency" value="#tlformat(GET_PRODUCT_SAMPLE.target_price)#"  hint="hedef fiyat"  label="62606" >
                        <cfelse>
                            <cf_duxi name="target_price" id="target_price_currency" type="text" data_control="money" currencyname="target_price_currency" currencyvalue="GET_PRODUCT_SAMPLE.target_price_currency"   hint="hedef fiyat"  label="62606" > 
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.sales_price") >
                            <cf_duxi name="sales_price" id="sales_price_currency" type="text" data_control="money" currencyname="sales_price_currency" currencyvalue="GET_PRODUCT_SAMPLE.sales_price_currency" value="#tlformat(GET_PRODUCT_SAMPLE.sales_price)#"  hint="satış fiyatı"  label="48183" >
                        <cfelse>
                            <cf_duxi name="sales_price" id="sales_price_currency" type="text" data_control="money" currencyname="sales_price_currency" currencyvalue="GET_PRODUCT_SAMPLE.sales_price_currency"  hint="satış fiyatı" label="48183" > 
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.target_amount")> 
                            <cf_duxi name="target_amount" type="text" hint="hedef birim"  data_control="unit" currencyname="TARGET_AMOUNT_UNITY" currencyvalue="GET_PRODUCT_SAMPLE.TARGET_AMOUNT_UNITY"   label="62607" value="#GET_PRODUCT_SAMPLE.target_amount#"  onkeyup="isNumber(this);" >
                        <cfelse>
                            <cf_duxi name="target_amount" type="text" hint="hedef birim"  data_control="unit" currencyname="TARGET_AMOUNT_UNITY" currencyvalue="GET_PRODUCT_SAMPLE.TARGET_AMOUNT_UNITY"    label="62607" onkeyup="isNumber(this);" >
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.target_delivery_date")> 
                            <cf_duxi name="target_delivery_date" type="text" data_control="date"    hint="Hedef teslim tarihi *" label="57951+57645" data="GET_PRODUCT_SAMPLE.target_delivery_date" >  
                        <cfelse> 
                            <cf_duxi name="target_delivery_date" type="text" data_control="date"    hint="Hedef teslim tarihi *" label="57951+57645">  
                        </cfif>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                        <cfif isdefined("GET_PRODUCT_SAMPLE.reference_product_id")>
                            <cf_duxi type="hidden" name="reference_product_id" id="reference_product_id" data="GET_PRODUCT_SAMPLE.reference_product_id">
                            <cf_duxi  type="text" name="product_name" id="product_name" label="58784+44019" hint="referans ürün"  data="GET_PRODUCT_SAMPLE.product_name"  threepoint="#request.self#?fuseaction=objects.popup_product_names&product_id=add_prodct_sample.reference_product_id&field_name=add_prodct_sample.product_name">
                        <cfelse>
                            <cf_duxi type="hidden" name="reference_product_id" id="reference_product_id" >
                            <cf_duxi  type="text" name="product_name" id="product_name" label="58784+44019" hint="referans ürün"   threepoint="#request.self#?fuseaction=objects.popup_product_names&product_id=add_prodct_sample.reference_product_id&field_name=add_prodct_sample.product_name">
                        </cfif>
                        <cf_duxi type="hidden" name="offer_id" id="offer_id" value="">
                        <cf_duxi type="hidden" name="order_id" id="order_id" value="">
                        <cfif  isdefined("GET_PRODUCT_SAMPLE.opportunity_id")> 
                            <cf_duxi type="hidden" name="opportunity_id" id="opportunity_id" data="GET_PRODUCT_SAMPLE.opportunity_id" >
                            <cf_duxi  type="text" name="opp_head_" id="opp_head_" label="38161" hint="ilişkili fırsat*" data="GET_PRODUCT_SAMPLE.opp_no" threepoint="#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=add_prodct_sample.opportunity_id&field_opp_head=add_prodct_sample.opp_head_&field_comp_id=add_prodct_sample.company_id&field_cons_id=add_prodct_sample.consumer_id&field_cons_name=add_prodct_sample.company_name&field_company_name=add_prodct_sample.company_name&field_partner_comp_id=add_prodct_sample.member&field_partner_comp_id=add_prodct_sample.member">
                            <cfif isdefined("GET_PRODUCT_SAMPLE.sales_emp_id") and len(GET_PRODUCT_SAMPLE.sales_emp_id)>
                                <cf_duxi type="text" name="sales_emp" id="sales_emp" label="57457+57908" hint="müşteri temsilci(fıtsat detaydan gelir)" value="#get_emp_info(GET_PRODUCT_SAMPLE.sales_emp_id,0,0)#"  readonly="yes"> 
                               
                                </cfif>
                            
                        <cfelse>
                            <cf_duxi type="hidden" name="opportunity_id" id="opportunity_id">
                            <cf_duxi  type="text" name="opp_head_" id="opp_head_" label="38161" hint="ilişkili fırsat*"  threepoint="#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=add_prodct_sample.opportunity_id&field_opp_head=add_prodct_sample.opp_head_&field_comp_id=add_prodct_sample.company_id&field_cons_id=add_prodct_sample.consumer_id&field_cons_name=add_prodct_sample.company_name&field_company_name=add_prodct_sample.company_name&field_partner=add_prodct_sample.member">
                        </cfif>
                        <cfif isdefined("GET_PRODUCT_SAMPLE.company_id") and len(GET_PRODUCT_SAMPLE.company_id)>
                            <cf_duxi type="hidden" name="partner_id" id="partner_id"  data="GET_PRODUCT_SAMPLE.partner_id">
                            <cf_duxi type="hidden" name="company_id" id="company_id" data="GET_PRODUCT_SAMPLE.company_id">
                            <cf_duxi name="company_name" id="company_name" type="text"  value="#get_par_info(GET_PRODUCT_SAMPLE.company_id,1,1,0)#" hint="müşteri" label="57457"threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                            <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_par_info(GET_PRODUCT_SAMPLE.partner_id,0,-1,0)#" readonly>
                        <cfelseif  isdefined("GET_PRODUCT_SAMPLE.CONSUMER_ID") and len(GET_PRODUCT_SAMPLE.CONSUMER_ID)>
                            <cf_duxi type="hidden" name="partner_id" id="partner_id" data="GET_PRODUCT_SAMPLE.consumer_id">
                            <cf_duxi type="hidden" name="consumer_id" id="consumer_id" data="GET_PRODUCT_SAMPLE.consumer_id">
                            <cf_duxi name="company_name" id="company_name" type="text" value="#get_cons_info(GET_PRODUCT_SAMPLE.consumer_id,0,0)#" hint="müşteri" label="57457" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=add_prodct_sample.company_id&field_comp_name=add_prodct_sample.company_name&field_consumer=add_prodct_sample.consumer_id&field_name=add_prodct_sample.member&field_partner=add_prodct_sample.partner_id&select_list=7,8">
                            <cf_duxi type="text" name="member" id="member" label="57457+57578" hint="müşteri yetkili" value="#get_cons_info(GET_PRODUCT_SAMPLE.CONSUMER_ID,0,0,0)#" readonly>
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
                            
                        <cfif isdefined("GET_PRODUCT_SAMPLE.product_sample_detail")> 
                            <cf_duxi name="product_sample_detail" type="textarea" hint="detaylar" maxlength="250" label="33077" data="GET_PRODUCT_SAMPLE.product_sample_detail">  
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
                        <cfif isdefined("attributes.product_sample_id") >
                            <div class="col col-6 col-xs-12">
                                <cfoutput>
                                    <cf_record_info query_name="GET_PRODUCT_SAMPLE" record_emp="RECORD_EMP" udate_emp="UPDATE_EMP">
                                </cfoutput>
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfif not len(sample_relation.P_SAMPLE_ID)> 
                                    <a href="javascript://" class="ui-ripple-btn btn-success" style="float:right;" onclick="CreateProd()"><cf_get_lang dictionary_id='63593.Ürün Tasarla'></a>
                                </cfif>
                                <cf_workcube_buttons is_upd='1'
                                data_action ="/V16/product/cfc/product_sample:DET_PRODUCT_SAMPLE"
                                next_page="#request.self#?fuseaction=#attributes.fuseaction#&event=det&product_sample_id=#GET_PRODUCT_SAMPLE.product_sample_id#&stock_id=#attributes.stock_id#"
                                del_action= '/V16/product/cfc/product_sample:DEL_PRODUCT_SAMPLE:product_sample_id=#GET_PRODUCT_SAMPLE.product_sample_id#'
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
        </cfif>

        <cfif isdefined("attributes.product_sample_id") and len(attributes.product_sample_id) and is_add_component eq 1>
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
                SELECT TYPE_ID,
                #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
                FROM PRODUCT_TREE_TYPE
            </cfquery>
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
                    FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree">
            </cfquery>
            <cfif get_order_xml.recordcount>
                <cfoutput query="get_order_xml">
                    <cfparam name="#get_order_xml.PROPERTY_NAME[currentRow]#" default="#get_order_xml.PROPERTY_VALUE[currentRow]#">
                </cfoutput>
            </cfif>
            <cf_box title="#getLang('','Bileşen Ekle',48515)#" popup_box="1">	
                <cfform name="add_sample_product" action="#request.self#?fuseaction=prod.emptypopup_add_sub_product" method="post">
                    <input type="hidden" name="product_Sample_id" id="product_Sample_id" value="<cfif isdefined("attributes.product_Sample_id")><cfoutput>#attributes.product_Sample_id#</cfoutput></cfif>"/>
                    <input type="hidden" name="history_stock" id="history_stock" value="<cfif isdefined("attributes.main_stock_id")><cfoutput>#attributes.main_stock_id#</cfoutput></cfif>"/>
                    <input type="hidden" name="main_product_id" id="main_product_id" value="<cfif isdefined('attributes.product_id')><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                    <input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                    <input type="hidden" name="operation_main_stock_id" id="operation_main_stock_id" value="<cfif isdefined("attributes.main_stock_id")><cfoutput>#attributes.main_stock_id#</cfoutput></cfif>">
                    <input type="hidden" name="product_id" id="product_id" value="">
                    <input type="hidden" name="is_show_line_number" id="is_show_line_number" value="0">
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
                                    <input name="fire_rate" id="fire_rate"  type="text" value="" onKeyUp="return(FormatCurrency(this,event,8))" style="width:40px;text-align:right;" validate="float" readonly="yes">
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_detail">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" style="width:250px;" name="detail" id="detail" maxlength="150">
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0'  add_function='kontrol_tree()' insert_info='#getLang('','Bileşen Ekle',48515)#'>
                    </cf_box_footer>
                </cfform>
            </cf_box>
        </cfif>

            <cfset t_type = "">
            <cfset counter = 1>
            <cfoutput query="GET_PRO_TREE">
                <cfif t_type neq tree_type>
                    <cfquery name="get_pro_variant" dbtype="query">
                        SELECT * FROM GET_PRO_TREE WHERE TREE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRO_TREE.TREE_TYPE#">
                    </cfquery>
                                
                    <cf_box title="#TYPE# : #get_pro_variant.recordCount# #getLang('','Bileşen',63535)#">
                        
                        <cfform name="purchase_plan_form_#counter#" method="post">
                            <input type="hidden" name="variant_count" value="#get_pro_variant.recordCount#">
                            <cf_grid_list>
                                <thead> 
                                    <tr>
                                        <th width="10">No</th>
                                        <th width="15" class="text-center">S</th>
                                        <th width="15" class="text-center" title="#getLang('','Alternatif Soru',36454)#">A</th>
                                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                                        <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                        <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                                        <th><cf_get_lang dictionary_id='57647.Spekt'></th>
                                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                                        <th><cf_get_lang dictionary_id='62606.Hedef Fiyat'></th>
                                        <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                                        <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                                        <th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
                                        <th><cf_get_lang dictionary_id='63567.Alım Fiyatı'></th>
                                        <th><cf_get_lang dictionary_id='63568.Tedarikçi Puanı'></th>
                                        <th style="text-align:center;color:orange"><span class="fa fa-folder-open"></span></th>
                                        <th style="text-align:center;color:green"><span class="fa fa-cube"></span></th>
                                        <th style="text-align:center;color:black"><span class="fa fa-pencil"></span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfloop query="#get_pro_variant#">
                                        <cfquery name="get_alternative_products" datasource="#dsn3#">
                                            SELECT COUNT(ALTERNATIVE_ID) AS COUNT FROM ALTERNATIVE_PRODUCTS 
                                             <cfif isdefined ("product_id") or isdefined ("PRODUCT_TREE_ID")>
                                                WHERE 
                                                   <cfif isdefined ("product_id") and len(product_id)> PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND</cfif>
                                                   <cfif isdefined ("PRODUCT_TREE_ID") and len(PRODUCT_TREE_ID)> PRODUCT_TREE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_TREE_ID#"></cfif>
                                            </cfif>
                                        </cfquery>
                                        <tr>
                                            <td>#currentrow#</td>
                                            <td class="text-center">
                                                <cfif is_production eq 1>
                                                    <a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&product_id=#product_id#&stock_id=#stock_id#">
                                                    <i style="color:green !important;" class="fa fa-tree" title="#getLang('','Ürün Ağacı',140)#"></i></a>
                                                <cfelse>
                                                    <i 
                                                        style="color:green;" 
                                                        class="fa fa-shopping-cart" 
                                                        title="#getLang('','Alternatif Ürünler',32776)#"
                                                        onclick="gizle_goster(row_#counter#_#currentrow#);connectAjax(#counter#, #currentrow#, #product_id#, #stock_id#, 2);">
                                                    </i>
                                                </cfif>
                                            </td>
                                            <td class="text-center">
                                                <cfif get_alternative_products.COUNT gt 0>
                                                    <i 
                                                        style="color:orange;" 
                                                        class="fa fa-tags" 
                                                        title="#getLang('','Alternatif Soru',36625)#"
                                                        onclick="gizle_goster(row_#counter#_#currentrow#);connectAjax(#counter#, #currentrow#, #product_id#, #stock_id#, 1);"
                                                        ></i>
                                                </cfif>
                                            </td>
                                            <td><cf_workcube_process type="color-status" select_name="PROCESS_STAGE" process_stage="#PROCESS_STAGE#"></td>
                                            <td><cfif len(product_id)>#PRODUCT_NAME#<cfelseif len(OPERATION_TYPE_ID)>#OPERATION_TYPE#</cfif></td>
                                            <td>#PRODUCT_CODE#</td>
                                            <td class="text-center">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <cfif len(SPECT_MAIN_ID)>
                                                            #SPECT_MAIN_ID#<span class="input-group-addon icon-ellipsis"  onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id=#SPECT_MAIN_ID#');"></span>
                                                        </cfif>
                                                    </div>
                                                </div>   
                                            </td>
                                            <td class="text-right">#AMOUNT#</td>
                                            <td>#MAIN_UNIT#</td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="target_price_#currentrow#" value="#( len( TARGET_PRICE ) ) ? tlformat(TARGET_PRICE) : ''#" class="moneybox" onkeyup="return(FormatCurrency(this,event,2))">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <select name="target_currency_#currentrow#">
                                                        <cfloop query="GET_MONEY">
                                                            <option value="#MONEY#" <cfif money eq get_pro_variant.TARGET_PRICE_CURRENCY> selected </cfif>>#MONEY#</option>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <cfinput type="hidden" name="product_tree_id_#currentrow#" value="#PRODUCT_TREE_ID#">
                                                        <input type="hidden" name="supplier_company_id_#currentrow#" id="supplier_company_id_#currentrow#" value="#( len( SUPPLIER_COMPANY_ID ) ) ? SUPPLIER_COMPANY_ID : ''#">
                                                        <input type="text" name="supplier_company_#currentrow#" id="supplier_company_#currentrow#" value="#( len( SUPPLIER_COMPANY_ID ) ) ? FULLNAME : '' #">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=purchase_plan_form_#counter#.supplier_company_id_#currentrow#&field_comp_name=purchase_plan_form_#counter#.supplier_company_#currentrow#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2</cfoutput>');" title="<cf_get_lang dictionary_id='170.Ekle'>"></span>
                                                    </div>
                                                </div>   
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="production_code_#currentrow#" value="#( len( PRODUCTION_CODE ) ) ? PRODUCTION_CODE : ''#">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="text" name="buy_amount_#currentrow#" value="#( len( LAST_PRICE ) ) ? tlformat(LAST_PRICE) : ''#" class="moneybox" onkeyup="return(FormatCurrency(this,event,2))">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="number" name="techinal_point_#currentrow#" value="#( len( TECHNICAL_POINT ) ) ? TECHNICAL_POINT : ''#">
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.ajax_files&asset_cat_id=-3&is_image=0&design_id=0&module=product&module_id=5&action_type=0&action_section=PRODUCT_ID&action_id=#product_id#&is_box=1')" >
                                                    <span class="fa fa-folder-open" style="color:orange !important"></span>
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" target="_blank">
                                                    <span class="fa fa-cube" style="color:green !important"></span>
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=prod.popup_upd_sub_product&history_stock=#stock_id#&pro_tree_id=#product_tree_id#&is_used_abh=#is_used_abh#&x_is_phantom_tree=0')">
                                                    <span class="fa fa-pencil" style="color:black !important" ></span>
                                                </a>
                                            </td>
                                        </tr>
                                            <tr id="row_#counter#_#currentrow#" style="display:none;">
                                                <td colspan="20">
                                                    <div align="left" id="alternative_info_#counter#_#currentrow#"></div>
                                                </td>
                                            </tr>
                                    </cfloop>
                                </tbody>
                            </cf_grid_list>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="ui-form-list-btn">
                                    <a href="javascript://" class="ui-ripple-btn" onclick="createTree(#stock_id#, #tree_type#)"><cf_get_lang dictionary_id='38169.Teklif Al'></a>
                                    <a href="javascript://" class="ui-ripple-btn btn-success" onclick="kontrol('#counter#')"><cf_get_lang dictionary_id='57461.Kaydet'></a>
                                </div>        
                            </div>
                        </cfform>
                    </cf_box>
                    <cfset counter++>
                </cfif>
                <cfset t_type = GET_PRO_TREE.tree_type>
            </cfoutput>
    </div>
<script>
    function connectAjax(counter, currentrow, product_id, stock_id, type){
        var tree_id = $("form#purchase_plan_form_" + counter + " #product_tree_id_"+ currentrow).val();
		var load_url = '<cfoutput>#request.self#</cfoutput>?fuseaction=prod.tree_purchase_plan_alternative&product_id='+product_id+'&stock_id='+stock_id+'&type='+type+'&product_tree_id='+tree_id+'&counter='+counter;
		AjaxPageLoad(load_url, 'alternative_info_' + counter + '_' + currentrow, 1);
	}

    function kontrol(counter){
        var data = new FormData(document.querySelector('#purchase_plan_form_'+counter));
           AjaxControlPostDataJson("V16/production_plan/cfc/get_tree.cfc?method=upd_purchase_plan", data, function(response){
                if( response.STATUS ){
                    alert(response.MESSAGE);
                    location.reload();
                }
            });
            return false;
    }
    function kontrol2(id, type) {
        var data = new FormData(document.querySelector('#purchase_plan_form_'+ id));  
        var method_name = ( type ==  1) ? 'upd_alternative' : 'upd_prod' ;
            AjaxControlPostDataJson("V16/production_plan/cfc/get_tree.cfc?method="+method_name, data, function(response){
                if( response.STATUS ){
                    alert(response.MESSAGE);
                    location.reload();
                }
            });
        return false; 
    }
    function createTree(sId,pType){
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.list_offer&event=add&sId='+sId+'&pType='+pType, "_blank");
    }

    function product_sample_(){
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

    <cfif isdefined("attributes.product_sample_id") and len(attributes.product_sample_id) and is_add_component eq 1>
    function kontrol_tree(){
        var amount_=parseFloat(filterNum(document.getElementById("amount").value,8));
        var fire_amount_=parseFloat(filterNum(document.getElementById("fire_amount").value,8));
		if(fire_amount_ !=''  && amount_ != ''){
		
           
            if( fire_amount_ >= amount_){
                

                alert("<cf_get_lang dictionary_id='51075.Fire miktarı bileşen miktarından büyük veya eşit olamaz'>");
                    return false;
                }
		
		}
		if(<cfoutput>#attributes.is_used_rate#</cfoutput>== 1){
			var product_tree_sum = parseFloat(document.getElementById('genel_toplam').value)+(parseFloat(filterNum(document.getElementById('amount').value)*100));
			if(product_tree_sum > 100){
				alert("<cf_get_lang dictionary_id='36623.% Kullanarak Ürün Ağacı Tasarlanırken Ağaca Eklenen Ürün Oranlarının Toplamı %100den fazla olamaz'> !");
				return false;
			}	
		}
		if((document.getElementById("add_stock_id").value == '' ) && ((document.getElementById('operation_type')!= undefined && document.getElementById('operation_type').value =="") || document.getElementById('operation_type') == undefined)){
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='29419.Operasyon'>");
			return false;
		}
		if((document.getElementById("add_stock_id").value != '') && (document.getElementById('operation_type').value!='')){
			alert("<cf_get_lang dictionary_id='36712.Ürün ve operasyon birlikte seçilemez Lütfen sadece bir tanesini seçiniz'>");
			return false;
		}
		
		if(filterNum(document.getElementById("amount").value,8) == 0){
			alert("<cf_get_lang dictionary_id='36359.Miktar Sıfırdan Büyük Olmalıdır'> !");
			return false;
		}
		
		if((document.getElementById("add_stock_id").value == '') && document.getElementById("add_stock_id").value == document.getElementById("main_stock_id").value){
			alert("<cf_get_lang dictionary_id='36941.Ürüne Kendisini Ekleyemezsiniz'>!"); 
			return false;
		}
		document.getElementById("amount").value=filterNum(document.getElementById("amount").value,8);
		document.getElementById("fire_amount").value=filterNum(document.getElementById("fire_amount").value,8);
		document.getElementById("process_stage_").value = document.getElementById("process_stage").value;
	}
    </cfif>
   	
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
    
</script>