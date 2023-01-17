<!--- <cfinclude template="../query/get_unique_traning_join_requests.cfm"> --->
<cfinclude template="../query/get_training_sec_names.cfm">
<cfquery name="get_class" datasource="#dsn#">
	SELECT 
		TC.*
	FROM
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID = #get_trainin_join_request.CLASS_ID#
</cfquery>

<cfquery name="get_section_name" datasource="#dsn#">
	SELECT
		SECTION_NAME 
	FROM
		TRAINING_SEC
	WHERE
		TRAINING_SEC_ID = <cfif get_class.TRAINING_SEC_ID neq "">#get_class.TRAINING_SEC_ID#<cfelse>0</cfif>
</cfquery>
<cfquery name="get_responsible" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = <cfif get_class.CLASS_RESPONSIBLE neq "">#get_class.CLASS_RESPONSIBLE#<cfelse>0</cfif>
</cfquery>
<table>
    <tr>
        <td width="150" class="txtbold"><cf_get_lang_main no='74.kategori'> / <cf_get_lang_main no='583.Bölüm'> </td>
        <td width="337">: <cfoutput>#get_section_name.SECTION_NAME#</cfoutput></TD>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang_main no='7.Eğitim'></td>
        <td>:
			<cfoutput>#get_class.CLASS_NAME#</cfoutput>
        </td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='107.Eğitim İçeriği'></td>
        <td>: <cfoutput>#get_class.CLASS_OBJECTIVE#</cfoutput></td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='94.Eğitim Tarihi'></td>
        <td>:
			<cfoutput>
				<cfif LEN(get_class.start_date) AND get_class.start_date GT '1/1/1900' and LEN(get_class.finish_date) AND get_class.finish_date GT '1/1/1900'>
					<cfif dateformat(get_class.start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(get_class.finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
						<cfset startdate = date_add('h', session.ep.time_zone, get_class.start_date)>
                        <cfset finishdate = date_add('h', session.ep.time_zone, get_class.finish_date)>
                        #dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#) 
                    <cfelseif LEN(get_class.MONTH_ID)>
                        #ListGetAt(my_month_list,get_class.MONTH_ID)# - #SESSION.EP.PERIOD_YEAR#
                    </cfif>
            </cfoutput>
        </td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='84.Eğitim Yeri'></td>
        <td>: <cfoutput>#get_class.CLASS_PLACE#</cfoutput></td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='7.Amaç'></td>
        <td>: <cfoutput>#get_class.CLASS_TARGET#</cfoutput></td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='178.Eğitim Yeri Adresi'></td>
        <td>: <cfoutput> #get_class.CLASS_PLACE_ADDRESS# </cfoutput> </td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='179.Eğitim Yeri Telefonu'></td>
        <td>: <cfoutput> #get_class.CLASS_PLACE_TEL# </cfoutput> </td>
    </tr>
    <tr>
        <td class="txtbold"><cf_get_lang no ='180.Eğitim Yeri Sorumlusu'></td>
        <td>: <cfoutput>#get_responsible.employee_name#&nbsp;#get_responsible.employee_surname#</cfoutput> </td>
    </tr>
</table>
