<!--- Stopaj Oranı Aktarımı --->
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfif not isdefined("attributes.hedef_period")>
<cfsavecontent variable = "title">
	<cf_get_lang no ='27.stopaj aktarım'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
		
		<form name="form_donem" id="form_donem" method="post"><table>
			<tr>
				<td><cf_get_lang no='1277.Hedef Dönem'></td>
				<td>
					<select name="item_company_id" id="item_company_id" onchange="show_periods_departments(1)" >
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
						</cfoutput>
					</select>
				</td>
				<td>
					<div id="period_div">
						<select name="hedef_period_1" id="hedef_period_1" style="width:220px;">
							<cfif isdefined("attributes.item_company_id") and len(attributes.item_company_id)>
								<cfquery name="get_periods" datasource="#dsn#">
									SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.item_company_id# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
								</cfquery>
								<cfoutput query="get_periods">				
									<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
								</cfoutput>
							</cfif>
						</select>
					</div>
				</td>
				<td><input type="button" value="<cf_get_lang dictionary_id='869.Stopaj Oranı Aktar'>" onClick="basamak_1();"></td>
			</tr></table>
		</form>
		</cf_area>
	<cf_area width="50%">
		<table>
				<tr height="30">
					<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
				</tr>    
				<tr>
					<td valign="top"> 
						<cftry>
							<cfinclude template="#file_web_path#templates/period_help/stopajRateTransfer_#session.ep.language#.html">
							<cfcatch>
								<script type="text/javascript">
									alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
								</script>
							</cfcatch>
						</cftry>
					</td>
				</tr>
			</table>
	</cf_area>					     
</cf_form_box>	
</cfif>

<cfif isdefined("attributes.hedef_period_1")>
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2031.Hedef Period Seçmelisiniz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
	</cfquery>
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.our_company_id#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.PERIOD_YEAR-1#">
	</cfquery>
	<cfif not get_kaynak_period.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2030.Kaynak Period Bulunamadı!Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<form name="form_aktarim" id="form_aktarim" method="post">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.our_company_id#</cfoutput>">
		&nbsp; &nbsp; <cf_get_lang no ='2028.Kaynak Veri Tabani'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		&nbsp; &nbsp; <cf_get_lang no ='2029.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		&nbsp; &nbsp; <input type="button" name="aktarim_button" id="aktarim_button"value="<cf_get_lang no ='2027.Aktarimi Baslat'>" onClick="basamak_2();">
	</form>
</cfif>

<cfif isdefined("attributes.aktarim_hedef_period")>
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
			<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
			<cfset hedef_dsn3 = '#dsn#_#attributes.aktarim_hedef_company#'>
			<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
			<!--- once hedef taboda kayitlar varmi diye bakilir --->
			<cfquery name="select_stopaj_hedef" datasource="#hedef_dsn2#">
				SELECT * FROM SETUP_STOPPAGE_RATES
			</cfquery>
			<cfquery name="select_stopaj_kaynak" datasource="#hedef_dsn2#">
				SELECT * FROM #kaynak_dsn2#.SETUP_STOPPAGE_RATES
			</cfquery>
			<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
			<cfif select_stopaj_hedef.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>");
					history.back();
					window.close;
				</script>
				<cfabort>
			<cfelse>
				<!--- eski donemdeki bilgiler aktarilir --->
				<cfquery name="ADD_SETUP_STOPPAGE_RATES" datasource="#hedef_dsn2#">
					INSERT INTO
						SETUP_STOPPAGE_RATES
					(
						STOPPAGE_RATE,
						STOPPAGE_ACCOUNT_CODE,
						DETAIL,
                        TAX_CODE,
                        TAX_CODE_NAME,
						SETUP_BANK_TYPE_ID,
						RECORD_IP,
						RECORD_DATE,
						RECORD_EMP
                     )
					SELECT 
						STOPPAGE_RATE,
						STOPPAGE_ACCOUNT_CODE,
						DETAIL,
                        TAX_CODE,
                        TAX_CODE_NAME,
						SETUP_BANK_TYPE_ID,
						'#cgi.remote_addr#',
						#now()#,
						#session.ep.userid#
                    FROM 
						#kaynak_dsn2#.SETUP_STOPPAGE_RATES
				</cfquery> 
			</cfif>
		</cftransaction>	
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2020.Islem Basariyla Tamamlanmistir'>");
	</script>
</cfif>
<script type="text/javascript">
	function basamak_1()
	{
		if(confirm("Stopaj Oranı Aktarım İşlemi Yapacaksınız.Bu İşlem Geri Alınamaz.Emin misiniz?"))
			document.form_donem.submit();
		else 
			return false;
	}
		
	function basamak_2()
	{
		if(confirm("Stopaj Oranı Aktarım İşlemi Yapacaksınız.Bu İşlem Geri Alınamaz.Emin misiniz?"))
			document.form_aktarim.submit();
		else 
			return false;
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.item_company_id") and len(attributes.item_company_id))>
			var company_id = document.getElementById('item_company_id').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
		}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('item_company_id').value != '')
			{
				var company_id = document.getElementById('item_company_id').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			}
		}
	}
</script>
