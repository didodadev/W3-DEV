<cf_get_lang_set module_name="product">
<cfsetting showdebugoutput="no">
<cfquery name="get_cons_cat" datasource="#dsn#">
	SELECT * FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY
</cfquery>

<cf_box title="Bağlı Temsilci Dağılımı">
<table border="0" width="200" cellpadding="2" cellspacing="1">
	<tr height="22">
		<td class="txtboldblue" width="120"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></td>
		<td class="txtboldblue"><cf_get_lang dictionary_id ='37915.Kişi Sayısı'></td>
	</tr>	
	<cfoutput query="get_cons_cat">
		<tr height="20">
			<td>
				<input type="hidden" name="consumer_catid_row#currentrow#_#attributes.rows#" id="consumer_catid_row#currentrow#_#attributes.rows#" value="#conscat_id#">
				<input type="text" name="consumer_cat_row#currentrow#_#attributes.rows#" id="consumer_cat_row#currentrow#_#attributes.rows#" value="#conscat#" class="boxtext">
			</td>
			<td>
				<input type="text" name="ref_member_row_count#currentrow#_#attributes.rows#" id="ref_member_row_count#currentrow#_#attributes.rows#" value="0" style="width:50px;" onkeyup="isNumber(this);" class="moneybox">
			</td>
		</tr>
	</cfoutput>
	<input type="hidden" name="form_complete_<cfoutput>#attributes.rows#</cfoutput>" id="form_complete_<cfoutput>#attributes.rows#</cfoutput>">
	<tr>
		<td colspan="2" align="right" style="text-align:right;">
			<input type="button" value="Ekle" onClick="add_process_<cfoutput>#attributes.rows#</cfoutput>();">
		</td>
	</tr>
</table>
</cf_box>
<script type="text/javascript">
	function add_process_<cfoutput>#attributes.rows#</cfoutput>()
	{
		<cfoutput query="get_cons_cat">
			if(document.all.ref_member_row_count#get_cons_cat.currentrow#_#attributes.rows#.value > 0)
			{
				document.all.consumer_cat_row_id#attributes.conscat_id#_#get_cons_cat.currentrow#.value = document.all.consumer_catid_row#get_cons_cat.currentrow#_#attributes.rows#.value;
				document.all.member_count_row#attributes.conscat_id#_#get_cons_cat.currentrow#.value = document.all.ref_member_row_count#get_cons_cat.currentrow#_#attributes.rows#.value;
			}
			else
			{
				document.all.consumer_cat_row_id#attributes.conscat_id#_#get_cons_cat.currentrow#.value = "";
				document.all.member_count_row#attributes.conscat_id#_#get_cons_cat.currentrow#.value = "0";
			}
		</cfoutput>
		document.all.open_process_<cfoutput>#attributes.rows#</cfoutput>.style.display ='none';
	}
	function function_load()
	{
		if (document.all.form_complete_<cfoutput>#attributes.rows#</cfoutput>)
		{
			<cfoutput query="get_cons_cat">
				document.all.ref_member_row_count#get_cons_cat.currentrow#_#attributes.rows#.value = document.all.member_count_row#attributes.conscat_id#_#get_cons_cat.currentrow#.value ;
			</cfoutput>
		}
		else
			setTimeout('function_load()',20);
	}
	function_load();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
