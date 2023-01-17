<!---Select  ifadeleri ile ilgili çalışma yapıldı. Egemen Ateş 16.07.2012 --->
<cfif not len(attributes.start_date)>
<cfset attributes.start_date = DateFormat(session.ep.period_start_date,dateformat_style)>
</cfif>
<cfif not len(attributes.finish_date)>
<cfset attributes.finish_date = DateFormat(session.ep.period_finish_date,dateformat_style)>
</cfif>
<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
<!--- e-defter islem kontrolu islem tarihi kontrolü icin FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
		<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
		<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
		<cfprocparam cfsqltype="cf_sql_varchar" value="">
		<cfprocresult name="getNetbook">
	</cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
			alert("<cf_get_lang dictionary_id='63221.Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<!--- e-defter islem kontrolu baslangıc bitis tarihleri kontrolu icin FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
		<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfprocparam cfsqltype="cf_sql_varchar" value="">
		<cfprocresult name="getNetbook">
	</cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
			alert('<cf_get_lang dictionary_id='63221.Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.'>');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- e-defter islem kontrolu FA --->


<cfif len(trim(attributes.TO_ACC_ID)) and len(trim(attributes.FROM_ACC_ID))>
	<cfif isdefined('attributes.is_acc_remainder_transfer') and attributes.is_acc_remainder_transfer eq 1><!--- hesabın bakiyesi aktarılacaksa --->
		<cf_date tarih="attributes.action_date">
		<cfset from_acc_code=trim(attributes.FROM_ACC_ID)>
		<cfset to_acc_code=trim(attributes.TO_ACC_ID)>
		<cfquery name="GET_ACC_CARD_ID" datasource="#DSN2#">
			SELECT MAX(CARD_ID) AS CARD_ID FROM ACCOUNT_CARD
		</cfquery>
		<cfquery name="get_acc_code_detail" datasource="#dsn2#">
			SELECT SUB_ACCOUNT,ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE='#from_acc_code#'
		</cfquery>
			<cfquery name="get_account_code_bakiye" datasource="#dsn2#">
				SELECT
					ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) AS BAKIYE, 
					ROUND(SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC - ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK),2) AS DOVIZLI_BAKIYE, 
					ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,
					ISNULL(ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_MONEY,
					ISNULL(ACCOUNT_ACCOUNT_REMAINDER.ACC_PROJECT_ID,0) AS ACC_PROJECT_ID<!--- ACC_PROJECT_ID hesap aktarımı yapılırken proje bazlı da aktrılsın(XML'e bağlı) --->
				FROM
				(
					SELECT
						0 AS ALACAK,
						 SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2)) AS BORC,		
						0 AS OTHER_AMOUNT_ALACAK,
						SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_BORC,
						ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'TL') AS OTHER_CURRENCY,		
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,
						ACCOUNT_CARD_ROWS.ACC_PROJECT_ID						
					FROM
						ACCOUNT_CARD_ROWS,ACCOUNT_CARD		
					WHERE
						BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID		
						<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
							AND (
							<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
								(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
								<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
							</cfloop>  
								)
						</cfif>	
						<cfif len(attributes.start_date)>
							AND ACCOUNT_CARD.ACTION_DATE >= #attributes.start_date#
						</cfif>
						<cfif len(attributes.finish_date)>
							AND ACCOUNT_CARD.ACTION_DATE <= #attributes.finish_date#
						</cfif>
						<cfif IsDefined("attributes.project_id") and len(attributes.project_id)>
							AND ACCOUNT_CARD_ROWS.ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						</cfif>						
					GROUP BY
						ACCOUNT_CARD_ROWS.ACCOUNT_ID		
						,ACCOUNT_CARD_ROWS.OTHER_CURRENCY
						,ACCOUNT_CARD_ROWS.ACC_PROJECT_ID
					HAVING SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2))<>0
				UNION ALL
					SELECT
						 SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2)) AS ALACAK,
						0 AS BORC,
						SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_ALACAK,
						0 AS OTHER_AMOUNT_BORC,
						ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'TL') AS OTHER_CURRENCY,		
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,
						ACCOUNT_CARD_ROWS.ACC_PROJECT_ID							
					FROM
						ACCOUNT_CARD_ROWS,ACCOUNT_CARD		
					WHERE
						BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID		
						<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
							AND (
							<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
								(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
								<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
							</cfloop>  
								)
						</cfif>	
						<cfif len(attributes.start_date)>
							AND ACCOUNT_CARD.ACTION_DATE >= #attributes.start_date#
						</cfif>
						<cfif len(attributes.finish_date)>
							AND ACCOUNT_CARD.ACTION_DATE <= #attributes.finish_date#
						</cfif>	
						<cfif IsDefined("attributes.project_id") and len(attributes.project_id)>
							AND ACCOUNT_CARD_ROWS.ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						</cfif>							
					GROUP BY
						ACCOUNT_CARD_ROWS.ACCOUNT_ID,		
						ACCOUNT_CARD_ROWS.OTHER_CURRENCY,
						ACCOUNT_CARD_ROWS.ACC_PROJECT_ID						
					HAVING SUM(ROUND(ACCOUNT_CARD_ROWS.AMOUNT,2))<>0 
				) AS ACCOUNT_ACCOUNT_REMAINDER
			WHERE
				<cfif get_acc_code_detail.sub_account eq 1> <!---ust hesap secilmisse, bu hesaba ait alt hesapların bakiyeleri seçilen alacak hesaba aktarılır. --->
					ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE '#from_acc_code#.%'
				<cfelse>
					ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID='#from_acc_code#'
				</cfif>
			GROUP BY	
				ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,
				ISNULL(ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY,'#session.ep.money#'),
				ISNULL(ACCOUNT_ACCOUNT_REMAINDER.ACC_PROJECT_ID,0)
			</cfquery>
		<cfif get_account_code_bakiye.recordcount>
        
           <cfscript>
				if(len(listgetat(session.ep.user_location,2,'-')) )
					to_branch_id =listgetat(session.ep.user_location,2,'-');
				else
					to_branch_id = '';
					
				borc_hesap_list='';
				alacak_hesap_list='';
				tutar_list ='';
				doviz_tutar_list = '';
				doviz_currency_list = '';
				satir_detay_list ='';
				alacakli_project_list = '';
				borclu_project_list = '';
				
				for(acc_j=1; acc_j lte get_account_code_bakiye.recordcount; acc_j=acc_j+1)
				{
					if(get_account_code_bakiye.BAKIYE[acc_j] lt 0) /*alacak bakiye vermisse*/
					{
						borc_hesap_list = listappend(borc_hesap_list,get_account_code_bakiye.ACCOUNT_ID[acc_j]);
						alacak_hesap_list = listappend(alacak_hesap_list,to_acc_code);
						borclu_project_list = listappend(borclu_project_list,get_account_code_bakiye.ACC_PROJECT_ID[acc_j]);						
						alacakli_project_list = listappend(alacakli_project_list,get_account_code_bakiye.ACC_PROJECT_ID[acc_j]);						
					}
					else
					{
						borc_hesap_list = listappend(borc_hesap_list,to_acc_code);
						alacak_hesap_list = listappend(alacak_hesap_list,get_account_code_bakiye.ACCOUNT_ID[acc_j]);
						alacakli_project_list = listappend(alacakli_project_list,get_account_code_bakiye.ACC_PROJECT_ID[acc_j]);
						borclu_project_list = listappend(borclu_project_list,get_account_code_bakiye.ACC_PROJECT_ID[acc_j]);
					}

					tutar_list = listappend(tutar_list,abs(get_account_code_bakiye.BAKIYE[acc_j]));
					
					if(get_account_code_bakiye.OTHER_MONEY[acc_j] is session.ep.money and get_account_code_bakiye.DOVIZLI_BAKIYE[acc_j] eq 0)
						doviz_tutar_list = listappend(doviz_tutar_list,abs(get_account_code_bakiye.BAKIYE[acc_j]));
					else
						doviz_tutar_list = listappend(doviz_tutar_list,abs(get_account_code_bakiye.DOVIZLI_BAKIYE[acc_j]));
					doviz_currency_list = listappend(doviz_currency_list,get_account_code_bakiye.OTHER_MONEY[acc_j]);
					
					/******Açıklama alanı için kontrol yapılması.*******/
					if(isdefined("attributes.detail") and len(attributes.detail))
					{
						fis_satir_detay_info=attributes.DETAIL;
						satir_detay_list = attributes.DETAIL;
					}	
					else
					{
						fis_satir_detay_info = UCase(getLang('main',2743));//VİRMAN (MUHASEBE) İŞLEMİ
						satir_detay_list =  UCase(getLang('main',2743));//VİRMAN (MUHASEBE) İŞLEMİ
					}	
				}
				muhasebeci (
					action_id : (GET_ACC_CARD_ID.CARD_ID+1),
					workcube_process_type : 17,			
					account_card_type : 13,
					islem_tarihi : attributes.ACTION_DATE,
					borc_hesaplar : borc_hesap_list,
					borc_tutarlar : tutar_list,
					alacak_hesaplar : alacak_hesap_list,
					alacak_tutarlar : tutar_list,
					other_amount_borc : doviz_tutar_list,
					other_currency_borc : doviz_currency_list,
					other_amount_alacak : doviz_tutar_list,
					other_currency_alacak : doviz_currency_list,
					to_branch_id : to_branch_id,
					fis_satir_detay: satir_detay_list,
					fis_detay : fis_satir_detay_info,
					acc_project_list_borc : borclu_project_list,
					acc_project_list_alacak : alacakli_project_list,
					is_account_group : 1
				);
			</cfscript>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='59055.Hesaba Ait Aktarılacak Bakiye Bulunamadı'>!");
				window.location.href="<cfoutput>#request.self#?fuseaction=account.add_acc_to_acc</cfoutput>";
				//window.close();
			</script>
			<cfabort>	
		</cfif>
	<cfelse>
		<cfquery name="get_1" datasource="#DSN2#">
			SELECT SUB_ACCOUNT FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE ='#attributes.TO_ACC_ID#'
		</cfquery>
		<cfif not get_1.recordcount>
			<script type="text/javascript">
				alert("<cfoutput>#attributes.TO_ACC_ID#</cfoutput> <cf_get_lang dictionary_id='47495.Seçtiğiniz Hesap, Muhasebe Hesap Planında Yoktur'>!");
				history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfif get_1.SUB_ACCOUNT>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='47496.Aktarım Yapılacak Hesabın Alt Hesapları Mevcuttur'>!");
					history.back();
				</script>
				<cfabort>		
			</cfif>
		</cfif>
		<cfquery name="get_2" datasource="#DSN2#">
			SELECT ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE ='#attributes.FROM_ACC_ID#'
		</cfquery>
		<cfif not get_2.recordcount>
			<script type="text/javascript">
				alert("<cfoutput>#attributes.FROM_ACC_ID#</cfoutput> <cf_get_lang dictionary_id='47495.Seçtiğiniz Hesap, Muhasebe Hesap Planında Yoktur'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
        <cfquery name="change_records_" datasource="#DSN2#">
            UPDATE
                ACCOUNT_CARD_ROWS
            SET
                ACCOUNT_ID='#attributes.TO_ACC_ID#'
            WHERE
                ACCOUNT_ID='#attributes.FROM_ACC_ID#'	
            <cfif len(attributes.start_date) and len(attributes.finish_date)>
                AND CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#)
            </cfif>
			<cfif IsDefined("attributes.project_id") and len(attributes.project_id)>
				AND ACCOUNT_CARD_ROWS.ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>	
        </cfquery>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='47494.Hesap İsimlerinizde Sorun Var'>.");
		history.back();
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	/* wrk_opener_reload();
	window.close(); */
	alert("<cf_get_lang dictionary_id='44493.Aktarım Tamamlandı'>");
	window.location.href="<cfoutput>#request.self#?fuseaction=account.add_acc_to_acc</cfoutput>";
</script>
