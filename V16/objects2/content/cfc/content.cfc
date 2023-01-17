<!---
    File :          V16\objects2\content\cfc\content.cfc
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          14.01.2022
    Description :   CONTENT ile ilgili servisler burdan gelir.
--->
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset session_base.period_is_integrated = 0>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
    </cfif> 
    <cffunction name="GET_CONTENT" access="remote" returntype="string" returnFormat="json">
        <cfargument name="content_id" type="string" required="yes">
        <cftry>
            <cfquery name="GET_CONTENT" datasource="#dsn#">        	
               SELECT
					C.CONTENT_ID,
					C.CONT_HEAD,
					C.CONT_BODY,
					C.CONT_SUMMARY					
				FROM
					CONTENT C
				WHERE 
					C.CONTENT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#content_id#" list="Yes" separator=",">)					
					AND C.LANGUAGE_ID = '#session_base.language#'
            </cfquery>
            <cfset result.status = true>
            <cfset result.data = this.returnData(replace(serializeJSON(GET_CONTENT),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="GET_BLOG_CONTENT" access="remote" returntype="string" returnFormat="json">
        <cfargument name="page" type="string">

        <cfargument name="PROTEIN_SITE" type="string">
        <cfargument name="list_start_date" type="string">
        <cfargument name="list_finish_date" type="string">

        <cfargument name="tab1_name" type="string">
        <cfargument name="tab1_chap_id" type="string">

        <cfargument name="tab2_name" type="string">
        <cfargument name="tab2_chap_id" type="string">

        <cfargument name="tab3_name" type="string">
        <cfargument name="tab3_chap_id" type="string">

        <cfargument name="tab4_name" type="string">
        <cfargument name="tab4_chap_id" type="string">

        <cfargument name="tab5_name" type="string">
        <cfargument name="tab5_chap_id" type="string">

        <cfargument name="is_content_main_sort" type="string">
        
        <cftry>
            <cfquery name="GET_CONTENT" datasource="#dsn#">        	
              SELECT
                C.CONTENT_ID,
                C.CONT_HEAD,
                /* C.CONT_BODY, */
                UFU.USER_FRIENDLY_URL,
                C.CONT_SUMMARY,
                C.PRIORITY,
                C.RECORD_DATE,
                C.RECORD_MEMBER,
                C.UPDATE_MEMBER,
                C.UPDATE_DATE,
                OUTHOR_EMP_ID,
                OUTHOR_CONS_ID,
                OUTHOR_PAR_ID,
                CC.CHAPTER_ID,
                CC.CHAPTER,
                CCAT.CONTENTCAT_ID,
                CPR.CONTENT_PROPERTY_ID,
                CPR.NAME,
                CI.CONTIMAGE_SMALL,
                CI.IMAGE_SERVER_ID
            FROM 
                CONTENT AS C
                OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'cntid' 
                    AND UFU.ACTION_ID = C.CONTENT_ID 		
                    AND UFU.PROTEIN_SITE = #PROTEIN_SITE#) UFU
                LEFT JOIN CONTENT_CHAPTER AS CC	ON C.CHAPTER_ID = CC.CHAPTER_ID
                LEFT JOIN CONTENT_CAT AS CCAT ON CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
                LEFT JOIN CONTENT_PROPERTY AS CPR ON C.CONTENT_PROPERTY_ID = CPR.CONTENT_PROPERTY_ID
                LEFT JOIN CONTENT_IMAGE AS CI ON C.CONTENT_ID = CI.CONTENT_ID
            WHERE		
                <cfif len(list_start_date)>
                    C.VIEW_DATE_START >= #createodbcdatetime(list_start_date)# AND 
                </cfif>
                <cfif len(list_finish_date)>
                    C.VIEW_DATE_FINISH <= #createodbcdatetime(list_finish_date)# AND
                </cfif>
                C.SPOT <> 1 AND 		 
                C.CONTENT_STATUS = 1 AND			
                INTERNET_VIEW = 1 AND
                UFU.USER_FRIENDLY_URL IS NOT NULL
                AND(
                    C.CHAPTER_ID  IN (0)
                    <cfif len(tab1_name)>
                        OR C.CHAPTER_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#tab1_chap_id#">)
                    </cfif>
                    <cfif len(tab2_name)>       
                        OR C.CHAPTER_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#tab2_chap_id#">)
                    </cfif>
                    <cfif len(tab3_name)>
                        OR C.CHAPTER_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#tab3_chap_id#">)
                    </cfif>
                    <cfif len(tab4_name)>
                        OR C.CHAPTER_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#tab4_chap_id#">)
                    </cfif>
                    <cfif len(tab5_name)>
                        OR C.CHAPTER_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#tab5_chap_id#">)
                    </cfif> 
                )
            ORDER BY 		
                <cfif isdefined('is_content_main_sort') and is_content_main_sort eq 1>
                    C.UPDATE_DATE DESC,
                    C.PRIORITY
                <cfelse>
                    C.RECORD_DATE DESC
		        </cfif>
                <cfif isDefined('page') and len(page)>
                    OFFSET #(page eq 1)?0:((page-1)*25)# ROWS FETCH NEXT 25 ROWS ONLY
                </cfif>
            </cfquery>
            <cfset result.status = true>
            <cfset result.this_page = page>
            <cfset result.next_page = page+1>
            <cfset result.count = queryRecordCount(GET_CONTENT)>
            <cfset result.data = this.returnData(replace(serializeJSON(GET_CONTENT),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>

