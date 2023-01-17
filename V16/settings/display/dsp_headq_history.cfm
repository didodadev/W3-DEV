<cfquery name="get_hist" datasource="#dsn#">
	SELECT 
	    HEADQ_HIST_ID, 
        HEADQUARTERS_ID, 
        NAME, 
        HIERARCHY, 
        HEADQUARTERS_DETAIL, 
        IS_ORGANIZATION, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPPER_HEADQUARTERS_ID,        
        (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = SH.RECORD_EMP) AS RECORD_NAME,
        (SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE  E.EMPLOYEE_ID = SH.UPDATE_EMP) AS UPDATE_NAME
    FROM 
    	SETUP_HEADQ_HISTORY  SH
    WHERE 
    	HEADQUARTERS_ID = #attributes.head_id# 
    ORDER BY 
    	UPDATE_DATE DESC
</cfquery>
<cf_catalystHeader>
<div class="row"> 
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
<cfif get_hist.recordcount>
	<cfset temp_ = 0>
    <cfoutput query="get_hist">
		<cfset temp_ = temp_ +1>
        <cfif len(UPDATE_DATE)>
            <cf_seperator id="history_#temp_#" header="#dateformat(date_add("h",session.ep.time_zone,UPDATE_DATE),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,UPDATE_DATE),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
        <cfelse>
            <cf_seperator id="history_#temp_#" header="#dateformat(date_add("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#) - #RECORD_NAME#" is_closed="1">
        </cfif>
        <div class="row" id="history_#temp_#" style="display:none;">
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">                
                <div class="form-group">
                    <label class="col col-6 bold"><cf_get_lang_main no='219.Ad'></label>
                    <div class="col col-6"> 
                        #NAME#
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-6 bold">#getLang('settings',1648)#</label>
                    <div class="col col-6"> 
                        <input type="checkbox" disabled="disabled"<cfif IS_ORGANIZATION eq 1>checked</cfif>>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-6 bold"><cf_get_lang no='954.Üst Başkanlık'></label>
                    <div class="col col-6"> 
                        <cfif len(UPPER_HEADQUARTERS_ID)>
                            <cfquery name="get_upp_name" datasource="#dsn#">
                                SELECT NAME FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID = #UPPER_HEADQUARTERS_ID#
                            </cfquery>
                            <cfif get_upp_name.recordcount>
                                #get_upp_name.NAME#
                            </cfif>
                        </cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-6 bold"><cf_get_lang_main no='377.Özel Kod'></label>
                    <div class="col col-6"> 
                        #hierarchy#
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-6 bold"><cf_get_lang_main no='217.Açıklama'></label>
                    <div class="col col-6"> 
                        #HEADQUARTERS_DETAIL#
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-6 bold"><cf_get_lang_main no='479.Güncelleyen'></label>
                    <div class="col col-6"> 
                        <cfif len(UPDATE_EMP)>
                            #get_emp_info(UPDATE_EMP,0,0)#
                        <cfelse>
                            #get_emp_info(RECORD_EMP,0,0)#
                        </cfif>
                    </div>
                </div>                
            </div>
        </div>
	</cfoutput>
</cfif>
