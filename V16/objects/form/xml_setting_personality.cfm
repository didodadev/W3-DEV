<!--- BOX LARIN AÇIK-KAPALI GELMESİ İLE İLGİLİ XML py--->
<cfif not directoryexists("#upload_folder#personal_settings")>
    <cfdirectory action="create" directory="#upload_folder#personal_settings">
</cfif>
<cfif FileExists("#upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml")>
<cfset myXmlDoc= XmlParse("#upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml")>
<cfset selectedElements = XmlSearch(myXmlDoc, "/Employee/XmlAction/")>
<cfoutput>   
   <cfxml variable="MyXMLDocc">
       <?xml version='1.0' encoding='UTF-8'?>
       <Employee>
		   <cfset is_upd_ = 0>
           <cfloop index="aa" from="1" to="#ArrayLen(selectedElements)#">
               <cfset fuseaction_ = selectedElements[aa].XmlChildren[1].XmlText>
               <cfset div_id_ = selectedElements[aa].XmlChildren[2].XmlText>
               <cfset action_name_ = selectedElements[aa].XmlChildren[3].XmlText>
               <cfset action_value_ = selectedElements[aa].XmlChildren[4].XmlText>
               <cfif fuseaction_ eq attributes.fuse and div_id_ eq attributes.bid and action_name_ eq attributes.action_name><XmlAction>
                        <Fuseaction>#fuseaction_#</Fuseaction>
                        <divId>#div_id_#</divId>
                        <action_name>#action_name_#</action_name>
                        <action_value>#attributes.action_value#</action_value>
                   </XmlAction>
                   <cfset is_upd_ = 1>
                <cfelse><XmlAction>
                        <Fuseaction>#fuseaction_#</Fuseaction>
                        <divId>#div_id_#</divId>
                        <action_name>#action_name_#</action_name>
                        <action_value>#action_value_#</action_value>
                   </XmlAction>
                </cfif>
           </cfloop>
           <cfif is_upd_ eq 0><XmlAction>
                    <Fuseaction>#attributes.fuse#</Fuseaction>
                    <divId>#attributes.bid#</divId>
                    <action_name>#attributes.action_name#</action_name>
                    <action_value>#attributes.action_value#</action_value>
                </XmlAction>
           </cfif></Employee>
   </cfxml>
</cfoutput>
<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#xml_emp_#session.ep.userid#.xml" output="#toString(MyXMLDocc)#" charset="utf-8">
<cfelse>
	<cfoutput>
       <cfxml variable="MyXMLDoc">
           <?xml version='1.0' encoding='utf-8'?>
           <Employee>
               <XmlAction>
                    <Fuseaction>#attributes.fuse#</Fuseaction>
                    <divId>#attributes.bid#</divId>
                    <action_name>#attributes.action_name#</action_name>
                    <action_value>#attributes.action_value#</action_value>
               </XmlAction>
           </Employee>
       </cfxml>
    </cfoutput>
    <cffile action="write" file="#upload_folder#personal_settings#dir_seperator#xml_emp_#session.ep.userid#.xml" output="#toString(MyXMLDoc)#" charset="utf-8">
</cfif>
