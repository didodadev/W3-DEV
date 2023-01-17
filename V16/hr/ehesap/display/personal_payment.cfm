<!--- <cfinclude template="../query/get_insurance_payments.cfm"> --->
<!--- <cfinclude template="../query/get_insurance_ratios.cfm"> --->
<!--- <cfinclude template="../query/get_tax_slices.cfm"> --->
<cf_xml_page_edit fuseact='ehesap.personal_payment'>
<cfif isdefined('attributes.get_xml') and attributes.get_xml eq 1>
	<cfif not len(attributes.per_year)> 
		<script type="text/javascript"> 
			alert("<cf_get_lang dictionary_id='39035.Dönem seçiniz'>"); 
			history.back(); 
		</script> 
		<cfabort> 
	</cfif> 
	<cfscript>
		ws = CreateObject("webservice","http://dev.workcube.com/web_services/get_personel_payment.cfc?wsdl");
		prdxml_data = ws.myFunction(period:attributes.per_year);
		if (prdxml_data neq 0)
		{
			dosyam = XmlParse(prdxml_data);
			Insurance_Premiums = xmlSearch(dosyam,'/Insurance_Premiums/Insurance_Premium');
			Insurance_Ratio = xmlSearch(dosyam,'/Insurance_Premiums/Insurance_Ratio');
			Tax_Bracket = xmlSearch(dosyam,'/Insurance_Premiums/Tax_Bracket');
		}
	</cfscript> 
	<cfif prdxml_data eq 0>
		<cfdump var="#prdxml_data#-" >
		<script type="text/javascript">
			alert("'<cfoutput>#attributes.per_year#</cfoutput>' <cf_get_lang dictionary_id='54634.yılı için bordro parametreleri tanımlı değildir'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif isdefined('dosyam') and ArrayLen(Insurance_Premiums)>
		<cfloop from="1" to="#ArrayLen(Insurance_Premiums)#" index="i">
			<cfset PremiumXML = xmlparse(Insurance_Premiums[i])>
			<cf_date tarih='PremiumXML.Insurance_Premium.start_date.XmlText'>
			<cf_date tarih='PremiumXML.Insurance_Premium.finish_date.XmlText'>
			<cfquery name="get_ins_pay" dbtype="query">
				SELECT
					*
				FROM
					get_insurance_payments
				WHERE
					STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.start_date.XmlText#">
					AND FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.finish_date.XmlText#">
			</cfquery>
			<cfif get_ins_pay.recordcount>
				<cfquery name="upd_ins_pay" datasource="#dsn#">
					UPDATE 
						INSURANCE_PAYMENT 
					SET
						MIN_PAYMENT = <cfif len(PremiumXML.Insurance_Premium.minimum.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.minimum.XmlText#"><cfelse>NULL</cfif>,
						MAX_PAYMENT = <cfif len(PremiumXML.Insurance_Premium.maximum.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.maximum.XmlText#"><cfelse>NULL</cfif>,
						MIN_GROSS_PAYMENT_NORMAL = <cfif len(PremiumXML.Insurance_Premium.min_gross_payment_normal.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.min_gross_payment_normal.XmlText#"><cfelse>NULL</cfif>,
						MIN_GROSS_PAYMENT_16 = <cfif len(PremiumXML.Insurance_Premium.min_gross_payment_16.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.min_gross_payment_16.XmlText#"><cfelse>NULL</cfif>,
						SENIORITY_COMPANSATION_MAX = <cfif len(PremiumXML.Insurance_Premium.seniority_compansation_max.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.seniority_compansation_max.XmlText#"><cfelse>NULL</cfif>,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					WHERE
						STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.start_date.XmlText#">
						AND FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.finish_date.XmlText#">
				</cfquery>
			<cfelse>
				<cfquery name="get_ins_pay_" dbtype="query">
					SELECT
						*
					FROM
						get_insurance_payments
					WHERE
						(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.start_date.XmlText#">
						AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.start_date.XmlText#">)
						OR
						(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.finish_date.XmlText#">
						AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.finish_date.XmlText#">)
				</cfquery>
				<cfif not get_ins_pay_.recordcount>
					<cfquery name="add_ins_pay" datasource="#dsn#">
						INSERT INTO
							INSURANCE_PAYMENT
						(
							MIN_PAYMENT,
							MAX_PAYMENT,
							MIN_GROSS_PAYMENT_NORMAL,
							MIN_GROSS_PAYMENT_16,
							SENIORITY_COMPANSATION_MAX,
							STARTDATE,
							FINISHDATE,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP
						)
						VALUES
						(
							<cfif len(PremiumXML.Insurance_Premium.minimum.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.minimum.XmlText#"><cfelse>NULL</cfif>,
							<cfif len(PremiumXML.Insurance_Premium.maximum.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.maximum.XmlText#"><cfelse>NULL</cfif>,
							<cfif len(PremiumXML.Insurance_Premium.min_gross_payment_normal.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.min_gross_payment_normal.XmlText#"><cfelse>NULL</cfif>,
							<cfif len(PremiumXML.Insurance_Premium.min_gross_payment_16.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.min_gross_payment_16.XmlText#"><cfelse>NULL</cfif>,
							<cfif len(PremiumXML.Insurance_Premium.seniority_compansation_max.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#PremiumXML.Insurance_Premium.seniority_compansation_max.XmlText#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.start_date.XmlText#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#PremiumXML.Insurance_Premium.finish_date.XmlText#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined('dosyam') and ArrayLen(Insurance_Ratio)>
		<cfset RatioXML = xmlparse(Insurance_Ratio[1])>
		<cf_date tarih='RatioXML.Insurance_Ratio.ins_rat_startdate.XmlText'>
		<cf_date tarih='RatioXML.Insurance_Ratio.ins_rat_finishdate.XmlText'>
		<cfquery name="get_ins_rat" dbtype="query">
			SELECT
				*
			FROM
				get_insurance_ratios
			WHERE
				STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_startdate.XmlText#">
				AND FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_finishdate.XmlText#">
		</cfquery>
		<cfif not get_ins_rat.recordcount>
			<cfquery name="upd_ins_rat_" dbtype="query">
				SELECT
					*
				FROM
					get_insurance_ratios
				WHERE
					(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_startdate.XmlText#">
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_startdate.XmlText#">)
					OR
					(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_finishdate.XmlText#">
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_finishdate.XmlText#">)
			</cfquery>
			<cfif not upd_ins_rat_.recordcount>
				<cfquery name="add_ins_pay" datasource="#dsn#">
					INSERT INTO
						INSURANCE_RATIO
					(
						MOM_INSURANCE_PREMIUM_WORKER,
						MOM_INSURANCE_PREMIUM_BOSS,
						PAT_INS_PREMIUM_WORKER,
						PAT_INS_PREMIUM_BOSS,
						PAT_INS_PREMIUM_WORKER_2,
						PAT_INS_PREMIUM_BOSS_2,
						DEATH_INSURANCE_PREMIUM_WORKER,
						DEATH_INSURANCE_PREMIUM_BOSS,
						DEATH_INSURANCE_WORKER,
						DEATH_INSURANCE_BOSS,
						SOC_SEC_INSURANCE_WORKER,
						SOC_SEC_INSURANCE_BOSS,
						STARTDATE,
						FINISHDATE,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					VALUES
					(
						<cfif len(RatioXML.Insurance_Ratio.mom_insurance_premium_worker.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.mom_insurance_premium_worker.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.mom_insurance_premium_boss.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.mom_insurance_premium_boss.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.pat_ins_premium_worker.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.pat_ins_premium_worker.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.pat_ins_premium_boss.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.pat_ins_premium_boss.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.pat_ins_premium_worker_2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.pat_ins_premium_worker_2.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.pat_ins_premium_boss_2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.pat_ins_premium_boss_2.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.death_insurance_premium_worker.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.death_insurance_premium_worker.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.death_insurance_premium_boss.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.death_insurance_premium_boss.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.death_insurance_worker.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.death_insurance_worker.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.death_insurance_boss.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.death_insurance_boss.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.soc_sec_insurance_worker.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.soc_sec_insurance_worker.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(RatioXML.Insurance_Ratio.soc_sec_insurance_boss.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#RatioXML.Insurance_Ratio.soc_sec_insurance_boss.XmlText#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_startdate.XmlText#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#RatioXML.Insurance_Ratio.ins_rat_finishdate.XmlText#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined('dosyam') and ArrayLen(Tax_Bracket)>
		<cfset BracketXML = xmlparse(Tax_Bracket[1])>
		<cf_date tarih='BracketXML.Tax_Bracket.tax_bracket_startdate.XmlText'>
		<cf_date tarih='BracketXML.Tax_Bracket.tax_bracket_finishdate.XmlText'>
		<cfquery name="get_tax_slc" dbtype="query">
			SELECT
				*
			FROM
				get_tax_slices
			WHERE
				STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_startdate.XmlText#">
				AND FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_finishdate.XmlText#">
		</cfquery>
		<cfif get_tax_slc.recordcount>
			<cfquery name="upd_tax_slc" datasource="#dsn#">
				UPDATE
					SETUP_TAX_SLICES
				SET
					MIN_PAYMENT_1 = <cfif len(BracketXML.Tax_Bracket.min_lim1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim1.XmlText#"><cfelse>NULL</cfif>,
					MAX_PAYMENT_1 = <cfif len(BracketXML.Tax_Bracket.max_lim1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim1.XmlText#"><cfelse>NULL</cfif>,
					RATIO_1 = <cfif len(BracketXML.Tax_Bracket.tax_bracket_rate1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate1.XmlText#"><cfelse>NULL</cfif>,
					MIN_PAYMENT_2 = <cfif len(BracketXML.Tax_Bracket.min_lim2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim2.XmlText#"><cfelse>NULL</cfif>,
					MAX_PAYMENT_2 = <cfif len(BracketXML.Tax_Bracket.max_lim2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim2.XmlText#"><cfelse>NULL</cfif>,
					RATIO_2 = <cfif len(BracketXML.Tax_Bracket.tax_bracket_rate2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate2.XmlText#"><cfelse>NULL</cfif>,
					MIN_PAYMENT_3 = <cfif len(BracketXML.Tax_Bracket.min_lim3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim3.XmlText#"><cfelse>NULL</cfif>,
					MAX_PAYMENT_3 = <cfif len(BracketXML.Tax_Bracket.max_lim3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim3.XmlText#"><cfelse>NULL</cfif>,
					RATIO_3 = <cfif len(BracketXML.Tax_Bracket.tax_bracket_rate3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate3.XmlText#"><cfelse>NULL</cfif>,
					MIN_PAYMENT_4 = <cfif len(BracketXML.Tax_Bracket.min_lim4.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim4.XmlText#"><cfelse>NULL</cfif>,
					MAX_PAYMENT_4 = <cfif len(BracketXML.Tax_Bracket.max_lim4.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim4.XmlText#"><cfelse>NULL</cfif>,
					RATIO_4 = <cfif len(BracketXML.Tax_Bracket.tax_bracket_rate4.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate4.XmlText#"><cfelse>NULL</cfif>,
					MIN_PAYMENT_5 = <cfif len(BracketXML.Tax_Bracket.min_lim5.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim5.XmlText#"><cfelse>NULL</cfif>,
					MAX_PAYMENT_5 = <cfif len(BracketXML.Tax_Bracket.max_lim5.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim5.XmlText#"><cfelse>NULL</cfif>,
					RATIO_5 = <cfif len(BracketXML.Tax_Bracket.tax_bracket_rate5.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate5.XmlText#"><cfelse>NULL</cfif>,
					MIN_PAYMENT_6 = <cfif len(BracketXML.Tax_Bracket.min_lim6.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim6.XmlText#"><cfelse>NULL</cfif>,
					MAX_PAYMENT_6 = <cfif len(BracketXML.Tax_Bracket.max_lim6.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim6.XmlText#"><cfelse>NULL</cfif>,
					RATIO_6 = <cfif len(BracketXML.Tax_Bracket.tax_bracket_rate6.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate6.XmlText#"><cfelse>NULL</cfif>,
					SAKAT1 = <cfif len(BracketXML.Tax_Bracket.hand_disc1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.hand_disc1.XmlText#"><cfelse>NULL</cfif>,
					SAKAT2 = <cfif len(BracketXML.Tax_Bracket.hand_disc2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.hand_disc2.XmlText#"><cfelse>NULL</cfif>,
					SAKAT3 = <cfif len(BracketXML.Tax_Bracket.hand_disc3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.hand_disc3.XmlText#"><cfelse>NULL</cfif>,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				WHERE
					STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_startdate.XmlText#">
					AND FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_finishdate.XmlText#">
			</cfquery>
		<cfelse>
			<cfquery name="get_tax_slc_" dbtype="query">
				SELECT
					*
				FROM
					get_tax_slices
				WHERE
					(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_startdate.XmlText#">
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_startdate.XmlText#">)
					OR
					(STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_finishdate.XmlText#">
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_finishdate.XmlText#">)
			</cfquery>
			<cfif not get_tax_slc_.recordcount>
				<cfquery name="add_ins_pay" datasource="#dsn#">
					INSERT INTO
						SETUP_TAX_SLICES
					(
						NAME,
						MIN_PAYMENT_1,
						MAX_PAYMENT_1,
						RATIO_1,
						MIN_PAYMENT_2,
						MAX_PAYMENT_2,
						RATIO_2,
						MIN_PAYMENT_3,
						MAX_PAYMENT_3,
						RATIO_3,
						MIN_PAYMENT_4,
						MAX_PAYMENT_4,
						RATIO_4,
						MIN_PAYMENT_5,
						MAX_PAYMENT_5,
						RATIO_5,
						MIN_PAYMENT_6,
						MAX_PAYMENT_6,
						RATIO_6,
						SAKAT1,
						SAKAT2,
						SAKAT3,
						STARTDATE,
						FINISHDATE,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.per_year# Vergi Dilimleri">,
						<cfif len(BracketXML.Tax_Bracket.min_lim1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim1.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.max_lim1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim1.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.tax_bracket_rate1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate1.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.min_lim2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim2.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.max_lim2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim2.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.tax_bracket_rate2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate2.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.min_lim3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim3.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.max_lim3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim3.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.tax_bracket_rate3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate3.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.min_lim4.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim4.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.max_lim4.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim4.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.tax_bracket_rate4.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate4.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.min_lim5.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim5.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.max_lim5.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim5.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.tax_bracket_rate5.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate5.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.min_lim6.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.min_lim6.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.max_lim6.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.max_lim6.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.tax_bracket_rate6.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.tax_bracket_rate6.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.hand_disc1.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.hand_disc1.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.hand_disc2.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.hand_disc2.XmlText#"><cfelse>NULL</cfif>,
						<cfif len(BracketXML.Tax_Bracket.hand_disc3.XmlText)><cfqueryparam cfsqltype="cf_sql_float" value="#BracketXML.Tax_Bracket.hand_disc3.XmlText#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_startdate.XmlText#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#BracketXML.Tax_Bracket.tax_bracket_finishdate.XmlText#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	<cflocation url="#request.self#?fuseaction=#attributes.fuseaction#" addtoken="false">
</cfif>
<cfparam name="attributes.per_year" default="">
<cfdirectory directory="#upload_folder#hr#dir_seperator#ucret_bilgileri#dir_seperator#" name="dirQuery" action="list" filter="*.xml"> 
<div class="row">
	<div class="col col-12 form-inline">
        <cfform name="form_add" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<cf_box title="#getLang('','Ücret Bilgileri',53044)#">
				<div class="ui-form-list flex-list">
					<div class="form-group medium">
						<select name="per_year" id="per_year">
							<option value=""><cf_get_lang dictionary_id='58472.Dönem'>&nbsp;<cf_get_lang dictionary_id='57734.Seçiniz'></option> 
							<cfif dirQuery.recordcount gt 0> 
								<cfoutput query="dirQuery"> 
									<option value="#mid(name,17,4)#"<cfif attributes.per_year eq mid(name,17,4)> selected</cfif>>#mid(name,17,4)#</option> 
								</cfoutput> 
							</cfif> 
						</select>
					</div>
					<div class="form-group"><cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0'></div>
				</div>
			</cf_box>
        </cfform>
    </div>
</div>
<cf_box id="payments_box" title="#getLang('','Sigorta Primine Esas Ücretler',53045)#" box_page="#request.self#?fuseaction=ehesap.personal_payment&event=listPayments">
</cf_box>

<cf_box id="ratios_box" title="#getLang('','Sigorta Primin Oranları',53049)#" box_page="#request.self#?fuseaction=ehesap.personal_payment&event=listRatios">
</cf_box>

<cf_box id="tax_box" title="#getLang('','Vergi Dilimleri',53050)#" box_page="#request.self#?fuseaction=ehesap.personal_payment&event=listTax">
</cf_box>

<cf_box id="factor_box" title="#getLang('','Memur Ücret Katsayıları',63765)#" box_page="#request.self#?fuseaction=ehesap.personal_payment&event=listFactor">
</cf_box>

<cf_box  id="GradeStepParams" title="#getLang('','Memur Gösterge Tablosu',62925)#" widget_load="GradeStepParams"></cf_box>

<cf_box  id="DeductibleContributionRate" title="#getLang('','Kesenek Katkı Oranı',63738)#" widget_load="DeductibleContributionRate"></cf_box>

<cfif show_additional_course eq 1>
	<cf_box id="listCourses_box" title="#getLang('','Ek Ders Ücret Tablosu',63390)#" box_page="#request.self#?fuseaction=ehesap.personal_payment&event=listCourses"></cf_box>
</cfif>

<cf_box id="listRate_box" title="#getLang('','Akademik Teşvik Ödeneği Oranları',64062)#" box_page="#request.self#?fuseaction=ehesap.personal_payment&event=listAcademicRate"></cf_box>

