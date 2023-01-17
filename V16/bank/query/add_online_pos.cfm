<!---
Kredi Kartı tahsilat sanal pos sayfasıdır,
formdan gelen bilgilerle banka tipine göre online gerçek pos işlemi yapılır,
bankadan onay alınmış bir işlemse kredi kartı tahsilat hareketi yapıcak...
Ayşenur 20060310
--->
<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#session.ep.userid#'&round(rand()*100)>
<cfscript>
	attributes.sales_credit = filterNum(attributes.sales_credit);
	attributes.other_value_sales_credit = filterNum(attributes.other_value_sales_credit);
	form.other_value_sales_credit = filterNum(form.other_value_sales_credit);
	attributes.system_amount = filterNum(attributes.system_amount);
	attributes.sales_credit_comm = filterNum(attributes.sales_credit_comm);
	attributes.sales_credit_dsp = filterNum(attributes.sales_credit_dsp);
</cfscript>
<cfif isDefined("attributes.subs_inv_id")>
	<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
		SELECT IS_COLLECTED_PROVISION FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION neq 0>
		<script type="text/javascript">
			alert("<cf_get_lang no ='416.Aynı Ödeme Planı Satırı İçin Provizyon İşlemi Yapılmıştır'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
    <cfquery name="GET_PAID_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
		SELECT IS_PAID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id# AND IS_PAID = 1
	</cfquery>
    <cfif GET_PAID_INFO.recordcount>
		<script type="text/javascript">
			alert("İlişkili fatura aha önceden tahsil edilmiştir! Tahsilat işlemi gerçekleşmeyecektir.");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_period_info" datasource="#dsn#">
		SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset new_dsn2 = "#dsn#_#get_period_info.period_year#_#get_period_info.our_company_id#">
	<cfquery name="get_inv_wrk_id" datasource="#new_dsn2#">
		SELECT WRK_ID FROM INVOICE WHERE INVOICE_ID = #attributes.subs_inv_id#
	</cfquery>
	<cfset wrk_id_invoice = get_inv_wrk_id.wrk_id>
<cfelse>
	<cfset wrk_id_invoice = wrk_id>	
</cfif>

<cfinclude template="../../objects2/finance/query/online_pos_files.cfm">
<!---<cfset response_code = 00> --->
<cflog text="#session.ep.name# #session.ep.surname#(#session.ep.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id_invoice#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes">
<cfquery name="get_ins_num" datasource="#dsn3#">
	SELECT 
		PAYMENT_TYPE_ID, 
		ISNULL(NUMBER_OF_INSTALMENT,0) NUMBER_OF_INSTALMENT, 
		P_TO_INSTALMENT_ACCOUNT,
		ACCOUNT_CODE,
		SERVICE_RATE,
		IS_PESIN,
		CARD_NO
	FROM 
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		PAYMENT_TYPE_ID = #listgetat(attributes.action_to_account_id,3,';')#
</cfquery>
<cfif isDefined("attributes.x_is_add_ins_number") and attributes.x_is_add_ins_number eq 1>
	<cfif get_ins_num.number_of_instalment eq 0>
		<cfset attributes.action_detail = attributes.action_detail & ' ' & 'Tek Çekim'>
	<cfelse>
		<cfset attributes.action_detail = attributes.action_detail & ' ' & '#get_ins_num.number_of_instalment# Taksit'>
	</cfif>
</cfif>
<cfif response_code eq 00><!--- onay almış ve para hesaba geçirilmiş bir işlemse--->
	<cftry>
		<cfinclude template="../query/add_creditcard_revenue_onlinepos.cfm">
		Sanal POS İşlemi Gerçekleşti,Hesabınıza Para Geçmiştir!<br/>
		Kredi Kartı Tahsilat Kaydı Yapılmıştır!
		<script language="javascript">
			alert("Sanal POS İşlemi Gerçekleşti,Hesabınıza Para Geçmiştir! Kredi Kartı Tahsilat Kaydı Yapılmıştır!");
			window.opener.location.reload();
			window.close();
		</script>
		<cfabort>
	<cfcatch>
			<cflog text="KK.Tah Kaydı Yapılamadı #session.ep.name# #session.ep.surname#(#session.ep.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id_invoice#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes">
			<cfif isDefined("attributes.x_send_error_mail") and len(attributes.x_send_error_mail)>
				<cfquery name="get_emp_mail" datasource="#dsn#">
					SELECT
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME,
						EMPLOYEE_EMAIL
					FROM
						EMPLOYEE_POSITIONS
					WHERE
						POSITION_CODE IN (#attributes.x_send_error_mail#)
						AND EMPLOYEE_EMAIL IS NOT NULL
				</cfquery>
				<cfif get_emp_mail.recordcount>
					<cfsavecontent variable="message"><cfoutput>#attributes.comp_name#</cfoutput> Kredi Kartı Tahsilatı</cfsavecontent>
					<cfoutput query="get_emp_mail">
						<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#get_emp_mail.employee_email#" subject="#message#" type="html">
							<style type="text/css">.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}</style>
							<table width="600" class="css1">
								<tr>
									<td>Sayın #get_emp_mail.employee_name# #get_emp_mail.employee_surname#, <br /><br />
										#attributes.comp_name# Carisi İçin #attributes.sales_credit# #session.ep.money# Tutarında Sanal POS İşlemi Gerçekleşti. <br />
										Fakat Kredi Kartı Tahsilat Kaydı Yapılamamıştır, Kredi Kartı Tahsilat Ekleme Ekranından Sisteme Kayıt Yapabilirsiniz.<br />
                                        Banka Bilgisi : #get_ins_num.card_no#<br />
									</td>
								</tr>
							</table>
							<br/><br/>
						</cfmail>
					</cfoutput>
				</cfif>
			</cfif>
			<script type="text/javascript">
				alert("<cf_get_lang no ='417.Sanal POS İşlemi Gerçekleşti,Hesabınıza Para Geçmiştir!Fakat Kredi Kartı Tahsilat Kaydı Yapılamamıştır,Kredi Kartı Tahsilat Ekleme Ekranından Sisteme Kayıt Yapabilirsiniz'>...");
				<cfoutput>
					window.open('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_creditcard_revenue');
					window.close();
				</cfoutput>
			</script>
		</cfcatch>
	</cftry>
<cfelse>
	<form name="form_resp_code" action="" method="post">
		<input type="hidden" name="response_code" id="response_code" value="<cfoutput>#response_code#</cfoutput>">
		<input type="hidden" name="pos_type" id="pos_type" value="<cfoutput>#pos_type#</cfoutput>">
	</form>
	<script type="text/javascript">
		alert('<cf_get_lang no ="418.İşlem Onay Almamıştır Dönüş Kodu"> : ' + "<cfoutput>#response_code#</cfoutput>");
		form_resp_code.action='<cfoutput>#request.self#?fuseaction=objects2.popup_dsp_response_code</cfoutput>';<!--- onay almamış tahsilatlarda dönüş kodu bilgisi vermek için --->
		window.open('','resp_code_window1','width=400,height=300');
		form_resp_code.target='resp_code_window1';
		form_resp_code.submit();
		window.close();
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
