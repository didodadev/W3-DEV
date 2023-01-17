<cfif len(attributes.startdate)>
	<CF_DATE tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<CF_DATE tarih="attributes.finishdate">
</cfif>

<cfif len(attributes.notice_no)>
	<cfquery name="control" datasource="#dsn#">
	  SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.notice_no#">
	</cfquery>
	  <cfif control.RECORDCOUNT> 
		<script type="text/javascript">
		  alert("<cf_get_lang no ='1487.Aynı ilan no lu kayıt var'> !");
		  history.back();
		</script>
		<cfabort>
	  </cfif>
</cfif>

<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
	<cfset upload_folder = "#upload_folder##dir_seperator#hr#dir_seperator#">
	<CFTRY>
		<cffile action="UPLOAD"
				filefield="visual_notice"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE"
				accept = "image/*">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfset attributes.visual_notice = '#file_name#.#cffile.serverfileext#'>
	
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>
	</CFTRY>
</cfif>

<cfset attributes.detail=replace(attributes.detail,"'"," ","all")>
<cfquery name="add_notice" datasource="#dsn#">
	INSERT INTO
		NOTICES
		(
		NOTICE_HEAD,
		NOTICE_NO,
		STATUS,
		STATUS_NOTICE,
		DETAIL,
		POSITION_NAME,
		INTERVIEW_PAR,
		<cfif len(validator_par)>
			VALIDATOR_PAR,
		<cfelse>
			VALID, 
			VALID_DATE, 
			VALID_PAR,
		</cfif>
			STARTDATE, 
			FINISHDATE, 	
			PUBLISH, 
			COMPANY_ID,
			COMPANY,
			OUR_COMPANY_ID,
			NOTICE_CITY,
			COUNT_STAFF,
			WORK_DETAIL,
			IS_VIEW_LOGO,
			IS_VIEW_COMPANY_NAME,
			VIEW_VISUAL_NOTICE,
			<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
				VISUAL_NOTICE,
				SERVER_VISUAL_NOTICE_ID,
			</cfif>
			RECORD_DATE,
			RECORD_IP,
			RECORD_PAR
		)
	VALUES
		(
		'#attributes.notice_head#', 
		'#attributes.notice_no#',
		<cfif isdefined('attributes.status')>1<cfelse>0</cfif>,
		<cfif len(attributes.status_notice)>#attributes.status_notice#,<cfelse>NULL,</cfif>
		'#attributes.detail#',
		<cfif len(attributes.app_position)>'#attributes.app_position#',<cfelse>NULL,</cfif>
		<cfif len(attributes.interview_par)>
			#listgetat(attributes.interview_par,1,',')#,
		<cfelse>
			NULL,
		</cfif>
		<cfif len(attributes.validator_par)>
			#listgetat(attributes.validator_par,1,',')#, 
		<cfelse>
			1, 
			#now()#, 
			#session.pp.userid#, 
		</cfif>
		<cfif len(attributes.startdate)>#attributes.startdate#, <cfelse>NULL,</cfif>
		<cfif len(attributes.finishdate)>#attributes.finishdate#,<cfelse>NULL,</cfif>
		1,
		#session.pp.company_id#,
		'#session.pp.company#',
		#session.pp.our_company_id#,
		<cfif isdefined('attributes.city') and len(attributes.city)>',#attributes.city#,'<cfelse>NULL</cfif>,
		<cfif len(attributes.staff_count)>#attributes.staff_count#<cfelse>NULL</cfif>,
		<cfif len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.view_logo")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.view_company_name")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.view_visual_notice")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
			'#attributes.visual_notice#',
			#fusebox.server_machine#,
		</cfif>
		#now()#,
		'#cgi.REMOTE_ADDR#',
		#session.pp.userid#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.list_notices_partner" addtoken="No">
