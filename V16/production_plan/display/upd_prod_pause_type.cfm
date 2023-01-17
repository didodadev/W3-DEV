<cfquery name="get_pauseType" datasource="#dsn3#">
	SELECT 
		IS_ACTIVE,
		PROD_PAUSE_CAT_ID,
		PROD_PAUSE_TYPE_CODE,
        #dsn#.Get_Dynamic_Language(PROD_PAUSE_CAT_ID,'#session.ep.language#','SETUP_PROD_PAUSE_TYPE','PROD_PAUSE_TYPE',NULL,NULL,PROD_PAUSE_TYPE) AS PROD_PAUSE_TYPE,
		PAUSE_DETAIL,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE
	FROM 
		SETUP_PROD_PAUSE_TYPE 
	WHERE 
		PROD_PAUSE_TYPE_ID = #prod_pause_type_id#
</cfquery>
<cfquery name="get_pauseCat" datasource="#dsn3#">
	SELECT 
		PROD_PAUSE_CAT_ID,
		PROD_PAUSE_CAT
	FROM 
		SETUP_PROD_PAUSE_CAT
	WHERE
		IS_ACTIVE = 1
</cfquery>
<cfquery name="GET_PRODUCT_CATS" datasource="#DSN1#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		PC.PRODUCT_CATID,
		PC.HIERARCHY,
		PC.PRODUCT_CAT
	FROM
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PC.PRODUCT_CATID IS NOT NULL AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		PC.HIERARCHY
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=prod.popup_add_prod_pause_type</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"/></a></cfsavecontent>
<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="prod_pause_type" title="#iif(isDefined("attributes.draggable"),"getLang('','Duraklama Tipi Güncelle',36480)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="prod_pause_type" method="post" action="#request.self#?fuseaction=prod.upd_prod_pause_type">
            <input type="hidden" name="prod_pause_type_id" id="prod_pause_type_id" value="<cfoutput>#prod_pause_type_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57493.Aktif"><input type="checkbox" name="is_active" id="is_active" <cfif get_pauseType.is_active eq 1>checked</cfif>></label>
                    </div>
                    <div class="form-group" id="item-pauseCat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29475.Duraklama Kategorisi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="pauseCat" id="pauseCat">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_pauseCat">
                                    <option value="#prod_pause_cat_id#" <cfif prod_pause_cat_id eq get_pauseType.prod_pause_cat_id>selected</cfif>>#prod_pause_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-pauseType_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36478.Duraklama Kodu">*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id="36478.Duraklama Kodu"></cfsavecontent>
                            <cfinput type="Text" name="pauseType_code" size="60" value="#get_pauseType.prod_pause_type_code#" maxlength="50" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-pauseType">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36986.Duraklama Tipi">*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id="36986.Duraklama Tipi"></cfsavecontent>
                                <cfinput type="Text" name="pauseType" size="60" value="#get_pauseType.prod_pause_type#" maxlength="50" required="Yes" message="#message#">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="SETUP_PROD_PAUSE_TYPE" 
                                        column_name="PROD_PAUSE_TYPE" 
                                        column_id_value="#attributes.prod_pause_type_id#" 
                                        maxlength="50" 
                                        datasource="#dsn3#" 
                                        column_id="PROD_PAUSE_TYPE_ID" 
                                        control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:150px;height:45px;"  maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfif len(get_pauseType.pause_detail)><cfoutput>#get_pauseType.pause_detail#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-productCat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29401.Ürün Kategorisi"></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="get_productCat" datasource="#dsn3#">
                                SELECT PROD_PAUSE_PRODUCTCAT_ID FROM SETUP_PROD_PAUSE_TYPE_ROW WHERE PROD_PAUSE_TYPE_ID = #prod_pause_type_id#
                            </cfquery>
                            <cfset Product_cat_List = ValueList(get_productCat.PROD_PAUSE_PRODUCTCAT_ID,',')>
                            <select name="productCat" id="productCat" multiple="multiple" style="width:200px;height:75px;">
                                <cfoutput query="GET_PRODUCT_CATS">
                                    <option value="#product_catid#" <cfif ListFind(Product_cat_List,product_catid)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_pauseType"><cf_workcube_buttons is_upd='1' is_delete="0">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
