<cfparam name="employee_id" default="#session.ep.userid#">
<cfparam name="salary_mon" default="#attributes.sal_mon#">
<cfparam name="salary_year" default="#attributes.sal_year#">
<cfparam name="id" default="#attributes.id#">
<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
SELECT
   EMPLOYEE_NAME,EMPLOYEE_SURNAME
FROM 
   EMPLOYEES
WHERE 
   EMPLOYEE_ID=#employee_id#
</cfquery>
<cfquery name="GET_PROTESTS" datasource="#DSN#">
	SELECT
	    *
	FROM
		EMPLOYEES_PUANTAJ_PROTESTS
	WHERE 
	    PROTEST_ID=#attributes.id#		
</cfquery>
<cf_catalystHeader>
<cfform name="add_protest" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_protest_answer" onsubmit="">
	<input type="hidden" name="salary_mon" id="salary_mon" value="<cfoutput>#attributes.sal_mon#</cfoutput>">
    <input type="hidden" name="salary_year" id="salary_year" value="<cfoutput>#attributes.sal_year#</cfoutput>">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <cfset ay=ListGetAt(ay_list(),#salary_mon#,',')>
    
	<div class="row">
		<div class="col col-12 uniqueRow">
			<div class="row formContent">
            	<div class="row" type="row">
                	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    	<cfoutput>
                    	<div class="form-group" id="item-EMPLOYEE_ID">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"> :</label>
                            <label class="col col-9 col-xs-12">#get_emp_info(GET_PROTESTS.EMPLOYEE_ID,0,1)#</label>
                        </div>
                        <div class="form-group" id="item-bordro">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="53179.Bordro"> :</label>
                            <label class="col col-9 col-xs-12">#ay# / #salary_year#</label>
                        </div>
    					</cfoutput>
                        <div class="form-group" id="item-PROTEST_DETAIL">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53631.İtiraz'> :</label>
                            <label class="col col-9 col-xs-12 bold"><cfoutput query="GET_PROTESTS">#GET_PROTESTS.PROTEST_DETAIL#</cfoutput></label>
						</div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-12"><cf_get_lang dictionary_id='58654.Cevap'> :</label>
                            <div class="col col-12">
                            	<textarea name="detail" id="detail" style="width:250px;height:100px;"><cfoutput query="GET_PROTESTS"><cfif GET_PROTESTS.ANSWER_DETAIL IS NOT "">#GET_PROTESTS.ANSWER_DETAIL#</cfif></cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                	<div class="col col-12">
                    	<cf_workcube_buttons is_upd='0'>
                    </div>
                </div>
            </div>
		</div>
	</div>
</cfform>	