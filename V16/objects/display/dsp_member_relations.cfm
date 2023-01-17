<!--- kurumsal-bireysel-sistem ilişkili kayıt eklemek içindir,3 ü içinde ortak kullanılır,type lara göre kayıtları getirir --->
<cfsetting showdebugoutput="no"><!--- ajax sayfa oldg. için --->
<cfif listlen(attributes.action_type_info,',') gt 1><cfset attributes.action_type_info = listfirst(attributes.action_type_info,',')></cfif>
<cfif listlen(attributes.relation_info_id,',') gt 1><cfset attributes.relation_info_id = listfirst(attributes.relation_info_id,',')></cfif>
<cfif attributes.action_type_info eq 1><!--- kurumsal üyeler --->
	<cfquery name="GET_REL_SETUP" datasource="#dsn#">
		SELECT PARTNER_RELATION_ID SETUP_REL_ID,PARTNER_RELATION SETUP_REL_NAME FROM SETUP_PARTNER_RELATION ORDER BY PARTNER_RELATION
	</cfquery>
	<cfquery name="GET_RELATION" datasource="#dsn#">
		SELECT 
			C.NICKNAME REL_ROW_NAME,<!--- satırdaki ilişkili üyenin ismi --->
			CPR.PARTNER_COMPANY_ID REL_ROW_ID,<!--- satırlardaki ilişkili üyelerin idsi --->
			CPR.PARTNER_RELATION_ID RELATION_TYPE_ID,<!--- satırdaki ilişki tipi idleri--->
			CPR.DETAIL,<!--- satırdaki ilişki açıklamları --->
			CPR.RECORD_EMP,
			CPR.RECORD_IP,
			CPR.RECORD_DATE
		FROM 
			COMPANY C, 
			COMPANY_PARTNER_RELATION CPR
		WHERE 
			CPR.PARTNER_COMPANY_ID = C.COMPANY_ID AND
			CPR.COMPANY_ID  = #attributes.relation_info_id#
	</cfquery>
<cfelseif attributes.action_type_info eq 2><!--- bireysel üyeler --->
	<cfquery name="GET_REL_SETUP" datasource="#dsn#">
		SELECT CONSUMER_RELATION_ID SETUP_REL_ID,CONSUMER_RELATION SETUP_REL_NAME FROM SETUP_CONSUMER_RELATION ORDER BY CONSUMER_RELATION
	</cfquery>
	<cfquery name="GET_RELATION" datasource="#dsn#">
		SELECT
			CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME REL_ROW_NAME,<!--- satırdaki ilişkili üyenin ismi --->
			CONSUMER2_ID REL_ROW_ID,<!--- satırlardaki ilişkili üyelerin idsi --->
			RELATION_ID RELATION_TYPE_ID,<!--- satırdaki ilişki tipi idleri--->
			CONSUMER_TO_CONSUMER.DETAIL,<!--- satırdaki ilişki açıklamları --->
			CONSUMER_TO_CONSUMER.RECORD_EMP,
			CONSUMER_TO_CONSUMER.RECORD_IP,
			CONSUMER_TO_CONSUMER.RECORD_DATE
		FROM
			CONSUMER,
			CONSUMER_TO_CONSUMER
		WHERE
			CONSUMER_TO_CONSUMER.CONSUMER_ID = #attributes.relation_info_id# AND 
			CONSUMER.CONSUMER_ID = CONSUMER_TO_CONSUMER.CONSUMER2_ID
			AND CONSUMER_TO_CONSUMER.IS_GUARANTOR IS NULL<!--- Kefil olmayan satırları getirsin diye eklendi(artık kullanılmyor galiba) --->
	</cfquery>
<cfelseif attributes.action_type_info eq 3><!--- sistemler --->
	<cfquery name="GET_REL_SETUP" datasource="#dsn#">
		SELECT SUBSCRIPTION_RELATION_ID SETUP_REL_ID,SUBSCRIPTION_RELATION SETUP_REL_NAME FROM SETUP_SUBSCRIPTION_RELATION ORDER BY SUBSCRIPTION_RELATION
	</cfquery>
	<cfquery name="GET_RELATION" datasource="#dsn3#">
		SELECT
			SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO REL_ROW_NAME,<!--- satırdaki ilişkili üyenin ismi --->
			SCR.RELATED_SUBSCRIPTION_ID REL_ROW_ID,<!--- satırlardaki ilişkili üyelerin idsi --->
			SCR.RELATION_TYPE_ID RELATION_TYPE_ID,<!--- satırdaki ilişki tipi idleri--->
			SCR.DETAIL,<!--- satırdaki ilişki açıklamları --->
			SCR.RECORD_EMP,
			SCR.RECORD_IP,
			SCR.RECORD_DATE
		FROM
			SUBSCRIPTION_CONTRACT,
			SUBSCRIPTION_CONTRACT_RELATIONS SCR
		WHERE
			SCR.SUBSCRIPTION_ID = #attributes.relation_info_id# AND 
			SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID = SCR.RELATED_SUBSCRIPTION_ID
	</cfquery>
</cfif>
<cfform name="form_relation" method="post" action="#request.self#?fuseaction=objects.emptypopup_member_relation_act">
	<cfoutput>
        <input type="hidden" name="relation_info_id" id="relation_info_id" value="#attributes.relation_info_id#"><!--- hangi üyenin altına ilişkilendiği --->
        <input type="hidden" name="record_num" id="record_num" value="#GET_RELATION.RECORDCOUNT#">
        <input type="hidden" name="action_type_info" id="action_type_info" value="#attributes.action_type_info#"><!--- tiplere göre arka tarafta işlemleri kaydedeck --->
	</cfoutput>
	<cf_grid_list>
        <thead>
            <tr>
                <th width="20"><a onClick="add_relation_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                <th><cfif attributes.action_type_info eq 1><cf_get_lang dictionary_id='57585.Kurumsal Üye'><cfelseif attributes.action_type_info eq 2><cf_get_lang dictionary_id='57586.Bireysel Üye'><cfelseif attributes.action_type_info eq 3><cf_get_lang dictionary_id='58832.Abone'></cfif></th>
                <th><cf_get_lang dictionary_id ='58680.İlişki'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th width="20"><i class="fa fa-cube"></i></th>
            </tr>
        </thead>
		<tbody id="member_relation_table">
        	<cfoutput query="GET_RELATION">
			<tr id="frm_row_rel#currentrow#">
				<td nowrap="nowrap">
						<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
						<input type="hidden" name="record_emp#currentrow#" id="record_emp#currentrow#" value="#RECORD_EMP#">
						<input type="hidden" name="record_date#currentrow#" id="record_date#currentrow#" value="#RECORD_DATE#">
						<input type="hidden" name="record_ip#currentrow#" id="record_ip#currentrow#" value="#RECORD_IP#">
						<a onclick="del_relation_row(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
				</td>	
				<td nowrap="nowrap">
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="rel_row_id#currentrow#" id="rel_row_id#currentrow#" value="#GET_RELATION.REL_ROW_ID#">
							<input type="text" name="rel_row_name#currentrow#" id="rel_row_name#currentrow#" value="#GET_RELATION.REL_ROW_NAME#" readonly>
							<span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencr_ac('#currentrow#');"></span>
						</div>
					</div>
				</td>
				<td nowrap="nowrap">		
					<div class="form-group">
						<select name="get_rel#currentrow#" id="get_rel#currentrow#">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="GET_REL_SETUP">
								<option value="#GET_REL_SETUP.SETUP_REL_ID#" <cfif GET_RELATION.RELATION_TYPE_ID eq GET_REL_SETUP.SETUP_REL_ID>selected</cfif>>#SETUP_REL_NAME#</option>
							</cfloop>
						</select>
					</div>
				</td>	
				<td nowrap="nowrap"><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#get_relation.detail#" maxlength="250"></div></td>
					<td nowrap="nowrap">
					<div class="form-group">
						<cfif len(record_emp)>
							#get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,RECORD_DATE),dateformat_style)#
						</cfif>
					</div>
				</td>	
				<td>
					<cfif attributes.action_type_info eq 1>
						<a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#GET_RELATION.REL_ROW_ID#" target="_blank"><i class="fa fa-cube" title="<cf_get_lang dictionary_id ='57771.Detay'>"></i></a>
					<cfelseif attributes.action_type_info eq 2>
						<a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#GET_RELATION.REL_ROW_ID#" target="_blank"><i class="fa fa-cube" title="<cf_get_lang dictionary_id ='57771.Detay'>"></i></a>
					<cfelseif attributes.action_type_info eq 3>
						<a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#GET_RELATION.REL_ROW_ID#" target="_blank"><i class="fa fa-cube" title="<cf_get_lang dictionary_id ='57771.Detay'>"></i></a>
					</cfif>
				</td>
			</tr>	

        	</cfoutput>
		</tbody>
	</cf_grid_list>
	<cf_box_footer>
		<div id="show_user_message" style="float:left;"></div><cf_workcube_buttons is_upd='0' type_format="1" is_cancel="0" add_function='rel_kontrol()'>
	</cf_box_footer>
</cfform>

<script type="text/javascript">
	row_count=<cfoutput>#GET_RELATION.RECORDCOUNT#</cfoutput>;
	function del_relation_row(sy)
	{
		document.getElementById('row_kontrol'+sy).value = 0;
		document.getElementById('frm_row_rel'+sy).style.display="none";
	}
	function add_relation_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("member_relation_table").insertRow(document.getElementById("member_relation_table").rows.length);
		newRow.setAttribute("name","frm_row_rel"+row_count);
		newRow.setAttribute("id","frm_row_rel"+row_count);	
		document.getElementById("record_num").value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="record_emp'+row_count+'" value=""><input type="hidden" name="record_ip'+row_count+'" value=""><input type="hidden" name="record_date'+row_count+'" value=""><input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a onclick="del_relation_row(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="rel_row_name'+row_count+'" value="" readonly> <input type="hidden" name="rel_row_id'+row_count+'" id="rel_row_id'+row_count+'" value=""><span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onClick="pencr_ac('+row_count+');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="get_rel'+row_count+'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="GET_REL_SETUP"><option value="#SETUP_REL_ID#">#SETUP_REL_NAME#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="detail'+row_count+'" value="" maxlength="250"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
	}
	<cfoutput>
		function pencr_ac(no)
		{
			if(document.getElementById('action_type_info').value == 1)//kurumsal üyeler
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&select_list=7&field_comp_id=form_relation.rel_row_id'+no+'&field_comp_name=form_relation.rel_row_name'+no);
			if(document.getElementById('action_type_info').value == 2)//bireysel üyeler
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_cons&select_list=8&field_id=form_relation.rel_row_id'+no+'&field_name=form_relation.rel_row_name'+no);
			if(document.getElementById('action_type_info').value == 3)//sistemler
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_subscription&field_id=form_relation.rel_row_id'+no+'&field_no=form_relation.rel_row_name'+no);
		}
		function rel_kontrol()
		{
			for(var i=1;i<=row_count;i++)
			{
				if(eval("document.form_relation.row_kontrol"+i+"").value==1 && eval("document.form_relation.rel_row_id" + i + "").value == '')
				{
					alert("<cf_get_lang dictionary_id ='34016.Lütfen Kayıt Giriniz'>!");
					return false;
				}
				for(var j=i+1;j<=row_count;j++)
				{
					if(eval("document.form_relation.row_kontrol" + i + "").value==1 && eval("document.form_relation.row_kontrol" + j + "").value==1 && eval("document.form_relation.rel_row_id" + i + "").value==eval("document.form_relation.rel_row_id" + j + "").value)
					{
						alert("<cf_get_lang dictionary_id ='34015.Aynı Kayıdı 2 Kere İlişkili Olarak Ekleyemezsiniz'>!");
						return false;
					}
				}
				if(eval("document.form_relation.row_kontrol" + i + "").value==1 && eval("document.form_relation.rel_row_id" + i + "").value==#attributes.relation_info_id#)
				{
					alert("<cf_get_lang dictionary_id ='34014.Kayıdı Kendisi İle İlişkilendiremezsiniz'>!");
					return false;
				}
			}
			if(document.getElementById('action_type_info').value == 1)
				form_relation.submit();
			else
				AjaxFormSubmit(form_relation,'show_user_message',0,'Kaydediliyor','Kaydedildi','#request.self#?fuseaction=objects.emptypopup_ajax_member_relations&relation_info_id=#attributes.relation_info_id#&action_type_info=#attributes.action_type_info#','div_list_member_rel');return false;
		}
	</cfoutput>
</script>

