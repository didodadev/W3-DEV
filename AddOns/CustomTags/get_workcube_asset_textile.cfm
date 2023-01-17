<!---
Description :   
    Document Template 
Parameters :
    module_id       .-.- > module id from MODULES table           'required
    action_section  .-.- > table name used in the action id       'required
    action_id       .-.- > action id for every record in a module 'required
	design_id       .-.- > design type for use area  'not required
	is_add			.-.- > manage files (add,update,delete)
	action_type      .-.- > verinin numeric mi nvarchar mı oldugunu belirtir 0:numeric 1:nvarchar 
	company_id      .-.- > sadece o şirkette görünmesini sağlar..diğer şirketlerden giriş yapanlar göremez bu değeri yollamazsanız eklediğiniz varlığı tüm şirketler görür. Kullanımı : company_id="#session.ep.company_id#"
	is_image      .-.- > verinin imaj olup olmadigini belirtir
	style	'not required : default assetler gorunmuyor, gorunmesi icin parametre 1 olarak verilmeli
Syntax :
	<cf_get_workcube_asset asset_cat_id="<module asset category id>" module_id='<integer value>' action_section='<table name>' action_id='<integer value>' design_id='<integer value>'>
Sample :
	<cf_get_workcube_asset asset_cat_id="-7" module_id='2' action_section='CONTENT' action_id='#attributes.cntid#' design_id='0'>	
	 --->
 
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.is_image" default="0">
<cfparam name="attributes.width" default="">
<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfparam name="attributes.design_id" default="1">
<cfparam name="attributes.is_add" default="1">
<cfparam name="attributes.title" default="Belgeler">
<cfset getComponent = createObject('component','CustomTags.cfc.get_position_denied')>
<cfset module_name="8">
<cfset position_id = "#session.ep.position_code#">
<cfset user_id = "#session.ep.userid#">
<cfset denied_page = "asset.list_asset">
<cfset emp_del_buttons = getComponent.GET_EMP_DEL_BUTTONS(module_name : module_name, position_id : position_id, user_id : user_id, denied_page : denied_page)>
<cfscript>
	attributes.module = caller.fusebox.circuit;
	if (attributes.module eq 'prod') attributes.module = 'product_tree';
	if (attributes.module eq 'order') attributes.module = 'salespur';
	if (attributes.module eq 'offer') attributes.module = 'salespur';
	if (attributes.module eq 'opportunity') attributes.module = 'salespur';
	if (attributes.module eq 'sales') attributes.module = 'salespur';
	if (attributes.module eq 'purchase') attributes.module = 'salespur';
	if (attributes.module eq 'cheque') attributes.module = 'finance';
	if (attributes.module eq 'bank') attributes.module = 'finance';
	if (attributes.module eq 'training_management') attributes.module = 'training';
	if (attributes.module eq 'assetcare') attributes.module = 'assetcare';
	if (isdefined("attributes.module_name_info") and len(attributes.module_name_info)) attributes.module = attributes.module_name_info;
</cfscript>
<cfset mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
<cfset imageplayer_extensions = ".jpg,.jpeg,.bmp,.gif,.png,.wbmp"/>
<cfif attributes.design_id is 0>
    <cfquery name="GET_ASSET" datasource="#CALLER.DSN#">
        SELECT
            A.ASSET_FILE_NAME,
            A.MODULE_NAME,
            A.ASSET_ID,
            A.ASSETCAT_ID,
            A.ASSET_NAME,
            A.IMAGE_SIZE,
            A.ASSET_FILE_SERVER_ID,
            A.RELATED_COMPANY_ID,
            A.RELATED_CONSUMER_ID,
            A.RELATED_ASSET_ID,
            A.ACTION_ID,
            A.RECORD_EMP,
            A.RECORD_DATE,
            ASSET_CAT.ASSETCAT,
            ASSET_CAT.ASSETCAT_PATH,
            CP.NAME,
            ASSET_DESCRIPTION
        FROM
            ASSET A,
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
        ORDER BY 
            A.RECORD_DATE DESC,
            CP.NAME,
            A.ASSET_NAME 
    </cfquery>
	<cf_ajax_list>
		<tbody>
            <tr height="25">
                <cfoutput>
                    <td class="txtboldblue" width="100%">#attributes.title#</td> <!---İlişkili İmajlar---> <!--- Belgeler ---> 
                <cfif attributes.is_add eq 1>
                    <td align="right" nowrap>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_asset_digital&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif>&asset_archive=true','page','popup_asset_digital')"><IMG src="/images/report_square2.gif" border="0" alt=""></a>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.form_add_asset&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif><cfif attributes.is_image eq 1>&is_image=1</cfif>','small','popup_form_add_asset')"><img src="/images/plus_list.gif" border="0" alt="#caller.getLang('main',54)#"></a> <!--- Belge Ekle --->
                    </td>
                </cfif>
                </cfoutput>
            </tr>
            <cfoutput query="get_asset">
				<cfif assetcat_id gte 0>
					<cfset path_ = "asset/#assetcat_path#">
                <cfelse>
                    <cfset path_ = "#assetcat_path#">
                </cfif>
                
                <cfif caller.company_asset_relation eq 1>
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
				
                <tr height="20">
                    <td width="100%" cellspacing="0" cellpadding="0">
                    <cfset extention = listlast(asset_file_name,'.')>
                    <cfif extention eq "flv">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_flvplayer&video=#caller.file_web_path##assetcat_path#/#asset_file_name#','video','popup_flvplayer');" class="tableyazi" title="#ASSET_DESCRIPTION#">#asset_name#</a>
                    <cfelseif listfindnocase(mediaplayer_extensions, "." & extention)>
                        <a href="#caller.file_web_path##assetcat_path#/#asset_file_name#" class="tableyazi" title="#ASSET_DESCRIPTION#">#asset_name#</a>
                    <cfelseif listfindnocase(imageplayer_extensions, "." & extention)>
                        <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi"><img src="/images/attach.gif" align="absmiddle" border="0"></a>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_download_file&direct_show=1&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','list','popup_download_file');" class="tableyazi" title="#ASSET_DESCRIPTION#">#asset_name#</a>
                    <cfelse>
                        <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=#folder_#/#asset_file_name#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#" class="tableyazi" title="#ASSET_DESCRIPTION#">#asset_name#</a>
                    </cfif>
                        <cfif image_size eq 0>(#caller.getLang('main',515)#)		<!---Küçük--->
                        <cfelseif image_size eq 1>(#caller.getLang('main',516)#)	<!---Orta--->
                        <cfelseif image_size eq 2>(#caller.getLang('main',517)#)	<!---Büyük--->
                        </cfif>
                        <cfif currentrow is 1>
                            (#name#)
                        <cfelse>
                            <cfset old_row = currentrow - 1>
                            <cfif name neq name[old_row]>(#name#)</cfif>
                        </cfif>
                    </td>
                <cfif attributes.is_add eq 1>
                    <td align="right">
                        <a style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=asset.list_asset&event=updPopup&asset_id=#ASSET_ID#&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type#<cfif isdefined("attributes.action_id_2")>&action_id_2=#attributes.action_id_2#</cfif><cfif attributes.is_image eq 1>&is_image=1</cfif>','small','popup_form_upd_asset');"><img src="/images/update_list.gif" border="0" alt="#caller.getLang('main',52)#"></a><!--- Guncelle --->
                        <cfif not len(emp_del_buttons.is_delete) and emp_del_buttons.is_delete neq 1>
                            <cfif not listfindnocase(caller.denied_pages,'objects.emptypopup_del_asset')><a style="cursor:pointer;" onclick="javascript:if(confirm('#caller.getLang('main',1057)#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=#attributes.module#&file_name=#ASSET_FILE_NAME#&file_server_id=#ASSET_FILE_SERVER_ID#','small'); else return false;"><img src="/images/delete_list.gif" border="0" alt="#caller.getLang('main',51)#"></a> <!--- Sil --->		<!---Kayıtlı Belgeyi Siliyorsunuz, Emin Misiniz? ---></cfif>
                        </cfif>
                    </td>
                </cfif>
                </tr>
            </cfoutput>
		</tbody>
	</cf_ajax_list>
<cfelse>
	<cfsavecontent variable="baslik"><cfoutput>#attributes.title#</cfoutput></cfsavecontent> <!--- Belgeler --->
	<cfif isdefined("attributes.action_id_2")>
		<cfset add_= '&action_id_2=#attributes.action_id_2#'>
	<cfelse>
		<cfset add_=''>
	</cfif>
	<cfif isdefined("attributes.is_image") and attributes.is_image eq 1>
		<cfset info_='&is_image=1'>
	<cfelse>
		<cfset info_=''>
	</cfif>
	
	<cfif isdefined("attributes.is_add") and attributes.is_add eq 1>
		<cfset add2_ = '#request.self#?fuseaction=asset.list_asset&event=add&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type##add_##info_#'> 
		<cfset upd_ = '#request.self#?fuseaction=objects.popup_asset_digital&module=#attributes.module#&module_id=#attributes.module_id#&action=#attributes.action_section#&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&action_type=#attributes.action_type##add_#&asset_archive=true'>
	<cfelse>
		<cfset add2_ = ''>
		<cfset upd_ = ''>
	</cfif>
	<cfif attributes.is_image eq 1>
		<cfset baslik = "#caller.getLang('main',2165)#">
	</cfif>
	<cfif not isDefined("attributes.id")><cfset attributes.id = "get_related_assets"></cfif>
	<cfset url_str = ''>
    <cfif isdefined("attributes.action_type")><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
    <cfif isdefined("attributes.is_image")><cfset url_str =url_str&'&is_image=#attributes.is_image#'></cfif>
    <cfif isdefined("attributes.width")><cfset url_str =url_str&'&width=#attributes.width#'></cfif>
    <cfif isdefined("attributes.style")><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
    <cfif isdefined("attributes.action_section")><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
    <cfif isdefined("attributes.action_id")><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
    <cfif isdefined("attributes.action_id_2")><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
    <cfif isdefined("attributes.company_id")><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>
    <cfif isdefined("attributes.period_id")><cfset url_str =url_str&'&period_id=#attributes.period_id#'></cfif>
    <cfif isdefined("attributes.design_id")><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
    <cfif isdefined("attributes.is_add")><cfset url_str =url_str&'&is_add=#attributes.is_add#'></cfif>
    <cfif isdefined("attributes.module_id")><cfset url_str =url_str&'&module_id=#attributes.module_id#'></cfif>
    <cfif isdefined("attributes.asset_cat_id")><cfset url_str =url_str&'&asset_cat_id=#attributes.asset_cat_id#'></cfif>
    <cfif isdefined("attributes.module")><cfset url_str =url_str&'&module=#attributes.module#'></cfif>
    <cfset url_str = url_str&'&mediaplayer_extensions=#mediaplayer_extensions#'>
    <cfset url_str = url_str&'&imageplayer_extensions=#imageplayer_extensions#'>
   <cf_box id="#attributes.id#" closable="0" add_href="#add2_#" add_href_size="wide" collapsed="#iif(attributes.style,1,0)#" info_href="#upd_#" title="#baslik#" style="width:#attributes.width#px;" box_page="#request.self#?fuseaction=objects.ajax_files&#url_str#"></cf_box>
</cfif>
