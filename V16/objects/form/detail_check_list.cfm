<br/>
<cfsetting showdebugoutput="no">
<cfquery name="getTest" datasource="#dsn#">
	SELECT
		TCR.SUBJECT_ID,
		TC.CATEGORY_NAME,
		TS.SUBJECT,
		TCR.DETAIL,
		TCR.STATUS,
		TCM.RECORD_DATE,
		TCM.RECORD_EMP
	FROM 
		TEST_CHECK_ROW TCR
		LEFT JOIN TEST_CHECK_MAIN TCM ON TCR.CHECK_ID=TCM.CHECK_ID,
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
	    <td  class="form-title" style="width:5px"><cf_get_lang dictionary_id='57487.No'></td>
		<td class="form-title" style="width:130px"><cf_get_lang dictionary_id='57486.Kategori'></td>
		<td class="form-title" style="width:200px"><cf_get_lang dictionary_id='58826.Test'>&nbsp;<cf_get_lang dictionary_id='57480.Konu'></td>
		<td class="form-title" style="width:10px"><cf_get_lang dictionary_id='57495.Evet'></td>
		<td class="form-title" style="width:10px"><cf_get_lang dictionary_id='57496.Hayır'></td>
		<td class="form-title" style="width:100px"><cf_get_lang dictionary_id='57629.Açıklama'></td>
	</tr>
	<cfif getTest.recordcount>
		<cfoutput query="getTest">
			<tr class="color-row">
				<td>#currentrow#</td>
				<td nowrap="nowrap">#category_name#</td>
				<td>#subject#</td>
				<td><cfif status eq 1><img src="/images/enabled.gif"></cfif></td>
				<td><cfif status eq 0><img src="/images/icons_invalid.gif"></cfif></td>
				<td>#detail#</td>
			</tr>
		</cfoutput>
		<tr class="color-row">
			<td colspan="6"><cf_get_lang dictionary_id='57899.Kaydeden'>:<cfoutput>#get_emp_info(getTest.record_emp,0,0)#&nbsp; (#dateformat(getTest.record_date,'dd-mm-yyyy')#&nbsp;#TimeFormat(dateadd("h",session.ep.time_zone,getTest.record_date),timeformat_style)#)</cfoutput></td>
		</tr> 
	 </cfif>
</table>
