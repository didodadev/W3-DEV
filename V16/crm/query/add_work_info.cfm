<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
			<!--- Sosyal Güvenlik Kurumları --->
			<cfquery name="DEL_SOCIETY" datasource="#dsn#">
				DELETE FROM COMPANY_PARTNER_SOCIETY WHERE PARTNER_ID = #attributes.partner_id#  AND COMPANY_ID = #attributes.cpid#
			</cfquery>
			<cfif isDefined('attributes.society')>
				<cfloop list="#attributes.society#" index="i">
					<cfquery name="ADD_SOCIETY" datasource="#dsn#">
						INSERT 
						INTO 
							COMPANY_PARTNER_SOCIETY
							(
								SOCIETY_ID,
								PARTNER_ID,
								COMPANY_ID
							)
							VALUES
							(
								#i#,
								#attributes.partner_id#,
								#attributes.cpid#
							)
					</cfquery>
				</cfloop>
			</cfif>
			<!--- Müşteri Genel Konumu  --->
			<cfquery name="DEL_POSITION" datasource="#dsn#">
				DELETE FROM COMPANY_POSITION WHERE COMPANY_ID = #attributes.cpid# 
			</cfquery>
			<cfif isDefined('attributes.customer_position')>
				<cfloop list="#attributes.customer_position#" index="i">
					<cfquery name="ADD_POSITION" datasource="#dsn#">
						INSERT 
						INTO 
							COMPANY_POSITION 
							(
								POSITION_ID,
								COMPANY_ID
							)
							VALUES
							(
								#i#,
								#attributes.cpid#
							)
					</cfquery>
				</cfloop>
			</cfif>
			<!--- Özel Sigorta Şirketleri --->
			<cfquery name="DEL_INS_COMP" datasource="#dsn#">
				DELETE FROM COMPANY_PARTNER_INSURANCE_COMP WHERE PARTNER_ID = #attributes.partner_id#  AND  COMPANY_ID = #attributes.cpid#
			</cfquery>
			<cfif isDefined('attributes.insurance_company')>
				<cfloop list="#attributes.insurance_company#" index="i">
					<cfquery name="ins_comp" datasource="#dsn#">
						INSERT INTO 
							COMPANY_PARTNER_INSURANCE_COMP
						(
							INSURANCE_COMP_ID,
							PARTNER_ID,
							COMPANY_ID
						)
						VALUES
						(
							#i#,
							#attributes.partner_id#,
							#attributes.cpid#
						)
					</cfquery>
				</cfloop>
			</cfif>
			<!---  Ugrastigi Diger isler --->
			<cfquery name="DEL_JOB" datasource="#dsn#">
				DELETE FROM COMPANY_PARTNER_JOB_OTHER WHERE PARTNER_ID = #attributes.partner_id#  AND COMPANY_ID = #attributes.cpid#
			</cfquery>
			<cfif isDefined('attributes.other_works')>
				<cfloop list="#attributes.other_works#" index="i">
					<cfquery name="ADD_JOB" datasource="#dsn#">
						INSERT INTO 
							COMPANY_PARTNER_JOB_OTHER
						(
							JOB_ID,
							PARTNER_ID,
							COMPANY_ID
						)
						VALUES
						(
							#i#,
							#attributes.partner_id#,
							#attributes.cpid#
						)
					</cfquery>
				</cfloop>
			</cfif>

		<!--- Çalıştığı Rakip Depolar --->
		<cfquery name="DEL_RIVALS" datasource="#dsn#">
			DELETE FROM COMPANY_PARTNER_RIVAL WHERE PARTNER_ID = #attributes.partner_id#  AND COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfif isDefined('attributes.competitor_depot')>
			<cfloop list="#attributes.competitor_depot#" index="i">
				<cfquery name="ADD_RIVALS" datasource="#dsn#">
					INSERT 
					INTO 
						COMPANY_PARTNER_RIVAL
						(
							RIVAL_ID,
							PARTNER_ID,
							COMPANY_ID
						)
						VALUES
						(
							#i#,
							#attributes.partner_id#,
							#attributes.cpid#
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif attributes.service_id neq "">
			<!--- Servis Bilgilerini Update Et --->
			<cfquery name="UPD_COMPANY_SERVICE_INFO" datasource="#DSN#">
				UPDATE
					COMPANY_SERVICE_INFO
				SET
					PC_NUMBER = <cfif len(attributes.pc_number)>#attributes.pc_number#,<cfelse>NULL,</cfif>
					NET_CONNECTION = <cfif len(attributes.net_connection)>#attributes.net_connection#,<cfelse>NULL,</cfif>
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP =  '#cgi.remote_addr#',
					IT_CONCERNED = <cfif len(attributes.it_concerned)>#attributes.it_concerned#<cfelse>NULL</cfif>
				WHERE
					COMPANY_ID = #attributes.cpid#
			</cfquery>
			<cfquery name="DEL_SOFTS" datasource="#DSN#">
				DELETE FROM COMPANY_OFFICE_SOFTWARES WHERE COMPANY_ID = #attributes.cpid# AND SERVICE_ID = #attributes.service_id# 
			</cfquery>
			<cfif isDefined("attributes.softwares")>
				<cfoutput>
					<cfloop from="1" to="#ListLen(attributes.softwares)#" index="i">
						<cfset liste = ListGetAt(attributes.softwares,i)>
						<cfquery name="ins_softwares" datasource="#dsn#">
							INSERT 
								INTO 
									COMPANY_OFFICE_SOFTWARES
									(
										COMPANY_ID,
										SOFTWARE_ID,
										SERVICE_ID
									)
								VALUES 
									(	
										#attributes.cpid#,
										#liste#,
										#attributes.service_id#
									)
						</cfquery>
					</cfloop>
				</cfoutput>
			</cfif>
		<cfelse>
			<cfquery name="UPD_COMPANY_SERVICE_INFO" datasource="#DSN#" result="MAX_ID">
				INSERT
				INTO
					COMPANY_SERVICE_INFO
				(
					COMPANY_ID,
					PC_NUMBER,
					NET_CONNECTION,
					IT_CONCERNED,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.cpid#, 
					<cfif len(attributes.pc_number)>#attributes.pc_number#,<cfelse>NULL,</cfif>
					<cfif len(attributes.net_connection)>#attributes.net_connection#,<cfelse>NULL,</cfif>
					<cfif len(attributes.it_concerned)>#attributes.it_concerned#,<cfelse>NULL,</cfif>
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
			<cfif isDefined("attributes.softwares")>
				<cfoutput>
					<cfloop from="1" to="#ListLen(attributes.softwares)#" index="i">
						<cfset liste = ListGetAt(attributes.softwares,i)>
						<cfquery name="ins_softwares" datasource="#dsn#">
							INSERT 
							INTO 
								COMPANY_OFFICE_SOFTWARES
									(
										COMPANY_ID,
										SOFTWARE_ID,
										SERVICE_ID
									)
								VALUES 
									(	
										#attributes.cpid#,
										#liste#,
										#MAX_ID.IDENTITYCOL#
									)
						</cfquery>
					</cfloop>
				</cfoutput>
			</cfif>
		</cfif>
		<!--- Sms İstiyor mu ? --->
		<cfquery name="UPD_PARTNER_INFO" datasource="#dsn#">
			UPDATE
				COMPANY_PARTNER
			SET
				IS_SMS = <cfif isdefined("attributes.is_sms")>1<cfelse>0</cfif>
			WHERE
				PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<!--- Lokasyon Bilgieleri --->
		<cfquery name="upd_locs" datasource="#dsn#">
			UPDATE 
				COMPANY
			SET
				STOCK_AMOUNT = <cfif len(attributes.stock_amount)>#attributes.stock_amount#,<cfelse>NULL,</cfif>
				DUTY_PERIOD  = <cfif len(attributes.duty_period)>#attributes.duty_period#,<cfelse>NULL,</cfif>
				ENDORSE_PERIOD = <cfif len(attributes.endorse_total)>#attributes.endorse_total#,<cfelse>NULL,</cfif>
				ENDORSE_PAYMENT = <cfif len(attributes.endorse_payment)>#attributes.endorse_payment#,<cfelse>NULL,</cfif>
				ENDORSE_CURRENCY = '#attributes.money_curr#'
			WHERE 
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="GET_BSM_INFO" datasource="#dsn#">
			SELECT 
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
				COMPANY.FULLNAME
			FROM
				COMPANY,
				COMPANY_BRANCH_RELATED,
				EMPLOYEE_POSITIONS
			WHERE
				COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
				COMPANY.COMPANY_ID = #attributes.cpid# AND
				COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND
				EMPLOYEE_POSITIONS.POSITION_CODE = COMPANY_BRANCH_RELATED.SALES_DIRECTOR
		</cfquery>
		<cfquery name="CHECK" datasource="#dsn#">
			SELECT ASSET_FILE_NAME2 FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
		</cfquery>
		<cfoutput query="get_bsm_info">
			<cfif len(get_bsm_info.employee_email)>
				<cfmail from="workcube@hedefalliance.com.tr" to="#get_bsm_info.employee_email#" subject="Güncelleme - #fullname#" type="html">
				<table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
				  <tr bgcolor="##000000">
					<td>
					  <table cellspacing="1" cellpadding="2" width="100%" border="0">
						<tr bgcolor="##FFFFFF">
						  <td><cfif len(check.asset_file_name2)>
								<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" width="100%">
									<tr> 
									  <td align="center"><img src="#user_domain##file_web_path#settings/#check.asset_file_name2#" alt="" border="0"></td>
									</tr>
								</table>
							</cfif></td>
						</tr>
						<tr bgcolor="##FFFFFF">
						  <td>
						  <table align="left">
							<tr>
								<td colspan="2" style="font-size:12px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;font-weight: bold;"><cf_get_lang_main no='1368.Sayın'> #employee_name# #employee_surname# ............</td>
							</tr>
							<tr>
								<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/><br/>#fullname#<cf_get_lang no ='925.Çalışma Bilgilerinde'>  #session.ep.name# #session.ep.surname# <cf_get_lang no ='926.Tarafından Güncelleme Yapılmıştır'>.<cf_get_lang no ='927.Bilginize'>..... </td>
							</tr>
							<tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">&nbsp;</td>
							</tr>
							<tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><cf_get_lang no ='928.Eczane'></td>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: #fullname#</td>
							</tr>
							<tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><cf_get_lang no ='929.Güncelleme Yapan'></td>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: #session.ep.name# #session.ep.surname#</td>
							</tr>
							<tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><cf_get_lang no ='930.Güncelleme Tarihi'></td>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: #dateformat(now(),dateformat_style)# #timeformat(now(), timeformat_style)#</td>
							</tr>
							<tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Link</td>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: <a href="#employee_domain##request.self#?fuseaction=crm.form_upd_company&cpid=#attributes.cpid#" class="tableyazi ">#fullname#</a></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
						  </table>
						  </td>
						</tr>
					  </table>
					</td>
				  </tr>
				</table>
				</cfmail>
			</cfif>
		</cfoutput>
	</cftransaction>
</cflock>	
<cflocation url="#request.self#?fuseaction=crm.popup_company_work_info&partner_id=#attributes.partner_id#&cpid=#attributes.cpid#" addtoken="no">
