<cf_get_lang_set module_name="settings">
<cfinclude template="../query/get_zone_branch_count.cfm">
<cfsavecontent variable="right">
<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_zone"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='42528.Bölge Ekle'>" alt="<cf_get_lang dictionary_id='42528.Bölge Ekle'>"></i></a>
</cfsavecontent>
		<cfquery name="CATEGORY" datasource="#dsn#">
			SELECT 
    	        ZONE_STATUS, 
                ZONE_ID, 
                ZONE_NAME, 
                ZONE_DETAIL, 
                ADMIN1_POSITION_CODE, 
                ADMIN2_POSITION_CODE,
                ZONE_TELCODE, 
                ZONE_TEL1, 
                ZONE_TEL2, 
                ZONE_TEL3, 
                ZONE_FAX, 
                ZONE_EMAIL, 
                ZONE_ADDRESS, 
                POSTCODE, 
                COUNTY, 
                CITY, 
                COUNTRY, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP, 
                IS_ORGANIZATION, 
                HIERARCHY 
            FROM 
	            ZONE 
            WHERE 
            	ZONE_ID=#attributes.ID#
		</cfquery>	  
		<cfset formun_adresi = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_zone_upd'>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=#formun_adresi#" method="post" name="zoneForm">
            <cfinput type="Hidden" name="id" id="id" value="#attributes.ID#">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-zone_status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.durum'></label>
                        <div class="col col-8 col-xs-12"> 
                            <label><input type="Checkbox" name="zone_status" id="zone_status" <cfif category.zone_status>checked</cfif> value=1><cf_get_lang dictionary_id='57493.Aktif'></label> 
                            <label><input type="Checkbox" name="is_organization" id="is_organization" <cfif category.is_organization eq 1>checked</cfif> value=1><cf_get_lang dictionary_id='42936.Org Şemada Göster'></label>
                        </div>
                    </div>
                    <cfoutput>
                        <div class="form-group" id="item-zone_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42529.Bölge Adı'>*</label>
                            <div class="col col-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='42031.Başlık girmelisiniz'></cfsavecontent>
                                    <cfinput required="Yes" message="#message#" type="Text" name="zone_name" id="zone_name" size="30" value="#category.zone_name#" maxlength="20">
                                    <span class="input-group-addon"><cf_language_info table_name="ZONE" column_name="ZONE_NAME" column_id_value="#attributes.ID#" maxlength="500" datasource="#dsn#" column_id="ZONE_ID" control_type="0"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-zone_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
                            <div class="col col-8 col-xs-12"> 
                                <textarea name="zone_Detail" id="zone_Detail"  style="width:150px;height:40px;">#category.zone_detail#</textarea>
                            </div>
                        </div>
                    </cfoutput>
                    <div class="form-group" id="item-admin1_position">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 1</label>
                        <div class="col col-8 col-xs-12"> 
                            <div class="input-group">
                                <input type="Hidden" name="admin1_position_code" id="admin1_position_code" value="<cfoutput>#category.admin1_position_code#</cfoutput>">
                                <cfif len(category.admin1_position_code)>
                                    <cfset attributes.employee_id = "">
                                    <cfset attributes.position_code = category.admin1_position_code>
                                    <cfinclude template="../query/get_position.cfm">
                                    <input type="text" name="admin1_position" id="admin1_position"  value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
                                <cfelse>
                                    <input type="text" name="admin1_position" id="admin1_position"  value="">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=zoneForm.admin1_position_code&field_name=zoneForm.admin1_position');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-admin2_position">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 2</label>
                        <div class="col col-8 col-xs-12"> 
                            <div class="input-group">
                                <input type="Hidden" name="admin2_position_code" id="admin2_position_code" value="<cfoutput>#category.admin2_position_code#</cfoutput>">
                                <cfif len(category.admin2_position_code)>
                                    <cfset attributes.employee_id = "">
                                    <cfset attributes.position_code = category.admin2_position_code>
                                    <cfinclude template="../query/get_position.cfm">
                                    <input type="text" name="admin2_position" id="admin2_position"  value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
                                <cfelse>
                                    <input type="text" name="admin2_position" id="admin2_position"  value="">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=zoneForm.admin2_position_code&field_name=zoneForm.admin2_position');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-zone_tel1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42364.Tel Kod - Tel'>1</label>
                        <div class="col col-2 col-xs-12"> 
                            <input type="Text" name="zone_telcode" id="zone_telcode" size="10" value="<cfoutput>#category.zone_telcode#</cfoutput>" maxlength="10" onkeyup="isNumber(this);">
                        </div>
                        <div class="col col-6 col-xs-12"> 
                            <input type="Text" name="zone_tel1" id="zone_tel1" size="10" value="<cfoutput>#category.zone_tel1#</cfoutput>" maxlength="10" onkeyup="isNumber(this);"></td>
                        </div>
                    </div>
                    <cfoutput>
                        <div class="form-group" id="item-zone_tel2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="zone_tel2" id="zone_tel2" size="10" value="#category.zone_tel2#" maxlength="10" onkeyup="isNumber(this);">
                            </div>
                        </div>
                        <div class="form-group" id="item-zone_tel3">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="zone_tel3" id="zone_tel3" size="10" value="#category.zone_tel3#" maxlength="10" onkeyup="isNumber(this);">
                            </div>
                        </div>
                    </cfoutput>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <cfoutput>
                        <div class="form-group" id="item-zone_fax">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Faks'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="zone_fax" id="zone_fax" size="10" value="#category.zone_fax#" maxlength="10" onkeyup="isNumber(this);">
                            </div>
                        </div>
                        <div class="form-group" id="item-zone_email">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="zone_email" id="zone_email" size="60" value="#category.zone_email#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-zone_address">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                            <div class="col col-8 col-xs-12"> 
                                <textarea name="zone_address" id="zone_address" cols="60" rows="2" style="width:150px;height:40px;">#category.zone_address#</textarea>
                            </div>
                        </div>
                    </cfoutput>
                    <div class="form-group" id="item-postcode">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                        <div class="col col-8 col-xs-12"> 
                            <input type="Text" name="postcode" id="postcode" size="6" value="<cfoutput>#category.postcode#</cfoutput>" maxlength="5" onkeyup="isNumber(this);">
                        </div>
                    </div>
                    <div class="form-group" id="item-county">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                        <div class="col col-8 col-xs-12"> 
                            <input type="Text" name="county" id="county" size="30" value="<cfoutput>#category.county#</cfoutput>" maxlength="20">
                        </div>
                    </div>
                    <cfoutput>
                        <div class="form-group" id="item-City">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="City" id="City" size="30" value="#category.city#" maxlength="20">
                            </div>
                        </div>
                        <div class="form-group" id="item-country">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="country" id="country" size="40" value="#category.country#" maxlength="30">
                            </div>
                        </div>
                        <div class="form-group" id="item-hierarchy">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="Text" name="hierarchy" id="hierarchy"  value="#category.hierarchy#" maxlength="75">
                            </div>
                        </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6"><cf_record_info query_name="category"></div>
                <div class="col col-6">
                    <cfif get_zone_branch_count.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
                        <cfif fusebox.circuit eq 'hr'>
                            <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0'>
                        <cfelse>
                            <cf_workcube_buttons type_format="1" is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_zone_del&zone_id=#attributes.id#&head=#category.zone_name#'>
                        </cfif>
                    </cfif>
                </div>                     
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<cf_get_lang_set module_name="#fusebox.circuit#">
