<cfscript>
	emp_id_list = attributes.emp_id_list;
	emp_id_out_list = attributes.emp_id_out_list;
	sal_mon = attributes.sal_mon;
	sal_year = attributes.sal_year;
	veri_type = attributes.veri_type;
	special_code_ = 'FM#attributes.branch_id#-#attributes.department#-#sal_year#-#sal_mon#';
	bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon,1);
	bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi));
</cfscript>

<cfif isdefined("attributes.is_del") and attributes.is_del eq 1>
    <cfquery name="show_record" datasource="#dsn#">
        SELECT
            RECORD_EMP
		FROM
			EMPLOYEES_EXT_WORKTIMES
		WHERE
			IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_id_out_list#">) AND 
			MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon#"> AND 
			YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year#"> AND
			SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
	</cfquery>
	<cfset record_emp_ = show_record.RECORD_EMP>
	<cfquery name="send_mail" datasource="#dsn#">
		SELECT
			EMPLOYEE_EMAIL,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp_#">
	</cfquery>
	<cfset mail_to = send_mail.employee_email>
	<cfif len(mail_to)>
		<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#mail_to#" subject="Fazla Mesai" type="html">
			<html>
				<body>
					Sayın #send_mail.EMPLOYEE_NAME# #send_mail.EMPLOYEE_SURNAME#,<br />
					Fazla mesai kayıtlarınız onaylanmamıştır. Mesai verilerinizi tekrar kaydetmeniz gerekmektedir.<br />
					<a class="tableyazi" target="_blank" href="#employee_domain##request.self#?fuseaction=myhome.list_extra_worktimes&is_form_submitted=1&branch_id=#attributes.branch_id#&department=#attributes.department#&sal_mon=#attributes.sal_mon#&comp_id=#attributes.comp_id#">İlgili sayfa</a>
				</body>
			</html>
		</cfmail>
	</cfif>
	<cfquery name="del_old_rec" datasource="#dsn#">
        DELETE FROM 
            EMPLOYEES_EXT_WORKTIMES 
        WHERE 
            IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_id_out_list#">) AND 
            MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon#"> AND 
            YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year#"> AND
            SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
    </cfquery>
<cfelseif attributes.is_add eq 1>
    <cfquery name="del_old_rec" datasource="#dsn#">
        DELETE FROM 
            EMPLOYEES_EXT_WORKTIMES 
        WHERE 
            IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_id_out_list#">) AND 
            MONTH(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon#"> AND 
            YEAR(START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year#"> AND
            SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
    </cfquery>    
    <cfloop index="aa" from="1" to="#listLen(emp_id_out_list)#">
        <cfset in_out_id = listgetat(emp_id_out_list,aa)>
        <cfquery name="get_emp_id" datasource="#dsn#">
            SELECT EMPLOYEE_ID,START_DATE FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
        </cfquery>
        <cfloop index="bb" from="1" to="#attributes.aydaki_gun_sayisi#">
            <cfif len(evaluate('mesai_saat_#in_out_id#_#bb#')) and evaluate('mesai_saat_#in_out_id#_#bb#') gt 0>
            	<cfset day_type_ = evaluate('mesai_day_type_#in_out_id#_#bb#')><!--- 2 ise genel tatil,1 hs tatili,0 normal gün --->
                <cfif day_type_ eq 2 or day_type_ eq 1>
					<cfset startdate = CreateDateTime(sal_year,sal_mon,bb,07,30,00)>
                <cfelseif day_type_ eq 0>
					<cfset startdate = CreateDateTime(sal_year,sal_mon,bb,16,30,00)>
                </cfif>
                <cfset time_ = #evaluate('mesai_saat_#in_out_id#_#bb#')#>
                <cfif veri_type eq 0><!--- dakika cinsinden veri--->
                    <cfset finishdate = dateadd("n",time_,startdate)>
                <cfelse><!--- saat cinsinden veri--->
                    <cfset finishdate = dateadd("h",time_,startdate)>
                </cfif>
                <cfquery name="add_worktime" datasource="#dsn#">
                	INSERT INTO
                        EMPLOYEES_EXT_WORKTIMES
                        (
	                        SPECIAL_CODE,
	                        IS_PUANTAJ_OFF,
							IS_FROM_PDKS,
	                        EMPLOYEE_ID,
	                        START_TIME,
	                        END_TIME,
	                        DAY_TYPE,
	                        VALIDATOR_POSITION_CODE_1,
	                        VALIDATOR_POSITION_CODE_2,
	                        VALIDATOR_POSITION_CODE_3,
	                        VALID_1,
	                        VALID_EMPLOYEE_ID_1,
	                        VALIDDATE_1,
	                        VALID_2,
	                        VALID_EMPLOYEE_ID_2,
	                        VALIDDATE_2,
	                        VALID_3,
	                        VALID_EMPLOYEE_ID_3,
	                        VALIDDATE_3,
	                        RECORD_DATE,
	                        RECORD_EMP,
	                        RECORD_IP,
	                        IN_OUT_ID
                        )
                    	VALUES
                        (
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">,
	                        0,
							1,
	                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#">,
	                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">,
	                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">,
	                        <cfqueryparam cfsqltype="cf_sql_integer" value="#day_type_#">,
	                        <cfif len(attributes.admin1_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin1_pos_code#"><cfelse>NULL</cfif>,
	                        <cfif len(attributes.admin2_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin2_pos_code#"><cfelse>NULL</cfif>,
	                        <cfif len(attributes.admin3_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin3_pos_code#"><cfelse>NULL</cfif>,
	                        <cfif attributes.type eq 1>
		                        1,
		                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	                        <cfelse>
		                        NULL,
		                        NULL,
		                        NULL,
	                        </cfif>
	                        <cfif attributes.type eq 2>
		                         1,
		                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	                        <cfelse>
		                        NULL,
		                        NULL,
		                        NULL,
	                        </cfif>
	                        <cfif attributes.type eq 3>
		                         1,
		                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	                        <cfelse>
		                        NULL,
		                        NULL,
		                        NULL,
	                        </cfif>
	                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
	                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
	                        <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
                        )
                </cfquery>
                <cfquery name="get_employee_mail" datasource="#dsn#">
					SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#">
				</cfquery>
                <cfif attributes.type eq 1 and len(attributes.admin2_pos_code)>
                	<cfquery name="get_validate_mail" datasource="#dsn#">
						SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin2_pos_code#">
					</cfquery>
					<cfif len(get_validate_mail.employee_email)>
						<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="HTML">
							<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
							<br/><br/>
							<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(startdate,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi birinci amir onayından geçmiştir.<br/><br/>
							<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
							
							<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
							<br/><br/>
							<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
						</cfmail>
					</cfif>
                <cfelseif attributes.type eq 2 and len(attributes.admin3_pos_code)>
                	<cfquery name="get_validate_mail" datasource="#dsn#">
						SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin3_pos_code#">
					</cfquery>
					<cfif len(get_validate_mail.employee_email)>
						<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="HTML">
							<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
							<br/><br/>
							<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(startdate,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi ikinci amir onayından geçmiştir.<br/><br/>
							<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
							
							<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
							<br/><br/>
							<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
						</cfmail>
					</cfif>
				<cfelseif attributes.type neq 1 and attributes.type neq 2 and attributes.type neq 3 and len(attributes.admin1_pos_code)>
					<cfquery name="get_validate_mail" datasource="#dsn#">
						SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin1_pos_code#">
					</cfquery>
					<cfif len(get_validate_mail.employee_email)>
						<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="html">
							<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
							<br/><br/>
							<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(startdate,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur!<br/><br/>
							<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
							
							<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
							<br/><br/>
							<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
						</cfmail>
					</cfif>
                </cfif>
           </cfif>
        </cfloop>
		<cfif len(evaluate("attributes.gece_mesai_saat_#in_out_id#"))>
			<cfset fark_ = datediff("d",bu_ay_basi,get_emp_id.start_date)>
			<cfset fark_bitis_ = datediff("d",get_emp_id.start_date,bu_ay_sonu)>	
			<cfset fm_minute = evaluate("attributes.gece_mesai_saat_#in_out_id#")>
			<cfif attributes.veri_type eq 1>
				<cfset fm_minute = fm_minute * 60>
			</cfif>
			<cfset islem_dakika = 180>
			<cfset gun_sayisi_ = (fm_minute \ islem_dakika)>
			<cfif fm_minute gt (gun_sayisi_ * islem_dakika)>
				<cfset gun_sayisi_ = gun_sayisi_ + 1>
			</cfif>

				<cfif fark_bitis_ lt daysinmonth(bu_ay_basi)>
					<cfset ay_gunum_ = fark_bitis_>
				<cfelse>
					<cfset ay_gunum_ = daysinmonth(bu_ay_basi)>
				</cfif>
				
				<cfif gun_sayisi_ gt ay_gunum_>
					<cfset islem_dakika = 300>
					<cfset gun_sayisi_ = (fm_minute \ 300)>
					
					<cfif fm_minute gt (gun_sayisi_ * 300)>
						<cfset gun_sayisi_ = gun_sayisi_ + 1>
					</cfif>
				</cfif>
				
				<cfif fark_ gt 0>
					<cfset baslangic_ = fark_>
				<cfelse>
					<cfset baslangic_ = 0>
				</cfif>
				
				<cfset kullanilan_ = 0>
				<cfloop from="1" to="#gun_sayisi_#" index="mmd">
					<cfif mmd neq gun_sayisi_>
						<cfset yazilacak_ = islem_dakika>
					<cfelse>
						<cfset yazilacak_ = (fm_minute - (islem_dakika * (mmd-1)))>
					</cfif> 
					<cfset new_tarih_ = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,(baslangic_+mmd)))>
					<cfset startdate_ = date_add('h',18,new_tarih_)>
					<cfset finishdate_ = date_add('n',yazilacak_,startdate_)>
					<cfif yazilacak_ contains '.'>
						<cfset finishdate_ = date_add('n',yazilacak_,finishdate_)>
					</cfif>
					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
								SPECIAL_CODE,
								IS_PUANTAJ_OFF,
								IS_FROM_PDKS,
								EMPLOYEE_ID,
								START_TIME,
								END_TIME,
								DAY_TYPE,
								VALIDATOR_POSITION_CODE_1,
								VALIDATOR_POSITION_CODE_2,
								VALIDATOR_POSITION_CODE_3,
								VALID_1,
								VALID_EMPLOYEE_ID_1,
								VALIDDATE_1,
								VALID_2,
								VALID_EMPLOYEE_ID_2,
								VALIDDATE_2,
								VALID_3,
								VALID_EMPLOYEE_ID_3,
								VALIDDATE_3,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								IN_OUT_ID
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">,
								0,
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate_#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate_#">,
								3,
								<cfif len(attributes.admin1_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin1_pos_code#"><cfelse>NULL</cfif>,
								<cfif len(attributes.admin2_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin2_pos_code#"><cfelse>NULL</cfif>,
								<cfif len(attributes.admin3_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin3_pos_code#"><cfelse>NULL</cfif>,
								<cfif attributes.type eq 1>
									1,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfelse>
									NULL,
									NULL,
									NULL,
								</cfif>
								<cfif attributes.type eq 2>
								 	1,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfelse>
									NULL,
									NULL,
									NULL,
								</cfif>
								<cfif attributes.type eq 3>
									 1,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfelse>
									NULL,
									NULL,
									NULL,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
								)
						</cfquery>
					<cfquery name="get_employee_mail" datasource="#dsn#">
						SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#">
					</cfquery>
	                <cfif attributes.type eq 1 and len(attributes.admin2_pos_code)>
	                	<cfquery name="get_validate_mail" datasource="#dsn#">
							SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin2_pos_code#">
						</cfquery>
						<cfif len(get_validate_mail.employee_email)>
							<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="HTML">
								<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
								<br/><br/>
								<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(startdate_,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi birinci amir onayından geçmiştir.<br/><br/>
								<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
								
								<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
								<br/><br/>
								<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
							</cfmail>
						</cfif>
	                <cfelseif attributes.type eq 2 and len(attributes.admin3_pos_code)>
	                	<cfquery name="get_validate_mail" datasource="#dsn#">
							SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin3_pos_code#">
						</cfquery>
						<cfif len(get_validate_mail.employee_email)>
							<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="HTML">
								<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
								<br/><br/>
								<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(startdate_,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi ikinci amir onayından geçmiştir.<br/><br/>
								<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
								
								<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
								<br/><br/>
								<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
							</cfmail>
						</cfif>
					<cfelseif attributes.type neq 1 and attributes.type neq 2 and attributes.type neq 3 and len(attributes.admin1_pos_code)>
						<cfquery name="get_validate_mail" datasource="#dsn#">
							SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin1_pos_code#">
						</cfquery>
						<cfif len(get_validate_mail.employee_email)>
							<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html">
								<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
								<br/><br/>
								<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(startdate_,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur!<br/><br/>
								<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
								
								<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
								<br/><br/>
								<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
							</cfmail>
						</cfif>
	                </cfif>
				</cfloop>
		</cfif>
    </cfloop>
<cfelse>
	<cfquery name="upd_old_rec" datasource="#dsn#">
       UPDATE
            EMPLOYEES_EXT_WORKTIMES 
       SET
       		<cfif attributes.type eq 1>
                VALID_1 =  1,
                VALID_EMPLOYEE_ID_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                VALIDDATE_1 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            <cfelseif attributes.type eq 2>
            	VALID_2 = 1,
                VALID_EMPLOYEE_ID_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                VALIDDATE_2 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
             <cfelseif attributes.type eq 3>
            	VALID_3 = 1,
                VALID_EMPLOYEE_ID_3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                VALIDDATE_3 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
              <cfelseif attributes.type eq 4>
            	VALID = 1,
                VALID_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                VALIDDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            </cfif>
        WHERE 
            SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
    </cfquery>
    <cfquery name="get_ext_worktime" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_EXT_WORKTIMES WHERE SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
	</cfquery>
	<cfoutput query="get_ext_worktime">
		<cfquery name="get_employee_mail" datasource="#dsn#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
		</cfquery>
		<cfif attributes.type eq 1 and len(validator_position_code_2)>
			<cfquery name="get_validate_mail" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_2#">
			</cfquery>
			<cfif len(get_validate_mail.employee_email)>
				<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="HTML">
					<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
					<br/><br/>
					<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(start_time,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi birinci amir onayından geçmiştir.<br/><br/>
					<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
								
					<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
					<br/><br/>
					<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
				</cfmail>
			</cfif>
		<cfelseif attributes.type eq 2 and len(validator_position_code_3)>
			<cfquery name="get_validate_mail" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_3#">
			</cfquery>
			<cfif len(get_validate_mail.employee_email)>
				<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="Fazla Mesai Talebi Onayı" type="HTML">
					<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
					<br/><br/>
					<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(start_time,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur. <br/> İzin talebi ikinci amir onayından geçmiştir.<br/><br/>
					<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
								
					<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
					<br/><br/>
					<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
				</cfmail>
			</cfif>
		<cfelseif attributes.type neq 1 and attributes.type neq 2 and attributes.type neq 3 and attributes.type neq 4 and len(validator_position_code_1) and not len(valid_1)>
			<cfquery name="get_validate_mail" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.admin1_pos_code#">
			</cfquery>
			<cfif len(get_validate_mail.employee_email)>
				<cfmail to="#get_validate_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" subject="#message#" type="html">
					<cf_get_lang_main no='1368.Sayın'> #get_validate_mail.employee_name# #get_validate_mail.employee_surname#,
					<br/><br/>
					<b>#get_employee_mail.employee_name# #get_employee_mail.employee_surname#</b> adlı kişi #dateformat(start_time,dateformat_style)# tarihinde fazla mesai talebinde bulunmuştur!<br/><br/>
					<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_extra_times" target="_blank">Fazla Mesai Takip Ekranı</a> <br/><br/>
								
					<cf_get_lang no='1586.Lütfen İşlemi Kontrol Ediniz!...'>
					<br/><br/>
					<cf_get_lang no='1587.Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.'><br/><br/>
				</cfmail>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
<!---<cflocation url="#request.self#?fuseaction=myhome.list_extra_worktimes&is_form_submitted=1&branch_id=#attributes.branch_id#&department=#attributes.department#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&comp_id=#attributes.comp_id#" addtoken="no">--->
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=#nextEvent#&is_form_submitted=1&branch_id=#attributes.branch_id#&department=#attributes.department#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&comp_id=#attributes.comp_id#</cfoutput>";
</script>

