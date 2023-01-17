<cfif listfind('-1,-2,-3,-4,-10,-13,-15,-18,-21,-19,-20,-23,-25', attributes.owner_type_id,',')>
	<cfset DB_ADI ="#DSN#">
	<cfset TABLO_ADI ="SETUP_INFOPLUS_NAMES">
	<cfset ALAN1 ="INFO_ID">
<cfelse>
	<cfset DB_ADI ="#DSN3#">
	<cfset TABLO_ADI ="SETUP_PRO_INFO_PLUS_NAMES">
	<cfset ALAN1 ="PRO_INFO_ID">
</cfif>
<cfinclude template="../query/get_info_plus.cfm">
<cfif fusebox.use_period>
	<cfinclude template="../query/get_product_cat_names.cfm">
	<cfquery name="GET_SUB_TYPES" datasource="#DSN3#">
		SELECT
			SUBSCRIPTION_TYPE_ID,
            SUBSCRIPTION_TYPE
		FROM
			SETUP_SUBSCRIPTION_TYPE
		ORDER BY 
			SUBSCRIPTION_TYPE
	</cfquery>
</cfif>
<cfquery name="GET_GDPR" datasource="#DSN#">
    SELECT
        SENSITIVITY_LABEL_ID,
        SENSITIVITY_LABEL,
        SENSITIVITY_LABEL_NO
    FROM
        GDPR_SENSITIVITY_LABEL
    ORDER BY 
        SENSITIVITY_LABEL
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='42567.Ek Bilgi Ayarları Güncelle'></cfsavecontent>
<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_info_plus">
    <cfform name="upd_pro_info" method="post" action="#request.self#?fuseaction=settings.upd_info_plus_act">
        <input type="hidden" name="id" id="id" value="<cfoutput>#evaluate('infoplus_name.#alan1#')#</cfoutput>">
        <div class="col col-2 col-xs-12">
            <div class="scrollbar" style="max-height:403px;overflow:auto;">
                <div class="ui-form-list" id="cc">
                    <cfinclude template="../display/list_info_plus_names.cfm">
                </div>
            </div>
        </div>
        <div class="col col-10 col-xs-12">   
            <cf_box_elements>
                <div class="col col-6 col-xs-12">  
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58572.Kullanım'></label>
                        <input type="hidden" name="owner_type_id" id="owner_type_id" value="<cfoutput>#infoplus_name.owner_type_id#</cfoutput>">
                        <div class="col col-8 col-xs-12">
                            <select name="owner_type_id_" id="owner_type_id_" disabled>
                                <option value="0"><cf_get_lang dictionary_id='58572.Kullanım'></option>
                                <option value="-1" <cfif infoplus_name.owner_type_id eq -1> selected</cfif>><cf_get_lang dictionary_id='57585.Kurumsal Üye'></option>
                                <option value="-2" <cfif infoplus_name.owner_type_id eq -2> selected</cfif>><cf_get_lang dictionary_id='57586.Bireysel Üye'></option>
                                <option value="-3" <cfif infoplus_name.owner_type_id eq -3> selected</cfif>><cf_get_lang dictionary_id='58612.Üye Şirket Çalışanı'></option>
                                <option value="-4" <cfif infoplus_name.owner_type_id eq -4> selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
                                <option value="-23" <cfif infoplus_name.owner_type_id eq -23> selected</cfif>><cf_get_lang dictionary_id='29767.CV'></option>
                                <option value="-5" <cfif infoplus_name.owner_type_id eq -5> selected</cfif>><cf_get_lang dictionary_id='57657.Ürün'></option>
                                <option value="-6" <cfif infoplus_name.owner_type_id eq -6> selected</cfif>><cf_get_lang dictionary_id='42103.Ürün Ağacı'></option>
                                <option value="-7" <cfif infoplus_name.owner_type_id eq -7> selected</cfif>><cf_get_lang dictionary_id='58207.Satış Siparişleri'></option>
                                <option value="-8" <cfif infoplus_name.owner_type_id eq -8> selected</cfif>><cf_get_lang dictionary_id='50922.Alış Faturaları'></option>
                                <option value="-32" <cfif infoplus_name.owner_type_id eq -32> selected</cfif>><cf_get_lang dictionary_id='50921.Satış Faturaları'></option>
                                <option value="-9" <cfif infoplus_name.owner_type_id eq -9> selected</cfif>><cf_get_lang dictionary_id='30007.Satış Teklifleri'></option>
                                <option value="-10" <cfif infoplus_name.owner_type_id eq -10> selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
                                <option value="-11" <cfif infoplus_name.owner_type_id eq -11> selected</cfif>><cf_get_lang dictionary_id='58832.Abone'></option>
                                <option value="-12" <cfif infoplus_name.owner_type_id eq -12> selected</cfif>><cf_get_lang dictionary_id='42422.Satınalma Siparişleri'></option>
                                <option value="-13" <cfif infoplus_name.owner_type_id eq -13> selected</cfif>><cf_get_lang dictionary_id='58833.Fiziki Varlık'></option>
                                <option value="-19" <cfif infoplus_name.owner_type_id eq -19> selected</cfif>><cf_get_lang dictionary_id='42789.IT Varlık'></option>
                                <option value="-20" <cfif infoplus_name.owner_type_id eq -20> selected</cfif>><cf_get_lang dictionary_id='57414.Araçlar'></option>
                                <option value="-14" <cfif infoplus_name.owner_type_id eq -14> selected</cfif>><cf_get_lang dictionary_id='39500.Alış İrsaliyeleri'></option>
                                <option value="-31" <cfif infoplus_name.owner_type_id eq -31> selected</cfif>><cf_get_lang dictionary_id='39502.Satış İrsaliyeleri'></option>
                                <option value="-15" <cfif infoplus_name.owner_type_id eq -15> selected</cfif>><cf_get_lang dictionary_id='57656.Servis'></option>
                                <option value="-16" <cfif infoplus_name.owner_type_id eq -16> selected</cfif>><cf_get_lang dictionary_id='42187.Satış Fırsatlar'></option>
                                <option value="-17" <cfif infoplus_name.owner_type_id eq -17> selected</cfif>><cf_get_lang dictionary_id='59003.Masraf ve gelir fişleri'></option>
                                <option value="-18" <cfif infoplus_name.owner_type_id eq -18> selected</cfif>><cf_get_lang dictionary_id='58445.İş'></option>
                                <option value="-21" <cfif infoplus_name.owner_type_id eq -21> selected</cfif>><cf_get_lang dictionary_id='29522.Sözleşme'></option>
                                <option value="-22" <cfif infoplus_name.owner_type_id eq -22> selected</cfif>><cf_get_lang dictionary_id='43214.Stok Fişleri'></option>
                                <option value="-24" <cfif infoplus_name.owner_type_id eq -24> selected</cfif>><cf_get_lang dictionary_id="57438.callcenter">-<cf_get_lang dictionary_id="58186.başvurular"></option>
                                <option value="-25" <cfif infoplus_name.owner_type_id eq -25> selected</cfif>><cf_get_lang dictionary_id="57438.callcenter">-<cf_get_lang dictionary_id="58729.Etkileşim"></option>
                                <option value="-27" <cfif infoplus_name.owner_type_id eq -27> selected</cfif>><cf_get_lang dictionary_id="58689.Teminat"></option>
                                <option value="-28" <cfif infoplus_name.owner_type_id eq -28> selected</cfif>><cf_get_lang dictionary_id="49752.Satınalma Talebi"></option>
                                <option value="-29" <cfif infoplus_name.owner_type_id eq -29> selected</cfif>><cf_get_lang dictionary_id="30782.İç Talepler"></option>
                                <option value="-30" <cfif infoplus_name.owner_type_id eq -30> selected</cfif>><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></option>
                            </select>
                        </div>
                    </div>
                    <cfif infoplus_name.owner_type_id eq -5>
                        <cfquery name="CONTROL_INFOPLUS" datasource="#DSN3#">
                            SELECT 
                                COUNT(PIP.PRO_INFO_ID) COUNT_PRO_INFO_ID,
                                P.PRODUCT_CATID 
                            FROM 
                                PRODUCT_INFO_PLUS PIP,
                                PRODUCT P 
                            WHERE
                                PIP.PRODUCT_ID = P.PRODUCT_ID AND
                                PIP.PRO_INFO_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#infoplus_name.pro_info_id#">
                            GROUP BY
                                P.PRODUCT_CATID
                        </cfquery>
    
                        <div class="form-group" id="pro_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57567.Ürün Kategorisi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="product_catid_old" id="product_catid_old" value="<cfoutput>#infoplus_name.multi_product_catid#</cfoutput>">
                                <!--- Bu ozellige ait secilen kategorilerde ek bilgi girilmis mi girilmemis mi --->
                                <cfset product_catid_count_old = ''>
                                <cfloop index="list_position" from="1" to="#listlen(infoplus_name.multi_product_catid)#">
                                    <cfquery name="GET_COUNT" dbtype="query">
                                        SELECT COUNT_PRO_INFO_ID FROM CONTROL_INFOPLUS WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(infoplus_name.multi_product_catid,list_position)#">
                                    </cfquery>
                                    <cfif get_count.recordcount>
                                        <cfset product_catid_count_old = listappend(product_catid_count_old,get_count.count_pro_info_id)>
                                    <cfelse>
                                        <cfset product_catid_count_old = listappend(product_catid_count_old,0)>							
                                    </cfif>						
                                </cfloop>
                                <cfset product_catid_count_old = ','&product_catid_count_old&','>
                                <!--- formdaki kategorilere ait ek bilgi kaydi varmi? --->
                                <cf_multiselect_check 
                                query_name="get_pro_cat"  
                                name="product_catid"
                                option_name="HIERARCHY-PRODUCT_CAT" 
                                option_value="PRODUCT_CATID"
                                value="#infoplus_name.multi_product_catid#"
                                data_source="#dsn3#">
                            </div>
                        </div>	
                    <cfelseif infoplus_name.owner_type_id eq -11>
                        <cfquery name="CONTROL_INFOPLUS" datasource="#DSN3#">
                            SELECT 
                                COUNT(PIP.SUB_INFO_ID) COUNT_PRO_INFO_ID,
                                P.SUBSCRIPTION_TYPE_ID 
                            FROM 
                                SUBSCRIPTION_INFO_PLUS PIP,
                                SUBSCRIPTION_CONTRACT P 
                            WHERE
                                PIP.SUBSCRIPTION_ID = P.SUBSCRIPTION_ID AND
                                PIP.SUB_INFO_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#infoplus_name.pro_info_id#">
                            GROUP BY
                                P.SUBSCRIPTION_TYPE_ID
                        </cfquery>
                        <div class="form-group" id="sub_cat" valign="top">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42950.Sistem Kategorileri'> *</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="sub_catid_old" id="sub_catid_old" value="<cfoutput>#infoplus_name.multi_sub_catid#</cfoutput>">
                                <!--- Bu ozellige ait secilen kategorilerde ek bilgi girilmis mi girilmemis mi --->
                                <cfset sub_catid_count_old = ''>
                                <cfloop index="list_position" from="1" to="#listlen(infoplus_name.multi_sub_catid)#">
                                    <cfquery name="GET_COUNT" dbtype="query">
                                        SELECT COUNT_PRO_INFO_ID FROM CONTROL_INFOPLUS WHERE SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(infoplus_name.multi_sub_catid,list_position)#">
                                    </cfquery>
                                    <cfif get_count.recordcount>
                                        <cfset sub_catid_count_old = listappend(sub_catid_count_old,get_count.count_pro_info_id)>
                                    <cfelse>
                                        <cfset sub_catid_count_old = listappend(sub_catid_count_old,0)>							
                                    </cfif>						
                                </cfloop>
                                <cfset sub_catid_count_old = ','&sub_catid_count_old&','>
                                <!--- formdaki kategorilere ait ek bilgi kaydi varmi? --->
                            
                                <cf_multiselect_check 
                                query_name="get_sub_types"  
                                name="sub_catid"
                                option_name="SUBSCRIPTION_TYPE" 
                                option_value="SUBSCRIPTION_TYPE_ID"
                                value="#infoplus_name.multi_sub_catid#"
                                data_source="#dsn3#">
                            </div>
                        </div>
                    <cfelseif listfind('-13,-19,-20',infoplus_name.owner_type_id)>
                        <cfquery name="CONTROL_INFOPLUS" datasource="#DSN#">
                            SELECT
                                COUNT(IP.ASSETP_INFO_ID) COUNT_PRO_INFO_ID,
                                ASSET_P.ASSETP_CATID
                            FROM 
                                INFO_PLUS IP,
                                ASSET_P
                            WHERE
                                ASSET_P.ASSETP_ID=IP.OWNER_ID AND
                                IP.INFO_OWNER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#infoplus_name.owner_type_id#"> AND
                                IP.ASSETP_INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#infoplus_name.info_id#">
                            GROUP BY
                                ASSET_P.ASSETP_CATID
                        </cfquery>
                        <div class="form-group" id="asset_cat" sort="true">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44768.Varlık Tipi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="asset_catid_old" id="asset_catid_old" value="<cfoutput>#infoplus_name.multi_assetp_catid#</cfoutput>">
                                <!--- Bu ozellige ait secilen kategorilerde ek bilgi girilmis mi girilmemis mi --->
                                <cfset sub_assetid_count_old = ''>
                                <cfloop index="list_position" from="1" to="#listlen(infoplus_name.multi_assetp_catid)#">
                                    <cfquery name="GET_COUNT" dbtype="query">
                                        SELECT COUNT_PRO_INFO_ID FROM CONTROL_INFOPLUS WHERE ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(infoplus_name.multi_assetp_catid,list_position)#">
                                    </cfquery>
                                    <cfif get_count.recordcount>
                                        <cfset sub_assetid_count_old = listappend(sub_assetid_count_old,get_count.count_pro_info_id)>
                                    <cfelse>
                                        <cfset sub_assetid_count_old = listappend(sub_assetid_count_old,0)>							
                                    </cfif>						
                                </cfloop>
                                <cfset sub_assetid_count_old = ','&sub_assetid_count_old&','>
                                <cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
                                    SELECT 
                                        ASSETP_CATID, 
                                        ASSETP_CAT 
                                    FROM 
                                        ASSET_P_CAT  
                                    WHERE 
                                        <cfif infoplus_name.owner_type_id eq -13>
                                            MOTORIZED_VEHICLE = 0 AND 
                                            IT_ASSET = 0 
                                        <cfelseif infoplus_name.owner_type_id eq -19>
                                            IT_ASSET = 1
                                        <cfelseif infoplus_name.owner_type_id eq -20>
                                            MOTORIZED_VEHICLE = 1
                                        </cfif>
                                    ORDER BY ASSETP_CAT
                                </cfquery>
                                <!--- Formdaki Fiziki varlık Tipi? --->
                                <cf_multiselect_check 
                                query_name="GET_ASSETP_CATS"  
                                name="sub_assetid"
                                option_name="ASSETP_CAT" 
                                option_value="ASSETP_CATID"
                                value=#infoplus_name.multi_assetp_catid#
                                data_source="#dsn#">
                            </div>
                        </div>
                    <cfelseif infoplus_name.owner_type_id eq -18>
                        <cfquery name="CONTROL_INFOPLUS" datasource="#DSN#">
                            SELECT
                                COUNT(IP.ASSETP_INFO_ID) COUNT_PRO_INFO_ID,
                                PRO_WORKS.WORK_CAT_ID
                            FROM 
                                INFO_PLUS IP,
                                PRO_WORKS
                            WHERE
                                PRO_WORKS.WORK_ID=IP.OWNER_ID AND
                                IP.INFO_OWNER_TYPE=-18 AND
                                IP.ASSETP_INFO_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#infoplus_name.info_id#">
                            GROUP BY
                                PRO_WORKS.WORK_CAT_ID
                        </cfquery>
                        <div class="form-group" id="work_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38177.İş Kategorisi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="work_catid_old" id="work_catid_old" value="<cfoutput>#infoplus_name.multi_work_catid#</cfoutput>">
                                <!--- Bu ozellige ait secilen kategorilerde ek bilgi girilmis mi girilmemis mi --->
                                <cfset sub_assetid_count_old = ''>
                                <cfloop index="list_position" from="1" to="#listlen(infoplus_name.multi_work_catid)#">
                                    <cfquery name="GET_COUNT" dbtype="query">
                                        SELECT COUNT_PRO_INFO_ID FROM CONTROL_INFOPLUS WHERE WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(infoplus_name.multi_work_catid,list_position)#">
                                    </cfquery>
                                    <cfif get_count.recordcount>
                                        <cfset sub_assetid_count_old = listappend(sub_assetid_count_old,get_count.count_pro_info_id)>
                                    <cfelse>
                                        <cfset sub_assetid_count_old = listappend(sub_assetid_count_old,0)>							
                                    </cfif>						
                                </cfloop>
                                <cfset sub_assetid_count_old = ','&sub_assetid_count_old&','>
                                <cfquery name="get_work_cat" datasource="#DSN#">
                                    SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
                                </cfquery>
                                <cf_multiselect_check 
                                query_name="get_work_cat"  
                                name="work_catid"
                                option_name="WORK_CAT" 
                                option_value="WORK_CAT_ID"
                                value="#infoplus_name.multi_work_catid#"
                                data_source="#dsn#">
                            </div>
                        </div>
                    <cfelseif infoplus_name.owner_type_id eq -9>
                        <cfquery name="GET_ADDOPTIONS" datasource="#DSN3#">
                            SELECT
                                SALES_ADD_OPTION
                            FROM 
                                SETUP_PRO_INFO_PLUS_NAMES
                            WHERE
                                PRO_INFO_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#infoplus_name.PRO_INFO_ID#">
                        </cfquery>
                        <div class="form-group" id="sales_add_options" sort="true">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41142.Özel Tanım'></label>
                            <div class="col col-8 col-xs-12">
                                <cfquery name="GET_SALES_ADD_OPTIONS" datasource="#DSN3#">
                                    SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
                                </cfquery>
                                <cf_multiselect_check 
                                query_name="GET_SALES_ADD_OPTIONS"  
                                name="sales_add_optionid"
                                option_name="SALES_ADD_OPTION_NAME" 
                                option_value="SALES_ADD_OPTION_ID"
                                value="#GET_ADDOPTIONS.SALES_ADD_OPTION#"
                                data_source="#dsn3#">
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-2 col-xs-12">  
                    <div class="form-group">
                        <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='43842.Kolon Sayısı'></label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="column_number" id="column_number" value="<cfoutput>#infoplus_name.column_number#</cfoutput>" onkeyup="isNumber(this);" maxlength="1">
                        </div>
                    </div>
                </div>                                  	
            </cf_box_elements>
            <cf_grid_list>		
                <thead>
                <tr>
                    <th width="150"></th>
                    <th><cf_get_lang dictionary_id='57631.Ad'></th>
                    <th><cf_get_lang dictionary_id='46598.GDPR Yetkisi'></th>
                    <th><cf_get_lang dictionary_id='61101.Maskeleme'></th>
                    <th><cf_get_lang dictionary_id='29801.Zorunlu'></th>
                    <th><cf_get_lang dictionary_id='43689.Alan Tipi'></th>
                    <th><cf_get_lang dictionary_id='43176.Kolon Uzunluğu'></th>
                    <th><cf_get_lang dictionary_id='43691.Maksimum Karakter'></th>
                    <th><cf_get_lang dictionary_id='43692.Alan Uyarısı'></th>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th></th>
                </tr>
                </thead>
                <cfloop index="i" from="1" to="40">
                    <tr>
                        <td style="min-width:120px!important">  
                            <cf_get_lang dictionary_id='57632.Özellik'><cfoutput>#i#</cfoutput>
                            <cfswitch expression="#i#">
                                <cfcase value="1,2,3,4,7,8,9,10">(100) <cf_get_lang dictionary_id='42569.Karakter'></cfcase>
                                <cfcase value="5,6">(500)<cf_get_lang dictionary_id='42569.Karakter'></cfcase>
                                <cfcase value="11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40">(250) <cf_get_lang dictionary_id='42569.Karakter'></cfcase>						
                            </cfswitch>
                        </td>
                        <td style="min-width:120px!important"><div class="form-group"><div class="input-group"><input type="text" maxlength="50" name="<cfoutput>property#i#_name</cfoutput>" id="<cfoutput>property#i#_name</cfoutput>" value="<cfoutput>#evaluate('infoplus_name.property#i#_name')#</cfoutput>"><span class="input-group-addon">
                            <cf_language_info 
                                table_name="#TABLO_ADI#" 
                                column_name="property#i#_name" 
                                maxlength="500" 
                                datasource="#DB_ADI#" 
                                column_id_value="#url.id#"
                                column_id="#ALAN1#" 
                                control_type="0">
                        </span></div></div></td>
                        <td>
                            <select name="<cfoutput>property#i#_gdpr</cfoutput>" id="<cfoutput>property#i#_gdpr</cfoutput>" onchange="change_option(this.value,<cfoutput>#i#</cfoutput>);">
                                <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>  
                                <cfoutput query="get_gdpr" ><option value="#sensitivity_label_id#" <cfif evaluate('infoplus_name.property#i#_gdpr') is sensitivity_label_id>selected</cfif>>#sensitivity_label#</option> </cfoutput>                          
                            </select>
                        </td>
                        <td><input type="checkbox" name="<cfoutput>property#i#_mask</cfoutput>" id="<cfoutput>property#i#_mask</cfoutput>" <cfif evaluate('infoplus_name.property#i#_mask') eq 1>checked</cfif>></td>
                        <td><input type="checkbox" name="<cfoutput>property#i#_req</cfoutput>" id="<cfoutput>property#i#_req</cfoutput>" <cfif evaluate('infoplus_name.property#i#_req') eq 1>checked</cfif>></td>
                        <td>
                            <select name="<cfoutput>property#i#_type</cfoutput>" id="<cfoutput>property#i#_type</cfoutput>" onchange="change_option(this.value,<cfoutput>#i#</cfoutput>);">
                                <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
                                <option value="integer" <cfif evaluate('infoplus_name.property#i#_type') is 'integer'>selected</cfif>><cf_get_lang dictionary_id='43985.Sayısal Değer'></option>
                                <option value="creditcard" <cfif evaluate('infoplus_name.property#i#_type') is 'creditcard'>selected</cfif>><cf_get_lang dictionary_id='58199.Kredi Kartı'></option>
                                <option value="email" <cfif evaluate('infoplus_name.property#i#_type') is 'email'>selected</cfif>><cf_get_lang dictionary_id='57428.E-mail'></option>
                                <option value="telephone" <cfif evaluate('infoplus_name.property#i#_type') is 'telephone'>selected</cfif>><cf_get_lang dictionary_id='57499.Telefon'></option>
                                <option value="eurodate" <cfif evaluate('infoplus_name.property#i#_type') is 'eurodate'>selected</cfif>><cf_get_lang dictionary_id='57742.Tarih'></option>
                                <option value="select" <cfif evaluate('infoplus_name.property#i#_type') is 'select'>selected</cfif>>Select Box</option>
                            </select>
                        </td>
                        <td>500</td>
                        <td><input type="text" name="<cfoutput>property#i#_range</cfoutput>"  id="<cfoutput>property#i#_range</cfoutput>" value="<cfoutput><cfif len(evaluate('infoplus_name.property#i#_range'))>#evaluate('infoplus_name.property#i#_range')#<cfelse><cfif i lte 10>100<cfelse>250</cfif></cfif></cfoutput>" onkeyup="isNumber(this);" maxlength="10"></td>
                        <td><input type="text" name="<cfoutput>property#i#_message</cfoutput>" id="<cfoutput>property#i#_message</cfoutput>" value="<cfoutput>#evaluate('infoplus_name.property#i#_message')#</cfoutput>"></td>
                        <td><input type="text" maxlength="2" style="width:50px;text-align:right;" name="<cfoutput>property#i#_no</cfoutput>" id="<cfoutput>property#i#_no</cfoutput>" onKeyup="isNumber(this);" value="<cfoutput>#evaluate('infoplus_name.property#i#_NO')#</cfoutput>"></td>
                        <td>
						<div <cfif evaluate('infoplus_name.property#i#_type') is not 'select'>style="display:none;"</cfif> id="<cfoutput>property_td#i#</cfoutput>">
                            <div style="position:absolute;display:none;margin-left:-200px;overflow:auto;height:300px;width:250px;" id="is_sending_zone<cfoutput>#i#</cfoutput>"></div>
                            <a href="javascript://" onclick="goster(is_sending_zone<cfoutput>#i#</cfoutput>);open_process(<cfoutput>#i#</cfoutput>);"><img src="/images/info_plus.gif" border="0" align="absmiddle" title="Değerler"></a>
						</div>
                        </td>
                    </tr>
                </cfloop>
            </cf_grid_list>
            <div class="ui-form-list-btn">
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="infoplus_name">
                </div>
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                </div>
            </div>
        </div>
    </cfform>
</cf_box>
<script type="text/javascript">
	function open_process(row_no)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.popup_list_info_plus_value&owner_type_id=#attributes.owner_type_id#&info_id='+document.upd_pro_info.id.value+'&row_no='+row_no+'</cfoutput>','is_sending_zone'+row_no,1);
	}
	function change_option(type_id,id)
	{
		if(type_id == 'select')
		{
			document.getElementById('property_td'+id).style.display = '';
		}
	}
	function kontrol()
	{
		for(x=1;x<=20;x++)
		{
			if(document.getElementById('property'+x+'_req').checked)
			{
				if(document.getElementById('property'+x+'_message').value=='')
				{
					alert("<cf_get_lang dictionary_id ='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57632.Özellik'>"+x+" <cf_get_lang dictionary_id ='43692.Alan Uyarısı'>");
					return false
				}
			}
		}
		if(upd_pro_info.column_number.value > 2)
		{
			alert("<cf_get_lang dictionary_id ='43843.Kolon Sayısı En Fazla 2 Olabilir ! Değerinizi Kontrol Ediniz'>")
			return false;
		}
		if(upd_pro_info.owner_type_id.value == -5)
		{
			product_catid_selected = 0;
			for(kk=0;kk<document.upd_pro_info.product_catid.length; kk++)
			{
				if(upd_pro_info.product_catid[kk].selected)
					product_catid_selected+=1;
				else
				{
					deger = upd_pro_info.product_catid[kk].value;
					if(list_getat(deger,2,'-') !=0)
					{	
						alert("<cf_get_lang dictionary_id ='43844.Bu Kategori ile Ek Bilgi Girişi Yapılmıştır !İlgili Kategori'> : "+upd_pro_info.product_catid[kk].text);
						return false;
					}
				}
			}				
			if(product_catid_selected == 0)
			{
				alert("<cf_get_lang dictionary_id ='44680.En Az Bir Ürün Kategorisi Seçiniz'>!");
				return false;
			}
	
		}
		if(upd_pro_info.owner_type_id.value == -13)
		{
			sub_assetid_selected = 0;
			for(kk=0;kk<document.upd_pro_info.sub_assetid.length; kk++)
			{
				if(upd_pro_info.sub_assetid[kk].selected)
					sub_assetid_selected+=1;
				else
				{
					deger = upd_pro_info.sub_assetid[kk].value;
					if(list_getat(deger,2,'-') !=0)
					{	
						alert("<cf_get_lang dictionary_id ='43844.Bu Kategori ile Ek Bilgi Girişi Yapılmıştır !İlgili Kategori'> : "+upd_pro_info.sub_assetid[kk].text);
						return false;
					}
				}
			}				
			if(sub_assetid_selected == 0)
			{
				alert("<cf_get_lang dictionary_id ='42496.En Az Bir Varlık Tipi Seçiniz'>!");
				return false;
			}
		}
		if(upd_pro_info.owner_type_id.value == -18)
		{
			sub_assetid_selected = 0;
			for(kk=0;kk<document.upd_pro_info.work_catid.length; kk++)
			{
				if(upd_pro_info.work_catid[kk].selected)
					sub_assetid_selected+=1;
				else
				{
					deger = upd_pro_info.work_catid[kk].value;
					if(list_getat(deger,2,';') !=0)
					{	
						alert("<cf_get_lang dictionary_id ='43844.Bu Kategori ile Ek Bilgi Girişi Yapılmıştır !İlgili Kategori'> : "+upd_pro_info.work_catid[kk].text);
						return false;
					}
				}
			}				
			if(sub_assetid_selected == 0)
			{
				alert("<cf_get_lang dictionary_id ='42496.En Az Bir Varlık Tipi Seçiniz'>!");
				return false;
			}
		}
		for(x=1;x<=20;x++)
		{
	
				if (eval('document.upd_pro_info.property'+x+'_range').value>500)
				{
					alert(x +".<cf_get_lang dictionary_id ='58508.Satir'>; <cf_get_lang dictionary_id ='45174.Maksimum Karakter en fazla 500 karakter olabilir!'>");
					return false;
				}
	
		}
			return true;	
	}
</script>

