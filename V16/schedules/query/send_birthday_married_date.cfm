<p align="center">Bu Gün Doğanlar - Evlenenler</p>
<style type="text/css">
	.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 1px;color : #0033CC;	}          
	a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 1px;color : #0033CC;} 
	a.tableyazi:active {text-decoration: none;}
	a.tableyazi:hover {text-decoration: underline; color:#339900;}  
	a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 1px;color : #0033CC;}
</style>
<cfquery name="GET_BIRTHDATE" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME, 
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.COMPANY_ID,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1, 
		COMPANY.TAXNO,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER_DETAIL.BIRTHDATE,
		EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID
	FROM 
		COMPANY, 
		COMPANY_PARTNER,
		COMPANY_PARTNER_DETAIL,
		COMPANY_BRANCH_RELATED,
		EMPLOYEE_POSITIONS
	WHERE 
		MONTH(COMPANY_PARTNER_DETAIL.BIRTHDATE) = #month(now())# AND 
		DAY(COMPANY_PARTNER_DETAIL.BIRTHDATE) = #day((now()+1))# AND
		COMPANY_PARTNER_DETAIL.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
		EMPLOYEE_POSITIONS.POSITION_CODE = COMPANY_BRANCH_RELATED.SALES_DIRECTOR AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<cfquery name="GET_MARRIEDDATE" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME, 
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.COMPANY_ID,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1, 
		COMPANY.TAXNO,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER_DETAIL.MARRIED_DATE,
		EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID
	FROM 
		COMPANY, 
		COMPANY_PARTNER,
		COMPANY_PARTNER_DETAIL,
		COMPANY_BRANCH_RELATED,
		EMPLOYEE_POSITIONS
	WHERE 
		MONTH(COMPANY_PARTNER_DETAIL.MARRIED_DATE) = #month(now())# AND 
		DAY(COMPANY_PARTNER_DETAIL.MARRIED_DATE) = #day((now()+1))# AND
		COMPANY_PARTNER_DETAIL.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND 
		EMPLOYEE_POSITIONS.POSITION_CODE = COMPANY_BRANCH_RELATED.SALES_DIRECTOR AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<cfoutput query="GET_BIRTHDATE">
	<cfquery name="CHECK" datasource="#dsn#">
		SELECT 
			OUR_COMPANY.ASSET_FILE_NAME2 
		FROM 
			OUR_COMPANY,
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH
		WHERE 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = #get_birthdate.employee_id# AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	</cfquery>
	<cfif len(get_birthdate.employee_id)>
		<cfquery name="ADD_MESSAGES" datasource="#dsn#">
			INSERT INTO
				WRK_MESSAGE
				(
					RECEIVER_ID,
					RECEIVER_TYPE,
					SENDER_ID,
					SENDER_TYPE,
					MESSAGE,
					SEND_DATE
				)
			VALUES
				(
					#get_birthdate.employee_id#,
					0,
					#get_birthdate.employee_id#,
					0,
					'Yarın Doğum Günü Olan Müşterileriniz Var - #get_birthdate.fullname# - #get_birthdate.company_partner_name# #get_birthdate.company_partner_name# - #dateformat(get_birthdate.birthdate,dateformat_style)# - <a onClick="opener.location.href=''#request.self#?fuseaction=agenda.view_daily&event=add'';window.close();" class="tableyazi">Ajandaya Olay Ekle</a>',
					#now()#
				)
		</cfquery>
	</cfif>
	<cfif len(get_birthdate.employee_email)>
		<cfmail from="#ListFirst(Server_Detail)#" to="#get_birthdate.employee_email#" subject="Workcube Admin Doğum Tarihi Bilgisi" type="html">
		<table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
		  <tr bgcolor="##000000">
			<td>
			  <table cellspacing="1" cellpadding="2" width="100%" border="0">
				<tr bgcolor="##FFFFFF">
				  <td><cfif len(check.asset_file_name2)>
						<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" width="100%">
							<tr> 
							  <td align="center"><img src="#user_domain##file_web_path#settings/#check.asset_file_name2#" border="0"></td>
							</tr>
						</table>
					</cfif></td>
				</tr>
				<tr bgcolor="##FFFFFF">
				  <td>
				  <table align="left">
					<tr>
						<td colspan="2" style="font-size:12px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;font-weight: bold;">Sayın #get_birthdate.employee_name# #get_birthdate.employee_surname# ............</td>
					</tr>
					<tr>
						<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/><br/>Yarın Doğum Günü Olan Müşterileriniz Var ....</td>
					</tr>
					<tr>
						<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">#get_birthdate.company_partner_name# #get_birthdate.company_partner_surname# - <a href="#employee_domain##request.self#?fuseaction=crm.detail_company&cpid=#get_birthdate.company_id#" class="tableyazi">#get_birthdate.fullname#</a> - #dateformat(get_birthdate.birthdate,dateformat_style)#</td>
					</tr>
					<tr>
						<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><a href="#employee_domain##request.self#?fuseaction=agenda.view_daily&event=add" class="tableyazi">Ajandaya Olay Ekle</a></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/>Workcube Admin<br/>#dateformat(now(), dateformat_style)# - #timeformat(now(), 'HH:mm')#</td>
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
<cfoutput query="GET_MARRIEDDATE">
	<cfquery name="CHECK" datasource="#dsn#">
		SELECT 
			OUR_COMPANY.ASSET_FILE_NAME2 
		FROM 
			OUR_COMPANY,
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH
		WHERE 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = #get_marrieddate.employee_id# AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
	</cfquery>
	<cfif len(get_birthdate.employee_id)>
		<cfquery name="ADD_MESSAGES" datasource="#dsn#">
			INSERT 
			INTO 
				WRK_MESSAGE
				(
					RECEIVER_ID,
					RECEIVER_TYPE,
					SENDER_ID,
					SENDER_TYPE,
					MESSAGE,
					SEND_DATE
				)
			VALUES
				(
					#get_birthdate.employee_id#,
					0,
					#get_birthdate.employee_id#,
					0,
					'Yarın Evlenme Yıldönümü Olan Müşterileriniz Var - #get_birthdate.fullname# - #get_birthdate.company_partner_name# #get_birthdate.company_partner_name# - #dateformat(get_birthdate.birthdate,dateformat_style)# - <a onClick="opener.location.href=''#request.self#?fuseaction=agenda.view_daily&event=add'';window.close();" class="tableyazi">Ajandaya Olay Ekle</a>',
					#now()#
				)
		</cfquery>
	</cfif>
	<cfif len(get_birthdate.employee_email)>
		<cfmail from="#ListFirst(Server_Detail)#" to="#get_birthdate.employee_email#" subject="Workcube Admin Evlilik Tarihi Bilgisi" type="html">
		<table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
		  <tr bgcolor="##000000">
			<td>
			  <table cellspacing="1" cellpadding="2" width="100%" border="0">
				<tr bgcolor="##FFFFFF">
				  <td><cfif len(check.asset_file_name2)>
						<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" width="100%">
							<tr> 
							  <td align="center"><img src="#user_domain##file_web_path#settings/#check.asset_file_name2#" border="0"></td>
							</tr>
						</table>
					</cfif></td>
				</tr>
				<tr bgcolor="##FFFFFF">
				  <td>
				  <table align="left">
					<tr>
						<td colspan="2" style="font-size:12px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;font-weight: bold;">Sayın #get_birthdate.employee_name# #get_birthdate.employee_surname# ............</td>
					</tr>
					<tr>
						<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/><br/>Yarın Evlenme Yıldönümü Olan Müşterileriniz Var ....</td>
					</tr>
					<tr>
						<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">#get_marrieddate.company_partner_name# #get_marrieddate.company_partner_surname# - <a href="#employee_domain##request.self#?fuseaction=crm.detail_company&cpid=#get_marrieddate.company_id#" class="tableyazi">#get_marrieddate.fullname#</a> - #dateformat(get_marrieddate.married_date,dateformat_style)#</td>
					</tr>
					<tr>
						<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><a href="#employee_domain##request.self#?fuseaction=agenda.view_daily&event=add" class="tableyazi">Ajandaya Olay Ekle</a></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/>Workcube Admin<br/>#dateformat(now(), dateformat_style)# - #timeformat(now(), 'HH:mm')#</td>
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
