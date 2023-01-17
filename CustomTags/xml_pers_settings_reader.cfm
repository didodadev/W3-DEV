<cfif isdefined("session.ep.userid") and FileExists("#caller.upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml")>
    <cftry>
        <cfscript>
            xml_file_size = GetFileInfo("#caller.upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml").size/1024/1024;
            if(xml_file_size gt 5)
                dosya_sil = 1;
        </cfscript>
        <cfif isdefined("dosya_sil") and dosya_sil eq 1>
            <cffile action="delete" file="#caller.upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml">
        </cfif>
    <cfcatch></cfcatch>
    </cftry>
	<cfscript>
		myXmlDoc= XmlParse("#caller.upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml");
		selectedElements = XmlSearch(myXmlDoc, "/Employee/XmlAction/");
		for (i = 1; i LTE ArrayLen(selectedElements); i = i + 1)
		{
			if(selectedElements[i].XmlChildren[1].XmlText == caller.attributes.fuseaction)
			{	
				xml_div_id_ = selectedElements[i].XmlChildren[2].XmlText;
				xml_attr_ = selectedElements[i].XmlChildren[3].XmlText;
				xml_value_ = selectedElements[i].XmlChildren[4].XmlText;
				'caller.xml_#xml_attr_#_#xml_div_id_#' = xml_value_;
			}
		}
	</cfscript>
</cfif>
