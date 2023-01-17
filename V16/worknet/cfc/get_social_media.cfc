<cfcomponent displayname="social_media_info" hint="Sosyal Medya">
	 <cffunction name="get_social_media_info" returntype="query" hint="Sosyal Medya listeleme query">
	 <cfargument name="startdate" default="" displayname="Başlama Tarihi" required="yes">
	 <cfargument name="site_name" default="">
	 <cfargument name="process_stage" default="">
	 <cfargument name="search_words" default="">
	 <cfargument name="language" default="">
	 <cfargument name="keyword" default="">
	 <cfargument name="startrow" default="">
	 <cfargument name="dsn" default="">
	 <cfargument name="data_source" default="">
	 <cfargument name="maxrows" default="">
	 <cfargument name="page" default="1"> 
		<cfsavecontent variable="order_by">
				SID
		</cfsavecontent>
		
<cf_wrk_cfc_query name="get_social_media_report" datasource="#dsn#" query_name = "get_social_media_report" maxrows="#maxrows#" startrow="#startrow#" order_by ="#order_by#">
	<cfoutput>	
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
			<cfif isdefined("site_name") and len(site_name)>
				AND SOC.SITE LIKE '%#site_name#%'
			</cfif>
			<cfif isdefined("process_stage") and len(process_stage)>
				AND SOC.PROCESS_ROW_ID =#process_stage#
			</cfif>
			<cfif isdefined("search_words") and len(search_words)>
				AND SOC.SEARCH_KEY= (SELECT WORD FROM SOCIAL_MEDIA_SEARCH_WORDS WHERE WORD_ID=#search_words#)
			</cfif>
			<cfif isdefined("language") and len(language)>
				AND SOC.LANGUAGE= '#language#'
			</cfif>
			<cfif isdefined("startdate") and len(startdate)>
				AND
				((SOC.PUBLISH_DATE >= #startdate# AND SOC.PUBLISH_DATE < #DATEADD("d",1,finishdate)#) OR PUBLISH_DATE IS NULL)
			</cfif>		
			<cfif isdefined("keyword") and len(keyword)>
				AND (  
						SOC.SITE LIKE '%#keyword#%' OR
						SOC.SOCIAL_MEDIA_CONTENT LIKE '%#keyword#%'
					)
			</cfif>
		</cfoutput>
</cf_wrk_cfc_query>
<cfreturn #get_social_media_report# />
</cffunction>
	
	<cffunction name="upd_social_media" displayname="Sosyal Medya Güncelleme" hint="Sosyal Medya Güncelleme Query">
		<cfargument name="process_stage">
		<cfargument name="sid">
		<cfquery name="upd_social_media" datasource="#dsn#">
			UPDATE 
				  SOCIAL_MEDIA_REPORT 
			SET
				  PROCESS_ROW_ID = #process_stage#,
				  UPDATE_DATE = #now()#,
				  UPDATE_EMP = #session.ep.userid#,
				  UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				  SID = #sid#
		</cfquery>		
	</cffunction>
	<cffunction name="delete_social_media" access="remote" displayname="Sosyal Medya Silme Query">
		<cfargument name="sid">
		<cfquery name="del_social_media" datasource="workcube_cf">
			DELETE FROM SOCIAL_MEDIA_REPORT WHERE SID = #sid#
		</cfquery>
	</cffunction>
</cfcomponent>

