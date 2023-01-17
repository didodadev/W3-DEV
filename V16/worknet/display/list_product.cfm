<div style="position:absolute; margin:35px; left:400px;" id="showCategory"></div>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.product_status" default="">
<cfparam name="attributes.is_catalog" default="">
<cfparam name="attributes.product_stage" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<!--- urun ve katalog, ayni sayfada calistigindan ayirt etmek adina fuseaction kontrolu konuldu --->
<cfif attributes.fuseaction contains 'product'>
	<cfset attributes.is_catalog = 0>
<cfelse>
	<cfset attributes.is_catalog = 1>
</cfif>
	
<cfset getProcess = createObject("component","V16.worknet.cfc.worknet_process").getProcess(fuseaction:attributes.fuseaction)/>
<cfif isdefined('attributes.form_submitted')>
	<cfset cmp = createObject("component","V16.worknet.cfc.product") />
	<cfset getProduct = cmp.getProduct(
		keyword:attributes.keyword,
		product_catid:attributes.product_catid,
		product_cat:attributes.product_cat,
		product_status:attributes.product_status,
		company_id:attributes.company_id,
		company_name:attributes.company_name,
		product_stage:attributes.product_stage,
		is_catalog:attributes.is_catalog
	) />
<cfelse>
	<cfset getProduct.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default="#getProduct.recordcount#">
<cfform name="search_product" action="" method="post"> <!---#request.self#?fuseaction=#attributes.fuseaction#--->
	<cfif attributes.is_catalog eq 0>
		<cfset title = "#getLang('main',152)#">
	<cfelse>
		<cfset title = "#getLang('worknet',295)#">
	</cfif> 
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box id="product_search" closable="0" collapsable="0"> 
            <cf_box_search plus="0">
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                        <cfsavecontent variable="message"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:125px;" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group"><!--- Uye Bilgisi --->
                        <cfsavecontent variable="message"><cf_get_lang_main no ='246.Üye'></cfsavecontent>
                        <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                        <input type="text" name="company_name" id="company_name" placeholder="<cfoutput>#message#</cfoutput>" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company_name)><cfoutput>#attributes.company_name#</cfoutput></cfif>" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_product.company_id&field_comp_name=search_product.company_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(search_product.company_name.value),'list','popup_list_pars');"><!--- <img src="/images/plus_thin.gif" border="0" align="absbottom"> ---></span>
                    </div>
                </div>	
                <div class="form-group">
                    <select name="product_stage" id="product_stage">
                        <option value=""><cf_get_lang_main no='70.Aşama'></option>
                        <cfoutput query="getProcess">
                            <option value="#process_row_id#" <cfif attributes.product_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="product_status" id="product_status">
                        <option value=""><cf_get_lang_main no ='344.Durum'></option>
                        <option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
                        <option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group"><!--- Urun Kategorileri --->
                        <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)><cfoutput>#attributes.product_catid#</cfoutput></cfif>" />
                        <input type="text" name="product_cat" id="product_cat" value="<cfif isdefined('attributes.product_cat') and len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput><cfelse><cf_get_lang_main no='155.Ürün Kategorileri'></cfif>" <!---onfocus="goster(showCategory);openProductCat();"--->/>
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi"><!--- <img src="/images/plus_thin.gif" border="0" align="absbottom"> ---></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>   
                <div class="form-group">
                    <div class="input-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_product&event=add"><i class="fa fa-plus"></i></a> 
                </div>
            </cf_box_search>
        </cf_box>
    </div>
</cfform>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="product_list" closable="0" collapsable="0" title=" #title#" add_href="#request.self#?fuseaction=worknet.list_product&event=add"> 
        <cf_grid_list>
            <thead>
                <tr>
                    <th style="width:20px;"><cf_get_lang_main no='75.No'></th>
                    <th></th>
                    <th><cfif attributes.is_catalog eq 0 ><cf_get_lang_main no='245.Ürün'><cfelse><cf_get_lang no='154.Katalog'></cfif><cf_get_lang_main no='485.Adı'></th>
                    <th><cf_get_lang_main no='74.Kategori'></th>
                    <th><i class="fa fa-barcode" style="font-size:24px"></i></th>
                    <!---<th><cf_get_lang_main no='640.Özet'></th>--->
                    <th><cf_get_lang_main no='70.Aşama'></th>
                    <th><cf_get_lang_main no ='344.Durum'></th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id='61344.Pazaryerleri'></th>
                    <th><cf_get_lang_main no='162.Şirket'> - <cf_get_lang_main no='166.Yetkili'></th>
                    <th style="width:20px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_product&event=add" title="<cf_get_lang_main no='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
                </tr>
               </thead>
            <tbody class="trHover">
                <cfif getProduct.recordcount>
                    <cfoutput query="getProduct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfset getCategories = cmp.getProductCat(
                            catid:getProduct.PRODUCT_CATID
                        ) />
                        <cfset getProductWorknet = cmp.getRelationWorknet(
                            pid:getProduct.PRODUCT_ID
                        ) />
                        <tr>
                            <td style="width:30px">
                                #currentrow#
                            </td>
                            <td style="width:52px;" align="center">
                                <cfif len(path)>
                                    <cf_get_server_file output_file="#path#" output_server="#path_server_id#" output_type="0" image_width="30" image_height="30">
                                <cfelse>
                                    <img src="/images/no_photo.gif" width="30" height="30">
                                </cfif>
                            </td>
                            <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=upd&pid=#product_id#">#product_name#</a></td>
                            <td><cfloop query = "getCategories"><cfif getCategories.currentrow eq getCategories.recordcount>#PRODUCT_CAT#<cfelse>#PRODUCT_CAT# - </cfif></cfloop></td>
                            <td title="Barkod"><cf_get_lang_main no='221.Barkod'></td>
                            <!---<td>#product_description#</td>--->
                                <cfset getProductProcess = createObject("component","V16.worknet.cfc.worknet_process").getProcess(fuseaction:'worknet.list_product',process_row_id:getProduct.product_stage)/>
                            <td>#getProductProcess.stage#</td>
                            <td <cfif product_status eq 1>style="color:green;"<cfelseif product_status eq 0>style="color:red;"</cfif>>
                                <cfif product_status eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif>
                            </td>
                            <td style="text-align:center;"><a class="fa fa-link" href="javascript://" onclick="cfmodal('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=popup_addWorknetRelation&pid=#product_id#&form_submitted=1&is_modal=1','warning_modal')" title="<cfloop query = "getProductWorknet"><cfif getProductWorknet.currentrow eq getProductWorknet.recordcount>#WORKNET#<cfelse>#WORKNET# - </cfif></cfloop>"></a></td>
                            <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#company_id#">#fullname#</a> - <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_partner&pid=#partner_id#">#partner_name#</a></td>
                            <td><cfif attributes.fuseaction contains 'product'><a href="index.cfm?fuseaction=worknet.list_product&event=upd&pid=#product_id#" title="<cf_get_lang_main no='52.Güncelle'>"><cfelse><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.detail_catalog&pid=#product_id#" title="<cf_get_lang_main no='52.Güncelle'>"></cfif><i class="fa fa-pencil"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isDefined("attributes.form_submitted")>
                <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.company_id)>
                <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
            </cfif>
            <cfif len(attributes.company_name)>
                <cfset url_str = "#url_str#&company_name=#attributes.company_name#">
            </cfif>
            <cfif len(attributes.product_stage)>
                <cfset url_str = "#url_str#&product_stage=#attributes.product_stage#">
            </cfif>
            <cfif len(attributes.product_status)>
                <cfset url_str = "#url_str#&product_status=#attributes.product_status#">
            </cfif>
            <cfif len(attributes.product_catid)>
                <cfset url_str = "#url_str#&product_catid=#attributes.product_catid#">
            </cfif>
            <cfif len(attributes.product_cat)>
                <cfset url_str = "#url_str#&product_cat=#attributes.product_cat#">
            </cfif>
            <cfif len(attributes.is_catalog)>
                <cfset url_str = "#url_str#&is_catalog=#attributes.is_catalog#">
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction##url_str#">
        </cfif>
        </cf_box>
        
        
</div>



<script language="javascript">
	function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	}
</script>

