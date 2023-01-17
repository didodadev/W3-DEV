<cfparam name="attributes.chart_type" default="pie">
 <cfquery name="get_trainings" datasource="#DSN#">
	SELECT
		AVG(FINALTEST_POINT) AS AVG_FINAL,
		AVG(PRETEST_POINT) AS AVG_PRE
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
</cfquery> 
<cfif LEN(get_trainings.AVG_FINAL)>
	<cfset final_= get_trainings.AVG_FINAL>
<cfelse>
	<cfset final_= 0>
</cfif>
<cfif LEN(get_trainings.AVG_PRE)>
	<cfset on_test= get_trainings.AVG_PRE>
<cfelse>
	<cfset on_test= 0>
</cfif>
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td></tr>--->
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
 <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
  <cfelse>
  <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='309.On Test Son Test Sonuçları'></font></td>
  </tr>
  </cfif>
 
</table>
<table>
	<tr>
		<td bgcolor="FFFFFF">
		<CFCHART show3d="yes" showlegend="yes" font="ARIAL" format="jpg">
			<CFCHARTSERIES type="#attributes.chart_type#" paintstyle="light">
				<CFCHARTDATA item="#getLang('hr',884)#" value="#on_test#">
				<CFCHARTDATA item="#getLang('training_management',176)#" value="#final_#">
			</CFCHARTSERIES>
		</CFCHART>
		</td>
	</tr>
</table>
		</td>
	</tr>
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td></tr>--->
</table>
