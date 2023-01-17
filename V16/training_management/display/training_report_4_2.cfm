
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
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
<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
	<tr class="formbold" height="25">
	<td width="75">Eğitim</td>
	<td><cf_get_lang_main no='164.Çalışan'></td>
	<td width="75"><cf_get_lang no='310.İlk Sınav'></td>
	<td width="75"><cf_get_lang no='311.Final Sınavı'></td>
	<td width="50"><cf_get_lang_main no='1171.Fark'></td>
	</tr>
  
   <cfloop list="#attributes.class_id_list#" index="i">
	  <cfset attributes.class_id= i>
	  <cfinclude template="../query/get_report_queries.cfm">
	  <cfinclude template="../query/get_upd_class_queries.cfm">
	  <cfquery name="get_trainings" datasource="#DSN#">
	   SELECT
	    '#get_class.class_name#' AS CLASS_NAME,
		FINALTEST_POINT,
		PRETEST_POINT,
		FINALTEST_POINT-PRETEST_POINT AS FARK,
		EMP_ID
	   FROM
		TRAINING_CLASS_RESULTS
	   WHERE
		 CLASS_ID=#attributes.CLASS_ID#
      </cfquery> 
	<cfif get_trainings.recordcount>
	<cfoutput query="get_trainings">
		<tr height="20">
		    <td>&nbsp;#CLASS_NAME#</td>
			<td>#GET_EMP_INFO(EMP_ID,0,0)#</td>
			<td align="center">#PRETEST_POINT#</td>
			<td align="center">#FINALTEST_POINT#</td>
			<td align="center">#FARK#</td>
		</tr>
	</cfoutput>
	</cfif>
  </cfloop>
</table>
</td>
</tr>
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
