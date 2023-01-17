<cfsetting showdebugoutput="no">
<cfquery name="get_forrer_list" datasource="#DSN3#">
SELECT * FROM OFFER WHERE FOR_OFFER_ID IS NULL AND ((OFFER_ZONE = 1 AND PURCHASE_SALES = 1) OR (OFFER_ZONE = 0 AND PURCHASE_SALES = 0)) AND OFFER_STATUS = 1
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id ='38509.İlişkili Teklifler'></cfsavecontent>
<cf_box id="related_offer_list" style="position:absolute;overflow:auto;height:200;width:185;margin-left:-170;top:20;" title="#message#">
<table border="0" cellpadding="0" cellspacing="0">
	<tr height="20">
		<td class="txtboldblue">No</td>
        <td class="txtboldblue" nowrap="nowrap"><cf_get_lang dictionary_id='58212.Teklif No'></td>
		<td class="txtboldblue" nowrap="nowrap"><cf_get_lang dictionary_id='38655.Teklif Tarihi'></td>
	</tr>
	<tr>
	<cfoutput query="get_forrer_list">
		<tr height="20">
			<td>#currentrow#</td>
			<td>#offer_number#</td>
            <td>#dateformat(get_forrer_list.offer_date,dateformat_style)#</td>
			<td><input type="radio" name="offer_number_" id="offer_number_" value="#offer_number#" checked>
				 <input type="hidden" name="offer_id_" id="offer_id_" value="#offer_id#" >
			</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="4" align="right" style="text-align:right;"><input type="button" value="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_for_offer();"></td>
	</tr>
</table>
</cf_box>
<script type="text/javascript">
function add_for_offer()
{ 
var offer_id_list ='';
var offer_number_list='';		
for(i=0;i<=document.getElementById('offer_number_').length-1;i++) 
	{
		
		if (document.all.offer_number_[i].checked == true)
		{
			 offer_id_list += document.all.offer_id_[i].value + ',';
			 offer_number_list += document.all.offer_number_[i].value + ','; 
		}
	}
	offer_id_list = offer_id_list.substr(0,offer_id_list.length-1);
	offer_number_list = offer_number_list.substr(0,offer_number_list.length-1);
	document.getElementById('related_offer_number').value = offer_number_list;
	document.getElementById('related_offer_id').value = offer_id_list;
	document.getElementById('related_offer_list').style.display ='none';
}
</script>

