<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact ="prod.manage_product_tree" default_value="0">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.pro_type" default="1">
<cfparam name="attributes.upd_amount_type" default="0">
<cfparam name="attributes.miktar" default="1">
<cfparam name="attributes.new_stock_name" default="">
<cfparam name="attributes.new_product_id" default="">
<cfparam name="attributes.new_stock_id" default="">
<cfparam name="attributes.old_stock_name" default="">
<cfparam name="attributes.old_product_id" default="">
<cfparam name="attributes.old_stock_id" default="">
<cfparam name="attributes.product_id_1" default="">
<cfparam name="attributes.product_name_1" default="">
<cfparam name="attributes.product_id_2" default="">
<cfparam name="attributes.product_name_2" default="">
<cfparam name="attributes.product_id_3" default="">
<cfparam name="attributes.product_name_3" default="">
<cfparam name="attributes.product_id_4" default="">
<cfparam name="attributes.product_name_4" default="">
<cfparam name="attributes.product_id_5" default="">
<cfparam name="attributes.product_name_5" default="">
<cfparam name="attributes.spect_main_id_1" default="">
<cfparam name="attributes.spect_main_name_1" default="">
<cfparam name="attributes.spect_main_id_2" default="">
<cfparam name="attributes.spect_main_name_2" default="">
<cfparam name="attributes.spect_main_id_3" default="">
<cfparam name="attributes.spect_main_name_3" default="">
<cfparam name="attributes.spect_main_id_4" default="">
<cfparam name="attributes.spect_main_name_4" default="">
<cfparam name="attributes.spect_main_id_5" default="">
<cfparam name="attributes.spect_main_name_5" default="">
<cfparam name="attributes.operation_type" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfparam name="attributes.is_upd_amount" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.report_type" default="0">
<cfparam name="attributes.question_id" default="">
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="get_questions" datasource="#dsn#">
	SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS ORDER BY QUESTION_NAME
</cfquery>
<cfinclude template="../../production_plan/query/get_product_list.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ürün Ağacı Revizyon Yönetim Ekranı',36972)#">
        <cfform name="report_special" enctype="multipart/form-data" method="post" action="">
            <input type="hidden" value="1" name="is_submit" id="is_submit">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='110' is_detail='0' >
                        </div>
                    </div>
                    <div class="form-group" id="item-get_product_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="cat" id="cat" multiple="multiple">
                                <cfoutput query="get_product_cat">
                                    <cfif listlen(HIERARCHY,".") lte 5>
                                        <option value="#HIERARCHY#" <cfif listfind(attributes.cat,HIERARCHY)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-operation">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29419.Operasyon'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkoperationtype operation_type_id="#attributes.operation_type_id#" width="110" boxwidth="250">
                        </div>
                    </div>
                    <div class="form-group" id="item-getProductBrand">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkproductbrand
                                width="110"
                                compenent_name="getProductBrand"               
                                boxwidth="240"
                                boxheight="150"
                                brand_id="#attributes.brand_id#">
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-product_name_1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 1</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id_1" id="product_id_1" value="<cfoutput>#attributes.product_id_1#</cfoutput>">
                                <cfinput type="text" name="product_name_1" id="product_name_1" value="#attributes.product_name_1#" onFocus="AutoComplete_Create('product_name_1','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_1','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_1&field_name=report_special.product_name_1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_name_2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id_2" id="product_id_2" value="<cfoutput>#attributes.product_id_2#</cfoutput>">
                                <cfinput type="text" name="product_name_2" id="product_name_2" value="#attributes.product_name_2#" onFocus="AutoComplete_Create('product_name_2','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_2','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_2&field_name=report_special.product_name_2');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_name_3">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 3</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id_3" id="product_id_3" value="<cfoutput>#attributes.product_id_3#</cfoutput>">
                                <cfinput type="text" name="product_name_3" id="product_name_3" value="#attributes.product_name_3#" onFocus="AutoComplete_Create('product_name_3','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_3','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_3&field_name=report_special.product_name_3');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_name_4">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 4</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id_4" id="product_id_4" value="<cfoutput>#attributes.product_id_4#</cfoutput>">
                                <cfinput type="text" name="product_name_4" id="product_name_4" value="#attributes.product_name_4#" onFocus="AutoComplete_Create('product_name_4','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_4','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_4&field_name=report_special.product_name_4');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_name_5">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 5</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id_5" id="product_id_5" value="<cfoutput>#attributes.product_id_5#</cfoutput>">
                                <cfinput type="text" name="product_name_5" id="product_name_5" value="#attributes.product_name_5#" onFocus="AutoComplete_Create('product_name_5','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_5','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_5&field_name=report_special.product_name_5');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-spect_main_name_1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34299.Spec'> 1</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id_1" id="spect_main_id_1" value="<cfoutput>#attributes.spect_main_id_1#</cfoutput>">
                                <cfinput type="text" name="spect_main_name_1" id="spect_main_name_1" value="#attributes.spect_main_name_1#">
                                <span class="input-group-addon icon-ellipsis" onclick="product_control(1);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-spect_main_name_2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34299.Spec'> 2</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id_2" id="spect_main_id_2" value="<cfoutput>#attributes.spect_main_id_2#</cfoutput>">
                                <cfinput type="text" name="spect_main_name_2" id="spect_main_name_2" value="#attributes.spect_main_name_2#">
                                <span class="input-group-addon icon-ellipsis" onclick="product_control(2);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-spect_main_name_3">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34299.Spec'> 3</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id_3" id="spect_main_id_3" value="<cfoutput>#attributes.spect_main_id_3#</cfoutput>">
                                <cfinput type="text" name="spect_main_name_3" id="spect_main_name_3" value="#attributes.spect_main_name_3#">
                                <span class="input-group-addon icon-ellipsis" onclick="product_control(3);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-spect_main_name_4">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34299.Spec'> 4</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id_4" id="spect_main_id_4" value="<cfoutput>#attributes.spect_main_id_4#</cfoutput>">
                                <cfinput type="text" name="spect_main_name_4" id="spect_main_name_4" value="#attributes.spect_main_name_4#">
                                <span class="input-group-addon icon-ellipsis" onclick="product_control(4);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-spect_main_name_5">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34299.Spec'> 5</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id_5" id="spect_main_id_5" value="<cfoutput>#attributes.spect_main_id_5#</cfoutput>">
                                <cfinput type="text" name="spect_main_name_5" id="spect_main_name_5" value="#attributes.spect_main_name_5#">
                                <span class="input-group-addon icon-ellipsis" onclick="product_control(5);"></span>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-old_stock_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="old_stock_id" id="old_stock_id" value="<cfoutput>#attributes.old_stock_id#</cfoutput>">
                                <input type="hidden" name="old_product_id" id="old_product_id" value="<cfoutput>#attributes.old_product_id#</cfoutput>">
                                <cfinput type="text" name="old_stock_name" id="old_stock_name" value="#attributes.old_stock_name#" onFocus="AutoComplete_Create('old_stock_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','old_stock_id,old_product_id','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.old_stock_id&product_id=report_special.old_product_id&field_name=report_special.old_stock_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-new_stock_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58674.Yeni'> <cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="new_stock_id" id="new_stock_id" value="<cfoutput>#attributes.new_stock_id#</cfoutput>">
                                <input type="hidden" name="new_product_id" id="new_product_id" value="<cfoutput>#attributes.new_product_id#</cfoutput>">
                                <cfinput type="text" name="new_stock_name" id="new_stock_name" value="#attributes.new_stock_name#" onFocus="AutoComplete_Create('new_stock_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','new_stock_id,new_product_id','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.new_stock_id&product_id=report_special.new_product_id&field_name=report_special.new_stock_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-miktar">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-8 col-xs-12">
                            <input name="miktar" id="miktar" type="text" value="<cfoutput>#tlformat(attributes.miktar,8)#</cfoutput>" style="width:65px;text-align:right;" onkeyup="return(FormatCurrency(this,event,8));">
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-pro_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'></label>
                        <div class="col col-8 col-xs-12">
                            <label><input type="radio" name="report_type" id="report_type" value="0" onclick="report_type_control(0);" <cfif attributes.report_type eq 0>checked</cfif>> <cf_get_lang dictionary_id='57657.Ürün'></label>
                            <label><input type="radio" name="report_type" id="report_type" value="1" onclick="report_type_control(1);" <cfif attributes.report_type eq 1>checked</cfif>> <cf_get_lang dictionary_id='36454.Alternatif Sorusu'></label>
                            <label><input type="radio" name="pro_type" id="pro_type1" value="0" onclick="kontrol_type(0);" <cfif attributes.pro_type eq 0>checked</cfif>> <cf_get_lang dictionary_id='36974.Çıkar'></label>
                            <label><input type="radio" name="pro_type" id="pro_type2" value="1" onclick="kontrol_type(1);" <cfif attributes.pro_type eq 1>checked</cfif>> <cf_get_lang dictionary_id='57582.Ekle'></label>                     
                            <label><input type="radio" name="pro_type" id="pro_type3" value="2" onclick="kontrol_type(2);" <cfif attributes.pro_type eq 2>checked</cfif>> <cf_get_lang dictionary_id='36975.Değiştir'></label>
                            <label <cfif attributes.pro_type neq 2>style="display:none;" </cfif> id="amount_table"><input type="checkbox" name="is_upd_amount" id="is_upd_amount" onclick="kontrol_upd_type();" value="1" <cfif attributes.is_upd_amount eq 1>checked</cfif>><cf_get_lang dictionary_id='36976.Miktarı Güncelle'></label>
                        </div>
                    </div>
                    <div class="form-group" id="question_id2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="question_id" id="question_id">
                                <cfoutput query="get_questions">
                                    <option value="#question_id#" <cfif listfind(attributes.question_id,question_id)>selected</cfif>>#question_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" <cfif not(attributes.pro_type eq 2 and attributes.is_upd_amount eq 1)>style="display:none;"</cfif> id="amount_table2">
                        <label class="col col-4 col-xs-12"></label>
                        <div class="col col-8 col-xs-12">
                            <label><input type="radio" name="upd_amount_type" id="upd_amount_type" value="0" <cfif attributes.upd_amount_type eq 0>checked</cfif>> <cf_get_lang dictionary_id="36493.Değer"></label>
                            <label><input type="radio" name="upd_amount_type" id="upd_amount_type" value="1" <cfif attributes.upd_amount_type eq 1>checked</cfif>> % <cf_get_lang dictionary_id="36757.Artır"></label>          
                            <label><input type="radio" name="upd_amount_type" id="upd_amount_type" value="2" <cfif attributes.upd_amount_type eq 2>checked</cfif>> % <cf_get_lang dictionary_id="36766.Azalt"></label>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<cfif isdefined("attributes.is_submit")>
	<cfscript>
		deep_level = 0;
		tree_id_list = '';
		question_id_list = '';
		function get_subs(related_id)
		{		
			if(len(attributes.question_id))
			 	param = 'AND QUESTION_ID = #attributes.question_id#';
			else
				param = '';
			if(len(related_id))
			{								
				SQLStr = "
						SELECT
							PRODUCT_TREE_ID RELATED_ID,
							ISNULL(RELATED_ID,0) STOCK_ID,
							ISNULL(QUESTION_ID,0) QUESTION_ID
						FROM 
							PRODUCT_TREE PT
						WHERE
							RELATED_PRODUCT_TREE_ID = #related_id#
					";
				query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
				stock_id_ary='';
				for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
				{
					stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
					stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
				}
				return stock_id_ary;
			}
		}
		function writeTree(product_tree_id)
		{
			var i = 1;
			var sub_products = get_subs(product_tree_id);
			_next_tree_id_ = '';
			_next_question_id_ = '';
			deep_level = deep_level + 1;
			if(isdefined("sub_products"))
			{
				for (i=1; i lte listlen(sub_products,'█'); i = i+1)
				{
					_next_tree_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
					_next_question_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');//alt+987 = █ --//alt+789 = §
					if(len(_next_tree_id_))
					{
						tree_id_list = listappend(tree_id_list,ListGetAt(ListGetAt(sub_products,i,'█'),1,'§'));
						question_id_list = listappend(question_id_list,ListGetAt(ListGetAt(sub_products,i,'█'),3,'§'));
						writeTree(_next_tree_id_);
					}
				 }
				 deep_level = deep_level-1;
			}
		}
	</cfscript>
	<cfset message_ = ''>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_PRODUCT_CAT') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_PRODUCT_CAT 
           END
    </cfquery>
    <cfquery name="crt_temp_product_cat" datasource="#dsn3#">
        CREATE TABLE ##TEMP_PRODUCT_CAT(
             PRODUCT_CATID INT
        )    
    </cfquery>
    <cfif len(attributes.cat)>
        <cfquery name="add_temp_product_cat" datasource="#dsn3#">
            <cfloop from="1" to="#listlen(attributes.cat)#" index="nn">
                INSERT INTO
                    ##TEMP_PRODUCT_CAT
                    (
                        PRODUCT_CATID
                    )
                    SELECT PRODUCT_CATID FROM PRODUCT_CAT WHERE HIERARCHY = '#ListGetAt(attributes.cat,nn,',')#'
            </cfloop>
        </cfquery>
    </cfif>
   
	<cfquery name="get_product_trees" datasource="#dsn3#">
		SELECT DISTINCT
			S.STOCK_ID,
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.IS_PROTOTYPE,
			PT.PROCESS_STAGE,
            PT.PRODUCT_TREE_ID,
            PT.OPERATION_TYPE_ID,
            PT.RELATED_ID
            <cfif len(attributes.spect_main_id_1) and len(attributes.spect_main_name_1)>
                ,#spect_main_id_1# SPECT_MAIN_ID_1
            <cfelse>
            	,'' SPECT_MAIN_ID_1
            </cfif>
            <cfif len(attributes.spect_main_id_2) and len(attributes.spect_main_name_2)>
                ,#spect_main_id_2# SPECT_MAIN_ID_2
            <cfelse>
            	,'' SPECT_MAIN_ID_2
            </cfif>
            <cfif len(attributes.spect_main_id_3) and len(attributes.spect_main_name_3)>
                ,#spect_main_id_3# SPECT_MAIN_ID_3
            <cfelse>
            	,'' SPECT_MAIN_ID_3
            </cfif>
            <cfif len(attributes.spect_main_id_4) and len(attributes.spect_main_name_4)>
                ,#spect_main_id_4# SPECT_MAIN_ID_4
            <cfelse>
            	,'' SPECT_MAIN_ID_4
            </cfif>
            <cfif len(attributes.spect_main_id_5) and len(attributes.spect_main_name_5)>
                ,#spect_main_id_5# SPECT_MAIN_ID_5
            <cfelse>
            	,'' SPECT_MAIN_ID_5
            </cfif>
		FROM
			PRODUCT_TREE PT,
			STOCKS S
            <cfif len(attributes.cat)>
            	INNER JOIN ##TEMP_PRODUCT_CAT TPC ON TPC.PRODUCT_CATID = S.PRODUCT_CATID
            </cfif>
		WHERE
			PT.STOCK_ID = S.STOCK_ID
			<cfif (len(attributes.product_id_1) and len(attributes.product_name_1)) or (len(attributes.product_id_2) and len(attributes.product_name_2)) or (len(attributes.product_id_3) and len(attributes.product_name_3)) or (len(attributes.product_id_4) and len(attributes.product_name_4)) or (len(attributes.product_id_5) and len(attributes.product_name_5))> 
				AND
				(
					S.PRODUCT_ID IS NULL
					<cfif len(attributes.product_id_1) and len(attributes.product_name_1)>
						OR S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id_1#">
					</cfif>
					<cfif len(attributes.product_id_2) and len(attributes.product_name_2)>
						OR S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id_2#">
					</cfif>
					<cfif len(attributes.product_id_3) and len(attributes.product_name_3)>
						OR S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id_3#">
					</cfif>
					<cfif len(attributes.product_id_4) and len(attributes.product_name_4)>
						OR S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id_4#">
					</cfif>
					<cfif len(attributes.product_id_5) and len(attributes.product_name_5)>
						OR S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id_5#">
					</cfif>
				)
			</cfif>
            <cfif len(attributes.brand_id)>
            	AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
            </cfif>
	</cfquery>
    <cfquery name="get_product_trees_sub" dbtype="query">
    	SELECT DISTINCT 
        	STOCK_ID,
            PRODUCT_ID,
            PRODUCT_NAME,
            PROPERTY,
            IS_PROTOTYPE,
            PROCESS_STAGE,
            SPECT_MAIN_ID_1,
            SPECT_MAIN_ID_2,
            SPECT_MAIN_ID_3,
            SPECT_MAIN_ID_4,
           	SPECT_MAIN_ID_5
        FROM
        	get_product_trees
    </cfquery>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_PRODUCT_TREE') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_PRODUCT_TREE 
           END
    </cfquery>
    <cfquery name="crt_temp_product_tree" datasource="#dsn3#">
        CREATE TABLE ##TEMP_PRODUCT_TREE(
             PRODUCT_TREE_ID INT,
             SPECT_MAIN_ID INT,
             UPDATE_MESSAGE NVARCHAR(600)
        )    
    </cfquery>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_SPECT_MAIN_ROW') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_SPECT_MAIN_ROW 
           END
    </cfquery>
    <cfquery name="crt_temp_spect_main_row" datasource="#dsn3#">
        CREATE TABLE ##TEMP_SPECT_MAIN_ROW(
             SPECT_MAIN_ID INT
        )    
    </cfquery>
	<cfif attributes.pro_type eq 1><!--- ekleme ise --->
		<cfquery name="get_new_stock_info" datasource="#dsn3#">
			SELECT PRODUCT_UNIT_ID,PRODUCT_NAME,PRODUCT_ID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_stock_id#">
		</cfquery><!--- yeni urun bilgisi --->
		<cfoutput query="get_product_trees_sub">
			<cflock name="#createUUID()#" timeout="20">
				<cftransaction>
					<cfif len(attributes.operation_type) and len(attributes.operation_type_id)>
						<cfquery name="get_tree_info" dbtype="query">
							SELECT PRODUCT_TREE_ID,PROCESS_STAGE FROM get_product_trees WHERE OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
						</cfquery>
						<cfif get_tree_info.recordcount eq 0>
							<cfquery name="get_spect_main" datasource="#dsn3#">
								SELECT TOP 1 
                                	* 
                                FROM 
                                	SPECT_MAIN SM 
                                WHERE 
                                	SM.SPECT_STATUS = 1 AND 
                                    SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#"> AND 
                                    SM.SPECT_STATUS = 1 
                                    <cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                                        AND
                                        (
                                            SM.SPECT_MAIN_ID IS NULL
                                            <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                                OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                            </cfif> 
                                            <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                                OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                            </cfif> 
                                            <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                                OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                            </cfif>
                                            <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                                OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                            </cfif>
                                            <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                                OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                            </cfif>
                                        )
                                    </cfif>
                            	ORDER BY 
                                	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
							</cfquery>
							<cfquery name="get_tree_info" datasource="#dsn3#">
								SELECT RELATED_TREE_ID PRODUCT_TREE_ID FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main.SPECT_MAIN_ID#"> AND OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
							</cfquery>
						</cfif>
					</cfif>
					<cfif len(attributes.operation_type) and len(attributes.operation_type_id) and get_tree_info.recordcount or not(len(attributes.operation_type) and len(attributes.operation_type_id))>
						<cfquery name="get_spect_main_new" datasource="#dsn3#">
							SELECT TOP 1 
                            	* 
                            FROM 
                            	SPECT_MAIN SM 
                            WHERE 
                            	SM.SPECT_STATUS = 1 AND 
                                SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_stock_id#">
								<cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                                    AND
                                    (
                                        SM.SPECT_MAIN_ID IS NULL
                                        <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                        </cfif> 
                                        <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                        </cfif> 
                                        <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                        </cfif>
                                        <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                        </cfif>
                                        <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                        </cfif>
                                    )
                                </cfif>
                            ORDER BY 
                            	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
						</cfquery>
						<cfquery name="ADD_TREE" datasource="#dsn3#" result="MAX_ID">
							INSERT INTO
								PRODUCT_TREE
							(
								<cfif len(attributes.operation_type) and len(attributes.operation_type_id)>
									RELATED_PRODUCT_TREE_ID,
								<cfelse>
									STOCK_ID,
								</cfif>
								PRODUCT_ID,
								RELATED_ID,
								AMOUNT,
								UNIT_ID,
								SPECT_MAIN_ID,
								IS_CONFIGURE,
								IS_SEVK,
								LINE_NUMBER,
								OPERATION_TYPE_ID,
								IS_PHANTOM,
								PROCESS_STAGE,
								QUESTION_ID
							)
							VALUES
							(
								<cfif len(attributes.operation_type) and len(attributes.operation_type_id)>
									#get_tree_info.PRODUCT_TREE_ID#,
								<cfelse>
									#get_product_trees_sub.stock_id#,
								</cfif>
								#get_new_stock_info.product_id#,
								#attributes.new_stock_id#,
								#attributes.miktar#,
								<cfif len(get_new_stock_info.product_unit_id)>#get_new_stock_info.product_unit_id#<cfelse>NULL</cfif>,
								<cfif get_spect_main_new.recordcount>#get_spect_main_new.spect_main_id#<cfelse>NULL</cfif>,
								0,
								0,
								0,
								0,
								NULL,
								#attributes.process_stage#,
								NULL
							)
						</cfquery>
                        <cfset attributes.stock_id = get_product_trees_sub.stock_id>
						<cfinclude template="../../production_plan/query/get_history_product_tree.cfm">
                        <cf_workcube_process is_upd='1' 
                            data_source='#dsn3#' 
                            old_process_line='0'
                            process_stage='#attributes.process_stage#' 
                            record_member='#session.ep.userid#' 
                            action_table='PRODUCT_TREE'
                            action_column='PRODUCT_TREE_ID'
                            record_date='#now()#' 
                            action_id='#MAX_ID.IDENTITYCOL#'
                            action_page='#request.self#?fuseaction=prod.manage_product_tree&id=#MAX_ID.IDENTITYCOL#' 
                            warning_description='Blok Takibi : #MAX_ID.IDENTITYCOL#'>
						<cfquery name="get_spect_main" datasource="#dsn3#">
							SELECT 
                            	* 
                            FROM 
                            	SPECT_MAIN SM 
                            WHERE  
                            	SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#"> AND 
                                SM.SPECT_STATUS = 1 
                                <cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                                    AND
                                    (
                                        SM.SPECT_MAIN_ID IS NULL
                                        <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                        </cfif> 
                                        <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                        </cfif> 
                                        <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                        </cfif>
                                        <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                        </cfif>
                                        <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                        </cfif>
                                    )
                                </cfif>
                            ORDER BY 
                            	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
						</cfquery>
                        <cfif get_spect_main.recordcount>
    						<cfquery name="ins_spect_main_row" datasource="#dsn3#">
        						<cfloop query="get_spect_main">
                                    INSERT INTO
                                        ##TEMP_SPECT_MAIN_ROW
                                        (
                                            SPECT_MAIN_ID
                                        )
                                    VALUES
                                        (
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main.SPECT_MAIN_ID#"> 
                                        )
        						</cfloop>
                            </cfquery>
                        </cfif>
						<cfloop query="get_spect_main">
							<cfquery name="ADD_ROW" datasource="#dsn3#">
								INSERT INTO
									SPECT_MAIN_ROW
									(
										SPECT_MAIN_ID,
										PRODUCT_ID,
										STOCK_ID,
										AMOUNT,
										PRODUCT_NAME,
										IS_PROPERTY,
										IS_CONFIGURE,
										IS_SEVK,
										PROPERTY_ID,
										VARIATION_ID,
										TOTAL_MIN,
										TOTAL_MAX,
										TOLERANCE,
										PRODUCT_SPACE,
										PRODUCT_DISPLAY,
										PRODUCT_RATE,
										PRODUCT_LIST_PRICE,
										CALCULATE_TYPE,
										RELATED_MAIN_SPECT_ID,
										RELATED_MAIN_SPECT_NAME,
										LINE_NUMBER,
										CONFIGURATOR_VARIATION_ID,
										DIMENSION,
										RELATED_TREE_ID,
										OPERATION_TYPE_ID,
										QUESTION_ID
									)
									VALUES
									(
										#get_spect_main.spect_main_id#,
										#get_new_stock_info.product_id#,
										#attributes.new_stock_id#,
										#attributes.miktar#,
										'#attributes.new_stock_name#',
										0,
										0,
										0,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										NULL,
										0,
										NULL,
										NULL,
										#MAX_ID.IDENTITYCOL#,
										NULL,
										NULL											
									)
							</cfquery>	
						</cfloop>
                        <cfquery name="INS_TEMP" datasource="#dsn3#">
                            INSERT INTO 
                                ##TEMP_PRODUCT_TREE
                                (
                                    PRODUCT_TREE_ID,
                                    SPECT_MAIN_ID,
                                    UPDATE_MESSAGE
                                )
                            VALUES
                                (
                                    #MAX_ID.IDENTITYCOL#,
                                    <cfif len(attributes.new_stock_id) and isdefined('get_spect_main_new.recordcount') and get_spect_main_new.recordcount>
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main_new.SPECT_MAIN_ID#">
                                    <cfelse>
                                        NULL
                                    </cfif>,
                                    <cfif isdefined('get_product_trees_sub.product_name') and len(get_new_stock_info.product_name)>
                                        '#get_product_trees_sub.product_name# adlı ürünün ağacına #get_new_stock_info.product_name# ürünü eklendi.'
                                    <cfelse>
                                        ''
                                    </cfif>
                                )
                        </cfquery>
                    </cfif>
                    <cfquery name="QAA" datasource="#DSN3#">
                        select * from ##TEMP_PRODUCT_TREE TPT
                    </cfquery>
                    <!--- <cfdump var="#QAA#"> --->
				</cftransaction>
			</cflock>
			<cfif isdefined('is_upd_prod_order') and is_upd_prod_order eq 1 and is_prototype eq 0><!--- xmlde üretim emirleri güncellensin evet seçili ise ve ürün özelleştirilebilir değilse buraya girer. hgul 20130306 --->
                <cfloop query="get_product_trees_sub">
                    <cfset attributes.stock_id = get_product_trees_sub.stock_id>
                    <cfinclude template="../../objects/query/upd_prod_order_stocks.cfm">
                </cfloop>
			</cfif>
		</cfoutput>
	<cfelseif attributes.pro_type eq 0><!--- çıkarma ise --->
		<cfquery name="get_old_stock_info" datasource="#dsn3#">
			SELECT * FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
		</cfquery>
		<cfoutput query="get_product_trees_sub">
			<cfif not (len(attributes.operation_type) and len(attributes.operation_type_id))>
				<cfquery name="get_new" dbtype="query">
					SELECT * FROM get_product_trees WHERE RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
				</cfquery>
			<cfelse>
				<cfset get_.recordcount = 0>
			</cfif>
			<cfset tree_id_list = ''>
			<cfquery name="get_1" datasource="#dsn3#">
				SELECT 
					* 
				FROM 
					PRODUCT_TREE 
				WHERE 
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#">
					AND OPERATION_TYPE_ID IS NOT NULL
					<cfif len(attributes.operation_type) and len(attributes.operation_type_id)>
						AND OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
					</cfif>
			</cfquery>
			<cfif get_1.recordcount eq 0 and len(attributes.operation_type) and len(attributes.operation_type_id)>
				<cfquery name="get_spect_main" datasource="#dsn3#">
					SELECT TOP 1 
                    	* 
                    FROM 
                    	SPECT_MAIN SM 
                    WHERE 
                    	SM.SPECT_STATUS = 1 AND 
                        SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#"> AND 
                        SM.SPECT_STATUS = 1 
						<cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                            AND
                            (
                                SM.SPECT_MAIN_ID IS NULL
                                <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                </cfif> 
                                <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                </cfif> 
                                <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                </cfif>
                                <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                </cfif>
                                <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                </cfif>
                            )
                        </cfif>
                    ORDER BY 
                    	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
				</cfquery>
				<cfquery name="get_1" datasource="#dsn3#">
					SELECT RELATED_TREE_ID PRODUCT_TREE_ID FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main.SPECT_MAIN_ID#"> AND OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
				</cfquery>
				<cfif get_spect_main.recordcount>
                    <cfquery name="ins_spect_main_row" datasource="#dsn3#">
                        <cfloop query="get_spect_main">
                            INSERT INTO
                                ##TEMP_SPECT_MAIN_ROW
                                (
                                    SPECT_MAIN_ID
                                )
                            VALUES
                                (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main.SPECT_MAIN_ID#"> 
                                )
                        </cfloop>
                    </cfquery>
                </cfif>
			</cfif>
			<cfif get_1.recordcount>
				<cfscript>
					writeTree(get_1.product_tree_id);
				</cfscript>
			</cfif>
			<cfif len(tree_id_list)>
				<cfquery name="get_" datasource="#dsn3#">
					SELECT * FROM PRODUCT_TREE WHERE PRODUCT_TREE_ID IN (#tree_id_list#) AND RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
				</cfquery>
			</cfif>
			<cfif (isdefined("get_") and get_.recordcount) or (isdefined("get_new") and get_new.recordcount)>
				<cflock name="#createUUID()#" timeout="20">
					<cftransaction>
						<cfif isdefined("get_new") and get_new.recordcount>
							<cfloop query="get_new">
								<cfquery name="del_product_tree" datasource="#dsn3#">
									DELETE FROM PRODUCT_TREE WHERE PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_new.PRODUCT_TREE_ID#">
								</cfquery>
							</cfloop>
                            <cfquery name="INS_TEMP" datasource="#dsn3#">
                                <cfloop query="get_new">
                                    INSERT INTO 
                                        ##TEMP_PRODUCT_TREE
                                        (
                                            PRODUCT_TREE_ID,
                                            SPECT_MAIN_ID,
                                            UPDATE_MESSAGE
                                        )
                                    VALUES
                                        (
                                            #get_new.PRODUCT_TREE_ID#,
                                            <cfif len(attributes.new_stock_id) and isdefined('get_spect_main_new.recordcount') and get_spect_main_new.recordcount>
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main_new.SPECT_MAIN_ID#">
                                            <cfelse>
                                                NULL
                                            </cfif>,
                                            <cfif isdefined('get_product_trees_sub.product_name') and len(get_old_stock_info.product_name)>
                                                '#get_product_trees_sub.product_name# adlı ürünün ağacına #get_old_stock_info.product_name# ürünü çıkarıldı.'
                                            <cfelse>
                                                ''
                                            </cfif>
                                        )
                                </cfloop>
                            </cfquery>
						</cfif>
						<cfif isdefined("get_") and get_.recordcount>
							<cfloop query="get_">
								<cfquery name="del_product_tree" datasource="#dsn3#">
									DELETE FROM PRODUCT_TREE WHERE PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_.PRODUCT_TREE_ID#">
								</cfquery>
								<cfset message_ = message_ & "<li>#get_product_trees_sub.product_name# adlı ürünün ağacından #get_old_stock_info.product_name# ürünü çıkarıldı.</li><br/>">
							</cfloop>
                            <cfquery name="INS_TEMP" datasource="#dsn3#">
                                <cfloop query="get_">
                                    INSERT INTO 
                                        ##TEMP_PRODUCT_TREE
                                        (
                                            PRODUCT_TREE_ID,
                                            SPECT_MAIN_ID,
                                            UPDATE_MESSAGE
                                        )
                                    VALUES
                                        (
                                            #get_.PRODUCT_TREE_ID#,
                                            <cfif len(attributes.new_stock_id) and isdefined('get_spect_main_new.recordcount') and get_spect_main_new.recordcount>
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main_new.SPECT_MAIN_ID#">
                                            <cfelse>
                                                NULL
                                            </cfif>,
                                            <cfif isdefined('get_product_trees_sub.product_name') and len(get_old_stock_info.product_name)>
                                                '#get_product_trees_sub.product_name# adlı ürünün ağacına #get_old_stock_info.product_name# ürünü çıkarıldı.'
                                            <cfelse>
                                                ''
                                            </cfif>
                                        )
                                </cfloop>
                            </cfquery>
						</cfif>
						<cfquery name="get_spect_main" datasource="#dsn3#">
							SELECT 
                            	* 
                            FROM 
                            	SPECT_MAIN SM 
                            WHERE 
                            	SM.SPECT_STATUS = 1 AND 
                                SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#">
                                <cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                                    AND
                                    (
                                        SM.SPECT_MAIN_ID IS NULL
                                        <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                        </cfif> 
                                        <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                        </cfif> 
                                        <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                        </cfif>
                                        <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                        </cfif>
                                        <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                            OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                        </cfif>
                                    )
                                </cfif>
                            ORDER BY 
                            	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
						</cfquery>
						<cfif get_spect_main.recordcount>
							<cfquery name="del_spect_main_row" datasource="#dsn3#">
								DELETE FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID IN(#valuelist(get_spect_main.SPECT_MAIN_ID)#) AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
							</cfquery>
						</cfif>
                        
					</cftransaction>
				</cflock>
			</cfif>
			<cfif isdefined('is_upd_prod_order') and is_upd_prod_order eq 1 and is_prototype eq 0><!--- xmlde üretim emirleri güncellensin evet seçili ise ve ürün özelleştirilebilir değilse buraya girer. hgul 20130306 --->
				<cfloop query="get_product_trees_sub">
                    <cfset attributes.stock_id = get_product_trees_sub.stock_id>
                    <cfinclude template="../../objects/query/upd_prod_order_stocks.cfm">
                </cfloop>
			</cfif>
		</cfoutput>
	<cfelseif attributes.pro_type eq 2><!--- değiştirme ise --->
        <cfif len(attributes.new_stock_id)>
            <cfquery name="get_new_stock_info" datasource="#dsn3#">
                SELECT PRODUCT_ID,PRODUCT_NAME,PRODUCT_UNIT_ID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_stock_id#">
            </cfquery><!--- yeni urun bilgisi --->
        <cfelse>
            <cfset get_new_stock_info.recordcount = 0>
        </cfif>
        <cfif len(attributes.old_stock_id)>
            <cfset get_old_stock_info.product_name = attributes.old_stock_name>
        <cfelse>
            <cfset get_old_stock_info.recordcount = 0>
        </cfif><!--- degistirilecek urun --->
        <cfoutput query="get_product_trees_sub">
            <cfif len(attributes.new_stock_id)><!--- yeni urun son spec bilgisi --->
                <cfquery name="get_spect_main_new" datasource="#dsn3#">
                    SELECT TOP 1 
                        SPECT_MAIN_ID 
                    FROM 
                        SPECT_MAIN SM 
                    WHERE 
                        SM.SPECT_STATUS = 1 AND
                        SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_stock_id#"> 
                        <cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                            AND
                            (
                                SM.SPECT_MAIN_ID IS NULL
                                <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                </cfif> 
                                <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                </cfif> 
                                <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                </cfif>
                                <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                </cfif>
                                <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                </cfif>
                            )
                        </cfif>
                    ORDER BY 
                        SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
                </cfquery>
            </cfif>

            <cfquery name="get_stock_tree_by_stock" datasource="#dsn3#">
                SELECT 
                    PRODUCT_TREE.PRODUCT_TREE_ID,
                    PRODUCT_TREE.OPERATION_TYPE_ID,
                    PRODUCT_TREE.QUESTION_ID,
                    PRODUCT_TREE.RELATED_ID,
                    STOCKS.PRODUCT_NAME
                FROM 
                    PRODUCT_TREE
                        LEFT JOIN STOCKS ON  STOCKS.STOCK_ID = PRODUCT_TREE.RELATED_ID 
                WHERE
                    PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#">
            </cfquery>
			<cfif not (len(attributes.operation_type) and len(attributes.operation_type_id))>
				<cfquery name="get_new" dbtype="query">
					SELECT 
                    	PRODUCT_TREE_ID,
                        PRODUCT_NAME
                    FROM 
                    	get_stock_tree_by_stock
                    WHERE 
                        1=1
                        <cfif len(attributes.old_stock_id)>
                           AND RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
                        </cfif>
				</cfquery><!--- urun agacindaki degistirilecek urunler --->
			</cfif>
			<cfset tree_id_list = ''>
			<cfquery name="get_1" dbtype="query">
				SELECT 
					PRODUCT_TREE_ID 
				FROM 
					get_stock_tree_by_stock 
				WHERE 
					OPERATION_TYPE_ID IS NOT NULL AND OPERATION_TYPE_ID <> 0
					<cfif len(attributes.operation_type) and len(attributes.operation_type_id)>
						AND OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
					</cfif>
			</cfquery>
			<cfif get_1.recordcount eq 0 and len(attributes.operation_type) and len(attributes.operation_type_id)>
				<cfquery name="get_spect_main" datasource="#dsn3#">
					SELECT TOP 1 
                    	SPECT_MAIN_ID 
                    FROM 
                    	SPECT_MAIN SM 
                    WHERE 
                    	SM.SPECT_STATUS = 1 AND 
                        SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#">
                        <cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                            AND
                            (
                                SM.SPECT_MAIN_ID IS NULL
                                <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                </cfif> 
                                <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                </cfif> 
                                <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                </cfif>
                                <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                </cfif>
                                <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                </cfif>
                            )
                        </cfif>
                    ORDER BY 
                    	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
				</cfquery>
				<cfif len(get_spect_main.SPECT_MAIN_ID)>
					<cfquery name="get_1" datasource="#dsn3#">
						SELECT RELATED_TREE_ID PRODUCT_TREE_ID FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main.SPECT_MAIN_ID#"> AND OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("get_1") and get_1.recordcount>
				<cfscript>
					writeTree(get_1.product_tree_id);
				</cfscript>
			</cfif>
			<cfif len(tree_id_list)>
				<cfquery name="get_" datasource="#dsn3#">
					SELECT 
                    	STOCKS.PRODUCT_NAME,
                        PRODUCT_TREE.PRODUCT_TREE_ID
                    FROM 
                    	PRODUCT_TREE
                            LEFT JOIN STOCKS ON STOCKS.STOCK_ID = PRODUCT_TREE.RELATED_ID
					WHERE 
                    	PRODUCT_TREE_ID IN (#tree_id_list#)
                        <cfif len(attributes.old_stock_id)>
                        	AND RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
                        </cfif>
                        <cfif isdefined('attributes.question_id') and len(attributes.question_id)>
                           AND PRODUCT_TREE.QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
                        </cfif>
				</cfquery>
                <!--- <cfdump var="#get_#" label="get_"> --->
			</cfif>
			<cfif (isdefined("get_") and get_.recordcount) or (isdefined("get_new") and get_new.recordcount)>
				<cfquery name="get_spect_main" datasource="#dsn3#">
					SELECT 
                    	SPECT_MAIN_ID
                    FROM 
                    	SPECT_MAIN SM 
                    WHERE 
                    	SM.SPECT_STATUS = 1 AND 
                        SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.stock_id#">
                        <cfif len(get_product_trees_sub.SPECT_MAIN_ID_1) or len(get_product_trees_sub.SPECT_MAIN_ID_2) or len(get_product_trees_sub.SPECT_MAIN_ID_3) or len(get_product_trees_sub.SPECT_MAIN_ID_4) or len(get_product_trees_sub.SPECT_MAIN_ID_5)> 
                            AND
                            (
                                SM.SPECT_MAIN_ID IS NULL
                                <cfif len(attributes.product_id_1) and len(attributes.product_name_1) and (get_product_trees_sub.product_id eq attributes.product_id_1) and len(get_product_trees_sub.SPECT_MAIN_ID_1)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_1#">
                                </cfif> 
                                <cfif len(attributes.product_id_2) and len(attributes.product_name_2) and (get_product_trees_sub.product_id eq attributes.product_id_2) and len(get_product_trees_sub.SPECT_MAIN_ID_2)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_2#">
                                </cfif> 
                                <cfif len(attributes.product_id_3) and len(attributes.product_name_3) and (get_product_trees_sub.product_id eq attributes.product_id_3) and len(get_product_trees_sub.SPECT_MAIN_ID_3)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_3#">
                                </cfif>
                                <cfif len(attributes.product_id_4) and len(attributes.product_name_4) and (get_product_trees_sub.product_id eq attributes.product_id_4) and len(get_product_trees_sub.SPECT_MAIN_ID_4)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_4#">
                                </cfif>
                                <cfif len(attributes.product_id_5) and len(attributes.product_name_5) and (get_product_trees_sub.product_id eq attributes.product_id_5) and len(get_product_trees_sub.SPECT_MAIN_ID_5)>
                                    OR SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_trees_sub.SPECT_MAIN_ID_5#">
                                </cfif>
                            )
                        </cfif>
                    ORDER BY 
                    	SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
				</cfquery>
                <cflock name="#createUUID()#" timeout="20">
                    <cftransaction>
                        <cfif get_spect_main.recordcount>
    						<cfquery name="ins_spect_main_row" datasource="#dsn3#">
        						<cfloop query="get_spect_main">
                                    INSERT INTO
                                        ##TEMP_SPECT_MAIN_ROW
                                        (
                                            SPECT_MAIN_ID
                                        )
                                    VALUES
                                        (
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main.SPECT_MAIN_ID#"> 
                                        )
        						</cfloop>
                            </cfquery>
                        </cfif>
                    </cftransaction>
                </cflock>
				<cfif isdefined("get_new") and get_new.recordcount>
                    <cflock name="#createUUID()#" timeout="20">
                        <cftransaction>
                            <cfquery name="INS_TEMP" datasource="#dsn3#">
                                <cfloop query="get_new">
                                    INSERT INTO 
                                        ##TEMP_PRODUCT_TREE
                                        (
                                            PRODUCT_TREE_ID,
                                            SPECT_MAIN_ID,
                                            UPDATE_MESSAGE
                                        )
                                    VALUES
                                        (
                                            #get_new.PRODUCT_TREE_ID#,
                                            <cfif len(attributes.new_stock_id) and isdefined('get_spect_main_new.recordcount') and get_spect_main_new.recordcount>
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main_new.SPECT_MAIN_ID#">
                                            <cfelse>
                                                NULL
                                            </cfif>,
                                            <cfif isdefined('get_old_stock_info.product_name') and len(get_old_stock_info.product_name)>
                                                '#get_product_trees_sub.product_name# adlı ürünün ağacında #get_old_stock_info.product_name# ürünü #get_new_stock_info.product_name# ile değiştirildi.'
                                            <cfelseif len(attributes.question_id) and attributes.question_id eq question_id>
                                                '#get_new.product_name# adlı ürünün ağacında miktarlar değiştirildi.'
                                            <cfelse>
                                                ''
                                            </cfif>
                                        )
                                </cfloop>
                            </cfquery>
                        </cftransaction>
                    </cflock>
				</cfif>
				<cfif isdefined("get_") and get_.recordcount>
                    <cflock name="#createUUID()#" timeout="20">
                        <cftransaction>
                            <cfquery name="INS_TEMP" datasource="#dsn3#">
                                <cfloop query="get_">
                                INSERT INTO 
                                    ##TEMP_PRODUCT_TREE
                                    (
                                        PRODUCT_TREE_ID,
                                        SPECT_MAIN_ID,
                                        UPDATE_MESSAGE
                                    )
                                VALUES
                                    (
                                        #get_.PRODUCT_TREE_ID#,
                                        <cfif len(attributes.new_stock_id) and isdefined('get_spect_main_new.recordcount') and get_spect_main_new.recordcount>
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spect_main_new.SPECT_MAIN_ID#">
                                        <cfelse>
                                            NULL
                                        </cfif>,
                                        <cfif isdefined('get_old_stock_info.product_name') and len(get_old_stock_info.product_name)>
                                            '#get_product_trees_sub.product_name# adlı ürünün ağacında #get_old_stock_info.product_name# ürünü #get_new_stock_info.product_name# ile değiştirildi.'
                                        <cfelseif len(attributes.question_id) and attributes.question_id eq question_id>
                                            '#get_.product_name# adlı ürünün ağacında miktarlar değiştirildi.'
                                        <cfelse>
                                        	''
                                        </cfif>
                                    )
                                </cfloop>
                            </cfquery>
                        </cftransaction>
                    </cflock>
				</cfif>
			</cfif>
			<cfif isdefined('is_upd_prod_order') and is_upd_prod_order eq 1 and is_prototype eq 0><!--- xmlde üretim emirleri güncellensin evet seçili ise ve ürün özelleştirilebilir değilse buraya girer. hgul 20130306 --->
				<cfloop query="get_product_trees_sub">
                    <cfset attributes.stock_id = get_product_trees_sub.stock_id>
                    <cfinclude template="../../objects/query/upd_prod_order_stocks.cfm">
                </cfloop>
			</cfif>
		</cfoutput>
        <cflock name="#createUUID()#" timeout="20">
            <cftransaction>
                <cfquery name="upd_spect_main_row" datasource="#dsn3#"><!--- spectler güncelleniyor --->
                    UPDATE
                        SPECT_MAIN_ROW
                    SET
                        <cfif len(attributes.new_stock_id)>
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_stock_id#">,
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_new_stock_info.product_id#">,
                            PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_new_stock_info.product_name#">
                        </cfif>
                        <cfif attributes.is_upd_amount eq 1>
                            <cfif len(attributes.new_stock_id)>,</cfif>
                            <cfif attributes.upd_amount_type eq 0>
                                AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.miktar#">
                            <cfelseif attributes.upd_amount_type eq 1>
                                AMOUNT = AMOUNT+(AMOUNT*#attributes.miktar#/100)
                            <cfelse>
                                AMOUNT = AMOUNT-(AMOUNT*#attributes.miktar#/100)
                            </cfif>
                        </cfif>
                    FROM 
                        SPECT_MAIN_ROW,
                        ##TEMP_SPECT_MAIN_ROW TEMP_SPECT_MAIN_ROW
                    WHERE 
                        SPECT_MAIN_ROW.SPECT_MAIN_ID = TEMP_SPECT_MAIN_ROW.SPECT_MAIN_ID
                        <cfif len(attributes.old_stock_id)>
                            AND SPECT_MAIN_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_stock_id#">
                        </cfif>
                        <cfif isdefined('attributes.question_id') and len(attributes.question_id)>
                            AND SPECT_MAIN_ROW.QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
                        </cfif>
                </cfquery>
                <cfquery name="upd_product_tree" datasource="#dsn3#" result="AAAA">
                    UPDATE
                        PRODUCT_TREE
                    SET
                        <cfif len(attributes.new_stock_id)>
                            RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_stock_id#">,
                            UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_new_stock_info.product_unit_id#">,
                        </cfif>
                        <cfif attributes.is_upd_amount eq 1>
                            <cfif attributes.upd_amount_type eq 0>
                                AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.miktar#">,
                            <cfelseif attributes.upd_amount_type eq 1>
                                AMOUNT = AMOUNT+(AMOUNT*#attributes.miktar#/100),
                            <cfelse>
                                AMOUNT = AMOUNT-(AMOUNT*#attributes.miktar#/100),
                            </cfif>
                        </cfif>
                        PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
                        SPECT_MAIN_ID = TPT.SPECT_MAIN_ID                
                    FROM
                        PRODUCT_TREE,
                        ##TEMP_PRODUCT_TREE TPT
                    WHERE 
                        PRODUCT_TREE.PRODUCT_TREE_ID = TPT.PRODUCT_TREE_ID
                        
                </cfquery>
                <cfquery name="QAA" datasource="#DSN3#">
                    select * from ##TEMP_PRODUCT_TREE TPT
                </cfquery>
                <!--- <cfdump var="#QAA#"> --->
            </cftransaction>
        </cflock>
	</cfif>
	<br/>
	<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
		<tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
			<td>
                <cfif not get_product_trees_sub.recordcount><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse>
                    <cfquery name="get_update_message" datasource="#dsn3#">
                        SELECT DISTINCT UPDATE_MESSAGE FROM ##TEMP_PRODUCT_TREE 
                    </cfquery>
                    <cfoutput query="get_update_message"><li>#UPDATE_MESSAGE#</li><br></cfoutput>
                </cfif>
            </td>
		</tr> 
	</table>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_PRODUCT_TREE') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_PRODUCT_TREE 
           END
    </cfquery>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_PRODUCT_TREE') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_SPECT_MAIN_ROW 
           END
    </cfquery>
</cfif>
<script type="text/javascript">
	function form_kontrol()
	{
		if(document.report_special.cat.value == '' && (document.report_special.product_id_1.value == '' && document.report_special.product_name_1.value == '')  && (document.report_special.product_id_2.value == '' && document.report_special.product_name_2.value == '')  && (document.report_special.product_id_3.value == '' && document.report_special.product_name_3.value == '')  && (document.report_special.product_id_4.value == '' && document.report_special.product_name_4.value == '')  && (document.report_special.product_id_5.value == '' && document.report_special.product_name_5.value == ''))
		{
			alert('<cf_get_lang dictionary_id="29401.Ürün Kategorisi"> <cf_get_lang dictionary_id="57998.veya"> <cf_get_lang dictionary_id="58227.Ürün Seçmelisiniz">!');
			return false;
		}
		if(document.report_special.pro_type[0].checked==true)//cikarma islemi
		{
			if(document.report_special.old_stock_id.value == '' || document.report_special.old_stock_name.value == '')//cikarilacak ürün secili olmali
			{
				alert('<cf_get_lang dictionary_id="58227.Ürün Seçmelisiniz">!');
				return false;
			}
		}
		else if(document.report_special.pro_type[1].checked==true)// ekleme islemi
		{
			if(document.report_special.new_stock_id.value == '' || document.report_special.new_stock_name.value == '')//eklenecek ürün secili olmali
			{
				alert('<cf_get_lang dictionary_id="58674.Yeni"> <cf_get_lang dictionary_id="58227.Ürün Seçmelisiniz">!');
				return false;
			}
			if(document.report_special.miktar.value=='')
			{
				alert('<cf_get_lang dictionary_id="36386.Miktar Girmelisiniz">!');
				return false;
			}
		}
		else if(document.report_special.pro_type[2].checked==true)// update islemi
		{
			if(document.report_special.report_type[1].checked==false)
			{
				document.report_special.question_id.value = '';
			}
			if(document.report_special.question_id.value == '')
			{
				if(document.report_special.new_stock_id.value == '' || document.report_special.new_stock_name.value == '')//eklenecek ürün secili olmali
				{
					alert('<cf_get_lang dictionary_id="58674.Yeni"> <cf_get_lang dictionary_id="58227.Ürün Seçmelisiniz">!');
					return false;
				}
				if(document.report_special.old_stock_id.value == '' || document.report_special.old_stock_name.value == '')//cikarilacak ürün secili olmali
				{
					alert('<cf_get_lang dictionary_id="58227.Ürün Seçmelisiniz">!');
					return false;
				}
			}
			else
			{
				if(document.report_special.is_upd_amount.checked == false)
				{
					alert("<cf_get_lang dictionary_id='36976.Miktarı Güncelleyi'> <cf_get_lang dictionary_id ='57734.Seçiniz!'>");
					return false;
				}
			}
			if(document.report_special.miktar.value=='')
			{
				alert('<cf_get_lang dictionary_id="36386.Miktar Girmelisiniz">!');
				return false;
			}
		}
		document.report_special.miktar.value = filterNum(document.report_special.miktar.value,8);
		return process_cat_control();
	}
	function product_control(crntrw)/*Ürün seçmeden spect seçemesin.*/
	{
		if(document.getElementById("product_id_"+crntrw).value=="" || document.getElementById("product_name_"+crntrw).value=="" )
		{
			alert("<cf_get_lang dictionary_id='36828.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>.");
			return false;
		}
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=report_special.spect_main_id_'+crntrw+'&field_name=report_special.spect_main_name_'+crntrw+'&is_display=1&product_id='+document.getElementById('product_id_'+crntrw).value+'');
	}
	function kontrol_type(type)
	{
		if(type == 2)
			amount_table.style.display = '';
		else
		{
			amount_table.style.display = 'none';
			amount_table2.style.display = 'none';
			document.report_special.is_upd_amount.checked = false;
		}
	}
	function kontrol_upd_type()
	{
		if(document.report_special.is_upd_amount.checked == true)
			amount_table2.style.display = '';
		else
			amount_table2.style.display = 'none';
	}

	if(document.report_special.report_type[0].checked) type_ = 0; else type_ = 1;
	report_type_control(type_);
	function report_type_control(type)
	{
		if(type == 1)
		{
			document.report_special.pro_type[0].disabled = true;
			document.report_special.pro_type[1].disabled = true;
			document.report_special.pro_type[2].checked = true;
			document.report_special.is_upd_amount.checked == true;
			amount_table.style.display = '';
			//question_id1.style.display = '';
			question_id2.style.display = '';
			if(document.report_special.is_upd_amount.checked == true)
				amount_table2.style.display = '';
			else
				amount_table2.style.display = 'none';
		}
		else
		{
			document.report_special.pro_type[0].disabled = false;
			document.report_special.pro_type[1].disabled = false;
			//question_id1.style.display = 'none';
			question_id2.style.display = 'none';
			if(document.report_special.is_upd_amount.checked == true)
				amount_table2.style.display = '';
			else
				amount_table2.style.display = 'none';
		}
	}
</script>
