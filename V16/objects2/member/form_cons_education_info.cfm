<cfquery name="GET_UNV" datasource="#DSN#">
	SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME ASC
</cfquery>
<cfquery name="GET_CONS_EDUCATION" datasource="#DSN#">
	SELECT TOP 1 * FROM CONSUMER_EDUCATION_INFO WHERE 
	<cfif isdefined("attributes.cid")>
		CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	<cfelse>
		CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfif>
</cfquery>
<table style="width:100%">
	<tr>
		<td></td>
		<td class="txtboldblue"><cf_get_lang no='520.Okul Adı'></td>
		<td class="txtboldblue"><cf_get_lang_main no='142.Giriş'></td>
		<td class="txtboldblue"><cf_get_lang no='521.Mezuniyet'></td>
		<td class="txtboldblue">&nbsp;</td>
	</tr>
	<tr>
		<td width="200"><cf_get_lang no='522.İlköğretim'></td>
		<td><input type="text" name="edu1" id="edu1" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu1#</cfoutput>"></td>
		<td width="150"><input type="text" name="edu1_start" id="edu1_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu1_start#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td><input type="text" name="edu1_finish" id="edu1_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu1_start#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><cf_get_lang no='523.Ortaokul'></td>
		<td><input type="text" name="edu2" id="edu2" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu2#</cfoutput>"></td>
		<td><input type="text" name="edu2_start" id="edu2_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu2_start#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td><input type="text" name="edu2_finish" id="edu2_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu2_finish#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><cf_get_lang no='524.Lise'></td>
		<td><input type="text" name="edu3" id="edu3" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu3#</cfoutput>"></td>
		<td><input type="text" name="edu3_start" id="edu3_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu3_start#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td>
			<input type="text" name="edu3_finish" id="edu3_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu3_finish#</cfoutput>"onkeyup="isNumber(this);" onBlur="isNumber(this)">
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1958.Üniversite'></td>
		<td><select name="edu4_id" id="edu4_id" style="width:190px;">
				<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				<cfoutput query="get_unv">
					<option value="#get_unv.school_id#" <cfif get_unv.school_id eq get_cons_education.edu4_id >selected="selected"</cfif>>#get_unv.school_name#</option>	
				</cfoutput>
			</select>
		</td>
		<td><input type="text" name="edu4_start" id="edu4_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu4_start#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td><input type="text" name="edu4_finish" id="edu4_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu4_finish#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td>&nbsp;</td>
	</tr>	
	<tr>
		<td><cf_get_lang no='526.Yüksek Lisans'></td>
		<td><input type="text" name="edu5" id="edu5" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu5#</cfoutput>"></td>
		<td><input type="text" name="edu5_start" id="edu5_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu5_start#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td><input type="text" name="edu5_finish" id="edu5_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu5_finish#</cfoutput>" onkeyup="isNumber(this);" onBlur="isNumber(this)"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><cf_get_lang no='527.Diğer Üniversite'></td>
		<td><input type="text" name="edu4" id="edu4" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu4#</cfoutput>">
		</td>
	</tr>
</table>
<!--- <script type="text/javascript">
	function pasif_yap(form_name,form_name2)
	{
		eval("document.upd_consumer."+form_name).value = "";
		if(eval("document.upd_consumer."+form_name2).checked==true)
		{
			eval("document.upd_consumer."+form_name).readOnly=true;
		}
		else
		{
			eval("document.upd_consumer."+form_name).readOnly=false;
		}
	}
</script> --->

