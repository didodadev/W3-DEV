<cfquery name="GET_REQUEST_ROW" datasource="#DSN#">
	SELECT
		ASSET_P_REQUEST_ROW.*
	FROM
		ASSET_P_REQUEST_ROW,
		ASSET_P_REQUEST
	WHERE
		ASSET_P_REQUEST.REQUEST_ID = #request_id# AND
		ASSET_P_REQUEST.REQUEST_ID = ASSET_P_REQUEST_ROW.REQUEST_ID
</cfquery>
<cfset row_kontrol_sabit = get_request_row.recordcount>
<cfquery name="GET_BRAND" datasource="#DSN#">
	SELECT BRAND_ID,BRAND_NAME FROM SETUP_BRAND WHERE MOTORIZED_VEHICLE = 1 ORDER BY BRAND_NAME
</cfquery>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr>
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr valign="middle">
                <td class="txtbold" colspan="5"><cf_get_lang no='737.Alış Talebi Güncelleme'></td>
              </tr>
              <tr id="list_correspondence1_menu2">
                <td class="color-row" valign="top">
                        <table name="table1" id="table1" width="100%">
                          <tr class="txtboldblue">
                            <td width="130px"><cf_get_lang_main no='344.Durum'></td>
							<td width="130px"><cf_get_lang no='101.Talep Tipi'></td>
							<td width="130px"><cf_get_lang_main no='1435.Marka'></td>
							<td width="130px"><cf_get_lang_main no='2244.Marka Tipi'></td>
							<td width="50px"><cf_get_lang_main no='1043.Yıl'></td>
                            <td width="95px"><cf_get_lang no='777.Pert'></td>
							<td width="50px"><cf_get_lang_main no='670.Adet'></td>		
                            <td>
							<input name="record_num" id="record_num" type="hidden" value="0">
							<input name="record_num_sabit" id="record_num_sabit" type="hidden" value="<cfoutput>#row_kontrol_sabit#</cfoutput>">
                              	<a href="javascript://" onClick="add_row();">
                                <img src="/images/plus_list.gif" alt="<cf_get_lang no='737.Alış Talebi Güncelleme'>" border="0"></a></td>
                          </tr>
                          <tr> 
                          <cfset upd_status = 0>
						  <cfoutput query="get_request_row">
                            <cfset my_status = get_request_row.VALID_STATUS_ID>
							<cfset my_brand = BRAND_ID>
							 <input type="hidden" name="row_id_sabit#currentrow#" id="row_id_sabit#currentrow#" value="#request_row_id#">	
							<tr id="frm_row_sabit#currentrow#">
                              <td>
							  <cfquery name="GET_LINE_NUMBER" datasource="#dsn#">
								SELECT LINE_NUMBER,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #my_status#
							 </cfquery>
							 
							  <cfif GET_LINE_NUMBER.LINE_NUMBER neq 1>
							  		<cfset upd_status = 1>
							  </cfif>							  
							  <input type="hidden" name="process_cat_sabit" id="process_cat_sabit" value="#get_line_number.line_number#">	
							 #GET_LINE_NUMBER.STAGE#	  								
							  </td>
							  <td>
							  	<cfif is_new_kontrol eq 1><cf_get_lang no ='745.Yeni Plaka'><cfelse><cf_get_lang no ='746.Pertli Plaka'></cfif>
							  </td>
							  <td><input  type="hidden" value="1" name="row_kontrol_sabit#currentrow#" id="row_kontrol_sabit#currentrow#">
                                   <cfloop query="get_brand">
                                   		<cfif get_brand.brand_id eq my_brand>#brand_name#</cfif>
                                   </cfloop>
								</td>
                              <td>#brand_type#</td>
                              <td>#make_year#</td>
                              <td>
									<cfset x = "">
									<cfif len(pert_id)>
										<cfquery  name="GET_ASSETP" datasource="#DSN#">
											SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #pert_id#
										</cfquery>
										<cfset x = get_assetp.assetp>
									</cfif>
									#x#
								</td>
                              <td>#quantity#</td>
                              <td><a style="cursor:pointer" onclick="sil_sor_sabit('#currentrow#');"><img  src="images/delete_list.gif" alt="Sil" border="0" align="absmiddle"></a></td>
                            </tr>
                          </cfoutput>
                        </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<cfsavecontent variable="satir_process"><cf_workcube_process process_action_dsn="#dsn#" is_upd="0" process_cat_width="140" is_detail="0"></cfsavecontent>
<script type="text/javascript">
	row_count_sabit=<cfoutput>#row_kontrol_sabit#</cfoutput>;
	row_count=0;
	
	function process_cat_control()
		{
			if (add_purchase_request.process_cat.length != undefined) /*n tane*/
			{
			for (i=0; i < add_purchase_request.process_cat.length; i++)
				{
				if(document.add_purchase_request.process_cat[i].value == '')
					{
					alert("cf_get_lang no='739.Araç Talebi Ekleme Yetkiniz Yok'>!")
					return false;
					}
				}
			}
		else /*1 tane*/ 
			{			
			if(document.add_purchase_request.process_cat.value == '')
				{
				alert("cf_get_lang no='739.Araç Talebi Ekleme Yetkiniz Yok'>!")
				return false;
				}
			}
		}
	
	function sil(sy)
	{
		var my_element=eval("upd_assetp_request.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function sil_sabit(sy)
	{
		var my_element=eval("upd_assetp_request.row_kontrol_sabit"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_sabit"+sy);
		my_element.style.display="none";
	}
	
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}

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
					
		document.getElementById('record_num').value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><select name="purchase_type_id' + row_count +'" id="purchase_type_id' + row_count +'" style="width:100px" onChange="change_pert('+ row_count +');"><cfoutput><option value="1"><cf_get_lang no ="745.Yeni Plaka"></option><option value="2"><cf_get_lang no ="746.Pertli Plaka"></option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="brand_id' + row_count +'" id="brand_id' + row_count +'" style="width:130px"><cfoutput query="get_brand"><option value="#brand_id#">#brand_name#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="" name="brand_type' + row_count +'" id="brand_type' + row_count +'" style="width:130px">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="" name="make_year' + row_count +'" id="make_year' + row_count +'" style="width:50px">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<span id="record' + row_count +'" style="display:none;"><input type="hidden" name="assetp_id'+ row_count +'" id="assetp_id'+ row_count +'"><input type="text" name="assetp_name' + row_count +'" id="assetp_name' + row_count +'" style="width:75px;" value="" readonly=yes;"><a href="javascript://" onClick="get_pert(' + row_count + ');"><img border="0" src="/images/plus_list.gif" alt="" align="absmiddle"></a></span>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text"  value="1"  name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:50px">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" border="0" alt="" align="absmiddle"></a>';							
	}		

	function get_pert(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_assetp_request.assetp_id' + row_count + '&field_name=upd_assetp_request.assetp_name'+ row_count,'list');
	}

	function sil_sor(param)
	{
		if(confirm("<cf_get_lang no ='733.Silme işlemi yapacaksınız Emin misiniz'>"))
			sil(param);	
		else
			return false;
	}
	
	function sil_sor_sabit(param)
	{
		if(confirm("<cf_get_lang no ='733.Silme işlemi yapacaksınız Emin misiniz'>?"))
			sil_sabit(param);	
		else
			return false;
	}
	
	function change_pert(no)
	{
			x = eval("document.upd_assetp_request.purchase_type_id"+no+".selectedIndex");
			if (eval("document.upd_assetp_request.purchase_type_id"+no+"["+x+"].value") != 1)
	{
			goster(eval("record"+no));			
	}
			else		
			gizle(eval("record"+no));
	}
</script>
