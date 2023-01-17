<!--- Uye Sosyal Medya Ekleme Sayfasi --->
<cfquery name="GET_SOCIAL_MEDIA" datasource="#DSN#">
	SELECT 
		SCMC.SMCAT,
		SCMC.SMCAT_ID,
		SCMC.SMCAT_LINK_TYPE,
		SM.LINK_1 
	FROM 
		SETUP_SOCIAL_MEDIA_CAT SCMC,
		SOCIAL_MEDIA SM
	WHERE 
		SM.SMCAT_ID = SCMC.SMCAT_ID AND
		SM.ACTION_ID = #attributes.action_type_id# AND
		SM.ACTION_TYPE = '#attributes.action_type#'
	
	UNION ALL
	
	SELECT 
		SCMC.SMCAT,
		SCMC.SMCAT_ID,
		SCMC.SMCAT_LINK_TYPE,
		'' LINK_1 
	FROM 
		SETUP_SOCIAL_MEDIA_CAT SCMC
	WHERE 
		SCMC.SMCAT_ID NOT IN (SELECT SMCAT_ID FROM SOCIAL_MEDIA WHERE ACTION_ID = #attributes.action_type_id# AND ACTION_TYPE = '#attributes.action_type#')
	 ORDER BY 
	 	SCMC.SMCAT
</cfquery>
<cfquery name="smc" datasource="#dsn#">
	SELECT SMCAT_ID,SMCAT,SMCAT_ICON FROM SETUP_SOCIAL_MEDIA_CAT
</cfquery>
<cfparam name="attributes.modal_id" default="">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29529.Sosyal Medya'><cf_get_lang dictionary_id='57652.Hesap'></cfsavecontent>
<cf_box title="#message#" closable="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_social_media" action="#request.self#?fuseaction=objects.emptypopup_add_social_media" method="post">
			<cf_box_elements>
				<input type="hidden" name="draggable" id="draggable" value="<cfif isdefined('attributes.draggable')><cfoutput>#attributes.draggable#</cfoutput></cfif>">
			<cfoutput>
            <cf_grid_list>
                <thead>
					<input name="record_num" id="record_num" type="hidden" value="<cfif GET_SOCIAL_MEDIA.recordcount>#GET_SOCIAL_MEDIA.recordcount#<cfelse>0</cfif>">
                    <tr>
                        <th style="width:10px;"><a title="<cf_get_lang dictionary_id='44630.Ekle'>" href="javascript://" onClick="add_row();"><i class="fa fa-plus"></i></a></th>
                        <th width="150"><cf_get_lang dictionary_id='38857.Hesap türü'></th>
                        <th><cf_get_lang dictionary_id='57581.Sayfa'></th>
                    </tr>
                </thead>
                <tbody name="table1" id="table1">
					<cfif get_social_media.recordcount>
				<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_type_id#</cfoutput>"/>
				<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>"/>
				<input type="hidden" name="sm_cat_id" id="sm_cat_id" value="<cfoutput>#get_social_media.smcat_id#</cfoutput>"/>
				<cfset count = 0>
					  <cfloop query="get_social_media">	
						<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
						<tr id="frm_row#currentrow#" name="frm_row#currentrow#">
                        <td ><a title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(#currentrow#);" ><i class="icon-minus"></i></a></td>
                        <td width="40">
						<select style="cursor:pointer;" name="category_id#currentrow#" id="category_id#currentrow#">
						   <cfloop query="smc">
						  <option value="#smc.SMCAT_ID#" <cfif len(get_social_media.smcat_id) and (get_social_media.smcat_id eq smc.smcat_id)> selected</cfif>>#smc.smcat#</option>
						 </cfloop>
						</select></td>
                        <td><input type="text" size="80" maxlength="110" name="link_#currentrow#" id="link_#currentrow#" value="#get_social_media.link_1#" ></td>
                    </tr>
				</cfloop>
				</cfif>
				</tbody>
			</cf_grid_list>
		</cfoutput>
		</cf_box_elements> 
		<cf_box_footer>
				<cf_workcube_buttons is_upd='0' is_delete='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_social_media' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
		</cfform>   
	</cf_box>	
<script type="text/javascript">
 var row_count = document.getElementById("record_num").value;
function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);	
	document.add_social_media.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(' + row_count + ');"  ><i class="icon-minus"></i></a><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<cfoutput><select style="cursor:pointer;" name="category_id'+row_count+'" id="category_id'+row_count+'"><cfloop query="smc"><option value="#smc.SMCAT_ID#"<cfif len(get_social_media.smcat_id) and (get_social_media.smcat_id eq smc.smcat_id)> selected</cfif>>#smc.smcat#</option></cfloop></select></cfoutput>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input size="80" maxlength="110" type="text" name="link_'+row_count+'" id="link_#'+row_count+'">';
}
function sil(sy)
	{
		var my_element=eval("add_social_media.row_kontrol"+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	</script>