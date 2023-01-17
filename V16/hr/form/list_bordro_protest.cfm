<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Subat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayis'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Agustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasim'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralik'></cfsavecontent>
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
<cfform name="list_bordro_protests" method="post" action="#request.self#?fuseaction=myhome.popup_list_bordro_protests" >
<input name="form_varmi" id="form_varmi" value="1" type="hidden">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
		<td height="35" class="headbold"><cf_get_lang dictionary_id='53627.Itirazlar'></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
  <cfoutput query="GET_PROTESTS">
  <cfset ay=ListGetAt(ay_list(),#GET_PROTESTS.SAL_MON#,',')>
  <tr class="color-header" height="22">
	<td class="form-title">#GET_PROTESTS.SAL_YEAR# - #ay# (<cf_get_lang dictionary_id="40998.Bordro Itiraz Tarihi"> : #dateformat(GET_PROTESTS.PROTEST_DATE,dateformat_style)#)</td>
  </tr>
	<tr height="20" class="color-row">
		<td>
		#GET_PROTESTS.PROTEST_DETAIL#
		<cfif len(answer_date)>
		<br/><br/>
		<span class="txtbold">
			<cf_get_lang dictionary_id ='31781.Cevap Tarihi'> : #dateformat(answer_date,dateformat_style)# &nbsp;&nbsp;
			<cf_get_lang dictionary_id ='31782.Cevaplayan'> : #get_emp_info(ANSWER_EMP_ID,0,1)# <br/><br/>
			#answer_detail#
		</span>
		
		</cfif>
		</td>
	</tr>
  </cfoutput>
</table>	
</cfform>

