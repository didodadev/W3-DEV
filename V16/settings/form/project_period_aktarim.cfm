<script type="text/javascript">
function basamak_1()
	{
	if(confirm("<cf_get_lang dictionary_id='44008.Dönem Aktarım İşlemi Yapacaksınız!!! Bu İşlem Geri Alınamaz!!! Emin misiniz'>"))
		document.form_.submit();
	else 
		return false;
	}
	
function basamak_2()
	{
	if(confirm("<cf_get_lang dictionary_id='44008.Dönem Aktarım İşlemi Yapacaksınız!!! Bu İşlem Geri Alınamaz!!! Emin misiniz'>"))
		document.form1_.submit();
	else 
		return false;
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
	<cf_box title="#getLang('','Proje Dönem Aktarım','43537')#">	
		<form action="" method="post" name="form_">
			<cf_box_elements>
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group"  id="item-company_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43767.Kaynak Dönem'></label>
						<div class="col col-7 col-md-7 col-sm-7 col-xs-12" >
							<select name="item_company_id" id="item_company_id" onchange="show_periods_departments(1)">
								<cfoutput query="get_companies">
									<option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-employee_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43260.Hedef Dönem'></label>
						<div class="col col-7 col-md-7 col-sm-7 col-xs-12" id="period_div">
							<select name="hedef_period_1" id="hedef_period_1">
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
				
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold "></b><cf_get_lang dictionary_id='57433.Yardım'><br/></label>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62997.Önceki dönemde tanımlı olan proje muhasebe kodlarının, yeni açılan dönemde de tanımlı olmasını sağlar.'>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62987.Hedef Dönem:Aktarım Yapılacak Dönem seçilmelidir.'><br/>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62995.Herhangi bir durumda tekrar çalıştırılmasında bir sakınca yoktur.'></label>
				</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
						<input type="button" value="<cf_get_lang dictionary_id='43996.Dönem Aktar'>" onClick="basamak_1();">
					</div>
				</cf_box_footer>
		</form>	
		<cfif isdefined("attributes.hedef_period_1")>
			<cfif not len(attributes.hedef_period_1)>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='44014.Hedef Period Seçmelisiniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
	
			<cfquery name="get_hedef_period" datasource="#dsn#">
				SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
			</cfquery>
			
			<cfquery name="get_kaynak_period" datasource="#dsn#">
				SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.our_company_id#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.period_year-1#">
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
					<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.our_company_id#</cfoutput>">
					<cf_get_lang dictionary_id='44011.Kaynak Veri Tabanı'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br>
					<cf_get_lang dictionary_id='44012.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br>
					<input type="button" value="<cf_get_lang dictionary_id='44010.Aktarımı Başlat'>" onClick="basamak_2();">
				</cf_box_elements>
			</form>
		</cfif>
	</cf_box>
</div>

<cfif isdefined("attributes.aktarim_hedef_period")>	
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
			<!--- once hedef perioddaki kayitlar mükerrer olmasin diye silinir --->
			<cfquery name="del_" datasource="#dsn#_#attributes.aktarim_hedef_company#">
				DELETE FROM PROJECT_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">
			</cfquery>

			<cfquery name="GET_COLUMN" datasource="#dsn#_#attributes.aktarim_hedef_company#">
				SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '#dsn#_#attributes.aktarim_hedef_company#' AND TABLE_NAME = 'PROJECT_PERIOD' AND COLUMN_NAME NOT IN ('PERIOD_ID','PROJECT_ACCOUNT_ID')
			</cfquery>
			
			<!--- eski donemdeki bilgiler aktarilir --->
			<cfquery name="ADD_PROJECT_PERIOD" datasource="#dsn#_#attributes.aktarim_hedef_company#">
				INSERT INTO 
					PROJECT_PERIOD 
				(
					PERIOD_ID,
				<cfoutput query="get_column">
					#get_column.column_name#<cfif get_column.currentrow neq get_column.recordcount>,</cfif>
				</cfoutput>			
				)
				SELECT 
					#attributes.aktarim_hedef_period#,
				<cfoutput query="get_column">
					#get_column.column_name#<cfif get_column.currentrow neq get_column.recordcount>,</cfif>
				</cfoutput>					
				 FROM 
					PROJECT_PERIOD
				 WHERE 
					PERIOD_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#">
			</cfquery>		
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44003.İşlem Başarıyla Tamamlanmıştır'>!");
	</script>
</cfif>
<script type="text/javascript">	
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