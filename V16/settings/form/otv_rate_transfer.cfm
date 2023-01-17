<script type="text/javascript">
function basamak_1()
	{
	if(confirm("<cf_get_lang dictionary_id='62992.ÖTV Oranı Aktarım İşlemi Yapacaksınız.Bu İşlem Geri Alınamaz.Emin misiniz?'>"))
		document.form_.submit();
	else 
		return false;
	}
	
function basamak_2()
	{
	if(confirm("<cf_get_lang dictionary_id='62992.ÖTV Oranı Aktarım İşlemi Yapacaksınız.Bu İşlem Geri Alınamaz.Emin misiniz?'>"))
		document.form1_.submit();
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
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','ötv aktarım','43701')#">
		<cfif not isdefined("attributes.hedef_period")>	
			<form name="form_" action="" method="post"><table>
				<cf_box_elements>
					<div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-employee_id">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43767.Kaynak Dönem'></label>
							<div class="col col-7 col-md-7 col-sm-7 col-xs-12" >
								<select name="item_company_id" id="item_company_id" onchange="show_periods_departments(1)">
									<cfoutput query="get_companies">
										<option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43260.Hedef Dönem'></label>
							<div class="col col-7 col-md-7 col-sm-7 col-xs-12" id="period_div">
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
						</div>
					</div>
					
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold "></b><cf_get_lang dictionary_id='57433.Yardım'><br/></label>
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62991.Önceki dönemde tanımlı olan ötv oranlarının yeni açılan dönemde tanımlanmasını sağlar.'>
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62987.Hedef Dönem:Aktarım Yapılacak Dönem seçilmelidir.'><br/>
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62988.Aktarım bir kere yapılabilir.'></label>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
						<input type="button" value="<cf_get_lang dictionary_id='62993.ÖTV Oranı Aktar'>" onClick="basamak_1();">
					</div>
				</cf_box_footer>
			</form>
		</cfif>	
		<cfif isdefined("attributes.hedef_period_1")>
			<cfif not len(attributes.hedef_period_1)>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='44014.Hedef Period Seçmelisiniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfquery name="get_hedef_period" datasource="#dsn#">
				SELECT 
					PERIOD_ID, 
					PERIOD, 
					PERIOD_YEAR, 
					IS_INTEGRATED, 
					OUR_COMPANY_ID, 
					PERIOD_DATE, 
					OTHER_MONEY, 
					STANDART_PROCESS_MONEY, 
					RECORD_DATE, 
					RECORD_IP, 
					RECORD_EMP, 
					UPDATE_DATE, 
					UPDATE_IP, 
					UPDATE_EMP, 
					IS_LOCKED, 
					PROCESS_DATE 
				FROM 
					SETUP_PERIOD 
				WHERE 
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
			</cfquery>
			<cfquery name="get_kaynak_period" datasource="#dsn#">
				SELECT 
					PERIOD_ID, 
					PERIOD, 
					PERIOD_YEAR, 
					IS_INTEGRATED, 
					OUR_COMPANY_ID, 
					PERIOD_DATE, 
					OTHER_MONEY, 
					STANDART_PROCESS_MONEY, 
					RECORD_DATE, 
					RECORD_IP, 
					RECORD_EMP, 
					UPDATE_DATE, 
					UPDATE_IP, 
					UPDATE_EMP, 
					IS_LOCKED, 
					PROCESS_DATE 
				FROM 
					SETUP_PERIOD 
				WHERE 
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.OUR_COMPANY_ID#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.PERIOD_YEAR-1#">
			</cfquery>
			<cfif not get_kaynak_period.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='44013.Kaynak Period Bulunamadı! Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<form action="" name="form1_" method="post">
				<cf_box_elements>
					<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
					<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
					<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
					<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
					<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
					<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
					<cf_get_lang dictionary_id='44011.Kaynak Veri Tabanı'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
					<cf_get_lang dictionary_id='44012.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
					<input type="button" value="<cf_get_lang dictionary_id='44010.Aktarımı Başlat'>" onClick="basamak_2();">
				</cf_box_elements>
			</form>
		</cfif>
	</cf_box>	
</div>
<cfif isdefined("attributes.aktarim_hedef_period")>
	<cflock name="#CREATEUUID()#" timeout="70">
	<cftransaction>
		<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
		<cfset hedef_dsn3 = '#dsn#_#attributes.aktarim_hedef_company#'>
		<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
		<!--- once hedef taboda kayitlar varmi diye bakilir --->
		<cfquery name="select_otv_hedef" datasource="#hedef_dsn3#">
			SELECT * FROM SETUP_OTV where PERIOD_ID = #attributes.aktarim_hedef_period#
		</cfquery>	
		<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
		<cfif select_otv_hedef.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='44032.Bu aktarım daha önce yapılmıştır'>!");
				history.back();
				window.close;
			</script>
			<cfabort>
		<cfelse>
			<cfquery name="aktar_otv" datasource="#hedef_dsn3#">
				INSERT INTO
					SETUP_OTV
					(
                        TAX,
						DETAIL,
						ACCOUNT_CODE,
						PURCHASE_CODE,
						ACCOUNT_CODE_IADE,
						PURCHASE_CODE_IADE,
						KDV_ACCOUNT_CODE,
						PERIOD_ID,
						TAX_CODE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						UPDATE_DATE,
						UPDATE_EMP,
						UPDATE_IP,
						TAX_CODE_NAME
					)
                    SELECT 
                        TAX,
						DETAIL,
						ACCOUNT_CODE,
						PURCHASE_CODE,
						ACCOUNT_CODE_IADE,
						PURCHASE_CODE_IADE,
						KDV_ACCOUNT_CODE,
						#attributes.aktarim_hedef_period#,
						TAX_CODE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						UPDATE_DATE,
						UPDATE_EMP,
						UPDATE_IP,
						TAX_CODE_NAME
                    FROM 
                        SETUP_OTV
					WHERE
						PERIOD_ID = #attributes.aktarim_kaynak_period#
			</cfquery> 
			
			<!--- eski donemdeki bilgiler aktarilir --->
		</cfif>
	</cftransaction>	
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44003.İşlem Başarıyla Tamamlanmıştır'>!");
	</script>
</cfif>
