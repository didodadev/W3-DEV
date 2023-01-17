<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Barbaros KUZ 20070713
Description :
	Proje secilen yerlerde input alanina girilen ifade ile baslayan proje adlarini bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	project_id 		--	required
	project_name	-- 	required
	max_rows 		-- 	not required
	min_char 		-- 	not required
	is_multi_no		-- 	not required
	
	project_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	Ayrıca project_name ifadesinin uzunlugu yoksa project_id ifadesi de bosaltilir.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	<cf_wrk_projects form_name = 'search_project' project_name='project_name' project_id='project_id'>
	<input type="hidden" name="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
	<input type="text" name="project_name" value="<cfoutput>#attributes.project_name#</cfoutput>" onKeyUp="get_project_1();" style="width:140px;">
	Bir formda ikinci kez kullanilirsa (is_multi_no parametresi tanimlanmali)
	<cf_wrk_projects form_name='add_cari_to_cari' project_id='project_id_2' project_name='project_name_2' is_multi_no='2'>
	<input type="hidden" name="project_id_2" value="">						
	<input type="text" name="project_name_2" value="" style="width:175px;" onkeyup="get_project_2();">
	
Revisions :
	Barbaros KUZ 20070718
	Barbaros KUZ 20080123	
--->
<cfparam name="attributes.is_multi_no" default='1'>
<cfparam name="caller.attributes.max_rows" default="20">
<cfparam name="caller.attributes.min_char" default="3">

<script type="text/javascript">
function get_project_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	var max_rows = <cfoutput>#caller.attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#caller.attributes.min_char#</cfoutput>;
	var project_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.project_name#.style.width</cfoutput>);
	project_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = project_div_genislik;
	var project_max_length = wrk_round((project_div_genislik*0.14),0);

	if(<cfoutput>#attributes.form_name#.#attributes.project_name#</cfoutput>.value.length >= min_char)
	{
		var get_project_workdata = workdata('get_project',<cfoutput>#attributes.form_name#.#attributes.project_name#</cfoutput>.value,max_rows);
		var total_project = max_rows;		
		var total_project_name = '';
		if(get_project_workdata.recordcount)
		{
			eval("project_div_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
			if(get_project_workdata.recordcount < total_project)
				total_project = get_project_workdata.recordcount;
			for(i=0;i<total_project;i++)
			{
				var baslik = get_project_workdata.PROJECT_HEAD[i];
				var baslik = baslik.substr(0,project_max_length);
				var project_name1 = '<a href="javascript://" onClick="add_project_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_project_workdata.PROJECT_ID[i]+','+'\''+get_project_workdata.PROJECT_HEAD[i]+'\');">'+baslik+'</a><br />';
				total_project_name = total_project_name + project_name1;
			}
			project_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_project_name;
		}
		else
			div_close_project_<cfoutput>#attributes.is_multi_no#</cfoutput>();
	}
	else
	{
		div_close_project_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		if(<cfoutput>#attributes.form_name#.#attributes.project_name#</cfoutput>.value.length == 0)
			<cfoutput>#attributes.form_name#.#attributes.project_id#</cfoutput>.value = '';
	}
}

function add_project_<cfoutput>#attributes.is_multi_no#</cfoutput>(project_id,project_name)
{
	<cfoutput>#attributes.form_name#.#attributes.project_id#</cfoutput>.value = project_id;
	<cfoutput>#attributes.form_name#.#attributes.project_name#</cfoutput>.value = project_name;
	div_close_project_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}
function div_close_project_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	project_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.display = 'none';
	project_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = '';
}
</script>

<div id="project_div_<cfoutput>#attributes.is_multi_no#</cfoutput>" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="project_td_<cfoutput>#attributes.is_multi_no#</cfoutput>">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
