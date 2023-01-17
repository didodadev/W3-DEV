<cfinclude template="../../config.cfm">
<div style="position:absolute; margin-top:70px;" id="showCategory"></div>
<cfsavecontent variable="pageHead">
    <cfif attributes.event  eq 'add'><cf_get_lang_main no='1613.Ürün Ekle'><cfelse><cf_get_lang no='175.Katalog Ekle'></cfif>
</cfsavecontent>
<cf_catalystHeader>

    <div class="row">
        <div class="col col-12 uniqueRow" id="content">
            
            <cfform name="add_product" id="add_product" method="post" enctype="multipart/form-data">
                <cfif not attributes.event eq 'add'>
                    <input type="hidden" name="is_catalog" id="is_catalog" value="1" />
                <cfelseif attributes.event eq 'add-catalog'>
                    <input type="hidden" name="is_catalog" id="is_catalog" value="0" />
                </cfif>

                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cfoutput>#pageHead#</cfoutput></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <!--- col 1 --->
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                        <div class="form-group" id="item-product_cat">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Kategori'> *</label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="hidden" name="product_catid" id="product_catid" value="" />
                                                <div class="input-group">
                                                    <input type="text" name="product_cat" id="product_cat" style="width:400px;" value="" onfocus="goster(showCategory);openProductCat();" readonly="" />
                                                    <div class="input-group-addon">
                                                        <a href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi"><cf_get_lang_main no="1535.Kategori Seç"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-product_name">
                                            <label class="col col-4 col-xs-12"><cfif attributes.event eq 'add'><cf_get_lang_main no='809.Ürün Adı'><cfelse><cf_get_lang no='228.Katalog Adı'></cfif>*</label>
                                            <div class="col col-8 col-xs-12">
                                                <cfinput type="text" name="product_name" id="product_name" value="" maxlength="250" style="width:400px;"/>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-product_image">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1965.İmaj'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="file" name="product_image" id="product_image" style="width:200px;">
                                            </div>
                                        </div>
                                        
                                    </div>
                                    <!--- col 2 --->
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                        <div class="form-group" id="item-company_name">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='246.Üye'> *</label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="hidden" name="company_id" id="company_id" value="">
                                                <div class="input-group">
                                                    <input name="company_name" type="text" id="company_name" style="width:300px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1\'','MEMBER_PARTNER_NAME2,PARTNER_ID,COMPANY_ID','partner_name,partner_id,company_id','','3','250');" value="" autocomplete="off">
                                                    <div class="input-group-addon">
                                                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_product.company_id&field_comp_name=add_product.company_name&field_id=add_product.partner_id&field_name=add_product.partner_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(add_product.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-product_keyword">
                                            <label class="col col-4 col-xs-12"><cf_get_lang no="11.Anahtar Kelime"> *</label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="" style="width:200px;"/>
                                            </div>
                                        </div>
                                        
                                    </div>
                                    <!--- col 3 --->
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                        <div class="form-group" id="item-partner_name">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='166.Yetkili'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="hidden" name="partner_id" id="partner_id" value="">
                                                <input type="text" name="partner_name" id="partner_name" style="width:200px;"  value="" readonly>
                                            </div>
                                        </div>
                                        <cfif attributes.event eq 'add'>
                                            <div class="form-group" id="item-product_brand">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="product_brand" id="product_brand" value="" maxlength="150" style="width:200px;"/>
                                                </div>
                                            </div>
                                        <cfelse>
                                            <div class="form-group" id="item-product_asset">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no='155.Katalog Belgesi'> *</label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="file" name="product_asset" id="product_asset" style="width:200px;">
                                                </div>
                                            </div>
                                        </cfif>
                                    </div>
                                    <!--- col 4 --->
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                        <div class="form-group" id="item-process">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
                                            <div class="col col-8 col-xs-12">
                                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                                            </div>
                                        </div>
                                        <cfif attributes.event eq 'add'>
                                            <div class="form-group" id="item-product_code">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1388.Ürün Kodu'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="product_code" id="product_code" value="" maxlength="150" style="width:200px;"/>
                                                </div>
                                            </div>
                                        </cfif>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <!--- col 5 --->
                                    <div class="col col-6 col-xs-12" type="column" index="5" sort="true">
                                        <div class="form-group" id="item-description">
                                            <label class="col col-2 col-xs-12"><cf_get_lang_main no="640.Özet"> *</label>
                                            <div class="col col-10 col-xs-12">
                                                <textarea 
                                                    style="width:400px; height:75px;" 
                                                    name="description" 
                                                    id="description" 
                                                    onChange="counter();return ismaxlength(this);"
                                                    onkeydown="counter();return ismaxlength(this);" 
                                                    onkeyup="counter();return ismaxlength(this);" 
                                                    onBlur="return ismaxlength(this);" ></textarea>
                                                <input type="text" name="detailLen"  id="detailLen" size="1"  style="width:25px !important;" value="250" readonly />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang_main no='217.Açıklama'> *</span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-12" type="column" index="6" sort="true">
                                        <div class="form-group" id="item-product_detail">
                                            <div class="col col-12">    
                                                <cfmodule
                                                    template="/fckeditor/fckeditor.cfm"
                                                    toolbarSet="mailcompose"
                                                    basePath="/fckeditor/"
                                                    instanceName="product_detail"
                                                    valign="top"
                                                    value=""
                                                    width="300"
                                                    height="300">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col col-12 uniqueRow">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <div class="col col-12" type="column" index="7" sort="false">
                                    <div class="form-group">
                                        <div class="col col-12">
                                            <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>

        </div>
    </div>
    <script language="javascript">
        function openProductCat()
        {
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
        }
        function kontrol()
        {
            if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
            {
                alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
                document.getElementById('product_cat').focus();
                return false;
            }
            <cfif attributes.fuseaction contains 'product'>
                if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '' )
                {
                    alert('Lütfen üye seçiniz !');
                    document.getElementById('company_name').focus();
                    return false;
                }
            </cfif>
            if(document.getElementById('product_name').value == '')
            {
                alert("<cf_get_lang no ='72.Lütfen Ürün İsmi Giriniz'>!");
                document.getElementById('product_name').focus();
                return false;
            }
            if(document.getElementById('product_keyword').value == '')
            {
                alert("Lütfen ürün anahtar kelime giriniz!");
                document.getElementById('product_keyword').focus();
                return false;
            }
            <cfif attributes.fuseaction contains 'catalog'>
                if(document.getElementById('product_asset').value == '')
                {
                    alert('Lütfen katalog belgesi seçiniz !');
                    document.getElementById('product_asset').focus();
                    return false;
                }
            </cfif>
            if(document.getElementById('description').value == '')
            {
                alert("Lütfen özet bilgisi giriniz!");
                document.getElementById('description').focus();
                return false;
            }
            if(CKEDITOR.instances.product_detail.getData() == '')
            {
                alert("Lütfen açıklama giriniz!");
                return false;
            }
            return true;
        }
        function counter()
         { 
            if (document.add_product.description.value.length > 250) 
              {
                    document.add_product.description.value = document.add_product.description.value.substring(0, 250);
                    alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250");  
               }
            else 
                document.getElementById('detailLen').value = 250 - (document.add_product.description.value.length); 
         } 
    </script>