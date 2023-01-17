<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.search_words" default="">
    <cfquery name="get_social_media_site" datasource="#dsn#">
        SELECT DISTINCT(SITE) AS SITE FROM SOCIAL_MEDIA_REPORT
    </cfquery>
    <cfquery name="get_social_media_words" datasource="#dsn#">
        SELECT WORD_ID,WORD FROM SOCIAL_MEDIA_SEARCH_WORDS
    </cfquery>
    <cfquery name="get_process_types" datasource="#dsn#">
        SELECT
            PTR.STAGE AS STAGE,
            PTR.PROCESS_ROW_ID AS ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%worknet.list_social_media%">
        ORDER BY
            ROW_ID ASC
    </cfquery>
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    <cfelse>
        <cfset attributes.startdate = date_add('d',-1,createodbcdatetime('#(now())#'))>
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    <cfelse>
        <cfset attributes.finishdate = date_add('d',1,attributes.startdate)>
    </cfif>
    
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfif isdefined("attributes.form_submit")>
        <cfquery name="get_social_media_result" datasource="#dsn#">
            WITH CTE1 AS (	
                SELECT 
                    SOC.SID,
                    SOC.SOCIAL_MEDIA_ID,
                    SUBSTRING(SOC.SOCIAL_MEDIA_CONTENT,1,100) AS SOCIAL_MEDIA_CONTENT,
                    SOC.PUBLISH_DATE,
                    SOC.IMAGE,
                    SOC.USER_NAME,
                    SOC.SEARCH_KEY,
                    SOC.SITE,
                    SOC.RECORD_DATE,
                    SOC.RECORD_EMP,
                    SOC.RECORD_IP,
                    SOC.UPDATE_EMP,
                    SOC.PROCESS_ROW_ID AS PROCESS,
                    SOC.UPDATE_DATE,
                    SOC.UPDATE_IP,
                    SOC.COMMENT_URL,
                    SOC.LANGUAGE,
                    SOC.USER_ID,
                    PRO.PROCESS_ROW_ID ,
                    PRO.STAGE AS STAGE
                FROM 
                    SOCIAL_MEDIA_REPORT SOC,
                    PROCESS_TYPE_ROWS PRO
                WHERE
                        SOC.PROCESS_ROW_ID = PRO.PROCESS_ROW_ID 
                    <cfif isdefined("attributes.site_name") and len(attributes.site_name)>
                        AND SOC.SITE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.site_name#%">
                    </cfif>
                    <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                        AND SOC.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                    </cfif>
                    <cfif isdefined("attributes.search_words") and len(attributes.search_words)>
                        AND SOC.SEARCH_KEY= (SELECT WORD FROM SOCIAL_MEDIA_SEARCH_WORDS WHERE WORD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_words#">)
                    </cfif>
                    <cfif isdefined("attributes.language") and len(attributes.language)>
                        AND SOC.LANGUAGE= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language#">
                    </cfif>
                    <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
                        AND
                        ((SOC.PUBLISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND SOC.PUBLISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finishdate)#">) OR PUBLISH_DATE IS NULL)
                    </cfif>		
                    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                        AND (  
                                SOC.SITE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                                SOC.SOCIAL_MEDIA_CONTENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                            )
                    </cfif>
                    ),
                    CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (ORDER BY PUBLISH_DATE  DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startrow#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.startrow+(attributes.maxrows-1)#">
        </cfquery>	
        <cfparam name="attributes.totalrecords" default="#get_social_media_result.QUERY_COUNT#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
		<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
	<cfinvoke component="worknet.cfc.get_social_media" method="upd_social_media">
		<cfinvokeargument name="sid" value="#attributes.sid#">
		<cfinvokeargument name="dsn" value="#dsn#">
		<cfinvokeargument name="process_stage" value="#attributes.process_stage#">
	</cfinvoke>
	<cf_workcube_process 
				is_upd='1' 
				data_source='#dsn#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#'
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_page='#request.self#?fuseaction=worknet.upd_social_media&sid=#attributes.sid#' 
				action_id='#attributes.sid#'>
	</cfif>
	<cfquery name="get_social_media_info"  datasource="#dsn#"> 
		SELECT 
			SID, 
			SOCIAL_MEDIA_ID, 
			SOCIAL_MEDIA_CONTENT, 
			PUBLISH_DATE, 
			USER_NAME, 
			SITE, 
			RECORD_DATE, 
			UPDATE_EMP, 
			PROCESS_ROW_ID, 
			UPDATE_DATE, 
			COMMENT_URL, 
			USER_ID
		FROM 
			SOCIAL_MEDIA_REPORT 
		WHERE 
			SID = #attributes.sid#
	</cfquery>
	<cfquery name="get_social_media_comment" datasource="#dsn#">
		SELECT 
			SC.USER_NAME AS USER_NAME,
			SC.SOCIAL_MEDIA_COMMENT_CONTENT AS SOCIAL_MEDIA_COMMENT_CONTENT,
			SC.PUBLISH_DATE AS PUBLISH_DATE,
			SR.SITE AS SITE,
			SC.USER_ID AS USER_ID
		FROM 
			SOCIAL_MEDIA_COMMENT SC,SOCIAL_MEDIA_REPORT SR 
		WHERE 
			SC.SOCIAL_MEDIA_ID=SR.SOCIAL_MEDIA_ID
													AND
			SR.SID=#attributes.sid#
	</cfquery>
	<cfquery name="get_process_types" datasource="#dsn#">
		SELECT
			PTR.STAGE AS STAGE,
			PTR.PROCESS_ROW_ID AS ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PTR.PROCESS_ID = PT.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%worknet.list_social_media%">
		ORDER BY
			ROW_ID ASC
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'upd')>									 
			function face_go()
			{
				<cfif  #get_social_media_info.SITE# EQ 'facebook'>
				window.open('<cfoutput>http://www.facebook.com/#listgetat(get_social_media_info.SOCIAL_MEDIA_ID,2,'_')#</cfoutput>','');
				</cfif>
			}
			function friend_go()
			{
				window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
			}
			function googlep_go()
			{
			   window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
			}
			function youtube_go()
			{
				window.open('<cfoutput>#get_social_media_info.COMMENT_URL#</cfoutput>','');
			}
	</cfif>
</script>	
<cfscript>


// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'worknet.list_social_media';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'worknet/display/list_social_media.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'worknet.list_social_media';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'worknet/form/upd_social_media.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'worknet/query/upd_social_media.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'worknet.list_social_media&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'sid=##attributes.sid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_social_media_info.site##-##attributes.sid##';

		// type'lar include,box,custom tag şekline dönüşecek.
		
	WOStruct['#attributes.fuseaction#']['pageParams']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['pageParams']['upd']['size'] = '8-4';
	
	WOStruct['#attributes.fuseaction#']['pageObjects'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['type'][0][0] = 0;
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['file'][0][0] = 'worknet/form/upd_social_media.cfm';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['id'][0][0] = 'notes';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['title'][0][0] = 'Notlar';
	
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['type'][1][0] = 1;
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['file'][1][0] = '<cf_get_workcube_note action_section="social_media" action_id="##attributes.sid##" style="1">';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['id'][1][0] = 'notes';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['title'][1][0] = 'Notlar';

	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['type'][1][1] = 1;
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['file'][1][1] = '<cf_get_workcube_asset asset_cat_id="-23" module_id="37" action_section="social_media" action_id="##attributes.sid##">';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['id'][1][1] = 'notes';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['title'][1][1] = 'Belgeler';

</cfscript>
