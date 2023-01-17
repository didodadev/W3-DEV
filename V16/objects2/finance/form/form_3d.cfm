<cfset payment_type_id = trim(ListGetAt(attributes.action_to_account_id,3,";"))>
<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
	SELECT NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#payment_type_id#">
</cfquery>

<cfset pos_id = ListGetAt(attributes.action_to_account_id,4,";")>
<cfquery name="getSanalPosType" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY_POS_RELATION WHERE POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">
</cfquery>
<cfscript>
	//sanal pos sifre ve gerekli bilgileri
	pos_user_name = getSanalPosType.user_name;
	pos_user_password = getSanalPosType.password;
	pos_terminal_no = getSanalPosType.terminal_no;
	pos_client_id = getSanalPosType.client_id;
	post_adress_3d = getSanalPosType.bank_host_3d;
	pos_store_key = getSanalPosType.store_key;
	
	if (len(GET_TAKS_METHOD.NUMBER_OF_INSTALMENT) and GET_TAKS_METHOD.NUMBER_OF_INSTALMENT neq 0)
		taksit = GET_TAKS_METHOD.NUMBER_OF_INSTALMENT;
	else
		taksit = '';
		
	okUrl = 'https://#cgi.HTTP_HOST#/index.cfm?fuseaction=objects2.popup_3d_control&okParam=1&is_order_=1';
	failUrl = 'https://#cgi.HTTP_HOST#/index.cfm?fuseaction=objects2.popup_3d_control&okParam=0&is_order_=0';
	oid = "#dateformat(now(),'ddmmyyy')##timeformat(now(),'hhmmSS')#";
	expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
	expire_year = Right(attributes.exp_year,2);
	
	if(listfind("1,2,3,4,5,6,10,13,14,16",getSanalPosType.pos_type,','))//Akbank,Fortis,IsBank,DenizBank,Finansbank,HSBC,Vakifbank,Halkbank,Citibank,TEB,Garanti,ING Bank(xml format)
	{
		rnd = timeformat(now(),'HHmmssl');
		tutar = filterNum(attributes.tutar_);
		hashData = '#pos_client_id##oid##tutar##okUrl##failUrl##taksit##rnd##pos_store_key#';
		hashData_ = ToBase64(BinaryDecode(Hash(hashData, "SHA1"), "Hex"));
	}
	else if(getSanalPosType.pos_type eq 8)//garanti
	{
		if (len(pos_terminal_no) lt 9)
			terminalID_ = repeatString("0",9-len(pos_terminal_no)) & "#pos_terminal_no#";
		else
			terminalID_ = pos_terminal_no;
		tutar = filterNum(attributes.tutar_);
		tutar = tutar*100;
		strMode = "PROD";
		strApiVersion = "v0.01";
		strType = "sales";
		SecurityData = hash("#pos_user_password##terminalID_#",'sha-1');
		HashData = hash("#pos_terminal_no##oid##tutar##okUrl##failUrl##strType##taksit##pos_store_key##SecurityData#",'sha-1');
	}
</cfscript>
<cfoutput>
	<form name="form_3d" action="#post_adress_3d#" method="post">
	  <cfif getSanalPosType.pos_type eq 8>
		<input type="text" name="cardnumber" id="cardnumber" value="#attributes.card_no#"/>
		<input type="text" name="cardexpiredatemonth" id="cardexpiredatemonth" value="#expire_month#"/>
		<input type="text" name="cardexpiredateyear" id="cardexpiredateyear" value="#expire_year#" />
		<input type="text" name="cardcvv2" id="cardcvv2" value="#attributes.cvv_no#"/>
		<input type="text" name="mode" id="mode" value="#strMode#" />
		<input type="text" name="apiversion" id="apiversion" value="#strApiVersion#" />
		<input type="text" name="terminalprovuserid" id="terminalprovuserid" value="#pos_user_name#" />
		<input type="text" name="terminaluserid" id="terminaluserid" value="#pos_user_name#" />
		<input type="text" name="terminalmerchantid" id="terminalmerchantid" value="#pos_client_id#" />
		<input type="text" name="txntype" id="txntype" value="#strType#" />
		<input type="text" name="txnamount" id="txnamount" value="#tutar#" />
		<input type="text" name="txncurrencycode" id="txncurrencycode" value="949" />
		<input type="text" name="txninstallmentcount" id="txninstallmentcount" value="#taksit#" />
		<input type="text" name="orderid" id="orderid" value="#oid#" /><br />
		<input type="text" name="terminalid" id="terminalid" value="#pos_terminal_no#" />
		<input type="text" name="successurl" id="successurl" value="#okUrl#" />
		<input type="text" name="errorurl" id="errorurl" value="#failUrl#" />
		<input type="text" name="customeripaddress" id="customeripaddress" value="#cgi.REMOTE_ADDR#" />
		<input type="text" name="customeremailaddress" id="customeremailaddress" value="" />
		<input type="text" name="secure3dhash" id="secure3dhash" value="#HashData#" />
		<input type="text" name="secure3dsecuritylevel" id="secure3dsecuritylevel" value="3d">
	 <cfelseif listfind("1,2,3,4,5,6,10,13,14,16",getSanalPosType.pos_type,',')>
		<input type="hidden" name="pan" id="pan" value="#attributes.card_no#">
		<input type="hidden" name="cv2" id="cv2" value="#attributes.cvv_no#"> 
		<input type="hidden" name="Ecom_Payment_Card_ExpDate_Year" id="Ecom_Payment_Card_ExpDate_Year" value="#expire_year#">
		<input type="hidden" name="Ecom_Payment_Card_ExpDate_Month" id="Ecom_Payment_Card_ExpDate_Month" value="#expire_month#">
		<input type="hidden" name="clientid" id="clientid" value="#pos_client_id#" > 
		<input type="hidden" name="amount" id="amount" value="#tutar#" >
		<input type="hidden" name="oid" id="oid" value="#oid#">
		<input type="hidden" name="okUrl" id="okUrl" value="#okUrl#">
		<input type="hidden" name="failUrl" id="failUrl" value="#failUrl#">
		<input type="hidden" name="rnd" id="rnd" value="#rnd#">
		<input type="hidden" name="hash" id="hash" value="#hashData_#">
		<input type="hidden" name="taksit" id="taksit" value="#taksit#">
		<input type="hidden" name="storetype" id="storetype" value="3d">
		<input type="hidden" name="lang" id="lang" value="tr">
		<input type="hidden" name="currency" id="currency" value="949">
	 </cfif>
	</form>
</cfoutput>

<script language="javascript">
	windowopen('','page','wrk3dwindow');
	document.form_3d.target = 'wrk3dwindow';
	document.form_3d.submit();
</script>
<cfabort>
