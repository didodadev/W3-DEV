<cfinclude template="../query/product_cats.cfm">
<cf_xml_page_edit fuseact="product.list_product_cat">
<cfquery name="CATEGORY" dbtype="query">
	SELECT 
    	* 
    FROM 
    	PRODUCT_CATS 
    WHERE 
    	PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfif not CATEGORY.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58642.Urun Kaydı Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfquery name="GET_PRODUCT_CAT_BRANDS" datasource="#DSN1#">
	SELECT
		PRODUCT_BRANDS.BRAND_ID,
		PRODUCT_BRANDS.BRAND_NAME
	FROM
		PRODUCT_CAT_BRANDS,
		PRODUCT_BRANDS
	WHERE
		PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
		PRODUCT_CAT_BRANDS.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
</cfquery>
<cfinclude template="../query/get_our_companies.cfm">
<cfquery name="GET_PRODUCT_CAT_OUR_COMPANIES" datasource="#DSN1#">
	SELECT OUR_COMPANY_ID FROM PRODUCT_CAT_OUR_COMPANY WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfset our_comp_list = valuelist(get_product_cat_our_companies.our_company_id)>
<cfquery name="GET_CONTROL" datasource="#DSN1#" maxrows="1">
	SELECT PRODUCT_CAT_ID FROM PRODUCT_CAT_PROPERTY WHERE PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset GET_OUR_COMPANY_INFO = company_cmp.GET_OURCMP_INFO()>
<cfset watalogy_cat_name = ''>
<cfset cmp = createObject("component","V16/settings/cfc/watalogyWebServices")>
<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1 and len(CATEGORY.WATALOGY_CAT_ID)>
	<cfset get_watalogy_category = cmp.getWatalogyCategory(cat_id:CATEGORY.WATALOGY_CAT_ID)>
    <cfoutput query="get_watalogy_category">
	    <cfset watalogy_cat_name = ListAppend(watalogy_cat_name,get_watalogy_category.hierarchy & ' '&get_watalogy_category.CATEGORY_NAME)>
    </cfoutput>
</cfif>
<cf_catalystHeader>
    <cf_box>
        <cfform name="product_cat" method="post" enctype="multipart/form-data" action='#request.self#?fuseaction=product.product_cat_upd'>
            <cfoutput>
                <input type="hidden" id="counter" name="counter">
                <input type="hidden" name="product_catid" id="product_catid" value="#url.id#">
                <input type="hidden" name="oldhierarchy" id="oldhierarchy" value="#category.hierarchy#">
                <cfset cat_code=listlast(category.hierarchy,".")>
                <!---#cat_code#<cfabort>--->
                <cfset ust_cat_code=listdeleteat(category.hierarchy,ListLen(category.hierarchy,"."),".")>
                <input type="hidden" name="product_cat_code_old" id="product_cat_code_old" value="#cat_code#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-our_company_ids">
                            <label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_multiselect_check
                                name="our_company_ids"
                                option_name="nick_name"
                                option_value="comp_id"
                                width="220"
                                table_name="OUR_COMPANY"
                                value="iif(#listlen(our_comp_list)#,#our_comp_list#,DE(''))">
                            </div>
                        </div>
                        <div class="form-group" id="item-hierarchy">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="hierarchy" id="hierarchy" onchange="document.product_cat.head_cat_code.value=document.product_cat.hierarchy[document.product_cat.hierarchy.selectedIndex].value;">
                                    <option value=""<cfif ust_cat_code eq "">selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="product_cats">
                                        <cfif hierarchy is not category.hierarchy>
                                            <option value="#hierarchy#"<cfif compare(ust_cat_code,hierarchy) eq 0 and len(ust_cat_code) eq len(hierarchy)> selected</cfif>>#hierarchy# #product_cat#</option>
                                        </cfif>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-head_cat_code">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37159.Kategori Kodu'> *</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="head_cat_code" id="head_cat_code" value="#ust_cat_code#" disabled/>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='37431.Kategori Kodu girmelisiniz'></cfsavecontent>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="product_cat_code" id="product_cat_code" value="#cat_code#" maxlength="50" required="yes" message="#message#">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-product_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='37378.Kategori girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="product_cat" id="product_cat" value="#category.product_cat#" maxlength="150" required="Yes" message="#message#">
                                    <span class="input-group-addon"><cf_language_info 
                                        table_name="PRODUCT_CAT" 
                                        column_name="PRODUCT_CAT" 
                                        column_id_value="#attributes.id#" 
                                        maxlength="500" 
                                        datasource="#dsn1#" 
                                        column_id="PRODUCT_CATID" 
                                        control_type="0"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-watalogy_product_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61453.Watalogy Kategorisi'></cfsavecontent>
                                    <cfinput type="hidden" name="watalogy_cat_id" value="#category.watalogy_cat_id#">
                                    <cfinput type="text" name="watalogy_cat_name" id="watalogy_cat_name" value="#watalogy_cat_name#">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_watalogy_category_names&field_id=product_cat.watalogy_cat_id&field_name=product_cat.watalogy_cat_name');" title="<cf_get_lang dictionary_id='61454.Watalogy Kategorisi Ekle'>!"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-profit_margin_min">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37045.Marj'>(%)</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <label><cf_get_lang dictionary_id='37321.Minimum'></label>
                                    <input type="text" name="profit_margin_min" id="profit_margin_min" value="#filternum(category.profit_margin,0)#" maxlength="3" onkeyup="return(FormatCurrency(this,event));" />
                                    <span class="input-group-addon no-bg"></span>
                                    <label><cf_get_lang dictionary_id='37319.Maximum'></label>
                                    <label><input type="text" name="profit_margin_max" id="profit_margin_max" value="#filternum(category.profit_margin_max,0)#" maxlength="3" onkeyup="return(FormatCurrency(this,event));" /></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-list_order_no">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37545.Listeleme Sırası'></label>
                            <div class="col col-9 col-xs-12">
                                <cfinput type="text" name="list_order_no" value="#category.list_order_no#" validate="integer" range="1,1000" message="Listeleme Sırası 1-1000 arası olmalıdır!" onKeyUp="return(FormatCurrency(this,event,0));">
                            </div>
                        </div>
                        <div class="form-group" id="item-stock_code_counter">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61459.Stock Code Counter'></label>
                            <div class="col col-9 col-xs-12">
                                <cfinput type="text" name="stock_code_counter" id="stock_code_counter" value="#category.STOCK_CODE_COUNTER#"  message="Stok kodu değeri sayı olmalıdır!" validate="integer">
                            </div>
                        </div>
                        <div class="form-group" id="item-image_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37135.İmaj Ekle'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="file" name="image_cat" id="image_cat">
                                <input type="hidden" name="old_image_cat" id="old_image_cat" value="#category.image_cat#">
                                <input type="hidden" name="old_image_cat_server_id" id="old_image_cat_server_id" value="#category.image_cat_server_id#">	
                            </div>
                        </div>
                        <cfif len(category.image_cat)>
                            <div class="form-group" id="item-image_cat">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
                                <div class="col col-9 col-xs-12">				
                                    <img src="/documents/#category.image_cat#">
                                    <label> #category.image_cat#</label>						
                                    <label><input type="checkbox" name="del_photo" id="del_photo" value="1"> <cf_get_lang dictionary_id='37937.Fotoğrafı Sil'></label>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-user_friendly_url">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='38023.Kullanıcı Dostu Url'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_publishing_settings fuseaction="product.list_product_cat" event="det" action_type="PRODUCT_CATID" action_id="#url.id#">                          
                            </div>
                        </div>
                    <cfif xml_form_factor>
                        <div class="form-group" id="item-form_factor">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='65046.Form Faktörü'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="form_factor" id="form_factor">
                                    <option value = "0"><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                    <cfoutput>
                                        <option value = "1" <cfif CATEGORY.FORM_FACTOR eq 1>selected</cfif>><cf_get_lang dictionary_id="65045.Boru"></option>
                                        <option value = "2" <cfif CATEGORY.FORM_FACTOR eq 2>selected</cfif>><cf_get_lang dictionary_id="39097.Profil"></option>
                                        <option value = "3" <cfif CATEGORY.FORM_FACTOR eq 3>selected</cfif>>H</option>
                                        <option value = "4" <cfif CATEGORY.FORM_FACTOR eq 4>selected</cfif>>I</option>
                                        <option value = "5" <cfif CATEGORY.FORM_FACTOR eq 5>selected</cfif>>T</option>
                                        <option value = "6" <cfif CATEGORY.FORM_FACTOR eq 6>selected</cfif>>U</option>
                                        <option value = "7" <cfif CATEGORY.FORM_FACTOR eq 7>selected</cfif>>L</option>
                                        <option value = "8" <cfif CATEGORY.FORM_FACTOR eq 8>selected</cfif>><cf_get_lang dictionary_id="65047.Köşebent"></option>
                                        <option value = "9" <cfif CATEGORY.FORM_FACTOR eq 9>selected</cfif>><cf_get_lang dictionary_id="57666.Silindir"></option>
                                        <option value = "10" <cfif CATEGORY.FORM_FACTOR eq 10>selected</cfif>><cf_get_lang dictionary_id="65048.Altıgen"></option>
                                        <option value = "11" <cfif CATEGORY.FORM_FACTOR eq 11>selected</cfif>><cf_get_lang dictionary_id="65049.Beşgen"></option>
                                        <option value = "12" <cfif CATEGORY.FORM_FACTOR eq 12>selected</cfif>><cf_get_lang dictionary_id="65050.Kare"></option>
                                        <option value = "13" <cfif CATEGORY.FORM_FACTOR eq 13>selected</cfif>><cf_get_lang dictionary_id="65051.Dikdörtgen"></option>
                                        <option value = "14" <cfif CATEGORY.FORM_FACTOR eq 14>selected</cfif>><cf_get_lang dictionary_id="65052.Üçgen"></option>
                                        <option value = "15" <cfif CATEGORY.FORM_FACTOR eq 15>selected</cfif>><cf_get_lang dictionary_id="65053.Küre"></option>
                                        <option value = "16" <cfif CATEGORY.FORM_FACTOR eq 16>selected</cfif>><cf_get_lang dictionary_id="63870.Rulo"></option>
                                        <option value = "17" <cfif CATEGORY.FORM_FACTOR eq 17>selected</cfif>><cf_get_lang dictionary_id="65055.Sıvı"></option>
                                        <option value = "18" <cfif CATEGORY.FORM_FACTOR eq 18>selected</cfif>><cf_get_lang dictionary_id="65054.Dökme"></option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                        <div class="form-group" id="item-detail">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-9 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                <textarea name="detail" id="detail" maxlength="150" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="#message#">#category.detail#</textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_public">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='37161.Webde Göster'></span></label>
                            <div class="col col-9 col-xs-12">
                                <label><input type="checkbox" name="is_public" id="is_public" value="1" <cfif category.is_public eq 1>checked</cfif> /><cf_get_lang dictionary_id='37161.Webde Göster'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_cash">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='65171.Display on Whops'></span></label>
                            <div class="col col-9 col-xs-12">
                                <label><input type="checkbox" name="is_cash_register" id="is_cash_register" value="1" <cfif category.is_cash_register eq 1>checked</cfif> /><cf_get_lang dictionary_id='65171.Display on Whops'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_customizable">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='37342.Konfigüre edilebilir'></span></label>
                            <div class="col col-9 col-xs-12">
                                <label><input type="checkbox" name="is_customizable" id="is_customizable" <cfif category.is_customizable eq 1>checked</cfif> /><cf_get_lang dictionary_id='37342.Konfigüre edilebilir'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_installment_payment">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='37263.Ödeme adımında taksit uygulanamaz'></span></label>
                            <div class="col col-9 col-xs-12">
                                <label><input type="checkbox" name="is_installment_payment" id="is_installment_payment" <cfif category.is_installment_payment eq 1>checked</cfif>/><cf_get_lang dictionary_id='37263.Ödeme adımında taksit uygulanamaz'></label>
                            </div>
                        </div>
                    </div>                            
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='37353.İlişkili Markalar'></cfsavecontent>
                        <cf_seperator title="#head#" id="brand_ids">
                        <div id="brand_ids">
                            <cfinclude template="../display/add_product_brand.cfm">
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
                        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='37316.İlişkili Sorumlular'></cfsavecontent>
                        <cf_seperator title="#head#" id="position_">
                        <div id="position_">
                                <cfquery name="GET_RESPONSIBLES" datasource="#DSN1#">
                                    SELECT 
                                        PCP.POSITION_CODE,
                                        PCP.SEQUENCE_NO,
                                        EMP.EMPLOYEE_NAME,
                                        EMP.EMPLOYEE_SURNAME 
                                    FROM 
                                        PRODUCT_CAT_POSITIONS PCP
                                        LEFT JOIN #dsn#.EMPLOYEE_POSITIONS EMP ON PCP.POSITION_CODE = EMP.POSITION_CODE
                                    WHERE
                                        PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                                </cfquery>
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th width="20"><a href="javascrript://" onclick="add_responsible_row();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
                                            <th><cf_get_lang dictionary_id ='37624.Sıra No'></th>
                                            <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                                        </tr>
                                    </thead>
                                    <input type="hidden" name="record_num_responsible" id="record_num_responsible" value="#get_responsibles.recordcount#">
                                    <tbody id="table_responsible">
                                        <cfloop query="get_responsibles">
                                            <tr id="responsibles#currentrow#">
                                                <td>
                                                    <input type="hidden" name="row_kontrol_responsibles#currentrow#" id="row_kontrol_responsibles#currentrow#" value="1">
                                                    <a onclick="sil_responsible(#currentrow#);"><img src="images/delete_list.gif" border="0" alt="Sil"></a>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <div class="col col-12">
                                                            <input type="text" name="order_number#currentrow#" id="order_number#currentrow#" onkeyup="isNumber(this);" onblur="isNumber(this);" value="#sequence_no#">
                                                        </div>
                                                    </div> 
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <div class="col col-12">
                                                            <div class="input-group">
                                                                <input type="hidden" name="position_code#currentrow#" id="position_code#currentrow#" value="#position_code#">
                                                                <input type="text" name="position_name#currentrow#" id="position_name#currentrow#" value="#employee_name# #employee_surname#" onfocus=""> 
                                                                <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="PopupOpenPos(#currentrow#);"></span>
                                                            </div>
                                                        </div>
                                                    </div>     
                                                </td>
                                            </tr>
                                        </cfloop>  
                                    </tbody>                
                                </cf_grid_list>
                        </div>
                    </div> 
                </cf_box_elements>                          
                <div class="ui-form-list-btn">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_record_info query_name="category">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfquery name="GET_PRODUCT_IN_CAT" datasource="#DSN3#"><!---Kategoride urun varsa silinmesin--->
                            SELECT 
                                PRODUCT_CATID 
                            FROM 
                                PRODUCT 
                            WHERE 
                                PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                            UNION ALL
                            SELECT 
                                PRODUCT_CATID 
                            FROM 
                                PRODUCT_CAT 
                            WHERE 
                                HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#category.hierarchy#.%">
                        </cfquery>
                        <cfif get_product_in_cat.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='form_check()&&control_old_list()'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' is_delete='1' add_function='form_check()&&control_old_list()'>
                        </cfif>
                    </div>
                </div>                   
            </cfoutput>
        </cfform>
    </cf_box>
    <cf_get_workcube_content action_type ='PRODUCT_CATID' action_type_id ='#url.id#' style='0'>
    <!--- Urun Ozellikleri --->
    <!---<cfinclude template="../form/add_upd_cat_property.cfm">--->
    <cfsavecontent variable="text"><cf_get_lang dictionary_id='37092.Ürün İlişkili Özellikleri'></cfsavecontent>
    <cf_box id="cat_property" title="#text#" closable="0" box_page="#request.self#?fuseaction=product.add_upd_cat_property&id=#attributes.id#&ust_cat_code=#ust_cat_code#"></cf_box>
    <!--- Kalite Kontrol Tipleri --->
    <cfsavecontent variable="qcct_message"><cf_get_lang dictionary_id="36499.Kalite Kontrol Tipi"></cfsavecontent>
    <cf_box id="quality_control_cat_type" title="#qcct_message#" closable="0" refresh="1" box_page="#request.self#?fuseaction=product.popupajax_product_quality_definition&product_cat_id=#attributes.id#"></cf_box>
    <!--- Kalite Kontrol Parametreleri --->
    <cf_box id="quality_control_parameter" title="#getLang('','Parti - Örneklem Miktarları','64047')#" closable="0" refresh="1" box_page="#request.self#?fuseaction=product.popupajax_product_quality_parameters&product_cat_id=#attributes.id#"></cf_box>
    <!--- Uye Muayene Seviyeleri --->
    <cfsavecontent variable="mil_message"><cf_get_lang dictionary_id="37445.Üye Muayene Seviyeleri"></cfsavecontent>
    <cf_box id="member_inspection_levels" title="#mil_message#" closable="0" refresh="1" box_page="#request.self#?fuseaction=product.popupajax_product_member_inspection_level&product_cat_id=#attributes.id#"></cf_box>
<script type="text/javascript">
	<cfoutput>
		$( document ).ready(function() {
			
			var buttonFirst = $("input[id=wrk_delete_button]");
			var buttonData = buttonFirst.attr('onClick');
			//alert(buttonData);
			buttonFirst.removeAttr('onClick');		
			buttonFirst.on('click',function(){
				var response = my_control_sil();
					if(response){
						var sql="SELECT PRODUCT_CATID FROM PRODUCT WHERE PRODUCT_CATID = "+#attributes.id#;
						get_product_cat= wrk_query(sql,'dsn3');
				if( get_product_cat.recordcount != 0){
				 alert("Bu kategoriye ait ürün bulunmakta kategoriyi silemezsiniz.");
				 return false;
				 }
				else{
					document.getElementById("product_cat").action='#request.self#?fuseaction=product.product_cat_del&product_catid=#url.id#&oldhierarchy=#category.hierarchy#';
					document.getElementById("product_cat").submit();
				 return true;
				}
					
					};//if
				});//click fonksiyonu
			
		}); //ready
		
		function my_control_sil()
			{			
				window.location.reload();
				
				return true;
			}
		</cfoutput>
	var responsible_row_count = <cfoutput>#get_responsibles.recordcount#</cfoutput>;
	function control_old_list()
	{
		var new_our_company_list='';
		
		for(ii=0;ii<document.product_cat.our_company_ids.length; ii++)
		{
			if(product_cat.our_company_ids[ii].selected && product_cat.our_company_ids.options[ii].value.length!='')
				new_our_company_list= new_our_company_list + ',' + product_cat.our_company_ids.options[ii].value;
		}
		<cfloop list="#our_comp_list#" index="k">
			if(!list_find(new_our_company_list,<cfoutput>#k#</cfoutput>,',') )
			{
				var new_dsn3 = '<cfoutput>#dsn#_#k#</cfoutput>';
				var get_productcat = wrk_safe_query('prd_get_product_cat',new_dsn3,0,<cfoutput>#url.id#</cfoutput>);
				if (get_productcat.recordcount)
				{
					alert("<cf_get_lang dictionary_id ='37862.İlgili Şirkette Bu Kategori Bir Üründe Kullanılmıştır'>");
					return false;
				}
			}
		</cfloop>
		
	}
	function form_kontrol(alan,msg,min_n,max_n)
	{
		if(!checkElementLengthRange(alan, '<cf_get_lang dictionary_id ="37873.Mesaj bölümü max karakter sayısı"> '+max_n+' ', 1, max_n)) return false;
	}
	function checkElementLengthRange(target, msg, min_n, max_n) 
	{	
		if (!(target.value.length>=min_n && target.value.length<=max_n))
		{
			alert(msg);
			target.focus();
			return false;
		}
		return true;
	}
	function form_check() <!---Burası hata veriyor jslerden--->
	{
        old_stock_code_counter = <cfoutput>#category.STOCK_CODE_COUNTER#</cfoutput>;
        new_stock_code_counter = document.getElementById('stock_code_counter').value;
        if (old_stock_code_counter > new_stock_code_counter ) {
            alert('Sayaç değeri kendinden daha küçük bir değerle değiştirilemez.!');
            return false;
        }
		if($('#our_company_ids').val() == '')
		{
			alert("<cf_get_lang dictionary_id ='37201.Lütfen, kaydetmek istediğiniz kategoriyi en az bir şirket ile ilişkilendiriniz!'>");
			return false;
		}
		for (i=1;i<responsible_row_count+1;i++)
		{
			
			if($('#row_kontrol_responsibles'+ i).val() == 1){
				
			if($('#order_number'+ i).val() == '' || $('#position_code'+ i).val() == '')
			   {
				alert("<cf_get_lang dictionary_id= '60486.Lütfen Sorumluları Eksiksiz Giriniz'>");
				return false;
			   }
			}
		}
		our_pro_str = $('#product_cat_code').val();
		for(;;) 
		{
			if(our_pro_str.search(" ") != -1)
			{
				our_pro_str = our_pro_str.replace(" ","");
				
				$('#product_cat_code').val() = our_pro_str;
			}
			else
				break;
		}		
		
		if(document.getElementById('product_cat_code').value.indexOf('.') != -1)
		{
			alert("<cf_get_lang dictionary_id ='37863.Ürün özel kategori kodu içeremez'> !");
			return false;
		}
		
		temp_profit_margin_min = filterNum($('#profit_margin_min').val());
		temp_profit_margin_max = filterNum($('#profit_margin_max').val());
		if (parseFloat(temp_profit_margin_min)!="" && temp_profit_margin_max!="" && (parseFloat(temp_profit_margin_min)>parseFloat(temp_profit_margin_max)))
		{
			alert("<cf_get_lang dictionary_id ='37864.Marj Degerlerini Kontrol Ediniz'> !");
			return false;
		}
		
		var obj = $('#image_cat').val();		
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'bmp')))
		{
			alert("<cf_get_lang dictionary_id='60495.Lütfen geçerli bir imaj giriniz'>!");        
			return false;
		}
		
		if (product_cat.product_cat_code.value != product_cat.product_cat_code_old.value)	
		{	
			if (confirm("<cf_get_lang dictionary_id ='37865.Kategori Kodunda Yaptığınız Değişiklik Stok Hiyerarşisinin Bozulmasına ve Veri Kaybına Neden Olabilir! Devam Etmek İstiyor musunuz'>?")) 
			{
				product_cat.profit_margin_min.value = filterNum(product_cat.profit_margin_min.value);
				product_cat.profit_margin_max.value = filterNum(product_cat.profit_margin_max.value);
				return true;
			}	
			else 
				return false;
		}		
		else
		{
			product_cat.profit_margin_min.value = filterNum(product_cat.profit_margin_min.value);
			product_cat.profit_margin_max.value = filterNum(product_cat.profit_margin_max.value);
			return true;
		}
	}
	
	function add_responsible_row()
	{
		responsible_row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_responsible").insertRow(document.getElementById("table_responsible").rows.length);
		newRow.setAttribute("id","responsibles" + responsible_row_count);
		document.getElementById('record_num_responsible').value = responsible_row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol_responsibles' + responsible_row_count +'" id="row_kontrol_responsibles' + responsible_row_count +'" value="1"><a onclick="sil_responsible(' + responsible_row_count + ');"><img  src="images/delete_list.gif" border="0" alt="Sil"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="order_number' + responsible_row_count +'" id="order_number' + responsible_row_count +'" onKeyUp="isNumber(this);" onBlur="isNumber(this);"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="position_code' + responsible_row_count +'" id="position_code' + responsible_row_count +'"><input type="text" name="position_name' + responsible_row_count +'" id="position_name' + responsible_row_count +'"   value="" onFocus="AutoCompleteOpenPos(' + responsible_row_count + ');" ><span class="input-group-addon btnPointer icon-ellipsis"href="javascript://" onClick="PopupOpenPos('+ responsible_row_count +');"></span></div></div>';
		
	}
	function AutoCompleteOpenPos(row)
	{
		AutoComplete_Create('position_name'+row,'FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','position_code'+row,'','3','130');
	}
	function PopupOpenPos(row)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=product_cat.position_name' + row +'&field_code=product_cat.position_code' + row </cfoutput>,'list');
	}
	function sil_responsible(row)
	{
		
		$('#row_kontrol_responsibles' + row).val(0) ;
		document.getElementById('responsibles' + row ).style.display = 'none';
	}

    $( document ).ready(function() {
		var my_options = $("#form_factor option");

		my_options.sort(function(a,b) {
		    if (a.text > b.text) return 1;
		    else if (a.text < b.text) return -1;
		    else return 0;
		});

		$("#form_factor").empty().append(my_options).selectpicker("refresh");
	})	
</script>
</cfif>
