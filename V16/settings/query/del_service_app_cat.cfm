<cfquery name="control_level" datasource="#dsn3#">
	SELECT 
    	TOP 1 *
     FROM 
     	SERVICE_APPCAT_SUB ORTA 
      	  	JOIN  
        SERVICE_APPCAT UST
          	ON 
         ORTA.SERVICECAT_ID=UST.SERVICECAT_ID
		 	AND 
         UST.SERVICECAT_ID= #SERVICECAT_ID#
</cfquery>
<cfif not control_level.recordcount>
    <cfquery name="DELSERVICECAT" datasource="#dsn3#">
        DELETE FROM SERVICE_APPCAT WHERE SERVICECAT_ID=#SERVICECAT_ID#
    </cfquery>
<cfelse>
	Silmek istediğiniz kategori üst kategori olarak kullanılıyor!
</cfif> 
<cflocation url="#request.self#?fuseaction=settings.form_add_service_app_cat" addtoken="no">
