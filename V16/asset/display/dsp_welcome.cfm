<cf_xml_page_edit fuseact="asset.list_asset">
<cfset url_str = "">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_view" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.property_id" default="">
<cfparam name="attributes.record_par_id" default="">
<cfparam name="attributes.record_member" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.validate_date1" default="">
<cfparam name="attributes.validate_date2" default="">
<cfparam name="attributes.validate_date3" default="">
<cfparam name="attributes.validate_date4" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
	<cfset url_str = "#url_str#&assetcat_id=#attributes.assetcat_id#">
</cfif>
<cfif isdefined("attributes.property_id") and len(attributes.property_id)>
	<cfset url_str = "#url_str#&property_id=#attributes.property_id#">
</cfif>
<cfif isdefined("attributes.list")>
	<cfset url_str = "#url_str#&list=#attributes.list#">
</cfif>
<cfif isdefined("attributes.record_date1")>
	<cfset url_str = "#url_str#&record_date1=#attributes.record_date1#">
</cfif>
<cfif isdefined("attributes.record_date2")>
	<cfset url_str = "#url_str#&record_date2=#attributes.record_date2#">
</cfif>
<cfif isdefined("attributes.validate_date1")>
	<cfset url_str = "#url_str#&validate_date1=#attributes.validate_date1#">
</cfif>
<cfif isdefined("attributes.validate_date2")>
	<cfset url_str = "#url_str#&validate_date2=#attributes.validate_date2#">
</cfif>
<cfif isdefined("attributes.validate_date3")>
	<cfset url_str = "#url_str#&validate_date3=#attributes.validate_date3#">
</cfif>
<cfif isdefined("attributes.validate_date4")>
	<cfset url_str = "#url_str#&validate_date4=#attributes.validate_date4#">
</cfif>
<cfif isdefined("attributes.record_member")>
	<cfset url_str = "#url_str#&record_member=#attributes.record_member#">
</cfif>
<cfif isdefined("attributes.record_par_id")>
	<cfset url_str = "#url_str#&record_par_id=#attributes.record_par_id#">
</cfif>
<cfif isdefined("attributes.record_emp_id")>
	<cfset url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#">
</cfif>
<cfif isdefined("attributes.our_company_id")>
	<cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
</cfif>
<cfif isdefined("attributes.format")>
	<cfset url_str = "#url_str#&format=#attributes.format#">
</cfif>
<cfif isdefined("attributes.process_stage")>
	<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
</cfif>
<cfif len(attributes.project_head) and len(attributes.project_id)>
	<cfset url_str = "#url_str#&project_head=#attributes.project_head#&project_id=#attributes.project_id#">
</cfif>
<cfif len(attributes.product_id) and len(attributes.product_name)>
	<cfset url_str = "#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.record_date1") and isdate(attributes.record_date1)><cf_date tarih = "attributes.record_date1"></cfif>
<cfif isdefined("attributes.record_date2") and isdate(attributes.record_date2)><cf_date tarih = "attributes.record_date2"></cfif>
<cfif isdefined("attributes.validate_date1") and isdate(attributes.validate_date1)><cf_date tarih = "attributes.validate_date1"></cfif>
<cfif isdefined("attributes.validate_date2") and isdate(attributes.validate_date2)><cf_date tarih = "attributes.validate_date2"></cfif>
<cfif isdefined("attributes.validate_date3") and isdate(attributes.validate_date3)><cf_date tarih = "attributes.validate_date3"></cfif>
<cfif isdefined("attributes.validate_date4") and isdate(attributes.validate_date4)><cf_date tarih = "attributes.validate_date4"></cfif>
<cfquery name="GET_POSITION_COMPANIES" datasource="#DSN#">
    SELECT DISTINCT
        SP.OUR_COMPANY_ID,
        O.NICK_NAME
    FROM
        EMPLOYEE_POSITIONS EP,
        SETUP_PERIOD SP,
        EMPLOYEE_POSITION_PERIODS EPP,
        OUR_COMPANY O
    WHERE 
        SP.OUR_COMPANY_ID = O.COMP_ID AND
        SP.PERIOD_ID = EPP.PERIOD_ID AND
        EP.POSITION_ID = EPP.POSITION_ID AND
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	ORDER BY
		O.NICK_NAME
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%asset.list_asset%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>

<cfquery name="GET_COMPANY_SITES" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL ORDER BY SITE_DOMAIN
</cfquery>

<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_assets.cfm">
<cfelse>
	<cfset GET_ASSETS.recordcount = 0>
</cfif>
<cfquery name="FORMAT" datasource="#dsn#">
	SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
</cfquery>
<cfif isDefined("attributes.asset_archive")>
	<cfoutput>	
		<script type="text/javascript">
			function sendAsset(file,path,desc,asset_name,size,property)
			{	  
				document.asset_archive.filename.value = file;
				document.asset_archive.filepath.value = path;
				document.asset_archive.filesize.value = size;
				document.asset_archive.property_id.value = property;								
				document.asset_archive.module_id.value = <cfif isdefined("attributes.module_id")>#attributes.module_id#<cfelse>''</cfif>;
				document.asset_archive.action_id.value = <cfif isdefined("attributes.action_id")>#attributes.action_id#<cfelse>''</cfif>;
				document.asset_archive.action_type.value = <cfif isdefined("attributes.action_type")>#attributes.action_type#<cfelse>0</cfif>;
				document.asset_archive.action_section.value = <cfif isdefined("attributes.action")>'#attributes.action#'<cfelse>''</cfif>;
				document.asset_archive.asset_cat_id.value = <cfif isdefined("attributes.asset_cat_id")>#attributes.asset_cat_id#<cfelse>''</cfif>;								
				document.asset_archive.asset_name.value = asset_name;				
				document.asset_archive.keyword.value = desc;		
				document.asset_archive.submit();			
			}
		</script>
		<form name="asset_archive" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_all_asset&asset_archive=true">
			<input type="hidden" name="filename" id="filename" value="">
			<input type="hidden" name="filepath" id="filepath" value="">
			<input type="hidden" name="filesize" id="filesize" value="">
			<input type="hidden" name="property_id" id="property_id" value="">				
			<input type="hidden" name="module_id" id="module_id" value="">
			<input type="hidden" name="action_id" id="action_id" value="">
			<input type="hidden" name="action_type" id="action_type" value="">
			<input type="hidden" name="action_section" id="action_section" value="">
			<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="">
			<input type="hidden" name="asset_name" id="asset_name" value="">						
			<input type="hidden" name="keyword" id="keyword" value="">
			<input type="hidden" name="module" id="#attributes.module#">
		</form>
	</cfoutput>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_assets.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_asset" action="#request.self#?fuseaction=asset.list_asset" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
	<cf_big_list_search title="#getLang('main',150)#">
		<cf_big_list_search_area>
			<table>
				<tr>
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<cfif x_is_asset_stage eq 1>
						<td>
							<select name="process_stage" id="process_stage" style="width:70px;">
								<cfoutput query="get_process_stage">
									<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
								</cfoutput>
                                <option value="" <cfif isdefined("attributes.process_stage") and (attributes.process_stage is 'null')>selected</cfif>>Aşamasız</option>
							</select>
						</td>
					</cfif>
					<td>
						<select name="is_view" id="is_view">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<option value="1"<cfif isdefined("attributes.is_view") and (attributes.is_view eq 1)>selected</cfif>><cf_get_lang_main no ='667.İnternet'></option>
							<option value="0"<cfif isdefined("attributes.is_view") and (attributes.is_view eq 0)>selected</cfif>><cf_get_lang no='193.Normal'></option>
						</select>
					</td>
					<td><select name="format" id="format">
							<option value=""><cf_get_lang_main no='1182.Format'></option>
							<cfoutput query="format">
								<option value=".#format_symbol#"<cfif isdefined("attributes.format") and attributes.format is '.#format_symbol#'>selected</cfif>>#format_symbol#</option>
							</cfoutput>
						</select>
					</td>
					<td><select name="list" id="list">
							<option value="list"><cf_get_lang_main no='97.List'> 
							<option value="thumb" <cfif isdefined("attributes.list") and (attributes.list is "thumb")>selected</cfif>><cf_get_lang_main no='249.Thumbnail'>
						</select>
					</td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Kayıt Sayısı Hatalı!'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;"></td>
					<td><cf_wrk_search_button search_function="date_control()"></td>
				</tr>
			</table>
		</cf_big_list_search_area>
		<cf_big_list_search_detail_area>
			<table>
				<tr>
					<cfif xml_show_product eq 1>
						<td>
							<cf_get_lang_main no='245.Ürün'>
							<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)> value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
							<input type="text" name="product_name" id="product_name" style="width:125px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','130');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search_asset.product_id&field_name=search_asset.product_name&keyword='+encodeURIComponent(document.getElementById('product_name').value),'list');"><img src="/images/plus_thin.gif"></a>
						</td>
					</cfif>
                    <td>
                    	<cfsavecontent variable="text"><cf_get_lang no='24.Döküman Tipleri'></cfsavecontent>
						<cf_wrk_combo 
						name="property_id"
						query_name="GET_CONTENT_PROPERTY"
						value="#attributes.property_id#"
						option_name="name"
						option_text="#text#"
						option_value="content_property_id">			
					</td>
                    <td>
						<select name="is_active" id="is_active" style="width:90px;">
							<option value=""><cf_get_lang_main no='296.Tümü'></option>
							<option value="1" <cfif isdefined("attributes.is_active") and attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
							<option value="0" <cfif isdefined("attributes.is_active") and attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
						</select>
                    </td>
					<td><cf_get_lang_main no='162.Sirket'></td>
					<td>
						<select name="our_company_id" id="our_company_id" style="width:120px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_position_companies">
								<option value="#our_company_id#" <cfif isdefined("attributes.our_company_id") and attributes.our_company_id eq our_company_id>selected</cfif>>#nick_name#</option>
							</cfoutput>
						</select>
					</td>
					<td><cf_get_lang_main no='215.Kayıt Tarihi'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='38.Kayıt Tarihini Kontrol Ediniz!'>!</cfsavecontent> 
						<cfinput type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="record_date1">
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='38.Kayıt Tarihini Kontrol Ediniz!'>!</cfsavecontent> 
						<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="record_date2">
					</td>
				</tr>
                <tr>
                	<cfif xml_show_project eq 1>
						<td>
							<cf_get_lang_main no='4.Proje'>
							<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<input type="text" name="project_head" id="project_head" style="width:125px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
							<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='1385.Proje Seçiniz'>"></a>
						</td>
					</cfif>
                    <td><cfquery name="get_temp_asset" datasource="#DSN#">
							SELECT 
								ASSETCAT_ID,  
								d#dsn#.Get_Dynamic_LanguageASSETCAT_ID,'#session.ep.language#','ASSET_CAT','ASSETCAT',NULL,NULL,ASSETCAT) AS ASSETCAT 
							FROM 
								ASSET_CAT 
							WHERE 
								ASSETCAT_ID >= 0 ORDER BY ASSETCAT
						</cfquery>
						<select name="assetcat_id" id="assetcat_id">				   
							<option value="" selected><cf_get_lang_main no='1739.Tüm Kategoriler'></option>
							<cfif get_module_user(17)>
								<option value="-4"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -4)> selected</cfif>><cf_get_lang_main no='239.Antlaşma'></option> 
							</cfif> 
							<cfif get_module_user(9)>
								<option value="-6"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -6)> selected</cfif>><cf_get_lang_main no='7.Eğitim'></option>
							</cfif> 
							<cfif get_module_user(11)>
								<option value="-13"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -13)> selected</cfif>><cf_get_lang_main no='200.Fırsat'></option>
							</cfif>	
							<cfif get_module_user(16)>
								<option value="-17"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -17)> selected</cfif>><cf_get_lang_main no='30.Finans'></option>	
							</cfif>
							<cfif get_module_user(16)>
								<option value="-23"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -23)> selected</cfif>><cf_get_lang_main no='1421.Fiziki Varlık'></option>	
							</cfif>
							<cfif get_module_user(10)>
								<option value="-10"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -10)> selected</cfif>><cf_get_lang_main no='9.Forum'></option> 
							</cfif>
							<cfif get_module_user(22)>
								<option value="-16"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -16)> selected</cfif>><cf_get_lang_main no='240.Hesap'></option>
							</cfif>
							<cfif get_module_user(2)>
								<option value="-7"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -7)> selected</cfif>><cf_get_lang_main no='241.İçerik'></option>
							</cfif>
							<cfif get_module_user(29)>
								<option value="-2"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -2)> selected</cfif>><cf_get_lang_main no='47.Yazışmalar'></option>
							</cfif>
							<cfif get_module_user(3)>
								<option value="-8"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -8)> selected</cfif>><cf_get_lang_main no='32.İnsan Kaynakları'></option>
							</cfif>
							<cfif get_module_user(15)>
								<option value="-15"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -15)> selected</cfif>><cf_get_lang_main no='34.Kampanya'></option>
							</cfif> 
							<cfif get_module_user(1)>
								<option value="-1"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -1)> selected</cfif>><cf_get_lang_main no='4.Proje'></option>
							</cfif> 
							<cfif get_module_user(14)> 
								<option value="-5"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -5)> selected</cfif>><cf_get_lang_main no='244.Servis'></option>
							</cfif>
							<cfif get_module_user(11)>
								<option value="-12"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -12)> selected</cfif>><cf_get_lang_main no='199.Sipariş'></option>
							</cfif>
							<cfif get_module_user(11)>
								<option value="-11"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -11)> selected</cfif>><cf_get_lang_main no='133.Teklif'></option>
							</cfif>
							<cfif get_module_user(5)>
								<option value="-3"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -3)> selected</cfif>><cf_get_lang_main no='245.Ürün'></option>
							</cfif>
							<cfif get_module_user(4)>
								<option value="-9"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -9)> selected</cfif>><cf_get_lang_main no='246.Üye'></option>
							</cfif> 
							<cfif get_module_user(17)>
								<option value="-19"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -19)> selected</cfif>><cf_get_lang_main no='1420.Abone'></option> 
							</cfif> 
							<cfif get_module_user(17)>
								<option value="-20"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -20)> selected</cfif>><cf_get_lang_main no='1033.İş'></option> 
							</cfif> 
							<cfif get_module_user(17)>
								<option value="-21"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -21)> selected</cfif>><cf_get_lang_main no='29.Fatura'></option> 
							</cfif> 
							<cfif get_module_user(17)>
								<option value="-22"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -22)> selected</cfif>><cf_get_lang_main no='1713.Olay'></option> 
							</cfif> 
							<cfif get_module_user(37)>
								<option value="-25"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -25)> selected</cfif>>Worknet Katalog Belgeleri</option>
							</cfif>
								<option value="-18"<cfif isDefined("attributes.assetcat_id") and (attributes.assetcat_id EQ -18)> selected</cfif>><cf_get_lang_main no='247.Satış Bölgesi'></option>					
							<cfoutput query="get_temp_asset">
								<option value="#assetcat_id#" <cfif isdefined("attributes.assetcat_id") and (attributes.assetcat_id eq assetcat_id)>selected</cfif>>#assetcat#</option> 
							</cfoutput>
						</select>
					</td>
                    <td>
						<select name="site_domain" id="site_domain" style="width:90px;">
							<option value=""><cf_get_lang no='198.Site'></option>
							<cfoutput query="GET_COMPANY_SITES">
								<option value="#site_domain#" <cfif isdefined("attributes.site_domain") and attributes.site_domain is site_domain>selected</cfif>>#site_domain#</option>
							</cfoutput>
						</select>
					</td>
                    <td><cf_get_lang_main no='487.Kaydeden'></td>
					<td>
						<input type="hidden" name="record_par_id" id="record_par_id" value="<cfoutput>#attributes.record_par_id#</cfoutput>">
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#attributes.record_emp_id#</cfoutput>">
						<cfinput type="text" name="record_member" value="#attributes.record_member#" style="width:120px;" onFocus="AutoComplete_Create('record_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','record_par_id,record_emp_id','search_asset','3','250');">	
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.record_emp_id&field_name=search_asset.record_member&field_partner=search_asset.record_par_id&select_list=1,2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='487.Kaydeden'>"></a>
					</td>
                    <td><cf_get_lang no='31.Geçerlilik Başlangıç Tarihi'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1080.Tarihi Kontrol Ediniz'>!</cfsavecontent> 
						<cfinput type="text" name="validate_date1" id="validate_date1" value="#dateformat(attributes.validate_date1,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="validate_date1">
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1080.Tarihi Kontrol Ediniz'>!</cfsavecontent> 
						<cfinput type="text" name="validate_date2" id="validate_date2" value="#dateformat(attributes.validate_date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="validate_date2">
					</td>
                </tr>
                <tr>
                	<td colspan="5"></td>
                	<td><cf_get_lang no='42.Geçerlilik Bitiş Tarihi'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1080.Tarihi Kontrol Ediniz'>!</cfsavecontent> 
						<cfinput type="text" name="validate_date3" id="validate_date3" value="#dateformat(attributes.validate_date3,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="validate_date3">
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1080.Tarihi Kontrol Ediniz'>!</cfsavecontent> 
						<cfinput type="text" name="validate_date4" id="validate_date4" value="#dateformat(attributes.validate_date4,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
						<cf_wrk_date_image date_field="validate_date4">
					</td>

                    </td>
                </tr>
			</table>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
</cfform>
<cfif isDefined("attributes.list")>
	<cfif attributes.list eq "list">
		<cfinclude template="list.cfm">
	<cfelse>
		<cfinclude template="../../objects/display/icon/thumbnail.cfm">
	</cfif>
<cfelse>
	<cfinclude template="list.cfm">			  
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function date_control()
	{
		if(!date_check(document.getElementById('record_date1'),document.getElementById('record_date2'),'<cf_get_lang_main no="1450.Baslangic Tarihi Bitis Tarihinden Buyuk Olamaz!">'))
			return false;
		else
			return true;
			
		if(!date_check(document.getElementById('validate_date1'),document.getElementById('validate_date2'),'<cf_get_lang_main no="1450.Baslangic Tarihi Bitis Tarihinden Buyuk Olamaz!">'))
			return false;
		else
			return true;
			
		if(!date_check(document.getElementById('validate_date3'),document.getElementById('validate_date4'),'<cf_get_lang_main no="1450.Baslangic Tarihi Bitis Tarihinden Buyuk Olamaz!">'))
			return false;
		else
			return true;
	}
</script>
