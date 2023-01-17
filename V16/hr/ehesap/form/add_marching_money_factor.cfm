<cfif isdefined('attributes.money_main_id')>
	<cfinclude template="../query/get_marching_money_factor.cfm">
	<cfif get_marching_money.recordcount>
		<cfquery name="get_rows" datasource="#dsn#">
			SELECT
				MARCH_MONEY_ID,
				MARCHING_MONEY_MAIN_ID,
				DOMESTIC_FACTOR,
				OVERSEAS_FACTOR
			FROM
				MARCHING_MONEY_FACTORS
			WHERE	
				MARCHING_MONEY_MAIN_ID = #get_marching_money.MARCHING_MONEY_MAIN_ID#
		</cfquery>
	<cfelse>
		<cfset get_rows.recordcount = 0>
	</cfif>
</cfif>
<!---<cfinclude template="../../query/get_position_cats.cfm">--->
<cfinclude template="../../query/get_titles.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="47119.Harcırah Katsayıları"></cfsavecontent>
<cf_box title="#message#" uidrop="1" hide_table_column="1" responsive_table="1">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_marching_money_factor" name="add_factor" method="post">
		<cfif isdefined('attributes.money_main_id')>
			<input name="record_num" id="record_num" type="hidden" value="0">
			<cfset start_ = dateformat(get_marching_money.start_date,dateformat_style)>
			<cfset finish_ = dateformat(get_marching_money.finish_date,dateformat_style)>
			<input type="hidden" name="money_main_id" value="<cfoutput>#get_marching_money.MARCHING_MONEY_MAIN_ID#</cfoutput>">
		<cfelse>
			<input name="record_num" id="record_num" type="hidden" value="0">
			<cfset start_ = ''>
			<cfset finish_ = ''>
		</cfif>
		<cf_box_search>
			<div class="form-group">
				<label class="text-center"><cf_get_lang dictionary_id="58690.Tarih Aralığı"> *</label>
			</div>
			<div class="form-group">
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
						<cfinput type="text" name="startdate" style="width:60px;" maxlength="10" validate="#validate_style#" message="#message#" required="yes" value="#start_#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>	
					</div>
				</div>           
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
						<cfinput type="text" name="finishdate" style="width:60px;" maxlength="10" validate="#validate_style#" message="#message#" required="yes" value="#finish_#">	
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>															
			</div>
		</cf_box_search>
		<br/>
		<cf_grid_list>
			<thead>
				<tr>
					<th><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
					<th style="width:160px;">&nbsp;<cf_get_lang dictionary_id ='57571.Ünvan'> *</th>
					<th style="width:160px;">&nbsp;<cf_get_lang dictionary_id ='29691.Yurtiçi'> <cf_get_lang dictionary_id ='36455.Katsayı'> *</th>
					<th style="width:160px;">&nbsp;<cf_get_lang dictionary_id ='29692.Yurtdışı'> <cf_get_lang dictionary_id ='36455.Katsayı'> *</th>
				</tr>
			</thead>
			<tbody id="link_table">
			<cfif isdefined("get_rows")  and get_rows.recordcount>
				<cfoutput query="get_rows">
					<tr id="my_row_#currentrow#">
						<input type="hidden" name="row_kontrol_#currentrow#" value="1" />
						<td><a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a></td>
						<td>
							<cfquery name="get_title" datasource="#dsn#">
								SELECT TITLE_ID FROM MARCHING_MONEY_POSITION_CATS WHERE MARCH_MONEY_ID = #MARCH_MONEY_ID#
							</cfquery>
							<select name="title_ids#currentrow#" id="title_ids#currentrow#" multiple="multiple" style="height:300px;">
								<cfloop query="titles">
								<option value="#title_id#"<cfif listlen(valuelist(get_title.title_id,',')) and listfind(valuelist(get_title.title_id,','),title_id,',')>selected</cfif>>#title#</option>
								</cfloop>
							</select>					
						</td>
						<td><input name="DOMESTIC_FACTOR#currentrow#" type="text" style="width:100px;" class="moneybox" value="#DOMESTIC_FACTOR#"></td>
						<td><input name="OVERSEAS_FACTOR#currentrow#" type="text" style="width:100px;" class="moneybox" value="#OVERSEAS_FACTOR#"></td>
					</tr>
				</cfoutput>
			</cfif>
			</tbody>
		</cf_grid_list>		
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="kontrol()">
		</cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	<cfif isdefined("get_rows") and get_rows.recordcount>
		row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
	function kontrol()
	{
		document.add_factor.record_num.value=row_count;
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='54622.Bir Kayıt Giriniz'>!");
			return false;
		}
		for(var j=1;j<=row_count;j++)
		{
			if(eval("document.add_factor.row_kontrol_"+j).value==1)
			{
				var katsayi1 = eval('document.add_factor.DOMESTIC_FACTOR'+j+'.value');
				if(katsayi1 == '')
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36455.Katsayı'>");
					return false;
				}
				var position_cat = eval('document.add_factor.title_ids'+j+'.value');
				if(position_cat == '')
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57571.Ünvan'>");
					return false;
				}
			}
		}
	}	
	function sil(sy)
	{
		var my_element=eval("document.add_factor.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		document.add_factor.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><select name="title_ids' + row_count +'" id="title_ids' + row_count +'" multiple="multiple" style="height:300px;"><cfoutput query="titles"><option value="#title_id#">#title#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input name="DOMESTIC_FACTOR' + row_count +'" type="text" style="width:100px;" class="moneybox">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input name="OVERSEAS_FACTOR' + row_count +'" type="text" style="width:100px;" class="moneybox">';
	}
</script>
