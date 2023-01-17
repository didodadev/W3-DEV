<cfparam name="attributes.cat" default="">
<cfparam name="attributes.new_cat_id" default="">
<cfparam name="attributes.question_id" default="">
<cfparam name="attributes.pro_type" default="1">
<cfparam name="attributes.katsayi_1" default="">
<cfparam name="attributes.katsayi_2" default="">
<cfparam name="attributes.katsayi_3" default="">
<cfparam name="attributes.katsayi_4" default="">
<cfparam name="attributes.katsayi_5" default="">
<cfparam name="attributes.katsayi_6" default="">
<cfparam name="attributes.katsayi_7" default="">
<cfparam name="attributes.katsayi_8" default="">
<cfparam name="attributes.katsayi_9" default="">
<cfparam name="attributes.katsayi_10" default="">
<cfparam name="attributes.question_stock_name_1" default="">
<cfparam name="attributes.question_product_id_1" default="">
<cfparam name="attributes.question_stock_id_1" default="">
<cfparam name="attributes.question_stock_name_2" default="">
<cfparam name="attributes.question_product_id_2" default="">
<cfparam name="attributes.question_stock_id_2" default="">
<cfparam name="attributes.question_stock_name_3" default="">
<cfparam name="attributes.question_product_id_3" default="">
<cfparam name="attributes.question_stock_id_3" default="">
<cfparam name="attributes.question_stock_name_4" default="">
<cfparam name="attributes.question_product_id_4" default="">
<cfparam name="attributes.question_stock_id_4" default="">
<cfparam name="attributes.question_stock_name_5" default="">
<cfparam name="attributes.question_product_id_5" default="">
<cfparam name="attributes.question_stock_id_5" default="">
<cfparam name="attributes.question_stock_name_6" default="">
<cfparam name="attributes.question_product_id_6" default="">
<cfparam name="attributes.question_stock_id_6" default="">
<cfparam name="attributes.question_stock_name_7" default="">
<cfparam name="attributes.question_product_id_7" default="">
<cfparam name="attributes.question_stock_id_7" default="">
<cfparam name="attributes.question_stock_name_8" default="">
<cfparam name="attributes.question_product_id_8" default="">
<cfparam name="attributes.question_stock_id_8" default="">
<cfparam name="attributes.question_stock_name_9" default="">
<cfparam name="attributes.question_product_id_9" default="">
<cfparam name="attributes.question_stock_id_9" default="">
<cfparam name="attributes.question_stock_name_10" default="">
<cfparam name="attributes.question_product_id_10" default="">
<cfparam name="attributes.question_stock_id_10" default="">
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
<cfparam name="attributes.product_id_6" default="">
<cfparam name="attributes.product_name_6" default="">
<cfparam name="attributes.product_id_7" default="">
<cfparam name="attributes.product_name_7" default="">
<cfparam name="attributes.product_id_8" default="">
<cfparam name="attributes.product_name_8" default="">
<cfparam name="attributes.product_id_9" default="">
<cfparam name="attributes.product_name_9" default="">
<cfparam name="attributes.product_id_10" default="">
<cfparam name="attributes.product_name_10" default="">
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
		PCO.OUR_COMPANY_ID = #session.ep.company_id# 
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="get_questions" datasource="#dsn#">
	SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS ORDER BY QUESTION_NAME
</cfquery>
<cfset question_id_list = valuelist(get_questions.question_id)>
<cfset question_name_list = valuelist(get_questions.question_name)>
<cfset message_ = ''>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Alternatif Hammadde Yönetim Ekranı',34297)#">
		<cfform name="report_special" enctype="multipart/form-data" method="post" action="">
			<input type="hidden" value="1" name="is_submit" id="is_submit">
			<cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-get_product_cat">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="cat" id="cat" multiple="multiple">
								<cfoutput query="get_product_cat">
									<cfif listlen(HIERARCHY,".") lte 6>
										<option value="#product_catid#" <cfif listfind(attributes.cat,product_catid)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
									</cfif>
								</cfoutput>
							</select>
                        </div>
                    </div>
					<div class="form-group" id="item-question_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36454.Alternatif Sorusu'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="question_id" id="question_id" multiple="multiple">
								<cfoutput query="get_questions">
									<option value="#question_id#" <cfif listfind(attributes.question_id,question_id)>selected</cfif>>#question_name#</option>
								</cfoutput>
							</select>
                        </div>
                    </div>
					<div class="form-group" id="item-new_cat_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'> 2</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="new_cat_id" id="new_cat_id" multiple="multiple">
								<cfoutput query="get_product_cat">
									<cfif listlen(HIERARCHY,".") lte 6>
										<option value="#product_catid#" <cfif listfind(attributes.new_cat_id,product_catid)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
									</cfif>
								</cfoutput>
							</select>
                        </div>
                    </div>
					<div class="form-group" id="item-pro_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'></label>
                        <div class="col col-4 col-xs-12">
                            <label><input type="radio" name="pro_type" id="pro_type" value="1" <cfif attributes.pro_type eq 1>checked</cfif>> <cf_get_lang dictionary_id="57582.Ekle"></label>
						</div>
						<div class="col col-4 col-xs-12">
							<label><input type="radio" name="pro_type" id="pro_type" value="0" <cfif attributes.pro_type eq 0>checked</cfif>> <cf_get_lang dictionary_id="36974.Çıkar"></label>
                        </div>
                    </div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-product_id_1">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 1</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_1" id="product_id_1" value="<cfoutput>#attributes.product_id_1#</cfoutput>">
								<cfinput type="text" name="product_name_1" id="product_name_1" value="#attributes.product_name_1#" onFocus="AutoComplete_Create('product_name_1','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_1','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_1&field_name=report_special.product_name_1');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_2">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 2</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_2" id="product_id_2" value="<cfoutput>#attributes.product_id_2#</cfoutput>">
								<cfinput type="text" name="product_name_2" id="product_name_2" value="#attributes.product_name_2#" onFocus="AutoComplete_Create('product_name_2','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_2','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_2&field_name=report_special.product_name_2');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_3">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 3</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_3" id="product_id_3" value="<cfoutput>#attributes.product_id_3#</cfoutput>">
								<cfinput type="text" name="product_name_3" id="product_name_3" value="#attributes.product_name_3#" onFocus="AutoComplete_Create('product_name_3','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_3','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_3&field_name=report_special.product_name_3');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_4">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 4</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_4" id="product_id_4" value="<cfoutput>#attributes.product_id_4#</cfoutput>">
								<cfinput type="text" name="product_name_4" id="product_name_4" value="#attributes.product_name_4#" onFocus="AutoComplete_Create('product_name_4','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_4','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_4&field_name=report_special.product_name_4');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_5">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 5</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_5" id="product_id_5" value="<cfoutput>#attributes.product_id_5#</cfoutput>">
								<cfinput type="text" name="product_name_5" id="product_name_5" value="#attributes.product_name_5#" onFocus="AutoComplete_Create('product_name_5','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_5','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_5&field_name=report_special.product_name_5');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_6">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 6</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_6" id="product_id_6" value="<cfoutput>#attributes.product_id_6#</cfoutput>">
								<cfinput type="text" name="product_name_6" id="product_name_6" value="#attributes.product_name_6#" onFocus="AutoComplete_Create('product_name_6','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_6','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_6&field_name=report_special.product_name_6');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_7">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 7</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_7" id="product_id_7" value="<cfoutput>#attributes.product_id_7#</cfoutput>">
								<cfinput type="text" name="product_name_7" id="product_name_7" value="#attributes.product_name_7#" onFocus="AutoComplete_Create('product_name_7','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_7','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_7&field_name=report_special.product_name_7');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_8">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 8</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_8" id="product_id_8" value="<cfoutput>#attributes.product_id_8#</cfoutput>">
								<cfinput type="text" name="product_name_8" id="product_name_8" value="#attributes.product_name_8#" onFocus="AutoComplete_Create('product_name_8','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_8','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_8&field_name=report_special.product_name_8');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_9">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 9</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_9" id="product_id_9" value="<cfoutput>#attributes.product_id_9#</cfoutput>">
								<cfinput type="text" name="product_name_9" id="product_name_9" value="#attributes.product_name_9#" onFocus="AutoComplete_Create('product_name_9','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_9','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_9&field_name=report_special.product_name_9');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-product_id_10">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> 10</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id_10" id="product_id_10" value="<cfoutput>#attributes.product_id_10#</cfoutput>">
								<cfinput type="text" name="product_name_10" id="product_name_10" value="#attributes.product_name_10#" onFocus="AutoComplete_Create('product_name_10','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id_10','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=report_special.product_id_10&field_name=report_special.product_name_10');"></span>
							</div>
                        </div>
                    </div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-question_stock_id_1">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 1</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_1" id="question_stock_id_1" value="<cfoutput>#attributes.question_stock_id_1#</cfoutput>">
								<input type="hidden" name="question_product_id_1" id="question_product_id_1" value="<cfoutput>#attributes.question_product_id_1#</cfoutput>">
								<cfinput type="text" name="question_stock_name_1" id="question_stock_name_1" value="#attributes.question_stock_name_1#" onFocus="AutoComplete_Create('question_stock_name_1','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_1,question_product_id_1','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_1&product_id=report_special.question_product_id_1&field_name=report_special.question_stock_name_1');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_2">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 2</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_2" id="question_stock_id_2" value="<cfoutput>#attributes.question_stock_id_2#</cfoutput>">
								<input type="hidden" name="question_product_id_2" id="question_product_id_2" value="<cfoutput>#attributes.question_product_id_2#</cfoutput>">
								<cfinput type="text" name="question_stock_name_2" id="question_stock_name_2" value="#attributes.question_stock_name_2#" onFocus="AutoComplete_Create('question_stock_name_2','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_2,question_product_id_2','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_2&product_id=report_special.question_product_id_2&field_name=report_special.question_stock_name_2');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_3">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 3</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_3" id="question_stock_id_3" value="<cfoutput>#attributes.question_stock_id_3#</cfoutput>">
								<input type="hidden" name="question_product_id_3" id="question_product_id_3" value="<cfoutput>#attributes.question_product_id_3#</cfoutput>">
								<cfinput type="text" name="question_stock_name_3" id="question_stock_name_3" value="#attributes.question_stock_name_3#" onFocus="AutoComplete_Create('question_stock_name_3','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_3,question_product_id_3','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_3&product_id=report_special.question_product_id_3&field_name=report_special.question_stock_name_3');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_4">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 4</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_4" id="question_stock_id_4" value="<cfoutput>#attributes.question_stock_id_4#</cfoutput>">
								<input type="hidden" name="question_product_id_4" id="question_product_id_4" value="<cfoutput>#attributes.question_product_id_4#</cfoutput>">
								<cfinput type="text" name="question_stock_name_4" id="question_stock_name_4" value="#attributes.question_stock_name_4#" onFocus="AutoComplete_Create('question_stock_name_4','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_4,question_product_id_4','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_4&product_id=report_special.question_product_id_4&field_name=report_special.question_stock_name_4');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_5">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 5</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_5" id="question_stock_id_5" value="<cfoutput>#attributes.question_stock_id_5#</cfoutput>">
								<input type="hidden" name="question_product_id_5" id="question_product_id_5" value="<cfoutput>#attributes.question_product_id_5#</cfoutput>">
								<cfinput type="text" name="question_stock_name_5" id="question_stock_name_5" value="#attributes.question_stock_name_5#" onFocus="AutoComplete_Create('question_stock_name_5','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_5,question_product_id_5','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_5&product_id=report_special.question_product_id_5&field_name=report_special.question_stock_name_5');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_6">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 6</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_6" id="question_stock_id_6" value="<cfoutput>#attributes.question_stock_id_6#</cfoutput>">
								<input type="hidden" name="question_product_id_6" id="question_product_id_6" value="<cfoutput>#attributes.question_product_id_6#</cfoutput>">
								<cfinput type="text" name="question_stock_name_6" id="question_stock_name_6" value="#attributes.question_stock_name_6#" onFocus="AutoComplete_Create('question_stock_name_6','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_6,question_product_id_6','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_6&product_id=report_special.question_product_id_6&field_name=report_special.question_stock_name_6');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_7">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 7</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_7" id="question_stock_id_7" value="<cfoutput>#attributes.question_stock_id_7#</cfoutput>">
								<input type="hidden" name="question_product_id_7" id="question_product_id_7" value="<cfoutput>#attributes.question_product_id_7#</cfoutput>">
								<cfinput type="text" name="question_stock_name_7" id="question_stock_name_7" value="#attributes.question_stock_name_7#" onFocus="AutoComplete_Create('question_stock_name_7','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_7,question_product_id_7','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_7&product_id=report_special.question_product_id_7&field_name=report_special.question_stock_name_7');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_8">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 8</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_8" id="question_stock_id_8" value="<cfoutput>#attributes.question_stock_id_8#</cfoutput>">
								<input type="hidden" name="question_product_id_8" id="question_product_id_8" value="<cfoutput>#attributes.question_product_id_8#</cfoutput>">
								<cfinput type="text" name="question_stock_name_8" id="question_stock_name_8" value="#attributes.question_stock_name_8#" onFocus="AutoComplete_Create('question_stock_name_8','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_8,question_product_id_8','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_8&product_id=report_special.question_product_id_8&field_name=report_special.question_stock_name_8');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id_9">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 9</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id_9" id="question_stock_id_9" value="<cfoutput>#attributes.question_stock_id_9#</cfoutput>">
								<input type="hidden" name="question_product_id_9" id="question_product_id_9" value="<cfoutput>#attributes.question_product_id_9#</cfoutput>">
								<cfinput type="text" name="question_stock_name_9" id="question_stock_name_9" value="#attributes.question_stock_name_9#" onFocus="AutoComplete_Create('question_stock_name_9','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_9,question_product_id_9','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_9&product_id=report_special.question_product_id_9&field_name=report_special.question_stock_name_9');"></span>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-question_stock_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36445.Hammadde'> 10</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="question_stock_id" id="question_stock_id_10" value="<cfoutput>#attributes.question_stock_id_10#</cfoutput>">
								<input type="hidden" name="question_product_id" id="question_product_id_10" value="<cfoutput>#attributes.question_product_id_10#</cfoutput>">
								<cfinput type="text" name="question_stock_name" id="question_stock_name_10" value="#attributes.question_stock_name_10#" onFocus="AutoComplete_Create('question_stock_name_10','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','question_stock_id_10,question_product_id_10','','3','225');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.question_stock_id_10&product_id=report_special.question_product_id_10&field_name=report_special.question_stock_name_10');"></span>		
							</div>
                        </div>
                    </div>
				</div>
				<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-katsayi_1">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 1 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_1" id="katsayi_1" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_1,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_2">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 2 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_2" id="katsayi_2" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_2,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_3">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 3 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_3" id="katsayi_3" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_3,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_4">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 4 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_4" id="katsayi_4" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_4,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_5">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 5 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_5" id="katsayi_5" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_5,4)#</cfoutput>" style=" text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_6">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 6 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_6" id="katsayi_6" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_6,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_7">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 7 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_7" id="katsayi_7" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_7,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_8">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 8 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_8" id="katsayi_8" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_8,4)#</cfoutput>" style=" text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_9">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 9 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_9" id="katsayi_9" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_9,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
					<div class="form-group" id="item-katsayi_10">
                        <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36455.Katsayı"> 10 %</label>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<input name="katsayi_10" id="katsayi_10" onkeyup="return(FormatCurrency(this,event,4));" type="text" value="<cfoutput>#TLFormat(attributes.katsayi_10,4)#</cfoutput>" style="text-align:right;">
                        </div>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
	
<cfif isdefined("attributes.is_submit")>
	<cfscript>
		deep_level = 0;
		function get_subs(spect_main_id,next_stock_id,type)
		{										
			if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
			SQLStr = "
					SELECT
						PRODUCT_TREE_ID RELATED_ID,
						ISNULL(PT.STOCK_ID,0) STOCK_ID,
						ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ROW_ID,
						ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
						ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
						ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
					FROM 
						PRODUCT_TREE PT
					WHERE
						#where_parameter#
					ORDER BY
						LINE_NUMBER,
						STOCK_ID DESC
				";
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			stock_id_ary='';
			for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
			{
				stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ROW_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
			}
			return stock_id_ary;
		}
		function GetDeepLevelMaınStockId(_deeplevel){
			for (lind_ = _deeplevel;lind_ gt 0; lind_ = lind_-1){
				if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
					return Evaluate('_deep_level_main_stock_id_#lind_#');
			}
			return 1;
		}
		function writeTree(next_spect_main_id,next_stock_id,type,question_id,first_stock_id)
		{
			var i = 1;
			var sub_products = get_subs(next_spect_main_id,next_stock_id,type);
			deep_level = deep_level + 1;
			for (jj=1; jj lte listlen(sub_products,'█'); jj = jj+1)
			{
				_next_stock_id_ = ListGetAt(ListGetAt(sub_products,jj,'█'),2,'§');
				if(_next_stock_id_ gt 0) '_deep_level_main_stock_id_#deep_level#' = _next_stock_id_; else '_deep_level_main_stock_id_#deep_level#' = '-1';
			}
			for (i=1; i lte listlen(sub_products,'█'); i = i+1)
			{
				_next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
				_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
				_next_spect_main_row_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
				_next_question_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
				_next_product_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
				_n_operation_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
				_n_spec_main_id_= ListGetAt(ListGetAt(sub_products,i,'█'),7,'§');
				_n_stock_related_id_= ListGetAt(ListGetAt(sub_products,i,'█'),8,'§');
				if(_next_question_id_ gt 0 and _n_operation_id_ eq 0 and _next_question_id_ eq question_id and _n_stock_related_id_ gt 0)
				{
					
					if(isdefined("question_stock_list_#first_stock_id#_#question_id#"))
					{
						"question_stock_list_#first_stock_id#_#question_id#" = listappend(evaluate("question_stock_list_#first_stock_id#_#question_id#"),_n_stock_related_id_);
						"relation_stock_list_#first_stock_id#_#question_id#" = listappend(evaluate("relation_stock_list_#first_stock_id#_#question_id#"),GetDeepLevelMaınStockId(deep_level));
					}
					else
					{
						"question_stock_list_#first_stock_id#_#question_id#" = _n_stock_related_id_;
						"relation_stock_list_#first_stock_id#_#question_id#" = GetDeepLevelMaınStockId(deep_level);
					}
				}
				if(_n_operation_id_ gt 0) type_=3;else type_=0;
				writeTree(_next_spect_main_id_,_n_stock_related_id_,type_,question_id,first_stock_id);
			 }
			 deep_level = deep_level-1;
		}
	</cfscript>
	<cfquery name="get_product_trees" datasource="#dsn3#">
		SELECT DISTINCT 
			S.STOCK_ID,
			S.PRODUCT_ID,
			S.PRODUCT_NAME AS YAN_URUN
		FROM
			PRODUCT_TREE PT,
			STOCKS S
		WHERE
        	S.STOCK_STATUS = 1 AND
            S.PRODUCT_STATUS = 1 AND
			(PT.RELATED_ID = S.STOCK_ID OR PT.STOCK_ID = S.STOCK_ID)
			<cfif len(attributes.cat)>
				AND	S.PRODUCT_CATID IN (#attributes.cat#)
			</cfif>
			<cfif (len(attributes.product_id_1) and len(attributes.product_name_1)) or (len(attributes.product_id_2) and len(attributes.product_name_2)) or (len(attributes.product_id_3) and len(attributes.product_name_3)) or (len(attributes.product_id_4) and len(attributes.product_name_4)) or (len(attributes.product_id_5) and len(attributes.product_name_5)) or (len(attributes.product_id_6) and len(attributes.product_name_6)) or (len(attributes.product_id_7) and len(attributes.product_name_7)) or (len(attributes.product_id_8) and len(attributes.product_name_8)) or (len(attributes.product_id_9) and len(attributes.product_name_9)) or (len(attributes.product_id_10) and len(attributes.product_name_10))> 
			AND
				(S.PRODUCT_ID IS NULL
				<cfif len(attributes.product_id_1) and len(attributes.product_name_1)>
					OR S.PRODUCT_ID = #attributes.product_id_1#
				</cfif>
				<cfif len(attributes.product_id_2) and len(attributes.product_name_2)>
					OR S.PRODUCT_ID = #attributes.product_id_2#
				</cfif>
				<cfif len(attributes.product_id_3) and len(attributes.product_name_3)>
					OR S.PRODUCT_ID = #attributes.product_id_3#
				</cfif>
				<cfif len(attributes.product_id_4) and len(attributes.product_name_4)>
					OR S.PRODUCT_ID = #attributes.product_id_4#
				</cfif>
				<cfif len(attributes.product_id_5) and len(attributes.product_name_5)>
					OR S.PRODUCT_ID = #attributes.product_id_5#
				</cfif>
				<cfif len(attributes.product_id_6) and len(attributes.product_name_6)>
					OR S.PRODUCT_ID = #attributes.product_id_6#
				</cfif>
				<cfif len(attributes.product_id_7) and len(attributes.product_name_7)>
					OR S.PRODUCT_ID = #attributes.product_id_7#
				</cfif>
				<cfif len(attributes.product_id_8) and len(attributes.product_name_8)>
					OR S.PRODUCT_ID = #attributes.product_id_8#
				</cfif>
				<cfif len(attributes.product_id_9) and len(attributes.product_name_9)>
					OR S.PRODUCT_ID = #attributes.product_id_9#
				</cfif>
				<cfif len(attributes.product_id_10) and len(attributes.product_name_10)>
					OR S.PRODUCT_ID = #attributes.product_id_10#
				</cfif>
				)
			</cfif>
	</cfquery>
	<cfset new_count = 10>
	<cfloop from="1" to="10" index="indx_product">
		<cfset "attributes.new_question_product_id_#indx_product#" = evaluate("attributes.question_product_id_#indx_product#")>
        <cfset "attributes.new_question_stock_id_#indx_product#" = evaluate("attributes.question_stock_id_#indx_product#")>
		<cfset "attributes.new_question_stock_name_#indx_product#" = evaluate("attributes.question_stock_name_#indx_product#")>
		<cfset "attributes.new_katsayi_#indx_product#" = evaluate("attributes.katsayi_#indx_product#")>
	</cfloop>
	<cfif len(attributes.new_cat_id)>
		<cfquery name="get_new_stocks" datasource="#dsn3#">
			SELECT
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.PRODUCT_NAME
			FROM
				STOCKS S
			WHERE
				S.PRODUCT_CATID IN (#attributes.new_cat_id#)
                AND S.STOCK_STATUS = 1
                AND S.PRODUCT_STATUS = 1
		</cfquery>
		<cfset new_count = get_new_stocks.recordcount>
		<cfloop query="get_new_stocks">
			<cfset "attributes.new_question_product_id_#currentrow#" = product_id>
            <cfset "attributes.new_question_stock_id_#currentrow#" = stock_id>
			<cfset "attributes.new_question_stock_name_#currentrow#" = product_name>
			<cfset "attributes.new_katsayi_#currentrow#" = evaluate("attributes.katsayi_1")>
		</cfloop>
	</cfif>
	<cfoutput query="get_product_trees">
		<cfif attributes.pro_type eq 1>
			<cfloop from="1" to="#new_count#" index="indx_product">
				<cfif len(evaluate("attributes.new_question_stock_name_#indx_product#"))>
					<cfset new_product_id = evaluate("attributes.new_question_product_id_#indx_product#")>
                    <cfset new_stock_id = evaluate("attributes.new_question_stock_id_#indx_product#")>
					<cfset new_product_name= evaluate("attributes.new_question_stock_name_#indx_product#")>
					<cfset new_katsayi= evaluate("attributes.new_katsayi_#indx_product#")>
					<cfloop from="1" to="#listlen(attributes.question_id)#" index="kk">
						<cfset new_question_id_ = listgetat(attributes.question_id,kk,'~')>
						<cfscript>							
							 writeTree(0,get_product_trees.stock_id,0,new_question_id_,get_product_trees.STOCK_ID);
						</cfscript>
						<cfif isdefined("question_stock_list_#get_product_trees.STOCK_ID#_#new_question_id_#")>
							<cfset new_stocks = evaluate("question_stock_list_#get_product_trees.STOCK_ID#_#new_question_id_#")>
							<cfif listlen(new_stocks,',')>
								<cfloop from="1" to="#listlen(new_stocks,',')#" index="new_indx">
									<cfset related_stock_id = listgetat(evaluate("relation_stock_list_#get_product_trees.STOCK_ID#_#new_question_id_#"),new_indx)>
									<cfquery name="get_p_id" datasource="#dsn3#">
										SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #listgetat(new_stocks,new_indx)#
									</cfquery>
									<cfquery name="get_spect_id" datasource="#dsn3#">
										SELECT MAX(SPECT_MAIN_ID) SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_STATUS = 1 AND STOCK_ID = #new_stock_id#
									</cfquery>
									<cfquery name="get_alternative_pro" datasource="#dsn3#">
										SELECT 
											ALTERNATIVE_ID 
										FROM 
											ALTERNATIVE_PRODUCTS 
										WHERE 
											TREE_STOCK_ID = #related_stock_id#
											AND QUESTION_ID = #new_question_id_#
											AND ALTERNATIVE_PRODUCT_ID = #new_product_id#
											AND STOCK_ID = #new_stock_id#
											AND PRODUCT_ID = #get_p_id.PRODUCT_ID#
									</cfquery>
									<cfif get_alternative_pro.recordcount and len(new_katsayi)>bb
										<cfquery name="upd_row" datasource="#dsn3#">
											UPDATE 
												ALTERNATIVE_PRODUCTS 
											SET 
												USAGE_RATE = #new_katsayi#,
												RECORD_EMP = #session.ep.userid#,
												RECORD_DATE = #now()#	
											WHERE 
												TREE_STOCK_ID = #related_stock_id#
												AND QUESTION_ID = #new_question_id_#
												AND ALTERNATIVE_PRODUCT_ID = #new_product_id#
												AND STOCK_ID = #new_stock_id#
												AND PRODUCT_ID = #get_p_id.PRODUCT_ID#
										</cfquery>
										<cfset soru_ = listgetat(question_name_list,listfindnocase(question_id_list,new_question_id_))>
										<cfset message_ = message_ & "<li>#YAN_URUN# adlı üründen (#soru_#) sorusuna bağlı olan #attributes.question_stock_name# ürününün Fiyat Farkı Oranı Güncellendi.</li><br/>">
									<cfelseif get_alternative_pro.recordcount eq 0>
										<cfquery name="add_row" datasource="#dsn3#">
											INSERT INTO
												ALTERNATIVE_PRODUCTS
											(
												PRODUCT_ID,
												STOCK_ID,
												ALTERNATIVE_PRODUCT_ID,
												TREE_STOCK_ID,
												SPECT_MAIN_ID,
												USAGE_RATE,
												QUESTION_ID,
												START_DATE,
												FINISH_DATE,
												RECORD_EMP,
												RECORD_DATE
											)
											VALUES
											(
												#get_p_id.PRODUCT_ID#,
												#new_stock_id#,
												#new_product_id#,
												#related_stock_id#,
												<cfif len(get_spect_id.spect_main_id)>#get_spect_id.spect_main_id#<cfelse>NULL</cfif>,
												<cfif len(new_katsayi)>#new_katsayi#<cfelse>NULL</cfif>,
												#listgetat(attributes.question_id,kk,',')#,
												NULL,
												NULL,
												#session.ep.userid#,
												#now()#		
											)
										</cfquery>
										<cfset soru_ = listgetat(question_name_list,listfindnocase(question_id_list,new_question_id_))>
										<cfset message_ = message_ & "<li>#YAN_URUN# adlı üründen (#soru_#) sorusuna #new_product_name# ürünü Eklendi.</li><br/>">
									</cfif>
								</cfloop>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop from="1" to="#new_count#" index="indx_product">
				<cfif len(evaluate("attributes.new_question_stock_name_#indx_product#"))>
					<cfset new_product_id = evaluate("attributes.new_question_product_id_#indx_product#")>
					<cfset new_product_name= evaluate("attributes.new_question_stock_name_#indx_product#")>
					<cfloop from="1" to="#listlen(attributes.question_id)#" index="kk">
						<cfset new_question_id_ = listgetat(attributes.question_id,kk,'~')>
						<cfscript>							
							 writeTree(0,get_product_trees.stock_id,0,new_question_id_,get_product_trees.STOCK_ID);
						</cfscript>
						<cfif isdefined("question_stock_list_#get_product_trees.STOCK_ID#_#new_question_id_#")>
							<cfset new_stocks = evaluate("question_stock_list_#get_product_trees.STOCK_ID#_#new_question_id_#")>
							<cfif listlen(new_stocks,',')>
								<cfloop from="1" to="#listlen(new_stocks,',')#" index="new_indx">
									<cfset related_stock_id = listgetat(evaluate("relation_stock_list_#get_product_trees.STOCK_ID#_#new_question_id_#"),new_indx)>
									<cfquery name="get_alternative_pro" datasource="#dsn3#">
										SELECT 
											ALTERNATIVE_ID 
										FROM 
											ALTERNATIVE_PRODUCTS 
										WHERE 
											TREE_STOCK_ID = #related_stock_id#
											AND QUESTION_ID = #new_question_id_#
											AND ALTERNATIVE_PRODUCT_ID = #new_product_id#
									</cfquery>
									<cfif get_alternative_pro.recordcount>
										<cfquery name="del_row" datasource="#dsn3#">
											DELETE FROM 
												ALTERNATIVE_PRODUCTS 
											WHERE 
												TREE_STOCK_ID = #related_stock_id# AND 
												QUESTION_ID = #new_question_id_#
												AND ALTERNATIVE_PRODUCT_ID = #new_product_id#
										</cfquery>
										<cfset soru_ = listgetat(question_name_list,listfindnocase(question_id_list,new_question_id_))>
										<cfset message_ = message_ & "<li>#YAN_URUN# adlı üründen (#soru_#) sorusuna bağlı olan #new_product_name# ürünü silindi.</li><br/>">
									</cfif>
								</cfloop>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>				
	</cfoutput>
	<cf_box>
		<cf_flat_list>
			<thead>
				<tr>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_product_trees.recordcount>
					<tr>	
						<td><cfoutput>#message_#</cfoutput></td>
					</tr> 
				<cfelse>
					<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</cfif>
</div>
<script type="text/javascript">
	function form_kontrol()
	{
		if(document.report_special.cat.value == '' && (document.report_special.product_id_1.value == '' && document.report_special.product_name_1.value == '')  && (document.report_special.product_id_2.value == '' && document.report_special.product_name_2.value == '')  && (document.report_special.product_id_3.value == '' && document.report_special.product_name_3.value == '')  && (document.report_special.product_id_4.value == '' && document.report_special.product_name_4.value == '')  && (document.report_special.product_id_5.value == '' && document.report_special.product_name_5.value == '')  && (document.report_special.product_id_6.value == '' && document.report_special.product_name_6.value == '')  && (document.report_special.product_id_7.value == '' && document.report_special.product_name_7.value == '')  && (document.report_special.product_id_8.value == '' && document.report_special.product_name_8.value == '')  && (document.report_special.product_id_9.value == '' && document.report_special.product_name_9.value == 
		'')  && (document.report_special.product_id_10.value == '' && document.report_special.product_name_10.value == ''))
		{
			alert("<cf_get_lang dictionary_id='36743.Ürün Kategorisi veya Ürün Seçmelisiniz'>!");
			return false;
		}
		if(((document.report_special.question_product_id_1.value == '' && document.report_special.question_stock_name_1.value == '')  && (document.report_special.question_product_id_2.value == '' && document.report_special.question_stock_name_2.value == '')  && (document.report_special.question_product_id_3.value == '' && document.report_special.question_stock_name_3.value == '')  && (document.report_special.question_product_id_4.value == '' && document.report_special.question_stock_name_4.value == '')  && (document.report_special.question_product_id_5.value == '' && document.report_special.question_stock_name_5.value == '')  && (document.report_special.product_id_6.value == '' && document.report_special.question_stock_name_6.value == '')  && (document.report_special.question_product_id_7.value == '' && document.report_special.question_stock_name_7.value == '')  && (document.report_special.question_product_id_8.value == '' && document.report_special.question_stock_name_8.value == '')  && (document.report_special.product_id_9.value == '' && document.report_special.product_name_9.value == 
		'')  && (document.report_special.question_product_id_10.value == '' && document.report_special.question_stock_name_10.value == ''))  && document.report_special.new_cat_id.value == '')
		{
			alert('<cf_get_lang dictionary_id="36745.Hammadde İçin Ürün veya Kategori Seçmelisiniz">!');
			return false;
		}
		if(((document.report_special.question_product_id_1.value != '' && document.report_special.question_stock_name_1.value != '')  || (document.report_special.question_product_id_2.value != '' && document.report_special.question_stock_name_2.value != '')  || (document.report_special.question_product_id_3.value != '' && document.report_special.question_stock_name_3.value != '')  || (document.report_special.question_product_id_4.value != '' && document.report_special.question_stock_name_4.value != '')  || (document.report_special.question_product_id_5.value != '' && document.report_special.question_stock_name_5.value != '')  || (document.report_special.product_id_6.value == '' && document.report_special.question_stock_name_6.value != '')  || (document.report_special.question_product_id_7.value != '' && document.report_special.question_stock_name_7.value == '')  || (document.report_special.question_product_id_8.value != '' && document.report_special.question_stock_name_8.value != '')  || (document.report_special.product_id_9.value == '' && document.report_special.product_name_9.value !=
		'')  || (document.report_special.question_product_id_10.value != '' && document.report_special.question_stock_name_10.value != ''))  && document.report_special.new_cat_id.value != '')
		{
			alert('<cf_get_lang dictionary_id="36745.Hammadde İçin Ürün veya Kategori Seçmelisiniz">!');
			return false;
		}
		if(document.report_special.question_id.value == '')
		{
			alert('<cf_get_lang dictionary_id="36756.Alternatif Soru Seçmelisiniz">!');
			return false;
		}
		
		for(xx=1;xx<=10;xx++)
		{	//Ondalik Hane icin
			document.getElementById("katsayi_"+xx).value = filterNum(document.getElementById("katsayi_"+xx).value,4);
		}
	}
</script>
