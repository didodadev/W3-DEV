<script>
function basamak_1()
	{
	if(confirm("<cf_get_lang no ='2012.Dönem Yetki Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz'>"))
		document.form_.submit();
	else 
		return false;
	}
	
function basamak_2()
	{
		if(confirm("<cf_get_lang no ='2012.Dönem Yetki Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz'>"))
		document.form1_.submit();
	else 
		return false;
	}
</script>

<cfif not isdefined("attributes.hedef_year")>
<cfsavecontent variable = "title">
	<cf_get_lang no='1276.Çalışan Çalışma Dönemi Aktarımı'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
	<form action="" method="post" name="form_">
			<table>
				<tr>
					<td><cf_get_lang no='1277.Hedef Dönem'></td>
					<td>
						<select name="hedef_year" id="hedef_year">
							<cfloop from="#session.ep.period_year+1#" to="#session.ep.period_year+10#" index="my_year">
								<cfoutput>
									<option value="#my_year#" <cfif isdefined("attributes.hedef_year") and attributes.hedef_year eq my_year>selected</cfif>>#my_year#</option>
								</cfoutput>
							</cfloop>
						</select>
					</td>
					<td><input type="checkbox" name="form_is_transfer_all" id="form_is_transfer_all" value="1"> <cf_get_lang_main no ='576.Geçişli'></td>
					<td><input type="button" value="<cf_get_lang no ='2013.Dönem Aktar'>" onClick="basamak_1();"></td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="checkbox" name="is_our_comp" id="is_our_comp" value=""><cf_get_lang dictionary_id='866.Sadece Bulunduğum Şirket İçin Aktarım Yapılsın'>
					</td>
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
							<cfinclude template="#file_web_path#templates/period_help/employeesTransferPeriod_#session.ep.language#.html">
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
<cfif isdefined("attributes.hedef_year")>
	<cfquery name="get_periods" datasource="#dsn#">
		SELECT 
			PERIOD,
			PERIOD_YEAR,
			OUR_COMPANY_ID
		FROM 
			SETUP_PERIOD 
		WHERE 
			PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_year#">
			<cfif isdefined("attributes.is_our_comp")>
				AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfif>
		ORDER BY
			OUR_COMPANY_ID DESC
	</cfquery>
	<cfset comp_list = valuelist(get_periods.our_company_id)>
	<cfif not get_periods.recordcount>
		<script>
			alert("<cf_get_lang no ='2015.Aktarım Gerçekleştirilebilecek Period Bulunamadı!Dönem Açılmadan Dönem Aktarımı Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="get_periods_gecerli" datasource="#dsn#">
		SELECT 
			PERIOD,
			PERIOD_YEAR,
			PERIOD_ID
		FROM 
			SETUP_PERIOD 
		WHERE 
			PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_year#"> AND
			OUR_COMPANY_ID IN (SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_year-1#">)
			<cfif isdefined("attributes.is_our_comp")>
				AND OUR_COMPANY_ID=#session.ep.company_id#
			</cfif>
		ORDER BY OUR_COMPANY_ID DESC
	</cfquery>
	
	<cfquery name="get_old_periods" datasource="#dsn#">
		SELECT 
			PERIOD_ID 
		FROM 
			SETUP_PERIOD 
		WHERE 
			PERIOD_YEAR =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_year-1#"> 
			AND OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#comp_list#">) 
			<cfif isdefined("attributes.is_our_comp")>
				AND OUR_COMPANY_ID=#session.ep.company_id#
			</cfif>
		ORDER BY 
			OUR_COMPANY_ID DESC
	</cfquery>
	<cfif not get_periods_gecerli.recordcount>
		<script>
			alert("<cf_get_lang no ='2016.Aktarım Gerçekleştirilebilecek İçin Kaynak Period Bulunamadı!Kaynak Period Olmadan Dönem Aktarımı Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	&nbsp;&nbsp;<font color="FF0000" style="font-size:16px;"><cf_get_lang no ='2017.Dönem aktarımı yapılabilmesi için aynı şirketin seçilen yılın bir önceki yılına ait period tanımının olması gerekmektedir'></font><br/><br/>
	&nbsp;&nbsp;<cf_get_lang no ='2018.Aktarım İstenen Dönemler'> : <cfoutput query="get_periods"><cfif currentrow mod 2><b></cfif>#PERIOD# - (#PERIOD_YEAR#)<cfif currentrow mod 2></b></cfif>, </cfoutput><br/>
	&nbsp;&nbsp;<cf_get_lang no ='2019.Aktarım Yapılabilecek Dönemler'> : <cfoutput query="get_periods_gecerli"><cfif currentrow mod 2><b></cfif>#PERIOD# - (#PERIOD_YEAR#)<cfif currentrow mod 2></b></cfif>, </cfoutput><br/> 
	<form name="form1_" method="post" action=""> 
		<input type="hidden" name="aktarim_year" id="aktarim_year" value="<cfoutput>#attributes.hedef_year#</cfoutput>">
		<cfif isdefined("form_is_transfer_all")>
			<input type="hidden" name="is_transfer_all" id="is_transfer_all" value="1">
		</cfif>
		<input type="hidden" name="period_list" id="period_list" value="<cfoutput>#valuelist(get_periods_gecerli.PERIOD_ID)#</cfoutput>">
		<input type="hidden" name="old_period_list" id="old_period_list" value="<cfoutput>#valuelist(get_old_periods.PERIOD_ID)#</cfoutput>">
		&nbsp;&nbsp;<input type="button" value="<cf_get_lang no ='2021.Dönem Aktarıma Devam Et'>" onClick="basamak_2();">
	</form>
</cfif>
<cfif isdefined("attributes.aktarim_year")>
	<cfquery name="GET_EMP_PERIODS" datasource="#DSN#">
		SELECT 
        	ID, 
            POSITION_ID,
			PERIOD_ID
        FROM 
        	EMPLOYEE_POSITION_PERIODS 
        WHERE 
    	    PERIOD_ID 
        IN 
	        (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_period_list#" list="yes">)
	</cfquery>
	<cfquery name="GET_EMP_NEW_PERIODS" datasource="#DSN#">
		SELECT 
        	ID, 
            POSITION_ID ,
			PERIOD_ID
        FROM 
    	    EMPLOYEE_POSITION_PERIODS 
        WHERE 
	        PERIOD_ID 
        IN 
        	(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_list#" list="yes">)
	</cfquery>
	<cfquery name="DEL_EMP_NEW_PERIODS" datasource="#DSN#">
		DELETE FROM EMPLOYEE_POSITION_PERIODS WHERE PERIOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_list#" list="yes">)
	</cfquery>
	<cfset count = 0>
	<cfloop list="#attributes.old_period_list#" index="aktarim">
		<cfset count = count + 1>
		<cfquery name="get_period_info" dbtype="query">
			SELECT POSITION_ID FROM GET_EMP_PERIODS WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#aktarim#">
		</cfquery>
			<cfif get_period_info.recordcount>
				<CFQUERY name="insert_" datasource="#dsn#">
						<cfoutput query="get_period_info">
                            INSERT INTO EMPLOYEE_POSITION_PERIODS
                            (POSITION_ID,PERIOD_ID) VALUES (#get_period_info.position_id#,#listgetat(attributes.period_list,count,',')#)
							<cfif isdefined("attributes.is_transfer_all")>
                            	UPDATE EMPLOYEE_POSITIONS SET PERIOD_ID = #listgetat(attributes.period_list,count,',')# WHERE POSITION_ID =#get_period_info.position_id#
							</cfif>
                        </cfoutput>
                    </CFQUERY>	
			</cfif>
	</cfloop>
	<script>
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
	</script>
</cfif>