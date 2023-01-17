<cfinclude template="../query/get_titles.cfm">
<cfquery name="GET_ORGANIZATION_STEPS" datasource="#DSN#">
	SELECT 
		ORGANIZATION_STEP_ID,
		ORGANIZATION_STEP_NAME
	FROM
		SETUP_ORGANIZATION_STEPS
	ORDER BY
		ORGANIZATION_STEP_NAME
</cfquery>
<cfquery name="GET_UNITS" datasource="#DSN#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
</cfquery>
<cfif not(isdefined("attributes.isAjax") and len(attributes.isAjax))>
    <cf_catalystHeader>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id = "57779.Pozisyon tipleri"></cfsavecontent>
<cf_box title="#title#" closable="0">
    <cfform action="#request.self#?fuseaction=hr.emptypopup_upd_position_cat" method="post" name="position_cat">
        <cfif isdefined("attributes.isAjax") and len(attributes.isAjax)><!--- Organizasyon Planlama sayfasından ajax ile çağırılırsa 20190912ERU ---> 
            <cfoutput>
                <input type="hidden" name="callAjax" id="callAjax" value = "1">
                <input type="hidden" name="branch_id" id="branch_id" value = "#attributes.branch_id#">
                <input type="hidden" name="comp_id" id="comp_id" value = "#attributes.comp_id#">
                <input type="hidden" name="department_id" id="department_id" value = "#attributes.department_id#">
                <input type="hidden" name="position_catid" id="position_catid" value = "#attributes.position_catid#">
                <input type="hidden" name="department" id="department" value = "#attributes.department#">
            </cfoutput>
        </cfif> 
        <cfquery name="CATEGORIES" datasource="#dsn#">
            SELECT
                SPC.POSITION_CAT_STATUS,
                #dsn#.Get_Dynamic_Language(SPC.POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,POSITION_CAT) AS POSITION_CAT,
                #dsn#.Get_Dynamic_Language(SPC.POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT_DETAIL',NULL,NULL,POSITION_CAT_DETAIL) AS POSITION_CAT_DETAIL,
                SPC.HIERARCHY,
                SPC.POSITION_CAT_UPPER_TYPE,
                SPC.POSITION_CAT_TYPE,
                SPC.PERF_STATUS,
                SPC.TITLE_ID,
                SPC.ORGANIZATION_STEP_ID,
                SPC.COLLAR_TYPE,
                SPC.FUNC_ID,
                SPC.BUSINESS_CODE_ID,
                SBC.BUSINESS_CODE_NAME,
                SBC.BUSINESS_CODE
            FROM 
                SETUP_POSITION_CAT SPC
                LEFT JOIN SETUP_BUSINESS_CODES SBC ON SPC.BUSINESS_CODE_ID = SBC.BUSINESS_CODE_ID
            WHERE 
                SPC.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.position_id#">
        </cfquery>
        <input type="Hidden" name="POSITION_ID" id="POSITION_ID" value="<cfoutput>#URL.position_id#</cfoutput>">
  
        <!---    <cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
                <cf_box title="#title#" closable="0">
            </cfif> --->
    
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-position_cat_status">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                    <div class="col col-8 col-xs-12">
                        <label><input type="checkbox" name="position_cat_status" id="position_cat_status" value="1" <cfif categories.position_cat_status eq 1>checked</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></label>
                    </div>
                </div>
                <div class="form-group" id="item-position_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Baslik Girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="position" id="position" size="40" value="#categories.POSITION_CAT#" maxlength="100" required="Yes" message="#message#">
                            <span class="input-group-addon">
                                <cf_language_info 
                                table_name="SETUP_POSITION_CAT" 
                                column_name="POSITION_CAT" 
                                column_id_value="#url.position_id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="POSITION_CAT_ID" 
                                control_type="0">
                            </span>	
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-position_detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <textarea name="position_detail" id="position_detail" cols="75" style="width:200px;height:60px;"><cfoutput>#categories.POSITION_CAT_DETAIL#</cfoutput></textarea>
                            <span class="input-group-addon">
                                <cf_language_info 
                                table_name="SETUP_POSITION_CAT" 
                                column_name="POSITION_CAT_DETAIL" 
                                column_id_value="#url.position_id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="POSITION_CAT_ID" 
                                control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-hierarchy">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="hierarchy" id="hierarchy" value="<cfoutput>#categories.hierarchy#</cfoutput>" maxlength="50">
                    </div>
                </div>
                <div class="form-group" id="item-position_cat_upper_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58572.Kullanım'></label>
                    <div class="col col-8 col-xs-12">
                        <label><input type="checkbox" name="position_cat_upper_type" id="position_cat_upper_type" value="1" <cfif categories.position_cat_upper_type eq 1>checked</cfif>><cf_get_lang dictionary_id ='58573.Merkez'></label>
                        <label><input type="checkbox" name="position_cat_type" id="position_cat_type" value="1"  <cfif categories.position_cat_type eq 1>checked</cfif>><cf_get_lang dictionary_id ='57453.Şube'></label>
                        <label><input type="checkbox" name="perf_status" id="perf_status" value="1" <cfif categories.perf_status eq 1>checked</cfif>><cf_get_lang dictionary_id ='55086.Yedekleme'></label>
                    </div>
                </div>
                <div class="form-group" id="item-title_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="title_id" id="title_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="titles"> 
                            <option value="#title_id#" <cfif categories.title_id eq title_id>selected</cfif>>#title#</option> 
                        </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ORGANIZATION_STEP_ID">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58710.Kademe'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="ORGANIZATION_STEP_ID" id="ORGANIZATION_STEP_ID">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_organization_steps">
                                <option value="#organization_step_id#" <cfif categories.organization_step_id eq organization_step_id>selected</cfif>>#organization_step_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-collar_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="collar_type" id="collar_type">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1" <cfif categories.collar_type eq 1>selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
                            <option value="2" <cfif categories.collar_type eq 2>selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-func_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="func_id" id="func_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                            <cfoutput query="get_units">
                                <option value="#get_units.unit_id#" <cfif categories.func_id eq unit_id>selected</cfif>>#unit_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-business_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55900.Meslek Grubu'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="business_code_id" id="business_code_id" value="<cfoutput>#categories.business_code_id#</cfoutput>">
                            <input type="text" name="business_code" id="business_code" value="<cfoutput>#categories.business_code_name# <cfif len(categories.business_code)>(#categories.business_code#)</cfif></cfoutput>">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_business_codes&field_id=position_cat.business_code_id&field_name=position_cat.business_code</cfoutput>');"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="categories">
            <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0'>
        </cf_box_footer>
    </cfform>
    <cf_seperator id="content" title="#getLang('','Yetki ve Sorumluluklar','55169')#">
    <cf_grid_list id="content">
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                <th width="20"> <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_form_add_position_content&position_cat_id=#attributes.position_id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfset attributes.POSITION_CAT_ID = url.POSITION_ID>
            <cfinclude template="../query/get_positioncat_content.cfm">
            <cfif get_positioncat_content.recordcount>
                <cfoutput query="GET_POSITIONCAT_CONTENT">
                    <tr>
                        <td>#GET_POSITIONCAT_CONTENT.AUTHORITY_HEAD#</td>
                        <td> <a href="#request.self#?fuseaction=hr.list_contents&event=upd&authority_id=#GET_POSITIONCAT_CONTENT.authority_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> </td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </cf_grid_list>
</cf_box>