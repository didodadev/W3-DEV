<cfsetting showdebugoutput="no">
<cfif not isdefined("xml_list_work")><cfset xml_list_work = ''></cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="10">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfquery name="GET_MILESTONE_WORKS" datasource="#dsn#">
	SELECT SHOW_MILESTONE FROM MY_SETTINGS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfquery name="GET_WORKS" datasource="#DSN#">
  WITH CTE1 AS (
    SELECT 
        PW.PROJECT_ID,
        PW.WORK_HEAD,
        PW.WORK_ID,
        PW.WORK_CURRENCY_ID,
        PW.WORK_PRIORITY_ID,
        SP.COLOR,
        SP.PRIORITY,
        PW.TARGET_FINISH,
        PW.RECORD_DATE,
        PW.TARGET_START,
        PW.TERMINATE_DATE,
        PW.PROJECT_EMP_ID,
		PW.UPDATE_DATE,
        PTR.STAGE_CODE,
        PTR.STAGE AS STAGE,
        PP.PROJECT_HEAD
    FROM 
        PRO_WORKS PW
        LEFT JOIN SETUP_PRIORITY SP ON PW.WORK_PRIORITY_ID = SP.PRIORITY_ID
        LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID = PW.WORK_CURRENCY_ID
        LEFT JOIN PRO_PROJECTS AS PP ON PW.PROJECT_ID = PP.PROJECT_ID
    WHERE 
        PW.WORK_STATUS = 1 AND
        (
            PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
            <cfif isdefined('xml_work_cc') and xml_work_cc eq 1>
                OR PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)<!--- cc den gelen isleri renklendirmek icin kullanildi --->
            </cfif>
        ) 
        <cfif GET_MILESTONE_WORKS.SHOW_MILESTONE eq 0>
            AND
                ISNULL(IS_MILESTONE,0) = #GET_MILESTONE_WORKS.SHOW_MILESTONE#
         </cfif>
         ),
        
       CTE2 AS (
            SELECT
                CTE1.*,
                ROW_NUMBER() OVER ( ORDER BY 
                                    <cfif xml_list_work eq 2>
                                        ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                                    <cfelseif xml_list_work eq 3>
                                        TARGET_START DESC
                                    <cfelseif xml_list_work eq 4>
                                        TARGET_START
                                    <cfelseif xml_list_work eq 5>
                                        terminate_date DESC
                                    <cfelseif xml_list_work eq 6>
                                        terminate_date
                                    <cfelseif xml_list_work eq 7>
                                        WORK_HEAD	
                                    <cfelseif xml_list_work eq 1>
                                        WORK_ID DESC
                                    <cfelse>
                                        RECORD_DATE	DESC
                                    </cfif>
                                ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
            FROM
                CTE1
        )
        SELECT
            CTE2.*
        FROM
            CTE2
        WHERE
            RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>
<cfset adres="myhome.emptypopup_my_works_ajaxmyworks&xml_list_work=#xml_list_work#&x_show_work_complete=#x_show_work_complete#&xml_work_cc=#xml_work_cc#">
<cfif GET_WORKS.recordcount>
    <cfparam name="attributes.totalrecords" default="#GET_WORKS.query_count#">
<cfelse>
    <cfparam name="attributes.totalrecords" default="0">
</cfif>
<div id="worksWidget">
<cf_flat_list>  
    <cfif get_works.recordcount>
        <thead>
            <tr>
                <th><cf_get_lang_main no="1165.Sıra"></th>
                <th><cf_get_lang_main no="1115.ID"></th>
                <th><cf_get_lang_main no="68.Konu"></th>
                <th><cf_get_lang_main no="4.proje"></th>
                <th><cf_get_lang_main no="70.aşama"></th>                
                <th><cf_get_lang_main dictionary_id="60609.Termin tarihi"></th>
                <cfif isdefined("x_show_work_complete") and x_show_work_complete eq 1>
                    <th><cf_get_lang no="274.Kalan zaman"></th>                
                </cfif>
                <th><i class="catalyst-fire bold" title="<cf_get_lang_main no="73.öncelk">"></i></th>
            </tr>
        </thead>
        <tbody> 
            <cfoutput query="get_works">
            <cfif session.ep.userid neq get_works.project_emp_id><cfset _row_font_color_ ='font-green'><cfelse><cfset _row_font_color_ =''></cfif><!--- cc den gelen isleri renklendirmek icin kullanildi --->
                <tr>
                    <td>#rownum#</td>
                    <td><a class="#_row_font_color_#" href="#request.self#?fuseaction=project.works&event=det&id=#get_works.work_id#">#get_works.work_id#</a></td>
                    <td><a class="#_row_font_color_#" href="#request.self#?fuseaction=project.works&event=det&id=#get_works.work_id#">#URLDecode(get_works.work_head)#</a></td>
                    <td class="#_row_font_color_#"><cfif len(project_id)><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="#_row_font_color_#" title="#PROJECT_HEAD#">#left(PROJECT_HEAD,20)#..</a><cfelse><cf_get_lang_main no='1047.Projesiz'></cfif></td>
                    <td class="#_row_font_color_#"><cfif Len(STAGE_CODE)>#STAGE_CODE#-</cfif>#STAGE#</td>
                    <cfif len(terminate_date)>
                    <td class="#_row_font_color_#" >#dateformat(get_works.terminate_date,dateformat_style)#</td>
                    <cfelse>
                        <td>-</td>
                    </cfif>
                    <cfif isdefined("x_show_work_complete") and x_show_work_complete eq 1>
                        <td>
                            <cfif datediff('n',now(),(len(terminate_date) ? terminate_date : target_finish)) lt 0>
                                <span class="font-red-pink">% 0</span>
                            <cfelseif datediff('n',now(),target_start) lt 0>
                               <cfif target_start neq (len(terminate_date) ? terminate_date : target_finish)>
                                    <cfset diff = round((datediff('n',target_start,now())/datediff('n',target_start,(len(terminate_date) ? terminate_date : target_finish)))*100)>
                                <cfelse>
                                    <cfset diff = round((datediff('n',target_start,now()))*100)>
                                </cfif>
                                <cfif diff gte 100><cfset diff = 100></cfif>
                                <span class="font-yellow-lemon">% #evaluate(100-diff)#</span>
                            <cfelse>
                               <span class="font-green-meadow">% 100</span>
                            </cfif>
                        </td>
                    </cfif>
                     <td><i class="catalyst-fire bold" style="color:###get_works.color#;" title="#get_works.priority#"></i></td>
                </tr>
            </cfoutput>
         <cfelse>
            <tr><td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td></tr>
        </cfif>
    </tbody>
</cf_flat_list>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cf_paging
        name="my_works"
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#"
        isAjax="1"
        target="worksWidget"
        >
</cfif>
</div>