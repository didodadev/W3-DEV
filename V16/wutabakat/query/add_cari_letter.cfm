<cfif isdefined("attributes.cari_letter_id") and len(attributes.cari_letter_id)>
	<cfif isdefined("attributes.company_id")>
		<cflock timeout="60">
			<cftransaction>
				<cfloop list="#attributes.company_id#" index="i">
					<cfset uuidvalue = CreateUUID()>
					<cfquery name="UPDMAIN" datasource="#dsn2#">
						UPDATE 
							CARI_LETTER 
						SET 
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#'
						WHERE 
							CARI_LETTER_ID = #attributes.cari_letter_id#
					</cfquery>
					<cfquery name="GETTYPE" datasource="#dsn2#">
						SELECT 
							IS_CH,
							IS_CR,
							IS_BA,
							IS_BS 
						FROM 
							CARI_LETTER
						WHERE 
							CARI_LETTER_ID = #attributes.cari_letter_id#
					</cfquery>
					<cfquery name="ADDMEMBERLETTER" datasource="#dsn2#">
						UPDATE 
							CARI_LETTER_ROW
						SET
							<!--- Mutabakat --->
							<cfif gettype.is_ch eq 1>
								IS_CH_AMOUNT =  <cfif isdefined("attributes.is_ch_amount#i#") and len(evaluate("attributes.is_ch_amount#i#"))>#filternum(evaluate("attributes.is_ch_amount#i#"))#<cfelse>0</cfif>,
							</cfif>
							<!--- Cari Hatırlatma --->
							<cfif gettype.is_cr eq 1>
								IS_CR_AMOUNT =  <cfif isdefined("attributes.is_cr_amount#i#") and len(evaluate("attributes.is_cr_amount#i#"))>#filternum(evaluate("attributes.is_cr_amount#i#"))#<cfelse>0</cfif>,
							</cfif>
							<!--- BA --->
							<cfif gettype.is_ba eq 1>
								IS_BA_TOTAL = <cfif isdefined("attributes.is_ba_total#i#") and len(evaluate("attributes.is_ba_total#i#"))>#filternum(evaluate("attributes.is_ba_total#i#"))#<cfelse>0</cfif>,
								IS_BA_AMOUNT = <cfif isdefined("attributes.is_ba_amount#i#") and len(evaluate("attributes.is_ba_amount#i#"))>#filternum(evaluate("attributes.is_ba_amount#i#"))#<cfelse>0</cfif>,
							</cfif>
							<!--- BS --->
							<cfif gettype.is_bs eq 1>
								IS_BS_TOTAL = <cfif isdefined("attributes.is_bs_total#i#") and len(evaluate("attributes.is_bs_total#i#"))>#filternum(evaluate("attributes.is_bs_total#i#"))#<cfelse>0</cfif>,
								IS_BS_AMOUNT = <cfif isdefined("attributes.is_bs_amount#i#") and len(evaluate("attributes.is_bs_amount#i#"))>#filternum(evaluate("attributes.is_bs_amount#i#"))#<cfelse>0</cfif>,
							</cfif>
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#'
						WHERE 
							CARI_LETTER_ID = #attributes.cari_letter_id# AND
							COMPANY_ID = #evaluate("attributes.company_id_#i#")#
					</cfquery>
				</cfloop>
			</cftransaction>
		</cflock>
		<cflocation url="index.cfm?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=#attributes.cari_letter_id#" addtoken="no">
	<cfelse>
		<script language="javascript">
			alert("<cf_get_lang dictionary_id='64403.Herhangi Bir Cari Seçmediniz!'>");
			window.location.href='index.cfm?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=<cfoutput>#attributes.cari_letter_id#</cfoutput>';
		</script>
	</cfif>
<cfelse>
	<cfif isdefined("attributes.company_id")>
		<cfif len(attributes.start_date_)>
			<cf_date tarih='attributes.start_date_'>
		</cfif>
		<cfif len(attributes.finish_date_)>
			<cf_date tarih='attributes.finish_date_'>
		</cfif>
		<cflock timeout="60">
			<cftransaction>
				<cfquery name="ADDMAIN" datasource="#dsn2#">
					INSERT 
					INTO 
						CARI_LETTER
						(
							OUR_COMPANY_ID,
							PERIOD_ID,
							START_DATE,
							FINISH_DATE,
							KEYWORD,
							SEARCH_ORDER_ID,
							SEARCH_TYPE_ID,
							IS_ZERO,
							IS_ACTION,
							IS_OPEN,
							BABS_AMOUNT,
							IS_CH,
							IS_CR,
							IS_BA,
							IS_BS,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						) 
						VALUES 
						(
							#session.ep.company_id#,
							#session.ep.period_id#,
							#attributes.start_date_#,
							#attributes.finish_date_#,
						   '#attributes.keyword#',
							<cfif len(attributes.search_order_id)>#attributes.search_order_id#<cfelse>null</cfif>,
							<cfif len(attributes.search_type_id)>#attributes.search_type_id#<cfelse>null</cfif>,
							<cfif len(attributes.is_zero)>#attributes.is_zero#<cfelse>null</cfif>,
							<cfif len(attributes.is_action)>#attributes.is_action#<cfelse>null</cfif>,
							<cfif len(attributes.is_open)>#attributes.is_open#<cfelse>null</cfif>,
							<cfif len(attributes.babs_limit)>#filternum(attributes.babs_limit)#<cfelse>null</cfif>,
							<cfif attributes.is_babs eq 1>1<cfelse>0</cfif>,
							<cfif attributes.is_babs eq 2>1<cfelse>0</cfif>,
							<cfif attributes.is_babs eq 3>1<cfelse>0</cfif>,
							<cfif attributes.is_babs eq 4>1<cfelse>0</cfif>,
							#session.ep.userid#,
							#now()#,
						   '#cgi.remote_addr#'
						)
				</cfquery>
				<cfquery name="GETMAX" datasource="#dsn2#">
					SELECT MAX(CARI_LETTER_ID) AS MAX_ID FROM CARI_LETTER
				</cfquery>
				<cfloop list="#attributes.company_id#" index="i">
					<cfset uuidvalue = CreateUUID()>
					<cfquery name="ADDMEMBERLETTER" datasource="#dsn2#">
						INSERT 
						INTO 
							CARI_LETTER_ROW
							(
								CARI_LETTER_ID,
								COMPANY_ID,
								UNIQUE_ID,
								START_DATE,
								FINISH_DATE,
								CARI_STATUS,
								IS_CH_AMOUNT,
								IS_CR_AMOUNT,
								IS_BA_TOTAL,
								IS_BA_AMOUNT,
								IS_BS_TOTAL,
								IS_BS_AMOUNT,
								CH_EMAIL,
								AS_EMAIL,
								RECORD_EMP,
								RECORD_DATE,
								RECORD_IP,
								ACCOUNT_CODE,
								ACCOUNT_AMOUNT,
								AMOUNT_OTHER,
								OTHER_MONEY
							) 
							VALUES 
							(
								#getmax.max_id#,
								#evaluate("attributes.company_id_#i#")#,
							   '#uuidvalue#',
								#attributes.start_date_#,
								#attributes.finish_date_#,
								#evaluate("attributes.caristatus#i#")#,
								<!--- Mutabakat --->
								<cfif attributes.is_babs eq 1>
									<cfif isdefined("attributes.cariamount#i#") and len(evaluate("attributes.cariamount#i#"))>#filternum(evaluate("attributes.cariamount#i#"))#<cfelse>0</cfif>,
								<cfelse>
									0,
								</cfif>
								<!--- Cari Hatırlatma --->
								<cfif attributes.is_babs eq 2>
									<cfif isdefined("attributes.cariamount#i#") and len(evaluate("attributes.cariamount#i#"))>#filternum(evaluate("attributes.cariamount#i#"))#<cfelse>0</cfif>,
								<cfelse>
									0,
								</cfif>
								<!--- BA --->
								<cfif attributes.is_babs eq 3>
									<cfif isdefined("attributes.batotal#i#") and len(evaluate("attributes.batotal#i#"))>#filternum(evaluate("attributes.batotal#i#"))#<cfelse>0</cfif>,
									<cfif isdefined("attributes.baamount#i#") and len(evaluate("attributes.baamount#i#"))>#filternum(evaluate("attributes.baamount#i#"))#<cfelse>0</cfif>,
								<cfelse>
									0,
									0,
								</cfif>
								<!--- BS --->
								<cfif attributes.is_babs eq 4>
									<cfif isdefined("attributes.bstotal#i#") and len(evaluate("attributes.bstotal#i#"))>#filternum(evaluate("attributes.bstotal#i#"))#<cfelse>0</cfif>,
									<cfif isdefined("attributes.bsamount#i#") and len(evaluate("attributes.bsamount#i#"))>#filternum(evaluate("attributes.bsamount#i#"))#<cfelse>0</cfif>,
								<cfelse>
									0,
									0,
								</cfif>
								<cfif isdefined("attributes.chemail#i#") and len(evaluate("attributes.chemail#i#"))>'#evaluate("attributes.chemail#i#")#'<cfelse>null</cfif>,
								<cfif isdefined("attributes.asemail#i#") and len(evaluate("attributes.asemail#i#"))>'#evaluate("attributes.asemail#i#")#'<cfelse>null</cfif>,
								#session.ep.userid#,
								#now()#,
							   '#cgi.remote_addr#',
							   '#evaluate("attributes.accountcode#i#")#',
							   <cfif isdefined("attributes.accountamount#i#") and len(evaluate("attributes.accountamount#i#"))>#filternum(evaluate("attributes.accountamount#i#"))#<cfelse>0</cfif>,
							   <cfif isdefined("attributes.cariamount_sistem#i#") and len(evaluate("attributes.cariamount_sistem#i#"))>#filternum(evaluate("attributes.cariamount_sistem#i#"))#<cfelse>0</cfif>,
							   <cfif isdefined("attributes.moneytype#i#") and len(evaluate("attributes.moneytype#i#"))>'#evaluate("attributes.moneytype#i#")#'<cfelse>null</cfif>
							)
					</cfquery>
				</cfloop>
			</cftransaction>
		</cflock>
		<cflocation url="index.cfm?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=#getmax.max_id#" addtoken="no">
	<cfelse>
		<script language="javascript">
			alert("<cf_get_lang dictionary_id='64403.Herhangi Bir Cari Seçmediniz!'> <cf_get_lang dictionary_id='64404.Mutabakat Kaydı Yapılamayacak!'>");
			window.location.href='index.cfm?fuseaction=finance.list_cari_letter';
		</script>
	</cfif>
</cfif>