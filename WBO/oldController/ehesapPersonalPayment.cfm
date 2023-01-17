<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfinclude template="../hr/ehesap/query/get_insurance_payments.cfm">
	<cfinclude template="../hr/ehesap/query/get_insurance_ratios.cfm">
	<cfinclude template="../hr/ehesap/query/get_tax_slices.cfm">
	<cfif isdefined('attributes.get_xml') and attributes.get_xml eq 1>
		<cfif not len(attributes.per_year)> 
			<script type="text/javascript"> 
				alert("<cf_get_lang dictionary_id='43274.Dönem seçmelisiniz'>!"); 
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
				alert("<cfoutput>#attributes.per_year#</cfoutput> <cf_get_lang dictionary_id='54634.yılı için bordro parametreleri tanımlı değildir'>!");
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
	<!---<cfif isdefined("is_gov_payroll") and is_gov_payroll eq 1>---><!--- memur bordrosu--->
		<cfinclude template="../hr/ehesap/query/get_factor_definition.cfm">
	<!---</cfif>--->
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_ins_pay'>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_insurance_payment.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_ins_rat'>
	<cf_get_lang_set module_name="ehesap">
	<cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
	<cfinclude template="../hr/ehesap/query/get_insurance_ratio.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_tax_sl'>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_tax_slice.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_fac_def'>
	<cfset attributes.factor_id = attributes.id>
	<cfinclude template="../hr/ehesap/query/get_factor_definition.cfm">
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add_ins_pay' or attributes.event is 'upd_ins_pay' or attributes.event is 'add_tax_sl' or attributes.event is 'upd_tax_sl' or attributes.event is 'add_fac_def' or attributes.event is 'upd_fac_def')>
		function UnformatFields()
		{
			<cfif attributes.event is 'add_ins_pay' or attributes.event is 'upd_ins_pay'>
				$('#seniority_compansation_max').val(filterNum($('#seniority_compansation_max').val()));	
				$('#min_gross_payment_normal').val(filterNum($('#min_gross_payment_normal').val()));
				$('#min_gross_payment_16').val(filterNum($('#min_gross_payment_16').val()));
				$('#minimum').val(filterNum($('#minimum').val()));
				$('#maximum').val(filterNum($('#maximum').val()));
			<cfelseif attributes.event is 'add_tax_sl' or attributes.event is 'upd_tax_sl'>
				$('#min_payment_1').val(filterNum($('#min_payment_1').val()));
				$('#max_payment_1').val(filterNum($('#max_payment_1').val()));
				$('#min_payment_2').val(filterNum($('#min_payment_2').val()));
				$('#max_payment_2').val(filterNum($('#max_payment_2').val()));
				$('#min_payment_3').val(filterNum($('#min_payment_3').val()));
				$('#max_payment_3').val(filterNum($('#max_payment_3').val()));
				$('#min_payment_4').val(filterNum($('#min_payment_4').val()));
				$('#max_payment_4').val(filterNum($('#max_payment_4').val()));
				$('#min_payment_5').val(filterNum($('#min_payment_5').val()));
				$('#max_payment_5').val(filterNum($('#max_payment_5').val()));
				$('#min_payment_6').val(filterNum($('#min_payment_6').val()));
				$('#max_payment_6').val(filterNum($('#max_payment_6').val()));
				$('#sakat1').val(filterNum($('#sakat1').val(),6));
				$('#sakat2').val(filterNum($('#sakat2').val(),6));
				$('#sakat3').val(filterNum($('#sakat3').val(),6));
			<cfelseif attributes.event is 'add_fac_def' or attributes.event is 'upd_fac_def'>
				$('#salary_factor').val(filterNum($('#salary_factor').val(),7));
				$('#base_salary_factor').val(filterNum($('#base_salary_factor').val(),7));
				$('#benefit_factor').val(filterNum($('#benefit_factor').val(),7));
			</cfif>
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/personal_payment.cfm';
	
	WOStruct['#attributes.fuseaction#']['add_ins_pay'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_ins_pay']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_ins_pay']['fuseaction'] = 'ehesap.popup_form_add_insurance_payments';
	WOStruct['#attributes.fuseaction#']['add_ins_pay']['filePath'] = 'hr/ehesap/form/form_add_insurance_payments.cfm';
	WOStruct['#attributes.fuseaction#']['add_ins_pay']['queryPath'] = 'hr/ehesap/query/add_insurance_payments.cfm';
	WOStruct['#attributes.fuseaction#']['add_ins_pay']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['add_ins_pay']['Identity'] = '##lang_array.item[109]##';
	
	WOStruct['#attributes.fuseaction#']['add_ins_rat'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_ins_rat']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_ins_rat']['fuseaction'] = 'ehesap.popup_form_add_insurance_ratio';
	WOStruct['#attributes.fuseaction#']['add_ins_rat']['filePath'] = 'hr/ehesap/form/form_add_insurance_ratio.cfm';
	WOStruct['#attributes.fuseaction#']['add_ins_rat']['queryPath'] = 'hr/ehesap/query/add_insurance_ratio.cfm';
	WOStruct['#attributes.fuseaction#']['add_ins_rat']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['add_ins_rat']['Identity'] = '##lang_array.item[240]##';
	
	WOStruct['#attributes.fuseaction#']['add_tax_sl'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_tax_sl']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_tax_sl']['fuseaction'] = 'ehesap.popup_form_add_tax_slice';
	WOStruct['#attributes.fuseaction#']['add_tax_sl']['filePath'] = 'hr/ehesap/form/add_tax_slice.cfm';
	WOStruct['#attributes.fuseaction#']['add_tax_sl']['queryPath'] = 'hr/ehesap/query/add_tax_slice.cfm';
	WOStruct['#attributes.fuseaction#']['add_tax_sl']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['add_tax_sl']['Identity'] = '##lang_array.item[112]##';
	
	WOStruct['#attributes.fuseaction#']['add_fac_def'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_fac_def']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_fac_def']['fuseaction'] = 'ehesap.popup_form_add_factor_definition';
	WOStruct['#attributes.fuseaction#']['add_fac_def']['filePath'] = 'hr/ehesap/form/form_add_factor_definition.cfm';
	WOStruct['#attributes.fuseaction#']['add_fac_def']['queryPath'] = 'hr/ehesap/query/add_factor_definition.cfm';
	WOStruct['#attributes.fuseaction#']['add_fac_def']['nextEvent'] = 'ehesap.personal_payment';
	
	WOStruct['#attributes.fuseaction#']['upd_ins_pay'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['fuseaction'] = 'ehesap.popup_form_upd_insurance_payments';
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['filePath'] = 'hr/ehesap/form/form_upd_insurance_payments.cfm';
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['queryPath'] = 'hr/ehesap/query/upd_insurance_payments.cfm';
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['parameters'] = 'ins_pay_id=##attributes.ins_pay_id##';
	WOStruct['#attributes.fuseaction#']['upd_ins_pay']['Identity'] = '##lang_array.item[113]##';
	
	WOStruct['#attributes.fuseaction#']['upd_ins_rat'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['fuseaction'] = 'ehesap.popup_form_upd_insurance_ratio';
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['filePath'] = 'hr/ehesap/form/form_upd_insurance_ratio.cfm';
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['queryPath'] = 'hr/ehesap/query/upd_insurance_ratio.cfm';
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['parameters'] = 'ins_rat_id=##attributes.ins_rat_id##';
	WOStruct['#attributes.fuseaction#']['upd_ins_rat']['Identity'] = '##lang_array.item[263]##';
	
	WOStruct['#attributes.fuseaction#']['upd_tax_sl'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['fuseaction'] = 'ehesap.popup_form_upd_tax_slice';
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['filePath'] = 'hr/ehesap/form/upd_tax_slice.cfm';
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['queryPath'] = 'hr/ehesap/query/upd_tax_slice.cfm';
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['parameters'] = 'tax_sl_id=##attributes.tax_sl_id##';
	WOStruct['#attributes.fuseaction#']['upd_tax_sl']['Identity'] = '##lang_array.item[277]##';
	
	WOStruct['#attributes.fuseaction#']['upd_fac_def'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['fuseaction'] = 'ehesap.popup_form_upd_factor_definition';
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['filePath'] = 'hr/ehesap/form/form_upd_factor_definition.cfm';
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['queryPath'] = 'hr/ehesap/query/upd_factor_definition.cfm';
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['nextEvent'] = 'ehesap.personal_payment';
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd_fac_def']['Identity'] = 'Katsayı Güncelle';
	
	if (isdefined("attributes.event") and listfind('add_ins_pay,upd_ins_pay,add_ins_rat,upd_ins_rat,add_tax_sl,upd_tax_sl,add_fac_def',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapPersonalPayment.cfm';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		
		if (listfind('add_ins_pay,upd_ins_pay',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INSURANCE_PAYMENT';
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_ins_pay,upd_ins_pay';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate','item-finishdate','item-minimum','item-maximum','item-min_gross_payment_normal','item-min_gross_payment_16','item-seniority_compansation_max']";
			
			if(attributes.event is 'upd_ins_pay')
			{
				WOStruct['#attributes.fuseaction#']['del_ins_pay'] = structNew();
				WOStruct['#attributes.fuseaction#']['del_ins_pay']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del_ins_pay']['fuseaction'] = 'ehesap.personal_payment&event=del_ins_pay&ins_pay_id=#attributes.ins_pay_id#';
				WOStruct['#attributes.fuseaction#']['del_ins_pay']['filePath'] = 'hr/ehesap/query/del_insurance_payments.cfm';
				WOStruct['#attributes.fuseaction#']['del_ins_pay']['queryPath'] = 'hr/ehesap/query/del_insurance_payments.cfm';
				WOStruct['#attributes.fuseaction#']['del_ins_pay']['nextEvent'] = 'ehesap.personal_payment';
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_pay'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_pay']['icons'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_pay']['icons']['add']['text'] = '#lang_array.item[109]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_pay']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.personal_payment&event=add_ins_pay";
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
		}
		else if (listfind('add_ins_rat,upd_ins_rat',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INSURANCE_RATIO';
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_ins_rat,upd_ins_rat';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-mom_insurance_premium_worker','item-pat_ins_premium_worker','item-pat_ins_premium_worker_2','item-death_insurance_premium_worker','item-death_insurance_worker','item-soc_sec_insurance_worker','item-mom_insurance_premium_boss','item-pat_ins_premium_boss','item-pat_ins_premium_boss','item-death_insurance_premium_boss','item-death_insurance_boss','item-soc_sec_insurance_boss']";
			
			if (attributes.event is 'upd_ins_rat')
			{
				WOStruct['#attributes.fuseaction#']['del_ins_rat'] = structNew();
				WOStruct['#attributes.fuseaction#']['del_ins_rat']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del_ins_rat']['fuseaction'] = 'ehesap.personal_payment&event=del_ins_rat&ins_rat_id=#attributes.ins_rat_id#';
				WOStruct['#attributes.fuseaction#']['del_ins_rat']['filePath'] = 'hr/ehesap/query/del_insurance_ratio.cfm';
				WOStruct['#attributes.fuseaction#']['del_ins_rat']['queryPath'] = 'hr/ehesap/query/del_insurance_ratio.cfm';
				WOStruct['#attributes.fuseaction#']['del_ins_rat']['nextEvent'] = 'ehesap.personal_payment';
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_rat'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_rat']['icons'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_rat']['icons']['add']['text'] = '#lang_array.item[240]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_ins_rat']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.personal_payment&event=add_ins_rat";
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
		}
		else if (listfind('add_tax_sl,upd_tax_sl',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_TAX_SLICES';
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_tax_sl,upd_tax_sl';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-name','item-startdate','item-ratio_1','item-ratio_2','item-ratio_3','item-ratio_4','item-ratio_5','item-ratio_6','item-sakat1','item-sakat2','item-sakat3']";
			
			if (attributes.event is 'upd_tax_sl')
			{
				WOStruct['#attributes.fuseaction#']['del_tax_sl'] = structNew();
				WOStruct['#attributes.fuseaction#']['del_tax_sl']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del_tax_sl']['fuseaction'] = 'ehesap.personal_payment&event=del_tax_sl&tax_sl_id=#attributes.tax_sl_id#';
				WOStruct['#attributes.fuseaction#']['del_tax_sl']['filePath'] = 'hr/ehesap/query/del_tax_slice.cfm';
				WOStruct['#attributes.fuseaction#']['del_tax_sl']['queryPath'] = 'hr/ehesap/query/del_tax_slice.cfm';
				WOStruct['#attributes.fuseaction#']['del_tax_sl']['nextEvent'] = 'ehesap.personal_payment';
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_tax_sl'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_tax_sl']['icons'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_tax_sl']['icons']['add']['text'] = '#lang_array.item[112]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_tax_sl']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.personal_payment&event=add_tax_sl";
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
		}
		else if (listfind('add_fac_def,upd_fac_def',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARY_FACTOR_DEFINITION';
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_fac_def';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate','item-finishdate','item-salary_factor','item-base_salary_factor','item-benefit_factor']";
			
			if (attributes.event is 'upd_fac_def')
			{
				WOStruct['#attributes.fuseaction#']['del_fac_def'] = structNew();
				WOStruct['#attributes.fuseaction#']['del_fac_def']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del_fac_def']['fuseaction'] = 'ehesap.personal_payment&event=del_fac_def&id=#attributes.id#';
				WOStruct['#attributes.fuseaction#']['del_fac_def']['filePath'] = 'hr/ehesap/query/del_factor_definition.cfm';
				WOStruct['#attributes.fuseaction#']['del_fac_def']['queryPath'] = 'hr/ehesap/query/del_factor_definition.cfm';
				WOStruct['#attributes.fuseaction#']['del_fac_def']['nextEvent'] = 'ehesap.personal_payment';
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_fac_def'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_fac_def']['icons'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_fac_def']['icons']['add']['text'] = 'Katsayı Ekle';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_fac_def']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.personal_payment&event=add_fac_def";
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
		}
	}
</cfscript>
