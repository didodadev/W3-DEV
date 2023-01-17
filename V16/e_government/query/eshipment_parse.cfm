<!--- Gelen irsaliyelerin çekilip tabloya yazılması --->
<cfset directory_name = getDirectoryFromPath(getBaseTemplatePath()) & "documents/eshipment_received">
<cfif not isDefined("soap")>
    <cfobject name="soap" type="component" component="V16.e_government.cfc.eirsaliye.soap">
    <cfset soap.init()>
</cfif>
<cfif not isDefined("eshipment")>
    <cfobject name="eshipment" type="component" component="V16.e_government.cfc.eirsaliye.common">
</cfif>
<cfset received_despatches = soap.GetAvailableDesptaches()>

<cfif received_despatches.serviceresult eq "Successful">
    <cfif StructKeyExists(received_despatches, "despatches") and arrayLen(received_despatches.despatches) gt 0>
        <cfloop array="#received_despatches.despatches#" index="despatch">
            <cfif despatch.serviceresult eq "Error">
                <cfset addReceivedEshipment = eshipment.addReceivedEshipment(
                    serviceresult : despatch.serviceresult,
                    serviceresultdescription : despatch.serviceresultdescription,
                    errorcode : despatch.errorcode
                )>
            <cfelse>
                <cfset eshipmentControl = eshipment.GET_ESHIPMENT_DETAIL(uuid : despatch.uuid)>
                <cfif not eshipmentControl.recordcount>
                    <cfset addReceivedEshipment = eshipment.addReceivedEshipment(
                        serviceresult : despatch.serviceresult,
                        serviceresultdescription : despatch.serviceresultdescription,
                        uuid : despatch.uuid,
                        despatchid : despatch.despatchid,
                        statuscode : despatch.statuscode,
                        statusdescription : despatch.statusdescription,
                        despatchadvicetypecode : despatch.despatchadvicetypecode,
                        sendertaxid : despatch.sendertaxid,
                        receivertaxid : despatch.receivertaxid,
                        profileid : despatch.profileid,
                        issuedate : despatch.issuedate,
                        issuetime : despatch.issuetime,
                        partyname : despatch.partyname,
                        receiverpostboxname : despatch.receiverpostboxname,
                        senderpostboxname : despatch.senderpostboxname,
                        totalamount : despatch.totalamount,
                        createdate : despatch.createdate,
                        direction : despatch.direction
                    )>
                </cfif>
                <cfif not fileExists("#directory_name#/#despatch.uuid#.xml")>
                    <cfset getDespatch = soap.GetDespatch(
                        value : despatch.uuid,
                        direction : 'Incoming'
                    )>
                    <cfdump var="#getDespatch#">
                    <cfif StructKeyExists(getDespatch, "DESPATCHES") and ArrayLen(getDespatch.DESPATCHES)>
                        <cfset temp_base64 = getDespatch.despatches[1].returnvalue>
                        <cffile action="write" file="#directory_name#/#despatch.uuid#.xml" output="#toString(tobinary(temp_base64))#" charset="utf-8" />
                        <cfset updDespatchPath = eshipment.updReceivedEshipment(uuid : despatch.uuid, path : '#despatch.uuid#.xml')>
                    </cfif>
                </cfif>
            </cfif>
        </cfloop>
    </cfif>
</cfif>
<!--- Gelen irsaliyelerin çekilip tabloya yazılması --->