 <!---
Kredi Kartı tahsilat sanal pos sayfasıdır,
formdan gelen bilgilerle banka tipine göre online gerçek pos işlemi yapılır,
bankadan onay alınmış bir işlemse kredi kartı tahsilat hareketi yapıcak...
Sipariş sonlandırdaki ödeme sayfasına benzer fakat orası dinamik oldugu için ayrı sayfadalar
--->
<script type="text/javascript">//tahsilat işlemlerinde sayfa reload edilmesin tahsilat ve kayıt çiftlenmesin diye yapıldı..
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
</script>

<cfif isDefined("attributes.order_id_info")>
	<cfquery name="KONTROL_ODEME" datasource="#DSN3#">
		SELECT ORDER_ID FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id_info#"> AND IS_PAID = 1
	</cfquery>
	<cfif KONTROL_ODEME.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1432.Bu Sipariş İçin Ödeme Yapılmıştır'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif isDefined("session.pp.userid")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssl')&'#session.pp.userid#'&round(rand()*100)>
<cfelseif isDefined("session.ww.userid")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssl')&'#session.ww.userid#'&round(rand()*100)>
<cfelseif isDefined("attributes.partner_id")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssl')&'#attributes.partner_id#'&round(rand()*100)>
<cfelseif isDefined("attributes.consumer_id")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssl')&'#attributes.consumer_id#'&round(rand()*100)>
</cfif>
<cfscript>
	attributes.sales_credit = filterNum(attributes.sales_credit);
	attributes.sales_credit_dsp = filterNum(attributes.sales_credit_dsp);
</cfscript>

<cfinclude template="online_pos_files.cfm" />

<cfset response_code = 00>

<cfif isDefined("ykb_inst_num")>
	<cfset attributes.action_detail = attributes.action_detail & ' ' & '(#ykb_inst_num# Taksit)'>
</cfif>

<cfif response_code eq 00><!--- onay almış ve para hesaba geçirilmiş bir işlemse--->
	<cftry>
		<cfset is_comission_total_amount_ = listlast(attributes.action_to_account_id,";")>
		<cfinclude template="add_credit_card_revenue.cfm">
		<main role="main"> 
			<div class="container-fluid" style=" margin-top: 55px; "> 
				<div class="row justify-content-md-center">
					<div class="ol-12 col-sm-8 col-md-7 col-lg-5">
						<div class="card">
						<div class="card-body">
							<h1 class="card-title text-center text-success"><i class="far fa-smile"></i></h1>
							<h4 class="card-text text-center">
								Tahsilat İşleminiz Yapılmıştır.
							</h4>
							<div class="text-center">
								<a href="/" class="btn btn-primary mt-2">Anasayfaya Devam Et</a>
							</div>
						</div>
						</div>
					</div>
				</div>
			</div>
		</main>
		<cfabort>
		<cfcatch>
			<div style="position:absolute;z-index: 99999;background: white; display:none;">
				<cfdump  var="#cfcatch#">
			</div>
			<main role="main"> 
				<div class="container-fluid" style=" margin-top: 55px; "> 
					<div class="row justify-content-md-center">
						<div class="col-12 col-sm-8 col-md-7 col-lg-5">
							<div class="card">
							<div class="card-body">
								<h1 class="card-title text-center text-danger"><i class="far fa-frown"></i></h1>
								<h4 class="card-text text-center">
									<cf_get_lang dictionary_id='35752.Sanal POS İşleminiz Yapıldı. Fakat Sisteme Kredi Kartı Tahsilat Kaydı Yapılamamıştır. Lütfen Müşteri Hizmetlerine Başvurunuz!'>
								</h4>
								<div class="text-center">
									<a href="/" class="btn btn-primary mt-2">Anasayfaya Devam Et</a>
								</div>
							</div>
							</div>
						</div>
					</div>
				</div>
			</main>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfoutput>
		<form name="form_resp_code" action="" method="post">
			<input type="hidden" name="response_code" id="response_code" value="#response_code#">
			<input type="hidden" name="pos_type" id="pos_type" value="#pos_type#">
		</form>
		<script type="text/javascript">//partner domainler ekleniyor https den çıksın diye
			form_resp_code.action='http://#cgi.http_host#/#request.self#?fuseaction=objects2.popup_dsp_response_code';<!--- onay almamış tahsilatlarda dönüş kodu bilgisi vermek için --->
			window.open('','resp_code_window1','width=400,height=300');
			form_resp_code.target='resp_code_window1';
			form_resp_code.submit();
			<cfif isdefined('attributes.invoice_id_list')>
				history.back();
			<cfelse>
				window.close();
			</cfif>
		</script>
	</cfoutput>
</cfif>