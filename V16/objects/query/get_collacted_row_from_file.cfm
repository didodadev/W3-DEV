<cfsetting showdebugoutput="no">
<!--- Dosyadan satir ekleme  --->
<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#objects#dir_seperator#">
<cfif not DirectoryExists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">

	<cfscript>
		CRLF = Chr(13) & Chr(10);// satir atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfset counter= 1>
	<cfloop from="2" to="#line_count#" index="k">
		<cfset counter++>
		<cfif type eq 1><!--- type 1: Toplu Dekont Ekleme (doviz tutara gore tutar hesaplanir)--->
			<cfset member_type = attributes.member_type>
			<cfscript>
				if(Left(dosya[k],1) != ';'){
					member_code = trim(ListGetAt(dosya[k],1,";"));				//cari hesap
					action_value_other = trim(ListGetAt(dosya[k],2,";"));		//dovizli tutar
					money = trim(ListGetAt(dosya[k],3,";")); 					//para birimi
					action_detail = trim(ListGetAt(dosya[k],4,";")); 			//aciklama
					project_id = trim(ListGetAt(dosya[k],5,";")); 				//proje_id
					contract_id = trim(ListGetAt(dosya[k],6,";"));				//sozlesme id
					action_account_code = trim(ListGetAt(dosya[k],7,";"));		//muhasebe kodu		
					expense_center_id = trim(ListGetAt(dosya[k],8,";"));		//masraf merkezi id
					expense_item_id = trim(ListGetAt(dosya[k],9,";"));			//gider kalemi id
					income_center_id = trim(ListGetAt(dosya[k],10,";"));		//gelir merkezi id
					if(listlen(dosya[k],';') gte 11)							//gelir kalemi id
						income_item_id = trim(ListGetAt(dosya[k],11,";"));
					else
						income_item_id = '';
					if(listlen(dosya[k],';') gte 12)							//cari hesap tipi
						acc_type_id = trim(ListGetAt(dosya[k],12,";"));
					else
						acc_type_id = '';
				}
			</cfscript>
			<cfoutput>
				<cfif isdefined("member_code") and len(member_code)>
					<!--- tutar --->
					<cfif not len(action_value_other)><cfset action_value_other = 0><cfelse><cfset action_value_other = replace(action_value_other,',','.','all')></cfif>
					<!--- muhasebe kodu --->
					<cfif not len(action_account_code)><cfset action_account_code = ''></cfif>
					<!--- para birimi --->
					<cfif len(money)>
						<cfquery name="get_money" datasource="#dsn2#">
							SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
						</cfquery>
						<cfset other_money = '#get_money.MONEY_TYPE#'>
					<cfelse>
						<cfset other_money = ''>
					</cfif>
					<!--- gider/masraf merkezi --->
					<cfif len(expense_center_id)>
						<cfquery name="get_exp_center" datasource="#dsn2#">
							SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_center_id#">
						</cfquery>
						<cfset expense_center_name = get_exp_center.EXPENSE>
					<cfelse>
						<cfset expense_center_name = ''>
					</cfif>
					<!--- gider kalemi --->
					<cfif len(expense_item_id)>
						<cfquery name="get_exp_item" datasource="#dsn2#">
							SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_item_id#">
						</cfquery>
						<cfset expense_item_name = get_exp_item.EXPENSE_ITEM_NAME>
					<cfelse>
						<cfset expense_item_name = ''>
					</cfif>
					<!--- gelir merkezi --->
					<cfif len(income_center_id)>
						<cfquery name="get_inc_center" datasource="#dsn2#">
							SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#income_center_id#">
						</cfquery>
						<cfset income_center_name = get_inc_center.EXPENSE>
					<cfelse>
						<cfset income_center_name = ''>
					</cfif>
					<!--- gelir kalemi --->
					<cfif len(income_item_id)>
						<cfquery name="get_inc_item" datasource="#dsn2#">
							SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#income_item_id#">
						</cfquery>
						<cfset income_item_name = get_inc_item.EXPENSE_ITEM_NAME>
					<cfelse>
						<cfset income_item_name = ''>
					</cfif>
					<!--- proje --->
					<cfif len(project_id)>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
						</cfquery>
						<cfset project = get_project.project_head>
					<cfelse>
						<cfset project = ''>
					</cfif>
					<!--- sozlesme --->
					<cfif len(contract_id)>
						<cfquery name="get_contract" datasource="#dsn3#">
							SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contract_id#">
						</cfquery>
						<cfset contract_head = get_contract.CONTRACT_HEAD>
					<cfelse>
						<cfset contract_head = ''>
					</cfif>
					<!--- uye --->
					<cfif member_type eq 1><!--- kurumsal uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								FULLNAME NAME,
								'partner' MEMBER_TYPE,
								COMPANY_ID,
								'' CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								COMPANY 
							WHERE 
								MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
						</cfquery>
					<cfelseif member_type eq 2> <!--- bireysel uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								CONSUMER_NAME +' '+ CONSUMER_SURNAME NAME,
								'consumer' MEMBER_TYPE,
								'' COMPANY_ID,
								CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								CONSUMER 
							WHERE 
								MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
						</cfquery>
					<cfelseif member_type eq 3> <!--- Çalışan --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME,
								'employee' MEMBER_TYPE,
								'' COMPANY_ID,
								'' CONSUMER_ID,
								EMPLOYEE_ID
							FROM 
								EMPLOYEES 
							WHERE 
								EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
						</cfquery>	
					</cfif>
					<cfif len(acc_type_id)>
						<cfquery name="get_acc_name" datasource="#dsn#">
							SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#acc_type_id#">
						</cfquery>
					</cfif>
					<cfif isdefined("get_acc_name") and get_acc_name.recordcount and len(get_acc_name.acc_type_name)>
						<cfset acc_type_name = get_acc_name.acc_type_name>
					<cfelse>
						<cfset acc_type_name = "">
					</cfif>
					<cfif isdefined("get_name")>
						<cfset member_type = get_name.member_type>
						<cfset company_id = get_name.company_id>
						<cfset consumer_id = get_name.consumer_id>
						<cfif len(acc_type_name)>
							<cfset employee_id = "#get_name.employee_id#_#acc_type_id#">
							<cfset authorized = "#get_name.name#-#acc_type_name#">
						<cfelse>
							<cfset employee_id = "#get_name.employee_id#">
							<cfset authorized = get_name.name>
						</cfif>
					<cfelse>
						<cfset member_type = ''>
						<cfset company_id = ''>
						<cfset consumer_id = ''>
						<cfset employee_id = ''>
						<cfset authorized = ''>
					</cfif>
					<script type="text/javascript">
							window.top.add_row("","#other_money#","#member_code#","#member_type#","#company_id#","#consumer_id#","#employee_id#","#authorized#","#action_account_code#","","#expense_center_id#","#expense_item_id#","#expense_center_name#","#expense_item_name#","#income_center_id#","#income_item_id#","#income_center_name#","#income_item_name#","#project_id#","#project#","","#action_detail#","","","","","","#contract_id#","#contract_head#","","#action_value_other#")
					</script>
					<cfset member_code="">
				<cfelse>
					<script>
						alert('#k#.Satirdaki Uyeye Ait Kod Bilgisi Eksik');
					</script>
				</cfif>
			</cfoutput>
		<cfelseif type eq 2><!--- type 2: Toplu Gelen Havale Ekleme (tutara gore doviz tutar hesaplanir)--->
			<cfset member_type = attributes.member_type>
			<cfscript>
				if(Left(dosya[k],1) != ';'){
					member_code = trim(ListGetAt(dosya[k],1,";"));				//cari hesap
					iban_no = trim(ListGetAt(dosya[k],2,";"));					//iban no
					action_value = trim(ListGetAt(dosya[k],3,";"));				//tutar
					money = trim(ListGetAt(dosya[k],4,";")); 					//para birimi
					action_detail = trim(ListGetAt(dosya[k],5,";")); 			//aciklama
					project_id = trim(ListGetAt(dosya[k],6,";")); 				//proje_id
					subscription_id = trim(ListGetAt(dosya[k],7,";")); 			//Abone Id
					asset_id = trim(ListGetAt(dosya[k],8,";"));					//fiziki varlik id
					if(listlen(dosya[k],';') gte 9)								//tahsilat tipi
						special_definition_id = trim(ListGetAt(dosya[k],9,";"));
					else
						special_definition_id = '';
					expense_amount = trim(ListGetAt(dosya[k],10,";"));			//masraf tutarı
					expense_center_id = trim(ListGetAt(dosya[k],11,";"));		//masraf merkezi id
					if(listlen(dosya[k],';') gte 12)							//gider kalemi id
						expense_item_id = trim(ListGetAt(dosya[k],12,";"));
					else
						expense_item_id = '';
					if(listlen(dosya[k],';') gte 13)							//cari hesap tipi
						acc_type_id = trim(ListGetAt(dosya[k],13,";"));
					else
						acc_type_id = '';
				}
				else if(Left(dosya[k],1) == ';'){
					member_code = '';											//cari hesap
					iban_no = trim(ListGetAt(dosya[k],1,";"));					//iban no
					action_value = trim(ListGetAt(dosya[k],2,";"));				//tutar
					money = trim(ListGetAt(dosya[k],3,";")); 					//para birimi
					action_detail = trim(ListGetAt(dosya[k],4,";")); 			//aciklama
					project_id = trim(ListGetAt(dosya[k],5,";")); 				//proje_id
					subscription_id = trim(ListGetAt(dosya[k],6,";")); 			//Abone Id
					asset_id = trim(ListGetAt(dosya[k],7,";"));					//fiziki varlik id
					if(listlen(dosya[k],';') gte 8)								//tahsilat tipi
						special_definition_id = trim(ListGetAt(dosya[k],8,";"));
					else
						special_definition_id = '';
					expense_amount = trim(ListGetAt(dosya[k],9,";"));			//masraf tutarı
					expense_center_id = trim(ListGetAt(dosya[k],10,";"));		//masraf merkezi id
					if(listlen(dosya[k],';') gte 11)							//gider kalemi id
						expense_item_id = trim(ListGetAt(dosya[k],11,";"));
					else
						expense_item_id = '';
					if(listlen(dosya[k],';') gte 12)							//cari hesap tipi
						acc_type_id = trim(ListGetAt(dosya[k],12,";"));
					else
						acc_type_id = '';
				}
				if(not isdefined("member_code")) member_code = '';
				if(not isdefined("iban_no")) iban_no = '';
			</cfscript>
			<cfoutput>
				<cfif (isdefined("member_code") and len(member_code)) or (isDefined("iban_no") and len(iban_no))>
					<!--- uye --->
					<cfif isdefined("member_code") and len(member_code)>
						<cfif member_type eq 1><!--- kurumsal uye --->
							<cfquery name="get_name" datasource="#dsn#">
								SELECT 
									FULLNAME NAME,
									'partner' MEMBER_TYPE,
									COMPANY.COMPANY_ID,
									'' CONSUMER_ID,
									'' EMPLOYEE_ID
								FROM 
									COMPANY
									LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID
								WHERE 
									(
										COMPANY.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> 
										OR COMPANY.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
										OR CP.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
									)
							</cfquery>
						<cfelseif member_type eq 2> <!--- bireysel uye --->
							<cfquery name="get_name" datasource="#dsn#">
								SELECT 
									CONSUMER_NAME +' '+ CONSUMER_SURNAME NAME,
									'consumer' MEMBER_TYPE,
									'' COMPANY_ID,
									CONSUMER_ID,
									'' EMPLOYEE_ID
								FROM 
									CONSUMER 
								WHERE 
									(MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">)
							</cfquery>
						<cfelseif member_type eq 3> <!--- Çalışan --->
							<cfquery name="get_name" datasource="#dsn#">
								SELECT 
									EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME,
									'employee' MEMBER_TYPE,
									'' COMPANY_ID,
									'' CONSUMER_ID,
									EMPLOYEE_ID
								FROM 
									EMPLOYEES 
								WHERE 
									EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
							</cfquery>	
						</cfif>
					<cfelseif isDefined("iban_no") and len(iban_no)>
						<cfif member_type eq 1><!--- kurumsal uye --->
							<cfquery name="get_name" datasource="#dsn#">
								SELECT 
									C.FULLNAME NAME,
									'partner' MEMBER_TYPE,
									C.COMPANY_ID,
									'' CONSUMER_ID,
									'' EMPLOYEE_ID
								FROM 
									COMPANY C LEFT JOIN COMPANY_BANK CB ON C.COMPANY_ID = CB.COMPANY_ID
								WHERE 
									CB.COMPANY_IBAN_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#iban_no#">
							</cfquery>
						<cfelseif member_type eq 2> <!--- bireysel uye --->
							<cfquery name="get_name" datasource="#dsn#">
								SELECT 
									C.CONSUMER_NAME +' '+ C.CONSUMER_SURNAME NAME,
									'consumer' MEMBER_TYPE,
									'' COMPANY_ID,
									C.CONSUMER_ID,
									'' EMPLOYEE_ID
								FROM 
									CONSUMER C LEFT JOIN CONSUMER_BANK CB ON C.CONSUMER_ID = CB.CONSUMER_ID
								WHERE 
									CB.CONSUMER_IBAN_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#iban_no#">
							</cfquery>
						<cfelseif member_type eq 3> <!--- Çalışan --->
							<cfquery name="get_name" datasource="#dsn#">
								SELECT 
									E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME NAME,
									'employee' MEMBER_TYPE,
									'' COMPANY_ID,
									'' CONSUMER_ID,
									E.EMPLOYEE_ID
								FROM 
									EMPLOYEES E LEFT JOIN EMPLOYEES_BANK_ACCOUNTS EBA ON E.EMPLOYEE_ID = EBA.EMPLOYEE_ID
								WHERE 
									EBA.IBAN_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#iban_no#">
							</cfquery>	
						</cfif>
					</cfif>
					<cfif isDefined("get_name") and get_name.recordCount eq 1>
						<!--- tutarlar --->
						<cfif not len(action_value)><cfset action_value = 0><cfelse><cfset action_value = replace(action_value,',','.','all')></cfif>
						<cfif not len(expense_amount)><cfset expense_amount = 0><cfelse><cfset expense_amount = replace(expense_amount,',','.','all')></cfif>
						<!--- para birimi --->
						<cfif len(money)>
							<cfquery name="get_money" datasource="#dsn2#">
								SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
							</cfquery>
							<cfset other_money = '#get_money.MONEY_TYPE#'>
						<cfelse>
							<cfset other_money = ''>
						</cfif>
						<!--- gider/masraf merkezi --->
						<cfif len(expense_center_id)>
							<cfquery name="get_exp_center" datasource="#dsn2#">
								SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_center_id#">
							</cfquery>
							<cfset expense_center_name = get_exp_center.EXPENSE>
						<cfelse>
							<cfset expense_center_name = ''>
						</cfif>
						<!--- gider kalemi --->
						<cfif len(expense_item_id)>
							<cfquery name="get_exp_item" datasource="#dsn2#">
								SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_item_id#">
							</cfquery>
							<cfset expense_item_name = get_exp_item.EXPENSE_ITEM_NAME>
						<cfelse>
							<cfset expense_item_name = ''>
						</cfif>
						<!--- proje --->
						<cfif len(project_id)>
							<cfquery name="get_project" datasource="#dsn#">
								SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
							</cfquery>
							<cfset project = get_project.project_head>
						<cfelse>
							<cfset project = ''>
						</cfif>
						<!--- abone --->
						<cfif len(subscription_id)>
							<cfquery name="get_subscription" datasource="#dsn3#">
								SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#subscription_id#">
							</cfquery>
							<cfset subscription_no = get_subscription.SUBSCRIPTION_NO & "-" & get_subscription.SUBSCRIPTION_HEAD>
						<cfelse>
							<cfset subscription_no = ''>
						</cfif>
						<!--- fiziki varlik --->
						<cfif len(asset_id)>
							<cfquery name="get_asset" datasource="#dsn#">
								SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#asset_id#">
							</cfquery>
							<cfset asset_name = get_asset.assetp>
						<cfelse>
							<cfset asset_name = ''>
						</cfif>
						<cfif len(acc_type_id)>
							<cfquery name="get_acc_name" datasource="#dsn#">
								SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#acc_type_id#">
							</cfquery>
						</cfif>
						<cfif isdefined("get_acc_name") and get_acc_name.recordcount and len(get_acc_name.acc_type_name)>
							<cfset acc_type_name = get_acc_name.acc_type_name>
						<cfelse>
							<cfset acc_type_name = "">
						</cfif>
						<cfif isdefined("get_name")>
							<cfset member_type = get_name.member_type>
							<cfset company_id = get_name.company_id>
							<cfset consumer_id = get_name.consumer_id>
							<cfif len(acc_type_name)>
								<cfset employee_id = "#get_name.employee_id#_#acc_type_id#">
								<cfset authorized = "#get_name.name#-#acc_type_name#">
							<cfelse>
								<cfset employee_id = "#get_name.employee_id#">
								<cfset authorized = get_name.name>
							</cfif>
						<cfelse>
							<cfset member_type = ''>
							<cfset company_id = ''>
							<cfset consumer_id = ''>
							<cfset employee_id = ''>
							<cfset authorized = ''>
						</cfif>
						<script type="text/javascript">
							window.top.add_row("#action_value#","#other_money#","#member_code#","#member_type#","#company_id#","#consumer_id#","#employee_id#","#authorized#","","","#expense_center_id#","#expense_item_id#","#expense_center_name#","#expense_item_name#","","","","","#project_id#","#project#","#expense_amount#","#action_detail#","","","#asset_id#","#asset_name#","#special_definition_id#","","","","","","","","#subscription_id#","#subscription_no#",1,"#iban_no#");
						</script>
						<cfset member_code="">
					<cfelseif isdefined("get_name") and get_name.recordCount gt 1>
						<script>
							alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='840.Üyeye Ait Kod Bilgisi veya IBAN Bilgisi Birden Fazla Caride Bulunmaktadır.'>");
						</script>
					<cfelseif isdefined("get_name") and len(get_name) and get_name eq 1>
						<script>
							alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='837.Üyeye Ait TC No Bilgisi Eksik'>");
						</script>
					<cfelse>
						<script>
							alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='841.Üyeye Ait Kod Bilgisi veya IBAN Bilgisi Bulunamadığından Eşleştirilme Yapılamadı.'>");
						</script>
					</cfif>
				<cfelse>
					<script>
						alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='842.Üyeye Ait Kod Bilgisi veya IBAN Bilgisi Eksik'>");
					</script>
				</cfif>
			</cfoutput>
		<cfelseif type eq 3><!--- type 3: Toplu Giden Havale Ekleme --->
			<cfset member_type = attributes.member_type>
		
			<cfscript>
				if(Left(dosya[k],1) != ';'){
					member_code = trim(ListGetAt(dosya[k],1,";"));				//cari hesap
					action_value = trim(ListGetAt(dosya[k],2,";"));				//tutar
					money = trim(ListGetAt(dosya[k],3,";")); 					//para birimi
					action_detail = trim(ListGetAt(dosya[k],4,";")); 			//aciklama
					project_id = trim(ListGetAt(dosya[k],5,";")); 				//proje_id
					subscription_id = trim(ListGetAt(dosya[k],6,";")); 			//Abone Id
					asset_id = trim(ListGetAt(dosya[k],7,";"));					//fiziki varlik id
					special_definition_id = trim(ListGetAt(dosya[k],8,";"));	//odeme tipi
					expense_amount = trim(ListGetAt(dosya[k],9,";"));			//masraf tutarı
					expense_center_id = trim(ListGetAt(dosya[k],10,";"));		//masraf merkezi id
					if(listlen(dosya[k],';') gte 11)							//gider kalemi id
						expense_item_id = trim(ListGetAt(dosya[k],11,";"));
					else
						expense_item_id = '';
					if(listlen(dosya[k],';') gte 12)							//cari hesap tipi
						acc_type_id = trim(ListGetAt(dosya[k],12,";"));
					else
						acc_type_id = '';
				}
			</cfscript>
			<cfoutput>
				<cfif isdefined("member_code") and len(member_code)>
					<!--- tutarlar --->
					<cfif not len(action_value)><cfset action_value = 0><cfelse><cfset action_value = replace(action_value,',','.','all')></cfif>
					<cfif not len(expense_amount)><cfset expense_amount = 0><cfelse><cfset expense_amount = replace(expense_amount,',','.','all')></cfif>
					<!--- para birimi --->
					<cfif len(money)>
						<cfquery name="get_money" datasource="#dsn2#">
							SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
						</cfquery>
						<cfset other_money = '#get_money.MONEY_TYPE#'>
					<cfelse>
						<cfset other_money = ''>
					</cfif>
					<!--- gider/masraf merkezi --->
					<cfif len(expense_center_id)>
						<cfquery name="get_exp_center" datasource="#dsn2#">
							SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_center_id#">
						</cfquery>
						<cfset expense_center_name = get_exp_center.EXPENSE>
					<cfelse>
						<cfset expense_center_name = ''>
					</cfif>
					<!--- gider kalemi --->
					<cfif len(expense_item_id)>
						<cfquery name="get_exp_item" datasource="#dsn2#">
							SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_item_id#">
						</cfquery>
						<cfset expense_item_name = get_exp_item.EXPENSE_ITEM_NAME>
					<cfelse>
						<cfset expense_item_name = ''>
					</cfif>
					<!--- proje --->
					<cfif len(project_id)>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
						</cfquery>
						<cfset project = get_project.project_head>
					<cfelse>
						<cfset project = ''>
					</cfif>		
					<!--- abone --->
					<cfif len(subscription_id)>
						<cfquery name="get_subscription" datasource="#dsn3#">
							SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#subscription_id#">
						</cfquery>
						<cfset subscription_no = get_subscription.SUBSCRIPTION_NO & "-" & get_subscription.SUBSCRIPTION_HEAD>
					<cfelse>
						<cfset subscription_no = ''>
					</cfif>
					<!--- fiziki varlik --->
					<cfif len(asset_id)>
						<cfquery name="get_asset" datasource="#dsn#">
							SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#asset_id#">
						</cfquery>
						<cfset asset_name = get_asset.assetp>
					<cfelse>
						<cfset asset_name = ''>
					</cfif>		
					<!--- uye --->
					<cfif member_type eq 1><!--- kurumsal uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								FULLNAME NAME,
								'partner' MEMBER_TYPE,
								COMPANY.COMPANY_ID,
								'' CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								COMPANY
								LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID
							WHERE 
								(
									COMPANY.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> 
									OR COMPANY.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
									OR CP.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
								)
						</cfquery>
					<cfelseif member_type eq 2> <!--- bireysel uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								CONSUMER_NAME +' '+ CONSUMER_SURNAME NAME,
								'consumer' MEMBER_TYPE,
								'' COMPANY_ID,
								CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								CONSUMER 
							WHERE 
								(MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">)
						</cfquery>
					<cfelseif member_type eq 3> <!--- Çalışan --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME,
								'employee' MEMBER_TYPE,
								'' COMPANY_ID,
								'' CONSUMER_ID,
								EMPLOYEE_ID
							FROM 
								EMPLOYEES 
							WHERE 
								EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
						</cfquery>	
					</cfif>
					<cfif len(acc_type_id)>
						<cfquery name="get_acc_name" datasource="#dsn#">
							SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#acc_type_id#">
						</cfquery>
					</cfif>
					<cfif isdefined("get_acc_name") and get_acc_name.recordcount and len(get_acc_name.acc_type_name)>
						<cfset acc_type_name = get_acc_name.acc_type_name>
					<cfelse>
						<cfset acc_type_name = "">
					</cfif>
					<cfif isdefined("get_name")>
						<cfset member_type = get_name.member_type>
						<cfset company_id = get_name.company_id>
						<cfset consumer_id = get_name.consumer_id>
						<cfif len(acc_type_name)>
							<cfset employee_id = "#get_name.employee_id#_#acc_type_id#">
							<cfset authorized = "#get_name.name#-#acc_type_name#">
						<cfelse>
							<cfset employee_id = "#get_name.employee_id#">
							<cfset authorized = get_name.name>
						</cfif>
					<cfelse>
						<cfset member_type = ''>
						<cfset company_id = ''>
						<cfset consumer_id = ''>
						<cfset employee_id = ''>
						<cfset authorized = ''>
					</cfif>
					<cfif get_name.recordcount eq 1>
						<script type="text/javascript">
							window.top.add_row("#action_value#","#other_money#","#member_code#","#member_type#","#company_id#","#consumer_id#","#employee_id#","#authorized#","","","#expense_center_id#","#expense_item_id#","#expense_center_name#","#expense_item_name#","","","","","#project_id#","#project#","#expense_amount#","#action_detail#","","","#asset_id#","#asset_name#","#special_definition_id#","","","","","","","","#subscription_id#","#subscription_no#",1);
						</script>
					<cfelseif isdefined("get_name") and len(get_name) and get_name eq 1>
						<script>
							alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='837.Üyeye Ait TC No Bilgisi Eksik'>");
						</script>
					<cfelse>
						<script type="text/javascript">
							alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='838.Üye kodu geçersizdir. Bu satır aktarılmayacaktır.'>");
						</script>
					</cfif>
					<cfset member_code="">
				<cfelse>
					<script>
						alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='839.Üyeye Ait Kod Bilgisi Eksik'>");
					</script>
				</cfif>
			</cfoutput>
		<cfelseif type eq 4><!--- type 4: Kasa Toplu Tahsilat Ekleme --->
			<cfset member_type = attributes.member_type>
			<cfscript>
				if(Left(dosya[k],1) != ';'){
					member_code = trim(ListGetAt(dosya[k],1,";"));				//cari hesap
					action_value = trim(ListGetAt(dosya[k],2,";"));				//tutar
					money = trim(ListGetAt(dosya[k],3,";")); 					//para birimi
					action_detail = trim(ListGetAt(dosya[k],4,";")); 			//aciklama
					revenue_collector_id = trim(ListGetAt(dosya[k],5,";")); 	//tahsil eden id
					project_id = trim(ListGetAt(dosya[k],6,";")); 				//proje_id
					asset_id = trim(ListGetAt(dosya[k],7,";"));					//fiziki varlik id
					special_definition_id = trim(ListGetAt(dosya[k],8,";"));	//tahsilat tipi id
					if(listlen(dosya[k],';') gte 9)								//cari hesap tipi
						acc_type_id = trim(ListGetAt(dosya[k],9,";"));
					else
						acc_type_id = '';
				}
			</cfscript>
			<cfoutput>
				<cfif isdefined("member_code") and len(member_code)>
					<!--- tutarlar --->
					<cfif not len(action_value)><cfset action_value = 0><cfelse><cfset action_value = replace(action_value,',','.','all')></cfif>
					<!--- para birimi --->
					<cfif len(money)>
						<cfquery name="get_money" datasource="#dsn2#">
							SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
						</cfquery>
						<cfset other_money = '#get_money.MONEY_TYPE#'>
					<cfelse>
						<cfset other_money = ''>
					</cfif>
					<!--- proje --->
					<cfif len(project_id)>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
						</cfquery>
						<cfset project = get_project.project_head>
					<cfelse>
						<cfset project = ''>
					</cfif>		
					<!--- fiziki varlik --->
					<cfif len(asset_id)>
						<cfquery name="get_asset" datasource="#dsn#">
							SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#asset_id#">
						</cfquery>
						<cfset asset_name = get_asset.assetp>
					<cfelse>
						<cfset asset_name = ''>
					</cfif>			
					<!--- uye --->
					<cfif member_type eq 1><!--- kurumsal uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								FULLNAME NAME,
								'partner' MEMBER_TYPE,
								COMPANY_ID,
								'' CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								COMPANY 
							WHERE 
								(MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">)
						</cfquery>
					<cfelseif member_type eq 2> <!--- bireysel uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								CONSUMER_NAME +' '+ CONSUMER_SURNAME NAME,
								'consumer' MEMBER_TYPE,
								'' COMPANY_ID,
								CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								CONSUMER 
							WHERE 
								(MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">)
						</cfquery>
					<cfelseif member_type eq 3> <!--- Çalışan --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME,
								'employee' MEMBER_TYPE,
								'' COMPANY_ID,
								'' CONSUMER_ID,
								EMPLOYEE_ID
							FROM 
								EMPLOYEES 
							WHERE 
								EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
						</cfquery>	
					</cfif>
					<cfif len(acc_type_id)>
						<cfquery name="get_acc_name" datasource="#dsn#">
							SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#acc_type_id#">
						</cfquery>
					</cfif>
					<cfif isdefined("get_acc_name") and get_acc_name.recordcount and len(get_acc_name.acc_type_name)>
						<cfset acc_type_name = get_acc_name.acc_type_name>
					<cfelse>
						<cfset acc_type_name = "">
					</cfif>
					<cfif isdefined("get_name")>
						<cfset member_type = get_name.member_type>
						<cfset company_id = get_name.company_id>
						<cfset consumer_id = get_name.consumer_id>
						<cfif len(acc_type_name)>
							<cfset employee_id = "#get_name.employee_id#_#acc_type_id#">
							<cfset authorized = "#get_name.name#-#acc_type_name#">
						<cfelse>
							<cfset employee_id = "#get_name.employee_id#">
							<cfset authorized = get_name.name>
						</cfif>
					<cfelse>
						<cfset member_type = ''>
						<cfset company_id = ''>
						<cfset consumer_id = ''>
						<cfset employee_id = ''>
						<cfset authorized = ''>
					</cfif>
					<!--- tahsil eden --->
					<cfif len(revenue_collector_id)>
						<cfquery name="get_revenue_collector" datasource="#dsn#">
							SELECT 
								EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME
							FROM 
								EMPLOYEES 
							WHERE 
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#revenue_collector_id#">
						</cfquery>
						<cfset revenue_collector_name = get_revenue_collector.NAME>
					<cfelse>
						<cfset revenue_collector_name = ''>
					</cfif>	
					<script type="text/javascript">
						window.top.add_row("#action_value#","#other_money#","#member_code#","#member_type#","#company_id#","#consumer_id#","#employee_id#","#authorized#","","","","","","","","","","","#project_id#","#project#","","#action_detail#","#revenue_collector_id#","#revenue_collector_name#","#asset_id#","#asset_name#","#special_definition_id#","","","","","","","")
						x = parseInt(window.top.document.getElementById('record_num').value); 
						window.top.kur_ekle_f_hesapla('cash_action_to_cash_id',false,x);
						<cfif counter eq k>
							window.top.closeBoxDraggable('multi_add_modal');
						</cfif>
					</script>
					<cfset member_code="">
				<cfelse>
					<script>
						alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='839.Üyeye Ait Kod Bilgisi Eksik'>");
					</script>
				</cfif>
			</cfoutput>
		<cfelseif type eq 5><!--- type 4: Kasa Toplu Ödeme Ekleme --->
			<cfset member_type = attributes.member_type>
			<cfscript>
				if(Left(dosya[k],1) != ';'){
					member_code = trim(ListGetAt(dosya[k],1,";"));				//cari hesap
					action_value = trim(ListGetAt(dosya[k],2,";"));				//tutar
					money = trim(ListGetAt(dosya[k],3,";")); 					//para birimi
					action_detail = trim(ListGetAt(dosya[k],4,";")); 			//aciklama
					revenue_collector_id = trim(ListGetAt(dosya[k],5,";")); 	//tahsil eden id
					project_id = trim(ListGetAt(dosya[k],6,";")); 				//proje_id
					asset_id = trim(ListGetAt(dosya[k],7,";"));					//fiziki varlik id
					special_definition_id = trim(ListGetAt(dosya[k],8,";"));	//tahsilat tipi id
					if(listlen(dosya[k],';') gte 9)								//cari hesap tipi
						acc_type_id = trim(ListGetAt(dosya[k],9,";"));
					else
						acc_type_id = '';
				}
			</cfscript>
			<cfoutput>
				<cfif isdefined("member_code") and len(member_code)>
					<!--- tutarlar --->
					<cfif not len(action_value)><cfset action_value = 0><cfelse><cfset action_value = replace(action_value,',','.','all')></cfif>
					<!--- para birimi --->
					<cfif len(money)>
						<cfquery name="get_money" datasource="#dsn2#">
							SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#">
						</cfquery>
						<cfset other_money = '#get_money.MONEY_TYPE#'>
					<cfelse>
						<cfset other_money = ''>
					</cfif>
					<!--- proje --->
					<cfif len(project_id)>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
						</cfquery>
						<cfset project = get_project.project_head>
					<cfelse>
						<cfset project = ''>
					</cfif>		
					<!--- fiziki varlik --->
					<cfif len(asset_id)>
						<cfquery name="get_asset" datasource="#dsn#">
							SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#asset_id#">
						</cfquery>
						<cfset asset_name = get_asset.assetp>
					<cfelse>
						<cfset asset_name = ''>
					</cfif>			
					<!--- uye --->
					<cfif member_type eq 1><!--- kurumsal uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								FULLNAME NAME,
								'partner' MEMBER_TYPE,
								COMPANY_ID,
								'' CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								COMPANY 
							WHERE 
								(MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">)
						</cfquery>
					<cfelseif member_type eq 2> <!--- bireysel uye --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								CONSUMER_NAME +' '+ CONSUMER_SURNAME NAME,
								'consumer' MEMBER_TYPE,
								'' COMPANY_ID,
								CONSUMER_ID,
								'' EMPLOYEE_ID
							FROM 
								CONSUMER 
							WHERE 
								(MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> OR TAX_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">)
						</cfquery>
					<cfelseif member_type eq 3> <!--- Çalışan --->
						<cfquery name="get_name" datasource="#dsn#">
							SELECT 
								EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME,
								'employee' MEMBER_TYPE,
								'' COMPANY_ID,
								'' CONSUMER_ID,
								EMPLOYEE_ID
							FROM 
								EMPLOYEES 
							WHERE 
								EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#">
						</cfquery>	
					</cfif>
					<cfif len(acc_type_id)>
						<cfquery name="get_acc_name" datasource="#dsn#">
							SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#acc_type_id#">
						</cfquery>
					</cfif>
					<cfif isdefined("get_acc_name") and get_acc_name.recordcount and len(get_acc_name.acc_type_name)>
						<cfset acc_type_name = get_acc_name.acc_type_name>
					<cfelse>
						<cfset acc_type_name = "">
					</cfif>
					<cfif isdefined("get_name")>
						<cfset member_type = get_name.member_type>
						<cfset company_id = get_name.company_id>
						<cfset consumer_id = get_name.consumer_id>
						<cfif len(acc_type_name)>
							<cfset employee_id = "#get_name.employee_id#_#acc_type_id#">
							<cfset authorized = "#get_name.name#-#acc_type_name#">
						<cfelse>
							<cfset employee_id = "#get_name.employee_id#">
							<cfset authorized = get_name.name>
						</cfif>
					<cfelse>
						<cfset member_type = ''>
						<cfset company_id = ''>
						<cfset consumer_id = ''>
						<cfset employee_id = ''>
						<cfset authorized = ''>
					</cfif>
					<!--- tahsil eden --->
					<cfif len(revenue_collector_id)>
						<cfquery name="get_revenue_collector" datasource="#dsn#">
							SELECT 
								EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME NAME
							FROM 
								EMPLOYEES 
							WHERE 
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#revenue_collector_id#">
						</cfquery>
						<cfset revenue_collector_name = get_revenue_collector.NAME>
					<cfelse>
						<cfset revenue_collector_name = ''>
					</cfif>	
					<script type="text/javascript">
						window.top.add_row("#action_value#","#other_money#","#member_code#","#member_type#","#company_id#","#consumer_id#","#employee_id#","#authorized#","","","","","","","","","","","#project_id#","#project#","","#action_detail#","#revenue_collector_id#","#revenue_collector_name#","#asset_id#","#asset_name#","#special_definition_id#","","","","","","","")
						x = parseInt(window.top.document.getElementById('record_num').value); 
						window.top.kur_ekle_f_hesapla('cash_action_from_cash_id',false,x);
					</script>
					<cfset member_code="">
				<cfelse>
					<script>
						alert("<cf_get_lang dictionary_id='58508.Satır'>: #k# <cf_get_lang dictionary_id='839.Üyeye Ait Kod Bilgisi Eksik'>");
					</script>
				</cfif>
			</cfoutput>
		</cfif>
	</cfloop>

<script type="text/javascript">
	if(window.top.document.getElementById('toplu_giden_file') != null){
		window.top.document.getElementById('toplu_giden_file').style.display = 'none' ;
	}
	<cfif type eq 2>
		window.top.showBasketItems();
		/* basketLen = parseInt(window.top.document.getElementById('record_num').value); 
		for(i=0;i<basketLen;i++){
			window.top.kur_ekle_f_hesapla('account_id',false,i);
		} */
	</cfif>
	<cfif type eq 3>
		window.top.showBasketItems(); 
		/* x = parseInt(window.top.document.getElementById('record_num').value); 
		window.top.kur_ekle_f_hesapla('account_id',false,x); */
	</cfif>
	window.top.document.getElementById("working_div_main").style.display = 'none' ;
</script>
