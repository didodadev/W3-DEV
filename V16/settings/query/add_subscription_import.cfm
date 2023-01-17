<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
        filefield = "uploaded_file" 
        destination = "#upload_folder#"
        nameconflict = "MakeUnique"  
        mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cfquery name="getCompMembers" datasource="#dsn3#">
    SELECT
        CP.PARTNER_ID,
        C.COMPANY_ID,
        C.COMPANY_POSTCODE AS POSTCODE,
        C.COMPANY_ADDRESS AS ADDRESS,
        C.SEMT AS SEMT,
        C.COUNTY AS COUNTY,
        C.COUNTRY AS COUNTRY,
        C.CITY AS CITY,
        C.COORDINATE_1 AS COORDINATE_1,
        C.COORDINATE_2 AS COORDINATE_2
    FROM 
        #dsn_alias#.COMPANY C,
        #dsn_alias#.COMPANY_PARTNER CP
    WHERE 
        C.COMPANY_ID = CP.COMPANY_ID
</cfquery>

<cfquery name="getConsMembers" datasource="#dsn3#">
    SELECT 
    	CONSUMER_ID,
        WORKPOSTCODE AS POSTCODE,
        WORKADDRESS AS ADDRESS,
        WORKSEMT AS SEMT,
        WORK_COUNTY_ID AS COUNTY,
        WORK_COUNTRY_ID AS COUNTRY,
        WORK_CITY_ID AS CITY,
        COORDINATE_1 AS COORDINATE_1,
        COORDINATE_2 AS COORDINATE_2
    FROM 
        #dsn_alias#.CONSUMER 
</cfquery>
 
<cfquery name="getProducts" datasource="#dsn3#">
    SELECT 
        STOCK_ID,
        PRODUCT_ID,
        PRODUCT_CODE_2,
        STOCK_CODE 
    FROM 
        STOCKS 
</cfquery>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
	<cffile action="delete" file="#upload_folder##file_name#">
    <cfcatch>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>");
            history.back();
        </script>
        <cfabort>
    </cfcatch>
</cftry>

<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
	satir_say =0;
</cfscript>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
				<cfscript>
					satir_say=satir_say+1;
					
					status = Listgetat(dosya[i],j,";");//Aktif/pasif *
					status = trim(status);
					j=j+1;
					
					subs_no = Listgetat(dosya[i],j,";");//abone no *
					subs_no = trim(subs_no);
					j=j+1;
					
					subs_consumer = Listgetat(dosya[i],j,";");//müsteri bireysel ise *
					subs_consumer = trim(subs_consumer);
					j=j+1;
					
					subs_company = Listgetat(dosya[i],j,";");//müsteri kurumsal ise *
					subs_company = trim(subs_company);
					j=j+1;
					
					subs_head = Listgetat(dosya[i],j,";");//tanim *
					subs_head = trim(subs_head);
					j=j+1;
					
					subs_stage_id = Listgetat(dosya[i],j,";");//asama id *
					subs_stage_id = trim(subs_stage_id);
					j=j+1;
					
					subs_cat_id = Listgetat(dosya[i],j,";");//kategori id *
					subs_cat_id = trim(subs_cat_id);
					j=j+1;
					
					contract_date = Listgetat(dosya[i],j,";");//sozlesme tarihi *
					contract_date = trim(contract_date);
					j=j+1;
					
					montage_date = Listgetat(dosya[i],j,";");//montaj tarihi 
					montage_date = trim(montage_date);
					j=j+1;
					
					special_code = Listgetat(dosya[i],j,";");//ozel kod
					special_code = trim(special_code);
					j=j+1;

					invoice_consumer = Listgetat(dosya[i],j,";");//fatura sirketi bireysel
					invoice_consumer = trim(invoice_consumer);
					j=j+1;
					
					invoice_company = Listgetat(dosya[i],j,";");//fatura sirketi kurumsal
					invoice_company = trim(invoice_company);
					j=j+1;
					
					sales_employee = Listgetat(dosya[i],j,";");//satis temsilcisi
					sales_employee = trim(sales_employee);
					j=j+1;
					
					sales_consumer = Listgetat(dosya[i],j,";");//satis ortagi bireysel
					sales_consumer = trim(sales_consumer);
					j=j+1;
					
					sales_company = Listgetat(dosya[i],j,";");//satis ortagi kurumsal
					sales_company = trim(sales_company);
					j=j+1;
					
					sales_member_comm_value = Listgetat(dosya[i],j,";");//satis ortagi komisyon
					sales_member_comm_value = trim(sales_member_comm_value);
					j=j+1;
					
					sales_member_comm_money = Listgetat(dosya[i],j,";");//satis ortagi komisyon p.b
					sales_member_comm_money = trim(sales_member_comm_money);
					j=j+1;
					
					ref_employee = Listgetat(dosya[i],j,";");//ref musteri calisan
					ref_employee = trim(ref_employee);
					j=j+1;
					
					ref_consumer = Listgetat(dosya[i],j,";");//ref musteri bireysel
					ref_consumer = trim(ref_consumer);
					j=j+1;
					
					ref_company = Listgetat(dosya[i],j,";");//ref musteri kurumsal
					ref_company = trim(ref_company);
					j=j+1;
					
					subs_product = Listgetat(dosya[i],j,";");//urun (id stock veya ozel kod)
					subs_product = trim(subs_product);
					j=j+1;
					
					contract_no = Listgetat(dosya[i],j,";");//sozlesme no
					contract_no = trim(contract_no);
					j=j+1;
					
					subs_add_option = Listgetat(dosya[i],j,";");//abone ozel tanim
					subs_add_option = trim(subs_add_option);
					j=j+1;
					
					sales_add_option = Listgetat(dosya[i],j,";");//ozel tanim
					sales_add_option = trim(sales_add_option);
					j=j+1;
					
					subs_payment_type = Listgetat(dosya[i],j,";");//odeme yontemi
					subs_payment_type = trim(subs_payment_type);
					j=j+1;
					
					subs_project = Listgetat(dosya[i],j,";");//proje
					subs_project = trim(subs_project);
					j=j+1;
					
					if(listlen(dosya[i],';') gte j)
					{
						subs_assetp = Listgetat(dosya[i],j,";");//ülke
						subs_assetp = trim(subs_assetp);
					}				
					else
						subs_assetp = '';
					j=j+1;	
					
					if(listlen(dosya[i],';') gte j)
					{
						branch_id = Listgetat(dosya[i],j,";");//Şube ilişkisi *
						branch_id = trim(branch_id);
					}
					else
						branch_id ='';  
				</cfscript>
				<cfcatch type="Any">
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
            <cfoutput>
            <cfquery name="getsubno" datasource="#dsn3#">
						SELECT 
							SUBSCRIPTION_NO
						FROM 
							SUBSCRIPTION_CONTRACT
                        WHERE 
                        	SUBSCRIPTION_NO = '#subs_no#'			
			</cfquery>
            </cfoutput>  
            <cfif getsubno.recordcount>
                	<cfoutput>
						<script type="text/javascript">
							alert("<cf_get_lang dictionary_id='63460.Aynı abone numarasına ait kayıtlar var'>!");							
							history.back();					
						</script>
					</cfoutput>
                    <cfabort>
            </cfif>         
			<cfif error_flag neq 1>
            	<cftry>	                
				<cfif not len(status) or not len(subs_no) or (not len(subs_consumer) and not len(subs_company)) or not len(subs_head) or not len(subs_stage_id) or not len(subs_cat_id) or not len(contract_date)>
					<cfoutput>
						<script type="text/javascript">
							alert("#satir_say#. <cf_get_lang dictionary_id='59216.satırdaki zorunlu alanlarda eksik değerler var. Lütfen dosyanızı kontrol ediniz'> !");
							history.back();					
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
				<cfif len(sales_member_comm_value)>
					<cfset sales_member_comm_value = filterNum(sales_member_comm_value)>
				</cfif>
				<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
				<cfif len(contract_date)>
					<cf_date tarih="contract_date">
				</cfif>
				<cfif len(montage_date)>
					<cf_date tarih="montage_date">
				</cfif>
				
				<cfif len(subs_company)>
					<cfquery name="getMember" dbtype="query">
						SELECT 
							*
						FROM 
							getCompMembers
						WHERE 
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#subs_company#">
					</cfquery>
				<cfelse>
					<cfquery name="getMember" dbtype="query">
						SELECT 
							*
						FROM 
							getConsMembers
						WHERE 
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#subs_consumer#">
					</cfquery>
				</cfif>
				
				<cfif len(invoice_company)>
					<cfquery name="getInvCompPartner" dbtype="query" maxrows="1">
						SELECT
							*
						FROM 
							getCompMembers
						WHERE 
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_company#">
					</cfquery>
				</cfif>
				
				<cfif len(sales_company)>
					<cfquery name="getSalesCompPartner" dbtype="query" maxrows="1">
						SELECT
							*
						FROM 
							getCompMembers
						WHERE 
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sales_company#">
					</cfquery>
				</cfif>
				
				<cfif len(ref_company)>
					<cfquery name="getRefCompPartner" dbtype="query" maxrows="1">
						SELECT
							*
						FROM 
							getCompMembers
						WHERE 
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_company#">
					</cfquery>
				</cfif>
				
				<cfif len(subs_product)>
					<cfquery name="getProduct_" dbtype="query">
						SELECT 
                        	*
                        FROM 
                        	getProducts 
                        WHERE 
                        	PRODUCT_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#subs_product#"> OR 
                            STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#subs_product#">
					</cfquery>
				</cfif>
				<cfset satir_no = satir_no + 1>
				<cfquery name="add_subs" datasource="#dsn3#">
					INSERT INTO
						SUBSCRIPTION_CONTRACT
						(
							WRK_ID,
                            BRANCH_ID,
							IS_ACTIVE,
							SUBSCRIPTION_NO,
							SUBSCRIPTION_HEAD,
							PARTNER_ID,
							COMPANY_ID,					
							CONSUMER_ID,
							SUBSCRIPTION_TYPE_ID,				
							SUBSCRIPTION_STAGE,
							INVOICE_COMPANY_ID,
							INVOICE_PARTNER_ID,
							INVOICE_CONSUMER_ID,
							SALES_COMPANY_ID,
							SALES_PARTNER_ID,
							SALES_CONSUMER_ID,
							SALES_EMP_ID,							
							REF_COMPANY_ID,	
							REF_PARTNER_ID,				
							REF_CONSUMER_ID,
							REF_EMPLOYEE_ID,
							SALES_MEMBER_COMM_VALUE,
							SALES_MEMBER_COMM_MONEY,
							PRODUCT_ID,
							STOCK_ID,
							CONTRACT_NO,
							PAYMENT_TYPE_ID,
							MONTAGE_DATE,
							START_DATE,<!---sozlesme tarihi --->
							SPECIAL_CODE,
							SHIP_ADDRESS,
							SHIP_POSTCODE,
							SHIP_SEMT,
							SHIP_COUNTY_ID,
							SHIP_CITY_ID,
							SHIP_COUNTRY_ID,
							SHIP_COORDINATE_1,
							SHIP_COORDINATE_2,
							INVOICE_ADDRESS,
							INVOICE_POSTCODE,
							INVOICE_SEMT,
							INVOICE_COUNTY_ID,
							INVOICE_CITY_ID,
							INVOICE_COUNTRY_ID,								
							INVOICE_COORDINATE_1,
							INVOICE_COORDINATE_2,
							CONTACT_ADDRESS,
							CONTACT_POSTCODE,
							CONTACT_SEMT,
							CONTACT_COUNTY_ID,
							CONTACT_CITY_ID,
							CONTACT_COUNTRY_ID,
							CONTACT_COORDINATE_1,
							CONTACT_COORDINATE_2,
							SUBSCRIPTION_ADD_OPTION_ID,
							SALES_ADD_OPTION_ID,
							PROJECT_ID,
							ASSETP_ID,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE							
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
                            <cfif len(branch_id)>#branch_id#<cfelse>NULL</cfif>,
							#status#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#subs_no#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#subs_head#">,
							<cfif len(subs_company)>
								#getMember.partner_id#,
								#subs_company#,
								NULL,
							<cfelse>
								NULL,
								NULL,
								#subs_consumer#,
							</cfif>
							#subs_cat_id#,
							#subs_stage_id#,
							<cfif len(invoice_company)>
								#invoice_company#,
								#getInvCompPartner.partner_id#,
                            <cfelseif len(subs_company)>
								#subs_company#,
                            	#getMember.partner_id#,
							<cfelse>
								NULL,
								NULL,
							</cfif>
							<cfif len(invoice_consumer)>
                            	#invoice_consumer#
                            <cfelseif len(subs_consumer)>
                            	#subs_consumer#
                            <cfelse>
                            	NULL
                            </cfif>,
							<cfif len(sales_company)>
								#sales_company#,
								#getSalesCompPartner.partner_id#,
							<cfelse>
								NULL,
								NULL,
							</cfif>
							<cfif len(sales_consumer)>#sales_consumer#<cfelse>NULL</cfif>,
							<cfif len(sales_employee)>#sales_employee#<cfelse>NULL</cfif>,
							<cfif len(ref_company)>
								#ref_company#,
								#getRefCompPartner.partner_id#,
							<cfelse>
								NULL,
								NULL,
							</cfif>
							<cfif len(ref_consumer)>#ref_consumer#<cfelse>NULL</cfif>,
							<cfif len(ref_employee)>#ref_employee#<cfelse>NULL</cfif>,
							<cfif len(sales_member_comm_value)>#sales_member_comm_value#<cfelse>NULL</cfif>,
							<cfif len(sales_member_comm_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#sales_member_comm_money#"><cfelse>NULL</cfif>,
							<cfif len(subs_product) and len(getProduct_.product_id)>#getProduct_.product_id#<cfelse>NULL</cfif>,
							<cfif len(subs_product) and len(getProduct_.stock_id)>#getProduct_.stock_id#<cfelse>NULL</cfif>,
							<cfif len(contract_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#contract_no#"><cfelse>NULL</cfif>,
							<cfif len(subs_payment_type)>#subs_payment_type#<cfelse>NULL</cfif>,
							<cfif len(montage_date)>#montage_date#<cfelse>NULL</cfif>,
							<cfif len(contract_date)>#contract_date#<cfelse>NULL</cfif>,
							<cfif len(special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code#"><cfelse>NULL</cfif>,
							<cfif len(getMember.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.address#"><cfelse>NULL</cfif>,
							<cfif len(getMember.postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.postcode#"><cfelse>NULL</cfif>,
							<cfif len(getMember.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.semt#"><cfelse>NULL</cfif>,
							<cfif len(getMember.county)>#getMember.county#<cfelse>NULL</cfif>,
							<cfif len(getMember.city)>#getMember.city#<cfelse>NULL</cfif>,
							<cfif len(getMember.country)>#getMember.country#<cfelse>NULL</cfif>,
							<cfif len(getMember.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.coordinate_1#"><cfelse>NULL</cfif>,
							<cfif len(getMember.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.coordinate_2#"><cfelse>NULL</cfif>,
							<cfif len(getMember.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.address#"><cfelse>NULL</cfif>,
							<cfif len(getMember.postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.postcode#"><cfelse>NULL</cfif>,
							<cfif len(getMember.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.semt#"><cfelse>NULL</cfif>,
							<cfif len(getMember.county)>#getMember.county#<cfelse>NULL</cfif>,
							<cfif len(getMember.city)>#getMember.city#<cfelse>NULL</cfif>,
							<cfif len(getMember.country)>#getMember.country#<cfelse>NULL</cfif>,
							<cfif len(getMember.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.coordinate_1#"><cfelse>NULL</cfif>,
							<cfif len(getMember.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.coordinate_2#"><cfelse>NULL</cfif>,
							<cfif len(getMember.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.address#"><cfelse>NULL</cfif>,
							<cfif len(getMember.postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.postcode#"><cfelse>NULL</cfif>,
							<cfif len(getMember.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.semt#"><cfelse>NULL</cfif>,
							<cfif len(getMember.county)>#getMember.county#<cfelse>NULL</cfif>,
							<cfif len(getMember.city)>#getMember.city#<cfelse>NULL</cfif>,
							<cfif len(getMember.country)>#getMember.country#<cfelse>NULL</cfif>,
							<cfif len(getMember.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.coordinate_1#"><cfelse>NULL</cfif>,
							<cfif len(getMember.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.coordinate_2#"><cfelse>NULL</cfif>,
							<cfif len(subs_add_option)>#subs_add_option#<cfelse>NULL</cfif>,
							<cfif len(sales_add_option)>#sales_add_option#<cfelse>NULL</cfif>,
							<cfif len(subs_project)>#subs_project#<cfelse>NULL</cfif>,
							<cfif len(subs_assetp)>#subs_assetp#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
							#now()#
						)
					</cfquery>
                    <!--- Belge numarasi update ediliyor. --->
                    <cf_papers paper_type="subscription">
					<!--- Belge numarasi update ediliyor. --->
                    <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                        UPDATE 
                            GENERAL_PAPERS
                        SET
                            SUBSCRIPTION_NUMBER = #paper_number#
                        WHERE
                            SUBSCRIPTION_NUMBER IS NOT NULL
                    </cfquery>
					<cfcatch type="Any">
						<cfoutput>#satir_say#</cfoutput>. <cf_get_lang dictionary_id='63401.satır 2. adımda sorun oluştu'>.<br/>
						history.back();
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfoutput><cf_get_lang dictionary_id='44647.İmport edilen satır sayısı'>: #satir_no# !!!</cfoutput><br/>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_subscription_import';
</script>
