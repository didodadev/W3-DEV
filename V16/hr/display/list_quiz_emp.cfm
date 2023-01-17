<cfparam name="attributes.page" default=1>
<cfparam name="attributes.chief_url" default="">
<cfparam name="attributes.canditate_url" default="">
<cfset action_list = ''>

<cfquery name="get_quiz" datasource="#dsn#">
	SELECT 
		IS_ALL_EMPLOYEE,
		QUIZ_HEAD
	FROM 
		EMPLOYEE_QUIZ
	WHERE 
		QUIZ_ID=#attributes.quiz_id#
</cfquery>

<cfquery name="POSCATS" datasource="#dsn#">
	SELECT 
		RSQ.RELATION_ACTION_ID,
		EQ.QUIZ_HEAD
	FROM 
		EMPLOYEE_QUIZ EQ,
		RELATION_SEGMENT_QUIZ RSQ 
	WHERE 
		EQ.QUIZ_ID =RSQ.RELATION_FIELD_ID AND   
		EQ.QUIZ_ID=#attributes.quiz_id#
</cfquery>

	<cfquery name="GET_EMPS" datasource="#dsn#">
		SELECT 
			EP.POSITION_CAT_ID,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			SPC.POSITION_CAT
		FROM 
			EMPLOYEES E,
			EMPLOYEE_POSITIONS EP,
			SETUP_POSITION_CAT SPC
		WHERE 
			EP.EMPLOYEE_ID = E.EMPLOYEE_ID
			AND SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
			<cfif get_quiz.is_all_employee eq 1>
				AND EP.POSITION_CAT_ID IS NOT NULL
			<cfelseif poscats.recordcount>
				AND EP.POSITION_CAT_ID IN (#ListSort(ValueList(POSCATS.RELATION_ACTION_ID),"numeric",'asc',',')#)
			<cfelse>
				AND EP.POSITION_CAT_ID IS NULL
			</cfif>
			AND EP.POSITION_STATUS = 1
			AND E.EMPLOYEE_STATUS = 1
			<cfif isdefined('attributes.key') and len(attributes.key)>
				AND	E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.key#%'
			</cfif>
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
<cfquery name="ALL_CHIEFS" datasource="#dsn#">
	SELECT
		CHIEF1_CODE,CHIEF2_CODE,CHIEF3_CODE,SB_ID
	FROM
		EMPLOYEE_POSITIONS_STANDBY
</cfquery>
<cfquery name="ALL_CANDIDATES" datasource="#dsn#">
	SELECT
		CANDIDATE_POS_1, CANDIDATE_POS_2, CANDIDATE_POS_3, SB_ID
	FROM
		EMPLOYEE_POSITIONS_STANDBY
</cfquery>
<cfquery name="ALL_EMPS" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		SETUP_POSITION_CAT.POSITION_CAT, 
		EMPLOYEE_POSITIONS.POSITION_CODE
	FROM
		EMPLOYEE_POSITIONS,
		EMPLOYEES,
		SETUP_POSITION_CAT
	WHERE
		SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
		AND EMPLOYEES.EMPLOYEE_ID =  EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55972.Ölçme-Değerlendirme Yapılacak Çalışanlar"></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
        <cfform name="get_" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&quiz_id=#attributes.quiz_id#&form_varmi=1">
        	<table>
                <tr>
                    <td width="15"><input type="text" name="key" id="key" style="width:100px;" value="<cfif isdefined('attributes.key') and len(attributes.key)><cfoutput>#attributes.key#</cfoutput></cfif>"></td>
                    <td width="25"><input type="text" name="maxrows" id="maxrows" style="width:25px;" value="<cfoutput>#attributes.maxrows#</cfoutput>"></td>
                    <td width="15"><input type="image" src="/images/ara.gif"></td>
                </tr>
            </table>
        </cfform>
    </cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
    	<tr>
        	<th colspan="8"><cf_get_lang dictionary_id='29764.Form'>: <cfoutput>#GET_QUIZ.QUIZ_HEAD#</cfoutput></th>
        </tr>
        <tr>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            <th><cf_get_lang dictionary_id='55490.Amirler'></th>
            <th><cf_get_lang dictionary_id='55973.Yetkililer'></th>
            <th width="15">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfparam name="attributes.totalrecords" default="#GET_EMPS.recordcount#">
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
        <cfif GET_EMPS.recordcount>
        <cfoutput query="GET_EMPS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfquery name="CHECK_RECORDS" datasource="#dsn#">
                SELECT COUNT(*) AS TOTAL_RECORDS FROM SENT_REPLIED_CONTENTS WHERE SEND_EMP = #EMPLOYEE_ID#
            </cfquery>
            <cfif CHECK_RECORDS.TOTAL_RECORDS GT 0><cfset img_to_display = "update_list.gif"><cfelse><cfset img_to_display = "plus_list.gif"></cfif>
            <cfquery name="GET_SB" datasource="#dsn#">
                SELECT
                    EMPLOYEE_POSITIONS_STANDBY.SB_ID
                FROM
                    EMPLOYEE_POSITIONS_STANDBY,
                    EMPLOYEE_POSITIONS
                WHERE
                    EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE
                    AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = #EMPLOYEE_ID#
            </cfquery>
            <cfif GET_SB.recordcount>
                <cfquery name="CHIEFS" dbtype="query">
                    SELECT
                        CHIEF1_CODE, CHIEF2_CODE, CHIEF3_CODE
                    FROM
                        ALL_CHIEFS
                    WHERE
                        SB_ID = #GET_SB.SB_ID#
                </cfquery>
                <cfquery name="CANDIDATES" dbtype="query">
                    SELECT
                        CANDIDATE_POS_1, CANDIDATE_POS_2, CANDIDATE_POS_3
                    FROM
                        ALL_CANDIDATES
                    WHERE
                        SB_ID = #GET_SB.SB_ID#
                </cfquery>
                <cfif CHIEFS.recordcount>
                    <cfloop from="1" to="3" index="i">
                        <cfif len(trim(evaluate("CHIEFS.CHIEF#i#_CODE"))) GT 0>
                            <cfquery name="EMP_DETAIL#i#" dbtype="query">
                                SELECT
                                    EMPLOYEE_ID,
                                    EMPLOYEE_NAME,
                                    EMPLOYEE_SURNAME,
                                    POSITION_CAT
                                FROM
                                    ALL_EMPS
                                WHERE
                                    POSITION_CODE = #evaluate("CHIEFS.CHIEF#i#_CODE")#
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <cfif CANDIDATES.recordcount>
                    <cfloop from="1" to="3" index="i">
                        <cfif len(trim(evaluate("CANDIDATES.CANDIDATE_POS_#i#"))) GT 0>
                            <cfquery name="CANDIDATE_DETAIL#i#" dbtype="query">
                                SELECT
                                    EMPLOYEE_ID,
                                    EMPLOYEE_NAME,
                                    EMPLOYEE_SURNAME,
                                    POSITION_CAT
                                FROM
                                    ALL_EMPS
                                WHERE
                                    POSITION_CODE = #evaluate("CANDIDATES.CANDIDATE_POS_#i#")#
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>
            <tr>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                <td>#POSITION_CAT#</td>
                <td>
                    <cfif GET_SB.recordcount>
                        <cfif CHIEFS.recordcount>
                           <cfloop from="1" to="3" index="i">
                             <cfif len(trim(evaluate("CHIEFS.CHIEF#i#_CODE"))) GT 0>#evaluate("EMP_DETAIL#i#.EMPLOYEE_NAME")# #evaluate("EMP_DETAIL#i#.EMPLOYEE_SURNAME")#<cfset attributes.chief_url = attributes.chief_url & "#evaluate("EMP_DETAIL#i#.EMPLOYEE_NAME")# #evaluate("EMP_DETAIL#i#.EMPLOYEE_SURNAME")#;#evaluate("EMP_DETAIL#i#.EMPLOYEE_ID")#-"></cfif>
                            &nbsp;
                           </cfloop>
                        <cfelse>&nbsp;
                        </cfif>
                    <cfelse>&nbsp;
                    </cfif>
                </td>
                <td>
                    <cfif GET_SB.recordcount>
                        <cfif CANDIDATES.recordcount>
                           <cfloop from="1" to="3" index="i">
                            <cfif len(trim(evaluate("CANDIDATES.CANDIDATE_POS_#i#"))) GT 0>#evaluate("CANDIDATE_DETAIL#i#.EMPLOYEE_NAME")# #evaluate("CANDIDATE_DETAIL#i#.EMPLOYEE_SURNAME")#<cfset attributes.canditate_url = attributes.canditate_url & "#evaluate("CANDIDATE_DETAIL#i#.EMPLOYEE_NAME")# #evaluate("CANDIDATE_DETAIL#i#.EMPLOYEE_SURNAME")#;#evaluate("CANDIDATE_DETAIL#i#.EMPLOYEE_ID")#-"><cfelse>&nbsp;</cfif>
                          &nbsp;
                           </cfloop>
                        <cfelse>&nbsp;
                        </cfif>
                    <cfelse>&nbsp;
                    </cfif>
                </td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_list_other_emp&emp_id=#EMPLOYEE_ID#&quiz_id=#attributes.quiz_id#&chief_url=#attributes.chief_url#&canditate_url=#attributes.canditate_url#&quiz_emp=#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#', 'medium');"><img src="/images/#img_to_display#" border="0"></a></td>
            </tr>
            <cfset attributes.chief_url = "">
            <cfset attributes.canditate_url = "">
        </cfoutput>
        <cfelse>
         <tr>
             <td colspan="5">Kayıt Yok</td>
         </tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cfif isdefined("attributes.form_varmi")>
    <cfif (GET_EMPS.recordcount gt attributes.maxrows)>
        <table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
            <tr>
                <td>
					<cfset send = "#attributes.fuseaction#&quiz_id=#attributes.quiz_id#&form_varmi=1">
                    <cf_pages
                      page="#attributes.page#"
                      maxrows="#attributes.maxrows#"
                      totalrecords="#GET_EMPS.recordcount#"
                      startrow="#attributes.startrow#"
                      adres="#send#"> 
                </td>
                <td  style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayit'>: <cfoutput>#GET_EMPS.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            </tr>
        </table>
    </cfif>	  
</cfif>
