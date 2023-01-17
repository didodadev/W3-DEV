<cfcomponent>
    <!--- Mail raporu --->
    <cffunction name="report" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.report(arguments.data.end_date,arguments.data.start_date,arguments.data.aggregated_by)>
        <cfreturn uuid>
    </cffunction> 
    <!--- Mevcut templateleri getirir --->
    <cffunction name="templates" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.templates(arguments.data.key)>
        <cfreturn uuid>
    </cffunction>   
    <!--- Template oluşturur ---> 
    <cffunction name="create_template" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.create_template(arguments.data)>
        <cfreturn uuid>
    </cffunction>  
    <!--- Template id'ye göre Template'i düzenler --->
    <cffunction name="versions" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.versions(arguments.data.template_id,arguments.data.data)>
        <cfreturn uuid>
    </cffunction>  
    <!--- Liste oluşturur --->
    <cffunction name="create_list" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.create_list(arguments.data.name)>
        <cfreturn uuid>
    </cffunction> 
    <!--- Alıcı oluşturur --->
    <cffunction name="recipients" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.recipients(arguments.data)>
        <cfreturn uuid>
    </cffunction> 
    <!--- Alıcıları listeye ekle --->
    <cffunction name="lists" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.lists(arguments.data.list_id,arguments.data.recipient_list)>
        <cfreturn uuid>
    </cffunction> 
    <!--- Kampanya oluştur --->
    <cffunction name="campaigns" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.campaigns(arguments.data)>
        <cfreturn uuid>
    </cffunction> 
    <!--- Kampanyayı listeye gönderir --->
    <cffunction name="send_camp" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.send_camp(arguments.data.campaign_id)>
        <cfreturn uuid>
    </cffunction> 
    <!---  Kampanyayı sil --->
    <cffunction name="del_camp" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.del_camp(arguments.data.campaign_id)>
        <cfreturn uuid>
    </cffunction> 
    <!--- Hazır şablon gönderme --->
    <cffunction name="send_mail" access="public">
        <cfargument name="data">
        <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
        <cfset uuid = datalayer.send_mail(arguments.data)>
        <cfreturn uuid>
    </cffunction> 
    <!--- İçerikleri mail gönderme --->
    <cffunction name="send_mail_content" access="public">
            <cfargument name="data">
            <cfobject type="component" name="datalayer" component="WEX.emailservices.cfc.sendgrid">
            <cfset uuid = datalayer.send_mail_content(arguments.data)>
            <cfreturn uuid>
    </cffunction>
</cfcomponent>
