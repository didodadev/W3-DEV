<cf_xml_page_edit fuseact ="prod.add_product_tree" default_value="0">
<cfsetting showdebugoutput="no">
<cfparam name="old_main_spec_id" default="0">
<cfparam name="attributes.stock_id" default="0">
<cfset attributes.stock_main_id = attributes.stock_id>
<cfinclude template="../query/get_product_info.cfm">
<cfif not isdefined("attributes.approach")><cfset attributes.approach=get_product.PRODUCTION_TYPE></cfif>
<cfif not isdefined("attributes.is_used_rate")><cfset attributes.is_used_rate=get_product.PRODUCTION_AMOUNT_TYPE></cfif>
<cfif not len(attributes.approach)><cfset attributes.approach=1></cfif>
<cfif not len(attributes.is_used_rate)><cfset attributes.is_used_rate=0></cfif>
<cfset getComponent = createObject('component','V16.production_plan.cfc.get_tree')>
<cfset GET_PRO_TREE_ID = getComponent.GET_PRO_TREE_ID(stock_id : attributes.stock_id)>
<cfif not isDefined("attributes.product_id")><cfset attributes.product_id = get_product.product_id></cfif>
<cfquery name="get_alternative_questions" datasource="#dsn#">
	SELECT QUESTION_ID,QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS
</cfquery>
<cfquery name="get_tree_types" datasource="#dsn#">
	SELECT TYPE_ID,
    #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
      FROM PRODUCT_TREE_TYPE
</cfquery>
<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
    <cfquery name="get_product_info" datasource="#dsn1#">
        SELECT IS_PRODUCTION, PRODUCT_CODE, IS_TERAZI, IS_INVENTORY, PRODUCT_STATUS FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
    </cfquery>
    <cfif isdefined("get_product.product_sample_id") and len(get_product.product_sample_id)>
        <cfquery name="get_product_sample" datasource="#dsn1#">
            SELECT * FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> and
            P_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_sample_id#">
        </cfquery>
     </cfif>
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
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_prod_order"> AND
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

<cfset PageHead = "#getlang('prod','Ürün Ağacı',36365)#: #get_product.stock_code#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-9 col-xs-12">
    <cfif len(get_product.PRODUCT_ID)>
        <cfif get_product.PRODUCT_CODE  eq get_product.STOCK_CODE><cfset stock_type=getlang('','Master','56058')><cfelse><cfset stock_type=getlang('','Versiyon','52829')></cfif>
    <cfelse>
        <cfset stock_type="">
    </cfif>
        <cf_box title="#getLang('','Yaklaşım',63505)# - #get_product.product_name# -  #stock_type#">
        <cfform name="add_approach" method="post">
            <div class="ui-form-list flex-list">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='63505.Yaklaşım'></label>
                    <select name="approach" id="approach">
                        <option value="1" <cfif attributes.approach eq 1> selected</cfif>><cf_get_lang dictionary_id='63506.Birleştirme'></option>
                        <option value="2" <cfif attributes.approach eq 2> selected</cfif>><cf_get_lang dictionary_id='63507.Ayrıştırma'></option>
                        <option value="3" <cfif attributes.approach eq 3> selected</cfif>><cf_get_lang dictionary_id='63508.Şekil Değiştirme'></option>
                    </select>
                </div>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='63509.Miktar Tipi'></label>
                    <select name="is_used_rate" id="is_used_rate">
                        <option value="0" <cfif attributes.is_used_rate eq 0> selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
                        <option value="1" <cfif attributes.is_used_rate eq 1> selected</cfif>><cf_get_lang dictionary_id='62480.Oransal'>%</option>
                    </select>
                </div>
                <div class="form-group">
					<cf_wrk_search_button button_type="5" value="#getlang('','Hesapla','58998')#">
				</div>
                 <div class="form-group">
                <cfoutput>
                    <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra" onclick="action='#request.self#?fuseaction=product.emptypopup_upd_approach&stock_id=#attributes.stock_id#'" value="#getlang('','Güncelle','57464')#">
                </cfoutput>
            </div>
        </div>
        </cfform>
    </cf_box>
    <cfform name="add_sub_product" action="#request.self#?fuseaction=prod.emptypopup_add_sub_product" method="post">
        <cf_box title="#getLang('','Bileşen Ekle',48515)#">	
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
               
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
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
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' select_value='#GET_PRO_TREE_ID.process_stage#'>
						</div>
					</div>
                    <cfsavecontent variable="header_"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                    <div class="form-group" id="form_ul_product_name">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="add_stock_id" id="add_stock_id" value="">
                                    <input type="text" name="product_name" id="product_name">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names<cfoutput>#xml_str#</cfoutput>&stock_and_spect=1&field_spect_main_id=add_sub_product.spect_main_id&field_spect_main_name=add_sub_product.spect_main_name&field_id=add_sub_product.add_stock_id&field_name=add_sub_product.product_name&product_id=add_sub_product.product_id&field_unit=add_sub_product.unit_id')"></span>
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
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
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
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
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
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
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
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cfif x_is_phantom_tree eq 1>
                            <label>
                                <input type="checkbox" name="is_phantom" id="is_phantom" value="1">
                                <cf_get_lang dictionary_id='36362.Bu Ürün İçin Üretim Emri Oluşturma'>
                            </label>
                        </cfif>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                        <label>
                            <input type="checkbox" name="is_configure" id="is_configure" value="1" <cfif is_select_configure eq 1>checked="checked"</cfif>>
                            <cf_get_lang dictionary_id='57236.Konfigure edilmez'> - <cf_get_lang dictionary_id='36799.Konfigure edilmez'>
                        </label>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' is_cancel="0" add_function='kontrol()' insert_info='#getLang('','Bileşen Ekle',48515)#'>
            </cf_box_footer>
        </cf_box>
    </cfform>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id="35700.Bileşenler"></cfsavecontent>
    <cf_box title="#head#" widget_load="components&stock_id=#attributes.stock_id##iif(isdefined('attributes.main_stock_id'),DE('&main_stock_id=##attributes.main_stock_id##'),DE(''))#&_product_tree_id_=#_product_tree_id_#&is_line_number=#is_line_number#&old_main_spec_id=#old_main_spec_id#&fuseaction_=#attributes.fuseaction#&is_used_rate=#attributes.is_used_rate#"></cf_box>
    <cfif isDefined("attributes.product_id") and len(attributes.product_id)>
        <cf_box id="by_products" title="#getLang('','Yan Ürünler',64082)# - #getlang('','Çıktılar','36476')#"  widget_load="byproducts&stock_id=#attributes.stock_id#&product_id=#attributes.product_id#"></cf_box>
    </cfif>
    <cfif isDefined("attributes.product_id") and len(attributes.product_id)>
        <cf_box title="#getLang('','Stoklar',58166)#" box_page="#request.self#?fuseaction=product.emptypopup_ajax_dsp_product_stocks&is_production=#get_product_info.is_production#&pid=#attributes.product_id#&product_code=#get_product_info.product_code#&is_terazi=#get_product_info.is_terazi#&is_inventory=#get_product_info.is_inventory#&is_auto_barcode=0&is_product_status=#get_product_info.product_status#"></cf_box>
    </cfif>

    <cfif is_show_prod_amount eq 1>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36392.Malzeme ihtiyaç Tablosu'></cfsavecontent>
        <cfif isdefined("attributes.main_stock_id")>
            <cf_box
                title="#message#"
                id="DET_MET"
                closable="0" 
                box_page="#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&from_product_tree=1&stock_id=#attributes.stock_id#&main_stock_id=#attributes.main_stock_id#">
                </cf_box>
        <cfelse>
            <cf_box
                title="#message#"
                id="DET_MET"
                closable="0" 
                scroll="1" 
                box_page="#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&from_product_tree=1&stock_id=#attributes.stock_id#">
            </cf_box>
        </cfif>
    </cfif>
</div>

<script type="text/javascript">
	function open_spec()
	{
		if(document.getElementById("add_stock_id").value!='' && document.getElementById("product_name").value!='')
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id&stock_id='+document.getElementById("add_stock_id").value,'list')
		else
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
	}
    function fire_control()
	{
		
        var amount_=parseFloat(filterNum(document.add_sub_product.amount.value,8));
        var fire_amount_= parseFloat(filterNum(document.add_sub_product.fire_amount.value,8));
		
       
		if(document.add_sub_product.amount.value != '' && document.add_sub_product.fire_amount.value!='')
		{
			var fire_operation=(100* fire_amount_)/amount_;
			fire_operation=fire_operation.toFixed(2);
			document.add_sub_product.fire_rate.value=fire_operation;
		
		}
		else{
			document.add_sub_product.fire_rate.value=''
			
		}
	
	}
    
	function kontrol()
	{
        
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
		if((document.getElementById("add_stock_id").value == '' || document.getElementById("product_name").value == '' ) && ((document.getElementById('operation_type')!= undefined && document.getElementById('operation_type').value =="") || document.getElementById('operation_type') == undefined))
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57998.veya'> <cf_get_lang dictionary_id='29419.Operasyon'>");
			return false;
		}
		if((document.getElementById("add_stock_id").value != '' && document.getElementById("product_name").value!='') && (document.getElementById('operation_type').value!=''))
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
		document.getElementById("process_stage_").value = document.getElementById("process_stage").value;
		return process_cat_control();
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
</script>
