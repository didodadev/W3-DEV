<!---  Dönem geçişlerinde iş istasyonu masraf merkezi aktarımının unutulmaması ve default olarak yeni döneme geçiş yapılması 
	   Modified by : FUygun 20140627 --->
<cfquery name="GET_COMPANY_PERIODS" datasource="#dsn#">
    SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        IS_LOCKED	 	
    FROM 
    	SETUP_PERIOD 
    ORDER BY 
	    OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
	<cf_box title="#getLang('','İş İstasyonları Muhasebe Aktarımı','43002')#">
		<cfif not isdefined("attributes.hedef_period")>
			<form action="" method="post" name="form_">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-item_company_id">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43767.Kaynak Dönem'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">  
								<select name="item_company_id" id="item_company_id" onchange="show_periods_departments(1)">
									<cfoutput query="get_companies">
										<option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-norm_file">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43260.Hedef Dönem'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="period_div">
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
					<div class="col col-7 col-md-7 col-sm-7 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-workstation_file">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62982.Bu İşlem Bir Önceki Yıla Ait Dönemde Bulunan İstasyon Masraf Merkezlerini Yeni Açılan Döneme Aktarmaya Olanak Sağlar'>.<br/>
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'>:<cf_get_lang dictionary_id='62981.Bu Aktarımı Yaparsanız Seçilen Hedef Döneme Ait Yapılan Manuel Tanımlamalar Silinecektir.'><br/></label>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12 text-right ">
						<input type="button" value="<cf_get_lang dictionary_id='58676.Aktar'>" onClick="basamak_1();">
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
					OUR_COMPANY_ID,
					PERIOD_YEAR	
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
					OUR_COMPANY_ID, 
					RECORD_DATE, 
					RECORD_IP, 
					RECORD_EMP, 
					UPDATE_DATE, 
					UPDATE_IP, 
					UPDATE_EMP, 
					IS_LOCKED	 	
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
					<cfif isdefined("attributes.definition")><input type="hidden" name="aktarim_definition" id="aktarim_definition" value="1"></cfif>
					<cfif isdefined("attributes.bakiye")><input type="hidden" name="aktarim_bakiye" id="aktarim_bakiye" value="1"></cfif>
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
			<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
			<cfset hedef_dsn3_alias = '#dsn#_#attributes.aktarim_hedef_company#'>
			<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
			<cfset kaynak_dsn2_alias = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
            <cfset kaynak_dsn3_alias = '#dsn#_#attributes.aktarim_kaynak_company#'>
			<!--- once hedef taboda kayitlar varmi diye bakilir --->
            <cfquery name="DEL_WORKSTATIONS" datasource="#hedef_dsn2#">
            	DELETE FROM #hedef_dsn3_alias#.WORKSTATION_PERIOD WHERE PERIOD_ID = #aktarim_hedef_period#
            </cfquery>
            <cfquery name="transfer_workstation_period" datasource="#hedef_dsn2#">	
                INSERT INTO #hedef_dsn3_alias#.WORKSTATION_PERIOD
                (
                    STATION_ID,
                    PERIOD_ID,
                    EXPENSE_ID,
                    EXPENSE_SHIFT,
                    COST_TYPE,
                    ACCOUNT_ID,
                    ACCOUNT_SHIFT
                )
                    SELECT
                        STATION_ID,
                        #aktarim_hedef_period#,
                        EXPENSE_ID,
                        EXPENSE_SHIFT,
                        COST_TYPE,
                        ACCOUNT_ID,
                        ACCOUNT_SHIFT
                    FROM
                    	#kaynak_dsn3_alias#.WORKSTATION_PERIOD
                    WHERE
                        PERIOD_ID = #attributes.aktarim_kaynak_period#
        	</cfquery>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44014.Hedef Period Seçmelisiniz'>!");
	</script>
    <cflocation url="#request.self#?fuseaction=settings.workstations_account_transfer" addtoken="no">
</cfif>﻿
<script type="text/javascript">
	function basamak_1()
	{
		if(confirm("<cf_get_lang dictionary_id='62983.İş İstasyonları Aktarım İşlemi Yapacaksınız ! Bu İşlem Geri Alınamaz ! Emin misiniz?'>"))
			document.form_.submit();
		else 
			return false;
	}
	function basamak_2()
	{
		
		var deger = confirm("<cf_get_lang dictionary_id='62983.İş İstasyonları Aktarım İşlemi Yapacaksınız ! Bu İşlem Geri Alınamaz ! Emin misiniz?'>");
		  if (deger == true) {
		  document.form1_.submit();
		  alert("<cf_get_lang dictionary_id='260.Aktarım Başarıyla Tamamlanmıştır!'>");
	} else 
		{
			return false;
		}
		
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

