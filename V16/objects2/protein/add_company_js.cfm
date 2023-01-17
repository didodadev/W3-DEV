<cfparam name="attributes.is_kur" default="1">
<cfparam name="attributes.field_select_name" default="">
<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_our_company_id = session.pp.our_company_id>
    <cfset session_company_id = session.pp.company_id>
    <cfset session_period_year = session.pp.period_year>
    <cfset session_language = session.pp.language>
    <cfset session_money = session.pp.money>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
    <cfset session_our_company_id = session.ep.our_company_id>
    <cfset session_company_id = session.ep.company_id>
    <cfset session_period_year = session.ep.period_year>
    <cfset session_language = session.ep.language>
    <cfset session_user_id = session.ep.user_id>
    <cfset session_money = session.ep.money>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
    <cfset session_our_company_id = session.ww.our_company_id>
    <cfset session_company_id = session.ww.company_id>
    <cfset session_period_year = session.ww.period_year>
    <cfset session_language = session.ww.language>
    <cfset session_money = session.ww.money>
</cfif>
<cfscript>
//TolgaS 20060321 artık sirketleri listelerken adres ve muhasebe kodunu almıyor asagi atmadan once tek firma için alıp atıyor
	attributes.long_address="";
	attributes.company_id =  attributes.c_id;
	attributes.c_id =  listfirst(attributes.c_id,'_');
	attributes.address="";
	attributes.address_id="";
	attributes.postcode="";
	attributes.mail_adress="";
	attributes.mobile_number_full="";
	attributes.mobile_number="";
	attributes.mobile_code="";
	attributes.telephone_number="";
	attributes.tel_number="";
	attributes.tel_code="";
	attributes.semt="";
	attributes.county_id="";
	attributes.county="";
	attributes.city_id="";
	attributes.city="";
	attributes.country_id="";
	attributes.country="";
	attributes.related_company_id_="";
	attributes.related_company_="";
	attributes.tax_no="";
	attributes.tax_office="";
	attributes.commission="";
	attributes.coordinate_1="";
	attributes.coordinate_2="";
	attributes.sz_id="";
if(isdefined("attributes.field_address") or isdefined("attributes.field_address2") or isdefined("attributes.field_address3") or isdefined("attributes.field_long_address") )// or isdefined("attributes.field_tel_number")  or isdefined("attributes.field_tel")  or isdefined("attributes.field_mobile_tel")
{
	if(isdefined("attributes.is_invoice") and attributes.is_invoice eq 1)
	{get_comp_addres_invoice = cfquery(SQLString:'SELECT COMPBRANCH_ID,COMPBRANCH_ADDRESS,COMPBRANCH_EMAIL,COMPBRANCH_TELCODE,COMPBRANCH_TEL1,COMPBRANCH_POSTCODE,SEMT,COUNTY_ID,CITY_ID,COUNTRY_ID,COMPBRANCH_MOBILTEL,COMPBRANCH_MOBIL_CODE,COORDINATE_1,COORDINATE_2,SZ_ID FROM COMPANY_BRANCH WHERE IS_INVOICE_ADDRESS=1 AND COMPANY_ID=#attributes.c_id#',Datasource:dsn);}
	else
	{get_comp_addres_invoice.recordcount = 0;}
	/* Eger üyenin calisaninin bagli oldugu sube adresi gelecekse. */
	if(isDefined("attributes.is_partner_address") and attributes.is_partner_address eq 1 and len(attributes.pid))
		get_comp_addres = cfquery(SQLString:"SELECT B.COMPBRANCH_ID,B.COMPBRANCH_ADDRESS,B.COMPBRANCH_EMAIL,B.COMPBRANCH_TELCODE,B.COMPBRANCH_TEL1,B.COMPBRANCH_POSTCODE,B.SEMT,B.COUNTY_ID,B.CITY_ID,B.COUNTRY_ID,B.COMPBRANCH_MOBILTEL,B.COMPBRANCH_MOBIL_CODE,B.COORDINATE_1,B.COORDINATE_2,B.SZ_ID FROM COMPANY_BRANCH B, COMPANY_PARTNER CP WHERE CP.COMPBRANCH_ID= B.COMPBRANCH_ID AND CP.COMPANY_ID = B.COMPANY_ID AND CP.PARTNER_ID=#attributes.pid#",Datasource:dsn);
	else
		get_comp_addres = cfquery(SQLString:'SELECT COMPBRANCH_ID,COMPBRANCH_ADDRESS,COMPBRANCH_EMAIL,COMPBRANCH_TELCODE,COMPBRANCH_TEL1,COMPBRANCH_POSTCODE,SEMT,COUNTY_ID,CITY_ID,COUNTRY_ID,COMPBRANCH_MOBILTEL,COMPBRANCH_MOBIL_CODE,COORDINATE_1,COORDINATE_2,SZ_ID FROM COMPANY_BRANCH WHERE IS_SHIP_ADDRESS=1 AND COMPANY_ID=#attributes.c_id#',Datasource:dsn);

	if(get_comp_addres_invoice.recordcount)
	{
		attributes.address=replace(get_comp_addres_invoice.COMPBRANCH_ADDRESS,chr(13)&chr(10),' ','all');
		attributes.address_id=get_comp_addres_invoice.COMPBRANCH_ID;
		attributes.postcode=get_comp_addres_invoice.COMPBRANCH_POSTCODE;
		attributes.semt=get_comp_addres_invoice.SEMT;
		attributes.county_id=get_comp_addres_invoice.COUNTY_ID;
		attributes.city_id=get_comp_addres_invoice.CITY_ID;
		attributes.country_id=get_comp_addres_invoice.COUNTRY_ID;
		attributes.mail_adress=get_comp_addres_invoice.COMPBRANCH_EMAIL;
		attributes.coordinate_1= get_comp_addres_invoice.COORDINATE_1;
        attributes.coordinate_2= get_comp_addres_invoice.COORDINATE_2;
		attributes.sz_id= get_comp_addres_invoice.SZ_ID;
		if(isdefined("attributes.field_tel_code"))
			attributes.telephone_number="#get_comp_addres_invoice.COMPBRANCH_TEL1#";
		else
			attributes.telephone_number="#get_comp_addres_invoice.COMPBRANCH_TELCODE##get_comp_addres_invoice.COMPBRANCH_TEL1#";
		attributes.tel_code="#get_comp_addres_invoice.COMPBRANCH_TELCODE#";
		attributes.tel_number="#get_comp_addres_invoice.COMPBRANCH_TEL1#";
		
		if(isdefined("attributes.field_mobile_tel_code"))
			attributes.mobile_number_full="get_comp_addres_invoice.COMPBRANCH_MOBILTEL";
		else
			attributes.mobile_number_full="#get_comp_addres_invoice.COMPBRANCH_MOBIL_CODE##get_comp_addres_invoice.COMPBRANCH_MOBILTEL#";


		attributes.mobile_number_code="#get_comp_addres_invoice.COMPBRANCH_MOBIL_CODE#";
		attributes.mobile_number="#get_comp_addres_invoice.COMPBRANCH_MOBILTEL#";
	}
	else if(get_comp_addres.recordcount)
	{
		attributes.address=replace(get_comp_addres.COMPBRANCH_ADDRESS,chr(13)&chr(10),' ','all');
		attributes.address_id=get_comp_addres.COMPBRANCH_ID;
		attributes.postcode=get_comp_addres.COMPBRANCH_POSTCODE;
		attributes.semt=get_comp_addres.SEMT;
		attributes.county_id=get_comp_addres.COUNTY_ID;
		attributes.city_id=get_comp_addres.CITY_ID;
		attributes.country_id=get_comp_addres.COUNTRY_ID;
		attributes.mail_adress=get_comp_addres.COMPBRANCH_EMAIL;
		attributes.coordinate_1= get_comp_addres.COORDINATE_1;
        attributes.coordinate_2= get_comp_addres.COORDINATE_2;
		attributes.sz_id= get_comp_addres.SZ_ID;
		if(isdefined("attributes.field_tel_code"))
			attributes.telephone_number="#get_comp_addres.COMPBRANCH_TEL1#";
		else
			attributes.telephone_number="#get_comp_addres.COMPBRANCH_TELCODE##get_comp_addres.COMPBRANCH_TEL1#";
		attributes.tel_code="#get_comp_addres.COMPBRANCH_TELCODE#";
		attributes.tel_number="#get_comp_addres.COMPBRANCH_TEL1#";
		
		if(isdefined("attributes.field_mobile_tel_code"))
			attributes.mobile_number_full="get_comp_addres.COMPBRANCH_MOBILTEL";
		else
			attributes.mobile_number_full="#get_comp_addres.COMPBRANCH_MOBIL_CODE##get_comp_addres.COMPBRANCH_MOBILTEL#";
		attributes.mobile_number_code="#get_comp_addres.COMPBRANCH_MOBIL_CODE#";
		attributes.mobile_number="get_comp_addres.COMPBRANCH_MOBILTEL";
	}
	else
	{
		/* Eger üyenin calisaninin bagli oldugu sube adresi gelecekse. */
		if(isDefined("attributes.is_partner_address") and attributes.is_partner_address eq 1 and len(attributes.pid))
			get_comp_addres = cfquery(SQLString:"SELECT -1 COMPBRANCH_ID,COMPANY_PARTNER_POSTCODE COMPANY_POSTCODE,COMPANY_PARTNER_EMAIL COMPANY_EMAIL,COMPANY_PARTNER_TELCODE COMPANY_TELCODE,COMPANY_PARTNER_TEL COMPANY_TEL1,COMPANY_PARTNER_ADDRESS COMPANY_ADDRESS, SEMT, COUNTY, CITY, COUNTRY,MOBILTEL,MOBIL_CODE,'' COORDINATE_1,'' COORDINATE_2,'' SALES_COUNTY FROM COMPANY_PARTNER WHERE COMPANY_ID=#attributes.c_id# AND PARTNER_ID=#attributes.pid#",Datasource:dsn);
		else
			get_comp_addres = cfquery(SQLString:'SELECT -1 COMPBRANCH_ID,COMPANY_POSTCODE,COMPANY_EMAIL,COMPANY_TELCODE,COMPANY_TEL1,COMPANY_ADDRESS, SEMT, COUNTY, CITY, COUNTRY,MOBILTEL,MOBIL_CODE,COORDINATE_1,COORDINATE_2,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID=#attributes.c_id#',Datasource:dsn);
		
		attributes.address=replace(get_comp_addres.COMPANY_ADDRESS,chr(13)&chr(10),' ','all');
		attributes.address_id=get_comp_addres.COMPBRANCH_ID;
		attributes.postcode=get_comp_addres.COMPANY_POSTCODE;
		attributes.semt=get_comp_addres.SEMT;
		attributes.county_id=get_comp_addres.COUNTY;
		attributes.city_id=get_comp_addres.CITY;
		attributes.country_id=get_comp_addres.COUNTRY;
		attributes.mail_adress=get_comp_addres.COMPANY_EMAIL;
		attributes.coordinate_1= get_comp_addres.COORDINATE_1;
        attributes.coordinate_2= get_comp_addres.COORDINATE_2;
		attributes.sz_id= get_comp_addres.SALES_COUNTY;
		if(isdefined("attributes.field_tel_code"))
			attributes.telephone_number="#get_comp_addres.COMPANY_TEL1#";
		else
			attributes.telephone_number="#get_comp_addres.COMPANY_TELCODE##get_comp_addres.COMPANY_TEL1#";
		attributes.tel_code="#get_comp_addres.COMPANY_TELCODE#";
		attributes.tel_number="#get_comp_addres.COMPANY_TEL1#";
		
		if(isdefined("attributes.field_mobile_tel_code"))
			attributes.mobile_number_full="#get_comp_addres.MOBILTEL#";
		else
		attributes.mobile_number_full="#get_comp_addres.MOBIL_CODE##get_comp_addres.MOBILTEL#";
		attributes.mobile_number_code="#get_comp_addres.MOBIL_CODE#";
		attributes.mobile_number="#get_comp_addres.MOBILTEL#";
	}
	attributes.address = replacelist(attributes.address,"#chr(10)#"," ");
	attributes.address = replacelist(attributes.address,"#chr(13)#"," ");
	//long_address ile ilgili tanimlar asagida devam ediliyor, il ilce bilgilerini yazabilmek icin
	attributes.long_address=attributes.address;
}
else if((isDefined("attributes.field_city_id") and Len(attributes.field_city_id)) or (isDefined("attributes.field_county_id") and Len(attributes.field_county_id)) or (isDefined("attributes.field_country_id") and Len(attributes.field_country_id)))
{
	get_comp_addres = cfquery(SQLString:'SELECT CITY,COUNTY,COUNTRY FROM COMPANY WHERE COMPANY_ID=#attributes.c_id#',Datasource:dsn);
	
	if(Len(get_comp_addres.county)) attributes.county_id = get_comp_addres.county;
	if(Len(get_comp_addres.city)) attributes.city_id = get_comp_addres.city;
	if(Len(get_comp_addres.country)) attributes.country_id = get_comp_addres.country;
}
	
if(len(attributes.county_id))
{
	get_comp_county_id = cfquery(SQLString:'SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID=#attributes.county_id#',Datasource:dsn);
	attributes.county=get_comp_county_id.COUNTY_NAME;
}
else
	attributes.county="";
if(len(attributes.city_id))
{
	get_comp_city_id = cfquery(SQLString:'SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#attributes.city_id#',Datasource:dsn);
	attributes.city=get_comp_city_id.CITY_NAME;
}
else
	attributes.city="";
if(len(attributes.country_id))
{
	get_comp_country_id =cfquery(SQLString:'SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#attributes.country_id#',Datasource:dsn);
	attributes.country=get_comp_country_id.COUNTRY_NAME;
}
else
	attributes.country="";

if(Len(attributes.long_address))
{
	attributes.long_address=attributes.long_address&' '&attributes.postcode&' '&attributes.semt&' '&attributes.county&' '&attributes.city&' '&attributes.country;
	attributes.long_address = replacelist(attributes.long_address,"#chr(10)#"," ");
	attributes.long_address = replacelist(attributes.long_address,"#chr(13)#"," ");
}

//odeme yontemi
attributes.pay_method = "";
attributes.pay_method_id ="";
attributes.card_pay_method_id ="";
attributes.due_of_paymethod ="";
attributes.ship_method_text = "";
attributes.shipmethod_id2 = "";
attributes.rev_method = "";
attributes.rev_method_id ="";
attributes.card_rev_method_id ="";
attributes.due_of_revmethod = "";
attributes.trans_comp_id = "";
attributes.trans_comp_name = "";
attributes.trans_deliver_id = "";
attributes.trans_deliver_name = "";
GET_OUR_COMPANY_INFO = cfquery(SQLString:'SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID=#session_company_id#',Datasource:dsn);
GET_CREDIT_ALL = cfquery(SQLString:'SELECT PAYMETHOD_ID,REVMETHOD_ID,CARD_PAYMETHOD_ID,CARD_REVMETHOD_ID,SHIP_METHOD_ID,TRANSPORT_COMP_ID,TRANSPORT_DELIVER_ID,MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID=#attributes.c_id# AND OUR_COMPANY_ID=#session_company_id#',Datasource:dsn);

	GET_CREDIT_ALL_MONEY = cfquery(SQLString:'SELECT PAYMETHOD_ID,REVMETHOD_ID,CARD_PAYMETHOD_ID,CARD_REVMETHOD_ID,SHIP_METHOD_ID,TRANSPORT_COMP_ID,TRANSPORT_DELIVER_ID,COMPANY_CREDIT.MONEY,RATE2,RATE1,PAYMENT_RATE_TYPE,RATE3,EFFECTIVE_SALE,EFFECTIVE_PUR FROM COMPANY_CREDIT,#dsn_alias#.SETUP_MONEY SETUP_MONEY WHERE COMPANY_CREDIT.MONEY = SETUP_MONEY.MONEY AND COMPANY_CREDIT.COMPANY_ID=#attributes.c_id# AND COMPANY_CREDIT.OUR_COMPANY_ID=#session_company_id#',Datasource:dsn);
if(isdefined("attributes.ship_method_id") or isdefined("attributes.ship_method_name") or isdefined("attributes.field_paymethod_id") or isdefined("attributes.field_paymethod") or isdefined("attributes.field_basket_due_value") or isdefined("attributes.field_revmethod_id") or isdefined("attributes.field_revmethod") or isdefined("attributes.field_basket_due_value_rev"))
{
	if(GET_CREDIT_ALL.RECORDCOUNT)
	{
	if(isdefined("attributes.ship_method_id") or isdefined("attributes.ship_method_name"))
		if(len(GET_CREDIT_ALL.SHIP_METHOD_ID))
		{
			GET_METHOD_NAME =cfquery(SQLString:'SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #GET_CREDIT_ALL.SHIP_METHOD_ID#',Datasource:dsn);
			attributes.ship_method_text = GET_METHOD_NAME.SHIP_METHOD;
			attributes.shipmethod_id2 = GET_CREDIT_ALL.SHIP_METHOD_ID;
		}
	if(isdefined('attributes.field_trans_comp_id'))	
		if	(len(GET_CREDIT_ALL.TRANSPORT_COMP_ID))
		{
			GET_TRANSPORT_COMP_NAME = cfquery(SQLString:'SELECT NICKNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #GET_CREDIT_ALL.TRANSPORT_COMP_ID#',Datasource:dsn);
			attributes.trans_comp_id = GET_TRANSPORT_COMP_NAME.COMPANY_ID;
			attributes.trans_comp_name = GET_TRANSPORT_COMP_NAME.NICKNAME;
		}
	if(isdefined('attributes.trans_deliver_id'))
		if	(len(GET_CREDIT_ALL.TRANSPORT_DELIVER_ID))
		{
			GET_TRANSPORT_DELIVER_NAME = cfquery(SQLString:'SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #GET_CREDIT_ALL.TRANSPORT_DELIVER_ID#',Datasource:dsn);
			attributes.trans_deliver_id = GET_TRANSPORT_DELIVER_NAME.PARTNER_ID;
			attributes.trans_deliver_name = GET_TRANSPORT_DELIVER_NAME.COMPANY_PARTNER_NAME &' '& GET_TRANSPORT_DELIVER_NAME.COMPANY_PARTNER_SURNAME;
		}	
	if(isdefined("attributes.field_paymethod_id") or isdefined("attributes.field_paymethod") or isdefined("attributes.field_basket_due_value"))
	{
		if(len(GET_CREDIT_ALL.PAYMETHOD_ID))
		{
			GET_PAYMETHOD =cfquery(SQLString:'SELECT PAYMETHOD,DUE_DAY,DUE_START_MONTH FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #GET_CREDIT_ALL.PAYMETHOD_ID#',Datasource:dsn);
			attributes.pay_method = GET_PAYMETHOD.PAYMETHOD;
			attributes.pay_method_id = GET_CREDIT_ALL.PAYMETHOD_ID;
			if(len(GET_PAYMETHOD.DUE_DAY))
			{
				if(len(GET_PAYMETHOD.DUE_START_MONTH))
					new_due_day = (GET_PAYMETHOD.DUE_START_MONTH*30) + GET_PAYMETHOD.DUE_DAY;
				else
					new_due_day = GET_PAYMETHOD.DUE_DAY;
			}
			else
			{
				if(len(GET_PAYMETHOD.DUE_START_MONTH))
					new_due_day = (GET_PAYMETHOD.DUE_START_MONTH*30);
				else
					new_due_day = 0;
			}
			attributes.due_of_paymethod = new_due_day;
		}
		else if(len(GET_CREDIT_ALL.CARD_PAYMETHOD_ID))
		{
			GET_CARD_PAYMETHOD =cfquery(SQLString:'SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #GET_CREDIT_ALL.CARD_PAYMETHOD_ID#',Datasource:dsn3);
			attributes.pay_method = GET_CARD_PAYMETHOD.CARD_NO;
			attributes.pay_method_id = '';
			attributes.card_pay_method_id = GET_CREDIT_ALL.CARD_PAYMETHOD_ID;
			attributes.due_of_paymethod = '';
			attributes.commission = GET_CARD_PAYMETHOD.COMMISSION_MULTIPLIER;
		}
	}
	if(isdefined("attributes.field_revmethod_id") or isdefined("attributes.field_revmethod") or isdefined("attributes.field_basket_due_value_rev"))
	{
		if(len(GET_CREDIT_ALL.REVMETHOD_ID))
		{
			GET_REVMETHOD =cfquery(SQLString:'SELECT PAYMETHOD,DUE_DAY,DUE_START_MONTH FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #GET_CREDIT_ALL.REVMETHOD_ID#',Datasource:dsn);
			if(len(GET_REVMETHOD.DUE_DAY))
			{
				if(len(GET_REVMETHOD.DUE_START_MONTH))
					new_due_day = (GET_REVMETHOD.DUE_START_MONTH*30) + GET_REVMETHOD.DUE_DAY;
				else
					new_due_day = GET_REVMETHOD.DUE_DAY;
			}
			else
			{
				if(len(GET_REVMETHOD.DUE_START_MONTH))
					new_due_day = (GET_REVMETHOD.DUE_START_MONTH*30);
				else
					new_due_day = 0;
			}
			attributes.rev_method = GET_REVMETHOD.PAYMETHOD;
			attributes.rev_method_id = GET_CREDIT_ALL.REVMETHOD_ID;
			attributes.due_of_revmethod = new_due_day;
			attributes.card_rev_method_id = '';
		}
		else if(len(GET_CREDIT_ALL.CARD_REVMETHOD_ID))
		{
			GET_CARD_REVMETHOD =cfquery(SQLString:'SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #GET_CREDIT_ALL.CARD_REVMETHOD_ID#',Datasource:dsn3);
			attributes.rev_method = GET_CARD_REVMETHOD.CARD_NO;
			attributes.rev_method_id = '';
			attributes.card_rev_method_id = GET_CREDIT_ALL.CARD_REVMETHOD_ID;
			attributes.due_of_revmethod = '';
			attributes.commission = GET_CARD_REVMETHOD.COMMISSION_MULTIPLIER;
		}
	}
	}
}
//abort('#attributes.c_id#,#dsn2#,#attributes.acc_type_id#');
if(isdefined("attributes.field_member_account_code") and  isdefined("attributes.x_add_multi_acc") and attributes.x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1)
	attributes.member_account_code=get_company_period(attributes.c_id,session_period_year,dsn2,attributes.acc_type_id);
if (isdefined("attributes.field_member_account_code"))
	attributes.member_account_code=get_company_period(attributes.c_id);
else
	attributes.member_account_code="";

//FS & EO ekledi, partnerin mail adresini dusurmek icin ekledik 20090504 sorun olursa birimize bildiriniz	
if(isdefined("attributes.field_mail") and len(attributes.pid))
{
	get_comp_email_ = cfquery(SQLString:'SELECT COMPANY_PARTNER_EMAIL, COMPANY_PARTNER_TELCODE, COMPANY_PARTNER_TEL FROM COMPANY_PARTNER WHERE PARTNER_ID=#attributes.pid#',Datasource:dsn);
	attributes.mail_adress=get_comp_email_.company_partner_email;
	attributes.tel_code=get_comp_email_.company_partner_telcode;
	attributes.tel_number=get_comp_email_.company_partner_tel;
}
if(isdefined("attributes.field_tax_no") or isdefined("attributes.field_tax_office"))
{
	get_comp_tax_ = cfquery(SQLString:'SELECT TAXOFFICE,TAXNO FROM COMPANY WHERE COMPANY_ID=#attributes.c_id#',Datasource:dsn);
	attributes.tax_no=get_comp_tax_.TAXNO;
	attributes.tax_office=get_comp_tax_.TAXOFFICE;
}
</cfscript>
<cfif isdefined("attributes.is_county_related_company") and len(attributes.county_id)>
	<cfquery name="get_related_" datasource="#dsn#">
		SELECT TOP 1
			C.COMPANY_ID,
			C.NICKNAME
		FROM 
			SALES_ZONES SZ,
			SALES_ZONES_TEAM SZT,
            SALES_ZONES_TEAM_COUNTY SZTC,
			COMPANY C
		WHERE 
			C.COMPANY_ID = SZ.RESPONSIBLE_COMPANY_ID AND
			SZ.SZ_ID = SZT.SALES_ZONES<!---  AND
			SZTC.COUNTY_ID LIKE '%,#attributes.county_id#,%' --->
	</cfquery>
	<cfif get_related_.recordcount>
		<cfset attributes.related_company_id_ = get_related_.COMPANY_ID>
		<cfset attributes.related_company_ = get_related_.NICKNAME>
	</cfif>
</cfif>

<script type="text/javascript">
	function add_user(p_id,c_id,name,c_name,long_address,address,postcode,semt,county,county_id,city,city_id,country,country_id,member_account_code,pay_method_id,pay_method,due_of_paymethod,shipmethod_id2,ship_method_text,rev_method_id,rev_method,due_of_revmethod,trans_comp_id,trans_comp_name,trans_deliver_id,trans_deliver_name,mail_adress,telephone_number,card_paymethod_id,card_revmethod_id,tel_code,tel_number,related_company,related_company_id,member_code,p_name,p_surname,tax_no,tax_office,mobile_number_full,mobile_number,mobile_code,address_id,commission,coordinate_1,coordinate_2,sz_id)
	{
		/*window.opener.document ifadesini kaldırdım, cunku oncelikle sayfaya document.form_adı.alan olarak deger gonderen yerler kontrol edilmeli ardından tekrar acılmalı. orn banka gelen havale OZDEN20080925*/
		<cfif isdefined("attributes.field_paymethod_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_paymethod_id#</cfoutput>.value = pay_method_id;
			<cfif isdefined("attributes.field_card_payment_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_card_payment_id#</cfoutput>.value = card_paymethod_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_basket_due_value")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_basket_due_value#</cfoutput>.value = due_of_paymethod;		
		</cfif>
		<cfif isdefined("attributes.field_paymethod")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_paymethod#</cfoutput>.value = pay_method;
		</cfif>
		<cfif isdefined("attributes.field_revmethod_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_revmethod_id#</cfoutput>.value = rev_method_id;
			<cfif isdefined("attributes.field_card_payment_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_card_payment_id#</cfoutput>.value = card_revmethod_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_basket_due_value_rev")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_basket_due_value_rev#</cfoutput>.value = due_of_revmethod;		
		</cfif>
		<cfif isdefined("attributes.field_commission_rate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_commission_rate#</cfoutput>.value = commission;
		</cfif>
		<cfif isdefined("attributes.field_revmethod")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_revmethod#</cfoutput>.value = rev_method;
		</cfif>
		<cfif isdefined("attributes.field_emp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_id#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.field_dep_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_dep_id#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.field_address")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_adress_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_adress_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_adress_id#</cfoutput>.value = address_id;
		</cfif>
		<cfif isdefined("attributes.field_member_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_member_code#</cfoutput>.value = member_code;
		</cfif>
		<cfif isdefined("attributes.field_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_code#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.field_consumer")>
			<cfif listlen(field_consumer,'.') eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_consumer#</cfoutput>').value = '';
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consumer#</cfoutput>.value = '';
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_consumer2")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consumer2#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consumer2#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.field_type")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_type#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_type#</cfoutput>.value = "partner";
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_type#</cfoutput>').value = "partner";
		</cfif>
		<cfif isdefined("attributes.field_name") and not isdefined("attributes.field_comp_name")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput> != undefined)
			{
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput>.value = name + '-' + c_name;
			}
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_name#</cfoutput>').value = name + '-' + c_name;
		<cfelseif isdefined("attributes.field_name")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_name#</cfoutput>').value = name;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_id#</cfoutput>.value = p_id;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_id#</cfoutput>').value = p_id;
		</cfif>
		<cfif isdefined("attributes.field_emp_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_id2#</cfoutput>.value = p_id;
		</cfif>

		<cfif isdefined("attributes.field_comp_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = c_id;
		</cfif>
		<cfif isdefined("attributes.field_comp_id2")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id2#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id2#</cfoutput>.value = c_id;
		</cfif>
		<cfif isdefined("attributes.field_partner")>
		<cfif listlen(field_partner,'.') eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_partner#</cfoutput>').value = p_id;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_partner#</cfoutput>.value = p_id;
			</cfif>			
		</cfif>
		<cfif isdefined("attributes.field_consno")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consno#</cfoutput>.value = p_id;
		</cfif>
		<cfif isdefined("attributes.field_comp_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_name#</cfoutput>.value = c_name ;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_name#</cfoutput>.focus();
		</cfif>
		<cfif isdefined("attributes.field_mail")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_mail#</cfoutput>.value = mail_adress;
		</cfif>
		<cfif isdefined("attributes.field_mobile_tel")>
			<cfif isdefined("attributes.field_mobile_tel_code")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_mobile_tel#</cfoutput>.value = mobile_number;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_mobile_tel_code#</cfoutput>.value = mobile_code;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_mobile_tel#</cfoutput>.value = mobile_number_full;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_tel")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_tel#</cfoutput>.value = telephone_number;
		</cfif>
		<cfif isdefined("attributes.field_tel_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_tel_code#</cfoutput>.value = tel_code;
		</cfif>
		<cfif isdefined("attributes.field_tel_number")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_tel_number#</cfoutput>.value = tel_number;
		</cfif>
		<cfif isdefined("attributes.field_partner_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_partner_name#</cfoutput>.value = p_name;
		</cfif>
		<cfif isdefined("attributes.field_partner_surname")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_partner_surname#</cfoutput>.value = p_surname;
		</cfif>
		<cfif isdefined("attributes.field_partner_name_surname")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_partner_name_surname#</cfoutput>.value = p_name +' '+p_surname;
		</cfif>		
		<cfif isdefined("attributes.field_tax_office")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tax_office#</cfoutput>.value = tax_office;
		</cfif>
		<cfif isdefined("attributes.field_tax_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tax_no#</cfoutput>.value = tax_no;
		</cfif>
		<cfif isdefined("attributes.field_member_account_code")>
			<cfif isdefined("attributes.field_member_account_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_member_account_id#</cfoutput>.value = member_account_code;
			</cfif>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_member_account_code#</cfoutput>.value = member_account_code;
		</cfif>
		
		/*şirket akış parametrelerine bağlı olarak company_credit den işlem dövizi bilgisi alıyor*/
		<cfif attributes.is_kur neq 0>
			
			<cfif get_our_company_info.is_select_risk_money eq 1 and get_credit_all_money.recordcount and len(get_credit_all_money.money) and not isdefined("attributes.is_rate_select")>
				new_money = "<cfoutput>#get_credit_all_money.money#</cfoutput>";
				<cfif get_credit_all_money.payment_rate_type eq 1>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.rate3#</cfoutput>";
				<cfelseif get_credit_all_money.payment_rate_type eq 3>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.effective_pur#</cfoutput>";
				<cfelseif get_credit_all_money.payment_rate_type eq 4>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.effective_sale#</cfoutput>";
				<cfelse>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.rate2#</cfoutput>";
				</cfif>
				<cfif isdefined("attributes.row_no")>
					new_row = "<cfoutput>#attributes.row_no#</cfoutput>";
					if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.money_id'+new_row) != undefined && new_row == 0)
						eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.money_id'+new_row).value = new_money_list;	
				<cfelse>
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.kur_say != undefined)
					{
						new_kur_say = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.kur_say.value;
						for(var i=1;i<=new_kur_say;i++)
						{
							if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i) != undefined && eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value != "<cfoutput>#session_money#</cfoutput>")
							{
								if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date_paper != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.'+<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date_paper.value+'.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date != undefined && <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date.value != 'now()')
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.'+<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date.value+'.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payment_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payment_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.action_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.action_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.ACTION_DATE != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.ACTION_DATE.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.PAYMENT_DATE != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.PAYMENT_DATE.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payroll_revenue_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payroll_revenue_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.act_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.act_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.expense_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.expense_date.value').toString());
								if(paper_date_new != undefined && paper_date_new != '')
								{					
									var listParam = eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value + "*" + paper_date_new;
									get_money_rate_ = wrk_safe_query("obj_get_money_rate_2",'dsn',0,listParam);
									if(get_money_rate_.recordcount == 0)
									{
										get_money_rate_ = wrk_safe_query('obj_get_money_rate','dsn2',0,eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value);
									}								
								}
								else
								{
									get_money_rate_ = wrk_safe_query('obj_get_money_rate','dsn2',0,eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value);
								}
								if(get_money_rate_ != undefined)
								{
									<cfif get_credit_all_money.payment_rate_type eq 1>
										if(get_money_rate_.RATE3 != '')
											eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = <cfif not isdefined("attributes.draggable")>window.opener.</cfif>commaSplit(get_money_rate_.RATE3,4);
									<cfelseif get_credit_all_money.payment_rate_type eq 3>
										if(get_money_rate_.EFFECTIVE_PUR != '')
											eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = <cfif not isdefined("attributes.draggable")>window.opener.</cfif>commaSplit(get_money_rate_.EFFECTIVE_PUR,4);
									<cfelseif get_credit_all_money.payment_rate_type eq 4>
										if(get_money_rate_.EFFECTIVE_SALE != '')
											eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = <cfif not isdefined("attributes.draggable")>window.opener.</cfif>commaSplit(get_money_rate_.EFFECTIVE_SALE,4);
									<cfelse>
										if(get_money_rate_.RATE2 != '')
											eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = <cfif not isdefined("attributes.draggable")>window.opener.</cfif>commaSplit(get_money_rate_.RATE2,4);
									</cfif>
								}
							}
							if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i) != undefined && eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.rd_money') != undefined && eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.rd_money['+(i-1)+']').disabled != true && eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value == new_money)
							{
								eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.rd_money['+(i-1)+']').checked = true;
							}
							if(typeof <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.kur_degistir != "undefined")
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.kur_degistir(i);	
						}
					}
				</cfif>				
			</cfif>
		<cfelse>
				<cfif get_our_company_info.is_select_risk_money eq 1 and get_credit_all_money.recordcount and len(get_credit_all_money.money) and not isdefined("attributes.is_rate_select")>
				new_money = "<cfoutput>#get_credit_all_money.money#</cfoutput>";
				<cfif get_credit_all_money.payment_rate_type eq 1>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.rate3#</cfoutput>";
				<cfelseif get_credit_all_money.payment_rate_type eq 3>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.effective_pur#</cfoutput>";
				<cfelseif get_credit_all_money.payment_rate_type eq 4>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.effective_sale#</cfoutput>";
				<cfelse>
					new_money_list = "<cfoutput>#get_credit_all_money.money#;#get_credit_all_money.rate1#;#get_credit_all_money.rate2#</cfoutput>";
				</cfif>
				<cfif isdefined("attributes.row_no")>
					new_row = "<cfoutput>#attributes.row_no#</cfoutput>";
					if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.money_id'+new_row) != undefined && new_row == 0)
						eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.money_id'+new_row).value = new_money_list;	
				<cfelse>
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.kur_say != undefined)
					{
						new_kur_say = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.kur_say.value;
						for(var i=1;i<=new_kur_say;i++)
						{
							if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i) != undefined && eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value != "<cfoutput>#session_money#</cfoutput>")
							{
								if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date_paper != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.'+<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date_paper.value+'.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date != undefined && <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date.value != 'now()')
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.'+<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date.value+'.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payment_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payment_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.action_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.action_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.ACTION_DATE != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.ACTION_DATE.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.PAYMENT_DATE != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.PAYMENT_DATE.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payroll_revenue_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payroll_revenue_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.act_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.act_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.expense_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.expense_date.value').toString());
								if(paper_date_new != undefined && paper_date_new != '')
								{					
									var listParam = eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value + "*" + paper_date_new;
									get_money_rate_ = wrk_safe_query("obj_get_money_rate_2",'dsn',0,listParam);
									if(get_money_rate_.recordcount == 0)
									{
										get_money_rate_ = wrk_safe_query('obj_get_money_rate','dsn2',0,eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value);
									}								
								}
								else
								{
									get_money_rate_ = wrk_safe_query('obj_get_money_rate','dsn2',0,eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value);
								}
								
							}
							<cfif isdefined("attributes.field_select_name") and len(attributes.field_select_name)>
								if((eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_select_name#</cfoutput>['+(i-1)+']').value).split(';')[1] == new_money)
								{
									eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_select_name#</cfoutput>['+(i-1)+']').selected = true;
								}
							</cfif>
							if(typeof <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.kur_degistir != "undefined")
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.kur_degistir(i);	
						}
					}
				</cfif>				
			</cfif>

		</cfif>
		
		<cfif isdefined("attributes.field_name")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput>.focus();
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_name#</cfoutput>').focus();
		</cfif>
		<cfif isdefined("attributes.cash_control_add") or isdefined("attributes.cash_control_upd")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.EMPLOYEE_ID.value="";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.upd_cash_payment.emp_name.value="";
		</cfif>
		<cfif isDefined("attributes.field_table")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+name+"</td></tr></table>";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pars#</cfoutput>.value += "," + p_id + ",";
		</cfif>
		/*yeni eklenenler*/
		<cfif isdefined("attributes.field_long_address")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_long_address#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_long_address#</cfoutput>.value = long_address;
		</cfif>
		<cfif isdefined("attributes.field_postcode") and len(attributes.field_postcode)>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode#</cfoutput>.value = postcode;
		</cfif>
		<cfif isdefined("attributes.field_semt")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt#</cfoutput>)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt#</cfoutput>.value = semt;
		</cfif>
		<cfif isdefined("attributes.field_country")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country#</cfoutput>)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country#</cfoutput>.value = country;
		</cfif>
		<cfif isdefined("attributes.field_country_id")>
			<cfif isdefined("attributes.is_select") and attributes.is_select eq 2>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_country_id,".")#</cfoutput>").select2().val(country_id).trigger('change');
			<cfelse>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_country_id#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id#</cfoutput>.value = country_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_city")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city#</cfoutput>)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city#</cfoutput>.value = city;
		</cfif>
		<cfif isdefined("attributes.field_city_id")>
			<cfif isdefined("attributes.is_select") and attributes.is_select eq 2>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_city_id,".")#</cfoutput>").select2().val(city_id).trigger('change');
			<cfelse>
				if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id#</cfoutput> != undefined)
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id#</cfoutput>.value = city_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_county")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county#</cfoutput>.value = county;
		</cfif>
		<cfif isdefined("attributes.field_county_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id#</cfoutput> != undefined)
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_address2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address2#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_postcode2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode2#</cfoutput>.value = postcode;
		</cfif>
		<cfif isdefined("attributes.field_semt2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt2#</cfoutput>.value = semt;
		</cfif>
		<cfif isdefined("attributes.field_country2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country2#</cfoutput>.value = country;
		</cfif>
		<cfif isdefined("attributes.field_country_id2")>
			<cfif isdefined("attributes.is_select") and attributes.is_select eq 2>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_country_id2,".")#</cfoutput>").select2().val(country_id).trigger('change');
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id2#</cfoutput>.value = country_id;
			</cfif>
		</cfif>	
		<cfif isdefined("attributes.field_city2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city2#</cfoutput>.value = city;
		</cfif>
		<cfif isdefined("attributes.field_city_id2")>
			<cfif isdefined("attributes.is_select") and attributes.is_select eq 2>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_city_id2,".")#</cfoutput>").select2().val(city_id).trigger('change');
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id2#</cfoutput>.value = city_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_county2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county2#</cfoutput>.value = county;
		</cfif>
		<cfif isdefined("attributes.field_county_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id2#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_address3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address3#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_postcode3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode3#</cfoutput>.value = postcode;
		</cfif>
		<cfif isdefined("attributes.field_semt3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt3#</cfoutput>.value = semt;
		</cfif>
		<cfif isdefined("attributes.field_country3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country3#</cfoutput>.value = country;
		</cfif>
		<cfif isdefined("attributes.field_country_id3")>
			<cfif isdefined("attributes.is_select") and attributes.is_select eq 2>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_country_id3,".")#</cfoutput>").select2().val(country_id).trigger('change');
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id3#</cfoutput>.value = country_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_city3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city3#</cfoutput>.value = city;
		</cfif>
		<cfif isdefined("attributes.field_city_id3")>
			<cfif isdefined("attributes.is_select") and attributes.is_select eq 2>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_city_id3,".")#</cfoutput>").select2().val(city_id).trigger('change');
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id3#</cfoutput>.value = city_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_county3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county3#</cfoutput>.value = county;
		</cfif>
		<cfif isdefined("attributes.field_county_id3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id3#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_member_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_member_name#</cfoutput>.value =c_name ;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_member_name#</cfoutput>.focus();
		</cfif>
		<cfif isdefined("attributes.field_trans_comp_id")><!--- Taşıyıcı firma id --->
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_trans_comp_id#</cfoutput>.value = trans_comp_id;	
		</cfif>
		<cfif isdefined("attributes.field_trans_comp_name")><!--- Taşıyıcı firma ismi --->
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_trans_comp_name#</cfoutput>.value = trans_comp_name;
		</cfif>
		<cfif isdefined("attributes.field_trans_deliver_id")><!--- Taşıyıcı firma yetkili id'si --->
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_trans_deliver_id#</cfoutput>.value = trans_deliver_id;		
		</cfif>
		<cfif isdefined("attributes.field_trans_deliver_name")><!--- Taşıyıcı firma yetkili ismi--->
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_trans_deliver_name#</cfoutput>.value = trans_deliver_name;		
		</cfif>
		<cfif isdefined("attributes.ship_method_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#ship_method_id#</cfoutput>.value = shipmethod_id2;
		</cfif>
		<cfif isdefined("attributes.ship_method_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#ship_method_name#</cfoutput>.value = ship_method_text;
		</cfif>
		
		<cfif isdefined("attributes.is_county_related_company")>
			<cfif isdefined("attributes.related_company")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.related_company#</cfoutput>.value = related_company;
			</cfif>
			<cfif isdefined("attributes.related_company_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.related_company_id#</cfoutput>.value = related_company_id;
			</cfif>
		</cfif>
		/*yeni eklenenler*/
		<cfif isdefined("attributes.str_opener_form_url")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.str_opener_form#</cfoutput>.action='<cfoutput>#request.self#?fuseaction=#attributes.str_opener_form_url#</cfoutput>'>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.str_opener_form#</cfoutput>.submit();
		</cfif>
		<cfif isdefined("attributes.basket_cheque")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.reload_basket();
		</cfif>
		<cfif isdefined("attributes.call_function")>
			<cfif listlen(attributes.call_function,'-') gt 1>
				<cfloop from="1" to="#listlen(attributes.call_function,'-')#" index="call_i">
					try{<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#listgetat(attributes.call_function,call_i,'-')#</cfoutput>;}
						catch(e){};
				</cfloop>			
			<cfelse>
				try{<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
					catch(e){};
			</cfif>
		</cfif>
		<cfif isdefined("attributes.ship_coordinate_1")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#ship_coordinate_1#</cfoutput>.value = coordinate_1;
		</cfif>
		<cfif isdefined("attributes.ship_coordinate_2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#ship_coordinate_2#</cfoutput>.value = coordinate_2;
		</cfif>
		<cfif isdefined("attributes.invoice_coordinate_1")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#invoice_coordinate_1#</cfoutput>.value = coordinate_1;
		</cfif>
		<cfif isdefined("attributes.invoice_coordinate_2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#invoice_coordinate_2#</cfoutput>.value = coordinate_2;
		</cfif>
		<cfif isdefined("attributes.contact_coordinate_1")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#contact_coordinate_1#</cfoutput>.value = coordinate_1;
		</cfif>
		<cfif isdefined("attributes.contact_coordinate_2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#contact_coordinate_2#</cfoutput>.value = coordinate_2;
		</cfif>
		<cfif isdefined("attributes.ship_sales_zone_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#ship_sales_zone_id#</cfoutput>.value = sz_id;
		</cfif>
		<cfif isdefined("attributes.invoice_sales_zone_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#invoice_sales_zone_id#</cfoutput>.value = sz_id;
		</cfif>
		<cfif isdefined("attributes.contact_sales_zone_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#contact_sales_zone_id#</cfoutput>.value = sz_id;
		</cfif>
		
		if(typeof(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.find_risk) != 'undefined')  //basketteki toplamdaki risk_bilgisi icin eklendi, add_company_js.cfm 'de de var.
		{
			try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.find_risk();}
				catch(e){};
		}
		if(typeof(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options) != 'undefined')  //baskete seri ve barkoddan urun ekleme bolumu icin eklendi, add_company_js.cfm 'de de var.
		{
			try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options();}
				catch(e){};
		}
		<cfif not isdefined("attributes.field_comp_id")>
			<cfif not isdefined("attributes.draggable")>self.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfif>
	}
	<cfoutput>
		
		add_user("#attributes.pid#","<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>#attributes.company_id#<cfelse>#attributes.c_id#</cfif>","#attributes.name#","#attributes.c_name#","#attributes.long_address#","#attributes.address#","#attributes.postcode#","#attributes.semt#","#attributes.county#","#attributes.county_id#","#attributes.city#","#attributes.city_id#","#attributes.country#","#attributes.country_id#","#attributes.member_account_code#","#attributes.pay_method_id#","#attributes.pay_method#","#attributes.due_of_paymethod#","#attributes.shipmethod_id2#","#attributes.ship_method_text#","#attributes.rev_method_id#","#attributes.rev_method#","#attributes.due_of_revmethod#","#attributes.trans_comp_id#","#attributes.trans_comp_name#","#attributes.trans_deliver_id#","#attributes.trans_deliver_name#","#attributes.mail_adress#","#attributes.telephone_number#","#attributes.card_pay_method_id#","#attributes.card_rev_method_id#","#attributes.tel_code#","#attributes.tel_number#","#attributes.related_company_#","#attributes.related_company_id_#","#attributes.member_code#","#attributes.p_name#"
		,"#attributes.p_surname#","#attributes.tax_no#","#attributes.tax_office#","#attributes.mobile_number_full#","#attributes.mobile_number#","#attributes.mobile_code#","#attributes.address_id#","#attributes.commission#","#attributes.coordinate_1#","#attributes.coordinate_2#",'#attributes.sz_id#');
	</cfoutput>
</script>


	<cfscript>
		get_note.recordcount = 0;
		/*kullanilabilir_risk_limiti = 0;
		acik_risk_limiti = 0;*/
	</cfscript>
<script type="text/javascript">
	<cfif get_note.recordcount>
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_company_note&c_id=#attributes.c_id#</cfoutput>','medium');
	</cfif>
	<cfif not isdefined("attributes.draggable")>self.close();<cfelseif isdefined("attributes.draggable")>$('#popup_box_<cfoutput>#attributes.modal_id#</cfoutput>').remove();</cfif>
</script>
