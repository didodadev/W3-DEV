<!--- Para Birimleri Aktarim --->
<script language="javascript">
	function basamak_1()
	{
		if(confirm("Para Birimi Aktarım İşlemini Yapmak İstediğinize Emin Misiniz?"))
			document.getElementById("form_").submit();
		else 
			return false;
	}	
</script>
<cfquery name="get_money" datasource="#dsn2#">
    SELECT MONEY FROM SETUP_MONEY WHERE RATE1 != RATE2 ORDER BY MONEY_ID
</cfquery>
<cfquery name="get_period_control" datasource="#dsn#">
	SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #session.ep.period_year+1#
</cfquery>
<cf_box title="#getLang('','','42346')#">
	<cfform name="form_" action="" method="post">
		<cf_box_elements>
			<div class="col col-5 col-md-5 col-sm-5 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group"  id="item-company_id">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></div>
					<cfoutput query="get_money">
						<cfif get_period_control.recordcount>
							<cfquery name="get_money_new_period" datasource="#dsn#">
								SELECT MONEY FROM #dsn#_#session.ep.period_year+1#_#session.ep.company_id#.SETUP_MONEY WHERE MONEY = '#get_money.MONEY#'
							</cfquery>
							<input type="checkbox" name="money_type" id="money_type" value="#money#" <cfif not get_money_new_period.recordcount>checked="checked"<cfelse>disabled="disabled"</cfif>> #money#&nbsp;&nbsp;&nbsp;
						<cfelse>	
							<input type="checkbox" name="money_type" id="money_type" value="#money#"> #money#&nbsp;&nbsp;&nbsp;
						</cfif>
					</cfoutput>
				</div>
				<div class="form-group" id="item-employee_id">
					<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43260.Hedef Dönem'></label>
					<div class="col col-7 col-md-7 col-sm-7 col-xs-12" id="period_div">
						<select name="hedef_year" id="hedef_year">
							<cfloop from="#session.ep.period_year+1#" to="#session.ep.period_year+10#" index="my_year">
								<cfoutput>
									<option value="#my_year#" <cfif isdefined("attributes.hedef_year") and attributes.hedef_year eq my_year>selected</cfif>>#my_year#</option>
								</cfoutput>
							</cfloop>
						</select>
						
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold "></b><cf_get_lang dictionary_id='57433.Yardım'><br/></label>
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='63022.Kullanmış olduğunuz para birimlerinin yeni dönemde de tanımlı olmasını sağlar.'>
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62987.Hedef Dönem:Aktarım Yapılacak Dönem seçilmelidir.'><br/>
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'>: <cf_get_lang dictionary_id='63020.Bir önceki dönemdeki tüm döviz birimleri eksiksiz yeni açtığınız dönemde de tanımlanmalıdır. (Devirlerde vs. sorun olmaması için.)'><br/>
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='63021.Devir işlemlerinde sorun yaşanmaması için öncelikle ve mutlaka para birimleri aktarılmalıdır.'><br/>
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62988.Aktarım bir kere yapılabilir.'></label>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
				<input type="button" value="<cf_get_lang dictionary_id='57489.Para Birimi'><cf_get_lang dictionary_id='58676.Aktar'>" onClick="basamak_1();">
			</div>
		</cf_box_footer>
	</cfform>			     
</cf_box>		
<cfif isDefined("attributes.money_type") and ListLen(attributes.money_type) and isDefined("attributes.hedef_year") and Len(attributes.hedef_year)>
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_year-1#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfif not get_kaynak_period.recordcount>
		<script>
			alert("<cf_get_lang dictionary_id='43999.Aktarım Gerçekleştirilebilecek İçin Kaynak Period Bulunamadı!Kaynak Period Olmadan Dönem Aktarımı Yapılamaz'>");
			history.back();
		</script>
        <cfabort>
	<cfelse>
		<cfquery name="get_kaynak_money" datasource="#dsn#">
			SELECT MONEY FROM SETUP_MONEY WHERE MONEY IN (#ListQualify(attributes.money_type,"'",",")#) AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_kaynak_period.period_id#">
		</cfquery>
	</cfif>
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_year#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfif not get_hedef_period.recordcount>
		<script>
			alert("<cf_get_lang dictionary_id='43998.Aktarım Gerçekleştirilebilecek Period Bulunamadı!Dönem Açılmadan Dönem Aktarımı Yapılamaz'>!");
			history.back();
		</script>
        <cfabort>
	<cfelse>
		<cfquery name="get_hedef_money" datasource="#dsn#">
			SELECT 
				MONEY_ID, 
				MONEY, 
				RATE1, 
				RATE2, 
				MONEY_STATUS, 
				PERIOD_ID, 
				COMPANY_ID, 
				ACCOUNT_950, 
				PER_ACCOUNT, 
				RATE3, 
				RECORD_DATE, 
				RECORD_EMP, 
				RECORD_IP, 
				UPDATE_DATE, 
				UPDATE_EMP, 
				UPDATE_IP, 
				RATEPP2, 
				RATEPP3, 
				RATEWW2, 
				RATEWW3, 
				CURRENCY_CODE, 
				DSP_RATE_SALE, 
				DSP_RATE_PUR, 
				DSP_UPDATE_DATE, 
				EFFECTIVE_SALE, 
				EFFECTIVE_PUR, 
				MONEY_NAME, 
				MONEY_SYMBOL 
			FROM 
				SETUP_MONEY 
			WHERE 
				MONEY IN (#ListQualify(attributes.money_type,"'",",")#) AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.period_id#">
		</cfquery>
		<cfif get_hedef_money.recordcount>
			<script>
				alert("Hedef Döneme Ait Daha Önce Para Birimi Eklenmiş, Lütfen Kontrol Ediniz!");
				history.back();
			</script>
            <cfabort>
		<cfelse>
			<cfquery name="add_hedef_money" datasource="#dsn#">
				INSERT INTO
					SETUP_MONEY
				(
					MONEY,
					RATE1,
					RATE2,
					MONEY_STATUS,
					PERIOD_ID,
					COMPANY_ID,
					ACCOUNT_950,
					PER_ACCOUNT,
					RATE3,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					RATEPP2,
					RATEPP3,
					RATEWW2,
					RATEWW3,
					CURRENCY_CODE,
					DSP_RATE_SALE,
					DSP_RATE_PUR,
					DSP_UPDATE_DATE,
					EFFECTIVE_SALE,
					EFFECTIVE_PUR,
					MONEY_NAME,
					MONEY_SYMBOL
				)
				SELECT
					MONEY,
					RATE1,
					RATE2,
					MONEY_STATUS,
					#get_hedef_period.period_id#,
					COMPANY_ID,
					ACCOUNT_950,
					PER_ACCOUNT,
					RATE3,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					RATEPP2,
					RATEPP3,
					RATEWW2,
					RATEWW3,
					CURRENCY_CODE,
					DSP_RATE_SALE,
					DSP_RATE_PUR,
					DSP_UPDATE_DATE,
					EFFECTIVE_SALE,
					EFFECTIVE_PUR,
					MONEY_NAME,
					MONEY_SYMBOL
				FROM
					SETUP_MONEY
				WHERE
					MONEY IN (#ListQualify(attributes.money_type,"'",",")#) AND
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_kaynak_period.period_id#">
			</cfquery>
			<script>
				alert("<cf_get_lang dictionary_id='44003.İşlem Başarıyla Tamamlanmıştır'>!");
				history.back();
			</script>
            <cfabort>
		</cfif>
	</cfif>
</cfif>
