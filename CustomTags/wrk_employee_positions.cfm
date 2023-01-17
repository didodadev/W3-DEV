<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Abdüsselam KARATAŞ 20061130
Description :
	Calisan - Pozisyon secilen yerlerde input alanina girilen ifade ile baslayan Calisan - Pozisyon ları bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	emp_name		-- 	required
	emp_id 			--	not required	
	pos_code		-- 	not required
	max_rows 		-- 	not required
	min_char 		-- 	not required
	is_multi_no		-- 	not required	
	
	Ayrıca emp_name ifadesinin uzunlugu yoksa emp_id veya pos_code ifadesi de bosaltilir.	
	employee_max_length	ifadesi div'in icine dolan ifadenin uzunlugunun kontrol eder.
Syntax :
	Bir formda sadece bir kez kullanilirsa
	<cf_wrk_employee_positions form_name='add_work' pos_code='project_emp_id' emp_name='responsable_name'>
	<cfinput type="text" name="responsable_name" value="" required="yes" message="#message1#" onKeyUp="get_emp_pos_1();" style="width:200px;">
	Bir formda ikinci kez kullanilirsa (is_multi_no parametresi tanimlanmali)
	<cf_wrk_employee_positions form_name='add_work' emp_id='cc_emp_id' emp_name='cc_name' is_multi_no='2'>
	<cfinput type="text" name="cc_name" value="" onKeyUp="get_emp_pos_2();" style="width:200px;">	
	
Revisions :
--->
<cfparam name="attributes.is_multi_no" default='1'>
<cfparam name="attributes.max_rows" default='20'>
<cfparam name="attributes.min_char" default='3'>

<script type="text/javascript">
function get_emp_pos_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	var max_rows = <cfoutput>#attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#attributes.min_char#</cfoutput>;

	var employee_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.emp_name#.style.width</cfoutput>);
	emp_pos_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = employee_div_genislik;
	var employee_max_length = wrk_round((employee_div_genislik*0.14),0);
	
	if(<cfoutput>#attributes.form_name#.#attributes.emp_name#</cfoutput>.value.length >= min_char)
	{
		var get_emp_pos = workdata('get_emp_pos',<cfoutput>#attributes.form_name#.#attributes.emp_name#</cfoutput>.value,max_rows);
		var total_emp_pos_no = max_rows;
		var total_emp_posname = '';
		if(get_emp_pos.recordcount)
		{
			eval("emp_pos_div_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
			if(get_emp_pos.recordcount < total_emp_pos_no)
				total_emp_pos_no = get_emp_pos.recordcount;
			for(i=0;i<total_emp_pos_no;i++)
			{
				var baslik = get_emp_pos.FULLNAME[i];
			
				var IS_MASTER_ = get_emp_pos.IS_MASTER[i]; 
				if(IS_MASTER_=='0')
					var baslik = baslik.substr(0,employee_max_length-5)+' (Ek)';
				else
					var baslik = baslik.substr(0,employee_max_length);

				var emp_posname = '<a href="javascript://" onClick="javascript:add_emp_pos_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_emp_pos.EMPLOYEE_ID[i]+','+'\''+get_emp_pos.FULLNAME[i]+'\','+get_emp_pos.POSITION_CODE[i]+');">'+baslik+'</a><br />';<!--- +get_emp_pos.FULLNAME[i]+' --->
				total_emp_posname = total_emp_posname + emp_posname;
			}
			emp_pos_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_emp_posname;
		}
		else
			div_close_emp_<cfoutput>#attributes.is_multi_no#</cfoutput>();
	}
	else
	{
		div_close_emp_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		if(<cfoutput>#attributes.form_name#.#attributes.emp_name#</cfoutput>.value.length == 0)
		{
			<cfif isdefined("attributes.emp_id")>
				<cfoutput>#attributes.form_name#.#attributes.emp_id#</cfoutput>.value = '';
			<cfelse>
				<cfoutput>#attributes.form_name#.#attributes.pos_code#</cfoutput>.value = '';
			</cfif>
		}
	}
}

function add_emp_pos_<cfoutput>#attributes.is_multi_no#</cfoutput> (emp_id,emp_name,pos_code)
{
	<cfoutput>#attributes.form_name#.#attributes.emp_name#</cfoutput>.value = emp_name;
	<cfif isdefined("attributes.emp_id")>
		<cfoutput>#attributes.form_name#.#attributes.emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.pos_code")>
		<cfoutput>#attributes.form_name#.#attributes.pos_code#</cfoutput>.value = pos_code;
	</cfif>
	div_close_emp_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}

function div_close_emp_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	emp_pos_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.display = 'none';
	emp_pos_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = '';
}
</script>

<div id="emp_pos_div_<cfoutput>#attributes.is_multi_no#</cfoutput>" style="position:absolute;display:none;z-index:9999; margin: -16px 0px 0px 42px;"><br />
	
			<div id="emp_pos_td_<cfoutput>#attributes.is_multi_no#</cfoutput>"></div>

</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
