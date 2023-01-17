/*
	Author : Uğur Hamurpet
	Date : 27/05/2020
	Desc : This component manages the application error. It makes a messages by error codes, send error mails, and create buglog request.
	methods : {
		getAdminMail : get admin mail adress,
		setError : set error message by the error code,
		getErrorDetail : get error message by the error code,
		sendBuglog : send buglog request,
		sendMail : send mail to admin mail account
	}
*/

component output = "true" displayname="Manage errors"  {

	property name = "exception" type = "struct" reqired = "true";
	property name = "attr" type = "any" default = "";
	property name = "settings" type = "struct" reqired = "true";
	property name = "errorDetail" type = "struct";

	systemParam = application.systemParam.systemParam();
	dateformat_style = ( isdefined("session.ep.dateformat_style") and len(session.ep.dateformat_style) ) ? session.ep.dateformat_style : 'dd/mm/yyyy';
	validate_style = ( dateformat_style eq 'dd/mm/yyyy' ) ? 'eurodate' : 'date';
	timeformat_style = ( isdefined("session.ep.timeformat_style") and len(session.ep.timeformat_style) ) ? session.ep.timeformat_style : 'HH:MM';

	public any function init( any exp, struct attr ) {

		this.exception = exp;
		this.attr = attr;

		this.settings = {
			mail : {
				admin_mail : this.getAdminMail(),
				workcube_server_mail : isdefined("systemParam.server_detail") ? listfirst(systemParam.server_detail) : "",
				workcube_server_name : isdefined("systemParam.server_detail") ? listlast(systemParam.server_detail) : ""
			},
			error : {
				application : { critical : true, mail : true, buglog : true, log : true },
				database : { critical : true, mail : true, buglog : true, log : true  },
				security : { critical : true, mail : true, buglog : true, log : true },
				object : { critical : false, mail : true, buglog : true, log : true },
				missingInclude : { critical : true, mail : true, buglog : true, log : true },
				template : { critical : true, mail : true, buglog : true, log : true },
				expression : { critical : true, mail : true, buglog : true, log : true },
				any : { critical : false, mail : true, buglog : true, log : true }
			}
		};

		return this;

	}

	public string function getAdminMail() {
		
		dataTable = new Query(datasource = systemParam.dsn, sql = "SELECT ADMIN_MAIL FROM OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL").execute().getResult();
		return dataTable.recordcount ? dataTable.ADMIN_MAIL[1] : '';

	}

	public void function setError(){

		if( StructKeyExists(this.settings.error, this.exception.Type) ){
			
			this.errorDetail = {
				error : {
					settings : this.settings.error[this.exception.Type],
					code : "",
					dumping : this.exception
				}
			};

			errorMessage = structKeyExists(this.exception,"Cause") ? this.exception.Cause.Message : this.exception.Message;
			errorDetail = structKeyExists(this.exception,"Cause") ? this.exception.Cause.Detail : this.exception.Detail;

			if( errorMessage contains 'for CFSQLTYPE' or errorMessage contains 'for CFSQLTYPE' ) this.errorDetail.error.code = "wrkE_8080"; //Hatalı veri tipi
			else if( errorMessage contains 'Error Executing Database Query' ){ //Eksik tablo ve kolon kaynaklı hatalar
				if( errorDetail contains 'Invalid object name' ) this.errorDetail.error.code = "wrkE_8180";
				else if( errorDetail contains 'Invalid column name') this.errorDetail.error.code = "wrkE_8180_1";
			}
			else if( errorMessage contains 'Your connection was terminated' or errorMessage contains 'Connection reset by peer: socket write error' ) this.errorDetail.error.code = "wrkE_8181"; //Veritabanı erişimiyle ilgili sorun oluştu
			else if( errorMessage contains 'Variable' and errorMessage contains 'is undefined' ) this.errorDetail.error.code = "wrkE_8280"; //Tanımlı olmayan bir değişken kullanılmış
			else if( errorMessage contains 'Could not find the included template' ) this.errorDetail.error.code = "wrkE_8280_1"; //İnclude işlemi hatası
			else if( errorMessage contains 'Fuseaction or Module not found' ) this.errorDetail.error.code = "wrkE_2347"; //Fuseaction eksiktir ya da modül yoktur.

			/* if( errorMessage contains 'undefined in a CFML structure referenced as part of an expression' ) this.errorDetail.error.code = "wrkE_2347";//Fuseaction eksiktir ya da modül yoktur.
			else if( errorMessage contains 'Element CIRCUITS is undefined in FUSEBOX' ) this.errorDetail.error.code = "wrkE_136"; //Modül adı Fusebox'a hatalı atanmıştır
			else if( errorMessage contains 'is undefined in ATTRIBUTES' or errorMessage contains 'is undefined in FORM' or errorMessage contains 'is undefined in URL' ) this.errorDetail.error.code = "wrkE_2348"; //Eksik Parametre Tanımı
			*/

			getErrorDetail =  len( this.errorDetail.error.code ) ? getErrorDetail( this.errorDetail.error.code ) : { status : false };

			if( getErrorDetail.status ){
				this.errorDetail.message.status = true;
				this.errorDetail.message.devMessage = getErrorDetail.message;
				this.errorDetail.message.devDetail = getErrorDetail.detail;
				this.errorDetail.message.devAdvice = getErrorDetail.advice;
				this.errorDetail.message.option = getErrorDetail.option;
			}else this.errorDetail.message.status = false;

			if( this.errorDetail.error.settings.buglog ){//Buglog kaydı gönderilsin mi?
				if( isDefined("application.bugLog") and systemParam.bugLog.bugLogAutoNotify ){
					this.errorDetail.message.buglogMessage = (sendBuglog()) ? "Buglog kaydi olusturuldu" : "Buglog kaydı olusturulamadi";
				}else this.errorDetail.message.buglogMessage = "Buglog ayarlari kapali";
			}else this.errorDetail.message.buglogMessage = "Buglog kaydi olusturulmadi";

			if( this.errorDetail.error.settings.mail ){//Admine mail gönderilsin mi?
				this.errorDetail.message.mailMessage = (sendMail()) ? "Sistem yöneticinize hata maili gonderildi" : "Sistem yöneticinize hata maili gonderilemedi";
			}else this.errorDetail.message.mailMessage = "Sistem yöneticinize hata maili gonderilmedi";

			if( this.errorDetail.error.settings.log ){//Sistem log dosyasına eklensin mi?
				this.errorDetail.message.logMessage = (addLog()) ? "Sistem log kaydı olusturuldu" : "Sistem log kaydı olusturulmadı";
			}else this.errorDetail.message.logMessage = "Sistem log kaydı olusturulamadi";

			request.self = application.systemParam.systemParam().request.self;

			errorDetail = this.errorDetail;

			include '../error_manager.cfm';

		}
		
	}
	
	private struct function getErrorDetail( string errorCode ) {
		
		/* 
		Error Mesajları burada gruplanır 
			-- Hata sebebi, tavsiyeler, ve hata ile ilgili linkler
		*/
		errorResponse = StructNew();
		errorResponse.status = true;

		switch( errorCode ){
			case "wrkE_2347":
				savecontent variable = "detail" {
					WriteOutput(
						"Bu hatayla genellikle fuseaction yanlış olduğunda karşılaşılır.
						<br>Modül adı ve sayfa adı bir nokta ile bağlanarak fuseaction'ı oluşturur : modul_adi.sayfa_adi"
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"Fuseaction yanlış gönderilmişse tıkladığınız bağlantı kodunu düzenlemeyi deneyebilirsiniz.
						<br>Eğer fuseaction değerinizin doğru olduğunu düşünüyorsanız DevTools > Wo içerisinden sisteminizde mevcut olup olmadığını ve doğruluğunu kontrol edebilirsiniz."
					);
				};
				errorResponse.message = "Modül adı ya da Fuseaction hatalı!";
				errorResponse.detail = detail;
				errorResponse.advice = {
					text : advice
				};
				errorResponse.option = {
					runWro : false
				};
			break;
			case "wrkE_8080":
				savecontent variable = "detail" {
					WriteOutput(
						"Bu hata genellikle zorunlu form - url parametreleri gönderilmediğinde ya da hatalı veri tipi gönderildiğinde oluşur.
						<br>Sorgu oluşturulurken parametre değeri ve tipini atamak için cfqueryparam etiketi kullanılır.
						<br>cfqueryparam etiketinde value parametresi cfsqltype parametresinde tanımlanan veri tipinde değilse bu hatayla karşılaşılır.
						<br>Örneğin value = 'wrk' cfsqltype = 'cf_sql_integer' : Bu durumda hatalı veri tipi gönderildiğinden hatalı veri tipi hatasıyla karşılaşırsınız."
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"Url'den ya da formdan eksik - hatalı veri gönderilip gönderilmediğini kontrol edin!
						<br>Sorgu içerisinde parametre ataması yaparken; hata veren satırda, cfqueryparam etiketinde, value parametresinin cfsqltype parametresinde istenilen tipte gönderildiğinden emin olun.
						<br> Muhtemelen integer ya da float tipte veri tipi istenirken, değer string tipinde gönderilmiştir!"
					);
				};
				errorResponse.message = "Hatalı veri tipi!";
				errorResponse.detail = "#detail#";
				errorResponse.advice = {
					text : "#advice#"
				};
				errorResponse.option = {
					runWro : false
				};
			break;
			case "wrkE_8180":
				savecontent variable = "detail" {
					WriteOutput(
						"Bu hata sorgunuzda hatalı tablo ismi kullanıldığında ya da veritabanınızda tablo eksik olduğunda oluşur."
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"Sorgunuzda tablo adlarını doğru olarak yazdığınızdan emin olun.
						<br>Sorguda kullanılan tabloların veritabanınızda bulunup bulunmadığını kontrol edin. Eksik ya da hatalı tablolar varsa tamamlayın."
					);
				};
				errorResponse.message = "Hatalı ya da eksik tablo!";
				errorResponse.detail = "#detail#";
				errorResponse.advice = {
					text : "#advice#"
				};
				errorResponse.option = {
					runWro : true
				};
			break;
			case "wrkE_8180_1":
				savecontent variable = "detail" {
					WriteOutput(
						"Bu hata sorgunuzda hatalı kolon ismi kullanıldığında ya da tablonuzda bazı kolonlar eksik olduğunda oluşur."
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"Sorgunuzda kolon adlarını doğru olarak yazdığınızdan emin olun.
						<br>Sorguda kullanılan kolonların veritabanı tablonuzda bulunup bulunmadığını kontrol edin. Eksik ya da hatalı kolonlar varsa tamamlayın."
					);
				};
				errorResponse.message = "Hatalı ya da eksik tablo kolonu!";
				errorResponse.detail = "#detail#";
				errorResponse.advice = {
					text : "#advice#"
				};
				errorResponse.option = {
					runWro : true
				};
			break;
			case "wrkE_8181":
				savecontent variable = "detail" {
					WriteOutput(
						"
						Bu hata veritabanı bağlantısının yapılamadığı durumlarda oluşur.
						<br>Ağınızda veritabanı erişimini engelleyen güvenlik duvarı ya da VPN olabilir.
						<br>Uygulama sunucunuzda CF datasource tanımlarınız hatalı ya da kullanıcı bilgileri değişmiş olabilir.
						<br>Veritabanı sunucunuz kapalı olabilir ya da isteklere cevap vermiyordur."
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"Veritabanına erişiminizi engelleyebilecek VPN varsa devre dışı bırakın. Güvenlik duvarı ayarlarınızı kontrol edin.
						<br>Uygulama sunucunuzda CF Datasource bilgilerinizin doğru olduğundan emin olun.
						<br>Veritabanı sunucunuzun açık olduğunu doğrulayın, isteklere yanıt verip vermediğini test edin."
					);
				};
				errorResponse.message = "Veritabanı bağlantı hatası!";
				errorResponse.detail = "#detail#";
				errorResponse.advice = {
					text : "#advice#"
				};
				errorResponse.option = {
					runWro : false
				};
			break;
			case "wrkE_8280":
				savecontent variable = "detail" {
					WriteOutput(
						"Bu hata tanımsız bir değişken adı kullanıldığında oluşur."
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"Değişkenin tanımlı olup olmadığını kontrol edin.
						<br>Değişken adının doğru kullanıldığında emin olun."
					);
				};
				errorResponse.message = "Tanımsız değisken adı!";
				errorResponse.detail = "#detail#";
				errorResponse.advice = {
					text : "#advice#"
				};
				errorResponse.option = {
					runWro : false
				};
			break;
			case "wrkE_8280_1":
				savecontent variable = "detail" {
					WriteOutput(
						"Bu hata genellikle sayfaya dahil edilmek istenen dosyanın ilgili dizinde bulunmadığı durumlarda oluşur."
					);
				};
				savecontent variable = "advice" {
					WriteOutput(
						"
						Dahil edilecek dosyanın dizin bilgisinin doğru olarak yazıldığından emin olun.
						<br>Dahil edilmek istenen dosyanın mevcut dizinde bulunup bulunmadığını kontrol edin."
					);
				};
				errorResponse.message = "Dosya sayfaya dahil edilemedi!";
				errorResponse.detail = "#detail#";
				errorResponse.advice = {
					text : "#advice#"
				};
				errorResponse.option = {
					runWro : false
				};
			break;
		
			default:
				errorResponse.status = false;
			break;
		}

		return errorResponse;
	}

	private boolean function sendBuglog() {
		
		try {
			application.bugLog.notifyService(
				message = structKeyExists(this.exception,"Cause") ? this.exception.Cause.Message : this.exception.Message, 
				extraInfo = structKeyExists(this.exception,"Cause") ? this.exception.Cause.Detail : this.exception.Detail,
				exception = this.exception
			);
			return true;
		}
		catch(type variable) {
			return false;
		}

	}

	private boolean function sendMail() {
		
		try {

			if( len( this.settings.mail.admin_mail ) and Len( this.settings.mail.workcube_server_name ) and Len( this.settings.mail.workcube_server_mail ) ){

				savecontent variable = "error_mail_info" { writeDump( this.errorDetail.error.dumping ); };

				savecontent variable = "error_mail" {
					attributes = this.attr;
					attributes.error_mail_info = error_mail_info;
					Exception = this.errorDetail.error.dumping;
					workcube_version = systemParam.workcube_version;
					include '../CustomTags/get_lang_set_main.cfm';
					include '../error_mail.cfm'; 
				}; 
				
				mailService = new mail(
					to : this.settings.mail.admin_mail,
					from : "#this.settings.mail.workcube_server_name#<#this.settings.mail.workcube_server_mail#>",
					subject : "#(this.errorDetail.message.status) ? this.errorDetail.message.devMessage : 'Bir hata bildirimi aldınız'#",
					body : "#error_mail#",
					type : "HTML"
				);
				
				mailService.send();

				return true;

			}else return false;

		}
		catch(type variable) {
			return false;
		} 

	}

	private boolean function addlog() {
		
		try {

			dumping = structKeyExists(this.errorDetail.error.dumping, "Cause") ? this.errorDetail.error.dumping.Cause : this.errorDetail.error.dumping;
			dumpingTagContext = structKeyExists(dumping, "RootCause") ? dumping.RootCause.TagContext : dumping.TagContext;

			writeLog(
				type = "error", 
				file = "workcube_errors",
				text = "Type: #this.exception.Type# - Description: #structKeyExists(this.exception,"Cause") ? this.exception.Cause.Message : this.exception.Message# - File: #dumpingTagContext[1].template#:#dumpingTagContext[1].line#"
			);

			return true;

		}
		catch(type variable) {
			return false;
		} 

	}
	
	
	

}