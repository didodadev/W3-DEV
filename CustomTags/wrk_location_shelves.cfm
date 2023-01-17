<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By : Özden Öztürk 20070926
Description :
Şimdilik sadece basket satırlarındaki raf bilgisini getirmek icin kullanılıyor, genele göre duzenlenecek..

shelf_basket_id parametresi sadece custom tag baskette cagrılacaksa kullanılmalıdır. shelf_basket_id kullanıldıgında shelf_department_id ve
shelf_location_id parametrelerinin gonderilmesine gerek yoktur, zaten ilgili basket_id nin kullanıldıgı formlardaki department ve location alanlarının
degerleri custom tag icinde bulunuyor.
--->
<cfparam name="attributes.max_rows" default="#session.ep.maxrows#">
<cfparam name="attributes.min_char" default="1">
<cfparam name="attributes.shelf_department" default="">
<cfparam name="attributes.shelf_location" default="">
<cfparam name="attributes.shelf_basket_id" default="">
<div id="shelf_code_div" style="position:absolute;display:none;z-index:9999;width:150px;height:250px;overflow:auto;background-color: #colorrow#; border: 1px outset cccccc;">
	<table class="color-border" cellpadding="2" cellspacing="1" width="100%">
		<tr height="18" class="form-title" >
			<td class=""><cfoutput>#caller.getLang('main',2147)#</cfoutput></td> <!--- Raflar--->
		</tr> 
		<tr height="18" class="color-row">
			<td id="shelf_code_td">&nbsp;</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	shelf_code_div.style.left = (screen.width-150)/2;
	shelf_code_div.style.top =  (screen.height-250)/2;
	<cfif isdefined('attributes.shelf_basket_id') and listfind('4,6',attributes.shelf_basket_id)>
		<cfset attributes.shelf_department = 'deliver_dept_id'>
		<cfset attributes.shelf_location = 'deliver_loc_id'>
	<cfelseif isdefined('attributes.shelf_basket_id') and listfind('14,15',attributes.shelf_basket_id)>
		<cfset attributes.shelf_department = 'DEPARTMENT_ID'>
		<cfset attributes.shelf_location = 'location_id'>
	<cfelseif isdefined('attributes.shelf_basket_id') and listfind('12,13',attributes.shelf_basket_id)>
		<cfset attributes.shelf_department = 'department_in'>
		<cfset attributes.shelf_location = 'location_in'>
	<cfelseif isdefined('attributes.shelf_basket_id') and attributes.shelf_basket_id eq 31>
		<cfset attributes.shelf_department = 'department_in_id'>
		<cfset attributes.shelf_location = 'location_in_id'>
	<cfelse>
		<cfset attributes.shelf_department = 'department_id'>
		<cfset attributes.shelf_location = 'location_id'>
	</cfif>

	function get_wrk_shelf(shelf_row,same_rowcount,field_name,field_id)
	{  

		var max_rows = <cfoutput>#attributes.max_rows#</cfoutput>;
		var min_char = <cfoutput>#attributes.min_char#</cfoutput>;
		var shelf_row_no = shelf_row;
		/*sıra degiskeni aynı form icinde aynı isimli liste halinde kullanılan raf bilgisi icin gonderilir ve alanın satır nosunu gosterir.
		same_rowcount ise aynı isimli alana sahip kac satır oldugunu gostermek icin kullanılır (tek satırlı baskette sorun cıkmaması icin)
		IKI PARAMETRE BIRLIKTE GONDERILMELIDIR*/
		if(shelf_row != undefined && same_rowcount != undefined && same_rowcount != 1)
		{
			var new_shelf_name = '<cfoutput>#attributes.form_name#.</cfoutput>'+field_name+'['+ shelf_row +']';
			var new_shelf_field_id = '<cfoutput>#attributes.form_name#.</cfoutput>'+field_id+'['+ shelf_row +']';
		}
		else
		{
			var new_shelf_name = '<cfoutput>#attributes.form_name#.</cfoutput>'+field_name;
			var new_shelf_field_id = '<cfoutput>#attributes.form_name#.</cfoutput>'+field_id;
		}
		if(eval(new_shelf_name+'.value').length >= min_char)
		{
			var search_dep_id = <cfoutput>#attributes.form_name#.#attributes.shelf_department#</cfoutput>.value;
			var search_loc_id = <cfoutput>#attributes.form_name#.#attributes.shelf_location#</cfoutput>.value;
			var shelf_info_result = workdata('get_shelf_info',eval(new_shelf_name+".value"),max_rows,search_dep_id,search_loc_id);
			var shelf_code_count = max_rows;
			var total_shelf_code = '';
			if(shelf_info_result.recordcount)
			{ 
				shelf_code_div.style.display = '';
				
				if(shelf_info_result.recordcount < shelf_code_count)
					shelf_code_count = shelf_info_result.recordcount;
				for(i=0;i<shelf_code_count;i++)
				{
					var baslik = shelf_info_result.SHELF_CODE[i];
					//var baslik = baslik.substr(0,acccode_max_length);
					var temp_shelf_code = '<a href="javascript://" onClick="add_shelf(\''+shelf_info_result.PRODUCT_PLACE_ID[i]+'\',\''+shelf_info_result.SHELF_CODE[i]+'\',\''+new_shelf_name+'\',\''+new_shelf_field_id+'\');">'+baslik+'</a><br />';
					total_shelf_code = total_shelf_code + temp_shelf_code;
				}
				shelf_code_td.innerHTML = total_shelf_code;
			}
			else
				close_shelf_div();
		}
		else
			close_shelf_div();
	}
	
	function add_shelf(shelf_id,shelf_code,shelf_field,shelf_field_id)
	{
		eval(shelf_field_id).value =shelf_id;
		eval(shelf_field).value =shelf_code;
		close_shelf_div();
	}
	function close_shelf_div()
	{
		shelf_code_div.style.display = 'none';
		shelf_code_td.innerHTML = '';
	}
</script>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
