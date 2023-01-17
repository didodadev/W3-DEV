<!--- 
	Web Service Uzerinden SMS Gonderimi FBS
	Formdan Gelen Parametreler; _PhoneNumber_ , _Message_ , _StatusControl_ , _SendDate_ , _DeleteDate_
	DataPort, Turatel, DorukHaberlesme ve 3GBilisim Firmalari Icin Entegrasyon Saglanmistir
	DataPort 20090225- TuraTel 20120312- DorukHaberlesme 20150417
  --->
<cfif not isDefined("attributes.data_source")><cfset attributes.data_source = dsn></cfif>
<cfif isDefined("session.ep")>
	<cfset OurCompanyId = session.ep.company_id>
<cfelseif isDefined("session.pp")>
	<cfset OurCompanyId = session.pp.company_id>
<cfelseif isDefined("session.ww")>
	<cfset OurCompanyId = session.ww.our_company_id>
<cfelse>
	<cfset OurCompanyId = 0>
</cfif>

<cfquery name="get_sms_info" datasource="#attributes.data_source#">
	SELECT IS_SMS,SMS_COMPANY,SMS_CUSTOMERNO,SMS_USERNAME,SMS_PASSWORD,SMS_SERVICECODE,SMS_ALPHANUMERIC FROM #dsn_alias#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#OurCompanyId#">
</cfquery>
<cfif get_sms_info.is_sms eq 1>
	<cfif Len(get_sms_info.sms_customerno)><cfset _CustomerNo_ = get_sms_info.sms_customerno><cfelse><cfset _CustomerNo_ = ""></cfif>
	<cfif Len(get_sms_info.sms_username)><cfset _UserName_ = get_sms_info.sms_username><cfelse><cfset _UserName_ = ""></cfif>
	<cfif Len(get_sms_info.sms_password)><cfset _Password_ = get_sms_info.sms_password><cfelse><cfset _Password_ = ""></cfif>
	<cfif Len(get_sms_info.sms_servicecode)><cfset _ServiceCode_ = get_sms_info.sms_servicecode><cfelse><cfset _ServiceCode_ = ""></cfif>
	<cfif Len(get_sms_info.sms_alphanumeric)><cfset _AlphaNumeric_ = get_sms_info.sms_alphanumeric><cfelse><cfset _AlphaNumeric_ = ""></cfif>
	<cfif get_sms_info.sms_company eq 1>
		<!--- Dataport
		http://sms.dataport.com.tr/WebServices/SmsServices.asmx?op=SendSingleSMS
		
		SendSingleSMS Fonksiyonu
		CustomerNo		: Size tarafımızdan verilen müşteri numaranızdır.
		UserName		: Güvenlik sorgulamasından geçmek için kullanacağız kullanıcı adınız.
						  (Eğer sms gönderecek hesap için şifreleme kullan seçilmiş ise, kullanıcının şifre anahtarına göre bu değer TripleDES ile şifrelenmelidir.)
		Password		: Güvenlik sorgulamasından geçmek için kullanacağız şifreniz
						  (Eğer sms gönderecek hesap için şifreleme kullan seçilmiş ise, kullanıcının şifre anahtarına göre bu değer TripleDES ile şifrelenmelidir.)
		ServiceCode		: Mesaj atmak istediğiniz Kısa Mesaj Numaranız
		AlphaNumeric	: Mesaj atarken kısa mesaj numaranız yerine çıkmasını istediğiniz alphanumeric bir metindir. Bu özelliğin Gateway tarafında açılmış ve size bu yetkinin verilmiş olması gerekir. Aksi takdir istediğiniz tanımı yazarak mesaj atamazsınız.
		PhoneNumber		: Mesaj atmak istediğiniz telefon numarası. 
						  Örnek: 0090532XXXXXXX  -  0532XXXXXXX –  532XXXXXXX
						  Eğer verdiğiniz numara BlackList içerisinde ise mesaj göndermek istediğinizde konuyla ilgili hata mesajı döner.
		Message			: Mesajınızın içeriği 
						  (Eğer sms gönderecek hesap için şifreleme kullan seçilmiş ise, kullanıcının şifre anahtarına göre bu değer TripleDES ile şifrelenmelidir.)
		StatusControl	: 1 veya 0 gibi bir değer içerir. Bu özellik Turkcell’den durum sorgulaması isteyip istemediğinizi belirtir. 
						  Eğer bu değer 0 verilirse mesajınız Turkcell’e gönderildikten sonra direkt Gönderildi konumuna düşer. Eğer 1 verilirse sistem cevap alasaya kadar bunu sürekli Turkcell’den sorgular. 
		SendDate		: Mesajınızın gönderilmesini istediğiniz zamanı belirtebilirsiniz. Geçerli bir tarih formatı olmak zorundadır. Bu özelliğin çalışma ve işleyiş garantisi Turkcell verir.
						  yyyy-MM-dd HH:mm:ss	Örnek: 2004-12-29  23:59:00
						  SendDate alanına vereceğiniz değer mesajınızın gateway’e ulaştığı zamandan büyük olmalıdır. Aksi takdirde 704 hata mesajı alırsınız. 
		DeleteDate		: Mesajınızın bu zamana kadar gönderilemezse silinmesini istediğinizi belirten tanımdır. Geçerli bir tarih formatı olmak zorundadır. Bu özelliğin çalışma ve işleyiş garantisi Turkcell verir.
						  Eğer SendDate set edilmiş ve DeleteDate boş bırakılmış ise sistem otomatik olarak bir gün sonrasını DeleteDate alanına set eder.
						  yyyy-MM-dd HH:mm:ss	Örnek: 2004-12-29  23:59:00
		 --->
		<cfif Len(_SendDate_)><cfset _SendDate_ = DateFormat(_SendDate_,'yyyy-mm-dd') & ' ' & TimeFormat(_SendDate_,'HH:MM:ss')></cfif>
		<cfhttp url="http://sms.dataport.com.tr/WebServices/SmsServices.asmx/SendSingleSMS" method="Post" timeout="60">
			<cfhttpparam type="formfield" name="CustomerNo" value="#_CustomerNo_#">
			<cfhttpparam type="formfield" name="UserName" value="#_UserName_#">
			<cfhttpparam type="formfield" name="Password" value="#_Password_#">
			<cfhttpparam type="formfield" name="ServiceCode" value="#_ServiceCode_#">
			<cfhttpparam type="formfield" name="AlphaNumeric" value="#_AlphaNumeric_#">
			<cfhttpparam type="formfield" name="PhoneNumber" value="#_PhoneNumber_#">
			<cfhttpparam type="formfield" name="Message" value="#_Message_#">
			<cfhttpparam type="formfield" name="StatusControl" value="#_StatusControl_#">
			<cfhttpparam type="formfield" name="SendDate" value="#_SendDate_#">
			<cfhttpparam type="formfield" name="DeleteDate" value="#_DeleteDate_#">
		</cfhttp>
		<cfset xmlDoc = XmlParse(cfhttp.Filecontent)>
		<cfif len(xmlDoc)>
			<cfset resources=xmlDoc.xmlroot>
			<cfif len(resources[1].SMS.MsgID.xmltext) and resources[1].SMS.MsgID.xmltext neq -1><cfset Sms_Status = 1><cfelse><cfset Sms_Status = 0></cfif>
			<cfif len(resources[1].SMS.ErrorCode.xmltext)><cfset Error_Code = resources[1].SMS.ErrorCode.xmltext><cfelse><cfset Error_Code = ""></cfif>
		</cfif>
	<cfelseif get_sms_info.sms_company eq 2>
		<!--- TuraTel
		https://processor.smsorigin.com/xml/process.aspx
		
		SmsToMany Fonksiyonu
		Command			: Her işleme göre farklılık gösteren İşlem kodu. (Smstomany: 0, Smstomultisenders: 1)
		PlatformID		: Yetkili tarafından sağlanacak PlatformID. Yetkili tarafından aksi söylenmedikçe 1 olarak girilmelidir.
		UserName		: Yetkili tarafından sağlanacak kullanıcı adı.
		PassWord		: Yetkili tarafından sağlanacak kullanıcı şifresi.
		ChannelCode		: Yetkili tarafından sağlanacak Kanal Kodu.
		Mesgbody		: Mesaj içeriği.
		Numbers			: Smstomany, yani 1 mesaj metninin birden fazla numaraya gönderilmesinde kullanılır. 
						  Numaralar 905422222222, 05423333333 veya 5444444444 şeklinde olabilir ve numaralar arasında ayraç olarak virgül kullanılmalıdır.
		Type			: Mesajın formatını belirlemek için kullanılacaktır. (Text SMS : 1, Wap-Push : 5)
		Originator		: Mesaj gönderilirken kullanılacak originator seçilebilir. Boş ise default olan originator kullanır.
		SDate			: Mesajın gönderilmeye başlanacağı tarihi gösterir ddmmyyyyhhmm formatındadır. Bu değer belirtilmemişse mesaj hemen yollanır.
						  Server tarihinden eski bir tarihe gönderilmeye çalışılırsa Mesajlar Hemen gidecektir.
		EDate			: Mesajın gönderim işleminin biteceği tarihi gösterir ddmmmyyyyhhmm formatındadır.
						  Hiçbir değer girilmemişse mesaj 24 saat içerisinde gönderilmeye devam edilir. 
						  End Date min. 90 dakika olmalıdır. 90 dakikadan küçük EndDate'lerde otomatik olarak 90 dakika ayarlanır. 
						  24 saatten büyük EndDate ayarlamasında ise otomatik olarak 24 saat olarak ayarlanır.
						  End Date her zaman Send Date „ ten büyük bir tarih olmalıdır. Bu durumda End Date , Send Date„ e 24 saat eklenerek uygulanır.
						  End Date, şu anki tarihten küçük bir tarih olmamalıdır. Bu durumda End Date , Send Date„ e 24 saat eklenerek uygulanır.
		Concat			: 1 mesajda gönderilemeyecek büyüklükte İçerik var ise, bunu otomatik olarak 1 den fazla mesaj olarak göndermesi için gerekli parametredir. 
						  Mesela 160 karakterlik Text Sms gönderilirken , Mesgbody alanına 160 tan fazla içerik yazılırsa ve Concat parametresi 1 olarak ayarlanırsa 
						  Mesajlar aboneye tek bir mesaj olarak ulaşacak fakat aslında birden fazla mesajın birleştirilerek gönderilmiş olacaktır.
						  0 : Mesajlar uzun olarak gönderilmesin, 1 : Mesajlar uzun olarak gönderilsin.
		IsTCKimlikNoPacket: Msisdn yerine, Tc Kimlik No üzerinden gönderim yapmayı sağlar. 
						  Parametre 1 olarak gönderilirse, Msisdn olarak yazılan değerler Tc Kimlik No olarak kabul edilir. 
		 --->
		<cfif Len(_SendDate_)><cfset _SendDate_ = DateFormat(_SendDate_,'ddmmyyyyHHMM')></cfif>
		<cfscript>
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"MainmsgBody");
			my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Command");
			my_doc.xmlRoot.XmlChildren[1].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"PlatformID");
			my_doc.xmlRoot.XmlChildren[2].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"UserName");
			my_doc.xmlRoot.XmlChildren[3].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"PassWord");
			my_doc.xmlRoot.XmlChildren[4].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"ChannelCode");
			my_doc.xmlRoot.XmlChildren[5].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Mesgbody");
			my_doc.xmlRoot.XmlChildren[6].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"Numbers");
			my_doc.xmlRoot.XmlChildren[7].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Type");
			my_doc.xmlRoot.XmlChildren[8].XmlText = "";
			
			my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"Originator");
			my_doc.xmlRoot.XmlChildren[9].XmlText = "";
		</cfscript>
		<cfhttp url="http://processor.smsorigin.com/xml/process.aspx" method="Post" timeout="60">
			<cfhttpparam type="xml" name="data" value="#my_doc#">
		</cfhttp>
		
		<cfset Sms_Status = 1>
		<cfset xmlDoc = cfhttp.FileContent>
		<cfif Len(xmlDoc)>
			<!--- Hata Olmadiysa Onay kodunu yazmamiza gerek yok,-1 sorunsuz anlaminda kullanilacak raporlarda da --->
			<cfif xmlDoc contains ':'>
				<cfset Error_Code = -1>
			<cfelse>
				<cfset Error_Code = Trim(xmlDoc)>
			</cfif>
		</cfif>
    <cfelseif get_sms_info.sms_company eq 3>
		<!--- Doruk Haberleşme
        http://www.leadinplus.com/apixml/sms/
                
        SMS Gönderme Fonksiyonu
        UserName   : Kayıt esnasında alınan kullanıcı adı(Zorunlu)
        PassWord   : Kayıt esnasında alınan erişim parolasıdır.(Zorunlu)
        UyeID      : İş yerinizin sistemimize tanımlandıktan sonra  size verilecek olan ID değeri için kullanılır.
        MsgText    : Mesaj içeriğinin yazılacağı parametredir.
        Numbers    : GSM numarasının/numaralarının yazılacağı parametre.Birden fazla GSM numarasına aralarına virgül(,) koyarak ayırabilirsiniz.Formata uymayan numaralar 
                     sistem tarafından atlanarak işlem uygulanmaz. 
        Originator : Kayıt esnasında alınan originatörlerden biri olmalıdır.
        Language   : Göndermek istediğiniz SMS'in Türkçeyi desteklemesini istiyorsanız TR yazarak belirtmelisiniz.Boş gönderdiğiniz durumda TR karakterler İngilizce 
                     ile değiştirilecektir.
        --->
		<cfscript>
            my_doc = XmlNew();
            my_doc.xmlRoot = XmlElemNew(my_doc,"MainBody");
            my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"UserName");
            my_doc.xmlRoot.XmlChildren[1].XmlText = "#_UserName_#";
            
            my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"PassWord");
            my_doc.xmlRoot.XmlChildren[2].XmlText = "#_Password_#";
            
            my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"UyeID");
            my_doc.xmlRoot.XmlChildren[3].XmlText = "#_ServiceCode_#";
        
            my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Messages");
            my_doc.xmlRoot.XmlChildren[4].xmlChildren[1] = XmlElemNew(my_doc,"Message");
            my_doc.xmlRoot.XmlChildren[4].xmlChildren[1].xmlChildren[1] = XmlElemNew(my_doc,"MsgText");
            my_doc.xmlRoot.XmlChildren[4].xmlChildren[1].xmlChildren[1].XmlText = "#_Message_#";
            my_doc.xmlRoot.XmlChildren[4].xmlChildren[1].xmlChildren[2] = XmlElemNew(my_doc,"Numbers");
            my_doc.xmlRoot.XmlChildren[4].xmlChildren[1].xmlChildren[2].XmlText = "#_PhoneNumber_#";
            
            my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"Originator");
            my_doc.xmlRoot.XmlChildren[5].XmlText = "#_AlphaNumeric_#";
			            
            my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Language");
            my_doc.xmlRoot.XmlChildren[6].XmlText = "TR";
        </cfscript>

        <cfhttp url="http://www.leadinplus.com/apixml/sms/" method="Post" timeout="60">
            <cfhttpparam type="xml" name="data" value="#my_doc#">
        </cfhttp>
    
		<cfset Sms_Status = 0> 
        <cfif len(cfhttp.FileContent) and find( "200", cfhttp.statusCode )>   
            <cfset xmlDoc = cfhttp.FileContent>
            <cfif len(xmlDoc)>
                <cfif cfhttp.FileContent contains '#chr(35)#'>
                    <cfset Error_Code = ListGetAt(xmlDoc,1,"#chr(35)#")>
                    <cfset Uniqcode = ListGetAt(xmlDoc,2,"#chr(35)#")>
                    <cfset Sms_Status = 1>
                <cfelse>
                    <cfset Error_Code = trim(xmlDoc)>
                </cfif>
            </cfif>
        <cfelse>
            <cfset Error_Code = 500>
        </cfif>
	<cfelseif get_sms_info.sms_company eq 4>   
		<!--- 3GBilisim SMS
		http://gateway.3gmesaj.com/BulkWebService.asmx?op=SendMany
				
		SMS Gönderme Fonksiyonu
		UserName: Bayiniz tarafındam sağlanacak kullanıcı adı
		Password: Kullanıcı şifreniz.
		CompanyCode: Bayiniz Tarafından verilen kod
		MesgBody: 160 karakter olacak şekilde oluşturulan mesaj metni
		Version: Yazılım firması tarafından en çok 15 karakter verilebilen özel kod.
		Originator Gönderici başlığı en az 3 en fazla 11 karakter kullanılabilir.Türkçe karakter kullanılamaz.
		Numbers: Mesaj gönderilecek numaralar her bir numara ülke kodunu da içeren uluslararası formatta olmalı ve numaralar arasında ayıraç olarak virgule(,) kullanılmalı.Ülke kodunun verilmemesi durumunda (905............ gibi) ülke kodu varsayılan olarak 90 kabul edilecektir. 
		SDate: Mesajın gönderilmeye başlanacağı tarihi gösterir.Formatı ddmmyyyyhhmm dir.Bu değer girilmediği durumda an itibariyle gönderim başlayacaktır.
		EDate: Mesajın gönderilme işleminin sonlandırılacağı zamandır.Bu tarihten sonar mesaj gönderme durdurulacak ve beklemeye alınan mesajlar zaman aşımı(timeout) olacaktır.
		--->
     	<!--- Yaz --->
		<cfset number_control = createobject("component","V16.objects.cfc.mobile_phone_validation")>
        <cfif len(number_control.CheckMobileNumber("#_PhoneNumber_#"))>
			<cfscript>
                 my_credit = xmlNew();
                 my_credit.xmlRoot = xmlElemNew(my_credit,"MainBody");
                 my_credit.xmlRoot.XmlChildren[1] = XmlElemNew(my_credit,"UserName");
                 my_credit.xmlRoot.XmlChildren[1].xmlText = "#_UserName_#";
                 
                 my_credit.xmlRoot.XmlChildren[2] = XmlElemNew(my_credit,"PassWord");
                 my_credit.xmlRoot.XmlChildren[2].XmlText = "#_Password_#";
                 
                 my_credit.xmlRoot.XmlChildren[3] = XmlElemNew(my_credit,"CompanyCode");
                 my_credit.xmlRoot.XmlChildren[3].xmlText = "#_ServiceCode_#";
                 
                 my_credit.xmlRoot.XmlChildren[4] = XmlElemNew(my_credit,"Type");
                 my_credit.xmlRoot.XmlChildren[4].xmlText = "1";
                 
                 my_credit.xmlRoot.XmlChildren[5] = XmlElemNew(my_credit,"Developer");
                 my_credit.xmlRoot.XmlChildren[5].xmlText = "";		 
                 
                 my_credit.xmlRoot.XmlChildren[6] = XmlElemNew(my_credit,"Originator");
                 my_credit.xmlRoot.XmlChildren[6].xmlText = "#_AlphaNumeric_#";
                 
                 my_credit.xmlRoot.XmlChildren[7] = XmlElemNew(my_credit,"Version");
                 my_credit.xmlRoot.XmlChildren[7].xmlText = "xVer.Workcube";
                 
                 my_credit.xmlRoot.XmlChildren[8] = XmlElemNew(my_credit,"Mesgbody");
                 my_credit.xmlRoot.XmlChildren[8].xmlText = "#_Message_#";
                 
                 my_credit.xmlRoot.XmlChildren[9] = XmlElemNew(my_credit,"Numbers");
                 my_credit.xmlRoot.XmlChildren[9].xmlText = "#_PhoneNumber_#";
                 
                 my_credit.xmlRoot.XmlChildren[10] = XmlElemNew(my_credit,"SDate");
                 my_credit.xmlRoot.XmlChildren[10].xmlText = "";
    
                 my_credit.xmlRoot.XmlChildren[11] = XmlElemNew(my_credit,"EDate");
                 my_credit.xmlRoot.XmlChildren[11].xmlText = "";
            </cfscript>
        
            <cfhttp url="http://newgateway.3gmesaj.net/SendSmsMany.aspx" method="Post" timeout="60"> 
                <cfhttpparam type="xml" name="data" value="#my_credit#">
            </cfhttp>
            
            <cfset Sms_Status = 0> 
            <cfif len(cfhttp.FileContent) and find( "200", cfhttp.statusCode )>   
                <cfif len(cfhttp.FileContent)>
                    <cfif cfhttp.FileContent contains 'ID'>
                        <cfset Error_Code = -1>
                        <cfset Uniqcode = ListGetAt(cfhttp.FileContent,2,':')>
                        <cfset Sms_Status = 1>
                    <cfelse>
                        <cfset Error_Code = trim(cfhttp.FileContent)>
                    </cfif>
                </cfif>
            <cfelse>
                <cfset Error_Code = 500>
            </cfif>
        <cfelse>
            <cfset Error_Code = 999>
        </cfif>
	<cfelseif get_sms_info.sms_company eq 5>
		<cfset getComponent = createObject('component', 'WEX.sitetour.hooks.sms')>
		<cfset data = {}>
		<cfset data.tel = "#_PhoneNumber_#">
		<cfset data.message = "#_Message_#">
		<cfset result = getComponent.send_sms(data)>
		<cfif len(result.FileContent) and find( "200", result.statusCode ) and IsNumeric(result.FileContent)>
			<cfset Error_Code = -1>
			<cfset Uniqcode = result.FileContent>
			<cfset Sms_Status = 1>
		<cfelse>
			<cfset Error_Code = result.ResponseHeader.Status_Code>
		</cfif>
 	</cfif>
	<!--- Sonuclar - Hata ve Donus Kodlari Tabloya Yazilir --->
    <cfquery name="get_max_sms_id" datasource="#attributes.data_source#">
        SELECT MAX(SMS_ID) SMS_ID FROM #dsn3_alias#.SMS_SEND_RECEIVE
    </cfquery>
    <cfquery name="UPD_SMS_SEND_RECEIVE" datasource="#attributes.data_source#">
        UPDATE
            #dsn3_alias#.SMS_SEND_RECEIVE
        SET
            IS_USE_WEBSERVICE = 1,
            SMS_STATUS = <cfif isDefined("Sms_Status") and Len(Sms_Status)>#Sms_Status#<cfelse>0</cfif>,
            ERROR_CODE = <cfif isDefined("Error_Code") and isNumeric(Error_Code)>#Error_Code#<cfelse>NULL</cfif>,
            UNIQCODE = <cfif isDefined("Uniqcode") and Len(Uniqcode)>'#Uniqcode#'<cfelse>NULL</cfif>
        WHERE
            SMS_ID = #get_max_sms_id.sms_id#
    </cfquery>
</cfif>
<script>
	location.href = document.referrer;
</script>