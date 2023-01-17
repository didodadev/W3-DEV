<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.start_date_order" default="">
<cfparam name="attributes.finish_date_order" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.stock_id_" default="">
<cfparam name="attributes.product_id_" default="">
<cfparam name="attributes.product_name" default="">


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset path = "#upload_folder#product#dir_seperator#">
<cfobject name="production_req" type="component" component="WBP.Fashion.files.cfc.production_req">
<cfset query_sample_request_type = production_req.get_sample_request_type()>
<cfset request_typeidlist=valuelist(query_sample_request_type.opportunity_type_id)>
<cfset request_typelist=valuelist(query_sample_request_type.opportunity_type)>

<cfform name="product_filter" method="post">
    <input type="hidden" name="is_search" value="1">
    <cf_big_list_search title="Malzeme İhtiyaçları">
        <cf_big_list_search_area>
            <div class="row form-inline">
                <div class="form-group">
                    <div class="input-group x-10">
                        <input type="text" name="keyword" id="keyword" placeholder="Filtre" value="<cfoutput>#attributes.keyword#</cfoutput>">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group x-3_5">
                        <input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button>
                </div>
            </div>
        </cf_big_list_search_area>
        <cf_big_list_search_detail_area>
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-">
                                <label class="col col-4 col-xs-12">Proje</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkProject
                                        project_Id="#attributes.project_id#"
                                        width="90"
                                        AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
                                        boxwidth="600"
                                        boxheight="400">
                                </div>
                            </div>
                            <div class="form-group" id="item-position_name">
                                <label class="col col-4 col-xs-12">Sorumlu</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                                        <input type="text" name="position_name" id="position_name" style="width:90px;" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onFocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=product_filter.position_code&field_name=product_filter.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.product_filter.position_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-member_name">
                                <label class="col col-4 col-xs-12">Cari Hesap</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                                        <input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                        <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                                        <input type="text" name="member_name" id="member_name"  value="<cfoutput>#attributes.member_name#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,CONSUMER_ID,MEMBER_TYPE','company_id,consumer_id,member_type','','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=product_filter.consumer_id&field_comp_id=product_filter.company_id&field_member_name=product_filter.member_name&field_type=product_filter.member_type&select_list=7,8&keyword='+encodeURIComponent(document.product_filter.member_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-category_name">
                                <label class="col col-4 col-xs-12">Kategori</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="category" id="category" value="<cfif len(attributes.category) and len(attributes.category_name)><cfoutput>#attributes.category#</cfoutput></cfif>">
                                        <input type="text" name="category_name" id="category_name" style="width:90px;" onFocus="AutoComplete_Create('category_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','category','','3','125');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=product_filter.category&field_name=product_filter.category_name</cfoutput>','list');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-spect_name">
                                <label class="col col-4 col-xs-12">Spekt</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
                                        <input style="width:90px;" type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>">
                                        <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="product_control();"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_name">
                                <label class="col col-4 col-xs-12">Ürün</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="stock_id_" id="stock_id_" value="<cfoutput>#attributes.stock_id_#</cfoutput>">
                                        <input type="hidden" name="product_id_" id="product_id_" value="<cfoutput>#attributes.product_id_#</cfoutput>">
                                        <input type="text"   name="product_name" id="product_name" style="width:90px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id_,stock_id_','','3','225','get_tree()');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_spect_main_id=product_filter.spect_main_id&field_spect_main_name=product_filter.spect_name&field_id=product_filter.stock_id_&product_id=product_filter.product_id_&field_name=product_filter.product_name&keyword='+encodeURIComponent(document.product_filter.product_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-date_order">
                                <label class="col col-4 col-xs-12">Sipariş Tarihi</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input maxlength="10" type="text" name="start_date_order" id="start_date_order"  validate="#validate_style#" style="width:65px;" value="<cfoutput>#dateformat(attributes.start_date_order,dateformat_style)#</cfoutput>">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date_order"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <input maxlength="10" type="text" name="finish_date_order" id="finish_date_order" value="<cfoutput>#dateformat(attributes.finish_date_order,dateformat_style)#</cfoutput>" validate="#validate_style#" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_order"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-start_date">
                                <label class="col col-4 col-xs-12">Teslim Tarihi</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input maxlength="10" type="text" name="start_date" id="start_date" validate="#validate_style#" style="width:65px;" value="<cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput>">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <input maxlength="10" type="text" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput>" validate="#validate_style#" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </cf_big_list_search_detail_area>
    <cf_big_list_search>
</cfform>
<cfif isDefined("attributes.is_search")>
<cfset query_list = production_req.get_prodreq_list(attributes.project_id, attributes.company_id, attributes.consumer_id, attributes.start_date_order, attributes.finish_date_order, attributes.start_date, attributes.finish_date)>
<cfset list_companies = replace( listRemoveDuplicates( valueList( query_list.COMPANY_ID ) ), ",,", "," )>
<cfset list_consumers = replace( listRemoveDuplicates( valueList( query_list.CONSUMER_ID ) ), ",,", "," )>
<cfset query_companies = production_req.get_company_names(list_companies, list_consumers)>
</cfif>
<cf_big_list>
    <thead>
        <tr>
            <th></th>
            <th>S.NO</th>
            <th>Resim</th>
            <th>Sipariş</th>
            <th>Tarih</th>
            <th>Numune Kategori</th>
            <th>Ürün Kodu</th>
            <th>Ürün</th>
            <th>Müşteri Order No</th>
            <th>Cari Hesap</th>
            <th>Proje</th>
            <th>Proje Cari Hesap****</th>
            <th>Miktar</th>
            <th>Birim</th>
            <th>Marj</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <cfif isDefined("attributes.is_search")>
        <cfoutput query="query_list">
        <tr>
            <td></td>
            <td>#currentrow#</td>
            <td>
                <cfset assetFileName=asset_file_name>
                <cfset asset_id=asset_id>
                <cfset assetcat_id=assetcat_id>
                <cfset file_path = '#path##assetFileName#'>
                <cfif len(assetFileName) and FileExists(file_path)>
                    <cfif len(assetFileName) and FileExists("#uploadFolder#thumbnails/middle/#assetFileName#")>
                        <cfset imagePath = "documents/thumbnails/middle/#assetFileName#">
                    <cfelse>
                        <cfset imagePath = "documents/thumbnails/middle/#assetFileName#" />
                    </cfif>
                    <cfset icon = false>
                <cfelse>
                    <cfset imagePath = "images/intranet/no-image.png">
                    <cfset icon = true>
                </cfif>
                <div class="image">
                    <cfif icon>
                        <img src="#imagePath#" style="margin-left: 10px; width:70px; height:50px;">
                    <cfelse>
                    <cfset ext=lcase(listlast(assetFileName, '.')) />
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##assetFileName#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
                            <img src="#imagePath#" style="margin: 10px; width:100px;" >
                        </a>
                    </cfif>
                </div>
            </td>
            <td style="white-space: nowrap"><a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#">#order_number#</a></td>
            <td>#dateformat(order_date, dateformat_style)#</td>
            <td><cfif req_type_id gt 0>#ListGetAt(request_typelist,ListFind(request_typeidlist,req_type_id))#</cfif></td>
            <td>#product_code#</td>
            <td>#product_name#</td>
            <td>#company_order_no#</td>
            <td>
                <cfif len(company_id)>
                    <cfset ctype = 1>
                    <cfset cid = company_id>
                <cfelse>
                    <cfset ctype = 2>
                    <cfset cid = consumer_id>
                </cfif>
                <cfquery name="query_line_company" dbtype="query">
                    SELECT FULLNAME FROM query_companies WHERE CTYPE = #ctype# AND COMPANY_ID = #cid#
                </cfquery>
                #query_line_company.FULLNAME#
            </td>
            <td>#project_head#</td>
            <td>#project_company#</td>
            <td>#len(amount)?tlformat(amount,2):''#</td>
            <td>#add_unit#</td>
            <td>#margin#</td>
            <td><a href="/index.cfm?fuseaction=textile.product_requirements&event=det&prodreqid=#PRODREQID#"><i class="fa fa-external-link"></i></a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="10">Filtre Yapınız</td>
        <tr>
    </cfif>
    </tbody>
</cf_big_list>