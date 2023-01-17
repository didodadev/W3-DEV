<cfquery name="get_our_company_info" datasource="#caller.dsn#">
	SELECT IS_ADD_INFORMATIONS FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif get_our_company_info.IS_ADD_INFORMATIONS eq 1>
    <cfparam name="attributes.upd_page" default="0">
    <cfparam name="attributes.colspan" default="">
    <cfset dsn = caller.dsn>
    <cfset dsn2 = caller.dsn2>
    <cfset dsn3 = caller.dsn3>
	<cfset attributes.fuseaction = caller.attributes.fuseaction>
	<cfset get_emp_info = caller.get_emp_info>
    <cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -25) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
        <cfset tablo_adi = "INFO_PLUS">
        <cfset kolon_adi = "OWNER_ID">
        <cfset dsn_adi = dsn>
    <cfelseif isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -5)>
        <cfset tablo_adi = "PRODUCT_INFO_PLUS">
        <cfset kolon_adi = "PRODUCT_ID">
        <cfset dsn_adi = dsn3>
    <cfelseif isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -6)>
        <cfset tablo_adi = "PRODUCT_TREE_INFO_PLUS">
        <cfset kolon_adi = "STOCK_ID">
        <cfset dsn_adi = dsn3>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -7) or (attributes.info_type_id eq -12))><!--- Satis ve satinalma siparisleri --->
        <cfset tablo_adi = "ORDER_INFO_PLUS">
        <cfset kolon_adi = "ORDER_ID">
        <cfset dsn_adi = dsn3>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -8) or (attributes.info_type_id eq -32))>
        <cfset tablo_adi = "INVOICE_INFO_PLUS">
        <cfset kolon_adi = "INVOICE_ID">
        <cfset dsn_adi = dsn2>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -9) or (attributes.info_type_id eq -30))><!--- Satis ve satinalma teklifleri --->
        <cfset tablo_adi = "OFFER_INFO_PLUS">
        <cfset kolon_adi = "OFFER_ID">
        <cfset dsn_adi = dsn3>
    <cfelseif isdefined("attributes.info_type_id") and ((attributes.info_type_id) eq -16)>
        <cfset tablo_adi = "OPPORTUNITIES_INFO_PLUS">
        <cfset kolon_adi = "OPP_ID">
        <cfset dsn_adi = dsn3>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -10))>
        <cfset tablo_adi = "PROJECT_INFO_PLUS">
        <cfset kolon_adi = "PROJECT_ID">
        <cfset dsn_adi = dsn>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -11))>
        <cfset tablo_adi = "SUBSCRIPTION_INFO_PLUS">
        <cfset kolon_adi = "SUBSCRIPTION_ID">
        <cfset dsn_adi = dsn3>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -14) or (attributes.info_type_id eq -31))>
        <cfset tablo_adi = "SHIP_INFO_PLUS">
        <cfset kolon_adi = "SHIP_ID">
        <cfset dsn_adi = dsn2>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -17))>
        <cfset tablo_adi = "EXPENSE_ITEM_PLANS_INFO_PLUS">
        <cfset kolon_adi = "EXPENSE_ID">
        <cfset dsn_adi = dsn2>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -22))>
		<cfset tablo_adi = "STOCK_FIS_INFO_PLUS">
        <cfset kolon_adi = "FIS_ID">
        <cfset dsn_adi = dsn2>
    <cfelseif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -28) or (attributes.info_type_id eq -29))><!--- İç Talepler ve satinalma talepleri --->
        <cfset tablo_adi = "INTERNALDEMAND_INFO_PLUS">
        <cfset kolon_adi = "INTERNAL_ID">
        <cfset dsn_adi = dsn3>
    </cfif>
    <cfif isdefined ("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4) or (attributes.info_type_id eq -10) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15)or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -21))>
        <cfquery name="GET_LABELS" datasource="#DSN#">
            SELECT
            <cfloop from="1" to="40" index="i">
                #dsn#.Get_Dynamic_Language(SETUP_INFOPLUS_NAMES.INFO_ID,'#session.ep.language#','SETUP_INFOPLUS_NAMES','PROPERTY#i#_NAME',NULL,NULL,SETUP_INFOPLUS_NAMES.PROPERTY#i#_NAME) AS PROPERTY#i#_NAME,
            </cfloop>
            *
            FROM
                SETUP_INFOPLUS_NAMES
            WHERE	
                OWNER_TYPE_ID = #attributes.info_type_id#
                <cfif isdefined("attributes.assetp_catid") and len(attributes.assetp_catid)>
                    AND MULTI_ASSETP_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#trim(attributes.assetp_catid)#,%">
                </cfif>
                <cfif isdefined("attributes.work_catid") and len(attributes.work_catid)>
                    AND MULTI_WORK_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#trim(attributes.work_catid)#,%">
                </cfif>
        </cfquery>
        <cfif GET_LABELS.recordcount>
            <cfquery name="GET_SELECT_VALUES_" datasource="#DSN#">
                SELECT
                    *
                FROM
                    SETUP_INFOPLUS_VALUES
                WHERE	
                    INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LABELS.INFO_ID#">
            </cfquery>
        </cfif>
    <cfelse>
        <cfquery name="GET_LABELS" datasource="#DSN3#">
            SELECT
            <cfloop from="1" to="40" index="i">
                #dsn#.Get_Dynamic_Language(SETUP_PRO_INFO_PLUS_NAMES.PRO_INFO_ID,'#session.ep.language#','SETUP_PRO_INFO_PLUS_NAMES','PROPERTY#i#_NAME',NULL,NULL,SETUP_PRO_INFO_PLUS_NAMES.PROPERTY#i#_NAME) AS PROPERTY#i#_NAME,
            </cfloop>
                *
            FROM
                SETUP_PRO_INFO_PLUS_NAMES
            WHERE	
                OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_type_id#">
                <cfif isdefined("attributes.product_catid1")>
                    AND MULTI_PRODUCT_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#trim(attributes.product_catid1)#,%">
                </cfif>
                <cfif isdefined("attributes.sub_catid")>
                    AND MULTI_SUB_CATID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#trim(attributes.sub_catid)#,%">
                </cfif>
                <cfif attributes.info_type_id eq -9>
                    <cfif isdefined("attributes.sales_add_option") and Len(attributes.sales_add_option)>
                        AND SALES_ADD_OPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#trim(attributes.sales_add_option)#,%">
                    <cfelse>
                        AND SALES_ADD_OPTION IS NULL
                    </cfif>
                </cfif>
        </cfquery>
        <cfif GET_LABELS.recordcount>
            <cfquery name="GET_SELECT_VALUES_" datasource="#DSN3#">
                SELECT
                    *
                FROM
                    SETUP_PRO_INFO_PLUS_VALUES
                WHERE	
                    PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LABELS.PRO_INFO_ID#">
            </cfquery>
        </cfif>
    </cfif>
    <cfif attributes.upd_page eq 1>
    <cfquery name="GET_VALUES" datasource="#dsn_adi#">
        SELECT
            PROPERTY1,
            PROPERTY2,
            PROPERTY3,
            PROPERTY4,
            PROPERTY5,
            PROPERTY6,
            PROPERTY7,
            PROPERTY8,
            PROPERTY9,
            PROPERTY10,
            PROPERTY11,
            PROPERTY12,
            PROPERTY13,
            PROPERTY14,
            PROPERTY15,
            PROPERTY16,
            PROPERTY17,
            PROPERTY18,
            PROPERTY19,
            PROPERTY20,
            PROPERTY21,
            PROPERTY22,
            PROPERTY23,
            PROPERTY24,
            PROPERTY25,
            PROPERTY26,
            PROPERTY27,
            PROPERTY28,
            PROPERTY29,
            PROPERTY30,
            PROPERTY31,
            PROPERTY32,
            PROPERTY33,
            PROPERTY34,
            PROPERTY35,
            PROPERTY36,
            PROPERTY37,
            PROPERTY38,
            PROPERTY39,
            PROPERTY40,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM
            #tablo_adi#
        WHERE
            #kolon_adi# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_id#">
            <cfif isdefined("attributes.info_type_id") and ((attributes.info_type_id eq -1) or (attributes.info_type_id eq -2) or (attributes.info_type_id eq -3) or (attributes.info_type_id eq -4 ) or (attributes.info_type_id eq -10) or (attributes.info_type_id eq -13) or (attributes.info_type_id eq -18) or (attributes.info_type_id eq -19) or (attributes.info_type_id eq -20) or (attributes.info_type_id eq -15) or (attributes.info_type_id eq -23) or (attributes.info_type_id eq -27)  or (attributes.info_type_id eq -24) or (attributes.info_type_id eq -21))>
                AND INFO_OWNER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.info_type_id#">
            <cfelseif (isdefined("get_labels.pro_info_id") and len(get_labels.pro_info_id)) and (isdefined("attributes.info_type_id") and attributes.info_type_id eq -5)>
                AND PRO_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_labels.pro_info_id#">
            </cfif>
    </cfquery>
    <cfelse>
    	<cfset get_values.recordcount = 0>
    </cfif>
    <cfset list_name="">
    <cfloop from="1" to="40" index="i">
        <cfif len(evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
            <cfset list_name=listappend(list_name,evaluate("GET_LABELS.PROPERTY#i#_NAME"),',')>
        </cfif>
    </cfloop>
    <input type="hidden" name="pro_info_id" id="pro_info_id" value="<cfif isdefined("get_labels.pro_info_id")><cfoutput>#get_labels.pro_info_id#</cfoutput><cfelseif isdefined("get_labels.info_id")><cfoutput>#get_labels.info_id#</cfoutput></cfif>">
	<div class="additional_clear"></div>
	<div class="text-center additionalinformation btnPointer" onclick="gizle_goster(_add_info);"><cfoutput>#caller.getLang('agenda',99)#</cfoutput></div>
    <div id="_add_info" class="addinformation_" style="display:none; z-index:100;">
        <cfif get_labels.recordcount and listlen(list_name)>
            <!--- frame_fuseaction bu fuseaction crm den geliyor lutfen dokunmayiniz, silmeyiniz FBS --->
            <input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
                <cfif isdefined("attributes.is_nonpopup")><!--- ne olduguna bakilmali --->
                    <input type="hidden" name="is_nonpopup" id="is_nonpopup" value="<cfoutput>#attributes.is_nonpopup#</cfoutput>">
                </cfif>
                <input type="hidden" name="product_catid1" id="product_catid1" value="<cfif isdefined("attributes.product_catid1")><cfoutput>#attributes.product_catid1#</cfoutput></cfif>">
                <cfif attributes.upd_page eq 1><input type="hidden" name="info_id" id="info_id" value="<cfoutput>#attributes.info_id#</cfoutput>"></cfif>
                <input type="hidden" name="info_type_id" id="info_type_id" value="<cfoutput>#attributes.info_type_id#</cfoutput>">
                <input type="hidden" name="sub_catid" id="sub_catid" value="<cfif isdefined("attributes.sub_catid")><cfoutput>#attributes.sub_catid#</cfoutput></cfif>">
                <input type="hidden" name="asset_catid" id="asset_catid" value="<cfif isdefined("attributes.asset_catid")><cfoutput>#attributes.asset_catid#</cfoutput></cfif>">
                <cfoutput>
                    <div class="row" style="width:250px !important;">
                        <!--- BK 20080620 eger ek bilgi tanimlama ekranında kolon sayisi belli ise ona gore set edilir. --->
                        <cfif len(get_labels.column_number) and get_labels.column_number neq 0>
                            <cfset column_number =get_labels.column_number>
                        <cfelse>
                            <cfset column_number =2>
                        </cfif>	
                        <cfset row_number =ceiling(40/column_number)>
                        <cfset no=0>
                        <cfset clm_no=0>
                        <cfset width=100/column_number>
                        <cfloop from="1" to="#column_number#" index="j">
                            <cfset sortQuery = queryNew("index,sort", "varchar,integer")>
                            <cfloop from="1" to="#row_number#" index="i">
                                <cfset no=no+1>
                                <cfif len(Evaluate('get_labels.property#no#_no')) and isnumeric(Evaluate('get_labels.property#no#_no'))>
                                    <cfset no_ = Evaluate('get_labels.property#no#_no')>
                                <cfelse>
                                    <cfset no_ = 999999999>
                                </cfif>	
                                <cfset queryAddRow(sortQuery)>
                                <cfset querySetCell(sortQuery, "index", no)>
                                <cfset querySetCell(sortQuery, "sort", no_)>
                            </cfloop>
                            <cfquery name="sorted" dbtype="query">
                                SELECT index, sort FROM sortQuery WHERE sort is not null
                                ORDER BY sort 
                            </cfquery>
                            <cfloop query="sorted">
                                    <cfif isdefined("get_labels.property#index#_name") and  len(Evaluate("get_labels.property#index#_name"))>
                                        <div class="form-group">
                                            <cfif len(Evaluate('get_labels.property#index#_gdpr')) and isnumeric(Evaluate('get_labels.property#index#_gdpr'))>
                                                <cfset gdpr_ = "#Evaluate('get_labels.property#index#_gdpr')#">
                                            <cfelse>
                                                <cfset gdpr_ = ''>
                                            </cfif>
                                            <cfif len(Evaluate('get_labels.property#index#_mask'))>
                                                <cfset mask_ = "#Evaluate('get_labels.property#index#_mask')#">
                                            <cfelse>
                                                <cfset mask_ = ''>
                                            </cfif>
                                            <cfquery name="control_gdpr" datasource="#dsn#">
                                                SELECT SENSITIVITY_LABEL_ID FROM GDPR_SENSITIVITY_LABEL
                                                 WHERE SENSITIVITY_LABEL_ID  IN (<cfqueryparam cfsqltype='integer' value='#session.ep.dockphone#' list="yes">)  
                                            </cfquery>
                                            <cfif len(gdpr_)>
                                                <cfquery name="get_gdpr" dbtype="query">
                                                        SELECT SENSITIVITY_LABEL_ID FROM control_gdpr WHERE SENSITIVITY_LABEL_ID IN (<cfqueryparam cfsqltype='integer' value='#gdpr_#' list="yes">)
                                                </cfquery>
                                                <cfif get_values.recordcount>
                                                    <cfif get_gdpr.recordcount>
                                                        <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                            <cftry>
                                                                <cfset value_ = caller.contentEncryptingandDecodingAES(isEncode:0,content:value_,accountKey:'wrk')>
                                                                <cfcatch>
                                                                    <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                                </cfcatch>
                                                            </cftry>
                                                    <cfelse> 
                                                        <script>
                                                            $(window).load(function(){ $("##property#index#").attr("readonly", true);$('##property#index#').attr('onclick','power()');})
                                                        </script>
                                                        <cfset value_="*******#mid(Evaluate('get_values.property#index#'),1,2)#">
                                                    </cfif>
                                                <cfelse>
                                                    <cfif not get_gdpr.recordcount>
                                                        <script>
                                                            $(window).load(function(){ $("##property#index#").attr("readonly", true);$('##property#index#').attr('onclick','power()');})
                                                        </script>
                                                    </cfif>
                                                    <cfset value_ = "">
                                                </cfif>
                                            <cfelse>
                                                <cfif get_values.recordcount>
                                                        <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                        <cftry>
                                                            <cfset value_ = caller.contentEncryptingandDecodingAES(isEncode:0,content:value_,accountKey:'wrk')>
                                                        <cfcatch>
                                                            <cfset value_= '#Evaluate('get_values.property#index#')#'>
                                                        </cfcatch>
                                                    </cftry>
                                                <cfelse>
                                                    <cfset value_ = "">
                                                </cfif>
                                            </cfif>
                                            <cfif len(Evaluate('get_labels.property#index#_type'))>
                                                <cfset validate_ = "#Evaluate('get_labels.property#index#_type')#">
                                            <cfelse>
                                                <cfset validate_ = "">
                                            </cfif>
                                            <cfif len(Evaluate('get_labels.property#index#_message'))>
                                                <cfset message_ = "#Evaluate('get_labels.property#index#_name')# : #Evaluate('get_labels.property#index#_message')# (#caller.getLang('main',398)#)">
                                            <cfelse>
                                                <cfset message_ = "">
                                            </cfif>
                                            <cfif len(Evaluate('get_labels.property#index#_range')) and isnumeric(Evaluate('get_labels.property#index#_range'))>
                                                <cfset max_ = "#Evaluate('get_labels.property#index#_range')#">
                                            <cfelse>
                                                <cfset max_ = "500">
                                            </cfif>
                                            <cfset clm_no=j>
                                            <label class="col col-4">#Evaluate("get_labels.property#index#_name")#<cfif Evaluate("get_labels.property#index#_req") eq 1> *</cfif></label>
                                            
                                            <cfif validate_ eq "integer">
                                                <div class="col col-8">
                                                    <cfif Evaluate("get_labels.property#index#_req") eq 1>
                                                        <cfinput type="text" name="property#index#" value="#value_#" required="yes" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;text-align:right;">
                                                    <cfelseif (#column_number# eq 1) and isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -5)>
                                                        <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;text-align:right;">
                                                    <cfelse>
                                                        <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;text-align:right;">
                                                    </cfif>
                                                </div>
                                            <cfelseif validate_ eq "select">
                                                <cfif isdefined("GET_SELECT_VALUES_")>
                                                    <cfquery name="get_row_selects_" dbtype="query">
                                                        SELECT * FROM GET_SELECT_VALUES_ WHERE PROPERTY_NO = #index#
                                                    </cfquery>
                                                </cfif>
                                                <div class="col col-8">
                                                    <cfif Evaluate("get_labels.property#index#_req") eq 1>
                                                        <cfselect name="property#index#" message="#message_#" required="yes" style="width:250px;">
                                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                            <cfif isdefined("get_row_selects_")>
                                                                <cfloop query="get_row_selects_">
                                                                    <option value="#get_row_selects_.select_value#" <cfif get_row_selects_.select_value eq value_>selected</cfif>>#get_row_selects_.select_value#</option>
                                                                </cfloop>
                                                            </cfif>
                                                        </cfselect>
                                                    <cfelse>
                                                        <cfselect name="property#index#" style="width:250px;">
                                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                            <cfif isdefined("get_row_selects_")>
                                                                <cfloop query="get_row_selects_">
                                                                    <option value="#get_row_selects_.select_value#" <cfif get_row_selects_.select_value eq value_>selected</cfif>>#get_row_selects_.select_value#</option>
                                                                </cfloop>
                                                            </cfif>
                                                        </cfselect>
                                                    </cfif>
                                                </div>
                                            <cfelse>
                                                <cfif validate_ eq 'eurodate'>
                                                    <cfif caller.validate_style is 'date'>
                                                        <cfset validate_ = "date">
                                                    </cfif>
                                                </cfif>
                                                <div class="col col-8">
                                                    <cfif Evaluate("get_labels.property#index#_req") eq 1>
                                                    <div class="input-group">
                                                        <cfinput type="text" name="property#index#" value="#value_#" required="yes" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;">
                                                        <cfif validate_ eq 'eurodate' or validate_ eq 'date'>
                                                            <span class="input-group-addon"><cf_wrk_date_image date_field="property#index#" alt="#caller.getLang('main',330)#"></span>
                                                        </cfif>
                                                    </div>    
                                                    <cfelseif (#column_number# eq 1) and isdefined ("attributes.info_type_id") and (attributes.info_type_id eq -5)>
                                                    <div class="input-group">    
                                                        <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;">
                                                        <cfif validate_ eq 'eurodate' or validate_ eq 'date'>
                                                            <span class="input-group-addon"><cf_wrk_date_image date_field="property#index#" alt="#caller.getLang('main',330)#"></span>
                                                        </cfif>
                                                    </div>    
                                                    <cfelse>
                                                        <cfif validate_ eq 'eurodate' or validate_ eq 'date'>
                                                        <div class="input-group">
                                                            <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;">
                                                            <span class="input-group-addon"><cf_wrk_date_image date_field="property#index#" alt="#caller.getLang('main',330)#"></span>
                                                        </div>
                                                        <cfelse>
                                                            <cfinput type="text" name="property#index#" value="#value_#" validate="#validate_#" message="#message_#" maxlength="#max_#" style="width:250px;">
                                                        </cfif>    
                                                    </cfif>
                                                </div>
                                            </cfif>
                                        </div>      
                                    </cfif>
                                  
                            </cfloop>   
                        </cfloop>
                        <cfif attributes.upd_page eq 1>
                            <tr>
                                <td>
                                    <cf_record_info query_name="GET_VALUES">
                                </td>
                            </tr>
                        </cfif>
                    </div>
                </cfoutput> 
        <cfelse>
            <table>
                <tr>
                    <td><cf_get_lang_main no='1920.Ayarlar Modülünden Ek Bilgi Detaylarını Doldurunuz'></td>
                </tr>
            </table>
        </cfif>
    </div>
    <div class="additional_clear"></div>
</cfif>
<script>
    function power() {
        alert("<cf_get_lang dictionary_id='57532.Yetkiniz yok'>!");
    }
</script>