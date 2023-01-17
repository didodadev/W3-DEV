<cfif isDefined('attributes.periods')>
	<!--- Kontrol Basladi --->
	<cfset mylist=ListToArray(attributes.for_control)>		
	<cfloop from="1" to="#ArrayLen(mylist)#" index="i">
		<cfset comp_id=ListGetAt(mylist[i],2,"-")>
		<cfset period_year=ListGetAt(mylist[i],1,"-")>
		<cfset period_id=ListGetAt(mylist[i],3,"-")>	
		<cfif database_type eq "MSSQL">
			<cfset db_type="#DSN#_#period_year#_#comp_id#">
		<cfelse>
			<cfset db_type="#DSN#_#comp_id#_#MID(period_year,3,2)#">
		</cfif>
		<cfset muhasebe_kodu=evaluate("account_code#period_id#")>
        <cfset avans_kodu=evaluate("advance_payment_code#period_id#")>      
		<cfif len(muhasebe_kodu) and muhasebe_kodu neq -1>
			<cfquery name="get_acc_name" datasource="#db_type#">
				SELECT
					ACCOUNT_NAME
				FROM
					ACCOUNT_PLAN
				WHERE
					ACCOUNT_CODE='#muhasebe_kodu#'
			</cfquery>
			<cfif not get_acc_name.RECORDCOUNT>
				<script type="text/javascript">
					alert("Muhasebe Kodu Seçtiginiz Döneme Ait degil! Kontrol ediniz!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
        <cfif len(avans_kodu) and avans_kodu neq -1>
			<cfquery name="get_avans_name" datasource="#db_type#">
				SELECT
					ACCOUNT_NAME
				FROM
					ACCOUNT_PLAN
				WHERE
					ACCOUNT_CODE='#avans_kodu#'
			</cfquery>
			<cfif not get_avans_name.RECORDCOUNT>
				<script type="text/javascript">
					alert("Avans Kodu Seçtiginiz Döneme Ait degil! Kontrol ediniz!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>        
	</cfloop>	
	<!--- Kontrol Bitti  --->
	
	<cfset APERIODS=ListToArray(attributes.periods)>
	<cfloop from="1" to="#ArrayLen(APERIODS)#" index="i">
		<cfset muhasebe_kodu=evaluate("account_code#APERIODS[i]#")>
		<cfif muhasebe_kodu eq "">
			<script type="text/javascript">
                alert('<cf_get_lang_main dictionary_id='33517.Aktif dönemlerde standart hesap seçimi zorunludur'>!');
				history.back();		
			</script>
			<cfabort>
		</cfif>
	</cfloop>

	<!--- Muhasebe Donemlerinin historysini tutmak icin eklenmistir FBS 20080501 --->
	<cfset muhasebe_kodu_2 = "">
	<cfset konsinye_kodu_2 = "">
	<cfset avans_kodu_2 = "">
	<cfset satis_kodu_2 = "">
	<cfset alis_kodu_2 = "">
	<cfset alinan_teminat_kodu_2 = "">
	<cfset verilen_teminat_kodu_2 = "">
	<cfset alinan_avans_kodu_2 = "">
	<cfset ihrac_alis_kodu_2 = "">
	<cfset ihrac_satis_kodu_2 = "">
	<cfquery name="hist_cont" datasource="#dsn#">
		SELECT * FROM CONSUMER_PERIOD WHERE CONSUMER_ID = #attributes.cpid# ORDER BY ID
	</cfquery>

	<cfset account_list = valuelist(hist_cont.account_code,',')>
	<cfset period_list = valuelist(hist_cont.period_id,',')>
	<cfset konsinye_list = valuelist(hist_cont.konsinye_code,',')>
    <cfset avans_list = valuelist(hist_cont.advance_payment_code,',')>
	<cfset sales_list = valuelist(hist_cont.sales_account,',')>
	<cfset purchase_list = valuelist(hist_cont.purchase_account,',')>
	<cfset received_guarantee_list = valuelist(hist_cont.received_guarantee_account,',')>
	<cfset given_guarantee_list = valuelist(hist_cont.given_guarantee_account,',')>
	<cfset received_advance_list = valuelist(hist_cont.received_advance_account,',')>
	<cfset export_sales_list = valuelist(hist_cont.export_registered_sales_account,',')>
	<cfset export_buy_list = valuelist(hist_cont.export_registered_buy_account,',')>

	<cfset history_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
	<cfloop from="1" to="#ArrayLen(APERIODS)#" index="i">
		<cfset muhasebe_kodu_2=listappend(muhasebe_kodu_2,evaluate("account_code#APERIODS[i]#"),',')>
		<cfif isdefined("konsinye_code#APERIODS[i]#")>
			<cfset konsinye_kodu_2=listappend(konsinye_kodu_2,evaluate("konsinye_code#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("advance_payment_code#APERIODS[i]#")>
    	    <cfset avans_kodu_2=listappend(avans_kodu_2,evaluate("advance_payment_code#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("sales_account#APERIODS[i]#")>
    	    <cfset satis_kodu_2=listappend(satis_kodu_2,evaluate("sales_account#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("purchase_account#APERIODS[i]#")>
    	    <cfset alis_kodu_2=listappend(alis_kodu_2,evaluate("purchase_account#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("received_guarantee_account#APERIODS[i]#")>
    	    <cfset alinan_teminat_kodu_2=listappend(alinan_teminat_kodu_2,evaluate("received_guarantee_account#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("given_guarantee_account#APERIODS[i]#")>
    	    <cfset verilen_teminat_kodu_2=listappend(verilen_teminat_kodu_2,evaluate("given_guarantee_account#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("received_advance_account#APERIODS[i]#")>
    	    <cfset alinan_avans_kodu_2=listappend(alinan_avans_kodu_2,evaluate("received_advance_account#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("export_registered_sales_account#APERIODS[i]#")>
    	    <cfset ihrac_alis_kodu_2=listappend(ihrac_alis_kodu_2,evaluate("export_registered_sales_account#APERIODS[i]#"),',')>
		</cfif>
		<cfif isdefined("export_registered_buy_account#APERIODS[i]#")>
    	    <cfset ihrac_satis_kodu_2=listappend(ihrac_satis_kodu_2,evaluate("export_registered_buy_account#APERIODS[i]#"),',')>
		</cfif>
	</cfloop>
	<cfif hist_cont.recordcount neq listlen(attributes.periods) or 
	(hist_cont.recordcount eq listlen(attributes.periods) and (account_list neq muhasebe_kodu_2 or period_list neq attributes.periods or konsinye_list neq konsinye_kodu_2 or avans_list neq avans_kodu_2 or sales_list neq satis_kodu_2 or  purchase_list neq alis_kodu_2 or received_guarantee_list neq alinan_teminat_kodu_2 or given_guarantee_list neq verilen_teminat_kodu_2 or received_advance_list neq alinan_avans_kodu_2 or export_sales_list neq ihrac_alis_kodu_2 or export_buy_list neq ihrac_satis_kodu_2))>	
		<cfoutput query="hist_cont">
			<cfquery name="add_member_periods_history" datasource="#dsn#">
				INSERT INTO
					MEMBER_PERIODS_HISTORY
				(
					CONSUMER_ID,
					PERIOD_ID,
					HISTORY_ID,
					ACCOUNT_CODE,
					KONSINYE_CODE,
					ADVANCE_PAYMENT_CODE,
					SALES_ACCOUNT,
					PURCHASE_ACCOUNT,
					RECEIVED_GUARANTEE_ACCOUNT,
					GIVEN_GUARANTEE_ACCOUNT,
					RECEIVED_ADVANCE_ACCOUNT,
					EXPORT_REGISTERED_SALES_ACCOUNT,
					EXPORT_REGISTERED_BUY_ACCOUNT,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.cpid#,
					#period_id#,
					'#history_id#',
					'#account_code#',
					'#konsinye_code#',
					'#advance_payment_code#',
					'#sales_account#',
					'#purchase_account#',
					'#received_guarantee_account#',
					'#given_guarantee_account#',
					'#received_advance_account#',
					'#export_registered_sales_account#',
					'#export_registered_buy_account#',
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#now()#
				)
			</cfquery>
		</cfoutput>
	</cfif>
	<!--- //Muhasebe Donemlerinin historysini tutmak icin eklenmistir FBS 20080501 --->
	
	<cfquery name="DEL_CONSUMER_PERIODS" datasource="#DSN#">
		DELETE FROM
			CONSUMER_PERIOD
		WHERE
			CONSUMER_ID = #attributes.cpid#
            AND PERIOD_ID IN (SELECT
									EP.PERIOD_ID
								FROM
									EMPLOYEE_POSITIONS E,
									EMPLOYEE_POSITION_PERIODS EP
								WHERE
									E.POSITION_CODE = #session.ep.position_code# AND
									E.POSITION_ID = EP.POSITION_ID
								)
	</cfquery>

	<cfif isDefined('attributes.period_default') and len(attributes.period_default)>
		<cfquery name="UPD_CONSUMER_PERIODS_DEFAULT" datasource="#DSN#">
			UPDATE
				CONSUMER
			SET
				PERIOD_ID = #attributes.period_default#
			WHERE
				CONSUMER_ID = #attributes.cpid#	
		</cfquery>
	</cfif>

	<cfloop from="1" to="#ArrayLen(APERIODS)#" index="i">
		<cfset muhasebe_kodu=evaluate("account_code#APERIODS[i]#")>
		<cfset avans_kodu=evaluate("advance_payment_code#APERIODS[i]#")>
		<cfset konsinye_kodu=evaluate("konsinye_code#APERIODS[i]#")>
		<cfif isdefined("SALES_ACCOUNT#APERIODS[i]#")>
    	    <cfset satis_hesabi=evaluate("SALES_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfif isdefined("PURCHASE_ACCOUNT#APERIODS[i]#")>
    	    <cfset alis_hesabi=evaluate("PURCHASE_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfif isdefined("RECEIVED_GUARANTEE_ACCOUNT#APERIODS[i]#")>
    	    <cfset alinan_teminat_hesabi=evaluate("RECEIVED_GUARANTEE_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfif isdefined("GIVEN_GUARANTEE_ACCOUNT#APERIODS[i]#")>
    	    <cfset verilen_teminat_hesabi=evaluate("GIVEN_GUARANTEE_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfif isdefined("RECEIVED_ADVANCE_ACCOUNT#APERIODS[i]#")>
    	    <cfset alinan_avans_hesabi=evaluate("RECEIVED_ADVANCE_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfif isdefined("EXPORT_REGISTERED_SALES_ACCOUNT#APERIODS[i]#")>
    	    <cfset ihrac_kayitli_satis_hesabi=evaluate("EXPORT_REGISTERED_SALES_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfif isdefined("EXPORT_REGISTERED_BUY_ACCOUNT#APERIODS[i]#")>
    	    <cfset ihrac_kayitli_alis_hesabi=evaluate("EXPORT_REGISTERED_BUY_ACCOUNT#APERIODS[i]#")>
		</cfif>
		<cfquery name="ADD_COMPANY_PERIODS" datasource="#DSN#">
			INSERT INTO 
				CONSUMER_PERIOD
			(
				CONSUMER_ID,  
				PERIOD_ID,
				ACCOUNT_CODE,
				ADVANCE_PAYMENT_CODE,
				SALES_ACCOUNT,
				PURCHASE_ACCOUNT,
				RECEIVED_GUARANTEE_ACCOUNT,
				GIVEN_GUARANTEE_ACCOUNT,
				RECEIVED_ADVANCE_ACCOUNT,
				EXPORT_REGISTERED_SALES_ACCOUNT,
				EXPORT_REGISTERED_BUY_ACCOUNT,
				KONSINYE_CODE                     
			)
			VALUES
			(
				#attributes.cpid#,
				#APERIODS[i]#,
				'#muhasebe_kodu#',
				'#avans_kodu#',
				'#satis_hesabi#',
				'#alis_hesabi#',
				'#alinan_teminat_hesabi#',
				'#verilen_teminat_hesabi#',
				'#alinan_avans_hesabi#',
				'#ihrac_kayitli_satis_hesabi#',
				'#ihrac_kayitli_alis_hesabi#',
				'#konsinye_kodu#'
			)	
		</cfquery>
	</cfloop>
</cfif>

<script type="text/javascript">
	location.href = document.referrer;
</script>
