<br/>
<cfsetting showdebugoutput="no">
<cfquery name="getTest" datasource="#dsn#">
	SELECT
		TCR.SUBJECT_ID,
		TC.CATEGORY_NAME,
		TS.SUBJECT,
		TCR.DETAIL,
		TCR.STATUS,
		TCR.RECORD_DATE,
		TCR.RECORD_EMP
	FROM 
		TEST_CHECK_ROW TCR,
		TEST_SUBJECT TS
		LEFT JOIN TEST_CAT TC ON TS.CATEGORY_ID=TC.ID
	WHERE
		TCR.SUBJECT_ID=TS.SUBJECT_ID AND
		TCR.CHECK_ID=#attributes.check_id#
	ORDER BY 
		TS.ORDER_NO
</cfquery>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
	<tr class="color-header" height="22"> 
	    <td  class="form-title" style="width:5px"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" style="width:50px"><cf_get_lang_main no='74.Kategori'></td>
		<td class="form-title" style="width:200px"><cf_get_lang_main no='1414.Test'>&nbsp;<cf_get_lang_main no='68.Konu'></td>
		<td class="form-title" style="width:10px"><cf_get_lang_main no='83.Evet'></td>
		<td class="form-title" style="width:10px"><cf_get_lang_main no='84.Hayır'></td>
		<td class="form-title" style="width:200px"><cf_get_lang_main no='217.Açıklama'></td>
	</tr>
	<cfif getTest.recordcount>
		<cfoutput query="getTest">
			<tr class="color-row">
				<td>#currentrow#</td>
				<td>#category_name#</td>
				<td>#subject#</td>
				<td><cfif status eq 1><img src="/images/enabled.gif"></cfif></td>
				<td><cfif status eq 0><img src="/images/icons_invalid.gif"></cfif></td>
				<td>#detail#</td>
			</tr>
		</cfoutput>
		<tr class="color-row">
			<td colspan="6"><cf_get_lang_main no='487.Kaydeden'>:<cfoutput>#get_emp_info(getTest.record_emp,0,0)#&nbsp; (#dateformat(getTest.record_date,'dd-mm-yyyy')#&nbsp;#TimeFormat(dateadd("h",session.ep.time_zone,getTest.record_date),timeformat_style)#)</cfoutput></td>
		</tr> 
	 </cfif>
</table>
