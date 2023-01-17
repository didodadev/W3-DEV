<!--- stock_identity_type 1 ise barkod 2 ise stok kodu 3 ise özel kod ile sayım dosyası olusturulmustur 
ek alanlarda dosyada yazılan sıraya uygun olarak seçilebilinir
SPECT_MAIN_ID main spec idsi olacak
DELIVER_DATE 20/10/2007  formatında tarih olacak
SHELF_NUMBER raf kodu olacak ancak dosyada bu varken sayım satırlar tablosuna idsi yazılıyor
--->
<cf_get_lang_set module_name="pos"><!--- sayfanin en altinda kapanisi var --->
  
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('pos',36095,36095)#">
        <cfform name="form_basket" action="#request.self#?fuseaction=#fusebox.circuit#.display_file_phl" method="post" enctype="multipart/form-data">
            <input type="hidden" name="file_format" id="file_format" value="1">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-sm-12">
                            <input type="file" name="uploaded_file" id="uploaded_file" style="width:202px;">
                        </div>    
                    </div>
                    <div class="form-group" id="item-location_in">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57453.Şube'> *</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="location_in" id="location_in">							
                                <input type="hidden" name="department_in" id="department_in">
                                <input type="text" name="txt_departman_in" id="txt_departman_in" style="width:143px;">
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_in&field_id=department_in&field_location_id=location_in<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
                            </div>
                        </div>    
                    </div>
                    <div class="form-group" id="item-seperator_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36086.Belge Ayracı'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="seperator_type" id="seperator_type" style="width:90px;">
                                <option value="59"><cf_get_lang dictionary_id ='36093.Noktalı Virgül'></option>
                                <option value="44"><cf_get_lang dictionary_id ='36094.Virgül'></option>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-stock_identity_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36085.Aktarım Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="stock_identity_type" id="stock_identity_type" style="width:90px;">
                                <option value="1" selected><cf_get_lang dictionary_id='57633.Barkod'></option>
                                <option value="2"><cf_get_lang dictionary_id='57518.Stok Kodu'></option>
                                <option value="3"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-description">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="text" name="description" id="description" style="width:143px;">
                        </div>    
                    </div>
                </div>
                <cfsavecontent variable="select_in_option_value">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <option value="spect_main_id"><cf_get_lang dictionary_id='37354.SPEC MAIN ID'></option>
                    <option value="shelf_code"><cf_get_lang dictionary_id ='36088.RAF'></option>
                    <option value="deliver_date"><cf_get_lang dictionary_id ='36089.SON KULLANMA TARİHİ'></option>
                    <option value="physical_age"><cf_get_lang dictionary_id ='36090.FİZİKSEL YAŞ'></option>
                    <option value="finance_date"><cf_get_lang dictionary_id ='36091.FİNANSAL YAŞ'></option>
                    <option value="cost_price"><cf_get_lang dictionary_id ='58258.MALİYET'></option>
                    <option value="extra_cost"><cf_get_lang dictionary_id ='57175.EK MALİYET'></option>
                    <option value="LOT_NO"><cf_get_lang dictionary_id ='36046.LOT NO'></option>
                </cfsavecontent>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-add_file_format_1">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 1</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_1" id="add_file_format_1" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-add_file_format_2">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 2</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_2" id="add_file_format_2" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-add_file_format_3">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 3</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_3" id="add_file_format_3" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-add_file_format_4">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 4</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_4" id="add_file_format_4" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-add_file_format_5">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 5</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_5" id="add_file_format_5" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-add_file_format_6">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 6</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_6" id="add_file_format_6" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-add_file_format_7">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 7</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_7" id="add_file_format_7" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-add_file_format_8">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36087.Ek Alan'> 8</label>
                        <div class="col col-8 col-sm-12">
                            <select name="add_file_format_8" id="add_file_format_8" style="width:200px;">
                                <cfoutput>#select_in_option_value#</cfoutput>
                            </select>
                        </div>    
                    </div>
                </div>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="4" sort="true">
                    <div class="form-group">
                        <label>
                            <cf_get_lang dictionary_id ='36084.Birimi KG olan satırlar 1000 e bölünerek işlem yapılacaktır Lütfen birimleri KG olan ürünlerinizi dosyalarınıza eklerken miktarları 1000 ile çarpılmış olarak ekleyiniz'><br><cf_get_lang dictionary_id='60351.Ondalık ayracı olarak virgül kullanınız!'>
                        </label>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <input type="button" name="listele" id="listele" value="<cf_get_lang dictionary_id ='58715.Listele'>" onClick="ekle_form_action();">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>    

<script type="text/javascript">
	function ekle_form_action()
	{	
		if(document.form_basket.uploaded_file.value == '')
		{
			alert("<cf_get_lang dictionary_id ='36018.Lütfen Belge Ekleyiniz'>")
			return false;
		}
		if(document.form_basket.department_in.value == '' || document.form_basket.txt_departman_in.value == '')
		{
			alert("<cf_get_lang dictionary_id ='58579.Lütfen Şube Seçiniz'>.")
			return false;
		}
		form_basket.submit();
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
