<script type="text/javascript">
	function basamak_1()
		{
		if(confirm("<cf_get_lang no ='2025.Dönem Aktarım İşlemi Yapacaksınız!!! Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form_.submit();
		else 
			return false;
		}
		
	function basamak_2()
		{
		if(confirm("<cf_get_lang no ='2025.Dönem Aktarım İşlemi Yapacaksınız!!! Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
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

<cfif not isdefined("attributes.hedef_period")>
<cfsavecontent variable = "title">
	<cf_get_lang no ='2070.Kurumsal Üye Dönem Aktarımı'><cfif isdefined("attributes.is_transfer_all")>(<cf_get_lang_main no ='576.Geçişli'>)</cfif>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
			<form action="" method="post" name="form_">
			<table>
				<tr>
					<td><cf_get_lang no ='1277.Hedef Dönem'></td>
					<td>
						<select name="item_company_id" id="item_company_id"  onchange="show_periods_departments(1)"> 
							<cfoutput query="get_companies">
								<option value="#COMP_ID#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
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
					<td><input type="checkbox" name="form_is_transfer_all" id="form_is_transfer_all" value="1"> <cf_get_lang_main no ='576.Geçişli'></td>
					<td><input type="button" value="<cf_get_lang no ='2013.Dönem Aktar'>" onClick="basamak_1();"></td>
				</tr>
			</table>
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
							<cfinclude template="#file_web_path#templates/period_help/CompanyPeriodTransfer_#session.ep.language#.html">
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
			alert("<cf_get_lang no ='2031.Hedef Period Seçmelisiniz'>!");
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
            PERIOD_DATE 
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
            PERIOD_DATE 
        FROM 
    	    SETUP_PERIOD 
        WHERE 
	        OUR_COMPANY_ID = #get_hedef_period.OUR_COMPANY_ID# AND PERIOD_YEAR = #get_hedef_period.PERIOD_YEAR-1#
	</cfquery>
	
	<cfif not get_kaynak_period.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2030.Kaynak Period Bulunamadı! Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<br/>
	<form action="" name="form1_" method="post">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<cfif isdefined("attributes.form_is_transfer_all")>
			<input type="hidden" name="is_transfer_all" id="is_transfer_all" value="<cfoutput>#attributes.form_is_transfer_all#</cfoutput>">
		</cfif>
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
		<cf_get_lang no ='2028.Kaynak Veri Tabanı'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cf_get_lang no ='2029.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="<cf_get_lang no ='2027.Aktarımı Başlat'>" onClick="basamak_2();">
	</form>
</cfif>
<cfif isdefined("attributes.aktarim_hedef_period")>	
	<cflock name="#CREATEUUID()#" timeout="70">
	<cftransaction>
		<cfquery name="get_hedef_period" datasource="#dsn#">
			SELECT 
                PERIOD_ID, 
                PERIOD, 
                PERIOD_YEAR, 
                OUR_COMPANY_ID, 
                PERIOD_DATE 
            FROM 
	            SETUP_PERIOD 
            WHERE 
            	PERIOD_ID = #attributes.aktarim_hedef_period#
		</cfquery>		
            
		<!--- eski donemdeki bilgiler, hedef donemde kriterlere uygun kayit yoksa aktarilir --->
        <cfquery name="aktar_" datasource="#dsn#">
            INSERT INTO COMPANY_PERIOD 
            (
                COMPANY_ID,
                PERIOD_ID,
                ACCOUNT_CODE,
                ADVANCE_PAYMENT_CODE,
                PERIOD_DATE,
				KONSINYE_CODE,
				SALES_ACCOUNT,
				PURCHASE_ACCOUNT,
				RECEIVED_GUARANTEE_ACCOUNT,
				GIVEN_GUARANTEE_ACCOUNT,
				RECEIVED_ADVANCE_ACCOUNT,
				EXPORT_REGISTERED_SALES_ACCOUNT,
				EXPORT_REGISTERED_BUY_ACCOUNT
            )
            SELECT 
                COMPANY_ID,
                #attributes.aktarim_hedef_period#,
                ACCOUNT_CODE,
                ADVANCE_PAYMENT_CODE,
                PERIOD_DATE,
				KONSINYE_CODE,
				SALES_ACCOUNT,
				PURCHASE_ACCOUNT,
				RECEIVED_GUARANTEE_ACCOUNT,
				GIVEN_GUARANTEE_ACCOUNT,
				RECEIVED_ADVANCE_ACCOUNT,
				EXPORT_REGISTERED_SALES_ACCOUNT,
				EXPORT_REGISTERED_BUY_ACCOUNT
            FROM 
                COMPANY_PERIOD
            WHERE
                PERIOD_ID =  #attributes.aktarim_kaynak_period# AND
                ACCOUNT_CODE IN (SELECT AP.ACCOUNT_CODE FROM #dsn#_#get_hedef_period.period_year#_#get_hedef_period.our_company_id#.ACCOUNT_PLAN AP WHERE AP.ACCOUNT_CODE = COMPANY_PERIOD.ACCOUNT_CODE)
                AND COMPANY_ID NOT IN (SELECT COMPANY_ID FROM COMPANY_PERIOD CP2 WHERE PERIOD_ID = #attributes.aktarim_hedef_period# AND ACCOUNT_CODE IS NOT NULL)
        </cfquery>
        <!--- eski donemdeki bilgiler, hedef donemde kriterlere uygun kayit yoksa aktarilir --->
        
        <!--- Geçişli ise default değerler update ediliyor --->
		<cfif isdefined("attributes.is_transfer_all")>
            <cfquery name="upd_default" datasource="#dsn#">
                UPDATE COMPANY SET PERIOD_ID = #attributes.aktarim_hedef_period# WHERE PERIOD_ID = #attributes.aktarim_kaynak_period#
            </cfquery> 
        </cfif>
        
        <cfquery name="get_acc_kontrol" datasource="#dsn#">
            SELECT 
                FULLNAME,
                ACCOUNT_CODE
            FROM 
                COMPANY_PERIOD,
                COMPANY
            WHERE 
                COMPANY.COMPANY_ID = COMPANY_PERIOD.COMPANY_ID
                AND COMPANY_PERIOD.PERIOD_ID = #attributes.aktarim_kaynak_period#
                AND ACCOUNT_CODE IS NOT NULL
				<cfif fusebox.use_period>
                AND (SELECT AP.ACCOUNT_CODE FROM #dsn#_#get_hedef_period.period_year#_#get_hedef_period.our_company_id#.ACCOUNT_PLAN AP WHERE AP.ACCOUNT_CODE = COMPANY_PERIOD.ACCOUNT_CODE) IS NULL
				</cfif>
		</cfquery>
	</cftransaction>
	</cflock>
	<cfif get_acc_kontrol.recordcount>
		<br/>
		<table cellpadding="2" cellspacing="1" width="98%" align="center" class="color-border">
			<tr class="color-row">
				<td>
					<font color="FF0000">Aktarım Tamamlandı. Aşağıdaki Üyelerin Muhasebe Kodları Yeni Dönemde Açılmadığı İçin Muhasebe Kodu Aktarımı Yapılmamıştır. </font>
					<br/>
					<table>
						<tr class="txtboldblue">
							<td>Üye</td>
							<td>Muhasebe Kodu</td>
						</tr>
						<cfoutput query="get_acc_kontrol">
							<tr>
								<td>#fullname#</td>
								<td align="right">#account_code#</td>
							</tr>
						</cfoutput>
					</table>
				</td>
			</tr>	
		</table>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
		</script>
	</cfif>
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