<cfif not isdefined('attributes.workcube_id')>
	<script>
		alert("<cf_get_lang_main no ='120.Yetkisiz Erişim'>");
		history.back(-1);
	</script>
	<cfabort>
</cfif>

<cfif isdefined('attributes.is_security') and attributes.is_security eq 1>
	<cf_wrk_captcha name="captcha" action="validate">
	<cfif captcha.validationResult eq false>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1439.Güvenlik Kodunu Hatalı Girdiniz! Lütfen Düzenleyiniz'>!");
			window.location = '<cfoutput>#request.self#?fuseaction=objects2.dsp_contact</cfoutput>';
			//history.back(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
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
		<cfif isdefined("session.pp")>
			PTR.IS_PARTNER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTR.IS_CONSUMER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelseif isdefined('session.cp')>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#"> AND
		<cfelseif isdefined('session.wp')>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.popup_add_helpdesk%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>

<cfif not get_process.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.workcube_id") and len(attributes.workcube_id)>
	<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
		SELECT
			SUBSCRIPTION_ID,			
			SUBSCRIPTION_NO,
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID
		FROM
			SUBSCRIPTION_CONTRACT
		WHERE
			SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workcube_id#">
	</cfquery>
<cfelse>
	<cfset get_subscription.recordcount = 0>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>	
		<cfsavecontent variable="attributes.subject">
			<cfoutput>
				<cfif isdefined('attributes.report_url') and len('attributes.report_url')>
					<a href="#attributes.report_url#">#attributes.report_url#</a><br /><br />
				</cfif>		
				<p>#attributes.subject#</p>
			</cfoutput>
		</cfsavecontent>

		<cfquery name="ADD_HELP" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				CUSTOMER_HELP
			(
				DETAIL,
				OUR_COMPANY_ID,
				SITE_DOMAIN,
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				APP_CAT,
				SUBJECT,
				PROCESS_STAGE,
				APPLICANT_NAME,
				APPLICANT_MAIL,
				SUBSCRIPTION_ID,
				<cfif isdefined('session.pp.userid')>
					RECORD_PAR,
				<cfelseif isdefined('session.ww.userid')>
					RECORD_CONS,
				<cfelseif isdefined('session.cp.userid')>
					RECORD_APP,
				<cfelse>
					GUEST,
				</cfif>
				RECORD_DATE,
				INTERACTION_DATE,
				RECORD_IP,  
				<cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>INTERACTION_CAT,</cfif> 
				IS_REPLY,
				IS_REPLY_MAIL,
				CUSTOMER_TELCODE,
                CUSTOMER_TELNO
			)
			VALUES
			(
				'#attributes.detail#',
				<cfif isdefined("session.pp")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">,
				<cfelseif isdefined("session.ww")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">,
				<cfelseif isdefined('session.cp')>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">,
				<cfelseif isdefined('session.wp')>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				</cfif>
				'#cgi.http_host#',
			  	<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.pid') and len(attributes.pid)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
					NULL,
			  	<cfelseif isdefined("session.pp.userid")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">,
					NULL,
			  	<cfelseif isdefined("session.ww.userid")>
					NULL,
					NULL,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">,
			  	<cfelseif get_subscription.recordcount>
					<cfif len(get_subscription.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.partner_id#"><cfelse>NULL</cfif>,
					<cfif len(get_subscription.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.company_id#"><cfelse>NULL</cfif>,
					<cfif len(get_subscription.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.consumer_id#"><cfelse>NULL</cfif>,
			  	<cfelse>
					NULL,
					NULL,
					NULL,
			  	</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_cat#">,
				'#attributes.subject#',
				#get_process.process_row_id#,
				'#attributes.applicant_name#',
				'#attributes.applicant_mail#',
				<cfif get_subscription.recordcount>'#get_subscription.subscription_id#'<cfelse>NULL</cfif>,
				<cfif isdefined('session.pp.userid')>
					#session.pp.userid#,
				<cfelseif isdefined('session.ww.userid')>
					#session.ww.userid#,
				<cfelseif isdefined('session.cp.userid')>
					#session.cp.userid#,
				<cfelse>
					1,
				</cfif>
				#now()#,
				#now()#,
				'#cgi.remote_addr#', 
				<cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>'#attributes.interaction_cat#',</cfif>
				0,
				0,
				<cfif isdefined("attributes.tel_code")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#">,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.tel_no")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_no#"><cfelse>NULL</cfif>
			)
		</cfquery>
	</cftransaction>
</cflock>

<cfif isdefined("session.ww.userid")>
	<cfset member_id = session.ww.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset member_id = session.pp.userid>
<cfelse>
	<cfset member_id = 0>
</cfif>

<!--- Gozat Belge Ekleme Kontrolleri- Dijital Varliklara Atiliyor --->
<cfif isdefined('attributes.file_name') and Len(attributes.file_name)>
	<cfquery name="GET_ASSETCAT_PATH" datasource="#DSN#">
		SELECT ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
	</cfquery>
	<cfset assetcat_path = get_assetcat_path.assetcat_path>
    <cfif company_asset_relation eq 1>
    	<cfif attributes.assetcat_id gte 0>
			<cfset folder="asset#dir_seperator##assetcat_path#">
        <cfelse>
            <cfset folder="#assetcat_path#">
        </cfif>
		<cfset upload_folder_ = "#upload_folder##folder##dir_seperator#">
    <cfelse>
    	<cfif attributes.assetcat_id gte 0>
			<cfset folder="asset#dir_seperator##assetcat_path#">
        <cfelse>
            <cfset folder="#assetcat_path#">
        </cfif>
		<cfset upload_folder_ = "#upload_folder##folder##dir_seperator#">
    </cfif>
	<cftry>
		<cffile action = "upload" 
		  filefield = "file_name" 
		  destination = "#upload_folder_#" 
		  nameconflict = "MakeUnique" 
		  accept="*"
		  mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">
		<cfset asset_file_real_name = cffile.serverfile>
		<cfset fileSize = cffile.filesize>
		<cfset fileServerId=fusebox.server_machine>
		<cfset moduleName="call">
		<cfset moduleId=27>
		<cfset actionSection="CUS_HELP_ID">
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<!---Script dosyalarını engeller --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder_##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfcatch type="Any">
		  	<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
				history.back();
		  	</script>
		  	<cfabort>
		</cfcatch>  
	</cftry>
    
    <cflock name="#createUUID()#" timeout="20">
		<cftransaction>	
            <cfquery name="ADD_ASSET" datasource="#DSN#" result="GET_MAX_ASSET">
                INSERT INTO 
                    ASSET
                (	
                    IS_INTERNET,
                    MODULE_NAME,
                    MODULE_ID,
                    ACTION_SECTION,
                    ACTION_ID,
                    ASSETCAT_ID,
                    PROPERTY_ID,
                    COMPANY_ID,
                    ASSET_NAME,
                    ASSET_STAGE,
                    ASSET_FILE_NAME,
                    ASSET_FILE_REAL_NAME,
                    SERVER_NAME,
                    ASSET_FILE_SIZE,
                    ASSET_FILE_SERVER_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (	
                    1,
                    '#moduleName#',
                    #moduleId#,
                    '#actionSection#',
                    #MAX_ID.IDENTITYCOL#,
                    <cfif isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>#attributes.assetcat_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.property_id") and len(attributes.property_id)>#attributes.property_id#<cfelse>NULL</cfif>,
                    #session_base.our_company_id#,
                    'Etkileşim: #MAX_ID.IDENTITYCOL#',
                    #get_process.process_row_id#,
                    '#file_name#',
                    '#asset_file_real_name#',
                    '#cgi.http_host#',
                    #ROUND(fileSize/1024)#,
                    #fileServerId#,
                    #member_id#,
                    #now()#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            
            <cfloop list="#partner_url#" index="i" delimiters=";">
                <cfquery name="ADD_ASSET_SD" datasource="#DSN#">
                    INSERT INTO
                        ASSET_SITE_DOMAIN
                        (
                            ASSET_ID,
                            SITE_DOMAIN
                        )
                        VALUES
                        (
                            #GET_MAX_ASSET.IDENTITYCOL#,
                            '#i#'
                        )
                        
                </cfquery>
            </cfloop>
            
            <cfloop list="#server_url#" index="i" delimiters=";">
                <cfquery name="ADD_ASSET_SD" datasource="#DSN#">
                    INSERT INTO
                        ASSET_SITE_DOMAIN
                        (
                            ASSET_ID,
                            SITE_DOMAIN
                        )
                        VALUES
                        (
                            #GET_MAX_ASSET.IDENTITYCOL#,
                            '#i#'
                        )
                        
                </cfquery>
            </cfloop>
        </cftransaction>
    </cflock>
</cfif>
<!--- //Gozat Belge Ekleme Kontrolleri- Dijital Varliklara Atiliyor --->

<cfif isdefined('member_id')>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#get_process.process_row_id#' 
		record_member='#member_id#' 
		record_date='#now()#'
		action_page='#request.self#?fuseaction=call.upd_helpdesk&cus_help_id=#MAX_ID.IDENTITYCOL#' 
		action_id='#MAX_ID.IDENTITYCOL#'
		warning_description='Etkileşim : #attributes.applicant_name#'>
</cfif>

<script type="text/javascript">
	 alert("<cf_get_lang no ='1440.E-mailinize En Kısa Zamanda Cevap Verilecektir'>!");
	 <cfif isdefined("attributes.is_popup")>
	 	self.close();
	 <cfelse>
	 	window.location.href = '/';
	 </cfif>
	 <!---<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.welcome--->
</script>
