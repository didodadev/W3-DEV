<cfinclude template="../query/get_pro_work_cat.cfm">
<cfquery name="GET_CATS" datasource="#DSN#">
	SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
</cfquery>

<cfquery name="GET_STAGES" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.popup_add_work%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">İş Ekle</td>
	</tr>
</table>

<cfform name="add_work" action="#request.self#?fuseaction=pda.emptypopup_add_work" method="post">
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
			<table align="center" style="width:99%">
				<tr>
					<td style="width:30%"><cf_get_lang_main no="1408.Başlık">*</td>
					<td><cfsavecontent variable="msg"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1408.Başlık"></cfsavecontent>
						<cfinput type="text" name="work_head" id="work_head" value="" required="yes" message="#msg#" style="width:193px;">
                    </td>
				</tr> 
                <cfif isDefined('xml_project') and xml_project eq 1>
                    <tr>
                        <td><cf_get_lang_main no="4.Proje">*</td>
                        <td>
                            <input type="hidden" name="project_id" id="project_id" value="0">
                            <cfsavecontent variable="msg"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="4.Proje"></cfsavecontent>
                            <cfinput type="text" name="project_head" id="project_head" value="" required="yes" message="#msg#" style="width:160px;">
                            <a href="javascript://" onclick="get_project_div();"><img src="/images/buyutec.jpg" title="<cf_get_lang_main no='1385.Proje Seçiniz'>" align="absmiddle" border="0" class="form_icon"></a>
                        </td>
                    </tr>
					<tr><td colspan="2"><div id="project_div" style="display:none;"></div></td></tr>                
				</cfif>
				<tr>
					<td><cf_get_lang_main no="157.Görevli">*</td>
					<td>
                    	<input type="hidden" name="employee_id" id="employee_id" value="">
                        <cfsavecontent variable="msg"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="157.Görevli"></cfsavecontent>
						<cfinput type="text" name="responsable_name" id="responsable_name" value="" required="yes" message="#msg#" style="width:163px;"> 
						<a href="javascript://" onclick="get_employee_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
					</td>
				</tr>
				<tr><td colspan="2"><div id="employee_div" style="display:none;"></div></td></tr>
				<tr>
					<td><cf_get_lang_main no="74.Kategori">*</td>
					<td>
						<select name="pro_work_cat" id="pro_work_cat" style="width:200px;" onchange="LoadStages();">
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<cfoutput query="get_work_cat">
								<option value="#work_cat_id#">#work_cat#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="73.Öncelik"></td>
					<td>
						<select name="priority_cat" id="priority_cat" style="width:200px;">
							<cfoutput query="get_cats">
								<option value="#priority_id#">#priority#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="70.Aşama"></td>
					<td>
						<select name="work_currency" id="work_currency" style="width:200px;">
                        	<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<!---<cfoutput query="get_stages">
								<option value="#process_row_id#">#stage#</option>
							</cfoutput>--->
					  	</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="1055.Başlama"></td>
					<td>
						<cfif isDefined("attributes.date")>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="243.Başlama Tarihi"></cfsavecontent>
							<cfinput type="text" name="work_h_start" id="work_h_start" value="#dateformat(attributes.date,'dd/mm/yyyy')#" maxlength="10" required="yes" validate="eurodate" message="#message#" style="vertical-align:top;width:85px;">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="243.Başlama Tarihi"></cfsavecontent>
							<cfinput type="text" name="work_h_start" id="work_h_start" value="#dateformat(now(),'DD/MM/YYYY')#" maxlength="10" required="yes" validate="eurodate" message="#message#" style="vertical-align:top;width:85px;">
						</cfif>
						<cf_wrk_date_image date_field="work_h_start">
						<cfoutput>
							<select name="start_hour" id="start_hour" style="width:65px;">
								<cfloop from="0" to="23" index="i">
									<option value="#i#" <cfif i eq 0>selected</cfif>>#i#:00</option>
								</cfloop>
							</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="90.Bitiş"></td>
					<td>
						<cfif isDefined("attributes.date")>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
							<cfinput type="text" name="work_h_finish" id="work_h_finish" value="#dateformat(attributes.date,'dd/mm/yyyy')#" maxlength="10" style="vertical-align:top;width:85px;" required="yes" message="#message#" validate="eurodate">
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
							<cfinput type="text" name="work_h_finish" id="work_h_finish" value="#dateformat(now(),'DD/MM/YYYY')#" maxlength="10" style="vertical-align:top;width:85px;" required="yes" message="#message#" validate="eurodate">
						</cfif>
						<cf_wrk_date_image date_field="work_h_finish">
						<cfoutput>
							<select name="finish_hour" id="finish_hour" style="width:65px;">
							<cfloop from="0" to="23" index="i">
								<option value="#i#" <cfif i eq 0>selected</cfif>>#i#:00</option>
							</cfloop>
							</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="vertical-align:top"><cf_get_lang_main no="217.Açıklama"></td>
					<td><textarea name="work_detail" id="work_detail"></textarea></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td class="color-row" style="vertical-align:top;width:20%">
			<cfsavecontent variable="info">Bilgi Verilecekler</cfsavecontent>
			<cf_workcube_to_cc
            			is_update="0"
            			cc_dsp_name="#info#"
            			form_name="add_work"
            			str_list_param="1,7"
            			data_type="2">
		</td>
    </tr>
</table>
<br/>
</cfform>

<script type="text/javascript">
	function LoadStages()
	{   
		var stage_len = document.getElementById('work_currency').options.length;
		for(j=stage_len;j>=0;j--)
		{
			eval('document.getElementById("work_currency")').options[j] = null;
		}
		
		if(document.getElementById('pro_work_cat').value != '')
		{    
			var deger=workdata('get_work_cat_stages',document.getElementById('pro_work_cat').value);
			eval('document.getElementById("work_currency")').options[0] = new Option('Seçiniz','');
			if(deger.recordcount)
			{
				for(var jj=0;jj < deger.recordcount;jj++)
					eval('document.getElementById("work_currency")').options[jj+1]=new Option(deger.STAGE[jj],deger.PROCESS_ROW_ID[jj]);
			}
		}
		else
		{
			eval('document.getElementById("work_currency")').options[0] = new Option('Seçiniz','');
		}
	}

	function kontrol()
	{
		x = document.getElementById('pro_work_cat').selectedIndex;
		if (document.getElementById('pro_work_cat')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
			return false;
		}
	}
		
	function get_employee_div()
	{
		if(document.getElementById('responsable_name').value.length < 3)
		{
			alert("Lütfen görevli alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(employee_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_employee_div&project_emp_id='+ encodeURI(document.getElementById('responsable_name').value) +'','employee_div');		
		return false;
	}
	
	function get_project_div()
	{
		goster(project_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_project_div&project_id='+ encodeURI(document.getElementById('project_head').value) +'','project_div');		
		return false;
	}
		
	function add_project_div(project_id, project_head)
	{
		document.getElementById('project_id').value = project_id;
		document.getElementById('project_head').value = project_head;
		gizle(project_div);
	}
</script>

