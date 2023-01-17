<cfparam name="attributes.company_id" default="">
<cfif isdefined("attributes.form_submit")>
	<cfset attributes.company_id = session_base.our_company_id>
	<cfinclude template="../../objects/query/get_positions.cfm">
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_positions.recordcount#">	
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.maxrows" default="25">
<cfparam name="attributes.page" default=1>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
		<cfif isdefined("attributes.to_title") and len(attributes.to_title)>
			to_title = <cfoutput>#attributes.to_title#</cfoutput>;
		<cfelse>
			to_title=1;
		</cfif>
        rowCount=0;
		<cfif isdefined("attributes.row_count")>
			rowCount = parseInt(document.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value);
		</cfif>
		function add_checked()
		{
			var counter = 0;
			<cfif get_positions.recordcount gt 1 and attributes.maxrows neq 1>
				for(i=0;i<document.form_name.emp_ids.length;i++) 
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
					}
					if (counter == 0)
					{
						alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
						return false;
					}
			<cfelseif get_positions.recordcount eq 1 or attributes.maxrows eq 1>
				if (document.getElementById('emp_ids').checked == true) 
				{
					counter = counter + 1;
				}
				if (counter == 0)
				{
					alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
					return false;
				}
			</cfif>

			<cfif get_positions.recordcount gt 1 and isdefined("attributes.field_emp_id")  and attributes.maxrows neq 1>
				counter = 0;
				for(i=0;i<document.form_name.emp_ids.length;i++)
					if (document.form_name.emp_ids[i].checked == true) 
					{
						counter = counter + 1;
						var emp_ids = document.form_name.emp_ids[i].value;
						var pos_id = document.form_name.position_id[i].value;
						if (to_title ==1 )
							var name = document.form_name.employee_name[i].value+' '+document.form_name.employee_surname[i].value;
						else
							var name = document.form_name.position_name[i].value;
						var pos_code =document.form_name.position_code[i].value;
						<cfif isDefined('attributes.row_count')>
							rowCount = rowCount + 1;					
						</cfif>
						var ss_int = ekle_str(name,emp_ids,pos_id,pos_code);
					}
				<cfif not (browserDetect() contains 'MSIE')>
					id_ekle();
				</cfif>
				<cfif isDefined('attributes.row_count')>
					document.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value = rowCount;	
				</cfif>
			<cfelseif (get_positions.recordcount eq 1 or attributes.maxrows eq 1) and isdefined("attributes.field_emp_id")>	
				var emp_ids = document.getElementById('emp_ids').value;
				var pos_id = document.getElementById('position_id').value;
				if (to_title == 1)
					var name = document.getElementById('employee_name').value + ' ' + document.getElementById('employee_surname').value;
				else
					var name = document.getElementById('position_name').value;
				rowCount = rowCount + 1;
				var pos_code = document.getElementById('position_code').value;
				var ss_int = ekle_str(name,emp_ids,pos_id,pos_code);			
				document.getElementById("<cfoutput>#attributes.row_count#</cfoutput>").value = rowCount;
				<cfif not (browserDetect() contains 'MSIE')>
					id_ekle();
				</cfif>
			</cfif>
			<cfif isDefined("attributes.url_direction")>
				<cfoutput>
				document.form_name.action='#request.self#?fuseaction=#attributes.url_direction#&'+document.getElementById('url_string').value;
				</cfoutput>
				document.form_name.submit();
			<cfelse>
				/*window.close();*/
			</cfif>
		}
		
		<cfif isdefined("attributes.table_name")>
			function ekle_str(str_ekle,int_id,int_id2,int_id3)
			{
				var newRow;
				var newCell;
				<cfoutput>
					newRow =document.getElementById("#attributes.table_name#").insertRow();	
					newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
					newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
					newRow.setAttribute("style","display:''");	
					newCell = newRow.insertCell();
					str_html = '';
					<cfif isdefined("attributes.field_emp_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_emp_id#" id="#attributes.field_emp_id#" value="' + int_id + '"><input type="hidden" name="#attributes.field_pos_id#" value="' + int_id2 + '">';	
						str_html = str_html + '<input type="hidden" name="#attributes.field_pos_code#" id="#attributes.field_pos_code#" value="' + int_id3 + '">';	
					</cfif>
					<cfif isdefined("attributes.field_comp_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_comp_id#" id="#attributes.field_comp_id#" value=""><input type="hidden" name="#attributes.field_par_id#" value="">';
					</cfif>
					<cfif isdefined("attributes.field_cons_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_cons_id#" id="#attributes.field_cons_id#" value="">';
					</cfif>
					str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" id="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" value="">';
					str_del = '<a href="javascript://"  onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><i class="fa fa-minus"></i></a>&nbsp;';
					newCell.innerHTML = str_del + str_html ;
                    newCell = newRow.insertCell();
                    newCell.innerHTML =  str_ekle  ;
				</cfoutput>
				return 1;
			 }
			 //sadece safari için kullanılır...
			 function id_ekle()
			 {
				<cfoutput>
					 if('#attributes.function_row_name#'=='workcube_cc_delRow')
					 {
						if(document.all.cc_emp_ids.length==undefined)
						{
							document.upd_work.appendChild(document.getElementById("cc_emp_ids"));
							document.upd_work.appendChild(document.getElementById("cc_pos_codes"));
							document.upd_work.appendChild(document.getElementById("cc_pos_ids"));
						}
						else
						{
							for(var i=0;i<document.all.cc_emp_ids.length;i++)
							{
								document.upd_work.appendChild(document.all.cc_emp_ids[i]);
								document.upd_work.appendChild(document.all.cc_pos_codes[i]);
								document.upd_work.appendChild(document.all.cc_pos_ids[i]);
							}
						}
					}
					else if('#attributes.function_row_name#'=='workcube_cc2_delRow')
					{
						if(document.all.cc2_emp_ids.length==undefined)
						{
							document.upd_work.appendChild(document.getElementById("cc2_emp_ids"));
							document.upd_work.appendChild(document.getElementById("cc2_pos_codes"));
							document.upd_work.appendChild(document.getElementById("cc2_pos_ids"));
						}
						else
						{
							for(var i=0;i<document.all.cc2_emp_ids.length;i++)
							{
								document.upd_work.appendChild(document.all.cc2_emp_ids[i]);
								document.upd_work.appendChild(document.all.cc2_pos_codes[i]);
								document.upd_work.appendChild(document.all.cc2_pos_ids[i]);
							}
						}
					}
					else
					{
						if(document.all.to_emp_ids.length==undefined)
						{
							document.upd_work.appendChild(document.getElementById("to_emp_ids"));
							document.upd_work.appendChild(document.getElementById("to_pos_codes"));
							document.upd_work.appendChild(document.getElementById("to_pos_ids"));
						}
						else
						{
							for(var i=0;i<document.all.to_emp_ids.length;i++)
								{
									document.upd_work.appendChild(document.all.to_emp_ids[i]);
									document.upd_work.appendChild(document.all.to_pos_codes[i]);
									document.upd_work.appendChild(document.all.to_pos_ids[i]);
								}
							}
					}
				</cfoutput>
			}
		</cfif>
	</script>
</cfif>

<cfset url_string = ''>
<cfif IsDefined("attributes.url_params") and Len(attributes.url_params)>
	<cfloop list="#attributes.url_params#" index="urlparam">
		<cfset url_string = "#url_string#&#urlparam#=#evaluate('attributes.'&urlparam)#">
	</cfloop>
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_string = '#url_string#&company_id=#attributes.company_id#'>
</cfif>
<cfif isDefined('attributes.field_emp_id') and len(attributes.field_emp_id)>
	<cfset url_string = '#url_string#&field_emp_id=#attributes.field_emp_id#'>
</cfif>
<cfif isDefined('attributes.field_pos_id') and len(attributes.field_pos_id)>
	<cfset url_string = '#url_string#&field_pos_id=#attributes.field_pos_id#'>
</cfif>
<cfif isDefined('attributes.field_pos_code') and len(attributes.field_pos_code)>
	<cfset url_string = '#url_string#&field_pos_code=#attributes.field_pos_code#'>
</cfif>
<cfif isDefined('attributes.field_par_id') and len(attributes.field_par_id)>
	<cfset url_string = '#url_string#&field_par_id=#attributes.field_par_id#'>
</cfif>
<cfif isDefined('attributes.field_company_id') and len(attributes.field_company_id)>
	<cfset url_string = '#url_string#&field_company_id=#attributes.field_company_id#'>
</cfif>
<cfif isDefined('attributes.field_cons_id') and len(attributes.field_cons_id)>
	<cfset url_string = '#url_string#&field_cons_id=#attributes.field_cons_id#'>
</cfif>
<cfif isDefined('attributes.table_name') and len(attributes.table_name)>
	<cfset url_string = '#url_string#&table_name=#attributes.table_name#'>
</cfif>
<cfif isDefined('attributes.table_row_name') and len(attributes.table_row_name)>
	<cfset url_string = '#url_string#&table_row_name=#attributes.table_row_name#'>
</cfif>
<cfif isDefined('attributes.field_grp_id') and len(attributes.field_grp_id)>
	<cfset url_string = '#url_string#&field_grp_id=#attributes.field_grp_id#'>
</cfif>
<cfif isdefined('attributes.field_wgrp_id') and len(attributes.field_wgrp_id)>
	<cfset url_string = '#url_string#&field_wgrp_id=#attributes.field_wgrp_id#'>
</cfif>
<cfif isdefined('attributes.function_row_name') and len(attributes.function_row_name)>
	<cfset url_string = '#url_string#&function_row_name=#attributes.function_row_name#'>
</cfif>
<cfif isdefined('attributes.row_count') and len(attributes.row_count)>
	<cfset url_string = '#url_string#&row_count=#attributes.row_count#'>
</cfif>
<cfif isdefined('attributes.url_direction') and len(attributes.url_direction)>
	<cfset url_string = '#url_string#&url_direction=#attributes.url_direction#'>
</cfif>
<cfsavecontent  variable="title"><cf_get_lang dictionary_id='56690.Kişiler'></cfsavecontent>
<cfform name="search" action="widgetloader?widget_load=listMultiUsers&isbox=1&style=maxi&title=#title#&#url_string#" method="post">    
    <input type="hidden" name="form_submit" id="form_submit" value="1">
    <div class="form-row">
        <div class="form-group col-lg-3">
            <cfinput type="text" class="form-control" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#getLang('','',57460)#">
        </div>
        <div class="form-group col-lg-3">        
            <button type="button" id="search_btn" class="btn font-weight-bold text-uppercase btn-color-7" onclick="loadPopupBox('search','<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
        </div>
    </div>
           
</cfform>

<form action="" method="post" name="form_name">
    <div class="table-responsive ui-scroll">
        <table class="table table-hover">
            <thead class="main-bg-color">
                <tr>
                    <th></th>
                    <th><cf_get_lang_main no='158.Ad Soyad'></th>
                    <th><cf_get_lang_main no='1085.Pozisyon'></th>
                    <th><cf_get_lang_main no='377.Özel Kod'></th>
                    <th><cf_get_lang_main no='580.Bölge'></th>
                    <th><cf_get_lang_main no='41.Şube'></th>
                    <th><cf_get_lang_main no='160.Departman'></th>
                    <th style="width:20px;"><cfif get_positions.recordcount><input type="Checkbox" name="all_" id="all_" value="1" onclick="javascript: hepsi();"></cfif></td>
                </tr>
            </thead>
            <tbody>
                <cfif get_positions.recordcount>
                    <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td align="center" style="width:25px;"><cf_online id="#employee_id#" zone="ep"></td>
                            <td>#employee_name# #employee_surname#</td>
                            <td>#position_name#</td>
                            <td>#ozel_kod#</td>
                            <td>#zone_name#</td>
                            <td>#branch_name#</td>
                            <td>#department_head#</td>
                            <td>
                                <input type="checkbox" name="emp_ids" id="emp_ids" value="#employee_id#">
                                <input type="hidden" name="employee_name" id="employee_name" value="#employee_name#">
                                <input type="hidden" name="employee_surname" id="employee_surname" value="#employee_surname#">
                                <input type="hidden" name="employee_email" id="employee_email" value="#employee_email#">
                                <input type="hidden" name="position_id" id="position_id" value="#position_id#">
                                <input type="hidden" name="position_name" id="position_name" value="#position_name#">
                                <input type="hidden" name="position_code" id="position_code" value="#position_code#">
                                <input type="hidden" name="branch_name" id="branch_name" value="#branch_name#">
                                <input type="hidden" name="department_head" id="department_head" value="#department_head#">
                            </td>
                        </tr>
                    </cfoutput>
                    <tr class="color-list">
                        <td style="text-align:right;" colspan="8"><input type="button" value="<cf_get_lang_main no='49.Kaydet'>" onclick="add_checked();" class="btn font-weight-bold text-uppercase btn-color-7"></td>
                    </tr>
                <cfelse>
                    <tr>
                        <td colspan="8" align="left"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
            <input type="hidden" name="record_type" id="record_type" value="employee">
            <input type="hidden" name="modal_id" id="modal_id" value=<cfif isdefined('attributes.draggable')>"#attributes.modal_id#"</cfif>>
            <input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">
        </table>
    </div>
</form>
<cfif len(attributes.keyword)>
	<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
</cfif>
<cfif len(attributes.position_cat_id)>
	<cfset url_string = '#url_string#&position_cat_id=#attributes.position_cat_id#'>
</cfif>

<cfif attributes.totalrecords gt attributes.maxrows>
    <table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
            <td>
                <cf_pages 
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="widgetloader?widget_load=listMultiUsers&isbox=1&style=maxi&title=#title#&#url_string#&form_submit=1" 
                    isAjax="1">
            </td>
            <td style="text-align:right"><cfoutput><cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Page'>:#attributes.page#/#lastpage#</cfoutput> </td>
        </tr>
    </table>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.form_submit")>
		function hepsi()
		{
			if (document.getElementById('all_').checked)
			{
				<cfif get_positions.recordcount gt 1 and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) document.form_name.emp_ids[i].checked = true;
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					document.getElementById('emp_ids').checked = true;
				</cfif>
			}
			else
			{
				<cfif get_positions.recordcount gt 1  and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.emp_ids.length;i++) document.form_name.emp_ids[i].checked = false;
				<cfelseif get_positions.recordcount eq 1 or  attributes.maxrows eq 1>
					document.getElementById('emp_ids').checked = false;
				</cfif>
			}
		}
	</cfif>
	document.getElementById('keyword').focus();
</script>
