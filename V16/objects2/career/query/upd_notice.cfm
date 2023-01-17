<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>

<cfif len(attributes.notice_no)>
    <cfquery name="CONTROL" datasource="#DSN#">
    	SELECT 
        	NOTICE_ID 
        FROM 
        	NOTICES 
        WHERE 
        	NOTICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.notice_no#"> AND 
            NOTICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
    </cfquery>
	<cfif control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1487.Aynı ilan no lu kayıt var'>!");
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>

<cfquery name="GET_IMAGE" datasource="#DSN#">
	SELECT 
		VISUAL_NOTICE,
		SERVER_VISUAL_NOTICE_ID
	FROM 
		NOTICES
	WHERE
		NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
</cfquery>

<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
<cfif isDefined("del_visual_notice")>
	<cfif len(get_image.visual_notice)>
		<cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
	</cfif>
	<cfset attributes.visual_notice = "">
<cfelse>
	<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
		<cfif len(get_image.visual_notice)>
			<cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
		</cfif>
		<cftry>
			<cffile action="UPLOAD" filefield="visual_notice" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
					history.back();
				</script>
			</cfcatch>  
		</cftry>
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
	<cfelse>
		<cfset attributes.visual_notice = get_image.visual_notice>
	</cfif>
</cfif>

<cfset attributes.detail=replace(attributes.detail,"'"," ","all")>
<cfquery name="UPD_NOTICE" datasource="#DSN#">
	UPDATE
		NOTICES
	SET
		NOTICE_HEAD = '#attributes.notice_head#', 
		NOTICE_NO = '#attributes.notice_no#',
		STATUS = <cfif isdefined('attributes.status')>1<cfelse>0</cfif>,
		STATUS_NOTICE = <cfif len(attributes.status_notice)>#attributes.status_notice#,<cfelse>NULL,</cfif>
		DETAIL = '#attributes.detail#',
		POSITION_NAME = <cfif len(attributes.app_position)>'#attributes.app_position#',<cfelse>NULL,</cfif>
		INTERVIEW_PAR = <cfif len(attributes.interview_par)>#listgetat(attributes.interview_par,1,',')#,<cfelse>NULL,</cfif>
		VALIDATOR_PAR = <cfif isdefined("attributes.validator_par") and len(validator_par)>#listgetat(attributes.validator_par,1,',')#,<cfelse> NULL,</cfif>
		<cfif isdefined("valid")>
			<cfif valid eq 1>
				VALID = 1, 
				VALID_DATE = #now()#, 
				VALID_PAR = #session.pp.userid#,
			<cfelseif valid eq 0>
				VALID = 0, 
				VALID_DATE = #now()#, 
				VALID_PAR = #session.pp.userid#,
			</cfif>
		</cfif>
		STARTDATE = <cfif len(attributes.startdate)>#attributes.startdate#, <cfelse>NULL,</cfif>
		FINISHDATE = <cfif len(attributes.finishdate)>#attributes.finishdate#,<cfelse>NULL,</cfif>
		PUBLISH = 1,
		COMPANY_ID = #session.pp.company_id#,
		COMPANY = '#session.pp.company#',
		OUR_COMPANY_ID = #session.pp.our_company_id#,
		NOTICE_CITY = <cfif isdefined('attributes.city') and len(attributes.city)>',#attributes.city#,'<cfelse>NULL</cfif>,
		COUNT_STAFF = <cfif len(attributes.staff_count)>#attributes.staff_count#<cfelse>NULL</cfif>,
		WORK_DETAIL = <cfif len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>NULL</cfif>,
		IS_VIEW_LOGO = <cfif isdefined("attributes.view_logo")>1<cfelse>0</cfif>,
		IS_VIEW_COMPANY_NAME = <cfif isdefined("attributes.view_company_name")>1<cfelse>0</cfif>,
		VIEW_VISUAL_NOTICE = <cfif isdefined("attributes.view_visual_notice")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
			VISUAL_NOTICE = '#attributes.visual_notice#',
		</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_PAR = #session.pp.userid#
	WHERE
		NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.form_upd_notice&notice_id=#notice_id#" addtoken="No">
