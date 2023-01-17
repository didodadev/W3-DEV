<br/>
<cfsetting showdebugoutput="no">
<!--- get_fuseactions query degeri en disda calisiyor SP olarak 20120801 --->
<cfquery name="getTest" datasource="#dsn#">
	SELECT
		TS.SUBJECT_ID, 
		TC.CATEGORY_NAME,
		TS.SUBJECT,
		TS.DETAIL,
		TS.TYPE,
		TS.SUBJECT
	FROM 
		TEST_SUBJECT TS
		LEFT JOIN TEST_CAT TC ON TS.CATEGORY_ID=TC.ID
	WHERE
		(
		<cfif len(get_fuseactions.is_update) and get_fuseactions.is_update eq 1>
			TYPE  LIKE '%11%' OR	<!---Type:Update için 11 --->
		</cfif>
		<cfif len(get_fuseactions.type) and get_fuseactions.type  eq 4>
			TYPE LIKE '%40%' OR		<!---Type:listeleme için 40---->
		</cfif>
		TYPE IS NULL
		) AND 
		TS.IS_ACTIVE=1
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
	<cfform name="save_check" id="save_check" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_check_list">
		<cfif getTest.recordcount>
			<cfif isdefined("attributes.work_id")>
				<input type="hidden" name="work_id" id="work_id" value="<cfoutput>#attributes.work_id#</cfoutput>">
			<cfelse>
				<input type="hidden" name="modul_short_name" id="modul_short_name" value="<cfoutput>#attributes.modul_short_name#</cfoutput>">
				<input type="hidden" name="faction" id="faction" value="<cfoutput>#attributes.faction#</cfoutput>" >
			</cfif>
			<input type="hidden" name="row" id="row" value="<cfoutput>#getTest.recordcount#</cfoutput>">
			<input type="hidden" name="is_yes" id="is_yes" value="1">
			<cfoutput query="getTest">
				<tr class="color-row">
					<td>#currentrow#</td>
					<td nowrap="nowrap">
						<input type="hidden" name="subject_id_#currentrow#" id="subject_id_#currentrow#" value="#subject_id#">
						#category_name#
					</td>
					<td title="#detail#">
						#subject#
					</td>
					<td><input type="checkbox" id="chk_yes_#currentrow#" name="chk_yes_#currentrow#" title="#detail#" value="" onClick="changeCheck(#currentrow#,1)"></td>
					<td><input type="checkbox" id="chk_no_#currentrow#" name="chk_no_#currentrow#" title="#detail#" value="" onClick="changeCheck(#currentrow#,2)"></td>
					<td><input type="text" style="width:100%;" id="detail_#currentrow#" name="detail_#currentrow#" class="boxtext" title="#detail#"  value="" onClick="changeCheck(#currentrow#,2)"></td>
				</tr>
			</cfoutput>
			<tr>
				<td colspan="6" class="color-row" style="text-align:right; vertical-align:middle;">
					<cf_workcube_buttons is_upd='0' add_function='control()'>
				</td>
			</tr>
		<cfelse>
			<tr class="color-row">
				<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</cfform>
</table>
<script type="text/javascript">
	function changeCheck(row,type)
	{
		if(type==1)
		{
			if(document.getElementById('chk_yes_'+row).checked==true)
			{
				document.getElementById('chk_no_'+row).checked=false;
				document.getElementById('chk_yes_'+row).value=1;
			}
		}
		else if(type==2)
		{
			if(document.getElementById('chk_no_'+row).checked==true)
			{
				document.getElementById('chk_yes_'+row).checked=false;
				document.getElementById('chk_no_'+row).value=0;
			}
		}
	}
	function control()
	{
		for(i=1;i<=document.getElementById('row').value;i++)
		{
			if(document.getElementById('chk_no_'+i).checked==true)
			{
				document.getElementById('is_yes').value=0;
			}
			if(document.getElementById('chk_no_'+i).checked==false && document.getElementById('chk_yes_'+i).checked==false)
			{
				alert(i+".<cf_get_lang dictionary_id='58508.Satır'> <cf_get_lang dictionary_id='57495.Evet'>/<cf_get_lang dictionary_id='57496.Hayır'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
				return false;
			}
			else if(document.getElementById('chk_no_'+i).checked==true && document.getElementById('detail_'+i).value=='')
			{
				alert(i+".<cf_get_lang dictionary_id='58508.Satır'><cf_get_lang dictionary_id='32488.Açıklama Giriniz'>!");
				return false;
			}
			else if(document.getElementById('chk_no_'+i).checked==true && document.getElementById('detail_'+i).value.length!=0 && document.getElementById('detail_'+i).value.length<10)
			{
				alert(i+".<cf_get_lang dictionary_id='58508.Satır'> <cf_get_lang dictionary_id='57629.Açıklama'> <cf_get_lang dictionary_id='32490.En az 10 karakter'>!");
				return false;
			}
		}
		return true;
	}
</script>
