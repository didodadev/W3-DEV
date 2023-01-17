<div class="col col-6 col-md-8 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='62257.E-Devlet Mükellef Aktarımı'></cfsavecontent>
    <cf_box title="#head#" collapsable="0" resize="0">
        <cfform name="formimport" action="#request.self#?fuseaction=settings.einvoice_comp_import" enctype="multipart/form-data" method="post">
            <input type="hidden" name="is_form_submitted" value="1" />
                <cf_box_elements>
                    <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                        <div class="form-group" id="item-uploaded-file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="file" name="uploaded_file" id="uploaded_file">
                            </div> 
                        </div>
                        <div class="form-group" id="item-explanation">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_get_lang dictionary_id='62258.GIB E-Fatura Portalından alınan XML formatındaki üye listesini Workcube''e aktararak üyelerin E-Fatura kullanıp kullanmadığı bilgisini günceller.'>
                            </div> 
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='control()'>
                </cf_box_footer>
        </cfform>
    </cf_box> 
</div>

<script type="text/javascript">
function control()
{
	var obj =  document.formimport.uploaded_file.value;		
	if ((obj == "") || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() != 'xml')){
		alert("Lütfen Xml Formatında Dosya Giriniz !");        
		return false;
	}	
	return true;
}
</script>
<cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
    <cftry>
        <cffile action = "upload" filefield = "uploaded_file" destination = "#upload_folder_#" nameconflict = "MakeUnique" mode="777" charset="UTF-8">
        <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
        <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="UTF-8">	
        <cfset file_size = cffile.filesize>
        <cfcatch type="Any">
            <script type="text/javascript">
                alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
                history.back();
            </script>
            <cfabort>
        </cfcatch>  
    </cftry>
    
    <cftry> 
        <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="UTF-8">
        <cffile action="delete" file="#upload_folder_##file_name#">
        <cfset xmlDoc = XmlParse(dosya)>   
        <cfset resources=xmlDoc.UserList.User>
        <cfset linecount=ArrayLen(xmlDoc.UserList.User)>
    <cfcatch>
        <script type="text/javascript">
            alert("XML Dosya Okunamadı. Belgenizi Kontrol Ediniz !");
            history.back();
        </script>
        <cfabort>
    </cfcatch>
    </cftry>

   
    <cfquery name="TRUN_EFAT_COMP" datasource="#DSN#">
        TRUNCATE TABLE EINVOICE_COMPANY_IMPORT
    </cfquery>
        
    <cfquery name="loopquery" datasource="#DSN#">
        <cfloop from="1" to="#linecount#" index="i">
            <cfset Register_Time_temp = replace(resources[i].FirstCreationTime.Xmltext,'T',' ')>
			<cfset alias_creation_temp = replace(resources[i].AliasCreationTime.Xmltext,'T',' ')>
            INSERT INTO EINVOICE_COMPANY_IMPORT (TAX_NO,ALIAS,COMPANY_FULLNAME,TYPE,REGISTER_DATE,ALIAS_CREATION_DATE)
            VALUES ('#resources[i].Identifier.Xmltext#','#resources[i].Alias.Xmltext#','#left(resources[i].Title.Xmltext,250)#','#resources[i].Type.Xmltext#','#Register_Time_temp#','#alias_creation_temp#')
        </cfloop>
    </cfquery> 
               
	<!---Kurumsal uye guncelleme--->        
    <cfquery name="UPD_COMP" datasource="#DSN#" result="xxx2">
        UPDATE COMPANY SET USE_EFATURA = 0,EFATURA_DATE = NULL WHERE USE_EFATURA = 1 
    </cfquery>
    
    <cfquery name="UPD_COMP" datasource="#DSN#" result="xxx">
        UPDATE 
            C
        SET 
            USE_EFATURA = 1, EFATURA_DATE = ECI.REGISTER_DATE
        FROM 
            COMPANY C, EINVOICE_COMPANY_IMPORT ECI
        WHERE 
            ECI.TAX_NO = C.TAXNO AND
            LEN(ECI.TAX_NO) = 10
    </cfquery>  
    
    <!---Bireysel uye guncelleme--->        
    <cfquery name="UPD_COMP" datasource="#DSN#" result="yyy2">
        UPDATE CONSUMER SET USE_EFATURA = 0,EFATURA_DATE = NULL WHERE USE_EFATURA = 1
    </cfquery>
            
    <cfquery name="UPD_COMP" datasource="#DSN#" result="yyy">
        UPDATE 
            C
        SET 
            USE_EFATURA = 1, EFATURA_DATE = ECI.REGISTER_DATE
        FROM 
            CONSUMER C, EINVOICE_COMPANY_IMPORT ECI
        WHERE 
            ECI.TAX_NO = C.TC_IDENTY_NO AND
            LEN(ECI.TAX_NO) = 11
    </cfquery>
    
	<cfoutput><font style="font-weight:bold"><cfoutput>#xxx.recordcount# Adet Kurumsal Üye, #yyy.recordcount# Adet Bireysel Üye Güncellendi.</cfoutput></font></cfoutput>
</cfif>
