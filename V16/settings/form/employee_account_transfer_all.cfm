<script type="text/javascript">
	function basamak_1()
		{
			if(confirm("Çalışan Muhasebe Tanım Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz?"))
				document.form_.submit();
			else 
				return false;
		}
		
	function basamak_2()
		{
			if(confirm("Çalışan Muhasebe Tanım Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz?"))
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
	<cf_box title="#getLang('','Çalışan Muhasebe Tanım Aktarım','42015')#">
		<cfif not isdefined("attributes.hedef_year")>
			<form action="" method="post" name="form_">
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
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62985.Önceki dönemde kayıtlı olan muhasebe ve bütçe tanımlarının yeni açılan dönemde de tanımlı olmasını sağlar.'>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62986.Aktarım yapılmadan önce masraf merkezi ve bütçe kalemlerinin aktarılması gerekmektedir.'><br/>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62987.Hedef Dönem:Aktarım Yapılacak Dönem seçilmelidir.'><br/>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62988.Aktarım bir kere yapılabilir.'></label>
				</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
						<input type="button" value="<cf_get_lang dictionary_id='43996.Dönem Aktar'>" onClick="basamak_1();">
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
					OUR_COMPANY_ID, 
					RECORD_DATE, 
					RECORD_IP, 
					RECORD_EMP 
				FROM 
					SETUP_PERIOD 
				WHERE 
					PERIOD_ID = #attributes.hedef_period_1#
			</cfquery>
			
			<cfquery name="get_kaynak_period" datasource="#dsn#">
				SELECT 
					PERIOD_ID, 
					PERIOD, 
					PERIOD_YEAR, 
					OUR_COMPANY_ID, 
					RECORD_DATE, 
					RECORD_IP, 
					RECORD_EMP 
				FROM 
					SETUP_PERIOD 
				WHERE 
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.OUR_COMPANY_ID#"> AND 
					PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.PERIOD_YEAR-1#">
			</cfquery>
			<!--- masraf merkezi ve gider kalemi --->
			<cfif fusebox.use_period>
				<cfset new_dsn2_alias = '#dsn#_#get_hedef_period.PERIOD_YEAR#_#get_hedef_period.OUR_COMPANY_ID#'>
			<cfelse>
				<cfset new_dsn2_alias = '#dsn#'>
			</cfif>
			<cfif not get_kaynak_period.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='44013.Kaynak Period Bulunamadı! Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
					history.back();
				</script>
				<cfabort>
			</cfif>
			
			<form action="" name="form1_" method="post">
				<cf_box_elements>
					<input type="hidden" name="new_dsn2_alias" id="new_dsn2_alias" value="<cfoutput>#new_dsn2_alias#</cfoutput>">
					<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
					<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
					<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
					<cf_get_lang dictionary_id='44011.Kaynak Veri Tabanı'>: <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
					<cf_get_lang dictionary_id='44012.Hedef Veri Tabanı'>: <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
					<input type="button" value="<cf_get_lang dictionary_id='44010.Aktarımı Başlat'>" onClick="basamak_2();">
				</cf_box_elements>
			</form>
		</cfif>
	</cf_box>	
</div>
	<cfif isdefined("attributes.aktarim_hedef_period")>	
		<cflock name="#CREATEUUID()#" timeout="70">
			<cftransaction>
				<cfquery name="get_hedef_period" datasource="#dsn#">
					SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.aktarim_hedef_period#
				</cfquery>
				<cfquery name="del_1" datasource="#dsn#">
					DELETE FROM EMPLOYEES_IN_OUT_PERIOD WHERE PERIOD_ID = #attributes.aktarim_hedef_period#
				</cfquery>
				<cfquery name="del_2" datasource="#dsn#">
					DELETE FROM EMPLOYEES_ACCOUNTS WHERE PERIOD_ID = #attributes.aktarim_hedef_period#
				</cfquery>
				<cfquery name="del_3" datasource="#dsn#">
					DELETE FROM EMPLOYEES_IN_OUT_PERIOD_ROW WHERE PERIOD_ID = #attributes.aktarim_hedef_period#
				</cfquery>
				<cfquery name="aktar_1" datasource="#dsn#">
					INSERT INTO EMPLOYEES_IN_OUT_PERIOD 
					(
						PERIOD_ID,
						IN_OUT_ID,
						ACCOUNT_BILL_TYPE,
						ACCOUNT_CODE,
						ACCOUNT_NAME,
						<!--- gider kalemi --->
						EXPENSE_ITEM_ID,
						EXPENSE_ITEM_NAME,
						<!--- //gider kalemi --->
						RECORD_PERIOD_ID,
						PERIOD_YEAR,
						PERIOD_COMPANY_ID,
						<!--- masraf merkezi start--->
						EXPENSE_CENTER_ID,
						EXPENSE_CODE,
						EXPENSE_CODE_NAME,
						<!--- // masraf merkezi finish--->
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					SELECT 
						#attributes.aktarim_hedef_period#,
						EIOP.IN_OUT_ID,
						EIOP.ACCOUNT_BILL_TYPE,
						EIOP.ACCOUNT_CODE,
						EIOP.ACCOUNT_NAME,
						<!--- gider kalemi --->                    
						EX.EXPENSE_ITEM_ID,
						EX.EXPENSE_ITEM_NAME,
						<!---// gider kalemi --->
						EIOP.RECORD_PERIOD_ID,
						#get_hedef_period.period_year#,
						EIOP.PERIOD_COMPANY_ID,
						<!--- masraf merkezi start--->
						EC.EXPENSE_ID AS EXPENSE_CENTER_ID,
						EC.EXPENSE_CODE,
						EC.EXPENSE_CODE+' - '+EC.EXPENSE AS EXPENSE_CODE_NAME,
						<!--- // masraf merkezi finish--->
						EIOP.RECORD_DATE,
						EIOP.RECORD_IP,
						EIOP.RECORD_EMP
					FROM 
						EMPLOYEES_IN_OUT_PERIOD EIOP LEFT JOIN #new_dsn2_alias#.EXPENSE_CENTER EC
						ON EIOP.EXPENSE_CENTER_ID = EC.EXPENSE_ID
						LEFT JOIN #new_dsn2_alias#.EXPENSE_ITEMS EX 
						ON EIOP.EXPENSE_ITEM_ID = EX.EXPENSE_ITEM_ID 
					WHERE 
						PERIOD_ID = #attributes.aktarim_kaynak_period#
				</cfquery>
				<cfquery name="aktar_2" datasource="#dsn#">
					INSERT INTO EMPLOYEES_ACCOUNTS 
					(
						PERIOD_ID,
						IN_OUT_ID,
						ACC_TYPE_ID,
						ACCOUNT_CODE,
						EMPLOYEE_ID
					)
					SELECT 
						#attributes.aktarim_hedef_period#,
						IN_OUT_ID,
						ACC_TYPE_ID,
						ACCOUNT_CODE,
						EMPLOYEE_ID
					FROM 
						EMPLOYEES_ACCOUNTS
					WHERE 
						PERIOD_ID = #attributes.aktarim_kaynak_period#
				</cfquery>
				<!--- çoklu masraf merkezi ve aktivite tipi aktarım--->
				<cfquery name="aktar_3" datasource="#dsn#">
					INSERT INTO EMPLOYEES_IN_OUT_PERIOD_ROW
					(
						PERIOD_ID,
						IN_OUT_ID,
						EXPENSE_CENTER_ID,
						RATE,
						ACTIVITY_TYPE_ID
					)
					SELECT
						#attributes.aktarim_hedef_period#,
						IN_OUT_ID,
						EC.EXPENSE_ID,
						RATE,
						ACTIVITY_TYPE_ID
					FROM 
						EMPLOYEES_IN_OUT_PERIOD_ROW PR INNER JOIN 
						#new_dsn2_alias#.EXPENSE_CENTER EC
						ON PR.EXPENSE_CENTER_ID = EC.EXPENSE_ID
					WHERE
						PERIOD_ID = #attributes.aktarim_kaynak_period#
				</cfquery>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='44003.İşlem Başarıyla Tamamlanmıştır'>!");
				</script>
			</cftransaction>
		</cflock>
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
	