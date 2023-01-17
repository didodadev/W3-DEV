<cfquery name="GET_PROTESTS" datasource="#DSN#">
	SELECT
	    *
	FROM
		EMPLOYEES_PUANTAJ_PROTESTS
	WHERE
		SAL_MON=#attributes.sal_mon# 
		AND SAL_YEAR=#attributes.sal_year#  
		AND EMPLOYEE_ID=#session.ep.userid# 
	ORDER BY PROTEST_ID DESC
</cfquery>
<cfif isdefined("attributes.form_varmi")>
<cfset get_protests.recordcount=0>
</cfif>
<input name="form_varmi" id="form_varmi" value="1" type="hidden">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31438.İtirazlar'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="list_bordro_protests" method="post" action="#request.self#?fuseaction=myhome.popup_list_bordro_protests" >
	<cf_medium_list>
	<thead>
		<cfoutput query="GET_PROTESTS">
			<cfset ay=ListGetAt(ay_list(),#GET_PROTESTS.SAL_MON#,',')>  
		</cfoutput>
		<tr>
			<th><cfoutput>#GET_PROTESTS.SAL_YEAR# - #ay# <cf_get_lang dictionary_id='55712.Bordro'> (<cf_get_lang dictionary_id ='31440.İtiraz Tarihi'> : #dateformat(GET_PROTESTS.PROTEST_DATE,dateformat_style)#)</cfoutput></th>
		</tr>
	</thead>
	<tbody>
		<tr height="20">
			<td>
			<cfoutput>
				#GET_PROTESTS.PROTEST_DETAIL#
				<cfif isdefined("GET_PROTESTS.answer_date") and len(GET_PROTESTS.answer_date)>
				<br/><br/>
				<span class="txtbold">
					<cf_get_lang dictionary_id ='31781.Cevap Tarihi'> : #dateformat(GET_PROTESTS.answer_date,dateformat_style)# &nbsp;&nbsp;
					<cf_get_lang dictionary_id ='31782.Cevaplayan'> : #get_emp_info(GET_PROTESTS.ANSWER_EMP_ID,0,0)# <br/><br/>
					#GET_PROTESTS.answer_detail#
				</span>
				</cfif>
			</cfoutput>
			</td>
		</tr>
	</tbody>
</cf_medium_list>
</cfform>
</cf_popup_box>
