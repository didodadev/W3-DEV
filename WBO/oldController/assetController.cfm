<cf_get_lang_set module_name="asset">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
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
    <cfparam name="attributes.sort_type" default="1">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
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
    <cfif isdefined("attributes.sort_type")>
        <cfset url_str = "#url_str#&sort_type=#attributes.sort_type#">
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
        <cfinclude template="../asset/query/get_assets.cfm">
    <cfelse>
        <cfset GET_ASSETS.recordcount = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#GET_ASSETS.recordcount#">
    <cfquery name="FORMAT" datasource="#dsn#">
        SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
    </cfquery>
    
    <cfquery name="GET_TEMP_ASSET" datasource="#DSN#">
        SELECT 
            ASSETCAT_ID,  
            catalyst_cf.Get_Dynamic_Language(ASSETCAT_ID,'#session.ep.language#','ASSET_CAT','ASSETCAT',NULL,NULL,ASSETCAT) AS ASSETCAT 
        FROM 
            ASSET_CAT 
        WHERE 
            ASSETCAT_ID >= 0 
        ORDER BY 
            ASSETCAT
    </cfquery> 

<!--- ekleme --->
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit fuseact="asset.form_add_asset">
    <cf_papers paper_type="ASSET">
    <cfset system_paper_no=paper_code & '-' & paper_number>
    <cfset system_paper_no_add=paper_number>
    <cfif len(paper_number)>
        <cfset asset_no = system_paper_no>
    <cfelse>
        <cfset asset_no = ''>
    </cfif>
    <cfif isdefined("attributes.revision")>
        <cfset asset_no = attributes.asset_no>
        <cfquery name="GET_ASSET_NO" datasource="#DSN#">
            SELECT ISNULL(MAX(REVISION_NO),0) REVISION_NO FROM ASSET WHERE ASSET_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">
        </cfquery>
        <cfset attributes.revision_no = (get_asset_no.revision_no+1)>
        <cfset attributes.related_asset_id = attributes.asset_id>
    <cfelseif isdefined("attributes.asset_id") and len(attributes.asset_id)>
        <cfinclude template="../asset/query/get_asset.cfm">
        <cfset attributes.product_id = get_asset.product_id>
        <cfset attributes.asset_name = get_asset.asset_name>
        <cfset attributes.asset_cat_id = get_asset.assetcat_id>
        <cfset attributes.asset_description = get_asset.asset_description>
        <cfset attributes.asset_detail = get_asset.asset_detail>
        <cfset attributes.project_id = get_asset.project_id>
        <cfset attribute.property_id = get_asset.property_id>
        <cfset attributes.revision_no = get_asset.revision_no>
        <cfset attributes.related_asset_id = get_asset.related_asset_id>
        <cfset attributes.validate_start_date = get_asset.validate_start_date>
        <cfset attributes.validate_finish_date = get_asset.validate_finish_date>
    <cfelse>
        <cfset attributes.product_id = ''>
        <cfif not isdefined("attributes.asset_cat_id")>
            <cfset attributes.asset_cat_id = "">
        </cfif>
        <cfset attributes.asset_name = ''>
        <cfset attributes.stream_name = ''>
        <cfset attributes.asset_description = ''>
        <cfset attributes.asset_detail = ''>
        <cfset attributes.project_id = ''>
        <cfset attributes.project_head = ''>
        <cfset attributes.mail_receiver_partner_id = ''>
        <cfset attributes.mail_receiver_emp_id = ''>
        <cfset attributes.mail_receiver = ''>
        <cfset attributes.mail_cc_partner_id = ''>
        <cfset attributes.mail_cc_emp_id = ''>
        <cfset attributes.mail_cc = ''>
        <cfset attributes.revision_no = '0'>
        <cfset attributes.related_asset_id = ''>
        <cfset attributes.validate_start_date = ''>
        <cfset attributes.validate_finish_date = ''>
    </cfif>
    <cfparam name="attributes.stream_name" default="#createUUID()#"/>
    <cfinclude template="../asset/query/get_asset_cats.cfm">
    <cfinclude template="../objects/display/imageprocess/imcontrol.cfm">
    <cfinclude template="../asset/query/get_company_cat.cfm">
<cfinclude template="../asset/query/get_customer_cat_add.cfm">
    <cfquery name="GET_COMPANY_SITES" datasource="#DSN#">
        SELECT 
            MENU_ID,
            SITE_DOMAIN,
            OUR_COMPANY_ID 
        FROM 
            MAIN_MENU_SETTINGS 
        WHERE 
            SITE_DOMAIN IS NOT NULL
    </cfquery>
    <!---<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
        SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY ORDER BY NAME
    </cfquery>--->
    <cfquery name="GET_POSITION_CATS" datasource="#DSN#">
        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
    </cfquery>
    <cfquery name="GET_USER_GROUPS" datasource="#DSN#">
        SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
    </cfquery>
    <cfquery name="GET_DIGITAL_ASSET" datasource="#DSN#">
        SELECT GROUP_NAME,GROUP_ID FROM DIGITAL_ASSET_GROUP ORDER BY GROUP_NAME
    </cfquery>
    
    <!--- Proje Iliskileri --->
    <cfif isdefined("attributes.action") and attributes.action eq "PROJECT_ID" and isdefined("attributes.action_id") and len(attributes.action_id)><cfset attributes.project_id = attributes.action_id></cfif>
    <cfif isdefined("attributes.project_multi_id") and len(attributes.project_multi_id)><cfset attributes.project_id = attributes.project_multi_id></cfif>
    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfquery name="GET_PROJECT" datasource="#dsn#">
            SELECT PROJECT_HEAD,PROJECT_ID,COMPANY_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#attributes.project_id#)
        </cfquery>
    </cfif>

<!--- güncelleme --->
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
<cf_xml_page_edit fuseact="asset.form_add_asset">
<cfinclude template="../asset/query/get_asset.cfm">
<cfquery name="GET_ASSET_RELATEDS" datasource="#DSN#">
	SELECT 
	    ASSET_ID,
        USER_GROUP_ID,
        DIGITAL_ASSET_GROUP_ID,
        COMPANY_CAT_ID,
        CONSUMER_CAT_ID,
        POSITION_CAT_ID,
        ALL_EMPLOYEE,
        ALL_CAREER,
        ALL_INTERNET,
        ALL_PEOPLE
	FROM 
		ASSET_RELATED 
    WHERE 
    	ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
</cfquery>
<cfquery name="DPL_DETAIL" datasource="#DSN3#">
	SELECT COUNT(DRAWING_PART_ROW.DPL_ID) COUNT_ FROM DRAWING_PART,DRAWING_PART_ROW WHERE DRAWING_PART.DPL_ID = DRAWING_PART_ROW.DPL_ID AND DPL_NO = '#get_asset.asset_no# - #get_asset.revision_no#'
</cfquery>
<cfif get_asset_relateds.recordcount>
	<cfquery name="GET_EMP_ALL" dbtype="query">
		SELECT ASSET_ID FROM GET_ASSET_RELATEDS WHERE ALL_EMPLOYEE = 1 OR ALL_PEOPLE = 1
	</cfquery>
	<cfif not get_emp_all.recordcount>
		<cfquery name="GET_USER_CAT" datasource="#DSN#">
			SELECT USER_GROUP_ID,POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
        <cfquery name="GET_DIGITAL_GROUPS" datasource="#DSN#">     	
            SELECT 
                DAG.GROUP_ID 
            FROM 
                DIGITAL_ASSET_GROUP DAG,
                DIGITAL_ASSET_GROUP_PERM DAGP
            WHERE 
                DAGP.GROUP_ID = DAG.GROUP_ID AND
                DAGP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        </cfquery>
        <cfquery name="control_user_cat" dbtype="query">
			SELECT ASSET_ID FROM get_asset_relateds WHERE <cfif get_digital_groups.recordcount>DIGITAL_ASSET_GROUP_ID IN (#ValueList(get_digital_groups.group_id)#) OR</cfif> <cfif len(get_user_cat.USER_GROUP_ID)>USER_GROUP_ID = #get_user_cat.USER_GROUP_ID# OR</cfif> POSITION_CAT_ID = #get_user_cat.POSITION_CAT_ID#
		</cfquery>
        <cfif isdefined("session.ep.userid")>
        	<cfset check_emp = "EMPLOYEE#session.ep.userid#">
        <cfelseif isdefined("session.pp.userid")>
        	<cfset check_emp = "PARTNER#session.pp.userid#">
        </cfif>
		<cfif not control_user_cat.recordcount and session.ep.userid neq get_asset.record_emp >
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='48537.Bu Dosyayı Görüntülemeye İzinli Değilsiniz! Kod : Yasaklı Kullanıcı'>");
				<cfif fuseaction contains 'popup'>
					window.close();
				</cfif>
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<cfinclude template="../asset/query/get_asset_cats.cfm">
<cfinclude template="../asset/query/get_company_cat.cfm">
<cfinclude template="../asset/query/get_customer_cat.cfm">
    <!--- tv yayın kategorisi --->
    <cfquery name="GET_COMPANY_SITE" datasource="#DSN#">
        SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
    </cfquery>
    
    <cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
        SELECT ASSET_ID,SITE_DOMAIN FROM ASSET_SITE_DOMAIN WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
    </cfquery>
    
    <cfquery name="GET_POSITION_CATS" datasource="#DSN#">
        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
    </cfquery>
    
    <cfquery name="GET_USER_GROUPS" datasource="#DSN#">
        SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
    </cfquery>
    
    <cfquery name="GET_DIGITAL_ASSET" datasource="#DSN#">
        SELECT GROUP_NAME,GROUP_ID FROM DIGITAL_ASSET_GROUP ORDER BY GROUP_NAME
    </cfquery>
    
    <cfquery name="GET_INTERNET" dbtype="query">
        SELECT ALL_INTERNET FROM GET_ASSET_RELATEDS WHERE ALL_INTERNET = 1
    </cfquery>
    
    <cfquery name="GET_CAREER" dbtype="query">
        SELECT ALL_CAREER FROM GET_ASSET_RELATEDS WHERE ALL_CAREER = 1
    </cfquery>
    
    <cfquery name="GET_ALL_PEOPLE" dbtype="query">
        SELECT ALL_PEOPLE FROM GET_ASSET_RELATEDS WHERE ALL_PEOPLE = 1
    </cfquery>
    
    <cfquery name="GET_ALL_EMPLOYEE" dbtype="query">
        SELECT ALL_EMPLOYEE FROM GET_ASSET_RELATEDS WHERE ALL_EMPLOYEE = 1
    </cfquery>
    
    <cfquery name="GET_COMPANY_CATS" dbtype="query">
        SELECT COMPANY_CAT_ID FROM GET_ASSET_RELATEDS WHERE COMPANY_CAT_ID IS NOT NULL
    </cfquery>
    <cfif get_company_cats.recordcount>
        <cfset company_cat_id_list = valuelist(get_company_cats.company_cat_id)>
    </cfif>
    
    <cfquery name="GET_CONSCAT" dbtype="query">
        SELECT CONSUMER_CAT_ID FROM GET_ASSET_RELATEDS WHERE CONSUMER_CAT_ID IS NOT NULL
    </cfquery>
    <cfif get_conscat.recordcount>
        <cfset conscat_id_list = valuelist(get_conscat.consumer_cat_id)>
    </cfif>
    
    <cfquery name="GET_POSITION_CAT" dbtype="query">
        SELECT POSITION_CAT_ID FROM GET_ASSET_RELATEDS WHERE POSITION_CAT_ID IS NOT NULL
    </cfquery>
    <cfif get_position_cat.recordcount>
        <cfset get_position_cat_list=valuelist(get_position_cat.position_cat_id)>
    </cfif>
    
    <cfquery name="GET_USER_GROUP" dbtype="query">
        SELECT USER_GROUP_ID FROM GET_ASSET_RELATEDS WHERE USER_GROUP_ID IS NOT NULL
    </cfquery>
    <cfif get_user_group.recordcount>
        <cfset get_user_group_list=valuelist(get_user_group.user_group_id)>
    </cfif>
    
    <cfquery name="GET_DIGITAL_ASSETS" dbtype="query">
        SELECT DIGITAL_ASSET_GROUP_ID FROM GET_ASSET_RELATEDS WHERE DIGITAL_ASSET_GROUP_ID IS NOT NULL
    </cfquery>
    <cfif GET_DIGITAL_ASSETS.recordcount>
        <cfset get_digital_asset_group_list=valuelist(GET_DIGITAL_ASSETS.DIGITAL_ASSET_GROUP_ID)>
    </cfif>
    
    <cfif len(get_asset.project_id) and x_is_asset_project_display eq 1>
        <cfset project_multi_id_ = get_asset.project_id>
    </cfif>
    <cfif len(get_asset.project_multi_id) and x_is_asset_project_display eq 2>
        <cfset project_multi_id_ = mid(get_asset.project_multi_id,2,len(get_asset.project_multi_id)-2)>
    </cfif>
    <cfif isdefined("project_multi_id_") and len(project_multi_id_)>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_HEAD,PROJECT_ID,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID 
            <cfif len(get_asset.project_multi_id) and x_is_asset_project_display eq 2>
                IN (#project_multi_id_#)
            <cfelse>
                =#project_multi_id_#
            </cfif>
        </cfquery>
    <cfelse>    
        <cfset get_project.recordcount = 0>
    </cfif>
    
    <cfif find(get_asset.asset_file_name, ".flv")>
        <cfset attributes.stream_name = Replace(get_asset.asset_file_name, ".flv", "") />
        <cfset attributes.is_stream = 1 />
    <cfelse>
        <cfset attributes.stream_name = createUUID() />
        <cfset attributes.is_stream = 0 />
    </cfif>
    <cfset session.resim = 4>
    <cfset session.module = "asset">

</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event")>
		<cfif isDefined("attributes.asset_archive")>
			<cfoutput>	
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
			</cfoutput>
		</cfif>		
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
	<cfelse>
		function detach(streamName)
		{
			document.getElementById("asset_file").disabled = "false";
			document.getElementById("stream_name").value = "";
			document.getElementById("is_stream").value = "0";
		}
<cfif isdefined("attributes.event") and attributes.event is 'add'>
	function get_content_property(type)
	{
		if(type == undefined)
			asset_cat_id = document.getElementById('assetcat_id').value;
		else
			asset_cat_id = type;
		
		if(asset_cat_id != '')
		{
			get_content_pro = wrk_safe_query('get_content_property','dsn',0,asset_cat_id);
			/*if(get_content_pro.recordcount == 0)
				get_content_pro = wrk_safe_query('get_content_property2','dsn',0,'0');*/
				
			var currency_len = document.getElementById("property_id").options.length;
			for(kk=currency_len;kk>=0;kk--)
				document.getElementById("property_id").options[kk] = null;	
				
			document.getElementById("property_id").options[0] = new Option('<cf_get_lang_main no="322.Seçiniz">','');
			for(var jj=0;jj < get_content_pro.recordcount;jj++)
				document.getElementById("property_id").options[jj+1]=new Option(get_content_pro.NAME[jj],get_content_pro.CONTENT_PROPERTY_ID[jj]);
				<cfif isDefined('attributes.property_id') and len(attributes.property_id)>
					if(get_content_pro.CONTENT_PROPERTY_ID[jj] == '<cfoutput>#attributes.property_id#</cfoutput>')
						document.getElementById("property_id").options[jj+1].selected = true;
				</cfif>
		}
	}
	<cfif isdefined('attributes.asset_cat_id') and len(attributes.asset_cat_id)>
		get_content_property('<cfoutput>#attributes.asset_cat_id#</cfoutput>');
	</cfif>
	//revizyondan gelen varlıklar icin
	<cfif isdefined("attributes.revision") and (attributes.revision)>
	window.onload = revision_load_functions;
	function revision_load_functions()
	{
		gizle_goster(broadcast_area);
		<cfif isdefined("attributes.digital_assets_all")>digital_assets_hepsi();</cfif>
		<cfif isdefined("attributes.user_group_id_all")>usergroup_hepsi();</cfif>
		<cfif isdefined("attributes.position_cat_id_all")>position_hepsi();</cfif>
		<cfif isdefined("attributes.customer_cat_all")>public_hepsi();</cfif>
		<cfif isdefined("attributes.is_internet")>
			//gizle_goster(is_site);
			gizle_goster(is_site_2);
		</cfif>
		<cfif isdefined("attributes.is_tv_publish") and attributes.is_tv_publish eq 1>goster(is_tv_folder);</cfif>
		<cfif isdefined("attributes.is_tv_publish") and attributes.is_tv_publish eq 2>gizle(is_tv_folder);</cfif>
	}
	</cfif>
	
	
	//videolar ekleme ile ilgili 
	function attachStream(streamName)
	{
		document.getElementById("asset_file").disabled = "true";
		// document.getElementById("asset_file").disabled = true;
		document.getElementById("stream_name").value = streamName;
		document.getElementById("is_stream").value = "1";
	}
		
	function detach(streamName)
	{
		document.getElementById("asset_file").disabled = "false";
		document.getElementById("stream_name").value = "";
		document.getElementById("is_stream").value = "0";
	}
	
	function check()
	{	
		var lstln = list_len(document.getElementById('asset_file').value,"\\");
		var file_string = list_getat(document.getElementById('asset_file').value,lstln,"\\");
		
		var tur_char = ["ü","ğ","ı","ş","ç","ö","Ü","Ğ","İ","Ş","Ç","Ö"]; 
		for(i=0; i<12; i++)
		{
			if(file_string.indexOf("" + tur_char[i] + "") > -1)
			{
				alert("<cf_get_lang no='14.Dosya adında türkçe karakter içermemeli'>");
				document.getElementById('asset_file').focus();
				return false;	
			}
		}	
		
		//if(!paper_control(add_asset.asset_no,'ASSET','1','','','','','','<cfoutput>#dsn#</cfoutput>')) return false;
		var send_mail = Number("<cfoutput>#is_receiver_and_cc_visible#</cfoutput>");
		if (send_mail == 1)
		{
			// Alıcı yoksa cc girememeli
			if ((document.add_asset.mail_cc.value.length != 0 && (document.add_asset.mail_cc_emp_id.value.length != 0 || document.add_asset.mail_cc_partner_id.value.length != 0)) && (document.add_asset.mail_receiver.value.length == 0 || (document.add_asset.mail_receiver.value.length != 0 && (document.add_asset.mail_receiver_emp_id.value.length == 0 && document.add_asset.mail_receiver_partner_id.value.length == 0))))
			{
				alert("<cf_get_lang no='190.Alıcı belirtilmeden CC belirtilemez !'>");
				return false;
			}
		}
		
		var obj =  document.add_asset.asset.value;
		var restrictedFormat = new Array('php','jsp','asp','cfm','cfml');
		
		if(document.getElementById('asset_no').value == '')
		{
			alert("<cf_get_lang_main no='468.Belge No'>!");
			return false;
		}
		
		if(document.getElementById('asset_description').value.length >1000)
		{
			alert("<cf_get_lang_main no='65.Hatalı veri'>:En Fazla 1000 Karakter!");
			return false;
		}
	
		if(document.getElementById('asset_detail').value.length >100)
		{
			alert("<cf_get_lang_main no='65.Hatalı veri'>:<cf_get_lang no ='174.En fazla 100 Karakter'> !");
			return false;
		}
	
		if (document.getElementById('assetcat_id') != undefined && document.getElementById('assetcat_id').value == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='74.Kategori'> !");
			return false;
		}
		
		if (document.getElementById('asset_file').value == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='68.Doküman'> !");
			return false;
		}
		
		
		if(document.getElementById('project_multi_id')!= undefined)
		{
			select_all('project_multi_id');
		}
		
		for(i=0;i<restrictedFormat.length;i++)
		if (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == restrictedFormat[i])
		{
			alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
			return false;										
		}
		else
		if((obj.length == (obj.indexOf('.') + 5)) && (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 5).toLowerCase() == restrictedFormat[i]))
		{
			alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
			return false;										
		}						
		
		if ((document.getElementById("stream_name").value == "") && (document.add_asset.asset.value == "")<cfif isdefined('internettv_folder_path') and len(internettv_folder_path)> && (document.getElementById('asset_path_name').value == "")</cfif>)
		{
				alert("<cf_get_lang no='48.Lütfen Varlık Seçiniz !'>");
				return false;
		}
		else	
		if (document.getElementById('asset_name').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='35.Varlık Adı !'>");
			return false;
		}
		else if ((document.getElementById("stream_name") != undefined && document.getElementById("stream_name").value == "") && document.add_asset.asset.value == "" <cfif isdefined('internettv_folder_path') and len(internettv_folder_path)>&& document.getElementById('asset_path_name').value == "<cfoutput>#internettv_path#</cfoutput>"</cfif>)
		{
			alert("<cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='68.Doküman'>");
			return false;
		}
		else
		if (document.getElementById('property_id').value == '')
		{
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='655.Döküman Tipi'> !");
			return false;
		}
		
		<cfif isDefined('x_is_product') and x_is_product eq 1>
			if((document.getElementById('product_id').value == '' || document.getElementById('product_name').value =='') && document.getElementById('is_dpl') != undefined && document.getElementById('is_dpl').checked==true)
			{
				alert('Ürün Seçiniz !');
				return false;
			}
		</cfif>
			
		<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
			<cfif isdefined("attributes.revision") and (attributes.revision)>
			if(document.getElementById('is_dpl').checked)
			{
				if(confirm('<cf_get_lang dictionary_id="52264.İlişkili DPL Kopyalansın mı ?">')==false)
				{
					document.getElementById('is_copy_dpl').value = 0;
				}
				if(document.getElementById('live').checked == true)	
				{
					if(confirm('<cf_get_lang dictionary_id="52265.Ana Üründe Bu Revizyon Geçerli Olacaktır">!')==false)
						return false;
				}
			}
			</cfif>
		</cfif>
		<cfif isdefined('x_is_asset_stage_display') and x_is_asset_stage_display eq 1>
			return process_cat_control();
		<cfelse>
			return true;
		</cfif>
	}
	function partner_hepsi()
	{
		if (document.add_asset.comp_cat_all.checked)
		{	
			for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
				document.add_asset.comp_cat[say].checked = true;
		}
		else
		{
			for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
				document.add_asset.comp_cat[say].checked = false;
		}
		return false;
	}
	function public_hepsi()
	{
		if (document.add_asset.customer_cat_all.checked)
		{	
			for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
				document.add_asset.customer_cat[say].checked = true;
		}
		else
		{
			for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
				document.add_asset.customer_cat[say].checked = false;
		}
		return false;
	}
	function position_hepsi()
	{
		if (document.add_asset.position_cat_id_all.checked)
		{	
			for(say=0;say<<cfoutput>#GET_POSITION_CATS.recordcount#</cfoutput>;say++)
				document.add_asset.position_cat_ids[say].checked = true;
		}
		else
		{
			for(say=0;say<<cfoutput>#GET_POSITION_CATS.recordcount#</cfoutput>;say++)
				document.add_asset.position_cat_ids[say].checked = false;
		}
		return false;
	}
	function usergroup_hepsi()
	{
		if (document.getElementById('user_group_id_all').checked)
		{	
			for(say=0;say<document.getElementsByName('user_group_ids').length;say++)
				document.getElementsByName('user_group_ids')[say].checked = true;
		}
		else
		{
			for(say=0;say<document.getElementsByName('user_group_ids').length;say++)
				document.getElementsByName('user_group_ids')[say].checked = false;
		}
		return false;
	}
	function digital_assets_hepsi()
	{
		if (document.getElementById('digital_assets_all').checked)
		{	
			for(say=0;say<document.getElementsByName('digital_assets').length;say++)
				document.getElementsByName('digital_assets')[say].checked = true;
		}
		else
		{
			for(say=0;say<document.getElementsByName('digital_assets').length;say++)
				document.getElementsByName('digital_assets')[say].checked = false;
		}
		return false;
	}
	
	function sel_digital_asset_group()
	{
		digital_assets_hepsi(); //Kosullara uygun kayit yoksa tumunu sec/kaldir calismis olur
		var GET_ASSET_GROUP = wrk_safe_query('ascr_get_emp_asset_group','dsn',0,document.getElementById('property_id').value);
		if(GET_ASSET_GROUP.recordcount)
		{
			var group_list = '0';
			for(say=0;say<GET_ASSET_GROUP.recordcount;say++)
				group_list = group_list+','+GET_ASSET_GROUP.GROUP_ID;
			for(say=1;say<=document.getElementsByName("digital_assets").length;say++)
			{
				if(list_find(group_list,document.getElementsByName("digital_assets")[say-1].value))
					document.getElementsByName("digital_assets")[say-1].checked = true;
				else
					document.getElementsByName("digital_assets")[say-1].checked = false;
			}
		}
	}
	function project_remove()
	{
		for (i=document.getElementById('project_multi_id').options.length-1;i>-1;i--)
		{
			if (document.getElementById('project_multi_id').options[i].selected==true)
			{
				document.getElementById('project_multi_id').options.remove(i);
			}	
		}
	}
	function select_all(selected_field)
	{
		var m = document.getElementById(selected_field).options.length;
		for(i=0;i<m;i++)
		{
			document.getElementById(selected_field)[i].selected=true;
		}
	}
	
	function dpl_yrm()
	{
	<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
		if(document.getElementById('featured').checked == true && document.getElementById('is_dpl').checked == false)
		{
			document.getElementById('featured').checked = false;
			alert("<cf_get_lang dictionary_id='52279.Yarı Mamül Seçmek İçin Önce DPL Seçmelisiniz'>!")
			return false;
		}
	</cfif>
	}
	function check_yrm()
	{
		<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
		if(document.getElementById('is_dpl').checked == false)
		{
			document.getElementById('featured').checked = false;
		}
		</cfif>
	}
	
	function pub_internet_func()
	{
		if(document.getElementById('is_internet').checked == true)
			goster(pub_internet);
		else
			gizle(pub_internet);	
	}
	
	pub_internet_func();
		</cfif>
		<cfif isdefined("attributes.event") and attributes.event is 'upd'>
			function get_content_property(old_type_id)
			{
				asset_cat_id = document.getElementById('assetcat_id').value;
				if(asset_cat_id != '')
				{
					get_content_pro = wrk_safe_query('get_content_property','dsn',0,asset_cat_id);
					/*if(get_content_pro.recordcount == 0)
						get_content_pro = wrk_safe_query('get_content_property2','dsn',0,0);*/
					var currency_len = document.getElementById("property_id").options.length;
					for(kk=currency_len;kk>=0;kk--)
						document.getElementById("property_id").options[kk] = null;	
					document.getElementById("property_id").options[0] = new Option('<cf_get_lang_main no="322.Seçiniz">','');
					for(var jj=0;jj < get_content_pro.recordcount;jj++)
					{
						document.getElementById("property_id").options[jj+1]=new Option(get_content_pro.NAME[jj],get_content_pro.CONTENT_PROPERTY_ID[jj]);
						if(old_type_id != undefined && get_content_pro.CONTENT_PROPERTY_ID[jj] == old_type_id)
							document.getElementById("property_id").options[jj+1].selected = true;
					}
				}
			}
			get_content_property("<cfoutput>#get_asset.property_id#</cfoutput>");
			function attachStream(streamName)
			{
				document.getElementById("asset_file").disabled = "true";
				document.getElementById("stream_name").value = streamName;
			}	
			function control()
			{
				var lstln = list_len(document.getElementById('asset_file').value,"\\");
				var file_string = list_getat(document.getElementById('asset_file').value,lstln,"\\");
				
				var tur_char = ["ü","ğ","ı","ş","ç","ö","Ü","Ğ","İ","Ş","Ç","Ö"]; 
				for(i=0; i<12; i++)
				{
					if(file_string.indexOf("" + tur_char[i] + "") > -1)
					{
						alert("<cf_get_lang no='14.Dosya adında türkçe karakter içermemeli'>");
						document.getElementById('asset_file').focus();
						return false;	
					}
				}
				
				var send_mail = Number("<cfoutput>#is_receiver_and_cc_visible#</cfoutput>");
				if (send_mail == 1)
				{
					// Alıcı yoksa cc girememeli
					if ((document.asset.mail_cc.value.length != 0 && (document.asset.mail_cc_emp_id.value.length != 0 || document.asset.mail_cc_partner_id.value.length != 0)) && (document.asset.mail_receiver.value.length == 0 || (document.asset.mail_receiver.value.length != 0 && (document.asset.mail_receiver_emp_id.value.length == 0 && document.asset.mail_receiver_partner_id.value.length == 0))))
					{
						alert("<cf_get_lang no='190.Alıcı belirtilmeden CC belirtilemez !'>");
						return false;
					}
				}
				var obj =  document.asset.asset.value;
				var restrictedFormat = new Array('php','jsp','asp','cfm','cfml');
				
				if(document.getElementById('asset_no').value == '')
				{
					alert("<cf_get_lang_main no='468.Belge No'>!");
					return false;
				}
				
				if(document.getElementById('asset_description').value.length >1000)
				{
					alert("<cf_get_lang_main no='65.Hatalı veri'>:En Fazla 1000 Karakter!");
					return false;
				}
				if(document.getElementById('asset_detail').value.length >100)
				{
					alert("<cf_get_lang_main no='65.Hatalı veri'>:<cf_get_lang no ='174.En fazla 500 Karakter'>!");
					return false;
				}
				for(i=0;i<restrictedFormat.length;i++)
					if(obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == restrictedFormat[i])
					{
						alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
						return false;										
					}
					else if((obj.length == (obj.indexOf('.') + 5)) && (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 5).toLowerCase() == restrictedFormat[i]))
					{
						alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
						return false;										
					}
					if (asset.new_file[1] != null && asset.new_file[1].checked)
					{
						if ((document.getElementById("stream_name").value == "") && (asset.asset.value==''))
						{
							alert("<cf_get_lang no='93.Döküman seçiniz !'>");
							return false;
						}
					}
					if (document.getElementById('property_id').value == '')
					{
						alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='655.Döküman Tipi'> !");
						return false;
					}
					var thumb_obj =  document.getElementById('thumbnail_file').value;
					if ((thumb_obj != "") && !((thumb_obj.substring(thumb_obj.indexOf('.')+1,thumb_obj.indexOf('.') + 4).toLowerCase() == 'jpg')))
					{
						alert('<cf_get_lang dictionary_id="52293.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!">');        
						return false;
					}	
					if(document.getElementById('project_multi_id')!= undefined)
					{
						select_all('project_multi_id');
					}
				<!--- <cfif session.ep.our_company_info.workcube_sector eq 'tersane'> --->
				<cfif isDefined('x_is_product') and x_is_product eq 1>
					if((document.getElementById('product_id').value == '' || document.getElementById('product_name').value =='') && document.getElementById('is_dpl') != undefined && document.getElementById('is_dpl').checked==true)
					{
						alert("<cf_get_lang dictionary_id='52302.Ana Ürün Seçiniz !'>");
						return false;
					}
				</cfif>
				<cfif isdefined('x_is_asset_stage_display') and x_is_asset_stage_display eq 1>
					if(document.getElementById('process_stage').value != '')
						return process_cat_control();
					else
					{
						alert('<cf_get_lang dictionary_id="52286.Eğer Aşama Kullanılacak ise Aşamasız olan kayıtlarınızı update ettiriniz!">');
						return false;
					}
				</cfif>
				return true;
			 }
			function usergroup_hepsi()
			{
				count = document.getElementsByName('user_group_ids').length;
				if (document.getElementById('user_group_id_all').checked)
				{	
					for(say=0;say<count;say++)
						document.getElementsByName('user_group_ids')[say].checked = true;
				}
				else
				{
					for(say=0;say<count;say++)
						document.getElementsByName('user_group_ids')[say].checked = false;
				}
				return false;
			}
			function sel_digital_asset_group()
			{
				digital_assets_hepsi(); //Kosullara uygun kayit yoksa tumunu sec/kaldir calismis olur
				var GET_ASSET_GROUP = wrk_safe_query('ascr_get_emp_asset_group','dsn',0,document.getElementById('property_id').value);
				if(GET_ASSET_GROUP.recordcount)
				{
					var group_list = '0,'+GET_ASSET_GROUP.GROUP_ID;
					for(say=1;say<=document.getElementsByName("digital_assets").length;say++)
					{
						if(list_find(group_list,document.getElementsByName("digital_assets")[say-1].value))
							document.getElementsByName("digital_assets")[say-1].checked = true;
						else
							document.getElementsByName("digital_assets")[say-1].checked = false;
					}
				}
			}
			function revision()
			{
				document.getElementById('revision_no').disabled = false;
				document.asset.action='<cfoutput>#request.self#?fuseaction=asset.form_add_asset&revision=1&asset_cat_id=#attributes.assetcat_id#</cfoutput>';
				if(document.getElementById('project_multi_id')!= undefined)
				{
					select_all('project_multi_id');
				}
				asset.submit();
			}
			function copy_asset()
			{
				document.getElementById('revision_no').disabled = false;
				document.asset.action='<cfoutput>#request.self#?fuseaction=asset.form_add_asset&asset_id=#attributes.asset_id#</cfoutput>';
				if(document.getElementById('project_multi_id')!= undefined)
				{
					select_all('project_multi_id');
				}
				asset.submit();
			}
			function check_delete_dpl()
			{
				var sql_dpl = "SELECT DPL_ID FROM DRAWING_PART WHERE ASSET_ID ="+document.getElementById('asset_id').value;
				GET_DPL_COUNT = wrk_query(sql_dpl,'dsn3');
				if(GET_DPL_COUNT.recordcount != 0)
				{
					alert('<cf_get_lang dictionary_id="52363.İlişkili DPL'i Olan Bir Belgeyi Silemezsiniz !">');	
					return false;
				}
				else
					return true;
			}
		</cfif>
		function partner_hepsi()
		{
			if (document.asset.comp_cat_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.asset.comp_cat[say].checked = true;
			}
			else
	
			{
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.asset.comp_cat[say].checked = false;
			}
			return false;
		}
		function public_hepsi()
		{
			if (document.asset.customer_cat_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.asset.customer_cat[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.asset.customer_cat[say].checked = false;
			}
			return false;
		}
		function position_hepsi()
		{
			if (document.asset.position_cat_id_all.checked)
			{	
				for(say=0;say<<cfoutput>#GET_POSITION_CATS.recordcount#</cfoutput>;say++)
					document.asset.position_cat_ids[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#GET_POSITION_CATS.recordcount#</cfoutput>;say++)
					document.asset.position_cat_ids[say].checked = false;
			}
			return false;
		}
		function digital_assets_hepsi()
		{
			if (document.getElementById('digital_assets_all').checked)
			{	
				for(say=0;say<document.getElementsByName('digital_assets').length;say++)
					document.getElementsByName('digital_assets')[say].checked = true;
			}
			else
			{
				for(say=0;say<document.getElementsByName('digital_assets').length;say++)
					document.getElementsByName('digital_assets')[say].checked = false;
			}
			return false;
		}
		function project_remove()
		{
			for (i=document.getElementById('project_multi_id').options.length-1;i>-1;i--)
			{
				if (document.getElementById('project_multi_id').options[i].selected==true)
				{
					document.getElementById('project_multi_id').options.remove(i);
				}	
			}
		}
		function select_all(selected_field)
		{
			var m = document.getElementById(selected_field).options.length;
			for(i=0;i<m;i++)
			{
				document.getElementById(selected_field)[i].selected=true;
			}
		}
		
		function dpl_yrm()
		{
		<cfif session.ep.our_company_info.workcube_sector eq 'tersane'>
			if(document.getElementById('featured').checked == true && document.getElementById('is_dpl').checked == false)
			{
				document.getElementById('featured').checked = false;
				alert( "<cf_get_lang dictionary_id='52279.Yarı Mamül Seçmek İçin Önce DPL Seçmelisiniz'>!")
				return false;
			}
		</cfif>
		}
		function pub_internet_func()
		{
			if(document.getElementById('is_internet').checked == true)
				goster(pub_internet);
			else
				gizle(pub_internet);	
		}
		pub_internet_func();
	</cfif>	
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'asset.form_add_asset';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'asset/form/form_add_asset.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'asset/query/add_asset.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'asset.list_asset&event=upd';
			
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'asset.list_asset';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'asset/display/list_asset.cfm';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'asset.form_add_asset';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'asset/form/form_upd_asset.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'asset/query/upd_asset.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'asset.list_asset&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.assetcat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.assetcat_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'asset.del_asset&assetcat_id=#attributes.assetcat_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'asset/query/del_asset.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'asset/query/del_asset.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'asset.list_asset';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[63]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_mail&IS_BASKET_HIDDEN=0&trail=1&module=asset&asset_id=#attributes.asset_id#','list')";
	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=asset.list_asset&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=asset.list_asset&event=add&asset_id=#attributes.asset_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
	
</cfscript>

