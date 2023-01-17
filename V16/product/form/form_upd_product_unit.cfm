<cf_xml_page_edit fuseact="product.form_upd_popup_unit">
<cfparam name="attributes.modal_id" default="">
<cfif not isDefined("xml_multiplier_round")><cfset xml_multiplier_round = 4></cfif>
<cfif not isDefined("xml_quantity_round")><cfset xml_quantity_round = 4></cfif>
<cfinclude template="../query/get_unit.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfquery name="GET_PRODUCT_UNIT_NAME" datasource="#DSN3#">
	SELECT ADD_UNIT,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
</cfquery>
<cfset kontroldeg = 0>
<cfquery name="GET_PROD_UNIT_INFO_1" datasource="#DSN2#" maxrows="1">
	SELECT 
		UNIT
	FROM 
		SHIP_ROW
	WHERE
		SHIP_ROW.UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(get_product_unit_name.add_unit)#"> AND
		SHIP_ROW.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_unit_name.product_id#">
</cfquery>
<cfif get_prod_unit_info_1.recordcount>
	<cfset kontroldeg = 1>
<cfelse>
	<cfquery name="GET_PROD_UNIT_INFO_2" datasource="#DSN2#" maxrows="1">
		SELECT
			UNIT
		FROM 		
			STOCK_FIS_ROW
		WHERE
			UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(get_product_unit_name.add_unit)#"> AND
			STOCK_ID IN (SELECT STOCK_ID FROM #dsn1_alias#.STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_unit_name.product_id#">) 
	</cfquery>
	<cfif get_prod_unit_info_2.recordcount>
		<cfset kontroldeg = 1>
	</cfif>
</cfif>
<cfquery name="GET_PROD_UNIT_INFO_FROM_BARCODES" datasource="#DSN3#" maxrows="1">
	SELECT UNIT_ID FROM STOCKS_BARCODES WHERE UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_unit.product_unit_id#">
</cfquery>
<cfsavecontent variable="head"><cfif get_product_unit.is_main is 1><cf_get_lang dictionary_id='37166.Ana Birim'><cfelse><cf_get_lang dictionary_id='37197.Birim Güncelle'></cfif></cfsavecontent>
<cfsavecontent variable="right">
	<cfoutput>
        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.popup_product_unit_history&product_unit_id=#attributes.unit_id#','','ui-draggable-box-small');" class="font-red-pink"><i class="fa fa-history" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a>
    </cfoutput>
</cfsavecontent>
<cf_box title="#head#" scroll="1" collapsable="1" resize="1" right_images="#right#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_upd_not" method="post" action="#request.self#?fuseaction=product.upd_popup_unit">
        <cf_box_elements>  
            <div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="1" sort="true">                <input type="hidden" name="product_unit_id" id="product_unit_id" value="<cfoutput>#attributes.unit_id#</cfoutput>">
                <input type="hidden" name="main_unit" id="main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
                <input type="hidden" name="main_unit_id" id="main_unit_id" value="<cfoutput>#get_product_unit.main_unit_id#</cfoutput>">
                <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
                <input type="hidden" name="unit_id_" id="unit_id_" value="<cfoutput>#get_product_unit.unit_id#</cfoutput>">
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product.product_name#</cfoutput></label>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"> 2.<cf_get_lang dictionary_id="57636.Birim"></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_add_unit" id="is_add_unit" <cfif get_product_unit.is_add_unit eq 1> checked</cfif> value="1"></label>						
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37859.Bu Birim İle Sevk Edilir'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_ship_unit" id="is_ship_unit" <cfif get_product_unit.is_ship_unit eq 1> checked</cfif>></label>						
                </div>
                <cfif get_product_unit.is_main neq 1>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
                        <label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product_unit.main_unit#</cfoutput></label>
                    </div>
                    <cfelse>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="main_unit" id="main_unit" onchange="mess();">
                                <cfoutput query="get_unit">
                                    <option value="#unit_id#,#unit#" <cfif get_product_unit.main_unit is unit> selected</cfif>>#unit#</option>
                                </cfoutput>
                            </select>
                            <input type="hidden" name="old_main_unit" id="old_main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
                        </div>
                    </div>
                </cfif>                
                <cfif get_product_unit.is_main neq 1>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37186.Ek Birim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="add_unit" id="add_unit">
                                <cfoutput query="get_unit">
                                    <cfif get_product_unit.main_unit_id neq get_unit.unit_id>
                                        <option value="#unit_id#,#unit#" <cfif get_product_unit.add_unit is unit> selected</cfif>>#unit#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif>
                <cfif get_product_unit.is_main neq 1>
                    <cfif xml_select_amount eq 1>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_product_unit.quantity)>
                                    <cfset amount_new_ = wrk_round(get_product_unit.quantity,8,1)>
                                <cfelse>
                                    <cfset amount_new_ = wrk_round(get_product_unit.multiplier,8,1)>
                                </cfif>
                                <cfinput type="text" name="quantity" id="quantity" value="#tlformat(amount_new_,xml_quantity_round)#" onBlur="hesapla_amount();" required="Yes" onkeyup="FormatCurrency(this,event,#xml_quantity_round#)" class="moneybox">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58865.Çarpan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37433.Çarpan girmelisiniz'></cfsavecontent>
                                <cfset amount_new = wrk_round(get_product_unit.multiplier,8,1)>
                                <cfinput type="text" name="multiplier" id="multiplier" required="Yes" onkeyup="FormatCurrency(this,event,#xml_multiplier_round#)" message="#message#" value="#tlformat(amount_new,xml_multiplier_round)#" class="moneybox">
                                <span class="input-group-addon bold">*<cfoutput>#get_product_unit.main_unit#</cfoutput></span>
                            </div>
                        </div>
                    </div>
                </cfif>
                 <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'> (<cf_get_lang dictionary_id='29703.cm'>)</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="dimention" id="dimention" value="#get_product_unit.dimention#" onBlur="return volume_calculate();">
                            <span class="input-group-addon bold">a*b*h</span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="30114.Hacim"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="volume" id="volume" value="#get_product_unit.volume#">
                            <span class="input-group-addon bold"><cf_get_lang dictionary_id='37318.cm3'></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="weight" id="weight" value="#tlformat(get_product_unit.weight,8)#" onkeyup="FormatCurrency(this,event,8)" class="moneybox">
                            <span class="input-group-addon bold"><cf_get_lang dictionary_id='37188.kg'></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37612.Birim Çarpanı'></label>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <cfinput type="text" name="unit_multiplier" id="unit_multiplier" value="#tlformat(get_product_unit.unit_multiplier,xml_multiplier_round)#" onkeyup="FormatCurrency(this,event,#xml_multiplier_round#)" class="moneybox">
                    </div><!--- maxlength="6" kaldirildi, ondalik hane degisebilir --->
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
                        <select name="multiplier_static" id="multiplier_static">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1"<cfif get_product_unit.unit_multiplier_static eq 1> selected</cfif>><cf_get_lang dictionary_id='37613.Litre'></option>
                            <option value="2"<cfif get_product_unit.unit_multiplier_static eq 2> selected</cfif>><cf_get_lang dictionary_id='37188.kg'></option>
                            <option value="3"<cfif get_product_unit.unit_multiplier_static eq 3> selected</cfif>><cf_get_lang dictionary_id='58082.Adet'></option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="2" sort="true">
                <div class="form-group" id="item-package">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34799.Paket Tipi'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfquery name="PACKAGES" datasource="#dsn#">
                            SELECT 
                                PACKAGE_TYPE_ID, 
                                PACKAGE_TYPE
                            FROM 
                                SETUP_PACKAGE_TYPE
                        </cfquery>
                        <select name="packages" id="packages" >
                            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                            <cfoutput query="PACKAGES">
                                <option value="#PACKAGE_TYPE_ID#" <cfif get_product_unit.PACKAGES eq package_type_id>selected</cfif>>#PACKAGE_TYPE#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div> 
                <div class="form-group" id="item-package_control_type">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='37768.Paket Kontrol Tipi'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="package_control_type" id="package_control_type">
                            <option value="1" <cfif get_product_unit.package_control_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='40429.Kendisi'></option>
                            <option value="2" <cfif get_product_unit.package_control_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='37770.Bileşenleri'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-instruction">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45222.Paketleme ve Taşıma Talimatı'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="instruction" id="instruction" value="<cfoutput>#get_product_unit.INSTRUCTION#</cfoutput>" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42647.Etiket Şablonu'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file"/></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="hidden" name="old_image_file" id="old_image_file" value="<cfoutput>#get_product_unit.path#</cfoutput>">
                        <cfoutput>#get_product_unit.path#</cfoutput></div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_product">
            <cfif kontroldeg or get_prod_unit_info_from_barcodes.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol_et() && loadPopupBox('form_upd_not' , #attributes.modal_id#)"),DE(""))#">
            <cfelse>
                <cfif get_product_unit.is_main neq 1>
                    <cf_workcube_buttons is_upd='1' del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#" add_function="#iif(isdefined("attributes.draggable"),DE("kontrol_et() && loadPopupBox('form_upd_not' , #attributes.modal_id#)"),DE(""))#"> 
                <cfelse>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol_et() && loadPopupBox('form_upd_not' , #attributes.modal_id#)"),DE(""))#"> 
                </cfif>
            </cfif>
        </cf_box_footer>    
    </cfform>
</cf_box>		
<script type="text/javascript">
	function mess()
	{
		window.alert("<cf_get_lang dictionary_id='37096.Ana birimi değiştirmek üzeresiniz \nDiğer Alt Birimlerde bu işlemle birlikte silinecek'> !");
	}
	
    <cfif isDefined('attributes.draggable')>
        function deleteFunc() {
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.emptypopup_del_product_unit&unit_id=#attributes.unit_id#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
        }
    </cfif>

	function kontrol_et()
	{
		<cfif get_product_unit.is_main neq 1>
            document.getElementById('multiplier').value = filterNum(document.getElementById('multiplier').value,'<cfoutput>#xml_multiplier_round#</cfoutput>');
            <cfif xml_select_amount eq 1>
                document.getElementById('quantity').value = filterNum(document.getElementById('quantity').value,4);
            </cfif>
		</cfif>
		document.getElementById('weight').value = filterNum(document.getElementById('weight').value,8);
		document.getElementById('unit_multiplier').value = filterNum(document.getElementById('unit_multiplier').value,'<cfoutput>#xml_multiplier_round#</cfoutput>');
		<cfif get_product_unit.is_main neq 1>
			if(document.getElementById('multiplier').value == 0)
			{
				alert("<cf_get_lang dictionary_id='37109.Çarpan alanına sıfır değerini giremezsiniz!'>");
				return false;	
			}
		</cfif>
		return true;
	}
	function volume_calculate()
	{
		var dimention_ = ReplaceAll(document.getElementById('dimention').value,"x","*");
		var a = list_getat(dimention_,1,'*');
		a = a.replace(',','.');
		var b = list_getat(dimention_,2,'*');
		b = b.replace(',','.');
		var c = list_getat(dimention_,3,'*');
		c = c.replace(',','.');
		var volume = a*b*c ;
		eval('form_upd_not.volume').value = volume;
	}
	<cfoutput>
		function hesapla_amount()
		{	
            <cfif xml_select_amount eq 1>
                if(list_len(document.getElementById('quantity').value))
                    amount_ = filterNum(document.getElementById('quantity').value,#xml_multiplier_round#);
                else
                    amount_ = 1;	
            <cfelse>
                amount_ = 1;	
            </cfif>
			document.getElementById('multiplier').value = commaSplit(1/amount_,#xml_multiplier_round#);
		}
	</cfoutput>
</script>
