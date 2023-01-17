<cfparam name="attributes.layout_id" default="">
<cfparam name="attributes.order_layout_id" default="">
<cfquery name="get_layouts" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES_LAYOUTS_NEW
</cfquery>
<cfquery name="get_my_layout" datasource="#dsn_dev#">
	SELECT * FROM  SEARCH_TABLES_DEFINES
</cfquery>

<cfif get_my_layout.recordcount>
	<cfset attributes.layout_id = get_my_layout.layout_id>
    <cfset attributes.order_layout_id = get_my_layout.order_layout_id>
</cfif>
<cfform name="add_form" action="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
       
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-layout_id">
                        <label class="col col-4 col-sm-12">b2b <cf_get_lang dictionary_id='32796.Görünüm'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="layout_id" id="layout_id">
                                <option value=""><cf_get_lang dictionary_id='32796.Görünüm'></option>
                                <cfoutput query="get_layouts">
                                    <option value="#layout_id#" <cfif attributes.layout_id eq layout_id>selected</cfif>>#layout_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-order_layout_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61674.Sipariş Görünüm'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="order_layout_id" id="order_layout_id">
                                <option value=""><cf_get_lang dictionary_id='32796.Görünüm'></option>
                                <cfoutput query="get_layouts">
                                    <option value="#layout_id#" <cfif attributes.order_layout_id eq layout_id>selected</cfif>>#layout_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-hover_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61676.Işıklandırma Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="hover_color" value="#get_my_layout.hover_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-row_focus_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61677.Seçili Satır Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="row_focus_color" value="#get_my_layout.row_focus_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-focus_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61678.Seçili Kolon Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="focus_color" value="#get_my_layout.focus_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-group_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61680.Gruplama Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="group_color" value="#get_my_layout.group_color#" width="50">
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-group_font_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61681.Gruplama Yazı Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="group_font_color" value="#get_my_layout.group_font_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-stock_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61682.Stok Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="stock_color" value="#get_my_layout.stock_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61683.Departman Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="department_color" value="#get_my_layout.department_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-active_price_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61684.Geçerli Fiyat Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="active_price_color" value="#get_my_layout.active_price_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-next_price_color">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61685.İleri Tarihli Fiyat Rengi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_color_picker name="next_price_color" value="#get_my_layout.next_price_color#" width="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-order_day">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61686.Sipariş Kapama'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="order_day" id="order_day">
                                <cfloop from="1" to="90" index="cc">
                                    <cfoutput><option value="#cc#" <cfif get_my_layout.order_day eq cc>selected</cfif>>#cc# Gün</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>
        </cf_box_elements>
        <cf_box_footer>
                  <cf_workcube_buttons>
        </cf_box_footer>
  
    </cf_box>
</div>
</cfform>


