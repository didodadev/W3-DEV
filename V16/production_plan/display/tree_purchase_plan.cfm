<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.tree_types" default="">
<cfparam name="attributes.designer_emp_id" default="">
<cfparam name="attributes.designer_emp" default="">
<cfparam name="attributes.ted_company_id" default="">
<cfparam name="attributes.ted_company" default="">
<cfparam name="attributes.opportunity_id" default="">
<cfparam name="attributes.opp_head" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.process_stage" default="">

<cfset purchase_plan = createObject("component","V16.production_plan.cfc.get_tree") />
<cfset get_process_stage = purchase_plan.sample_process_stage()>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
    <cfset prod_sample = purchase_plan.LIST_PRODUCT_SAMPLE(
        product_id : '#IIf(len(attributes.product_id) and len(attributes.product_name),"attributes.product_id",DE(""))#',
        consumer_id : '#IIf(len(attributes.consumer_id) and len(attributes.company_name),"attributes.consumer_id",DE(""))#',
        company_id : '#IIf(len(attributes.company_id) and len(attributes.company_name),"attributes.company_id",DE(""))#',
        tree_types : '#IIf(len(attributes.tree_types),"attributes.tree_types",DE(""))#',
        designer_emp_id : '#IIf(len(attributes.designer_emp_id) and len(attributes.designer_emp),"attributes.designer_emp_id",DE(""))#',
        ted_company_id : '#IIf(len(attributes.ted_company) and len(attributes.ted_company_id),"attributes.ted_company_id",DE(""))#',
        opportunity_id : '#IIf(len(attributes.opportunity_id) and len(attributes.opp_head),"attributes.opportunity_id",DE(""))#',
        process_stage : attributes.process_stage,
        startrow :'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
    )/>
<cfelse>
    <cfset prod_sample.recordcount = 0>
</cfif>
<cfif prod_sample.recordcount gt 0>
    <cfparam name="attributes.totalrecords" default='#prod_sample.QUERY_COUNT#'>
<cfelse>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfquery name="get_tree_types" datasource="#dsn#">
    SELECT TYPE_ID, TYPE FROM PRODUCT_TREE_TYPE
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_product_sample" method="post">          
            <cf_box_search plus="0">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group" id="form_ul_product_name">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="#attributes.product_id#"</cfif>>
                            <input name="product_name" placeholder="#getLang('','Ürün',57657)#" type="text" id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','product_id','product_id','list_product_sample','3','200');" value="<cfif len(attributes.product_id) and len(attributes.product_name)>#attributes.product_name#</cfif>" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=list_product_sample.product_id&field_name=list_product_sample.product_name');"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="form_ul_member_name">
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
                            <input name="company_name" type="text" id="company_name" value="<cfif len(attributes.company_name)>#attributes.company_name#</cfif>" placeholder="#getLang('','Müşteri','57457')#" >
                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=list_product_sample.company_id&field_comp_name=list_product_sample.company_name&field_consumer=list_product_sample.consumer_id&par_con=1&select_list=2,3');"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="form_ul_tree_types">
                    <select name="tree_types" id="tree_types">
                        <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                        <cfloop query="get_tree_types">
                            <cfoutput><option value="#TYPE_ID#" <cfif TYPE_ID eq attributes.tree_types> selected </cfif> >#TYPE#</option></cfoutput>
                        </cfloop>
                    </select>
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
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="form_ul_designer_emp">
                        <cf_get_lang dictionary_id='61924.Tasarımcı'>
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="designer_emp_id" id="designer_emp_id" value="<cfif Len(attributes.designer_emp)>#attributes.designer_emp_id#</cfif>">
                                    <input type="text" name="designer_emp" id="designer_emp" value="<cfif Len(attributes.designer_emp)>#attributes.designer_emp#</cfif>" style="width:110px;" onfocus="AutoComplete_Create('designer_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','designer_emp_id','','3','125');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_product_sample.designer_emp_id&field_name=list_product_sample.designer_emp&select_list=1,9&branch_related')"></span>
                                </cfoutput>
                            </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-record_emp_id">
                        <cf_get_lang dictionary_id='29533.Tedarikçi'>
                        <div class="input-group">
                            <input type="hidden" name="ted_company_id" id="ted_company_id" value="<cfif Len(attributes.ted_company_id)><cfoutput>#attributes.ted_company_id#</cfoutput></cfif>">
                            <input name="ted_company" type="text" id="ted_company" value="<cfif Len(attributes.ted_company)><cfoutput>#attributes.ted_company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','ted_company_id','','3','150');" value="" autocomplete="off" class=""><div id="company_div_2" name="company_div_2" class="completeListbox" autocomplete="on" style="width: 449px; max-height: 150px; overflow: auto; position: absolute; left: 0px; top: 30px; z-index: 159; display: none;"></div>
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&amp;field_comp_name=list_product_sample.ted_company&amp;field_comp_id=list_product_sample.ted_company_id&amp;select_list=2');"></span>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item_opp_head">
                        <cf_get_lang dictionary_id='57612.Fırsat'>
                        <div class="input-group">
                            <input type="hidden" name="opportunity_id" id="opportunity_id" value="<cfif Len(attributes.opportunity_id)><cfoutput>#attributes.opportunity_id#</cfoutput></cfif>">
                            <input type="text" name="opp_head" id="opp_head" placeholder="" value="<cfif Len(attributes.opp_head)><cfoutput>#attributes.opp_head#</cfoutput></cfif>" class="">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_opportunities&amp;field_opp_id=list_product_sample.opportunity_id&amp;field_opp_head=list_product_sample.opp_head')"></span>
                        </div>        
                    </div>
                </div>
            </cf_box_search_detail> 
        </cfform>
    </cf_box>
    <cfset counter = 1>
    <cf_box title="#getLang('','Tedarik Planı',63564)#" uidrop="1" hide_table_column="1"> 
        <cfform name="purchase_plan_form_#counter#" method="post">
            <cf_grid_list>  
                <thead>
                    <tr>
                        <th width="10">No</th>
                        <th width="15" class="text-center">S</th>
                        <th width="15" class="text-center" title="<cfoutput>#getLang('','Alternatif Soru',36454)#</cfoutput>">A</th>
                        <th><cf_get_lang dictionary_id='62603.numune'><cf_get_lang dictionary_id='57897.Adı'></th>
                        <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                        <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                        <th><cf_get_lang dictionary_id='57612.Fırsat'></th>
                        <th><cf_get_lang dictionary_id='61924.Tasarımcı'></th>
                        <th><cf_get_lang dictionary_id='63502.Bileşen Tipi'></th>
                        <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th><cf_get_lang dictionary_id='62606.Hedef Fiyat'></th>
                        <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                        <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>    
                        <th><cf_get_lang dictionary_id='63568.Tedarikçi Puanı'></th>   
                        <th width="10"></th>
                        <th width="10"></th>
                    </tr>
                </thead>
                <tbody>
                <cfif prod_sample.recordcount>
                    <cfoutput query="prod_sample">
                        <cfquery name="get_alternative_products" datasource="#dsn3#">
                            SELECT COUNT(ALTERNATIVE_ID) AS COUNT FROM ALTERNATIVE_PRODUCTS WHERE PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_TREE_ID#">
                        </cfquery>
                            <tr>
                                <td>#currentrow#</td>
                                <td class="text-center">
                                        <i 
                                            style="color:green;" 
                                            class="fa fa-shopping-cart" 
                                            title="#getLang('','Alternatif Ürünler',32776)#"
                                            onclick="gizle_goster(row_#currentrow#);connectAjax(#PRODUCT_TREE_ID#,#currentrow#, #T_PRODUCT_ID#, #stock_id#, 2);">
                                        </i>
                                </td>
                                <td class="text-center">
                                    <cfif get_alternative_products.COUNT gt 0>
                                        <i 
                                            style="color:orange;" 
                                            class="fa fa-tags" 
                                            title="#getLang('','Alternatif Soru',36625)#"
                                            onclick="gizle_goster(row_#currentrow#);connectAjax(#PRODUCT_TREE_ID#,#currentrow#, #T_PRODUCT_ID#, #stock_id#, 1);"
                                            ></i>
                                    </cfif>
                                </td>    
                                <td><a href="#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#product_sample_id#">#PRODUCT_SAMPLE_NAME#</a></td>
                                <td><cf_workcube_process type="color-status" select_name="PROCESS_STAGE" process_stage="#PROCESS_STAGE_ID#"  fuseaction="product.product_sample"></td>
                                <td>
                                    <cfif len(consumer_id)> 
                                        #get_cons_info(consumer_id,0,0)#
                                    <cfelseif len(company_id)> 
                                        #get_par_info(company_id,1,1,0)# 
                                    </cfif>
                                </td>
                                <td><a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#opp_id#&product_sample_id=#product_sample_id#">#OPP_HEAD#</a></td>
                                <td><cfif len(designer_emp_id)>#get_emp_info(designer_emp_id,0,0)#</cfif></td>
                                <td>#TREE_TYPE_NAME#</td>
                                <td>
                                    <cfif len(T_PRODUCT_ID)>
                                    <cfquery name="get_prod_name" datasource="#dsn3#">
                                        SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#T_PRODUCT_ID#">
                                    </cfquery>
                                    #get_prod_name.PRODUCT_NAME#
                                    </cfif>
                                </td>
                                <td class="text-right"><cfif len(AMOUNT)>#TLFormat(AMOUNT)#</cfif></td>
                                <td><cfif len(AMOUNT)>#MAIN_UNIT#</cfif></td>
                                <td class="text-right"><cfif len(target_price)>#TLFormat(target_price)#</cfif></td>
                                <td><cfif len(target_price)>#target_price_currency#</cfif></td>
                                <td>
                                    <cfif len(supplier_company_id)> 
                                        #get_par_info(supplier_company_id,1,1,0)# 
                                    </cfif>
                                </td>
                                <td class="text-right">
                                    <cfif len(technical_point)>
                                        #TLFormat(TECHNICAL_POINT)#
                                    </cfif>
                                </td>
                                <td>
                                    <cfif IS_PRODUCTION eq 1>
                                        <a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&product_id=#product_id#&stock_id=#stock_id#">
                                        <i style="color:green !important;" class="fa fa-tree" title="#getLang('','Ürün Ağacı',140)#"></i></a>
                                    </cfif>
                                </td>
                                <td><a href="#request.self#?fuseaction=prod.tree_purchase_plan&event=det&product_sample_id=#PRODUCT_SAMPLE_ID#&stock_id=#stock_id#"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            </tr>
                            <tr id="row_#currentrow#" style="display:none;">
                                <td colspan="20">
                                    <div align="left" id="alternative_info_#currentrow#"></div>
                                </td>
                            </tr>
                    </cfoutput>
                </cfif>
                </tbody> 
            </cf_grid_list>
            <cfif prod_sample.recordcount eq 0>
                <div class="ui-info-bottom">
                    <p><cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</p>
                </div>
            </cfif>
        </cfform>
        <cfset counter++>
        <cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif len(attributes.form_submitted)>
                <cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
            </cfif>
            <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                <cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
            </cfif>
            <cfif len(attributes.ted_company_id)>
                <cfset url_str = "#url_str#&ted_company_id=#attributes.ted_company_id#">
            </cfif>
            <cfif len(attributes.ted_company)>
                <cfset url_str = "#url_str#&ted_company=#attributes.ted_company#">
            </cfif>
            <cfif len(attributes.opportunity_id)>
                <cfset url_str = "#url_str#&opportunity_id=#attributes.opportunity_id#">
            </cfif>
            <cfif len(attributes.opp_head)>
                <cfset url_str = "#url_str#&opp_head=#attributes.opp_head#">
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
            <cfif len(attributes.tree_types)>
                <cfset url_str = "#url_str#&tree_types=#attributes.tree_types#">
            </cfif>
            <cfif len(attributes.product_id)>
                <cfset url_str = "#url_str#&product_id=#attributes.product_id#">
            </cfif>
            <cfif len(attributes.product_name)>
                <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
            </cfif>
            <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="prod.tree_purchase_plan#url_str#">
        </cfif>
    </cf_box>
</div>

<script>
    function connectAjax(tree_id, currentrow, product_id, stock_id, type){
		var load_url = '<cfoutput>#request.self#</cfoutput>?fuseaction=prod.tree_purchase_plan_alternative&counter=1&product_id='+product_id+'&stock_id='+stock_id+'&type='+type+'&product_tree_id='+tree_id;
		AjaxPageLoad(load_url, 'alternative_info_' + currentrow, 1);
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
</script>