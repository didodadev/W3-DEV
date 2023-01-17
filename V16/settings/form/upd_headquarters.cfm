<cfquery name="GET_HEADQUAR" datasource="#dsn#">
    SELECT 
        HEADQUARTERS_ID, 
        NAME, 
        HIERARCHY, 
        HEADQUARTERS_DETAIL, 
        IS_ORGANIZATION, 
        RECORD_DATE,
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP,
        UPDATE_IP, 
        UPPER_HEADQUARTERS_ID 
    FROM 
        SETUP_HEADQUARTERS 
    WHERE 
        HEADQUARTERS_ID=#attributes.head_id#
</cfquery>
<cfif isdefined("attributes.hr")>
    <cfset formun_adresi = 'settings.emptypopup_upd_headquarters&hr=1'>
    <cfset is_hr = 1>
<cfelse>
    <cfset formun_adresi = 'settings.emptypopup_upd_headquarters'>
    <cfset is_hr = 0>
</cfif>
<cfif not(isdefined('attributes.isAjax') and len(attributes.isAjax))>
    <cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang(951,'Üst Düzey birimler',42934)#" hide_table_column="1">
<cfform name="upd_headquarters" method="post" action="#request.self#?fuseaction=#formun_adresi#">
    <input type="hidden" value="<cfoutput>#head_id#</cfoutput>" name="head_id" id="head_id">
    <input type="hidden" value="<cfoutput>#get_headquar.name#</cfoutput>" name="head" id="head">
    <cfif isdefined("attributes.isAjax") and len(attributes.isAjax)><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
			<input type="hidden" name="callAjax" id="callAjax" value="1">	
		</cfif>
    <cfif len(GET_HEADQUAR.UPPER_HEADQUARTERS_ID)>
        <cfquery name="GET_UPPER_HEAD" datasource="#dsn#">
            SELECT NAME,HEADQUARTERS_ID FROM SETUP_HEADQUARTERS WHERE HEADQUARTERS_ID=#GET_HEADQUAR.UPPER_HEADQUARTERS_ID#
        </cfquery>
    </cfif>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id = "42984.Üst Düzey Birim"></cfsavecontent>
    <cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
		<cf_box title="#title#" closable="0">
	</cfif>
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_organization">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56059.Org Şemada Göster'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="Checkbox" name="is_organization" id="is_organization" value="1" <cfif get_headquar.is_organization eq 1>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfinput type="text" name="name" id="name" maxlength="200" value="#get_headquar.name#">
                            </div>
                        </div>
                        <div class="form-group" id="item-upper_headquarters_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42937.Üst Başkanlık'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <input type="hidden" name="upper_headquarters_id" id="upper_headquarters_id" value="<cfif isdefined("GET_UPPER_HEAD.recordcount") and GET_UPPER_HEAD.recordcount><cfoutput>#GET_UPPER_HEAD.HEADQUARTERS_ID#</cfoutput></cfif>">
                                    <input type="text" name="upper_headquarters_name" id="upper_headquarters_name" value="<cfif isdefined("GET_UPPER_HEAD.recordcount") and GET_UPPER_HEAD.recordcount><cfoutput>#GET_UPPER_HEAD.name#</cfoutput></cfif>" style="width:250px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_headquarters&field_name=upd_headquarters.upper_headquarters_name&field_id=upd_headquarters.upper_headquarters_id</cfoutput>','list');"></span>
                                </div>

                            </div>
                        </div>
                        <div class="form-group" id="item-hierarchy">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfinput type="text" name="hierarchy" id="hierarchy" maxlength="75" value="#get_headquar.hierarchy#">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Acıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="textmessage"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                <textarea name="detail" id="detail" style="width:250px;height:50px" message="<cfoutput>#textmessage#</cfoutput>" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_headquar.headquarters_detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <cfquery name="Get_HeadQuarters_Control" datasource="#dsn#">
                            SELECT TOP 1 HEADQUARTERS_ID FROM WORK_GROUP WHERE HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.head_id#">
                        </cfquery>
                        <cfif not Get_HeadQuarters_Control.RecordCount>
                            <cfquery name="Get_HeadQuarters_Control" datasource="#dsn#">
                                SELECT TOP 1 HEADQUARTERS_ID FROM OUR_COMPANY WHERE HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.head_id#">
                            </cfquery>
                        </cfif>
                        <cfif not Get_HeadQuarters_Control.RecordCount>
                            <cfquery name="Get_HeadQuarters_Control" datasource="#dsn#">
                                SELECT TOP 1 HEADQUARTERS_EXIST HEADQUARTERS_ID FROM PERSONEL_ROTATION_FORM WHERE HEADQUARTERS_EXIST = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.head_id#">
                            </cfquery>
                        </cfif>
                        <cfif not Get_HeadQuarters_Control.RecordCount>
                            <cfquery name="Get_HeadQuarters_Control" datasource="#dsn#"><!--- Ust Duzey Birimlerde Ust Duzey Baskanlik Alaninda Kullaniliyor --->
                                SELECT TOP 1 UPPER_HEADQUARTERS_ID HEADQUARTERS_ID FROM SETUP_HEADQUARTERS WHERE UPPER_HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.head_id#">
                            </cfquery>
                        </cfif>
                        <cfif Get_HeadQuarters_Control.RecordCount>
                            <cfset IsDelete_ = 0>
                        <cfelse>
                            <cfset IsDelete_ = 1>
                        </cfif>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                        <div class="col col-6"><cf_record_info query_name="get_headquar"></div> 
                        <div class="col col-6">
                            <cf_workcube_buttons type_format="1" add_function='kontrol()' is_upd='1' is_delete='#IsDelete_#' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_headquarters&is_hr=#is_hr#&head_id=#attributes.head_id#&head=#get_headquar.name#'>
                        </div>
                    </cf_box_footer>
           

</cfform>
</cf_box>
</div>

<script type="text/javascript">
function kontrol()
{
	if (document.getElementById('name').value == '')
	{
		alert("<cf_get_lang dictionary_id='58059.Başlık girmelisiniz'> !");
	  	return false;
	} 
	return true;
}
</script>