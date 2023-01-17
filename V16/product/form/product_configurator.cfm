
<cf_xml_page_edit fuseact="product.configurator">
<cfparam name="attributes.modal_id" default="">
<cfif not isdefined("attributes.basket_add_parameters") and not isdefined("attributes.config_id") and not isdefined("attributes.main_config")>
    <style>
        .configs{background-color:#D5D5D5;font-size:15px;cursor:pointer;border-radius:5px;padding:30px;text-align:center;border:5px solid white;}
        .configs:hover {background-color:#7C7C7C;color:white;}      
    </style>
    <cfset url_str="">
    <cfloop index="i" from="2" to="#ListLen(CGI.QUERY_STRING,'&')#">
        <cfif ListGetAt(CGI.QUERY_STRING,i,"&") eq 'draggable=1'><cfbreak></cfif>
        <cfset url_str=url_str&"&"&ListGetAt(CGI.QUERY_STRING,i,"&")>
    </cfloop>
    <cfset cf_box_title=getLang('','Konfigüratör',33920)>
    <cf_box title="#cf_box_title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform id="setup_config" name="setup_config">
            <input type="hidden" name="basket_add_parameters" id="basket_add_parameters" value="<cfoutput>#url_str#</cfoutput>">
            <input type="hidden" name="int_basket_id" id="int_basket_id" value="<cfoutput>#attributes.int_basket_id#</cfoutput>">
            <cfquery name="get_conf" datasource="#dsn3#">
                SELECT
                    * 
                FROM 
                    SETUP_PRODUCT_CONFIGURATOR
                where  CONFIGURATOR_STOCK_ID IS NOT NULL
            </cfquery>
            <cfoutput query="get_conf">
                <div class="col col-3 col-md-3 col-xs-3 configs" id="#PRODUCT_CONFIGURATOR_ID#">
                    #CONFIGURATOR_NAME#
                </div>
            </cfoutput>
        </cfform>
    </cf_box>
<cfelse>

    <cfif not isdefined("attributes.main_config")>
    <cfquery name="get_conf" datasource="#dsn3#">
        SELECT 
            * 
        FROM 
            SETUP_PRODUCT_CONFIGURATOR
        where 
            PRODUCT_CONFIGURATOR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.config_id#">
            and CONFIGURATOR_STOCK_ID IS NOT NULL
    </cfquery>
    <cfif not isdefined("attributes.stock_id")>
        <cfset attributes.stock_id=get_conf.CONFIGURATOR_STOCK_ID>
    </cfif>
</cfif>
    <cfif isdefined("attributes.main_config")>
        <cfset cf_box_style="margin-left:-5px;">
        <cfset cf_box_class="-">
        <cfset cf_box_title="">
    <cfelse>
        <cfset cf_box_class="">
        <cfset cf_box_style="">
        <cfset cf_box_title=getLang('','Konfigüratör',33920)&": "&get_conf.CONFIGURATOR_NAME>
    </cfif>
    <cfsavecontent variable="right_images">
        <li>
        <a onclick="goto_main_page();"><i class="catalyst-puzzle"></i></a>
        </li>
    </cfsavecontent>
    <cfif not isdefined("attributes.main_config")>
        <cf_box title="#cf_box_title#" scroll="1" right_images="#right_images#" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#" class="#cf_box_class#" style="#cf_box_style#">
            <cfif not isdefined("attributes.main_config")> 
                <cf_tab defaultOpen="configurator" divId="configurator,mpc_spect" divLang="#getLang('','Yeni Tasarım',65332)#;MPC Spekt">
                    <div id="unique_configurator" class="uniqueBox">
                        <cfform id="add_spect_variations" name="add_spect_variations">
                            <input type="hidden" name="from_product_config">
                            <cfif not isdefined("attributes.main_config")>
                                <input type="hidden" id="config_id" name="config_id" value="<cfoutput>#attributes.config_id#</cfoutput>">
                            </cfif>
                            <cf_box_elements>
                                <div class="col col-12 col-md-12 col-xs-12">
                                <label><cf_get_lang dictionary_id="57657.Ürün"></label>
                                <div class="form-group">
                                <div class="input-group">
                                    <cfif isdefined("attributes.stock_id")>
                                        <cfquery name="get_stock_name" datasource="#dsn3#">
                                        SELECT PRODUCT_NAME,PROPERTY	
                                        FROM 
                                        STOCKS 
                                        WHERE 
                                        STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                                        </cfquery>
                                    </cfif>
                                    <input type="hidden" name="stock_id" id="stock_id" <cfif isdefined("attributes.stock_id")>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                                    <input type="text" readonly name="urun" id="urun" <cfif isdefined("attributes.stock_id")>value="<cfoutput>#get_stock_name.product_name# - #get_stock_name.PROPERTY#</cfoutput>"</cfif>>
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick='open_product_list_config()'></span>
                                </div>
                                </div>
                                </div>
                            </cf_box_elements>
                            <cfinclude  template="configurator_form.cfm">
                        </cfform>
                    </div>
                    <div id="unique_mpc_spect" class="uniqueBox">
                        <div class="row">
                            <cfinclude  template="../../objects/display/configurator_spect.cfm">
                        </div>
                    </div>
                </cf_tab>
            <cfelse>
                <cfinclude template="configurator_form.cfm">
            </cfif>
        </cf_box>
    <cfelse>
        <cfif not isdefined("attributes.main_config")> 
            <cf_tab defaultOpen="configurator" divId="configurator,mpc_spect" divLang="#getLang('','Yeni Tasarım',65332)#;MPC Spekt">
                <div id="unique_configurator" class="uniqueBox">
                    <cfform id="add_spect_variations" name="add_spect_variations">
                        <input type="hidden" name="from_product_config">
                        <cfif not isdefined("attributes.main_config")>
                            <input type="hidden" id="config_id" name="config_id" value="<cfoutput>#attributes.config_id#</cfoutput>">
                        </cfif>
                        <cf_box_elements>
                            <div class="col col-12 col-md-12 col-xs-12">
                            <label><cf_get_lang dictionary_id="57657.Ürün"></label>
                            <div class="form-group">
                            <div class="input-group">
                                <cfif isdefined("attributes.stock_id")>
                                    <cfquery name="get_stock_name" datasource="#dsn3#">
                                    SELECT PRODUCT_NAME,PROPERTY	
                                    FROM 
                                    STOCKS 
                                    WHERE 
                                    STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="stock_id" id="stock_id" <cfif isdefined("attributes.stock_id")>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                                <input type="text" readonly name="urun" id="urun" <cfif isdefined("attributes.stock_id")>value="<cfoutput>#get_stock_name.product_name# - #get_stock_name.PROPERTY#</cfoutput>"</cfif>>
                                <span class="input-group-addon icon-ellipsis" href="javascript://" onclick='open_product_list_config()'></span>
                            </div>
                            </div>
                            </div>
                        </cf_box_elements>
                        <cfinclude  template="configurator_form.cfm">
                    </cfform>
                </div>
                <div id="unique_mpc_spect" class="uniqueBox">
                    <div class="row">
                        <cfinclude  template="../../objects/display/configurator_spect.cfm">
                    </div>
                </div>
            </cf_tab>
        <cfelse>
            <cfinclude template="configurator_form.cfm">
        </cfif>
    </cfif>
<script>

    function generate_mpc(){
        value = cat.value;
        category = value.split("|");
        value2 = quality.value;
        code = value2.split("|");
        if(category[2] == '1'){    
            mpc.value=category[1]+"."+code[2]+".Ø"+diameter.value;
        }
        else if (category[2] == '16'){
            mpc.value=category[1]+"."+code[2]+"."+size.value+".rØ"+iccap.value+"xrØ"+discap.value;
        }
        else if (category[2] == '9'){
            mpc.value=category[1]+"."+code[2]+".Ø"+diameter.value+"."+size.value;
        }
        else if (category[2] == '10'){
            mpc.value=category[1]+"."+code[2]+"."+width.value+"."+size.value;
        }
        else if (category[2] == '11'){
            mpc.value=category[1]+"."+code[2]+"."+width.value+"."+size.value;
        }
        else if (category[2].length > 0){
            mpc.value=category[1]+"."+code[2]+"."+width.value+"x"+height.value;
        }
    }
   
<cfif not isdefined("attributes.main_config")>
  <cfif isDefined("attributes.stock_id")>add_spect_variations.action="<cfoutput>#formAction#</cfoutput>";</cfif>
  function box_refresh(){
    add_spect_variations.action="<cfoutput>#request.self#</cfoutput>?fuseaction=product.configurator&temp_basket_id=<cfoutput><cfif isdefined("attributes.int_basket_id")>#attributes.int_basket_id#<cfelse>#attributes.temp_basket_id#</cfif></cfoutput>&stock_id="+add_spect_variations.stock_id.value;
    loadPopupBox('add_spect_variations' , <cfoutput>#attributes.modal_id#</cfoutput>);
  }
  
    <cfif isdefined("attributes.from_product_config")>
        url_str=add_spect_variations.basket_add_parameters.value;
    </cfif>
  function open_product_list_config(){
/*     value = cat.value;
    category = value.split("|"); */
    windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products"+url_str+"&from_product_config=1",'page_horizantal');
  }
  </cfif>
  </script>
</cfif>
<script>
 $(".configs").click(function(event) {
    setup_config.action="<cfoutput>#request.self#</cfoutput>?fuseaction=product.configurator&config_id="+event.target.id+"";
    loadPopupBox('setup_config' , <cfoutput>#attributes.modal_id#</cfoutput>);
    });
    function goto_main_page(){
        closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
        control_comp_selected(0,0,1);
    }

  </script>

