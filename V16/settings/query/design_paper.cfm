<!--- Design Paper Save XML Document, formdaki verileri xml olarak documents/settings altinda kaydeder --->
<cfif isDefined("attributes.design_id") and Len(attributes.design_id)>
	<cfquery name="get_old_file" datasource="#dsn3#">
		SELECT TEMPLATE_FILE,IMAGE_FILE,IMAGE_FILE_SERVER_ID FROM SETUP_PRINT_FILES WHERE FORM_ID = #attributes.design_id#
	</cfquery>
	
	<cfif isdefined("attributes.include_template") and len(attributes.include_template)>
		<cfif len(get_old_file.IMAGE_FILE)>
			<cftry>
				<cf_del_server_file output_file="settings/#get_old_file.IMAGE_FILE#" output_server="#get_old_file.IMAGE_FILE_SERVER_ID#">
			<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>
		<cftry>
            <cffile action = "upload" 
                filefield = "include_template" 
                destination = "#upload_folder#settings#dir_seperator#" 
                nameconflict = "MakeUnique" 
                mode="777">
			<cfcatch type="Any">
			<cfset error=1>
				<script type="text/javascript">
					alert("1.<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##file_name#.#cffile.serverfileext#">
	</cfif>
	
	
	<cfif len(get_old_file.template_file)>
		<cftry>
			<cffile action="delete" file="#upload_folder#settings\#get_old_file.template_file#">
		<cfcatch type="any"></cfcatch>
		</cftry>
	</cfif>
	<cfif isDefined("attributes.is_delete") and Len(attributes.is_delete)>
		<cfquery name="del_print_design" datasource="#dsn3#">
			DELETE FROM SETUP_PRINT_FILES WHERE FORM_ID = #attributes.design_id#
		</cfquery>
		<cfif len(get_old_file.IMAGE_FILE)>
			<cffile action="delete" file="#upload_folder#settings\#get_old_file.IMAGE_FILE#">
		</cfif>
		<cflocation addtoken="no" url="#request.self#?fuseaction=settings.list_design_paper">
		<cfabort>
	</cfif>
</cfif>

<cfsetting showdebugoutput="no">
<cfset FormType_ = "Design_paper">
<cfset FormDate_ = DateFormat(now(),dateformat_style)>
<cflock timeout="100">
	<cftransaction>
		<cfsetting enablecfoutputonly="yes" requesttimeout="3600">
		<cfprocessingdirective suppresswhitespace="Yes">
			<cfscript>
				FormFieldList = ListSort(form.fieldnames,'text','asc',',');
				DimensionList = "Width,Height,LeftMargin,TopMargin,Bold,Italic,Underline,JustifyLeft,JustifyCenter,JustifyRight,FontType,FontSize";
				
				// SayiList_ Liste elemanini bos set ediyoruz
				for(ff=1;ff lte ListLen(FormFieldList);ff = ff+1)
					{
					if(ListContainsNoCase(ListGetAt(FormFieldList,ff),'Check','_'))
						'SayiList_#ListFirst(ListGetAt(FormFieldList,ff),'_')#' = "";
					}
				
				// SayiList_ Liste elemanini dolduruyoruz
				for(gg = 1; gg lte ListLen(FormFieldList);gg=gg+1)
				{
					FormName = ListGetAt(FormFieldList,gg);
					FormValue = Evaluate(FormName);

					if(ListContainsNoCase(FormName,'Check','_'))
						'SayiList_#ListFirst(FormName,'_')#' = ListAppend(Evaluate('SayiList_#listfirst(FormName,'_')#'),ListLast(FormName,'_'),',');
				}

				xArtir = 1;
				yArtir = 1;
				zArtir = 1;	
				xml_top = 0;	
				xml_middle = 0;
				xml_bottom = 0;			
				
				MyXmlDoc = XmlNew();
				MyXmlDoc.xmlRoot = XmlElemNew(MyXmlDoc,"DesignPaper");

				for(xlist = 1; xlist lte ListLen(FormFieldList); xlist=xlist +1)
				{
					FormName = ListGetAt(FormFieldList,xlist);
					FormValue = Evaluate(FormName);
					
					// x,y,z disinda kalan degerler (sayfa genel ozellikleri)
					if(not (ListContainsNoCase(FormName,'_')))
						MyXmlDoc.xmlRoot.XmlAttributes[FormName] = FormValue;
					
					// x degerleri (Top)
					if(isDefined("SayiList_x") and ListFirst(FormName,'_') is 'x' and ListFind(Evaluate('SayiList_x'),ListLast(FormName,'_'),','))
					{
						xml_top = 1;					
						if(xArtir eq 1)
							MyXmlDoc.xmlRoot.XmlChildren[xml_top] = XmlElemNew(MyXmlDoc,"Top");
						if(ListLen(FormName,'_') eq 3)
						{
							MyXmlDoc.xmlRoot.XmlChildren[xml_top].XmlChildren[xArtir] = XmlElemNew(MyXmlDoc,ListGetAt(FormName,2,'_'));
							MyXmlDoc.xmlRoot.XmlChildren[xml_top].XmlChildren[xArtir].XmlText =FormValue;
							
							for(DimXList = 1; DimXList lte ListLen(DimensionList); DimXList=DimXList+1)
							{
								DimensionName = ListGetAt(DimensionList,DimXList);
								if(isDefined("x_#ListGetAt(FormName,2,'_')#_#DimensionName#_#ListGetAt(FormName,3,'_')#"))
									xValue = Evaluate('x_#ListGetAt(FormName,2,'_')#_#DimensionName#_#ListGetAt(FormName,3,'_')#');
								else
									xValue = "0";
	
								MyXmlDoc.xmlRoot.XmlChildren[xml_top].XmlChildren[xArtir].XmlAttributes[DimensionName] = xValue;
							}
							xArtir=xArtir+1;
						}
					}
								
					// y degerleri (Middle)
					if(isDefined("SayiList_y") and ListFirst(FormName,'_') is 'y' and ListFind(Evaluate('SayiList_y'),ListLast(FormName,'_'),','))					
					{
						if(xml_top lt 1)
							xml_middle = 1;
						else
							xml_middle = 2;	
									
						if(yArtir eq 1)
							MyXmlDoc.xmlRoot.XmlChildren[xml_middle] = XmlElemNew(MyXmlDoc,"Middle");

						if(ListLen(FormName,'_') eq 3)
						{						
							MyXmlDoc.xmlRoot.XmlChildren[xml_middle].XmlChildren[yArtir] = XmlElemNew(MyXmlDoc,ListGetAt(FormName,2,'_'));						
							MyXmlDoc.xmlRoot.XmlChildren[xml_middle].XmlChildren[yArtir].XmlText =FormValue;

							for(DimYList = 1; DimYList lte ListLen(DimensionList); DimYList=DimYList+1)
							{
								DimensionName = ListGetAt(DimensionList,DimYList);
								if(isDefined("y_#ListGetAt(FormName,2,'_')#_#DimensionName#_#ListGetAt(FormName,3,'_')#"))
									yValue = Evaluate('y_#ListGetAt(FormName,2,'_')#_#DimensionName#_#ListGetAt(FormName,3,'_')#');																
								else
									yValue = "0";
									
								MyXmlDoc.xmlRoot.XmlChildren[xml_middle].XmlChildren[yArtir].XmlAttributes[DimensionName] = yValue;
							}
							yArtir=yArtir+1;							
						}																						
					}
					
					// z degerleri (Bottom)
					if(isDefined("SayiList_z") and ListFirst(FormName,'_') is 'z' and ListFind(Evaluate('SayiList_z'),ListLast(FormName,'_'),','))
					{	
						if(xml_top eq 1)
						{
							if(xml_middle eq 2)
								xml_bottom = 3;
							else
								xml_bottom = 2;
						}
						else
						{
							if(xml_middle eq 1)
								xml_bottom = 2;
							else
								xml_bottom = 1;
						}
								
						if(zArtir eq 1)
							MyXmlDoc.xmlRoot.XmlChildren[xml_bottom] = XmlElemNew(MyXmlDoc,"Bottom");

						if(ListLen(FormName,'_') eq 3)
						{
							MyXmlDoc.xmlRoot.XmlChildren[xml_bottom].XmlChildren[zArtir] = XmlElemNew(MyXmlDoc,ListGetAt(FormName,2,'_'));
							MyXmlDoc.xmlRoot.XmlChildren[xml_bottom].XmlChildren[zArtir].XmlText =FormValue;
							
							for(DimZList = 1; DimZList lte ListLen(DimensionList); DimZList=DimZList+1)
							{
								DimensionName = ListGetAt(DimensionList,DimZList);
								if(isDefined("z_#ListGetAt(FormName,2,'_')#_#DimensionName#_#ListGetAt(FormName,3,'_')#"))
									zValue = Evaluate('z_#ListGetAt(FormName,2,'_')#_#DimensionName#_#ListGetAt(FormName,3,'_')#');
								else
									zValue = "0";
								MyXmlDoc.xmlRoot.XmlChildren[xml_bottom].XmlChildren[zArtir].XmlAttributes[DimensionName] = zValue;
							}
							zArtir=zArtir+1;
						}
					}				
				}	
			</cfscript>

			<cfset dosya = "#FormType_#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')#.xml"> 
			<cffile action="write" file="#upload_folder#settings\#dosya#" output="#toString(MyXmlDoc)#" charset="utf-8">
		</cfprocessingdirective>
		<cfsetting enablecfoutputonly="no">
		
	<!--- Setup_print_design tablosuna insert atiyoruz --->
		
		<cfif len(attributes.PrintDesignName) and len(dosya) and isdefined("attributes.design_id") and Len(attributes.design_id)>
			<cfquery name="add_setup_print_design" datasource="#dsn3#">
				UPDATE
					SETUP_PRINT_FILES
					
				SET
					NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PrintDesignName#">,
					TEMPLATE_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dosya#">,
					TEMPLATE_FILE_SERVER_ID = #fusebox.server_machine#,
					<cfif len(attributes.include_template)>
						IMAGE_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
						IMAGE_FILE_SERVER_ID = #fusebox.server_machine#,
					</cfif>
					DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#upload_folder#settings/#dosya#">,
					PROCESS_TYPE = #listfirst(attributes.PrintDesignType,'-')#,
					MODULE_ID = #listlast(attributes.PrintDesignType,'-')#,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_DATE = #now()#,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				WHERE
					FORM_ID = #attributes.design_id#
			</cfquery>
		<cfelse>
			<cfquery name="add_setup_print_design" datasource="#dsn3#">
				INSERT INTO
					SETUP_PRINT_FILES
				(
					ACTIVE,
					NAME,
					PROCESS_TYPE,
					MODULE_ID,
					TEMPLATE_FILE,
					TEMPLATE_FILE_SERVER_ID,
					DETAIL,
					IS_XML,
					IS_DEFAULT,
					IS_PARTNER,
					IS_STANDART,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PrintDesignName#">,
					#listfirst(attributes.PrintDesignType,'-')#,
					#listlast(attributes.PrintDesignType,'-')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#dosya#">,
					#fusebox.server_machine#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#upload_folder#settings/#dosya#">,
					1,
					0,
					0,
					0,
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				)
			</cfquery>
			<cfquery name="get_design_id" datasource="#dsn3#">
				SELECT MAX(FORM_ID) DESIGN_ID FROM SETUP_PRINT_FILES
			</cfquery>
			<cfset attributes.design_id = get_design_id.design_id>
		</cfif>
	</cftransaction>
</cflock>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_design_paper&design_id=#attributes.design_id#">
