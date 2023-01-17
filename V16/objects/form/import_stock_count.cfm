<cf_papers paper_type="STOCK_FIS">
<cf_xml_page_edit fuseact="objects.popup_form_import_stock_count">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32905.Stok Sayımı'></cfsavecontent>
<cfset pageHead=#message#>

	<cfform name="form_basket" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=objects.popup_add_import_stock_count_display">
	<input  type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html"> 
    	<div class="row">
    		<div class="col col-12 uniqueRow">
    			<div class="row formContent">
    				<div class="row" type="row">
    					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group" id="item-seperator_type">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33889.Belge Ayracı'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="seperator_type" id="seperator_type" style="width:200px;">
                                        <option value="59"><cf_get_lang dictionary_id='32874.Noktalı Virgül'></option>
                                        <option value="44"><cf_get_lang dictionary_id='32873.Virgül'></option>
                                    </select>
                                    <input type="hidden" name="x_kg_calculate" id="x_kg_calculate" value="<cfoutput>#x_kg_calculate#</cfoutput>" />
                                </div>
                            </div>
                        	<div class="form-group" id="item-stock_identity_type">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58530.Aktarim Turu'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="stock_identity_type" id="stock_identity_type" style="width:200px;">
                                        <option value="1" selected><cf_get_lang dictionary_id ='57633.Barkod'></option>
                                        <option value="2"><cf_get_lang dictionary_id='57518.Stok Kodu'></option>
                                        <option value="3"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-uploaded_file">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57468.Belge'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-department_location">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> / <cf_get_lang dictionary_id ='30031.Lokasyon'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkdepartmentlocation
                                        returnInputValue="location_id,store,department_id,branch_id"
                                        returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldName="store"
                                        fieldid="location_id"
                                        department_fldId="department_id"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        width="200">
                                </div>
                            </div>
                            <div class="form-group" id="item-date">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'> !</cfsavecontent>
                                        <cfinput type="text" name="process_date" value="" validate="#validate_style#" required="yes" message="#message#" maxlength="10" style="width:65px;">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-add_file_format_1">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33890.Ek Alan'> 1</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="add_file_format_1" id="add_file_format_1" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="SPECT_MAIN_ID"><cf_get_lang dictionary_id='34290.Spec Main Id'></option>
                                        <option value="SHELF_CODE"><cf_get_lang dictionary_id='33891.Raf'></option>
                                        <option value="DELIVER_DATE"><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></option>
                                        <option value="LOT_NO"><cf_get_lang dictionary_id='32916.Lot No'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-add_file_format_2">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33890.Ek Alan'>2</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="add_file_format_2" id="add_file_format_2" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="SPECT_MAIN_ID"><cf_get_lang dictionary_id='34290.Spec Main Id'></option>
                                        <option value="SHELF_CODE"><cf_get_lang dictionary_id='33891.Raf'></option>
                                        <option value="DELIVER_DATE"><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></option>
                                        <option value="LOT_NO"><cf_get_lang dictionary_id='32916.Lot No'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-add_file_format_3">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33890.Ek Alan'>3</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="add_file_format_3" id="add_file_format_3" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="SPECT_MAIN_ID"><cf_get_lang dictionary_id='34290.Spec Main Id'></option>
                                        <option value="SHELF_CODE"><cf_get_lang dictionary_id='33891.Raf'></option>
                                        <option value="DELIVER_DATE"><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></option>
                                        <option value="LOT_NO"><cf_get_lang dictionary_id='32916.Lot No'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-add_file_format_4">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33890.Ek Alan'>4</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="add_file_format_4" id="add_file_format_4" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="SPECT_MAIN_ID"><cf_get_lang dictionary_id='34290.Spec Main Id'></option>
                                        <option value="SHELF_CODE"><cf_get_lang dictionary_id='33891.Raf'></option>
                                        <option value="DELIVER_DATE"><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></option>
                                        <option value="LOT_NO"><cf_get_lang dictionary_id='32916.Lot No'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
    				</div>
                    <div class="row">
                    	<div class="col col-12">
                        	<table>
                                <tr>
                                    <td colspan="2">
                                        <strong><cf_get_lang dictionary_id='34291.Devir sayım import işleminde dosya formatı aşağıdaki gibi olmalıdır'>;</strong><br/>
                                        <cf_get_lang dictionary_id='34292.Aktarım Tipi ( stok kodu, barkod ya da özel kod ) ; Miktar ; Raf Kodu ( Stok alan yönetiminde raflar listesindeki raf kodu bilgisi ) ; Son Kullanma Tarihi ; Main Spec ID	'><br/>
                                        <cf_get_lang dictionary_id='34293.(Raf, son kullanma tarihi ve main spec ID alanları ek alan olarak tanımlanmıştır. Bu alanların hepsinin belgede olması zorunlu değildir ve bu alanlar için belge sıralaması yoktur.'> <cf_get_lang dictionary_id='32397.Sadece raf kodu ya da sadece son kullanma tarihi veya her ikiside belgede olabilir. Ek alan kısımlarından seçilme sırasına göre belgeye eklenmelidir.)'> <br/>
                                        <strong><cf_get_lang dictionary_id='58967.Örnek'>;</strong><br/>
                                        01.01.01.1445;100;75;31/12/2007<br/>
                                        2110000000059;555;10<br/>
                                        150;850<br/>
                                        01.01.01.1445;100;31/12/2007<br/>
                                        300;500;18<br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <font color="red"><cf_get_lang dictionary_id='34294.Birimi Kg olan satırlar 1000 e bölünerek işlem yapılacaktır. Lütfen birimleri KG olan ürünlerinizi dosyalarınıza eklerken miktarları 1000 ile çarpılmış olarak ekleyiniz.'></font>
                                    </td>
                                </tr>
                            </table>
                    	</div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-12">
                        	<cf_workcube_buttons type_format='1' is_upd='0'>
                        </div>
                    </div>
    			</div>
    		</div>
    	</div>
	</cfform>
