<cfobject name="irsoap" type="component" component="V16.e_government.cfc.eirsaliye.soap">
<cfobject name="common" type="component" component="V16.e_government.cfc.eirsaliye.common">
<cfobject name="mapper" type="component" component="V16.e_government.cfc.eirsaliye.mapper">
<cfobject name="javaziphelper" type="component" component="cfc.javaziphelper">

<cfset irsoap.init()>
<cfxml variable="xmlx"><cfoutput>#toString(javaziphelper.DecompressFirstEntry(toBinary(irsoap.GetEDespatchCustomerFullList().compressedfile)))#</cfoutput></cfxml>

<cfset common.truncate_eshipment_alias()>
<cfloop array="#xmlx.UserFullList.XmlChildren#" index="child">
    <cfset common.add_eshipment_alias( argumentCollection = mapper.map_eshipment_alias( child ) )>
</cfloop>
<cfset common.fill_eshipment_to_company()>