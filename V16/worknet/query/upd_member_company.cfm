<!--- <cfif len(attributes.organization_start_date)><cf_date tarih='attributes.organization_start_date'></cfif> --->
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.nickname = replacelist(attributes.nickname,list,list2)>
<cfset attributes.fullname=replacelist(attributes.fullname,list,list2)>
<cfset attributes.address=replacelist(attributes.address,list,list2)>
<cfset attributes.nickname = trim(attributes.nickname)>
<cfset attributes.fullname = trim(attributes.fullname)>

<!--- <cfquery name="GET_ASSET_COMPANY" datasource="#DSN#">
	SELECT ASSET_FILE_NAME1,ASSET_FILE_NAME2,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2_SERVER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>
<cfset upload_folder = "#upload_folder#member#dir_seperator#"> --->
<!--- Kroki Sil --->

<cfif isdefined('session.ep.userid')>
	<cfset our_comp_id = session.ep.company_id>
<cfelseif isdefined('session.pp.userid')>
	<cfset our_comp_id = session.pp.our_company_id>
</cfif>
<!--- <cfquery name="get_file_size_comp" datasource="#dsn#">
	SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#our_comp_id#
</cfquery> --->
<!--- Dis Gorunus Ekle --->
<!--- <cfif not isdefined("attributes.del_asset1")>
	<cfif isdefined("attributes.asset1") and len(attributes.asset1)>
		<cftry>
			<cffile action = "upload" filefield = "asset1" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
			<cfset file_name1 = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name1#.#cffile.serverfileext#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name1#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfset file_name1_ = "#file_name1#.#cffile.serverfileext#">
			<!--- dosya boyutu kontrol --->
			<cfif get_file_size_comp.is_file_size>
				<cfquery name="get_file_size" datasource="#dsn#">
					SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
				</cfquery>
				<cfif get_file_size.recordcount and len(get_file_size.format_size)>
					<cfset dt_size=get_file_size.format_size * 1048576>
					<cfif INT(dt_size) lte INT(filesize)>
						<cfif FileExists("#upload_folder##file_name1_#")>
							<cffile action="delete" file="#upload_folder##file_name1_#">
						</cfif>
						 <script type="text/javascript">
							alert('Logo ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
							history.back();
						</script>
						<cfabort>
					</cfif>
				</cfif>
			</cfif>
			<!--- dosya boyutu kontrol --->	
			<!--- eski dosya siliniyor --->
			<cf_del_server_file output_file="member/#get_asset_company.asset_file_name1#" output_server="#get_asset_company.asset_file_name1_server_id#">
			<!--- eski dosya siliniyor --->
			<cfquery name="UPD_ASSET1_VALUE" datasource="#DSN#">
				UPDATE  
				    COMPANY 
				SET 
					ASSET_FILE_NAME1 = '#file_name1_#',
					ASSET_FILE_NAME1_SERVER_ID = #fusebox.server_machine# 
				WHERE 
					 COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no='533.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
	</cfif>
<cfelseif isdefined("attributes.del_asset1")>
	<cfquery name="UPD_ASSET1_NULL" datasource="#DSN#">
		UPDATE  
			COMPANY
		SET 
			ASSET_FILE_NAME1 = NULL,
			ASSET_FILE_NAME1_SERVER_ID = NULL
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cf_del_server_file output_file="member/#get_asset_company.asset_file_name1#" output_server="#get_asset_company.asset_file_name1_server_id#">
</cfif> --->
<!--- Kroki Ekle --->
<!--- <cfif not isdefined("attributes.del_asset2")>
	<cfif isdefined("attributes.asset2") and LEN(attributes.asset2)>
		<cftry>
			<cffile action = "upload" filefield = "asset2" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
			<cfset file_name2 = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name2#.#cffile.serverfileext#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name2#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfset file_name2_ = "#file_name2#.#cffile.serverfileext#">
			<!--- dosya boyutu kontrol --->
			<cfif get_file_size_comp.is_file_size>
				<cfquery name="get_file_size" datasource="#dsn#">
					SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#assetTypeName#'
				</cfquery>
				<cfif get_file_size.recordcount and len(get_file_size.format_size)>
					<cfset dt_size=get_file_size.format_size * 1048576>
					<cfif INT(dt_size) lte INT(filesize)>
						<cfif FileExists("#upload_folder##file_name2_#")>
							<cffile action="delete" file="#upload_folder##file_name2_#">
						</cfif>
						 <script type="text/javascript">
							alert('Kroki ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
							history.back();
						</script>
						<cfabort>
					</cfif>
				</cfif>
			</cfif>
			<!--- dosya boyutu kontrol --->
			<!--- eski dosya siliniyor --->
			<cf_del_server_file output_file="member/#get_asset_company.asset_file_name2#" output_server="#get_asset_company.asset_file_name2_server_id#">
			<!--- eski dosya siliniyor --->
			<cfquery name="UPD_ASSET2_VALUE" datasource="#DSN#">
				UPDATE  
				   COMPANY 
				SET 
					 ASSET_FILE_NAME2 = '#file_name2_#',
					 ASSET_FILE_NAME2_SERVER_ID = #fusebox.server_machine# 
				WHERE 
					 COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang no='533.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
	</cfif>
<cfelseif isdefined("attributes.del_asset2")>
	<cfquery name="UPD_ASSET2" datasource="#DSN#">
		UPDATE  
			COMPANY
		SET 
			ASSET_FILE_NAME2 = NULL,
			ASSET_FILE_NAME2_SERVER_ID = NULL
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cf_del_server_file output_file="member/#get_asset_company.asset_file_name2#" output_server="#get_asset_company.asset_file_name2_server_id#">
</cfif> --->


<!--- sirket unvanı ve kısa unvanı kontrolü  --->
<!--- <cfquery name="GET_COMP" datasource="#DSN#">
	SELECT
		COMPANY_ID
	FROM
		COMPANY
	WHERE
		COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fullname#"> AND
		NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.nickname#">
</cfquery> 
<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:şirket ünvanı <cf_get_lang_main no='781.tekrarı'>!");
		history.back();
	</script>
	<cfabort>
</cfif> --->

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined('attributes.is_status')><cfset attributes.is_status = 1><cfelse><cfset attributes.is_status = 0></cfif>
		<cfif isdefined('attributes.is_potential')><cfset attributes.is_potential = 1><cfelse><cfset attributes.is_potential = 0></cfif>
		<cfif isdefined('attributes.is_related_company')><cfset attributes.is_related_company = 1><cfelse><cfset attributes.is_related_company = 0></cfif>
        <!--- <cfif isdefined('attributes.is_homepage')><cfset attributes.is_homepage = 1><cfelse><cfset attributes.is_homepage = 0></cfif> --->
		
		<cfif isdefined('attributes.firm_type') and len(attributes.firm_type)><cfset firm_type = attributes.firm_type><cfelse><cfset firm_type = ''></cfif>
		<!--- <cfif isdefined('attributes.req_type') and len(attributes.req_type)><cfset req_type = attributes.req_type><cfelse><cfset req_type = ''></cfif> --->
		<cfif isdefined('attributes.product_category') and len(attributes.product_category)><cfset product_category = attributes.product_category><cfelse><cfset product_category = ''></cfif>
		
		<cfset cmp = createObject("component","V16.worknet.cfc.worknet_add_member") />
		<cfset cmp.updCompany(
				company_id:attributes.cpid,
				is_potential:attributes.is_potential,
				is_status:attributes.is_status,
<!--- 				process_stage:attributes.process_stage,
				companycat_id:attributes.companycat_id, --->
				nickname:attributes.nickname,
				fullname:attributes.fullname,
				vd:attributes.taxoffice,
				vno:attributes.taxno,
				company_email:attributes.email,
<!--- 				homepage:attributes.homepage, --->
				telcod:attributes.telcod1,
				tel1:attributes.tel1,
				tel2:attributes.tel2,
<!--- 				tel3:attributes.company_tel3,
				fax:attributes.company_fax,
				mobilcat_id:attributes.mobilcat_id,
				mobiltel:attributes.mobiltel, --->
				postcod:attributes.postcod,
				domain:attributes.domain,
				adres:attributes.address,
				county_id:attributes.county_id,
				city_id:attributes.city_id,
				country:attributes.country,
				<!--- semt:attributes.semt,
				company_sector:attributes.company_sector,
				firm_type:attributes.firm_type, --->
				manager_partner_id:attributes.manager_partner_id,
				<!--- company_size_cat_id:attributes.company_size_cat_id,
				coordinate_1:attributes.coordinate_1,
				coordinate_2:attributes.coordinate_2,
				our_company_id:'',
				organization_start_date:attributes.organization_start_date,
				req_type:req_type,
				annual_customer_value:attributes.annual_customer_value,
				domestic_customer_value:attributes.domestic_customer_value,
				export_customer_value:attributes.export_customer_value,
				company_detail:attributes.company_detail,
				company_detail_eng:attributes.company_detail_eng,
				company_detail_spa:attributes.company_detail_spa,
				product_category:product_category, --->
				is_related_company:attributes.is_related_company
<!--- 				is_homepage:attributes.is_homepage, --->
<!--- 				sort:iif(isdefined("attributes.sort"),"attributes.sort",DE("")) --->
			) />
					
		<cf_workcube_user_friendly user_friendly_url='#left(attributes.fullname,250)#' action_type='COMPANY_ID' action_id='#attributes.cpid#' action_page='#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&&cpid=#attributes.cpid#'>
		<cfif isdefined('session.ep')>
			<cfset process_user_id = session.ep.userid>
		<cfelseif  isdefined('session.pp')>
			<cfset process_user_id = session.pp.userid>
		</cfif>

		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#process_user_id#' 
			record_date='#now()#' 
			action_table='COMPANY'
			action_column='COMPANY_ID'
			action_id='#attributes.cpid#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#attributes.cpid#' 
			warning_description = 'Kurumsal Üye : #attributes.fullname#'>

	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfoutput>
		window.location.href = '#request.self#?fuseaction=worknet.form_list_company&event=upd&cpid=#attributes.cpid#';
	</cfoutput>
</script>
<!---Ek Bilgiler--->
<!--- <cfset attributes.info_id =  attributes.company_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -1>
<cfinclude template="../../objects/query/add_info_plus2.cfm"> --->
<!---Ek Bilgiler--->
<!--- <cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#attributes.company_id#" addtoken="no"> --->

