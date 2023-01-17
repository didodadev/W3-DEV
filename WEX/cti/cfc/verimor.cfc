<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Şİrketin entegrasyon bilgilerini getirir --->
    <cffunction name="getCallInformations" returntype="query" access="public">
		<cfargument name="emp_id" type="any" default="#iif(isdefined("session.ep.userid"),"session.ep.userid",DE(""))#">
		<cfargument name="comp_id" type="any" default="#iif(isdefined("session.ep.company_id"),"session.ep.company_id",DE(""))#">
        <cfquery name="getCallInformations" datasource="#dsn#">
            SELECT IS_CTI_INTEGRATED, API_KEY, IS_SMS, SMS_USERNAME, SMS_PASSWORD, SMS_COMPANY <cfif isdefined("arguments.emp_id") and len(arguments.emp_id)>, EXTENSION, CORBUS_TEL, TEL_TYPE</cfif> FROM OUR_COMPANY_INFO <cfif isdefined("arguments.emp_id") and len(arguments.emp_id)>, EMPLOYEES</cfif> WHERE OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isdefined("arguments.comp_id") and len(arguments.comp_id),"arguments.comp_id",1)#"> <cfif isdefined("arguments.emp_id") and len(arguments.emp_id)>AND EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"></cfif>
        </cfquery>
        <cfreturn getCallInformations>
    </cffunction>
    <cffunction name="getMissedCount" returntype="numeric" access="public">
        <cfargument name="key" type="any" default="">
        <cfargument name="extension" type="any" default="">
        <cfset missed_count = 0>
        <script>
            var formObjects = {};
			formObjects.api_key = "<cfoutput>#arguments.key#</cfoutput>";
			extension = "<cfoutput>#arguments.extension#</cfoutput>";

			$.ajax({
				url :'/wex.cfm/cti/cdrs',
				method: 'post',
				contentType: 'application/json; charset=utf-8',
				dataType: "json",
				data : JSON.stringify(formObjects),
				success : function(response){
                    missed_count = 0;
					for (var i = 0; i < response.cdrs.length; i++) {
						if(response.cdrs[i].result !== 'Cevaplandı' && response.cdrs[i].destination_number.includes(extension) ){
                            missed_count += 1;
                        }
					}
                    if(missed_count != 0){
                        $('#missed_count').attr("class" , "badge badgeCount").text(missed_count);
                        $('#missed_count1').attr("class" , "badge badgeCount").text(missed_count);
                    }                 
            
				}
			});
        </script>
        <cfreturn missed_count>
    </cffunction>
    
    <!--- Çağrı başlatma --->
    <cffunction name="beginCall" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="extension" type="any" default="">
        <cfargument name="destination" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="https://api.bulutsantralim.com/originate?key=#arguments.api_key#&extension=#arguments.extension#&destination=#arguments.destination#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Çağrı sonlandırma --->
    <cffunction name="hangUpCall" returntype="any" access="public">
        <cfargument name="key" type="any" default="">
        <cfargument name="uuid" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/hangup/#arguments.uuid#?key=#arguments.key#">
        </cfhttp> 
        <cfreturn result>
    </cffunction>
    <!--- Çağrıyı Sesliye alma --->
    <cffunction name="muteOff" returntype="any" access="public">
        <cfargument name="key" type="any" default="">
        <cfargument name="uuid" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/mute/#arguments.uuid#?state=off&key=#arguments.key#">
        </cfhttp> 
        <cfreturn result>
    </cffunction>
    <!--- Çağrıyı Sessize alma --->
    <cffunction name="muteOn" returntype="any" access="public">
        <cfargument name="key" type="any" default="">
        <cfargument name="uuid" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/mute/#arguments.uuid#?state=on&key=#arguments.key#">
        </cfhttp> 
        <cfreturn result>
    </cffunction>
    <!--- Rahatsız Etme Modu --->
    <cffunction name="dnd" returntype="any" access="public">
        <cfargument name="key" type="any" default="">
        <cfargument name="extension" type="any" default="">
        <cfargument name="state" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/dnd/#arguments.extension#?state=#arguments.state#&key=#arguments.key#">
        </cfhttp> 
        <cfreturn result>
    </cffunction>
    <!--- Arama Kayıtlarına Erişim --->
    <cffunction name="cdrs" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="extension" type="any" default="">
        <cfargument name="start_date" default="#DateFormat(DateAdd('d',-29,now()),'yyyy-mm-dd')#">
        <cfargument name="finish_date" default="#DateFormat(now(),'yyyy-mm-dd')#">
        <cfhttp result="result" method="GET" charset="utf-8" url="https://api.bulutsantralim.com/cdrs?key=#arguments.api_key#&caller_id_number=#arguments.extension#&start_stamp_from=#start_date# 00:00:00 UTC&start_stamp_to=#finish_date# 23:59:59 UTC&limit=100">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Ses kaydı erişimi --->
    <cffunction name="recording" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="call_uuid" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.bulutsantralim.com/recording_url">
            <cfhttpparam name="key" type="formField" value="#arguments.api_key#">
            <cfhttpparam name="call_uuid" type="formField" value="#arguments.call_uuid#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Webphone --->
    <cffunction name="webphone_iframe" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="extension" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.bulutsantralim.com/webphone_tokens">
            <cfhttpparam name="key" type="formField" value="#arguments.api_key#">
            <cfhttpparam name="extension" type="formField" value="#arguments.extension#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Dahili durumları --->
    <cffunction name="user_status" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/user_statuses?key=#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kuyruklar listesi --->
    <cffunction name="queues" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/queues?key=#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- MT (Müşteri Temsilcisi) Durumları --->
    <cffunction name="agent_status" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/queues?key=#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Ses kayıtları --->
    <cffunction name="announcements" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="http://api.bulutsantralim.com/announcements?key=#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Ses kaydı yükleme --->
    <cffunction name="announcements_upload" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="name" type="any" default="">
        <cfargument name="sounddata" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.bulutsantralim.com/announcements">
            <cfhttpparam name="key" type="formField" value="#arguments.api_key#">
            <cfhttpparam name="name" type="formField" value="#arguments.name#">
            <cfhttpparam name="sounddata" type="formField" value="#arguments.sounddata#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kişiler listesi --->
    <cffunction name="contacts" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfhttp result="result" method="get" charset="utf-8" url="http://api.bulutsantralim.com/contacts?key=#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kara liste --->
    <cffunction name="blocked_numbers" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfhttp result="result" method="get" charset="utf-8" url="http://api.bulutsantralim.com/blocked_numbers?key=#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kara listeye ekleme --->
    <cffunction name="blocked_numbers_add" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="number" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="http://api.bulutsantralim.com/blocked_numbers">
            <cfhttpparam name="key" type="formField" value="#arguments.api_key#">
            <cfhttpparam name="number" type="formField" value="#arguments.number#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kişi ekleme --->
    <cffunction name="contacts_add" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="tckn" type="any" default="">
        <cfargument name="name" type="any" default="">
        <cfargument name="surname" type="any" default="">
        <cfargument name="birthday" type="any" default="">
        <cfargument name="description" type="any" default="">
        <cfargument name="company_name" type="any" default="">
        <cfargument name="title" type="any" default="">
        <cfargument name="phone" type="any" default="">
        <cfargument name="phone1" type="any" default="">
        <cfargument name="email" type="any" default="">

        <cfhttp result="result" method="POST" charset="utf-8" url="http://api.bulutsantralim.com/contacts">
            <cfhttpparam name="key" type="formField" value="#arguments.api_key#">
            <cfhttpparam name="tckn" type="formField" value="#arguments.tckn#">
            <cfhttpparam name="name" type="formField" value="#arguments.name#">
            <cfhttpparam name="surname" type="formField" value="#arguments.surname#">
            <cfhttpparam name="birthday" type="formField" value="#arguments.birthday#">
            <cfhttpparam name="description" type="formField" value="#arguments.description#">
            <cfhttpparam name="company_name" type="formField" value="#arguments.company_name#">
            <cfhttpparam name="title" type="formField" value="#arguments.title#">
            <cfhttpparam name="phone" type="formField" value="#arguments.phone#">
            <cfhttpparam name="phone1" type="formField" value="#arguments.phone1#">
            <cfhttpparam name="email" type="formField" value="#arguments.email#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kişi Sil --->
    <cffunction name="contacts_del" returntype="any" access="public">
        <cfargument name="api_key" type="any" default="">
        <cfargument name="id" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="http://api.bulutsantralim.com/contacts/#arguments.id#">
            <cfhttpparam name="key" type="formField" value="#arguments.api_key#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="send_sms" returntype="any" access="public">
		<cfargument name="comp_id" type="any" default="">
        <cfargument name="tel" type="any" default="">
        <cfargument name="message" type="any" default="">
        <cfargument name="send_at" type="any" default=""><!--- Gönderim zamanı --->
        <cfargument name="valid_for" type="any" default=""><!--- Geçerlilik süresi --->
        <cfargument name="source_addr" type="any" default=""><!--- Başlık boş ise sistemde kayıtlı ilk başlığı getirir --->
        <cfargument name="custom_id" type="any" default=""><!--- Bu kampanyaya verebileceğiniz özel ID’dir. API’nin kampanyaya döndüreceği ID’yi kullanmayıp kendi vereceğiniz ID ile mesajların sonucu takip etmek isterseniz kullanılır --->
        <cfset getCallInformations = getCallInformations(comp_id:'#iif(isdefined("arguments.comp_id") and len(arguments.comp_id),"arguments.comp_id",DE(""))#')>
        <cfhttp result="result" method="get" charset="utf-8" url="http://sms.verimor.com.tr/v2/send?username=#getCallInformations.SMS_USERNAME#&password=#getCallInformations.SMS_PASSWORD#&msg=#arguments.message#&dest=#arguments.tel#&datacoding=1#iif(len(arguments.valid_for),DE('&valid_for=#arguments.valid_for#'),DE(''))##iif(len(arguments.custom_id),DE('&custom_id=#arguments.custom_id#'),DE(''))##iif(len(arguments.source_addr),DE('&source_addr=#arguments.source_addr#'),DE(''))##iif(len(arguments.send_at),DE('&send_at=#arguments.send_at#'),DE(''))#">
        </cfhttp> 
        <cfreturn result>
    </cffunction>
</cfcomponent>