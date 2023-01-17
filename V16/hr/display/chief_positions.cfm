<cfparam name="attributes.modal_id" default="">
    <cf_box title="#getLang('','Değerlendirici Olunan Pozisyonlar',55331)#" scroll="1" collapsable="1" resize="1" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="" method="post" name="add_">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group">
					<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id="58497.Pozisyon"></label>
						<div class="col col-4  col-xs-12">
                            <input name="chief_code" id="chief_code" type="hidden" value="<cfif isdefined("attributes.chief_code")><cfoutput>#attributes.chief_code#</cfoutput></cfif>">
                            <cfif isdefined("attributes.chief_code")>
                                <cfset attributes.POSITION_CODE = attributes.chief_code>
                            <cfinclude template="../query/get_position.cfm">
                            </cfif>
                            <cfif isdefined("attributes.chief_code")>
                                <!--- <cfsavecontent variable = "message"><cf_get_lang dictionary_id="33571.Pozisyon Çalışanı Seçiniz!"></cfsavecontent> --->
                                <cfinput name="chief_emp" type="text"  readonly value="#get_position.employee_name# #get_position.employee_surname#" required="yes" >
                            <cfelse>
                                <!--- <cfsavecontent variable = "message"><cf_get_lang dictionary_id="33571.Pozisyon Çalışanı Seçiniz!"></cfsavecontent> --->
                                <cfinput name="chief_emp" type="text"  readonly value="" required="yes">
                            </cfif>
                        </div>
						<div class="col col-4  col-xs-12">
                            <div class="input-group">
                             
                                <cfif isdefined("attributes.chief_code")>
                                    <!--- <cfsavecontent variable = "message"><cf_get_lang dictionary_id="56375.Pozisyon Seçmelisiniz"></cfsavecontent> --->
                                    <cfinput name="chief_name"  type="text" style="width:100px;" readonly value="#get_position.position_name#" required="yes" >
                                <cfelse>
                                    <!--- <cfsavecontent variable = "message"><cf_get_lang dictionary_id="56375.Pozisyon Seçmelisiniz"></cfsavecontent> --->
                                    <cfinput name="chief_name"  type="text" style="width:100px;" readonly value="" required="yes" >
                                </cfif>	
                                    <cfoutput><span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_positions&field_code=add_.chief_code&field_emp_name=add_.chief_emp&field_pos_name=add_.chief_name');"></span></cfoutput>

                            </div>
					    </div>
				</div>
			</div>
    </cf_box_elements>
<cf_box_footer>
    <cf_wrk_search_button button_type="5"  search_function="kontrol()">
</cf_box_footer>
    </cfform>				
<cfif isdefined("attributes.chief_code")>
	<cfquery name="get_standbys" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
		EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE,
        EMPLOYEE_POSITIONS_STANDBY.CANDIDATE_POS_1,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CAT_ID,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS_STANDBY.SB_ID,		
		B.BRANCH_NAME,
		B.BRANCH_ID,
		D.DEPARTMENT_HEAD
	FROM
		EMPLOYEE_POSITIONS_STANDBY,
		EMPLOYEE_POSITIONS,
		EMPLOYEES,
		OUR_COMPANY,
		BRANCH B,
		DEPARTMENT D
	WHERE
		(
		EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE = #attributes.chief_code# 
		OR
		EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE = #attributes.chief_code#
		OR
		EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE = #attributes.chief_code#
        OR
        EMPLOYEE_POSITIONS_STANDBY.CANDIDATE_POS_1 = #attributes.chief_code#
		)
		AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE AND
		OUR_COMPANY.COMP_ID=B.COMPANY_ID AND 
		B.BRANCH_ID=D.BRANCH_ID AND 
		D.DEPARTMENT_ID=EMPLOYEE_POSITIONS.DEPARTMENT_ID
	ORDER BY EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE DESC,EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE DESC,EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE DESC
	</cfquery>
	<!--- <cfquery name="get_quizs" datasource="#dsn#">
		SELECT 
			EQ.QUIZ_ID,
			EQ.QUIZ_HEAD,
			RS.RELATION_ACTION_ID POSITION_CAT_ID,
			EQ.FORM_OPEN_TYPE,
			EQ.POSITION_ID
		FROM 
			EMPLOYEE_QUIZ EQ,
			RELATION_SEGMENT_QUIZ RS
		WHERE 
			EQ.QUIZ_ID = RS.RELATION_FIELD_ID
			AND RS.RELATION_ACTION = 3 AND
			EQ.IS_ACTIVE = 1 AND
			EQ.STAGE_ID = -2 AND
			EQ.IS_EDUCATION <> 1 AND
			EQ.IS_TRAINER <> 1 AND
			EQ.FORM_YEAR = #session.ep.period_year#
	</cfquery> --->
	<!--- performans formları---->
	<cfquery name="get_quizs" datasource="#dsn#">
		SELECT 
			PC.POSITION_CAT_ID,
			SM.SURVEY_MAIN_HEAD,
			SM.SURVEY_MAIN_ID 
		FROM 
			SURVEY_MAIN SM INNER JOIN SURVEY_MAIN_POSITION_CATS PC
			ON SM.SURVEY_MAIN_ID = PC.SURVEY_MAIN_ID
		WHERE
			YEAR(SM.START_DATE) = #session.ep.period_year# AND
			SM.IS_ACTIVE = 1			
	</cfquery>
<cf_grid_list>
	<thead>
        <tr>
            <th colspan="6"><cfoutput>#get_position.position_name# - #get_position.employee_name# #get_position.employee_surname#</cfoutput></th>
        </tr>
        <tr>
            <th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
            <th width="125"><cf_get_lang dictionary_id="57576.Çalışan"></th>
            <th><cf_get_lang dictionary_id="55907.Değerlendirme Formu"></th>
            <!--- <th><cf_get_lang no='915.Form Tipi'></th> --->
            <th><cf_get_lang dictionary_id='57453.Şube'>-<cf_get_lang dictionary_id='57572.Departman'></th>			
            <th width="75"><cf_get_lang dictionary_id="57756.Durum"></th>
        </tr>
    </thead>
    <tbody>
	<cfif get_standbys.recordcount>
		<cfoutput query="get_standbys">
            <cfset position_cat_id = get_standbys.POSITION_CAT_ID>
           <!---  <cfset position_id=get_standbys.POSITION_ID>
            <cfquery name="get_position_quiz" dbtype="query">
                SELECT 
                    QUIZ_HEAD,
                    FORM_OPEN_TYPE,
                    POSITION_ID
                FROM 
                    get_quizs
                WHERE 
                    POSITION_ID IS NOT NULL AND
                    POSITION_ID LIKE '%,#position_id#,%' 
            </cfquery> 
            <cfif not get_position_quiz.recordcount>
                <cfquery name="get_emp_quizs" dbtype="query">
                    SELECT QUIZ_HEAD,FORM_OPEN_TYPE FROM get_quizs WHERE POSITION_CAT_ID = #position_cat_id#
                </cfquery>
            </cfif>--->
			<cfquery name="get_emp_quizs" dbtype="query">
				SELECT SURVEY_MAIN_HEAD FROM get_quizs WHERE POSITION_CAT_ID = #position_cat_id#
			</cfquery>
          <tr>
            <td>#position_name#</td>
            <td>#employee_name# #employee_surname#</td>
            <td>
                <cfif get_emp_quizs.recordcount>
					 #get_emp_quizs.SURVEY_MAIN_HEAD# (P.T.)
                <cfelse>
                    -
				</cfif>
				<!--- <cfif get_position_quiz.recordcount>
                    #get_position_quiz.QUIZ_HEAD# (P.)
                <cfelseif get_emp_quizs.recordcount>
                    #get_emp_quizs.QUIZ_HEAD# (P.T.)
                <cfelse>
                    -
                </cfif> --->
            </td>
           <!--- 
		   20121015 SG
		   <td>
                <cfif get_position_quiz.recordcount>
                    <cfif get_position_quiz.FORM_OPEN_TYPE eq 1>Açık
                    <cfelseif get_position_quiz.FORM_OPEN_TYPE  eq 2>Yarı Açık
                    <cfelseif get_position_quiz.FORM_OPEN_TYPE eq 3>Kapalı
                    </cfif>
                <cfelseif get_emp_quizs.recordcount>
                    <cfif get_emp_quizs.FORM_OPEN_TYPE eq 1>Açık
                    <cfelseif get_emp_quizs.FORM_OPEN_TYPE  eq 2>Yarı Açık
                    <cfelseif get_emp_quizs.FORM_OPEN_TYPE eq 3>Kapalı
                    </cfif>
                <cfelse>
                    -
            </cfif>
            </td> --->
            <td>#BRANCH_NAME# - #DEPARTMENT_HEAD#</td>
            <td>
                <cfif CHIEF1_CODE eq attributes.chief_code>1.<cf_get_lang dictionary_id="55620.Değerlendirici"></cfif>
                <cfif CHIEF2_CODE eq attributes.chief_code>2.<cf_get_lang dictionary_id="55620.Değerlendirici"></cfif>
                <cfif CHIEF3_CODE eq attributes.chief_code><cf_get_lang dictionary_id="31406.Görüş"></cfif>
                <cfif CANDIDATE_POS_1 eq attributes.chief_code><cf_get_lang dictionary_id="33570.Yedek Değerlendirici"></cfif>
            </td>
          </tr>
        </cfoutput>
    </cfif>
    </tbody>
</cf_grid_list>
</cfif>
</cf_box>

<script type="text/javascript">
function kontrol()
{
if(document.add_.chief_emp.value == '' ||  document.add_.chief_name.value == '')
    {
    alert("<cf_get_lang dictionary_id='56375.Pozisyon Seçmelisiniz'>");
    return false;
    }
    else{<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_' , #attributes.modal_id#)"),DE(""))#</cfoutput>}
}
</script> 
