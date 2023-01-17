<cfsetting showdebugoutput="no">
<cfquery name="get_product_brand" datasource="#DSN1#">
	SELECT
		* 
	FROM
		PRODUCT_BRANDS 
	ORDER BY
		 BRAND_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='40539.Ürün Markaları'></cfsavecontent>
<cf_box id="brand_list" style="position:absolute;overflow:auto;height:200;width:180;" title="#message#" >
<table border="0" width="150" cellpadding="1" cellspacing="2">
	<tr height="20">
		<td class="txtboldblue"><cf_get_lang dictionary_id='57487.No'></td>
		<td class="txtboldblue"><cf_get_lang dictionary_id='58847.Marka'></td>
		<td><input type="checkbox" name="all_brands" id="all_brands" value="1" onclick="all_select();" title="<cf_get_lang dictionary_id='58081.Hepsi'>"></td>
	</tr>
	<tr>
	<cfoutput query="get_product_brand">
		<tr height="20">
			<td>#currentrow#</td>
			<td>#brand_name#</td>
			<td><input type="checkbox" name="_brand_names_" id="_brand_names_" value="#brand_name#" <cfif listfind(attributes.id_list,brand_id)> checked </cfif>>
				 <input type="hidden" name="_brand_id_" id="_brand_id_" value="#brand_id#" >
			</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="3" align="right" style="text-align:right;"><input type="button" value="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_brand();"></td>
	</tr>
</table>
</cf_box>
<script type="text/javascript">
function add_brand()
{ 
var branch_id_list ='';
var brand_name_list='';		
for(i=0;i<=document.getElementById._brand_names_.length-1;i++) 
	{
		
		if (document.all._brand_names_[i].checked == true)
		{	
			
			 branch_id_list += document.all._brand_id_[i].value + ',';
			 brand_name_list += document.all._brand_names_[i].value + ','; 
		}
		else if(document.getElementById('all_brands').checked == true)
		{
			 document.getElementById('all_brands').checked == true;
			 branch_id_list += document.all._brand_id_[i].value + ',';
			 brand_name_list += document.all._brand_names_[i].value + ','; 
		}
	}
	branch_id_list = branch_id_list.substr(0,branch_id_list.length-1);
	brand_name_list = brand_name_list.substr(0,brand_name_list.length-1);
	document.getElementById('brand_id').value =branch_id_list;
	document.getElementById('brand_name').value = brand_name_list;
	document.getElementById('brand_list').style.display ='none';
}
function all_select()
{
	if (document.getElementById('all_brands').checked)
		{
			for(say=0;say<<cfoutput>#get_product_brand.recordcount#</cfoutput>;say++)
			document.all._brand_names_[say].checked = true;
			
		}
	else 
		{
		for(say=0;say<<cfoutput>#get_product_brand.recordcount#</cfoutput>;say++)
		document.all._brand_names_[say].checked = false;
		
		}
}

</script>

