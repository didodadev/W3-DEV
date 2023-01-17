<!--- Şube/Departman Muhasebe tanımı aktarımı--->
<script type="text/javascript">
function basamak_1()
	{
		if(confirm("<cf_get_lang dictionary_id='870.Şube/Departman Muhasebe Tanım Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz'>?"))
			document.form_.submit();
		else 
			return false;
	}
	
function basamak_2()
	{
		if(confirm("<cf_get_lang dictionary_id='870.Şube/Departman Muhasebe Tanım Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz'>?"))
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

<cfif not isdefined("attributes.hedef_year")>
<cfsavecontent variable = "title">
	<cf_get_lang dictionary_id="43431.Şube/Departman Muhasebe Tanım Aktarım">
</cfsavecontent>

 <cf_form_box title="#title#">
	<cf_area width="50%">
		<form action="" method="post" name="form_">
		<table>
		<tr>
			<td><cf_get_lang no='1277.Hedef Dönem'></td>
			<td>
				<select name="item_company_id" id="item_company_id" onchange="show_periods_departments(1)">
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
							<p><cf_get_lang dictionary_id ='871.Bu işlem şube ve departman muhasebe tanımlarını yeni döneme aktarır.'></p>
							<!---Yardım dosyası--->
							<!--- <cfinclude template="#file_web_path#templates/period_help/departmentPeriodTransfer_#session.ep.language#.html"> --->
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
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP 
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
            RECORD_EMP 
        FROM 
    	    SETUP_PERIOD 
        WHERE 
	        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.OUR_COMPANY_ID#"> AND 
            PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.PERIOD_YEAR-1#">
	</cfquery>
	<cfif not get_kaynak_period.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2030.Kaynak Period Bulunamadı! Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<form action="" name="form1_" method="post">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
		<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cf_get_lang no ='2029.Hedef Veri Tabanı'>: <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="<cf_get_lang no ='2027.Aktarımı Başlat'>" onClick="basamak_2();">
	</form>
</cfif>
<cfif isdefined("attributes.aktarim_hedef_period")>	
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
			<cfquery name="get_hedef_period" datasource="#dsn#">
				SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">
			</cfquery>
			<cfquery name="del_1" datasource="#dsn#">
				DELETE FROM SETUP_ACCOUNT_DEFINITION WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">
			</cfquery>
			<cfquery name="del_2" datasource="#dsn#">
				DELETE FROM SETUP_ACCOUNT_DEFINITION_CODE_ROW WHERE SETUP_ACCOUNT_DEFINITION_ID IN(SELECT SETUP_ACCOUNT_DEFINITION_ID FROM SETUP_ACCOUNT_DEFINITION WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">)
			</cfquery>
			<cfquery name="del_3" datasource="#dsn#">
				DELETE FROM SETUP_ACCOUNT_CODE_DEFINITION WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">
			</cfquery>
			<cfquery name="del_4" datasource="#dsn#">
				DELETE FROM SETUP_ACCOUNT_EXPENSE WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">
			</cfquery>
            <cfquery name="get_account_definition" datasource="#dsn#">
				SELECT * FROM SETUP_ACCOUNT_DEFINITION WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#">
            </cfquery>
			<cfloop query="get_account_definition">
				<cfquery name="add_account_definition" datasource="#dsn#" result="max_id">
					INSERT INTO
                    	SETUP_ACCOUNT_DEFINITION
                      	(
                        	BRANCH_ID,
                            DEPARTMENT_ID,
                            PERIOD_ID,
                            ACCOUNT_BILL_TYPE,
                            ACCOUNT_CODE,
                            EXPENSE_CODE,
                            EXPENSE_ITEM_ID,
                            ACCOUNT_NAME,
                            EXPENSE_CODE_NAME,
                            EXPENSE_ITEM_NAME,
                            RECORD_PERIOD_ID,
                            PERIOD_YEAR,
                            PERIOD_COMPANY_ID,
                            EXPENSE_CENTER_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )  
                        VALUES
                        (
                        	<cfif len(get_account_definition.branch_id)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.branch_id#">
                            <cfelse>
                            	NULL
                            </cfif>,
                        	<cfif len(get_account_definition.DEPARTMENT_ID)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.DEPARTMENT_ID#">
                            <cfelse>
                            	NULL
                            </cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_period#">,
                        	<cfif len(get_account_definition.ACCOUNT_BILL_TYPE)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.ACCOUNT_BILL_TYPE#"><cfelse>NULL</cfif>,
                        	<cfif len(get_account_definition.ACCOUNT_CODE)>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_definition.ACCOUNT_CODE#"><cfelse>NULL</cfif>,
                        	<cfif len(get_account_definition.EXPENSE_CODE)>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_definition.EXPENSE_CODE#"><cfelse>NULL</cfif>,
                        	<cfif len(get_account_definition.EXPENSE_ITEM_ID)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.EXPENSE_ITEM_ID#"><cfelse>NULL
                            </cfif>,
                        	<cfif len(get_account_definition.ACCOUNT_NAME)>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_definition.ACCOUNT_NAME#"><cfelse>NULL
                            </cfif>,
                        	<cfif len(get_account_definition.EXPENSE_CODE_NAME)>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_definition.EXPENSE_CODE_NAME#"><cfelse>NULL
                             </cfif>,
                        	<cfif len(get_account_definition.EXPENSE_ITEM_NAME)>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_account_definition.EXPENSE_ITEM_NAME#"><cfelse>NULL
                            </cfif>,
                        	<cfif len(get_account_definition.RECORD_PERIOD_ID)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.RECORD_PERIOD_ID#"><cfelse>NULL
                            </cfif>,
                        	<cfif len(get_account_definition.PERIOD_YEAR)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.PERIOD_YEAR#"><cfelse>NULL
                            </cfif>,
                        	<cfif len(get_account_definition.PERIOD_COMPANY_ID)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.PERIOD_COMPANY_ID#"><cfelse>NULL
                            </cfif>,
                        	<cfif len(get_account_definition.EXPENSE_CENTER_ID)>
                            	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_definition.EXPENSE_CENTER_ID#"><cfelse>NULL
                            </cfif>,
                        	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                        )             
                </cfquery>
                <cfquery name="add_definition_code_row" datasource="#dsn#">
                   	INSERT INTO 
                    SETUP_ACCOUNT_DEFINITION_CODE_ROW
                    (
                        SETUP_ACCOUNT_DEFINITION_ID,
                        ACCOUNT_BILL_TYPE
                    )
                    SELECT
                        #max_id.identitycol#,
                        ACCOUNT_BILL_TYPE
                    FROM 
                        SETUP_ACCOUNT_DEFINITION_CODE_ROW 
                    WHERE 
                        SETUP_ACCOUNT_DEFINITION_ID = #get_account_definition.ID#
                </cfquery>
            </cfloop>
            <cfquery name="add_code_definition" datasource="#dsn#">
                INSERT INTO 
                	SETUP_ACCOUNT_CODE_DEFINITION
                    (
                    BRANCH_ID,
                    DEPARTMENT_ID,
                    ACC_TYPE_ID,
                    ACCOUNT_CODE,
                    PERIOD_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                    )
                SELECT
                    BRANCH_ID,
                    DEPARTMENT_ID,
                    ACC_TYPE_ID,
                    ACCOUNT_CODE,
                    #attributes.aktarim_hedef_period#,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.REMOTE_ADDR#'
                FROM 
                    SETUP_ACCOUNT_CODE_DEFINITION
                WHERE
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#">			
            </cfquery>
            <cfquery name="add_account_expense" datasource="#dsn#">
				INSERT INTO
                	SETUP_ACCOUNT_EXPENSE
                (
                    BRANCH_ID,
                    DEPARTMENT_ID,
                    PERIOD_ID,
                    EXPENSE_CENTER_ID,
                    RATE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                SELECT
                    BRANCH_ID,
                    DEPARTMENT_ID,
                    #attributes.aktarim_hedef_period#,
                    EXPENSE_CENTER_ID,
                    RATE,
                    #NOW()#,
                    #session.ep.userid#,
                    '#cgi.REMOTE_ADDR#'
                FROM 
                    SETUP_ACCOUNT_EXPENSE
                WHERE
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#">                
            </cfquery>
			<script type="text/javascript">
				alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
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