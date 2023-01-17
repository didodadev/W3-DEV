<!--- anket tipinde oluşturulan formlar bu listeye gelir--->
<cfscript>
	get_survey_ = createObject("component", "myhome.cfc.get_survey_main");
	get_survey_.dsn = dsn;
	get_survey_.dsn_alias = dsn_alias;
	get_survey_form = get_survey_.survey_records
	(
		survey_type : 14,//anket formu tipi
		keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
		is_show_myhome : 1, //gündemde gösterilsin
		result_control :1, // çalışan sadece formu 1 kere dolduracak ise bu kontrol eklenmeli
		action_type_id : session.ep.userid // result_control 1 ise bu parametrede gonderilmeli kontrol icin
	);
</cfscript>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_survey_form.recordcount#'>
<cfform name="search" method="post" action="#request.self#?fuseaction=myhome.list_employee_survey_form">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57947.Anketler'></cfsavecontent>
<cf_big_list_search title="#message#">
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td>
                	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                        <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                    <cfelse>
                        <cfinput type="text" name="keyword" style="width:100px;" value="" maxlength="50">
                	</cfif>
                </td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list> 
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='29764.Form'></th>
			<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			<th class="header_icn_none"></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_survey_form.recordcount>
			<cfoutput query="get_survey_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#SURVEY_MAIN_HEAD#</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td style="text-align:center"> 
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#survey_main_id#&action_type=#type#&action_type_id=#session.ep.userid#&is_popup=1','wide');" class="tableyazi"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>" border="0" align="absmiddle"></a>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_str = "">
<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%" align="center">
		<tr>
			<td><cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="myhome.list_employee_survey_form#url_str#"> </td>
			<td style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>