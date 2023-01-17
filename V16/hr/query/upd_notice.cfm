<cfif len(attributes.startdate)>
	<CF_DATE tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<CF_DATE tarih="attributes.finishdate">
</cfif>

<cfif len(attributes.notice_no)>
<cfquery name="control" datasource="#dsn#">
  SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_NO = '#attributes.notice_no#' AND NOTICE_ID <> #attributes.notice_id#
</cfquery>
  <cfif control.recordcount>
    <script type="text/javascript">
	  alert("<cf_get_lang dictionary_id='56316.Aynı ilan no lu kayıt var'> !");
	  history.back();
	</script>
	<cfabort>
  </cfif>
</cfif>

<cfquery name="get_image" datasource="#DSN#">
	SELECT 
		VISUAL_NOTICE,
		SERVER_VISUAL_NOTICE_ID
	FROM 
		NOTICES
	WHERE
		NOTICE_ID = #attributes.notice_id#
</cfquery>

<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
<cfif isDefined("attributes.del_visual_notice") and attributes.del_visual_notice eq 1>
	<cfif len(get_image.visual_notice)>
		<cffile action="DELETE" file="#upload_folder##dir_seperator##get_image.visual_notice#">
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
					alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
					history.back();
				</script>
			</cfcatch>  
		</cftry>
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA,ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='32535.php,jsp,asp,cfm,cfml Formatlarında Dosya Girmeyiniz!!'>");
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
<cfquery name="upd_notice" datasource="#dsn#">
	UPDATE
		NOTICES
	SET
		NOTICE_CAT_ID = <cfif isdefined("attributes.notice_cat_id") and len(attributes.notice_cat_id)>#attributes.notice_cat_id#,<cfelse>NULL,</cfif>
		NOTICE_HEAD = '#attributes.notice_head#', 
		NOTICE_NO = '#attributes.notice_no#',
		<cfif isdefined("attributes.status")>STATUS = 1,<cfelse>STATUS = 0,</cfif>
		<cfif len("attributes.process_stage")>STATUS_NOTICE = #attributes.process_stage#,</cfif>
		DETAIL = '#FORM.detail#',<!--- '#attributes.detail#', ---> 
		POSITION_NAME = <cfif len(attributes.app_position)>'#attributes.app_position#',<cfelse>NULL,</cfif>
		POSITION_ID = <cfif len(attributes.position_id)>#attributes.position_id#,<cfelse>NULL,</cfif>
		POSITION_CAT_ID = <cfif len(attributes.position_cat_id)>#attributes.position_cat_id#,<cfelse>NULL,</cfif>
		POSITION_CAT_NAME = <cfif len(attributes.position_cat)>'#attributes.position_cat#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.interview_position_code") and len(attributes.interview_position_code)>
			INTERVIEW_POSITION_CODE = #attributes.interview_position_code#, 
		<cfelse>
			INTERVIEW_POSITION_CODE = NULL, 
		</cfif>
		<cfif isdefined("attributes.interview_par") and len(attributes.interview_par)>
			INTERVIEW_PAR = #attributes.interview_par#, 
		<cfelse>
			INTERVIEW_PAR = NULL, 
		</cfif>
		<cfif isdefined("attributes.validator_position_code") and len(validator_position_code)>
			VALIDATOR_POSITION_CODE = #attributes.validator_position_code#, 
		<cfelse>
			VALIDATOR_POSITION_CODE = NULL, 
		</cfif>
		<cfif isdefined("attributes.validator_par") and len(validator_par)>
			VALIDATOR_PAR = #attributes.validator_par#, 
		<cfelse>
			VALIDATOR_PAR = NULL, 
		</cfif>
		<cfif isdefined("valid")>
		<cfif valid eq 1>
			VALID = 1, 
			VALID_DATE = #now()#, 
			VALID_EMP = #session.ep.userid#, 
		<cfelseif valid eq 0>
			VALID = 0, 
			VALID_DATE = #now()#, 
			VALID_EMP = #session.ep.userid#, 
		</cfif>
		</cfif>
		<cfif len(attributes.startdate)>
			STARTDATE = #attributes.startdate#, 
		<cfelse>
			STARTDATE = null,
		</cfif>
		<cfif len(attributes.finishdate)>
			FINISHDATE = #attributes.finishdate#, 	
		<cfelse>
			FINISHDATE = null,
		</cfif>
		PUBLISH = <cfif isdefined("attributes.publish")>'#attributes.publish#', <cfelse>NULL, </cfif> 
		<cfif len(attributes.company_id) and len(attributes.company)>COMPANY_ID=#attributes.company_id#,<cfelse>COMPANY_ID=NULL,</cfif>
		<cfif len(attributes.company) and len(attributes.company_id)>COMPANY='#attributes.company#',<cfelse>COMPANY=NULL,</cfif>
		<cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id)>
			OUR_COMPANY_ID=#attributes.our_company_id#,
		<cfelse>
			OUR_COMPANY_ID=NULL,
		</cfif>
		<cfif len(attributes.department_id) and len(attributes.department)>
			DEPARTMENT_ID=#attributes.department_id#,
		<cfelse>
			DEPARTMENT_ID=NULL,
		</cfif>
		<cfif len(attributes.branch_id) and len(attributes.branch)>
			BRANCH_ID=#attributes.branch_id#,
		<cfelse>
			BRANCH_ID=NULL,
		</cfif>
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#,
			NOTICE_CITY=<cfif len(attributes.city)>',#attributes.city#,'<cfelse>NULL</cfif>,
			COUNT_STAFF=<cfif len(attributes.staff_count)>#attributes.staff_count#<cfelse>NULL</cfif>,
			WORK_DETAIL=<cfif len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>NULL</cfif>,
			PIF_ID = <cfif len(attributes.pif_id) and len(attributes.pif_name)>#attributes.pif_id#<cfelse>NULL</cfif>,
			IS_VIEW_LOGO=<cfif isdefined("attributes.view_logo")>1<cfelse>0</cfif>,
			IS_VIEW_COMPANY_NAME = <cfif isdefined("attributes.view_company_name")>1<cfelse>0</cfif>,
			VIEW_VISUAL_NOTICE = <cfif isdefined("attributes.view_visual_notice")>1<cfelse>0</cfif>,
			VISUAL_NOTICE = <cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>'#attributes.visual_notice#'<cfelse>NULL</cfif>,
			SERVER_VISUAL_NOTICE_ID = #fusebox.server_machine#
	WHERE
		NOTICE_ID = #attributes.notice_id#
</cfquery>
<cfif isDefined("attributes.validator_position_code") and len(attributes.validator_position_code)>
    <cfquery name="add_warning" datasource="#dsn#" result="GET_WARNINGS">
        INSERT INTO
            PAGE_WARNINGS
            (
                URL_LINK,
                WARNING_HEAD,
                WARNING_DESCRIPTION,
                RECORD_DATE,
                LAST_RESPONSE_DATE,
                IS_NOTIFICATION,
                IS_ACTIVE,
                RECORD_IP,
                RECORD_EMP,
                POSITION_CODE,
                IS_CONFIRM,
                IS_REFUSE,
                IS_MANUEL_NOTIFICATION
            )
            VALUES
            (
                '#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#attributes.notice_id#',
                '#getLang('','İK İlanları',55174)#: #attributes.notice_id#',
                <cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#attributes.work_detail#">,
                #NOW()#,
                #NOW()#,
                1,
                1,
                '#CGI.REMOTE_ADDR#',
                #SESSION.EP.USERID#,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_position_code#">,
                1,
                1,
                1
            )
    </cfquery>
    <cfquery name="UPD_WARNINGS" datasource="#dsn#">
        UPDATE PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.IDENTITYCOL# WHERE W_ID = #GET_WARNINGS.IDENTITYCOL#			
    </cfquery>
</cfif>

<!--- <cf_workcube_process
	is_upd='1'
	data_source='#dsn#'
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='NOTICES'
    action_column='NOTICE_ID'
	action_id='#attributes.NOTICE_ID#'
	action_page='#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#attributes.NOTICE_ID#'
	warning_description='#getLang('','İK İlanları',55174)#: #attributes.NOTICE_ID#'> --->

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_notice&event=upd&notice_id=<cfoutput>#attributes.notice_id#</cfoutput>';
</script>