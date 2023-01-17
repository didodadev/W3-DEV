<cfabort>
<cffile action="read" variable="dosyam" file="#upload_folder#pos#dir_seperator##IMPORT_FILE.FILE_NAME#" charset="utf-8">
<cfscript>
	function wrk_xml_read_tag(f_xml_data,f_xml_doc_name)
	{/*en disdaki xmli pars edilen deger listede tutulmuyor her sayfada baska bir degisken olabilr ve birbiri ile �akismamasi i�in*/
		xml = 1;
		xml_tag_list='';
		xml_tag_root_list='';
		'#f_xml_doc_name#' = XmlParse(f_xml_data);
		xml_tag_list = listappend(xml_tag_list,'xmlroot',';');
		while(xml lte listlen(xml_tag_list,';'))
		{
			xml_tag_root = listgetat(xml_tag_list,xml,';');
			tag_len = ArrayLen(evaluate('#f_xml_doc_name#.#xml_tag_root#.XmlChildren'));
			pre_tag_name=evaluate('#f_xml_doc_name#.#xml_tag_root#.XmlChildren').xmlname;
			for(xml_ind=1;xml_ind lte tag_len;xml_ind=xml_ind+1)
			{
				xml_tag_root_list=listappend(xml_tag_root_list,'#pre_tag_name#.XmlChildren[#xml_ind#].xmlname',';');
				xml_tag_list = listappend(xml_tag_list,'#xml_tag_root#.XmlChildren[#xml_ind#]',';');
			}
			xml = xml+1;
		}
		writeoutput(xml_tag_root_list);
		return xml_tag_list;
	}
	wrk_xml_read_tag(dosyam,'xml_doc');
</cfscript>
<cfabort>

			
			

<cfloop condition="isdefined('paper_header_#paper_count#')">

</cfloop>
