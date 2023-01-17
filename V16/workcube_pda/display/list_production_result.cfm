<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.start_date2" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.finish_date2" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_fis_type" default="">
<cfquery name="GET_WORKSTATIONS" datasource="#DSN#">
	SELECT
		STATION_ID,
    	STATION_NAME
	FROM 
    	#dsn3_alias#.WORKSTATIONS 
	WHERE 
		ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
    	DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">) 
	ORDER BY
		STATION_NAME ASC
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:35px;">
		<td class="headbold">Üretim Sonuçları</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
		<cfform name="form_production" method="post" action="">
			<table border="0">
			  	<input type="hidden" name="is_submit" id="is_submit" value="1" />
				<tr>
					<td style="width:70px;">İstasyon*</td>
					<td style="width:200px;">
						<select name="station_id" id="station_id" style="width:150px;">
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<option value="0" <cfif attributes.station_id eq 0>selected</cfif>>İstasyonu Boş Olanlar</option>
							<cfoutput query="get_workstations">
								<option value="#station_id#" <cfif attributes.station_id eq get_workstations.station_id>selected</cfif>>#station_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td>Stok Fişi</td>
					<td><select name="stock_fis_type" id="stock_fis_type" style="width:150px;">
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<option value="1" <cfif attributes.stock_fis_type eq 1>selected</cfif>>Oluşturulmuş</option>
							<option value="0" <cfif attributes.stock_fis_type eq 0>selected</cfif>>Oluşturulmamış</option>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='245.Ürün'>*</td>
					<td><cfoutput>
						<input type="hidden" name="product_id" id="product_id" value="<cfif Len(attributes.product_id)>#attributes.product_id#</cfif>">
						<input type="text" name="product_name" id="product_name" value="<cfif Len(attributes.product_id)>#attributes.product_name#</cfif>" style="width:150px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {getProduct('show_product_div');}">
						<a href="javascript://" onclick="getProduct('show_product_div');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
						</cfoutput>
					</td>
			  	</tr>
				<tr>
					<td><cf_get_lang_main no='641.Başlangıç Tarihi'></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
		  				<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
		 				 <cf_wrk_date_image date_field="start_date">
			
						 <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
						 <cfinput type="text" name="start_date2" id="start_date2" value="#dateformat(attributes.start_date2,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
		  				<cf_wrk_date_image date_field="start_date2">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
		  				<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
		 				 <cf_wrk_date_image date_field="finish_date">
			
						 <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
						 <cfinput type="text" name="finish_date2" id="finish_date2" value="#dateformat(attributes.finish_date2,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
		  				<cf_wrk_date_image date_field="finish_date2">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="button" value="Listele" onclick="kontrol_prerecord('kontrol_prerecord_div');"></td>
				</tr>
				<tr>
					<td colspan="2"><div id="show_product_div"></div></td>
				</tr>
				<tr>
					<td colspan="2"><div id="kontrol_prerecord_div"></div></td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
</table>
<br/>
<script type="text/javascript">
	function getProduct(div_name)
	{
		if(document.getElementById("product_name").value.length <= 2)
		{
			alert("Lütfen Listelemek İçin En Az 3 Karakter Giriniz !");
			return false;
		}
		goster(document.getElementById(div_name));
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_product_div&keyword='+encodeURI(document.getElementById("product_name").value)+'&list=1&div_name='+div_name,div_name);
		return false;
	}
	function kontrol_prerecord(div_name)
	{
		if(document.getElementById("station_id").value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1422.İstasyon'>");
			return false;
		}
		if(document.getElementById("product_id").value == "" || document.getElementById("product_name").value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='245.Ürün'>");
			return false;
		}
		goster(document.getElementById(div_name));
		if(document.getElementById("station_id").value == "")
			var form_values = '&station_id=<cfoutput>#ValueList(get_workstations.station_id,",")#</cfoutput>';
		else
			var form_values = '&station_id='+document.getElementById("station_id").value;
		var form_values = form_values + '&stock_fis_type='+document.getElementById("stock_fis_type").value;
		var form_values = form_values + '&product_id='+document.getElementById("product_id").value + '&product_name='+document.getElementById("product_name").value;
		var form_values = form_values + '&start_date='+document.getElementById("start_date").value + '&start_date2='+document.getElementById("start_date2").value;
		var form_values = form_values + '&finish_date='+document.getElementById("finish_date").value + '&finish_date2='+document.getElementById("finish_date2").value;
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_production_result'+form_values,div_name,1);
		return false;
	}
</script>
