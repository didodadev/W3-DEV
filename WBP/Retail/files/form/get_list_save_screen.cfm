<cfparam name="attributes.list_name" default="">
<cfparam name="attributes.list_id" default="">

<cfquery name="get_list" datasource="#dsn_dev#">
    SELECT
        LIST_ID,
        LIST_NAME
    FROM
        SEARCH_LISTS
    ORDER BY
    	LIST_NAME
</cfquery>

<cfform name="add_list" action="#request.self#?fuseaction=retail.emptypopup_add_list_save_screen" method="post">
<cfinput type="hidden" value="#attributes.list_id#" name="list_id">
<cfinput type="hidden" name="list_all_product_list" id="list_all_product_list" value=""/>
	<table>
    	<tr>
        	<td colspan="2">
            	<input type="radio" name="record_type" value="1" checked onclick="set_action();"/> Yeni Kayıt
                <input type="radio" name="record_type" value="2" onclick="set_action();"/> Güncelleme
            </td>
        </tr>
        <tr id="new_record">
        	<td width="70">Liste Adı</td>
            <td><cfinput type="text" value="#attributes.list_name#" name="list_name" style="width:125px;"></td>
        </tr>
        <tr id="upd_record" style="display:none;">
        	<td width="70">Liste</td>
            <td>
            	<select name="upd_list_id" id="upd_list_id">
                	<option value="">Seçiniz</option>
                    <cfoutput query="get_list">
                    	<option value="#list_id#">#list_name#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
        	<td colspan="2"><input type="button" value="Kaydet" onclick="send_form_save();"/></td>
        </tr>
    </table>
</cfform>
<div id="hide_col_list_action_div"></div>

<script>
	document.getElementById('list_all_product_list').value = document.getElementById('all_product_list').value;

function set_action()
{
	if(document.add_list.record_type[0].checked == true)
	{
		show('new_record');
		hide('upd_record');	
	}
	else
	{
		hide('new_record');
		show('upd_record');	
	}	
}
	
function send_form_save()
{
	if(document.add_list.record_type[0].checked == true)
	{
		if(document.getElementById('list_name').value == '')
		{
			alert('Liste Adı Giriniz!');
			return false;	
		}
	}
	else
	{
		if(document.getElementById('upd_list_id').value == '')
		{
			alert('Liste Seçiniz!');
			return false;	
		}	
	}
	deger_ = '';
	deger_ += '&list_id=' + document.getElementById('upd_list_id').value;
	deger_ += '&list_all_product_list=' + document.getElementById('list_all_product_list').value;
	deger_ += '&list_name=' + document.getElementById('list_name').value;
	
	if(document.add_list.record_type[0].checked == true)
	{
		record_type_ = 0;
	}
	else
	{
		record_type_ = 1;
	}	
	
	deger_ += '&record_type=' + record_type_;
	
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_add_list_save_screen</cfoutput>' + deger_,'hide_col_list_action_div','1');
}
</script>