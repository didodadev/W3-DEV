<!---<cf_get_lang_set module_name="sales">--->

    <cfset member_name_="">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
       <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
       <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#get_opportunity.req_id#</cfoutput>">
       <input type="hidden" name="old_process_stage" id="old_process_stage" value="#get_opportunity.req_stage#">
       <cf_box_elements>
           <div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
               <cf_seperator title="Model Detayları" id="detail_seperator">
               <div  id="detail_seperator">
                   <div class="form-group" id="item-opp_no">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62620.Model No'></label>
                       <div class="col col-4 col-md-12 col-sm-12 col-xs-12" extra_checkbox="req_status">
                           <input type="hidden" name="req_id2" id="req_id2" value="<cfoutput>#get_opportunity.req_id# </cfoutput>" readonly>
                           <input type="text" name="req_no" id="req_no" value="<cfoutput>#get_opportunity.req_no#</cfoutput>" readonly>
                       </div>
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12" extra_checkbox="opp_status" ><input type="checkbox" name="opp_status" id="opp_status" value="1" <cfif get_opportunity.req_status>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
                   </div>
                   <div class="form-group" id="item-opp_stage">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                       <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                           <cf_workcube_process is_upd='0' select_value='#get_opportunity.req_stage#' process_cat_width='140' is_detail='1'>
                       </div>
                   </div>
                   <div class="form-group" id="item-opportunity_type_id">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62621.Model Kategori'></label>
                       <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                        <cfquery name="get_opportunity_type" datasource="#DSN3#">
                            SELECT
                                OPPORTUNITY_TYPE_ID,
                                OPPORTUNITY_TYPE
                            FROM
                                SETUP_OPPORTUNITY_TYPE
                        </cfquery>
                           <select name="opportunity_type_id" id="opportunity_type_id" onchange="if (['6','14'].indexOf(this.value)>=0) { $('#btnorderadd').hide() } else { $('#btnorderadd').show() }">
                               <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                               <cfoutput query="get_opportunity_type">
                                   <option value="#opportunity_type_id#" <cfif opportunity_type_id eq get_opportunity.req_type_id>selected</cfif>>#opportunity_type#</option>
                               </cfoutput>
                           </select>
                       </div>
                   </div>
                   <div class="form-group" id="item-opp_date">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='47994.Talep Tarihi'></label>
                       <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                           <div class="input-group">
                               <cfsavecontent variable="message"><cf_get_lang dictionary_id='58769.Başvuru Tarihi Girmelisiniz'></cfsavecontent>
                               <input type="text" name="opp_date" id="opp_date" value="<cfoutput>#dateformat(get_opportunity.req_date,dateformat_style)#</cfoutput>"  maxlength="10" >
                               <span class="input-group-addon"><cf_wrk_date_image date_field="opp_date" call_function="change_money_info"></span>
                           </div>
                       </div>
                   </div>
                   <div class="form-group" id="item-sales_emp_id">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='58795.Müşteri Temsilcisi'></label>
                       <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                           <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfoutput>#get_opportunity.sales_emp_id#</cfoutput>">
                           <div class="input-group">
                               <input type="text" name="sales_emp" id="sales_emp" value="<cfif len(get_opportunity.sales_emp_id)><cfoutput>#get_emp_info(get_opportunity.sales_emp_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','140');" autocomplete="off">
                               <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_opp.sales_emp_id&field_name=upd_opp.sales_emp&select_list=1');"></span>
                           </div>
                       </div>
                   </div>
                   <div class="form-group" id="item-detail">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                       <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                           <textarea name="req_detail" id="req_detail" ><cfoutput>#get_opportunity.req_detail#</cfoutput></textarea>
                       </div>
                   </div>
                   <div class="form-group" id="item-desing_emp_id">
                       <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='61924.Tasarımcı'></label>
                       <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                           <input type="hidden" name="desing_emp_id" id="desing_emp_id" value="<cfoutput>#get_opportunity.desing_emp_id#</cfoutput>">
                           <div class="input-group">
                               <input type="text" name="desing_emp" id="desing_emp" value="<cfif len(get_opportunity.desing_emp_id)><cfoutput>#get_emp_info(get_opportunity.desing_emp_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('desing_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','desing_emp_id','','3','140');" autocomplete="off">
                               <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_opp.desing_emp_id&field_name=upd_opp.desing_emp&select_list=1');"></span>
                           </div>
                       </div>
                   </div>
               </div>
           </div>                     
           <cfoutput>
               <div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                   <cf_seperator title="#getLang('','Müşteri Detayları','62599')#" id="detail_seperatorr_">
                   <div  id="detail_seperatorr_">
                       <div class="form-group" id="item-company">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'> *</label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="hidden" name="old_company_id" id="old_company_id" value="#get_opportunity.company_id#">
                               <cfif len(get_opportunity.partner_id)>
                                   <input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
                                   <input type="hidden" name="member_type" id="member_type" value="partner">
                                   <input type="hidden" name="member_id" id="member_id" value="#get_opportunity.partner_id#">
                                   <input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.partner_id#">
                                   <div class="input-group">
                                       <input type="text" name="company" id="company" value="#get_par_info(get_opportunity.company_id,1,0,0)#" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                       <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8','list');"></span>
                                   </div>
                               <cfelseif len(get_opportunity.consumer_id)>
                                   <input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
                                   <input type="hidden" name="member_type" id="member_type" value="consumer">
                                   <input type="hidden" name="member_id" id="member_id"  value="#get_opportunity.consumer_id#">
                                   <input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.consumer_id#">
                                   <div class="input-group">
                                       <input type="text" name="company" id="company"  value="" readonly onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                       <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8','list');"></span>
                                   </div>
                               <cfelse>
                                   <input type="hidden" name="company_id" id="company_id" value="">
                                   <input type="hidden" name="member_type" id="member_type" value="">
                                   <input type="hidden" name="member_id" id="member_id" value="">
                                   <input type="hidden" name="old_member_id" id="old_member_id"  value="">
                                   <div class="input-group">
                                       <input type="text" name="company" id="company"  value="" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                       <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8','list');"></span>                                                      
                                    </div>
                               </cfif>
                           </div>
                       </div>
                       <div class="form-group" id="item-member">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <cfif len(get_opportunity.partner_id)>
                                   <input type="text" name="member" id="member" value="#get_par_info(get_opportunity.partner_id,0,-1,0)#" readonly>
                               <cfelseif len(get_opportunity.consumer_id)>
                                   <input type="text" name="member" id="member" value="#get_cons_info(get_opportunity.consumer_id,0,0,0)#" readonly>
                               <cfelse>
                                   <input type="text" name="member" id="member" value="" readonly>
                               </cfif>
                           </div>
                       </div>
                       <div class="form-group" id="item-invoice-company">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62577.Fatura Müşterisi'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="hidden" name="invoice_company_id" id="invoice_company_id" value="#get_opportunity.invoice_company_id#">
                               <input type="hidden" name="invoice_member_type" id="invoice_member_type" value="">
                               <input type="hidden" name="invoice_member_id" id="invoice_member_id" value="">
                               <input type="hidden" name="invoice_old_member_id" id="invoice_old_member_id"  value="">
                               <input type="hidden" name="invoice_number" id="invoice_number" value="">
                               <input type="hidden" name="invoice_member" id="invoice_member" value="">
                               <div class="input-group">
                                   <input type="text" name="invoice_company" id="invoice_company"  value="#get_opportunity.INVOICE_COMPANY#" onFocus="AutoComplete_Create('invoice_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','invoice_company_id,invoice_member_type,invoice_member_id,invoice_member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                                   <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&field_partner=upd_opp.invoice_member_id&field_consumer=upd_opp.invoice_member_id&field_comp_id=upd_opp.invoice_company_id&field_comp_name=upd_opp.invoice_company&field_name=upd_opp.invoice_member&field_type=upd_opp.invoice_member_type&select_list=7,8');"></span>
                               </div>
                           </div>
                       </div>
                       <div class="form-group" id="item-order-no">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='33024.Order No.'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="text" name="order_no" value="#get_opportunity.company_order_no#">
                           </div>
                       </div>
                       <div class="form-group" id="item-project">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='30886.Project No'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="hidden" name="project_id" id="project_id" value="#get_opportunity.project_id#">
                                <input type="text" disabled name="project_head" id="project_head" value="<cfif len(get_opportunity.project_id)>#get_opportunity.PROJECT_HEAD#</cfif>"   onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                   <!---<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_opp.project_id&project_head=upd_opp.project_head','list');"></span>--->
                           </div>
                       </div>
                       <div class="form-group" id="item-main-project">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62604.Ana Sipariş Projesi'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="hidden" name="main_project_id" id="main_project_id" value="#get_opportunity.RELATED_PROJECT_ID#">
                                <input type="text" disabled name="main_project_head" id="main_project_head" value="<cfif len(get_opportunity.RELATED_PROJECT_HEAD)>#get_opportunity.RELATED_PROJECT_HEAD#</cfif>"   onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                   <!---<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_opp.project_id&project_head=upd_opp.project_head','list');"></span>--->
                           </div>
                       </div>
                       <div class="form-group" id="item-opp_invoice_date">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='57645.Teslim Tarihi'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <div class="input-group">
                                   <input type="text" name="opp_invoice_date" id="opp_invoice_date" value="#dateformat(get_opportunity.invoice_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                   <span class="input-group-addon"><cf_wrk_date_image date_field="opp_invoice_date"></span>
                               </div>
                           </div>
                       </div>
                       <cfquery name="query_customer_values" datasource="#dsn3#">
                           SELECT * FROM TEXTILE_CUSTOMER_VALUES WHERE IS_ACTIVE = 1 AND CUSTOMER_VALUE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#get_opportunity.CUSTOMER_VALUE#'>
                       </cfquery>
                       <div class="form-group" id="item-gyg_fire">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12">GYG-<cf_get_lang dictionary_id='62605.İmalat Firesi'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="text" name="gyg_fire" id="gyg_fire" value="#len(get_opportunity.gyg_fire)?get_opportunity.gyg_fire:query_customer_values.GYG_RATE#">
                           </div>
                       </div>
                       
                   </div>
               </div>
               <div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="4" sort="true">
                   <cf_seperator title="#getLang('','Ürün Detayları','58764')#" id="detail_seperator_">
                   <div  id="detail_seperator_">
                       <div class="form-group" id="item-product_cat_id">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12" >
                               <cfif len(get_opportunity.product_cat_id)>
                                   <cfset attributes.id = get_opportunity.product_cat_id>
                                   <cfinclude template="/V16/product/query/get_product_cat.cfm">
                                   <input type="hidden" name="product_cat_id" id="product_cat_id" value="#get_opportunity.product_cat_id#">
                                   <div class="input-group" >
                                       <cfif not len(get_product_cat.product_cat)>
                                           <input type="text" name="product_cat" id="product_cat" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
                                           <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&field_id=upd_opp.product_cat_id&field_name=upd_opp.product_cat');"></span>
                                       <cfelse>
                                           <input type="hidden" name="product_cat" id="product_cat" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#">
                                           #get_product_cat.hierarchy# #get_product_cat.product_cat#
                                       </cfif>
                                   </div>
                               <cfelse>
                                   <input type="hidden" name="product_cat_id" id="product_cat_id" value="">
                                   <div class="input-group" >
                                       <input type="text" name="product_cat" id="product_cat" value="" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
                                       <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&field_id=upd_opp.product_cat_id&field_name=upd_opp.product_cat');"></span>
                                   </div>
                               </cfif>
                           </div>
                       </div>
                       <div class="form-group" id="item-stock_id">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58800.Ürün Kodu'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="hidden" name="stock_id" id="stock_id" value="#get_opportunity.stock_id#">
                               <cfif len(get_opportunity.stock_id)>
                                   <cfset attributes.stock_id = get_opportunity.stock_id>
                                   <cfinclude template="/V16/sales/query/get_stock_name.cfm">
                               </cfif>
                               <div class="input-group">
                                       <cfif not len(get_opportunity.stock_id)>
                                           <input type="text" name="stock_name" id="stock_name" value="<cfif len(get_opportunity.stock_id)>#get_stock_name.product_name#</cfif>">
                                       <cfelse>
                                            <!---#get_stock_name.product_name#--->
                                            <input type="hidden" name="stock_name" id="stock_name" value="<cfif len(get_opportunity.stock_id)>#get_stock_name.product_name#</cfif>">
                                            <a class="tableyazi"  href="javascript://" onclick="window.open('#request.self#?fuseaction=product.list_product&event=det&pid=#get_opportunity.product_id#');">#get_stock_name.product_name#</a>											
                                       </cfif>
                               </div>
                           </div>
                       </div>
                            <div class="form-group" id="item-short_code_name">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                       <cfset deger = "">
                            <div class="col col-8 col-md-12 col-sm-12 col-xs-12" >
                                <cfif not len(get_opportunity.short_code_id)>
                                    <!--- necip menekşe --->
                                    <input type="hidden" name="old_short_code" id="old_short_code" value="<cfoutput>#get_opportunity.short_code#</cfoutput>">
                                    <cf_wrkproductbrand
                                    returninputvalue="short_code_id,short_code"
                                    returnqueryvalue="brand_id,brand_name"
                                    fieldname="short_code"
                                    fieldid="short_code_id"
                                    width="140"
                                    compenent_name="getProductBrand"               
                                    boxwidth="300"
                                    boxheight="150"
                                    is_internet="1"
                                    brand_code="1"
                                    brand_id="">		
                                <cfelse>
                                    <input type="hidden" name="short_code_name" id="short_code_name" value="">
                                    <input type="hidden" name="old_short_code" id="old_short_code" value="<cfoutput>#get_opportunity.short_code#</cfoutput>">
                                    <input type="hidden" name="short_code" id="short_code" value="<cfoutput>#get_opportunity.short_code#</cfoutput>">
                                    <input type="hidden" name="short_code_id" id="short_code_id" value="<cfoutput>#get_opportunity.short_code_id#</cfoutput>">
                                    #get_opportunity.short_code#
                                </cfif>
                           </div>
                       </div>
                       <div class="form-group" id="item-model-no">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62569.Müşteri Model No'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="text" name="musteri_model_no" value="<cfoutput>#get_opportunity.company_model_no#</cfoutput>">
                           </div>
                       </div>
                        <cfquery name="GET_MONEYS" datasource="#dsn#">
                            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
                        </cfquery>
                       <div class="form-group" id="item-ok-price">
                           <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37042.Satış Fiyatı'></label>
                            <div class="col col-8 col-md-12 col-sm-12 col-xs-12"> 
                                <div class="input-group">
                                <input type="text" name="CONFIG_PRICE_OTHER" class="box"  value="#tlformat(get_opportunity.CONFIG_PRICE_OTHER)#">	
                                    <span class="input-group-addon width">
                                        <select name="CONFIG_PRICE_MONEY" id="CONFIG_PRICE_MONEY">
                                            <cfloop query="GET_MONEYS">
                                                <option value="#MONEY#" <cfif (get_opportunity.CONFIG_PRICE_MONEY) eq (MONEY)>selected</cfif> >#MONEY#</option> 
                                            </cfloop>
                                        </select>
                                    </span>
                                </div>
                            </div>
                       </div>
                       <div class="form-group" id="item-commission">
                        <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='35334.Komisyon Oranı'></label>
                        <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="commission" id="commission" value="#tlformat(get_opportunity.commission, 2)#">
                                <span class="input-group-addon"> % </span>
                            </div>
                        </div>
                    </div>
                      
                    <div class="form-group" id="item-ok-price">
                        <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='62606.Hedef Fiyat'></label>
                        <div class="col col-8 col-md-12 col-sm-12 col-xs-12"> 
                            <div class="input-group">
                                <input type="text" name="target_price" class="box"  value="#tlformat(get_opportunity.TARGET_PRICE)#">	
                                    <span class="input-group-addon width">
                                        <select name="target_money" id="target_money" onchange="get_currency();">
                                            <cfloop query="GET_MONEYS">
                                                <option value="#MONEY#" <cfif trim(get_opportunity.TARGET_MONEY) eq trim(MONEY)>selected</cfif>>#MONEY#</option>
                                            </cfloop>
                                        </select>
                                    </span>
                            </div> 
                        </div>
                    </div>
                       <div class="form-group" id="item-ok-price">
                        <label class="col col-4 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='62607.Hedef Miktar'></label>
                           <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                               <input type="text" name="target_amount" class="box"  value="#tlformat(get_opportunity.TARGET_AMOUNT,0)#">	
                        </div>
                    </div>
                   </div>
               </div>
         </cfoutput>	
       </cf_box_elements>
       <cf_box_footer>
           <div class="col col-6"><cf_record_info query_name="get_opportunity" is_partner='1'></div>
           <div class="col col-6">
               <cfif get_opportunity.is_processed eq 1>
                       <div style="padding:3px; float:right;"><font color="red"><strong><cf_get_lang dictionary_id='34407.İşlendi'></strong></font></div>
               <cfelse>
                   <cfif attributes.fuseaction eq 'textile.list_sample_request' and attributes.event eq 'det'>
                       <cfset url.req_id=attributes.req_id>
                       <cf_workcube_buttons is_upd='1' is_delete="0" type_format="1" delete_page_url='#request.self#?fuseaction=textile.emptypopup_del_req&req_id=#url.req_id#&opportunity_no=#get_opportunity.req_no#&head=#get_opportunity.req_head#&cat=#get_opportunity_type.opportunity_type_id#' add_function='kontrol()'>
                   </cfif>	
               </cfif>
           </div>
       </cf_box_footer>
    
   </div>
   <script>
       $("#company_detay input").prop('disabled', true);
       
   </script>