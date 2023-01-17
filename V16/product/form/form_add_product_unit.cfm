<!--- form_add_target.cfm --->
<cf_xml_page_edit fuseact="product.form_upd_popup_unit">
<cfif not isDefined("xml_multiplier_round")><cfset xml_multiplier_round = 4></cfif>
<cfif not isDefined("xml_quantity_round")><cfset xml_quantity_round = 4></cfif>
<cf_box title="#getLang('','Birim Ekle',37032)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_upd_not" method="post" action="#request.self#?fuseaction=product.emptypopup_add_product_unit">
        <cfscript>
            get_product_list_action = createObject("component", "V16.product.cfc.get_product");
            get_product_list_action.dsn1 = dsn1;
            get_product_list_action.dsn_alias = dsn_alias;
            get_product = get_product_list_action.get_product_
            (
                module_name : fusebox.circuit,
                pid : attributes.pid
            );
        </cfscript>
        <!---<cfinclude template="../query/get_product.cfm">--->
        <cfinclude template="../query/get_unit.cfm">
        <cfinclude template="../query/get_product_unit.cfm">
        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
        <input type="hidden" name="main_unit" id="main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
        <input type="hidden" name="main_unit_id" id="main_unit_id" value="<cfoutput>#get_product_unit.main_unit_id#</cfoutput>">
        <cf_box_elements>  
            <div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="1" sort="true">
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product.product_name#</cfoutput></label>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product_unit.main_unit#</cfoutput></label>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"> 2.<cf_get_lang dictionary_id="57636.Birim"></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_add_unit" id="is_add_unit" value="1"></label>						
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37859.Bu Birim İle Sevk Edilir'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_ship_unit" id="is_ship_unit" value="1"></label>						
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37186.Ek Birim'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="add_unit_id" id="add_unit_id">
                            <option value=""><cf_get_lang dictionary_id='37186.Ek Birim'></option>
                            <cfoutput query="get_unit">
                                <cfif get_product_unit.main_unit_id neq get_unit.unit_id>
                                    <option value="#unit_id#">#unit#</option>
                                </cfif>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <cfif xml_select_amount eq 1>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="quantity" id="quantity" onBlur="hesapla_amount();" onkeyup="FormatCurrency(this,event,#xml_quantity_round#)" class="moneybox">
                        </div>
                    </div>
                </cfif>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58865.Çarpan'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">	
                            <cfinput type="text" name="multiplier" id="multiplier" required="Yes" onkeyup="FormatCurrency(this,event,#xml_multiplier_round#)" message="#getLang('','Çarpan girmelisiniz',37433)#" class="moneybox">
                            <span class="input-group-addon bold">*<cfoutput>#get_product_unit.main_unit#</cfoutput></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'> (<cf_get_lang dictionary_id='29703.cm'>)</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">	
                            <cfinput type="text" name="dimention" id="dimention" onBlur="return volume_calculate();">    
                            <span class="input-group-addon bold">a*b*h</span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="30114.Hacim"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="volume" id="volume">
                            <span class="input-group-addon bold"><cf_get_lang dictionary_id='37318.cm3'></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="weight" id="weight" onkeyup="FormatCurrency(this,event,3)" message="#getLang('','Ağırlık Girmelisiniz',37343)#" class="moneybox">
                            <span class="input-group-addon bold"><cf_get_lang dictionary_id='37188.kg'></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37612.Birim Çarpanı'></label>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <cfinput type="text" name="unit_multiplier" id="unit_multiplier" onkeyup="FormatCurrency(this,event,#xml_multiplier_round#)" class="moneybox">
                    </div><!--- maxlength="6" kaldirildi, ondalik hane degisebilir --->
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
                        <select name="multiplier_static" id="multiplier_static">
                            <option selected value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1"><cf_get_lang dictionary_id='37613.Litre'></option>
                            <option value="2"><cf_get_lang dictionary_id='37188.kg'></option>
                            <option value="3"><cf_get_lang dictionary_id='58082.Adet'></option>
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
                                <option value="#PACKAGE_TYPE_ID#">#PACKAGE_TYPE#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div> 
                <div class="form-group" id="item-package_control_type">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='37768.Paket Kontrol Tipi'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="package_control_type" id="package_control_type">
                            <option value="1"><cf_get_lang dictionary_id ='40429.Kendisi'></option>
                            <option value="2"><cf_get_lang dictionary_id ='37770.Bileşenleri'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-instruction">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45222.Paketleme ve Taşıma Talimatı'></label>  
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="instruction" id="instruction" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42647.Etiket Şablonu'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file"/></div>
                </div>
            </div>
        </cf_box_elements>    
        <cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("control() && loadPopupBox('form_upd_not' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function control()
	{
		x = document.form_upd_not.add_unit_id.selectedIndex;
		if (document.form_upd_not.add_unit_id[x].value == "")
			{
			alert ("<cf_get_lang dictionary_id='37709.Ek Birim Seçmelisiniz'> !");
			return false;
			}
        document.getElementById('multiplier').value = filterNum(document.getElementById('multiplier').value,'<cfoutput>#xml_multiplier_round#</cfoutput>');
        <cfif xml_select_amount eq 1>
        document.getElementById('quantity').value = filterNum(document.getElementById('quantity').value,'<cfoutput>#xml_quantity_round#</cfoutput>');
        </cfif>
		document.getElementById('weight').value = filterNum(document.getElementById('weight').value,3);
		document.getElementById('unit_multiplier').value = filterNum(document.getElementById('unit_multiplier').value,'<cfoutput>#xml_multiplier_round#</cfoutput>');
		if(document.getElementById('multiplier').value == 0)
		{
			alert("<cf_get_lang dictionary_id='37109.Çarpan alanına sıfır değerini giremezsiniz!'>");
			return false;	
		}
		return true;	
	}
	function volume_calculate()
	{
		var a = list_getat(document.getElementById('dimention').value,1,'*');
		var b = list_getat(document.getElementById('dimention').value,2,'*');
		var c = list_getat(document.getElementById('dimention').value,3,'*');
		var volume = a*b*c ;
		eval('form_upd_not.volume').value = volume;
	}
	<cfoutput>
		function hesapla_amount()
		{
			amount_ = filterNum(document.getElementById('quantity').value,#xml_quantity_round#);
			document.getElementById('multiplier').value = commaSplit(1/amount_,#xml_multiplier_round#);
		}
	</cfoutput>
</script>
