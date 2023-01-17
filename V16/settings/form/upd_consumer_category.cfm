<cf_xml_page_edit fuseact="settings.form_add_consumer_categories">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_consumer_cats.cfm">
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="GET_CATEGORY_SITE_DOMAIN" datasource="#DSN#">
	SELECT 
    	CATEGORY_ID, 
        MENU_ID, 
        MEMBER_TYPE 
    FROM 
    	CATEGORY_SITE_DOMAIN 
    WHERE 
	    MEMBER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="Consumer"> AND 
        CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery><!--- Tabloda Üç Alan var, yıldız işreti kalmasının mahsuru yok --->
<cfquery name="GET_CONSUMER_CAT_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
    	ID, 
        CONSCAT_ID, 
        OUR_COMPANY_ID 
    FROM 
    	CONSUMER_CAT_OUR_COMPANY 
    WHERE 
	    CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery><!--- Tabloda Üç Alan var, yıldız işreti kalmasının mahsuru yok --->
<cfset our_comp_list = valuelist(get_consumer_cat_our_companies.our_company_id)>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_consumer_categories" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_consumer_categories.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="consumer_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_consumer_cat">
                <input type="hidden" name="conscat_id" id="conscat_id" value="<cfoutput>#url.id#</cfoutput>">
        		<cf_box_elements>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="conscat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="conscat" id="conscat" size="60" value="#get_consumer_cat.conscat#" maxlength="50" required="Yes" message="#getLang('','Kategori Adı Girmelisiniz',58555)#!">
                                        <span class="input-group-addon">
                                            <cf_language_info 
                                            table_name="CONSUMER_CAT" 
                                            column_name="CONSCAT" 
                                            column_id_value="#url.id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="CONSCAT_ID" 
                                            control_type="0">
                                        </span>
                                    </div>
                                </div>
						</div>
                        <div class="form-group" id="account-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42329.Sorumlu Pozisyon'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_consumer_cat.position_code#</cfoutput>">
                                    <cfif len(get_consumer_cat.position_code)>
                                        <cfset attributes.position_code = get_consumer_cat.position_code>
                                        <cfinclude template="../query/get_position.cfm">
                                        <cfset position = "#get_position.employee_name# #get_position.employee_surname#">
                                    <cfelse>
                                        <cfset position = "">
                                    </cfif>
                                    <input type="text" name="position" id="position" value="<cfoutput>#position#</cfoutput>" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=consumer_cat.position_code&field_name=consumer_cat.position','list');"></span>
                                </div>
                            </div>
						</div>
                        <div class="form-group" id="related_comp">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cf_multiselect_check
                                        name="our_company_ids"
                                        option_name="nick_name"
                                        option_value="comp_id"
                                        table_name="OUR_COMPANY"
                                        value="iif(#listlen(our_comp_list)#,#our_comp_list#,DE(''))">
                                </div>
						</div>
                        <div class="form-group" id="min_cons_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44409.Min. Bağlanabilecek Üye Kategorisi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="min_cons_cat" id="min_cons_cat">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_consumer_cats">
                                            <option value="#conscat_id#" <cfif get_consumer_cat.min_conscat_id eq conscat_id>selected</cfif>>#conscat#</option>
                                        </cfoutput>
                                    </select>
								</div>
						</div>
                        <div class="form-group" id="max_cons_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41997.Max. Bağlanabilecek Üye Kategorisi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="max_cons_cat" id="max_cons_cat">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_consumer_cats">
                                            <option value="#conscat_id#" <cfif get_consumer_cat.max_conscat_id eq conscat_id>selected</cfif>>#conscat#</option>
                                        </cfoutput>
                                    </select>
								</div>
						</div>
                        <div class="form-group" id="short_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57751.Kısa Ad'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput type="text" name="short_name" id="short_name" value="#get_consumer_cat.short_name#" maxlength="15">
								</div>
						</div>
                        <div class="form-group" id="hierarchy">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput type="text" name="hierarchy" id="hierarchy"  onKeyup="isNumber(this);" maxlength="5" onblur="isNumber(this);" value="">
								</div>
						</div>
						<cfif is_risk_limit_required eq 1>
							<div class="form-group" id="risk_limit">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45097.Risk Limiti'>*</label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cfoutput query="get_consumer_cat">
                                            <input type="text" name="risk_limit" id="risk_limit" value="#TLFormat(risk_limit)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox"  message="#getLang('','Lütfen Risk Limiti Giriniz',52032)#!"/>
                                        </cfoutput>
									</div>
							</div>
						</cfif>
                    </div>
					<div  class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
							<div class="form-group" id="is_active">
								<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_consumer_cat.is_active eq 1>checked</cfif>>
                                </div>	
							</div>
                        <div class="form-group" id="is_internet">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='43008.İnternette Göster'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_internet" id="is_internet" value="1" onClick="gizle_goster(is_site_display);"<cfif get_consumer_cat.is_internet eq 1>checked</cfif>>
                                </div>
						</div>
                        <div class="form-group" id="is_premium">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='43809.Prim Alamaz'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_premium" id="is_premium" <cfif get_consumer_cat.is_premium eq 1> checked</cfif>>
                                </div>
						</div>
                        <div class="form-group" id="is_ref_order">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='44545.Referans Olduğu Temsilcilerin Siparişlerini Girebilir'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_ref_order" id="is_ref_order" <cfif get_consumer_cat.is_ref_order eq 1> checked</cfif>>
                                </div>
						</div>
                        <div class="form-group" id="is_ref_record">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='42348.Referans Üye Olarak Seçilebilir'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_ref_record" id="is_ref_record" <cfif get_consumer_cat.is_ref_record eq 1> checked</cfif>>
                                </div>
						</div>
                        <div class="form-group" id="is_default">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='43115.Standart Seçenek Olarak Gelsin'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_default" id="is_default" value="1"<cfif get_consumer_cat.is_default eq 1> checked</cfif>>
                                </div>
						</div>
                        <div class="form-group" id="is_internet_denied">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='44824.İnternette Yetki Verdiğim Ekranlara Ulaşabilsin (Public)'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="checkbox" name="is_internet_denied" id="is_internet_denied" value="1"<cfif get_consumer_cat.is_internet_denied eq 1> checked</cfif>>
                                </div>
						</div>
			        </div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_record_info query_name="get_consumer_cat">
                    <cfif get_cons_category.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"> 
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.popup_del_consumer_cat&conscat_id=#url.id#'>
                    </cfif>
                </cf_box_footer>
			</cfform>	
    	</div>
  	</cf_box>
</div>





