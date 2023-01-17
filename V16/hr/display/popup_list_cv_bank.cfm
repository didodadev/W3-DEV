<!--- Cv Bankasi FBS 20110429 --->
<!--- Ad Soyad, Sube, TC, Doğum Tarihi, Cinsiyet, Askerlik, Eğitim, Ehliyet, Psikoteknik, Akrabalık ilişkisi  --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.field_empapp_id" default="">
<cfparam name="attributes.field_name" default="">
<cfparam name="attributes.field_surname" default="">
<cfparam name="attributes.field_tc_identy_no" default="">
<cfparam name="attributes.field_birthdate" default="">
<cfparam name="attributes.field_sex" default="">
<cfparam name="attributes.field_military_status" default="">
<cfparam name="attributes.field_military_exempt_detail" default="">
<cfparam name="attributes.field_training_level" default="">
<cfparam name="attributes.field_driverlicence" default="">
<cfparam name="attributes.field_psychotechnics" default="">
<cfparam name="attributes.field_relative_status" default="">
<cfparam name="attributes.field_relative_detail" default="">
<cfparam name="attributes.field_functions" default="">
<cfquery name="get_employees_app" datasource="#dsn#">
	SELECT
		EA.EMPAPP_ID,
		EA.NAME,
		EA.SURNAME,
		EA.SEX,
		EA.MILITARY_STATUS,
		EA.MILITARY_EXEMPT_DETAIL,
		EA.TRAINING_LEVEL,
		EA.LICENCECAT_ID,
		EA.IS_PSICOTECHNIC,
		EA.RELATED_REF_NAME,
		EAI.TC_IDENTY_NO,
		EAI.BIRTH_DATE
	FROM
		EMPLOYEES_APP EA,
		EMPLOYEES_IDENTY EAI
	WHERE
		EA.EMPAPP_ID = EAI.EMPAPP_ID
		<cfif Len(attributes.keyword)>
			AND (
					<cfif isNumeric(attributes.keyword)>
						EAI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
					</cfif>
					NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
		</cfif>
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_employees_app.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.field_training_level") and Len(attributes.field_training_level)>
	<cfinclude template="../query/get_edu_level.cfm">
</cfif>
<cfif isDefined("attributes.field_training_level") and Len(attributes.field_training_level)>
	<cfinclude template="../query/get_driverlicence.cfm">
</cfif>
<script type="text/javascript">
function add_send_info(empapp_id,name,surname,tc_identy_no,birth_date,sex,military_status,military_exempt_detail,training_level,licencecat_id,is_psicotechnic,related_ref_name)
{
	<cfoutput>
	<cfif isDefined("attributes.field_empapp_id") and Len(attributes.field_empapp_id)>
		opener.#attributes.field_empapp_id#.value = empapp_id;
	</cfif>
	<cfif isDefined("attributes.field_name") and Len(attributes.field_name)>
		opener.#attributes.field_name#.value = name;
	</cfif>
	<cfif isDefined("attributes.field_surname") and Len(attributes.field_surname)>
		opener.#attributes.field_surname#.value = surname;
	</cfif>
	<cfif isDefined("attributes.field_tc_identy_no") and Len(attributes.field_tc_identy_no)>
		opener.#attributes.field_tc_identy_no#.value = tc_identy_no;
	</cfif>
	<cfif isDefined("attributes.field_birthdate") and Len(attributes.field_birthdate)>
		opener.#attributes.field_birthdate#.value = birth_date;
	</cfif>
	<cfif isDefined("attributes.field_sex") and Len(attributes.field_sex)>
		opener.#attributes.field_sex#.value = sex;
	</cfif>
	<cfif isDefined("attributes.field_military_status") and Len(attributes.field_military_status)>
		opener.#attributes.field_military_status#[military_status].checked = true;
	</cfif>
	<cfif isDefined("attributes.field_military_exempt_detail") and Len(attributes.field_military_exempt_detail)>
		opener.#attributes.field_military_exempt_detail#.value = military_exempt_detail;
	</cfif>
	<cfif isDefined("attributes.field_training_level") and Len(attributes.field_training_level)>
		<cfif get_edu_level.recordcount>
		<cfloop query="get_edu_level">
			if("#get_edu_level.edu_level_id#" == training_level)
				opener.#attributes.field_training_level#[#get_edu_level.currentrow#-1].checked = true;
		</cfloop>
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_driverlicence") and Len(attributes.field_driverlicence)>
		<cfif get_driverlicence.recordcount>
		<cfloop query="get_driverlicence">
			if("#get_driverlicence.licencecat_id#" == licencecat_id)
				opener.#attributes.field_driverlicence#[#get_driverlicence.currentrow#-1].checked = true;
		</cfloop>
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_psychotechnics") and Len(attributes.field_psychotechnics)>
		if(is_psicotechnic == 1)
			 opener.#attributes.field_psychotechnics#[0].checked = true;
		else
			opener.#attributes.field_psychotechnics#[1].checked = true;
	</cfif>
	<cfif isDefined("attributes.field_relative_status") and Len(attributes.field_relative_status)>
		if(related_ref_name != "")
		{
			opener.#attributes.field_relative_status#[0].checked = true;
			<cfif isDefined("attributes.field_functions") and Len(attributes.field_functions)>
				try{opener.#attributes.field_functions#;} catch(e){};
			</cfif>
			<cfif isDefined("attributes.field_relative_detail") and Len(attributes.field_relative_detail)>
				opener.#attributes.field_relative_detail#.value = related_ref_name;
			</cfif>
		}
		else
		{
			opener.#attributes.field_relative_status#[1].checked = true;
			<cfif isDefined("attributes.field_functions") and Len(attributes.field_functions)>
				try{opener.#attributes.field_functions#;} catch(e){};
			</cfif>
		}
	</cfif>
	</cfoutput>
	window.close();
}
</script>
<cfscript>
	url_string = '';
	if (isdefined('attributes.field_empapp_id')) url_string = '#url_string#&field_empapp_id=#attributes.field_empapp_id#';
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#attributes.field_name#';
	if (isdefined('attributes.field_surname')) url_string = '#url_string#&field_surname=#attributes.field_surname#';
	if (isdefined('attributes.field_tc_identy_no')) url_string = '#url_string#&field_tc_identy_no=#attributes.field_tc_identy_no#';
	if (isdefined('attributes.field_birthdate')) url_string = '#url_string#&field_birthdate=#attributes.field_birthdate#';
	if (isdefined('attributes.field_sex')) url_string = '#url_string#&field_sex=#attributes.field_sex#';
	if (isdefined('attributes.field_military_status')) url_string = '#url_string#&field_military_status=#attributes.field_military_status#';
	if (isdefined('attributes.field_military_exempt_detail')) url_string = '#url_string#&field_military_exempt_detail=#attributes.field_military_exempt_detail#';
	if (isdefined('attributes.field_training_level')) url_string = '#url_string#&field_training_level=#attributes.field_training_level#';
	if (isdefined('attributes.field_driverlicence')) url_string = '#url_string#&field_driverlicence=#attributes.field_driverlicence#';
	if (isdefined('attributes.field_psychotechnics')) url_string = '#url_string#&field_psychotechnics=#attributes.field_psychotechnics#';
	if (isdefined('attributes.field_relative_status')) url_string = '#url_string#&field_relative_status=#attributes.field_relative_status#';
	if (isdefined('attributes.field_relative_detail')) url_string = '#url_string#&field_relative_detail=#attributes.field_relative_detail#';
	if (isdefined('attributes.field_functions')) url_string = '#url_string#&field_functions=#attributes.field_functions#';
</cfscript>
	<table class="harfler">
		<tr>
			<td>
				<cfoutput>
					<td>&nbsp;</td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=A">A</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=B">B</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=C">C</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Ç">Ç</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=D">D</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=E">E</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=F">F</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=G">G</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Ğ">Ğ</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=H">H</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=I">I</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=İ">İ</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=J">J</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=K">K</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=L">L</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=M">M</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=N">N</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=O">O</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Ö">Ö</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=P">P</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Q">Q</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=R">R</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=S">S</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Ş">Ş</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=T">T</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=U">U</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Ü">Ü</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=V">V</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=W">W</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Y">Y</a></td>
					<td><A href="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#&keyword=Z">Z</a></td>
					<td>&nbsp;</td>
				</cfoutput>
			</td>
		</tr>
	</table>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56039.CV Bank"></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<cfform name="search" action="#request.self#?fuseaction=hr.popup_list_cv_bank#url_string#" method="post">
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='57460.Filtre'></td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:120px;" maxlength="50"></td>
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='55757.Adi Soyadi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_employees_app.recordcount>
			<cfoutput query="get_employees_app" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="javascript://" onClick="add_send_info('#empapp_id#','#name#','#surname#','#tc_identy_no#','#DateFormat(birth_date,dateformat_style)#','#sex#','#military_status#','#military_exempt_detail#','#training_level#','#licencecat_id#','#is_psicotechnic#','#related_ref_name#');" class="tableyazi">#name# #surname#</a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfscript>
if (isdefined('attributes.keyword') and len(attributes.keyword)) url_string = '#url_string#&keyword=#attributes.keyword#';
</cfscript>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td><cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="hr.popup_list_cv_bank#url_string#">
		</td>
		<!-- sil -->
		<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		<!-- sil -->
	</tr>
</table>
</cfif>
<br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
