<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
<cfset directory_name = "#upload_folder#eshipment_received#dir_seperator#">

<cfif not isDefined("soap")>
    <cfobject name="soap" type="component" component="V16.e_government.cfc.eirsaliye.soap">
    <cfset soap.init()>
</cfif>
<cfif not isDefined("eshipment")>
    <cfobject name="eshipment" type="component" component="V16.e_government.cfc.eirsaliye.common">
</cfif>

<cfif isdefined('attributes.associate') and attributes.associate eq 1> <!--- belge iliskilendirmeden geliyor ise --->
    <cfset ADD_PURCHASE_MAX_ID.IDENTITYCOL = attributes.related_ship_id>
    <cfinclude template="eshipment_approval.cfm" />

    <script>
		alert('Gelen E-İrsaliye Belge ile İlişkilendirilmiştir !');
		document.location.href = '/index.cfm?fuseaction=stock.received_eshipment&event=det&receiving_detail_id=<cfoutput>#attributes.receiving_detail_id#</cfoutput>';
	</script>
	<cfabort>
<cfelse> <!--- Manuel UBL eklemeden geliyor ise --->
    <cfif not directoryexists("#directory_name#")>
        <cfdirectory action="create" directory="#directory_name#">
    </cfif>


    <cffile action = "upload" 
            fileField = "uploaded_file" 
            destination = "#directory_name#"
            nameConflict = "MakeUnique"  
            mode="777">

    <cfset file_name = "#createUUID()#.#cffile.serverfileext#">
    <cffile action="rename" source="#directory_name##cffile.serverfile#" destination="#directory_name##file_name#">	

    <cffile action="read" file="#directory_name##file_name#" variable="inv_xml_data" charset="utf-8">

    <cfset resultdata = structNew()>
    <cfset resultdata.despatches = arrayNew(1)>

    <cftry>
        <cfxml variable="xmlresult"><cfoutput>#inv_xml_data#</cfoutput></cfxml>
        
        <cfloop array="#xmlresult.DespatchAdvice#" index="child">
        
            <cfset despatch = structNew()>
                <cfset despatch.uuid = child.UUID.XmlText>
                <cfset despatch.despatchid = child.ID.XmlText>
                <cfset despatch.despatchadvicetypecode = child.Despatchadvicetypecode.XmlText>
                <cfset despatch.sendertaxid = child.despatchsupplierparty.party.partyidentification.ID.XmlText>
                <cfset despatch.receivertaxid = child.deliverycustomerparty.party.partyidentification.ID.XmlText>
                <cfset despatch.profileid = child.profileId.XmlText>
                <cfset despatch.issuedate = child.Issuedate.XmlText>
                <cfset despatch.issuetime = child.Issuetime.XmlText>
                <cfset despatch.partyname = child.despatchsupplierparty.party.partyname.name.XmlText>
            <cfset arrayAppend( resultdata.despatches, despatch )>
        </cfloop>
        <cfcatch type="any">
            <script>
                alert('XML Dosyası Okunamadı , Lütfen XML Formatını Kontrol Ediniz !');
                document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
            </script>
            <cfabort>
        </cfcatch>
    </cftry>

    <cfif isdefined("despatch.despatchid")> 
        
        <cfquery name="tax_control" datasource="#dsn#"> <!--- Vkn Kontrolü --->
            SELECT 
                TAX_NO 
            FROM 
                OUR_COMPANY 
            WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND TAX_NO = '#despatch.receivertaxid#'
        </cfquery>
        <cfif not tax_control.recordcount>
            <script>
		         alert("Eklemek İstediğiniz Belgedeki Vergi No Bulunduğunuz Sirket Vergi No ile Aynı Değil !");
				 document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
			</script>
			<cfabort>
        </cfif> 
        <cfquery name="ship_control" datasource="#dsn2#"> <!--- İrsaliye Kontrolü --->
			SELECT 
                ESHIPMENT_ID 
            FROM 
                ESHIPMENT_RECEIVING_DETAIL 
            WHERE ESHIPMENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#despatch.despatchid#"> AND SENDER_TAX_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#despatch.sendertaxid#"> 
        </cfquery>
        <cfif ship_control.recordcount>
			<script type="text/javascript">
				alert("Eklemek İstediğiniz Belge Daha Önce Eklenmiş , Lütfen Bilgileri Kontrol Ediniz !");
				document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
			</script>
			<cfabort>
        </cfif>
        <cflock name="#CREATEUUID()#" timeout="60">
            <cftransaction>
                <cfset addReceivedEshipment = eshipment.addReceivedEshipment(
                                                                                serviceresult : 'Successful',
                                                                                uuid : despatch.uuid,
                                                                                despatchid : despatch.despatchid,
                                                                                statuscode : 24,
                                                                                statusdescription : 'SİSTEME KAYDEDİLDİ',
                                                                                despatchadvicetypecode : 'SEVK',
                                                                                sendertaxid : despatch.sendertaxid,
                                                                                receivertaxid : despatch.receivertaxid,
                                                                                profileid : despatch.profileid,
                                                                                issuedate : despatch.issuedate,
                                                                                issuetime : despatch.issuetime,
                                                                                partyname : despatch.partyname,
                                                                                totalamount : 0,
                                                                                createdate : despatch.issuedate,
                                                                                direction : 'Incoming'
                    )>
                    <cffile action="rename" source="#directory_name##file_name#" destination="#directory_name##despatch.uuid#.xml">
                    <cfset updDespatchPath = eshipment.updReceivedEshipment(uuid : despatch.uuid, path : '#despatch.uuid#.xml')>
            </cftransaction>
        </cflock>
        
    </cfif>
    <script>
        document.location.href = '/index.cfm?fuseaction=stock.received_eshipment';
    </script>
</cfif>