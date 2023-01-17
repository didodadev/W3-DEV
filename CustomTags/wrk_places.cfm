<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : 
Barbaros KUZ 20070808

Description :
	İl secilen yerlerde input alanina girilen ifade ile baslayan illerin adlarini bulur.
	Ve secilmesi icin o anda inputun altina div acar.
Parameters :
	form_name		-- 	required
	place_id		-- 	required
	place_name		-- 	required
	is_type			-- 	required (1 - country, 2 - city, 3 - county)
	max_rows 		-- 	not required
	min_char 		--  not required
	is_multi_no		-- 	not required 
	id_name			--	not required
	is_requisite	-- 	not required
	requisite_text	-- 	not required
	
	place_max_length degiskeni fazla gelen text ifadenin belli bir karaktere kadar olan bolumunu almak icin kullanilir.
	id_name parametresi ilgili alandaki degere gore kayit getirmek icin kullanilir.
	is_requisite parametresi formdaki zorunlu alanların kontrolunu yapar.
	requisite_text ifadesi ise ilgili alanin olmamasi durumundaki mesaji ifade eder.
	Ayrıca place_name ifadesinin uzunlugu yoksa place_id ifadesi de bosaltilir.	
	
	Div uzunlugu ve karakter uzunlugu otomatik olarak duzenlenir.
Syntax :
	Bir formda sadece bir kez kullanilirsa
	<cf_wrk_places form_name='subscription_list' place_name='city' place_id='city_id' is_type='2'>					
	<input type="hidden" name="city_id" value="">
	<input type="text" name="city" value="" onKeyUp="get_place_1();" style="width:90px;">
	Bir formda ikinci kez kullanilirsa (is_multi_no parametresi tanimlanmali)
	<cf_wrk_places form_name='subscription_list' place_name='county' place_id='county_id' is_type='3' is_multi_no='2' id_name='city_id'>
	<input type="hidden" name="county_id" value="">
	<input type="text" name="county" onChange="county_temizle();" value="" onKeyUp="get_place_2();" style="width:90px;">
	Eger zorunlu alan varsa (Bu ornekde city zorunlu yapilmis)
	<cf_wrk_places form_name='add_consumer' place_name='work_county' place_id='work_county_id' is_type='3' id_name='work_city_id' is_requisite='1' requisite_text=' İl Seçiniz (Iş) !'>
Revisions :

--->
<cfparam name="attributes.is_multi_no" default='1'>
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.min_char" default="3">
<cfparam name="attributes.id_name" default="">
<cfparam name="attributes.is_requisite" default="0">
<cfparam name="attributes.requisite_text" default="">

<script type="text/javascript">
function get_place_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	var max_rows = <cfoutput>#attributes.max_rows#</cfoutput>;
	var min_char = <cfoutput>#attributes.min_char#</cfoutput>;
	var place_div_genislik = parseInt(<cfoutput>#attributes.form_name#.#attributes.place_name#.style.width</cfoutput>);
	place_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.width = place_div_genislik;
	var place_max_length = wrk_round((place_div_genislik*0.14),0);
	var id_name_length = <cfif len(attributes.id_name)><cfoutput>#attributes.form_name#.#attributes.id_name#</cfoutput>.value.length<cfelse>0</cfif>;
	var requisite_text = '<cfoutput>#attributes.requisite_text#</cfoutput>';
	var is_requisite = <cfoutput>#attributes.is_requisite#</cfoutput>;
	
	if(<cfoutput>#attributes.form_name#.#attributes.place_name#</cfoutput>.value.length >= min_char)
	{
		if(is_requisite == 0 || is_requisite == 1 && id_name_length !=0)
		{	
			var query_place = workdata('get_place',<cfoutput>#attributes.form_name#.#attributes.place_name#</cfoutput>.value,max_rows,'<cfoutput>#attributes.is_type#</cfoutput>'<cfif attributes.is_type eq 3 and len(attributes.id_name)>,<cfoutput>#attributes.form_name#.#attributes.id_name#</cfoutput>.value</cfif>);
			var total_place_no = max_rows;
			var total_placename = '';
			if(query_place.recordcount)
			{
				eval("place_div_<cfoutput>#attributes.is_multi_no#</cfoutput>").style.display = '';
				if(query_place.recordcount < total_place_no)
					total_place_no = query_place.recordcount;
				for(i=0;i<total_place_no;i++)
				{
					var baslik = query_place.PLACE_NAME[i];
					var baslik = baslik.substr(0,place_max_length);
					var placename = '<a href="javascript://" onClick="add_place_<cfoutput>#attributes.is_multi_no#</cfoutput>('+query_place.PLACE_ID[i]+','+'\''+query_place.PLACE_NAME[i]+'\''+');">'+baslik+'</a><br />';
					total_placename = total_placename + placename;
				}
				place_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = total_placename;
			}
			else
				div_close_place_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		}
		else //Eger zorunlu alan varsa hata mesaji
			alert(requisite_text);
	}
	else
	{
		div_close_place_<cfoutput>#attributes.is_multi_no#</cfoutput>();
		if(<cfoutput>#attributes.form_name#.#attributes.place_name#</cfoutput>.value.length == 0)
			<cfoutput>#attributes.form_name#.#attributes.place_id#</cfoutput>.value = '';		
	}

}
function add_place_<cfoutput>#attributes.is_multi_no#</cfoutput>(place_id,place_name,is_multi_no)
{
	<cfoutput>#attributes.form_name#.#attributes.place_id#</cfoutput>.value = place_id;
	<cfoutput>#attributes.form_name#.#attributes.place_name#</cfoutput>.value = place_name;
	div_close_place_<cfoutput>#attributes.is_multi_no#</cfoutput>();
}
function div_close_place_<cfoutput>#attributes.is_multi_no#</cfoutput>()
{
	place_div_<cfoutput>#attributes.is_multi_no#</cfoutput>.style.display = 'none';
	place_td_<cfoutput>#attributes.is_multi_no#</cfoutput>.innerHTML = '';
}
</script>

<div id="place_div_<cfoutput>#attributes.is_multi_no#</cfoutput>" style="position:absolute;display:none;z-index:9999;"><br />
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="color-row">
			<td id="place_td_<cfoutput>#attributes.is_multi_no#</cfoutput>">&nbsp;</td>
		</tr>
	</table>
</div>

</cfprocessingdirective><cfsetting enablecfoutputonly="no">
