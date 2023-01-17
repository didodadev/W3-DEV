<cfsetting showdebugoutput="no">
<!--- <cfquery name="GET_EFATURA_CONTROL" datasource="#DSN#">
	SELECT
    	IS_EFATURA,
        EINVOICE_TYPE
	FROM
    	OUR_COMPANY_INFO
    WHERE
    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">        
</cfquery>
 --->
<cfscript>
	get_efatura_control_tmp= createObject("component","V16.e_government.cfc.einvoice");
	get_efatura_control_tmp.dsn = dsn;
	get_efatura_control = get_efatura_control_tmp.get_efatura_control_fnc(company_id:session.ep.company_id);
</cfscript> 
<cfset pageHead = "Xml Ekle">
<cf_catalystHeader>
<cfif len(get_efatura_control.is_efatura) and len(get_efatura_control.einvoice_type)>
	<cfoutput>
		<cfform name="upload_form_page" enctype="multipart/form-data" action="#request.self#?fuseaction=objects.emptypopup_add_efatura_xml">
        	<div class="row">
            	<div class="col col-12 uniqueRow">
                	<div class="row formContent">
                		<div class="row" type="row">
                			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            	<div class="form-group" id="item-file">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                                    <div class="col col-8 col-xs-12">
                                    	<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                                    </div>
                                </div>
                                <div class="form-group" id="item-process">
                                	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                    <div class="col col-8 col-xs-12">
                                    	<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                                    </div>
                                </div>
                            </div>
                		</div>
                        <div class="row formContentFooter">
                        	<div class="col col-12">
                            	<cf_workcube_buttons is_upd='0' is_cancel="0" is_delete=0 add_function='ekle_form_action()'>
                            </div>
                        </div>
                	</div>
                </div>
            </div>
		</cfform>
	</cfoutput>
<cfelse>
	<cf_get_lang dictionary_id="57532.Yetkiniz yok!">   
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="54246.Belge Seçmelisiniz"></cfsavecontent>
<script type="text/javascript">
function ekle_form_action()
{
	if(document.getElementById('uploaded_file').value == "")
	{
		alertObject({message:"<cfoutput>#message#</cfoutput>"})
		return false;
	}
	return process_cat_control();
}
</script>