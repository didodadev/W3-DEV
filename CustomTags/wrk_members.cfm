<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Barbaros KUZ 20070713
Description :
	Cari secilen yerlerde input alanina girilen ifade ile baslayan cari adlarini bulur 
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	member_name		-- 	required
	employee_id		--	not required
	consumer_id		--	not required
	company_id		--	not required
	select_list		-- 	required 
	max_rows 		-- 	not required
	min_char 		-- 	not required
	member_type		-- 	not required 
	
	member_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.,
	member_type ilgili forumdaki member_type alanina partner veya consumer seklinde deger dusurur.
	Ayrıca member_name ifadesinin uzunlugu yoksa consumer_id ve company_id ifadesi de bosaltilir.
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
	Select_list parametresine gore kurumsal(2),bireysel(3),calisanlar(1) ekrana gelir. Parantez icindeki parametreler ile kullanilabilir.
	long_member_name kısa ad ve uzun ad ifadelerinin görüntülenmesini saglar. default olarak 0 set edilmiştir. Uzun ad kullanılackasa ornek kullanim altta.
	calisanlar icin employee_id alani eklendi, company_id ve consumer_id gibi kullanilir select_list =1 dir. FB 2008201
	
Syntax :
	<cf_wrk_members form_name='list_invoice' member_name='company' consumer_id='consumer_id' company_id='company_id' select_list='2,3'>
	<input type="hidden" name="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>">
	<input type="text" name="member_name" value="<cfoutput>#attributes.member_name#</cfoutput>" onKeyUp="get_member();" style="width:140px;">
	member_type parametresi kullanilirsa
	<cf_wrk_members form_name='order_form' member_name='member_name' consumer_id='consumer_id' company_id='company_id' member_type='member_type' select_list='2,3'>
	long_member_name parametresi kullanilirsa
	<cf_wrk_members form_name='form' member_name='company' consumer_id='consumer_id' company_id='company_id' select_list='2,3' long_member_name='1'>
	
Revisions :
	Filiz BALCI 20080201
	Barbaros KUZ 20070718
	Barbaros KUZ 20070807
--->
<cfparam name="attributes.is_multi_no" default=''>
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.min_char" default="3">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.long_member_name" default="0">

<script type="text/javascript">
function get_member<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	var max_rows = <cfoutput>#attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#attributes.min_char#</cfoutput>;
	
	var member_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.member_name#.style.width</cfoutput>);
	member_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = member_div_genislik;
	var member_max_length = wrk_round((member_div_genislik*0.14),0);
	var long_member_name = <cfoutput>#attributes.long_member_name#</cfoutput>;

	if(<cfoutput>#attributes.form_name#.#attributes.member_name#</cfoutput>.value.length >= min_char)
	{
		var get_member = workdata('get_member',<cfoutput>#attributes.form_name#.#attributes.member_name#</cfoutput>.value,max_rows,'<cfoutput>#attributes.select_list#</cfoutput>');
		var total_member = max_rows;		
		var total_member_name = '';
		if(get_member.recordcount)
		{
			eval("member_div_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
			if(get_member.recordcount < total_member)
				total_member = get_member.recordcount;
			for(i=0;i<total_member;i++)
			{
				if(long_member_name == 0)
					var baslik = get_member.MEMBER_NAME[i];
				else
					var baslik = get_member.LONG_MEMBER_NAME[i];
			
				var baslik = baslik.substr(0,member_max_length);
				if(get_member.TYPE[i] == '1')
				{
					if(get_member.MASTER_ID[i] == 0)
						var member_name1 = '<a href="javascript://" onClick="add_member_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_member.TYPE[i]+','+'\''+get_member.MEMBER_ID[i]+'\','+'\''+get_member.MEMBER_NAME[i]+'\');"><font color=blue>'+baslik+' (Ek)</font></a><br />';
					else
						var member_name1 = '<a href="javascript://" onClick="add_member_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_member.TYPE[i]+','+'\''+get_member.MEMBER_ID[i]+'\','+'\''+get_member.MEMBER_NAME[i]+'\');"><font color=blue>'+baslik+'</font></a><br />';
				}
				else if(get_member.TYPE[i] == '2')
				{
					if(long_member_name == 0)
						var member_name1 = '<a href="javascript://" onClick="add_member_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_member.TYPE[i]+','+'\''+get_member.MEMBER_ID[i]+'\','+'\''+get_member.MEMBER_NAME[i]+'\');"><font color=red>'+baslik+'</font></a><br />';
					else
						var member_name1 = '<a href="javascript://" onClick="add_member_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_member.TYPE[i]+','+'\''+get_member.MEMBER_ID[i]+'\','+'\''+get_member.LONG_MEMBER_NAME[i]+'\');"><font color=red>'+baslik+'</font></a><br />';
				}
				else
					var member_name1 = '<a href="javascript://" onClick="add_member_<cfoutput>#attributes.is_multi_no#</cfoutput>('+get_member.TYPE[i]+','+'\''+get_member.MEMBER_ID[i]+'\','+'\''+get_member.MEMBER_NAME[i]+'\');"><font color=green>'+baslik+'</font></a><br />';
					
				total_member_name = total_member_name + member_name1;
			}
			member_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_member_name;
		}
		else
			div_close_member_<cfoutput>#attributes.is_multi_no#</cfoutput>();
	}
	else
	{
		div_close_member_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		if(<cfoutput>#attributes.form_name#.#attributes.member_name#</cfoutput>.value.length == 0)
		{
			<cfif isdefined("attributes.employee_id")>
				<cfoutput>#attributes.form_name#.#attributes.employee_id#</cfoutput>.value = '';
			</cfif>
			<cfif isdefined("attributes.company_id")>
				<cfoutput>#attributes.form_name#.#attributes.company_id#</cfoutput>.value = '';
			</cfif>
			<cfif isdefined("attributes.consumer_id")>
				<cfoutput>#attributes.form_name#.#attributes.consumer_id#</cfoutput>.value = '';
			</cfif>
			<cfif len(attributes.member_type)>
				<cfoutput>#attributes.form_name#.#attributes.member_type#</cfoutput>.value = '';
			</cfif>			
		}
	}
}

function add_member_<cfoutput>#attributes.is_multi_no#</cfoutput>(type,member_id,member_name)
{
	if(type == 1)
	{
		<cfoutput>#attributes.form_name#.#attributes.member_name#</cfoutput>.value = member_name;
		<cfif isdefined("attributes.employee_id")>
			<cfoutput>#attributes.form_name#.#attributes.employee_id#</cfoutput>.value = member_id;
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfoutput>#attributes.form_name#.#attributes.company_id#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<cfoutput>#attributes.form_name#.#attributes.consumer_id#</cfoutput>.value = '';
		</cfif>
		<cfif len(attributes.member_type)>
			<cfoutput>#attributes.form_name#.#attributes.member_type#</cfoutput>.value = 'employee';
		</cfif>
	}
	else if(type == 2)
	{
		
		<cfoutput>#attributes.form_name#.#attributes.member_name#</cfoutput>.value = member_name;
		<cfif isdefined("attributes.employee_id")>
			<cfoutput>#attributes.form_name#.#attributes.employee_id#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfoutput>#attributes.form_name#.#attributes.company_id#</cfoutput>.value = member_id;
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<cfoutput>#attributes.form_name#.#attributes.consumer_id#</cfoutput>.value = '';
		</cfif>
		<cfif len(attributes.member_type)>
			<cfoutput>#attributes.form_name#.#attributes.member_type#</cfoutput>.value = 'partner';
		</cfif>
	}
	else if(type == 3)
	{
		<cfoutput>#attributes.form_name#.#attributes.member_name#</cfoutput>.value = member_name;
		<cfif isdefined("attributes.employee_id")>
			<cfoutput>#attributes.form_name#.#attributes.employee_id#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfoutput>#attributes.form_name#.#attributes.company_id#</cfoutput>.value = '';	
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<cfoutput>#attributes.form_name#.#attributes.consumer_id#</cfoutput>.value = member_id;
		</cfif>
		<cfif len(attributes.member_type)>
			<cfoutput>#attributes.form_name#.#attributes.member_type#</cfoutput>.value = 'consumer';
		</cfif>
	}
	div_close_member_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}

function div_close_member_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	member_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.display = 'none';
	member_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = '';
}
</script>

<div id="member_div_<cfoutput>#attributes.is_multi_no#</cfoutput>" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="member_td_<cfoutput>#attributes.is_multi_no#</cfoutput>">&nbsp;</td>
		</tr>
	</table>
</div>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
