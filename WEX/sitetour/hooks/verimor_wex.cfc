<cfcomponent>
    <!--- Çağrı Başlatma --->
    <cffunction name="beginCall" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.destination") and len(arguments.data.destination) and  isDefined("arguments.data.extension") and len(arguments.data.extension) and  isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.beginCall(arguments.data.api_key, arguments.data.extension, arguments.data.destination)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Rahatsız Etme Modu --->
    <cffunction name="dnd" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key) and  isDefined("arguments.data.extension") and len(arguments.data.extension) and  isDefined("arguments.data.state") and len(arguments.data.state)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.dnd(arguments.data.api_key, arguments.data.extension, arguments.data.state)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Arama Kayıtları --->
    <cffunction name="cdrs" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.cdrs(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Ses kaydı erişimi --->
    <cffunction name="recording" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.recording(arguments.data.api_key,arguments.data.call_uuid)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Webphone --->
    <cffunction name="webphone_iframe" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.webphone_iframe(arguments.data.api_key,arguments.data.extension)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Dahili durumları --->
    <cffunction name="user_status" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.user_status(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Kuyruklar listesi --->
    <cffunction name="queues" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.queues(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- MT (Müşteri Temsilcisi) Durumları --->
    <cffunction name="agent_status" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.agent_status(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Ses kayıtları --->
    <cffunction name="announcements" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.announcements(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Ses kaydı yükleme --->
    <cffunction name="announcements_upload" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.announcements_upload(arguments.data.api_key, arguments.data.name, arguments.data.sounddata)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Kişiler listesi --->
    <cffunction name="contacts" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.contacts(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Kişi ekle --->
    <cffunction name="contacts_add" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.contacts_add(arguments.data.api_key,arguments.data.tckn,arguments.data.name,arguments.data.surname,arguments.data.birthday,arguments.data.description,arguments.data.company_name,arguments.data.title,arguments.data.phone,arguments.data.phone1,arguments.data.email)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
     <!--- Kişi sil --->
     <cffunction name="contacts_del" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.contacts_del(arguments.data.api_key,arguments.data.id)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Kara liste --->
    <cffunction name="blocked_numbers" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.blocked_numbers(arguments.data.api_key)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <!--- Kara listeye ekleme --->
    <cffunction name="blocked_numbers_add" access="public">
        <cfargument name="data">
        <cfif isDefined("arguments.data.api_key") and len(arguments.data.api_key)>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.blocked_numbers_add(arguments.data.api_key,arguments.data.number)>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
    <cffunction name="report_event" access="remote">
        <cfdump label="content" var="#getHttpRequestData().content#" format="html" output="c:\arg.html" >
        <cfdump label="url" var="#form#" format="html" output="c:\arg.html" >
        <cfset wsPublish("webphone",{ACTION: "gelen çağrı", EXTENSION: "#form.DIALED_USER#", CALLER_ID_NUMBER: "#form.CALLER_ID_NUMBER#"})/>
        <cfreturn "No">
    </cffunction>
</cfcomponent>