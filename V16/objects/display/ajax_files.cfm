<cfif not isNumeric(attributes.action_id)>
    <cfset attributes.action_id= '#contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id,accountKey:'wrk')#'>  
</cfif>
<cfif not isDefined("attributes.mediaplayer_extensions")>
    <cfset attributes.mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
</cfif>
<cfif not isDefined("attributes.imageplayer_extensions")>
    <cfset attributes.imageplayer_extensions = ".jpg,.jpeg,.bmp,.gif,.png,.wbmp"/>
</cfif>
<cfif not isDefined("attributes.is_add")>
    <cfparam name="attributes.is_add" default="1">
</cfif>
<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT
		A.ASSET_FILE_NAME,
        A.ASSET_FILE_PATH_NAME,
		A.MODULE_NAME,
		A.ASSET_ID,
		A.ASSETCAT_ID,
		A.ASSET_NAME,
		A.IMAGE_SIZE,
		A.ASSET_FILE_SERVER_ID,
		A.RELATED_COMPANY_ID,
		A.RELATED_CONSUMER_ID,
        A.RELATED_ASSET_ID,
        A.RECORD_EMP,
        A.RECORD_DATE,
        A.EMBEDCODE_URL,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_PATH,
		CP.NAME,
		ASSET_DESCRIPTION,
        E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME AS EMP_NAME,
        A.ACTION_ID
	FROM
		ASSET A
        LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = A.RECORD_EMP,
		CONTENT_PROPERTY CP,
		ASSET_CAT
	WHERE
        A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#"> AND
		(
			<!--- Proje iliskisi coklu kuruldugunda diger projelerde de belge gorunsun isteniyor fbs 20130514 --->
			<cfif ucase(attributes.action_section) is 'PROJECT_ID'>
				PROJECT_MULTI_ID LIKE '%,#attributes.action_id#,%' OR
			</cfif>
			
			<cfif attributes.action_type eq 0>
				A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			<cfelse>
				A.ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_id#">
			  <cfif isdefined("attributes.action_id_2")>
				OR A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#">	
			  </cfif>
			</cfif>
		) AND
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
		<cfif isDefined('attributes.company_id')>
			AND A.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined('attributes.period_id') and len(attributes.period_id)>
			AND A.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
		</cfif>
		<cfif attributes.is_image eq 1>
			AND A.IS_IMAGE = 1
		<cfelse>
			AND (A.IS_IMAGE = 0 OR A.IS_IMAGE IS NULL)
		</cfif>
		AND 
		(
			A.IS_SPECIAL = 0 OR
		  	A.IS_SPECIAL IS NULL 
		  <cfif isdefined("session.ep")>
			OR (A.IS_SPECIAL = 1 AND (A.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR A.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">))
		  <cfelseif isDefined('session.pp')>
			OR (A.IS_SPECIAL = 1 AND (A.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR A.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">))
		  </cfif>
		)
<cfif isdefined("related_id") and isdefined("related_section")>
    UNION ALL
        SELECT
		A.ASSET_FILE_NAME,
        A.ASSET_FILE_PATH_NAME,
		A.MODULE_NAME,
		A.ASSET_ID,
		A.ASSETCAT_ID,
		A.ASSET_NAME,
		A.IMAGE_SIZE,
		A.ASSET_FILE_SERVER_ID,
		A.RELATED_COMPANY_ID,
		A.RELATED_CONSUMER_ID,
        A.RELATED_ASSET_ID,
        A.RECORD_EMP,
        A.RECORD_DATE,
        A.EMBEDCODE_URL,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_PATH,
		CP.NAME,
		ASSET_DESCRIPTION,
        E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME AS EMP_NAME,
        A.ACTION_ID
	FROM
		ASSET A
        LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = A.RECORD_EMP,
		CONTENT_PROPERTY CP,
		ASSET_CAT
	WHERE
        A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.related_section)#"> AND
		(
			<!--- Proje iliskisi coklu kuruldugunda diger projelerde de belge gorunsun isteniyor fbs 20130514 --->
			<cfif ucase(attributes.action_section) is 'PROJECT_ID'>
				PROJECT_MULTI_ID LIKE '%,#attributes.action_id#,%' OR
			</cfif>
			
			<cfif attributes.action_type eq 0>
				A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_id#">
			<cfelse>
				A.ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_id#">
			</cfif>
		) AND
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
		<cfif isDefined('attributes.company_id')>
			AND A.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined('attributes.period_id') and len(attributes.period_id)>
			AND A.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
		</cfif>
		<cfif attributes.is_image eq 1>
			AND A.IS_IMAGE = 1
		<cfelse>
			AND (A.IS_IMAGE = 0 OR A.IS_IMAGE IS NULL)
		</cfif>
		AND 
		(
			A.IS_SPECIAL = 0 OR
		  	A.IS_SPECIAL IS NULL 
		  <cfif isdefined("session.ep")>
			OR (A.IS_SPECIAL = 1 AND (A.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR A.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">))
		  <cfelseif isDefined('session.pp')>
			OR (A.IS_SPECIAL = 1 AND (A.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR A.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">))
		  </cfif>
		)
</cfif>
	ORDER BY 
    	A.RECORD_DATE DESC,
		CP.NAME,
		A.ASSET_NAME 
</cfquery>
<cfset getComponent = createObject('component','CustomTags.cfc.get_position_denied')>
<cfset module_name="8">
<cfset position_id = "#session.ep.position_code#">
<cfset user_id = "#session.ep.userid#">
<cfset denied_page = "asset.list_asset">
<cfset emp_del_buttons = getComponent.GET_EMP_DEL_BUTTONS(module_name : module_name, position_id : position_id, user_id : user_id, denied_page : denied_page)>
<cfif isDefined("attributes.is_box") and attributes.is_box eq 1>
    <cf_box 
        title="#getLang('','Belgeler',57568)#" 
        closable="1" 
        popup_box="1" 
        add_href_size="wide" 
        info_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_asset_digital&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#&add=&asset_archive=true');"
        add_href="#request.self#?fuseaction=asset.list_asset&event=add&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#&add=&info=">
        <cf_ajax_list>
            <tbody>
                <cfif get_asset.recordcount>
                    <cfoutput query="get_asset">
                        <cfif not len(ASSET_FILE_PATH_NAME)>
                            <cfif assetcat_id gte 0>
                                <cfset path_ = "asset/#assetcat_path#">
                            <cfelse>
                                <cfset path_ = "#assetcat_path#">
                            </cfif>
                        <cfelse>
                            <cfset path_ = "">
                        </cfif>
                        
                        <cfif company_asset_relation eq 1>
                            <cfif len(get_asset.related_asset_id)>
                                <cfquery name="getAssetRelated" datasource="#dsn#">
                                    SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = #get_asset.related_asset_id#
                                </cfquery>
                                <cfif len(getAssetRelated.action_id)>
                                    <cfset folder_="#path_#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#">
                                <cfelse>
                                    <cfset folder_="#path_#/#year(get_asset.record_date)#">
                                </cfif>
                            <cfelseif len(get_asset.action_id)>
                                <cfset folder_="#path_#/#year(get_asset.record_date)#/#get_asset.action_id#">
                            <cfelse>
                                <cfset folder_="#path_#/#year(get_asset.record_date)#">
                            </cfif>
                        <cfelse>
                            <cfset folder_ = path_>
                        </cfif>
                        <tr>
                            <td width="100%">
                                <cfset link_name = ''>
                                <cfif len(record_emp)>
                                    <cfset link_name = emp_name>
                                </cfif>
                                <cfset link_name = "#link_name# #DateFormat(record_date,dateformat_style)# #TimeFormat(record_date,timeformat_style)#">
                                <cfset extention = listlast(asset_file_name,'.')>
                                <cfif isdefined("get_asset.EMBEDCODE_URL") and len(get_asset.EMBEDCODE_URL)>
                                    <a href="#get_asset.EMBEDCODE_URL#" target="_blank" title="#link_name#">#asset_name#</a>
                                <cfelse>
                                    <cfif extention eq "flv">
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_flvplayer&video=#file_web_path##assetcat_path#/#asset_file_name#','video','popup_flvplayer');" title="#link_name#">#asset_name#</a>
                                    <cfelseif listfindnocase(attributes.mediaplayer_extensions, "." & extention)>
                                        <a href="#file_web_path##assetcat_path#/#asset_file_name#" class="tableyazi">#asset_name#</a>
                                    <cfelseif listfindnocase(attributes.imageplayer_extensions, "." & extention)>
                                        <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi" title="#link_name#"><i class="fa fa-paperclip"></i></a>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&direct_show=1&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','list','popup_download_file');" class="tableyazi" title="#link_name#">#asset_name#</a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi" title="#link_name#">#asset_name#</a>
                                    </cfif>
                                </cfif>
            
                                <cfif image_size eq 0>(#getLang('main',515)#)		<!---Küçük--->
                                <cfelseif image_size eq 1>(#getLang('main',516)#)	<!---Orta--->
                                <cfelseif image_size eq 2>(#getLang('main',517)#)	<!---Büyük--->
                                </cfif>
                                <cfif currentrow is 1>
                                    (#name#)
                                <cfelse>
                                    <cfset old_row = currentrow - 1>
                                    <cfif name neq name[old_row]>(#name#)</cfif>
                                </cfif>
                            </td>
                            <cfif attributes.is_add eq 1>
                                <td>
                                    <a style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=asset.list_asset&event=updPopup&asset_id=#asset_id#&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif><cfif attributes.is_image eq 1>&is_image=1</cfif>','longpage','popup_form_upd_asset');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                </td>
                                <cfif not len(emp_del_buttons.is_delete) and emp_del_buttons.is_delete neq 1>
                                    <cfif not listfindnocase(denied_pages,'objects.emptypopup_del_asset')>
                                        <td>
                                            <a style="cursor:pointer;" onclick="javascript:if(confirm('<cf_get_lang dictionary_id="58469.Kayıtlı Belgeyi Siliyorsunuz, Emin Misiniz?">')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=#attributes.module#&file_name=#asset_file_name#&file_server_id=#asset_file_server_id#','small'); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                        </td>
                                    </cfif><!---Kayıtlı Belgeyi Siliyorsunuz, Emin Misiniz? --->
                                </cfif>
                            </cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <cfoutput>
                        <tr>
                            <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        </tr>
                    </cfoutput>	
                </cfif>
            </tbody>
        </cf_ajax_list>
    </cf_box>
<cfelse>
    <cf_ajax_list>
        <tbody>
            <cfif get_asset.recordcount>
                <cfoutput query="get_asset">
                    <cfif not len(ASSET_FILE_PATH_NAME)>
                        <cfif assetcat_id gte 0>
                            <cfset path_ = "asset/#assetcat_path#">
                        <cfelse>
                            <cfset path_ = "#assetcat_path#">
                        </cfif>
                    <cfelse>
                        <cfset path_ = "">
                    </cfif>
                    
                    <cfif company_asset_relation eq 1>
                        <cfif len(get_asset.related_asset_id)>
                            <cfquery name="getAssetRelated" datasource="#dsn#">
                                SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = #get_asset.related_asset_id#
                            </cfquery>
                            <cfif len(getAssetRelated.action_id)>
                                <cfset folder_="#path_#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#">
                            <cfelse>
                                <cfset folder_="#path_#/#year(get_asset.record_date)#">
                            </cfif>
                        <cfelseif len(get_asset.action_id)>
                            <cfset folder_="#path_#/#year(get_asset.record_date)#/#get_asset.action_id#">
                        <cfelse>
                            <cfset folder_="#path_#/#year(get_asset.record_date)#">
                        </cfif>
                    <cfelse>
                        <cfset folder_ = path_>
                    </cfif>
                    <tr>
                        <td width="100%">
                            <cfset link_name = ''>
                            <cfif len(record_emp)>
                                <cfset link_name = emp_name>
                            </cfif>
                            <cfset link_name = "#link_name# #DateFormat(record_date,dateformat_style)# #TimeFormat(record_date,timeformat_style)#">
                            <cfset extention = listlast(asset_file_name,'.')>
                            <cfif isdefined("get_asset.EMBEDCODE_URL") and len(get_asset.EMBEDCODE_URL)>
                                <a href="#get_asset.EMBEDCODE_URL#" target="_blank" title="#link_name#">#asset_name#</a>
                            <cfelse>
                                <cfif extention eq "flv">
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_flvplayer&video=#file_web_path##assetcat_path#/#asset_file_name#','video','popup_flvplayer');" title="#link_name#">#asset_name#</a>
                                <cfelseif listfindnocase(attributes.mediaplayer_extensions, "." & extention)>
                                    <a href="#file_web_path##assetcat_path#/#asset_file_name#" class="tableyazi">#asset_name#</a>
                                <cfelseif listfindnocase(attributes.imageplayer_extensions, "." & extention)>
                                    <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi" title="#link_name#"><i class="fa fa-paperclip"></i></a>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&direct_show=1&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','list','popup_download_file');" class="tableyazi" title="#link_name#">#asset_name#</a>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi" title="#link_name#">#asset_name#</a>
                                </cfif>
                            </cfif>
        
                            <cfif image_size eq 0>(#getLang('main',515)#)		<!---Küçük--->
                            <cfelseif image_size eq 1>(#getLang('main',516)#)	<!---Orta--->
                            <cfelseif image_size eq 2>(#getLang('main',517)#)	<!---Büyük--->
                            </cfif>
                            <cfif currentrow is 1>
                                (#name#)
                            <cfelse>
                                <cfset old_row = currentrow - 1>
                                <cfif name neq name[old_row]>(#name#)</cfif>
                            </cfif>
                        </td>
                        <cfif attributes.is_add eq 1>
                            <td>
                                <a style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=asset.list_asset&event=updPopup&asset_id=#asset_id#&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif><cfif attributes.is_image eq 1>&is_image=1</cfif>','longpage','popup_form_upd_asset');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>
                            <cfif not len(emp_del_buttons.is_delete) and emp_del_buttons.is_delete neq 1>
                                <cfif not listfindnocase(denied_pages,'objects.emptypopup_del_asset')>
                                    <td>
                                        <a style="cursor:pointer;" onclick="javascript:if(confirm('<cf_get_lang dictionary_id="58469.Kayıtlı Belgeyi Siliyorsunuz, Emin Misiniz?">')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=#attributes.module#&file_name=#asset_file_name#&file_server_id=#asset_file_server_id#','small'); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                    </td>
                                </cfif><!---Kayıtlı Belgeyi Siliyorsunuz, Emin Misiniz? --->
                            </cfif>
                        </cfif>
                    </tr>
                </cfoutput>
            <cfelse>
                <cfoutput>
                    <tr>
                        <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                    </tr>
                </cfoutput>	
            </cfif>
        </tbody>
    </cf_ajax_list>
</cfif>