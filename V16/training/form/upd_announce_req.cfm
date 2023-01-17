<cfquery name="get_reqs" datasource="#dsn#">
	SELECT CLASS_ID,IS_VALID FROM TRAINING_REQUEST_ROWS WHERE EMPLOYEE_ID = #session.ep.userid# AND ANNOUNCE_ID = #attributes.announce_id#
</cfquery>
<cfquery name="get_announce" datasource="#dsn#">
	SELECT ANNOUNCE_HEAD, DETAIL FROM TRAINING_CLASS_ANNOUNCEMENTS WHERE ANNOUNCE_ID = #attributes.announce_id#
</cfquery>
<cfquery name="get_class" datasource="#dsn#">
	SELECT
		TC.CLASS_NAME,
		TC.CLASS_ID,
		TC.START_DATE,
		TC.FINISH_DATE,
		TC.MAX_PARTICIPATION
	FROM
		TRAINING_CLASS TC,
		TRAINING_CLASS_ANNOUNCE_CLASSES TCAC
	WHERE
		TC.CLASS_ID = TCAC.CLASS_ID AND
		TCAC.ANNOUNCE_ID = #attributes.announce_id#
</cfquery>
<cf_medium_list_search title="#getLang('training',6)#">      </cf_medium_list_search>
<cf_medium_list>
    <thead>
        <tr>
      	  <th class="form-title"><cfoutput>#get_announce.ANNOUNCE_HEAD#</cfoutput></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><cfoutput>#get_announce.DETAIL#</cfoutput></td>
        </tr>
    </tbody>
</cf_medium_list>
<cfif not get_reqs.recordcount>
<cf_medium_list_search title="#getLang('training',137)#"></cf_medium_list_search>
    <cfform name="add_announce_req" method="post" action="#request.self#?fuseaction=training.emptypopup_add_class_join_request">
    <input type="hidden" name="announce_id" id="announce_id" value="<cfoutput>#attributes.announce_id#</cfoutput>">
    <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
    <input name="mail" id="mail" type="hidden" value="<cfif isdefined("attributes.mail") and len(attributes.mail)><cfoutput>#attributes.mail#</cfoutput></cfif>">
    <cf_medium_list>
        <thead>
            <tr>
                <th><cf_get_lang_main no='2115.Eğitimler'></th>
                <th style="text-align:right;"><cf_get_lang no='13.Kontenjan'></th>
                <th style="text-align:right;"><cf_get_lang_main no='1983.Katılımcı'></th>
                <th width="15"></th>
            </tr>
        </thead>
			<cfif get_class.recordcount>
				<cfoutput query="get_class">
                    <cfquery name="GET_EMP_ADD" datasource="#dsn#">
                        SELECT COUNT(EMP_ID) AS TOTAL_EMP,COUNT(CON_ID) AS TOTAL_PAR,COUNT(PAR_ID) AS TOTAL_CON FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #CLASS_ID# AND (EMP_ID IS NOT NULL OR PAR_ID IS NULL OR CON_ID IS NULL)
                    </cfquery>
                <cfset total = get_emp_add.total_emp + get_emp_add.total_par + get_emp_add.total_con>
        <tbody>
            <tr>
                <td>#CLASS_NAME# : <!--- #CLASS_ID# ---> (#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#)</td>
                <td align="right" style="text-align:right;">#MAX_PARTICIPATION#</td>
                <td align="right" style="text-align:right;">#total#</td>
                <td><input type="radio" name="class_id" id="class_id" value="#CLASS_ID#"></td>
            </tr>
				</cfoutput>
                <cfelse>
            <tr>
                 <td colspan="8"><cf_get_lang_main no='72.Kayit Yok'>!</td>
            </tr>
        </tbody>
        </cfif>
        <tfoot>
            <tr>
        	    <td colspan="4" style="text-align:right;"><cf_workcube_buttons type_format='1' is_upd='0'></td>
            </tr>
        </tfoot>
        </cf_medium_list>
	</cfform>
<cfelse>
<cf_medium_list_search title="#getLang('training',45)#"></cf_medium_list_search>
	<cfform name="add_announce_req" method="post" action="#request.self#?fuseaction=training.emptypopup_upd_class_join_request">
    <input type="hidden" name="announce_id" id="announce_id" value="<cfoutput>#attributes.announce_id#</cfoutput>">
		<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
		<input name="mail" id="mail" type="hidden" value="<cfif isdefined("attributes.mail") and len(attributes.mail)><cfoutput>#attributes.mail#</cfoutput></cfif>">
        <cf_medium_list>
        	<thead>
                <tr>
                    <th><cf_get_lang_main no='2115.Eğitimler'></th>
                    <th style="text-align:right;"><cf_get_lang no='13.Kontenjan'></th>
                    <th style="text-align:right;"><cf_get_lang_main no='1983.Katılımcı'></th>
                    <th width="15"></th>
                </tr>
            </thead>
            <tbody>
				<cfif get_class.recordcount>
                    <cfoutput query="get_class">
                        <cfquery name="GET_EMP_ADD" datasource="#dsn#">
                            SELECT COUNT(EMP_ID) AS TOTAL_EMP,COUNT(CON_ID) AS TOTAL_PAR,COUNT(PAR_ID) AS TOTAL_CON FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #CLASS_ID#
                        </cfquery>
                        <cfset total = get_emp_add.total_emp + get_emp_add.total_par + get_emp_add.total_con>
                        <tr>
                        <td>#CLASS_NAME# : #CLASS_ID# (#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#)</td>
                            <td style="text-align:right;">#MAX_PARTICIPATION#</td>
                            <td style="text-align:right;">#total#</td>
                            <td><input type="radio" name="class_id" id="class_id" value="#CLASS_ID#" <cfif get_reqs.class_id eq CLASS_ID>checked</cfif>></td>
                        </tr>
                    </cfoutput>
                 <cfelse>
                <tr>
                  <td colspan="8"><cf_get_lang_main no='72.Kayit Yok'>!</td>
                </tr>
              </cfif>
            </tbody>
            <tfoot>
                <tr>
                <td colspan="4"><cfif get_reqs.IS_VALID eq 1>Eğitime Katılımcı Olarak Seçildiniz!<cfelse><cf_workcube_buttons type_format='1' is_upd='1' is_delete='0'></cfif></td>
                </tr>
          </tfoot>
        </cf_medium_list>
	</cfform>
</cfif>
