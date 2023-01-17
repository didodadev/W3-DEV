<cfsetting showdebugoutput="no">
<cfform name="submit_form" action="#request.self#?fuseaction=objects.emptypopup_add_employee_position_denied_form" method="post">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29814.Form Obje Yetkilendirmesi'></cfsavecontent>
<cf_popup_box title="#message#-#attributes.act_#">
<table>
    <input type="hidden" name="fusename" id="fusename" value="<cfoutput>#attributes.act_#</cfoutput>" />
    <input type="hidden" name="update_table_" id="update_table_" value="" />
    <cfif isdefined("url.type_id")>
    	<input type="hidden" name="type_id" id="type_id" value="<cfoutput>#url.type_id#</cfoutput>" />
    </cfif>
	<tr valign="top">
    	<cf_area>
		<td width="30%" style="vertical-align:top">
			<table width="99%" class="ajax_inner_table" id="table_form_list">
				<tr valign="top">
					<th class="txtboldblue"><cf_get_lang dictionary_id='32471.Alan Adı'></th>
					<th class="txtboldblue" nowrap="nowrap"><cf_get_lang dictionary_id='32474.Alan Açıklamasi'></th>
					<th class="txtboldblue"></th>
				</tr>
			</table>
		</td>
    	</cf_area>
       	<cf_area>
		<td width="70%" style="vertical-align:top;"><div id="yetkiler"></div></td>
        </cf_area>
	</tr>
</table>
</cf_popup_box>
</cfform>
<!--- Bu blok o inputa ait database'de herhangi bir kayit varmi kontrolü yapiyor. Varsa asagida yazilan title kirmizi geliyor.--->
<cfquery name="get_changed_input" datasource="#dsn#">
	SELECT 
		FORM_DEFINE
    FROM
    	EMPLOYEE_POSITIONS_DENIED_FORM
    WHERE
    	DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.act_#">
        AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif isdefined("url.type_id")>
           AND TYPE_ID = #url.type_id#
        </cfif>
</cfquery>
<cfset changed_inputs = valuelist(get_changed_input.FORM_DEFINE)>
<!--- --->
<script type="text/javascript">

	var real_forms = new Array(0);
	var row_value = new Array(0);
	var inputs_value = new Array(0);
	for(i = 0; i<window.opener.document.forms.length; i++)
	{
		if(window.opener.document.forms[i].name == '[object HTMLInputElement]')
			alert("Form elemanı table etiketinin dışında olmalıdır.")
		else
		{
			if(window.opener.document.forms[i].name.search('qry') == -1 && window.opener.document.forms[i].name.search('add_to_fav') == -1 && window.opener.document.forms[i].name.search('fav_form') == -1 && window.opener.document.forms[i].getElementsByTagName("tr").length != 0)
			{
				var newRow;
				var newCell;
				newRow = document.getElementById("table_form_list").insertRow(document.getElementById("table_form_list").rows.length);
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = window.opener.document.forms[i].name;
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = 'Form';
				
				form_elemanlari = window.opener.document.forms[i].getElementsByTagName("tr");

				for(mmc=0;mmc<form_elemanlari.length;mmc++)
				{
					if(form_elemanlari[mmc].id != '' && form_elemanlari[mmc].id.search('form_ul') == 0 && isNaN(form_elemanlari[mmc].id.substr(8,1)) != false) // ID'si girilmemis alanlarda form_ul_1 seklinde 8. karakter 'rakam' geldigi icin onu hesaba katmiyoruz..
					{
						newRow = document.getElementById("table_form_list").insertRow(document.getElementById("table_form_list").rows.length);
						
						<cfoutput>changed_inputs = '#changed_inputs#';</cfoutput>
						
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = window.opener.document.getElementById(form_elemanlari[mmc].id).id;
						
						newCell = newRow.insertCell(newRow.cells.length);
						if(list_find(changed_inputs,window.opener.document.getElementById(form_elemanlari[mmc].id).id) != 0)
							newCell.style.color = "red";
						newCell.innerHTML = window.opener.document.getElementById(form_elemanlari[mmc].id).title;
							
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML = '<a href="javascript://" onClick="create_hidden(\'' + window.opener.document.getElementById(form_elemanlari[mmc].id).id + '\');"><img src="/images/transfer.gif" border="0"></a>';
					}
				}
			}
		}
	}
function create_hidden(obje)
{
    <cfif isdefined("url.type_id")>
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.denied_form_objects&form_define='+obje+'&fusename='+document.getElementById('fusename').value+'&type_id='+document.getElementById('type_id').value,'yetkiler');
	<cfelse>
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.denied_form_objects&form_define='+obje+'&fusename='+document.getElementById('fusename').value,'yetkiler');		
    </cfif>
}
</script>
