<div style="position:absolute; margin-top:50px;" id="showCategory"></div>
<cfform name="upd_product" method="post" enctype="multipart/form-data">
    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
    <cfif attributes.event eq 'det'>
        <input type="hidden" name="is_catalog" id="is_catalog" value="0" />
    <cfelse>
        <input type="hidden" name="is_catalog" id="is_catalog" value="1" />
    </cfif>

    <div class="row">
        <div class="col col-12 uniqueRow" id="content">
            <div class="portBox portBottom">
                <div class="portHeadLight font-green-sharp">
                    <span><cfoutput>#listfirst(pageHead, ":")#</cfoutput></span>
                </div>
                <div class="portBoxBodyStandart">
                    <div class="col col-12 uniqueRow">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <!--- col 1 --->
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                    <div class="form-group" id="item-sort">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1512.Sıralama'></label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="sort" id="sort" value="<cfoutput>#getProduct.sort#</cfoutput>" style="width:30px;" maxlength="2" onKeyup="isNumber(this);" onblur="isNumber(this);"/>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-company_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='246.Üye'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getProduct.company_id#</cfoutput>">
                                            <div class="input-group">
                                                <input type="text" name="company_name" id="company_name" value="<cfoutput>#getProduct.fullname#</cfoutput>" style="width:200px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1\'','MEMBER_PARTNER_NAME2,PARTNER_ID,COMPANY_ID','partner_name,partner_id,company_id','','3','250');" autocomplete="off">
                                                <div class="input-group-addon">
                                                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_product.company_id&field_comp_name=upd_product.company_name&field_id=upd_product.partner_id&field_name=upd_product.partner_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(upd_product.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-product_keyword">
                                        <label class="col col-4 col-xs-12"><cf_get_lang no='11.Anahtar Kelime'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="product_keyword" id="product_keyword" maxlength="250" value="<cfoutput>#getProduct.product_keyword#</cfoutput>" style="width:200px;"/>
                                        </div>
                                    </div>
                                    
                                </div>
                                <!--- col 2 --->
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                    <div class="form-group" id="item-product_status">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='81.Aktif'></label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="checkbox" name="product_status" id="product_status" <cfif getProduct.product_status eq 1>checked</cfif>>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-partner_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='166.Yetkili'></label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#getProduct.partner_id#</cfoutput>">
					                        <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#getProduct.partner_name#</cfoutput>" style="width:200px;" readonly>
                                        </div>
                                    </div>
                                    <cfif attributes.event eq 'det'>
                                        <div class="form-group" id="item-product_brand">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="product_brand" id="product_brand" value="<cfoutput>#getProduct.brand_name#</cfoutput>" maxlength="150" style="width:200px;"/>
                                            </div>
                                        </div>
                                    </cfif>
                                </div>
                                <!--- col 3 --->
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                    <div class="form-group" id="item-is_homepage">
                                        <label class="col col-4 col-xs-12"><cf_get_lang no='227.Anasayfa'></label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="checkbox" name="is_homepage" id="is_homepage" value="1" <cfif getProduct.is_homepage is 1>checked</cfif>>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-product_stage">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_workcube_process is_upd='0' select_value='#getProduct.product_stage#' process_cat_width='200' is_detail='1'>
                                        </div>
                                    </div>
                                    <cfif attributes.event eq 'det'>
                                        <div class="form-group" id="item-product_code">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1388.Ürün Kodu'></label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="text" name="product_code" id="product_code" value="<cfoutput>#getProduct.product_code#</cfoutput>" maxlength="150" style="width:200px;"/>
                                            </div>
                                        </div>
                                    </cfif>
                                </div>
                                <!--- col 4 --->
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                    <div class="form-group" id="item-product_cat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Kategori'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <cfoutput>
                                                <cfset hierarchy_ = "">
                                                <cfset new_name = "">
                                                <cfloop list="#getProduct.HIERARCHY#" delimiters="." index="hi">
                                                    <cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
                                                    <cfquery name="getCat" datasource="#dsn1#">
                                                        SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#hierarchy_#'
                                                    </cfquery>
                                                    <cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
                                                </cfloop>
                                                <cfset productCatId = getProduct.product_catid>
                                                <cfset productCatName = new_name>
                                                <input type="hidden" name="product_catid" id="product_catid" value="#productCatId#" />
                                                <div class="input-group">
                                                    <input type="text" name="product_cat" id="product_cat" style="width:300px;font-size:bold; " value="#productCatName#" readonly="" onClick="goster(showCategory);openProductCat();"/>
                                                    <div class="input-group-addon">
                                                        <a href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                                    </div>
                                                </div>
                                            </cfoutput>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-product_name">
                                        <label class="col col-4 col-xs-12"><cfif attributes.event eq 'det'><cf_get_lang_main no='809.Ürün Adı'><cfelse><cf_get_lang no='228.Katalog Adı'></cfif>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="product_name" id="product_name" value="<cfoutput>#getProduct.product_name#</cfoutput>" maxlength="250" style="width:200px;"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row" type="row">
                                <div class="col col-6 col-xs-12" type="column" index="5" sort="true">
                                    <div class="form-group" id="item-description">
                                        <label class="col col-2 col-xs-12"><cf_get_lang_main no='640.Özet'> *</label>
                                        <div class="col col-10 col-xs-12">
                                            <textarea 
                                                style="width:100%; height:75px;" 
                                                name="description" 
                                                id="description" 
                                                onChange="counter();return ismaxlength(this);"
                                                onkeydown="counter();return ismaxlength(this);" 
                                                onkeyup="counter();return ismaxlength(this);" 
                                                onBlur="return ismaxlength(this);" ><cfoutput>#getProduct.product_description#</cfoutput></textarea>
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
                                    <cfmodule
                                        template="/fckeditor/fckeditor.cfm"
                                        toolbarSet="mailcompose"
                                        basePath="/fckeditor/"
                                        instanceName="product_detail"
                                        valign="top"
                                        value="#getProduct.product_detail#"
                                        width="600"
                                        height="300">
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
                            <div class="col col-6 col-xs-12" type="column" index="7" sort="true">
                                <div class="form-group">
                                    <div class="col col-8 col-xs-12">
                                        <cfoutput>
                                            <cf_get_lang_main no='71.Kayıt'> : 
                                            <cfif getProduct.record_member_type is 'employee'> #get_emp_info(getProduct.record_member,0,0)# - <cfelse>#get_par_info(getProduct.record_member,0,-1,0)# - </cfif>
                                            #dateformat(date_add('h',session.ep.time_zone,getProduct.record_date),"dd/mm/yyyy")# (#timeformat(date_add('h',session.ep.time_zone,getProduct.record_date),"HH:MM")#) &nbsp;
                                            <br/>
                                            <cfif len(getProduct.update_member)>
                                                <cf_get_lang_main no='291.Son Güncelleme'>: 
                                                <cfif getProduct.update_member_type is 'employee'>#get_emp_info(getProduct.update_member,0,0)# - <cfelse>#get_par_info(getProduct.update_member,0,-1,0)# - </cfif>
                                                <cfif len(getProduct.update_date)>#dateformat(date_add('h',session.ep.time_zone,getProduct.update_date),"dd/mm/yyyy")# (#timeformat(date_add('h',session.ep.time_zone,getProduct.update_date),"HH:MM")#)</cfif>
                                            </cfif>
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-xs-12" type="column" index="8" sort="true">
                                <div class="form-group">
                                    <div class="col col-12">
                                        <cfif session.ep.admin eq 1>
                                            <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['del']##attributes.pid#' add_function='kontrol()'>
                                        <cfelse>
                                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>