<!---<script type="text/javascript">//tahsilat işlemlerinde sayfa reload edilmesin tahsilat ve kayıt çiftlenmesin diye yapıldı..
	var asciiF5 = 116;//f5 asci kodu
	var bRet = true;
	if(document.all)
		document.onkeydown = onKeyPress;
	else if (document.layers || document.getElementById) 
		document.onkeypress = onKeyPress;

function onKeyPress(evt) 
{
	window.status = '';
	var oEvent = (window.event) ? window.event : evt;
	var nKeyCode = oEvent.keyCode ? oEvent.keyCode :
	oEvent.which ? oEvent.which : 
	void 0;
	var bIsFunctionKey = false;
	if(oEvent.charCode == null || oEvent.charCode == 0)
	bIsFunctionKey = (nKeyCode == asciiF5)
	if(bIsFunctionKey)
	{
		bRet = false;
		try{
			oEvent.returnValue = false;
			oEvent.cancelBubble = true;
			if(document.all)
				oEvent.keyCode = 0;
			else
			{
				oEvent.preventDefault();
				oEvent.stopPropagation();
			}
			window.status = msg; 
		}
		catch(ex){
			alert("<cf_get_lang no ='1433.Sayfayı Yenileyemezsiniz'>!");
		}
	}
	return bRet;
}

	browserName= navigator.appName 
	browserVersion= parseInt(navigator.appVersion) 

document.onmousedown = checkforRightMouseButtonClick; 
if (browserVersion<5 && browserName=="Netscape") 
{ 
	window.onmousedown = checkforRightMouseButtonClick; 
} 

function rightClickPressed() 
{ 
   alert("Bu Sayfada Sağ Tıklamak Yasaktır!"); 
} 

function checkforRightMouseButtonClick(mouseEvent) 
{ 
if ( ((browserName=="Microsoft Internet Explorer") && (event.button >1)) || 
	   ((browserName=="Ne tscape") && (mouseEvent.which > 1)) ) 
	{ 
	  rightClickPressed() 
	  return false; 
	} 
else 
   return true; 
} 
</script>--->
<cfquery name="get_process_type_rev" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_rev#">
</cfquery>
<cfscript>
	process_type_rev = get_process_type_rev.process_type;
	is_cari_rev = get_process_type_rev.is_cari;
	is_account_rev = get_process_type_rev.is_account;
</cfscript>
<cfif is_account_rev eq 1>
	<cfif isDefined("session.pp")>
		<cfset my_acc_result = get_company_period(session.pp.company_id,session_base.period_id)>
	<cfelse>
		<cfset my_acc_result = get_consumer_period(session.ww.userid,session_base.period_id)>
	</cfif>
	<cfif not len(my_acc_result)>
		<script type="text/javascript">
			alert("Muhasebe Hesaplarınız Tanımlanmamıştır Lütfen Müşteri Hizmetlerine Başvurunuz!");
			window.location.href='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=worknet.list_dashboard</cfoutput>';
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfset my_acc_result = ''>
</cfif>

<cfset payment_type_id = trim(ListGetAt(attributes.action_to_account_id,3,";"))>
<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
	SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE,IS_COMISSION_TOTAL_AMOUNT,PAYMENT_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#payment_type_id#">
</cfquery>
<cfif not len(GET_TAKS_METHOD.ACCOUNT_CODE)>
	<script type="text/javascript">
		alert("Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiştir Lütfen Müşteri Hizmetlerine Başvurunuz!");
		window.location.href='<cfoutput>http://#cgi.http_host#/#request.self#?fuseaction=worknet.list_dashboard</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cfscript>
	expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
	expire_year = Right(attributes.exp_year,2);
	attributes.sales_credit = filterNum(attributes.sales_credit);
	attributes.order_related = 1;
	
	if (len(GET_TAKS_METHOD.NUMBER_OF_INSTALMENT) and GET_TAKS_METHOD.NUMBER_OF_INSTALMENT neq 0)
		taksit_sayisi = GET_TAKS_METHOD.NUMBER_OF_INSTALMENT;
	else
		taksit_sayisi = 0;
		
	if (len(GET_TAKS_METHOD.VFT_CODE))
		vft_code = GET_TAKS_METHOD.VFT_CODE;
	else
		vft_code = '';
</cfscript>
<cfif GET_TAKS_METHOD.IS_COMISSION_TOTAL_AMOUNT eq 1 and len(GET_TAKS_METHOD.PAYMENT_RATE)>
	<cfset attributes.cari_sales_credit = filterNum(attributes.sales_credit)-((filterNum(attributes.sales_credit)*GET_TAKS_METHOD.PAYMENT_RATE)/100)>
<cfelse>
	<cfset attributes.cari_sales_credit = filterNum(attributes.sales_credit)>
</cfif>
<cfif isDefined("session.pp.userid")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssl')&'#session.pp.userid#'&round(rand()*100)>
<cfelseif isDefined("session.ww.userid")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssl')&'#session.ww.userid#'&round(rand()*100)>
</cfif>

<!--- sanal pos cekim islemi yapiliyor. --->
<!---<cfinclude template="../../add_options/query/online_pos_files.cfm"> --->
<cfset response_code = 00>

<cfif isDefined("session.pp.userid")>
	<cflog text="#session.pp.name# #session.pp.surname#(#session.pp.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
<cfelseif isDefined("session.ww.userid")>
	<cflog text="#session.ww.name# #session.ww.surname#(#session.ww.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
</cfif>

<cfset credit_cart_warning = 0>
<cfif response_code eq 00><!--- onay almış ve para hesaba geçirilmiş bir işlemse--->
	<cftry>
		<cfset is_comission_total_amount_ = listlast(attributes.action_to_account_id,";")>
		<cfinclude template="../../objects2/finance/query/add_credit_card_revenue.cfm">
		<cfcatch>
			<cfset credit_cart_warning = 1>
			<cfif isDefined("session.pp.userid")>
				<cflog text="KK.Tah Kaydı Yapılamadı #session.pp.name# #session.pp.surname#(#session.pp.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
			<cfelseif isDefined("session.ww.userid")>
				<cflog text="KK.Tah Kaydı Yapılamadı #session.ww.name# #session.ww.surname#(#session.ww.userid#)/ #CGI.REMOTE_ADDR# - #NOW()#; --- wrk_id:#wrk_id#- kart_no:#left(attributes.card_no,4)#********#right(attributes.card_no,4)# ---- response_code:#response_code#" file="sanal_pos_kayit" application="yes" date="yes">
			</cfif>
		</cfcatch>
	</cftry>
<cfelse>
	<cfoutput>
		<form name="form_resp_code" action="" method="post">
			<input type="hidden" name="response_code" id="response_code" value="#response_code#">
			<input type="hidden" name="pos_type" id="pos_type" value="#pos_type#">
		</form>
		<script type="text/javascript">
			form_resp_code.action='http://#cgi.http_host#/#request.self#?fuseaction=objects2.popup_dsp_response_code';<!--- onay almamış tahsilatlarda dönüş kodu bilgisi vermek için --->
			window.open('','resp_code_window1','width=400,height=300');
			form_resp_code.target='resp_code_window1';
			form_resp_code.submit();
			history.back();
		</script>
	</cfoutput>
</cfif>
