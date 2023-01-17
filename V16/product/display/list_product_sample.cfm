
<!---
    File:V16\product\display\list_product_sample.cfm
    Controller:WBO\controller\ProductSampleController.cfm
    Author: Fatma Zehra Dere
    Date: 2021-07-25
    Description:Numune Ürünlerin Listelendiği Sayfadır.
--->
<cfparam  name="attributes.page" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.ep.maxrows />
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfparam  name="attributes.keyword" default="">
<cfparam  name="attributes.customer_model_no" default="">
<cfparam  name="attributes.consumer_id" default="">
<cfparam  name="attributes.form_submitted" default="">
<cfparam  name="attributes.company_id" default="">
<cfparam  name="attributes.company_name" default="">
<cfparam  name="attributes.process_stage" default="">
<cfparam  name="attributes.product_sample_cat_id" default="">
<cfparam  name="attributes.product_cat_id" default="">
<cfparam  name="attributes.brand_id" default="">
<cfparam  name="attributes.brand_name" default="">
<cfparam  name="attributes.designer_emp_id" default="">
<cfparam  name="attributes.designer_emp" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.reference_product_id" default="">
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
    <cfset comp    = createObject("component","V16.product.cfc.product_sample") />
    <cfset LIST_PRODUCT_SAMPLE = comp.LIST_PRODUCT_SAMPLE(
        keyword :#attributes.keyword#,
        customer_model_no:#attributes.customer_model_no#,
        consumer_id:#attributes.consumer_id#,
        company_id:#attributes.company_id#,
        process_stage:#attributes.process_stage#,
        product_sample_cat_id:#attributes.product_sample_cat_id#,
        product_cat_id:#attributes.product_cat_id#,
        brand_id:#attributes.brand_id#,
        designer_emp_id:#attributes.designer_emp_id# ,
        designer_emp:#attributes.designer_emp#,
        company_name:#attributes.company_name#,
        brand_name:#attributes.brand_name# ,
        reference_product_id:#attributes.reference_product_id# 
    )/>
   
 
    <cfparam name='attributes.totalrecords' default="#LIST_PRODUCT_SAMPLE.recordcount#">
<cfelse>
    <cfset LIST_PRODUCT_SAMPLE.recordcount = 0>
    <cfparam name='attributes.totalrecords' default="0">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_box_data asname="get_process_stage" function="V16.product.cfc.product_sample:get_process_stage">
        <cfform name="list_product_sample" action="#request.self#?fuseaction=product.product_sample" method="post">
            
            <cf_box_search plus="0">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Keyword',47046)#">
                </div>
               <div class="form-group" id="form-model_no">
                    <cfinput type="text" name="customer_model_no" id="customer_model_no" value="#attributes.customer_model_no#" placeholder="#getLang('','Müşteri Model No','62569')# ">
                </div> 
                <div class="form-group" id="form_ul_member_name">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
                            <cfinput name="company_name" type="text" id="company_name"placeholder="#getLang('','Müşteri','57457')#" >
                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=list_product_sample.company_id&field_comp_name=list_product_sample.company_name&field_consumer=list_product_sample.consumer_id&par_con=1&select_list=2,3');"></span>
                        </cfoutput>
                    </div>
                </div>
              <div class="form-group medium" id="form_ul_process_stage">
                    <cf_multiselect_check
                        name="process_stage"
                        query_name="get_process_stage"
                        option_name="stage"
                        option_value="process_row_id"
                        option_text="#getLang('','Süreç','58859')#"
                        value="#attributes.process_stage#">
                </div>
              
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#"  maxlength="3">
                </div> 
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div> 
                <div class="form-group" id="item-submit">    
                    <a href="<cfoutput>#request.self#?fuseaction=product.product_sample&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="form_ul_opportunity_type_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='62603.numune'><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-12">
                            <cf_multiselect_check
                                name="product_sample_cat_id"
                                data_source="#DSN3#"
                                option_name="product_sample_cat"
                                option_value="product_sample_cat_id"
                                table_name="PRODUCT_SAMPLE_CAT"
                                value="#attributes.product_sample_cat_id#">
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="form_ul_product_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
                                    <input name="product_cat" type="text" id="product_cat" onfocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" value="<cfif len(attributes.product_cat)>#attributes.product_cat#</cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_product_sample.product_cat_id&field_name=list_product_sample.product_cat');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-brand_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                        <div class="col col-12">
                            <cf_wrkproductbrand
                            width="100"
                            compenent_name="getProductBrand"               
                            boxwidth="240"
                            boxheight="150"
                            brand_id="#attributes.brand_id#">
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="form_ul_designer_emp">
                        <label class="col col-12"><cf_get_lang dictionary_id='61924.Tasarımcı'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="designer_emp_id" id="designer_emp_id" value="<cfif Len(attributes.designer_emp)>#attributes.designer_emp_id#</cfif>">
                                    <input type="text" name="designer_emp" id="designer_emp"  value="<cfif Len(attributes.designer_emp)>#attributes.designer_emp#</cfif>" style="width:110px;" onfocus="AutoComplete_Create('designer_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','designer_emp_id','','3','125');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_product_sample.designer_emp_id&field_name=list_product_sample.designer_emp&select_list=1,9&branch_related')"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="form_ul_product_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='58784.Referans'><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="reference_product_id" id="reference_product_id" <cfif len(attributes.product_name)>value="#attributes.reference_product_id#"</cfif>>
                                    <input name="product_name" type="text" id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','reference_product_id','reference_product_id','list_product_sample','3','200');" value="<cfif len(attributes.reference_product_id) and len(attributes.product_name)>#attributes.product_name#</cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&field_id=list_product_sample.reference_product_id&field_name=list_product_sample.product_name');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail> 
        </cfform>
    </cf_box>
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='62603.Numune'><cf_get_lang dictionary_id='57564.Ürünler'>
    </cfsavecontent>
    
    <cf_box title="#message#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_sample_id', print_type : 368 }#"> 
        <cf_grid_list>  
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='62603.numune'><cf_get_lang dictionary_id='57897.Adı'></th>
                    <th><cf_get_lang dictionary_id='62569.Müşteri Model No'></th>
                    <th><cf_get_lang dictionary_id='62603.numune'><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></th>
                    <th><cf_get_lang dictionary_id='58847.Marka'></th>
                    <th><cf_get_lang dictionary_id='58784.Referans'><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='61924.Tasarımcı'></th>
                    <th><cfoutput>#getLang('','Müşteri','57457')#</cfoutput></th>
                    <th><cf_get_lang dictionary_id='57457.Müşteri'><cf_get_lang dictionary_id='57908.Temsilci'></th>
                    <th><cf_get_lang dictionary_id='62606.Hedef Fiyat'></th>
                    <th><cf_get_lang dictionary_id='62607.Hedef Miktar'></th>
                    <th><cf_get_lang dictionary_id='57951.Hedef'><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                    <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th width="20"><i class="fa fa-truck"></i></th>
                    <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.product_sample&event=add"><i class="fa fa-plus" alt="<cf_get_lang no='503.Formu Doldur'>" title="<cf_get_lang_main no='170.Ekle'>" ></i></a></th>
                        <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                            <cfif LIST_PRODUCT_SAMPLE.recordcount>
                                <cfif LIST_PRODUCT_SAMPLE.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
                                <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_sample_id');">
                            </cfif>
                        </th>
                    </tr>
            </thead>
            <cfif LIST_PRODUCT_SAMPLE.recordcount>
                <cfoutput query="LIST_PRODUCT_SAMPLE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset comp    = createObject("component","V16.product.cfc.product_sample") />
                    <cfset sample_relation = comp.get_relation_sample(product_sample_id : LIST_PRODUCT_SAMPLE.product_sample_id)>
                    <cfif sample_relation.recordcount>
                        <cfset get_stock = comp.get_stock(product_id : sample_relation.product_id, barcod : sample_relation.barcod )>
                    </cfif>
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>
                            <td>#PRODUCT_SAMPLE_NAME#</td>
                            <td>#customer_model_no#</td>
                            <td><cfif len(product_sample_cat_id)>#PRODUCT_SAMPLE_CAT#</cfif></td>
                            <td><cfif len(product_cat_id)>#PRODUCT_CAT#</cfif></td>
                            <td><cfif len(brand_id)>#BRAND_NAME#</cfif></td>
                            <td><cfif len(reference_product_id)>#PRODUCT_NAME#</cfif></td>
                            <td><cfif len(designer_emp_id)>#get_emp_info(LIST_PRODUCT_SAMPLE.designer_emp_id,0,0)#</cfif></td>
                            <td>
                                <cfif len(LIST_PRODUCT_SAMPLE.consumer_id)> 
                                    #get_cons_info(LIST_PRODUCT_SAMPLE.consumer_id,0,0)#
                                <cfelseif len(LIST_PRODUCT_SAMPLE.company_id)> 
                                    #get_par_info(LIST_PRODUCT_SAMPLE.company_id,1,1,0)# 
                                </cfif>
                            </td>
                            <td>#get_emp_info(LIST_PRODUCT_SAMPLE.sales_emp_id,0,0)#</td>
                            <td class="text-right"><cfif len(target_price)>#TlFormat(wrk_round(LIST_PRODUCT_SAMPLE.target_price))##target_price_currency#</cfif></td>
                            <td class="text-right"><cfif len(target_amount)>#TlFormat(wrk_round(target_amount))# #UNIT#</cfif></td><td height="20">
                                <cfif len(target_delivery_date)>
                                    #dateformat(date_add('h',session.ep.time_zone,target_delivery_date),dateformat_style)#
                                </cfif>
                            </td>
                            <td><cf_workcube_process type="color-status" select_name="PROCESS_STAGE" process_stage="#PROCESS_STAGE_ID#"  fuseaction="product.product_sample"></td>
                            <td class="text-center">
                                <cfif  isdefined("get_stock.stock_id") and len(get_stock.stock_id) and sample_relation.recordcount>
                                    <a href="#request.self#?fuseaction=prod.tree_purchase_plan&event=det&stock_id=#get_stock.stock_id#&product_sample_id=#product_sample_id#"><i class="fa fa-truck" title="#getLang('','Maliyet Hesabı ve Tedarik Planı',63564)#"></i></a>
                                </cfif>
                            </td>
                            <td class="text-center"><a href="#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#PRODUCT_SAMPLE_ID#"><i class="fa fa-tree" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <td class="text-center"><input type="checkbox" name="print_sample_id" id="print_sample_id" value="#product_sample_id#"></td>
                        </tr>
                    </tbody>
                </cfoutput>
            <cfelse>
                <tbody> 
                    <tr>
                        <td colspan="20"><cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </tbody> 
            </cfif>

        </cf_grid_list>
        <cfset url_str = "">
        <cfif len(attributes.form_submitted)>
            <cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.customer_model_no)>
            <cfset url_str = "#url_str#&customer_model_no=#attributes.customer_model_no#">
        </cfif>
        <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
            <cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
        </cfif>
        <cfif isdefined("attributes.product_sample_cat_id") and len(attributes.product_sample_cat_id)>
            <cfset url_str = "#url_str#&product_sample_cat_id=#attributes.product_sample_cat_id#">
        </cfif>
        <cfif len(attributes.product_cat_id)>
            <cfset url_str = "#url_str#&product_cat_id=#attributes.product_cat_id#">
        </cfif>
        <cfif len(attributes.brand_id)>
            <cfset url_str = "#url_str#&brand_id=#attributes.brand_id#">
        </cfif>
        <cfif len(attributes.company_id)>
            <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
        </cfif>
        <cfif len(attributes.company_name)>
            <cfset url_str = "#url_str#&company_name=#attributes.company_name#">
        </cfif> 
        <cfif len(attributes.consumer_id)>
            <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
        </cfif>
        <cfif len(attributes.designer_emp_id)>
            <cfset url_str = "#url_str#&designer_emp_id=#attributes.designer_emp_id#">
        </cfif>
        <cfif len(attributes.designer_emp)>
            <cfset url_str = "#url_str#&designer_emp=#attributes.designer_emp#">
        </cfif> 
        <cfif len(attributes.reference_product_id)>
            <cfset url_str = "#url_str#&reference_product_id=#attributes.reference_product_id#">
        </cfif>
        <cfif len(attributes.product_name)>
            <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
        </cfif>
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="product.product_sample#url_str#">
    </cf_box>
</div>