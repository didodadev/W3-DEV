<cfinclude template="../../config.cfm">
<cf_get_lang_set module_name="worknet">
<cf_xml_page_edit fuseact="worknet.detail_demand">

<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.demands.demand")>
<cfset getDemand = cmp.getDemand(demand_id:attributes.demand_id)>
<cfset getProductCat = cmp.getProductCat(demand_id:attributes.demand_id) />

<cfsavecontent variable="pageHead">
    <cf_get_lang no="86.Talep Detay"> : <cfoutput>#attributes.demand_id#</cfoutput>
</cfsavecontent>
<cf_catalystHeader>

    <div class="row">
        <div class="col col-9 col-xs-12 uniqueRow">
            <cfform name="upd_demand" enctype="multipart/form-data" method="post">
                <input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>" />
                <div class="portBox portBottom">
                    <div class="portHeadLight font-green-sharp">
                        <span><cf_get_lang no="86.Talep Detay"></span>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="row" type="row">
                                        <!--- col 1 --->
                                        <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                                            <div class="form-group" id="item-is_status">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no="344.Durum"></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="checkbox" value="1" name="is_status" id="is_status" <cfif getDemand.is_status eq 1>checked="checked"</cfif>  /> <cf_get_lang_main no='81.Aktif'>
                                                    <span></span>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-order_member_type">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no="6.Yetkilendirme">*</label>
                                                <div class="col col-8 col-xs-12">
                                                    <label><cf_get_lang no="9. Herkese Açık "><input type="radio" value="1" name="order_member_type" id="order_member_type" <cfif getDemand.order_member_type eq 1>checked="checked"</cfif> /></label>
                                                    <label><cf_get_lang no="10.Üyelerime Açık"><input type="radio" value="2" name="order_member_type" id="order_member_type" <cfif getDemand.order_member_type eq 2>checked="checked"</cfif> /></label>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-partner_id">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='166.Yetkili'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#getDemand.partner_id#</cfoutput>">
                                                    <input type="text" name="partner_name" id="partner_name" style="width:200px;"  value="<cfoutput>#getDemand.partner_name#</cfoutput>" readonly>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-project_id">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no="4.Proje"></label>
                                                <div class="col col-8 col-xs-12">
                                                    <div class="input-group">
                                                    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#getDemand.project_id#</cfoutput>">
                                                    <input type="text" name="project_head"  id="project_head" style="width:300px;" value="<cfoutput>#getDemand.project_head#</cfoutput>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_demand.project_id&project_head=upd_demand.project_head&select_list=2</cfoutput>&keyword='+encodeURIComponent(upd_demand.project_head.value),'list');"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-demand_keyword">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no='11.Anahtar Kelime'> *</label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="demand_keyword" id="demand_keyword" maxlength="250" value="<cfoutput>#getDemand.demand_keyword#</cfoutput>" style="width:400px;"/>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-date">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no='84.Yayın Tarihi'> *</label>
                                                <div class="col col-4 col-sm-12">
                                                    <div class="input-group">
                                                        <input type="text" name="start_date" id="start_date" value="<cfoutput>#dateformat(getDemand.start_date,'dd/mm/yyyy')#</cfoutput>" maxlength="10" style="width:70px;" placeholder="Başlangıç Tarihi">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                                    </div>
                                                </div>
                                                <div class="col col-4 col-sm-12">  
                                                    <div class="input-group">                      
                                                    <input type="text" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(getDemand.finish_date,'dd/mm/yyyy')#</cfoutput>" maxlength="10" style="width:70px;" placeholder="Bitiş Tarihi">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                                    </div>
                                                </div> 
                                            </div>
                                            <div class="form-group" id="item-sector_cat_id">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='167.Sektör'> *</label>
                                                <div class="col col-8 col-xs-12">
                                                    <cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
                                                    <cf_wrk_selectlang 
                                                        name="sector_cat_id"
                                                        option_name="sector_cat"
                                                        option_value="sector_cat_id"
                                                        width="200"
                                                        table_name="SETUP_SECTOR_CATS"
                                                        option_text="#text#" value=#getDemand.SECTOR_CAT_ID#>	
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-total_amount">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='672.Fiyat'></label>
                                                <div class="col col-5 col-sm-12">
                                                    <cfinput type="text" name="total_amount" id="total_amount" value="#tlformat(getDemand.total_amount)#" style="width:90px;" passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
                                                </div>
                                                <div class="col col-3 col-sm-12">
                                                    <cfquery name="GET_MONEYS" datasource="#DSN#">
                                                        SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.period_id#
                                                    </cfquery>
                                                    <select name="money" id="money" style="width:50px;">
                                                        <cfoutput query="get_moneys">
                                                        <option value="#money#"<cfif money is getDemand.money>selected</cfif>>#money#</option>
                                                        </cfoutput>
                                                    </select>								
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-deliver_addres">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1037.Teslim Yeri'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="deliver_addres" id="deliver_addres" value="<cfoutput>#getDemand.deliver_addres#</cfoutput>" style="width:300px;" maxlength="250">
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-ship_method">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1703.Sevk Yöntemi'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="ship_method" id="ship_method" value="<cfoutput>#getDemand.ship_method#</cfoutput>" style="width:300px;" maxlength="250">
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-colour">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no='236.Renk'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="colour" id="colour" value="<cfoutput>#getDemand.colour#</cfoutput>" style="width:300px;" maxlength="150" >
                                                </div>
                                            </div>
                                        </div>
                                        <!--- col 2 --->
                                        <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                                            <div class="form-group" id="item-demand_type">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no="81.Talep Türü">*</label>
                                                <div class="col col-8 col-xs-12">
                                                    <label><cf_get_lang no="13.Alış Talebi"><input type="radio" value="1" name="demand_type" id="demand_type" <cfif getDemand.demand_type eq 1>checked="checked"</cfif> /></label>
                                                    <label><cf_get_lang no="16.Satış Talebi"><input type="radio" value="2" name="demand_type" id="demand_type" <cfif getDemand.demand_type eq 2>checked="checked"</cfif> /></label>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-company_id">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='246.Üye'>*</label>
                                                <div class="col col-8 col-xs-12">
                                                    <div class="input-group">
                                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getDemand.company_id#</cfoutput>">
                                                    <input name="company_name" type="text" id="company_name"  class="form-control input-inline input-medium" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1\'','MEMBER_PARTNER_NAME2,PARTNER_ID,COMPANY_ID','partner_name,partner_id,company_id','','3','250');" value="<cfoutput>#getDemand.fullname#</cfoutput>" autocomplete="off">
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_demand.company_id&field_comp_name=upd_demand.company_name&field_id=upd_demand.partner_id&field_name=upd_demand.partner_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(upd_demand.company_name.value),'list','popup_list_pars');"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-stage_id">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
                                                <div class="col col-8 col-xs-12">
                                                    <cf_workcube_process is_upd='0' select_value='#getDemand.stage_id#' process_cat_width='200' is_detail='1'>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-demand_head">
                                                <label class="col col-4 col-xs-12"><cf_get_lang no='88.Talep'> *</label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="demand_head" id="demand_head" value="<cfoutput>#getDemand.demand_head#</cfoutput>" maxlength="200" style="width:400px;"/>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-product_category">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='155.Ürün Kategorileri'> *</label>
                                                <div class="col col-8 col-xs-12">
                                                <select name="product_category" id="product_category" style="width:400px; height:60px;" multiple>
                                                    <cfif getProductCat.recordcount>
                                                        <cfoutput query="getProductCat">
                                                            <cfset hierarchy_ = "">
                                                            <cfset new_name = "">
                                                            <cfloop list="#HIERARCHY#" delimiters="." index="hi">
                                                                <cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
                                                                <cfquery name="getCat" datasource="#dsn1#">
                                                                    SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#hierarchy_#'
                                                                </cfquery>
                                                                <cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
                                                            </cfloop>
                                                            <option value="#product_catid#">#new_name#</option>
                                                        </cfoutput>
                                                    </cfif>
                                                </select>
                                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.upd_demand.product_category','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
                                                <a href="javascript://" onClick="remove_field('product_category');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-deliver_date">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='233.Teslim Tarihi'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <div class="input-group">
                                                    <input type="text" name="deliver_date" id="deliver_date" value="<cfoutput>#dateformat(getDemand.deliver_date,'dd/mm/yyyy')#</cfoutput>" maxlength="10" style="width:70px;">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-paymethod">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="paymethod" id="paymethod" value="<cfoutput>#getDemand.paymethod#</cfoutput>" style="width:300px;" maxlength="250">
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-quantity">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='223.Miktar'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <cfinput type="text" name="quantity" id="quantity" value="#TLFormat(getDemand.quantity)#" passThrough="onkeyup=""return(FormatCurrency(this,event));""" style="width:70px;" maxlength="50">
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-demand_kind">
                                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='519.Cins'></label>
                                                <div class="col col-8 col-xs-12">
                                                    <input type="text" name="demand_kind" id="demand_kind" value="<cfoutput>#getDemand.type#</cfoutput>" style="width:300px;" maxlength="150" >
                                                </div>
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
                                                    template="../../../../../fckeditor/fckeditor.cfm"
                                                    toolbarSet="mailcompose"
                                                    basePath="/fckeditor/"
                                                    instanceName="demand_detail"
                                                    valign="top"
                                                    value="#getDemand.detail#"
                                                    width="100%"
                                                    height="260">
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
                                <div class="col col-6 col-xs-12">
                                    <cf_record_info query_name="getDemand" record_emp="record_member" update_emp="update_member" is_partner='1'>
                                </div>
                                <div class="col col-6 col-xs-12">
                                    <cfif session.ep.admin eq 1 >
                                        <cf_workcube_buttons is_upd='1' is_delete="1" delete_page_url='#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['del']['fuseaction']##attributes.demand_id#' add_function="kontrol()">
                                    <cfelse>
                                        <cf_workcube_buttons is_upd='1' is_delete="0"  add_function="kontrol()">
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
        </div>
        <div class="col col-3 col-xs-12 uniqueRow">
            <div class="row">
                <!--- Yan kısım--->
                <cfsavecontent variable="text"><cf_get_lang_main no='156.Belgeler'></cfsavecontent>
                <cf_box id="relation_assets" title="#text#" closable="0" style="width:98%;" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-relation-asset']['fuseaction']#&action_id=#attributes.demand_id#&action_section=DEMAND_ID&asset_cat_id=-11"
                    add_href="AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add-relation-asset']['fuseaction']#&action_id=#attributes.demand_id#&action_section=DEMAND_ID&asset_cat_id=-11','body_relation_assets',0,'Loading..')">
                </cf_box>
            </div>
        </div>
        <div class="col col-9 col-xs-12">
            <cfsavecontent variable="teklif"><cf_get_lang no ='90.Teklifler'></cfsavecontent>
                <cf_box id="offer" title="#teklif#" closable="0" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-offer']['fuseaction']##attributes.demand_id#" add_href="javascript:windowopen('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add-offer']['fuseaction']##attributes.demand_id#', 'list', 'offer')">
                </cf_box>
        </div>
    </div>

    <script language="javascript">
        function select_all(selected_field)
        {
            var m = eval("document.upd_demand." + selected_field + ".length");
            for(i=0;i<m;i++)
            {
                eval("document.upd_demand."+selected_field+"["+i+"].selected=true");
            }
        }
        function remove_field(field_option_name)
        {
            field_option_name_value = document.getElementById(field_option_name);
            for (i=field_option_name_value.options.length-1;i>-1;i--)
            {
                if (field_option_name_value.options[i].selected==true)
                {
                    field_option_name_value.options.remove(i);
                }	
            }
        }
        
        function kontrol()
        {	
            //alert(FCKeditorAPI.GetInstance('demand_detail').GetHTML(true));
            
            select_all('product_category');
            document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value);
            document.getElementById('quantity').value = filterNum(document.getElementById('quantity').value);
    
            if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '' )
            {
                alert('Lütfen üye seçiniz !');
                document.getElementById('company_name').focus();
                return false;
            }
            if(document.getElementById('demand_head').value == '')
            {
                alert("Lütfen talep adı giriniz !");
                document.getElementById('demand_head').focus();
                return false;
            }
            if(document.getElementById('product_category').value == '' )
            {
                alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
                document.getElementById('product_category').focus();
                return false;
            }
            if(document.getElementById('demand_keyword').value == '')
            {
                alert("Lütfen talep anahtar kelime giriniz!");
                document.getElementById('demand_keyword').focus();
                return false;
            }
            
            if(CKEDITOR.instances.demand_detail.getData() == '')
            {
                alert("Lütfen açıklama giriniz!");
                return false;
            }
            
            if(document.getElementById('start_date').value == '' || document.getElementById('finish_date').value == '')
            {
                alert("Lütfen yayın tarihi giriniz!");
                document.getElementById('start_date').focus();
                return false;
            }
            
            if (!date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"Yayın bitiş tarihi başlangıç tarihinden önce olamaz !"))
            return false;
            
            
            if(document.getElementById('sector_cat_id').value == '')
            {
                alert("Lütfen sektör seçiniz!");
                document.getElementById('sector_cat_id').focus();
                return false;
            }
        }
    </script>
    
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    