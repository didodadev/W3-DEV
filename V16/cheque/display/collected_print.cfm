<cfquery name="get_print_cats" datasource="#dsn#">
	 SELECT 
    	PRINT_CAT_ID, 
        PRINT_MODULE_ID, 
        PRINT_NAME, 
        PRINT_NAME_ENG, 
        PRINT_TYPE, 
        PRINT_MODULE_NAME 
     FROM 
	     SETUP_PRINT_FILES_CATS
</cfquery>
<cfquery name="get_module_id" datasource="#dsn#">
	SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = 'cheque'
</cfquery>
<cfquery name="GET_DET_FORM" datasource="#dsn3#">
  	SELECT 
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME
	FROM 
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC
	WHERE
		SPF.MODULE_ID = #get_module_id.module_id# AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND
		SPFC.PRINT_TYPE = 110
</cfquery>

<cfparam name="attributes.first_number" default="">
<cfparam name="attributes.last_number" default="">
<cf_box  title="#getlang('','Toplu çek yazdır','50339')#" uidrop="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="cheque_print" method="post" action="#request.self#?fuseaction=cheque.popup_collected_print">
 <cf_box_search>
			<div class="form-group">
				<cfsavecontent variable="ilkcek"><cf_get_lang dictionary_id='51666.İlk Çek'></cfsavecontent>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="51670.İlk Çek No Girmelisiniz"></cfsavecontent>
                <cfinput type="text" value="#attributes.first_number#" name="first_number" placeholder="#ilkcek#" required="yes" message="#message#">
            </div>
			<div class="form-group">
				<cfsavecontent variable="soncek"><cf_get_lang dictionary_id='51672.Son Çek'></cfsavecontent>
				<cfsavecontent variable="message1"><cf_get_lang dictionary_id='51674.Son Çek Girmelisiniz'></cfsavecontent>
                <cfinput type="text" value="#attributes.last_number#" name="last_number" placeholder="#soncek#" required="yes" message="#message1#">
            </div>
            <div class="form-group">
                <select name="form_type" id="form_type">
                  <option value=""><cf_get_lang dictionary_id="57792.Modül İçi Yazıcı Belgeleri"></option>
                  <cfoutput query="GET_DET_FORM">
                    <option value="#form_id#" <cfif isdefined("attributes.form_type") and attributes.form_type eq form_id>selected</cfif>>
                        #name# - #print_name#
                    </option>
                  </cfoutput>
                </select>
            </div>
            <div class="form-group">
            	<cf_wrk_search_button button_type="4" search_function='kontrol()'>
					</div>
		</cf_box_search>
</cfform>
<cfif isdefined("attributes.form_type")>

<cfquery name="GET_FORM" datasource="#DSN3#">
  	SELECT 
		TEMPLATE_FILE,
		FORM_ID,
		NAME,
		PROCESS_TYPE,
		MODULE_ID,
		IS_STANDART
	FROM 
		SETUP_PRINT_FILES	
	WHERE
		FORM_ID = #attributes.form_type#
</cfquery>
	
	<cfset ilk_number_numeric = 0>
	<cfset son_number_numeric = 0>
	
	<cfloop from="#len(attributes.first_number)#" to="1" step="-1" index="i">
		<cfset karakter = mid(attributes.first_number,i,1)>
		<cfif not isnumeric(karakter)>			
			<cfset ilk_cek_no = listlast(attributes.first_number,karakter)>
			<cfset ilk_cek = listdeleteat(attributes.first_number,listlen(attributes.first_number,karakter),karakter) & karakter>
			<cfbreak>
		<cfelse>
			<cfset ilk_number_numeric = ilk_number_numeric + 1>
		</cfif>
	</cfloop>
	
	<cfloop from="#len(attributes.last_number)#" to="1" step="-1" index="i">
		<cfset karakter2 = mid(attributes.last_number,i,1)>
		<cfif not isnumeric(karakter2)>			
			<cfset son_cek_no = listlast(attributes.last_number,karakter)>
			<cfset son_cek = listdeleteat(attributes.last_number,listlen(attributes.last_number,karakter2),karakter2) & karakter2>
			<cfbreak>
		<cfelse>
			<cfset son_number_numeric = son_number_numeric + 1>
		</cfif>
	</cfloop>

<cfif ilk_number_numeric eq len(attributes.first_number)>
	<cfset ilk_cek = "">
	<cfset ilk_cek_no = attributes.first_number>
</cfif>

<cfif son_number_numeric eq len(attributes.last_number)>
	<cfset son_cek = "">
	<cfset son_cek_no = attributes.last_number>
</cfif>

<cfif son_cek neq ilk_cek>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='47501.Girilen Aralık Geçerli Değil!'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset cheque_number=",">
<cfquery name="cheques" datasource="#DSN2#">
	SELECT 
		CHEQUE_ID
	FROM 
		CHEQUE 
	WHERE 
	CHEQUE_STATUS_ID = 6 AND
	CHEQUE_NO BETWEEN '#ilk_cek#'+'#ilk_cek_no#' AND '#son_cek#'+'#son_cek_no#'

</cfquery>
<cfif cheques.recordCount>
<cfset cheque_list = valuelist(cheques.CHEQUE_ID,',')>
<cfset sayi = 0>
<!-- sil -->
	<cfset sayi = sayi + 1>
	<cfquery name="cheque_" datasource="#DSN2#">
		SELECT 
			CHEQUE.COMPANY_ID,
			CHEQUE.CHEQUE_CITY,
			CHEQUE.CHEQUE_DUEDATE,
			CHEQUE.CHEQUE_VALUE,
			CHEQUE.CURRENCY_ID,
			CHEQUE_NO,
			CHEQUE.ENDORSEMENT_MEMBER
		FROM 
			CHEQUE 
		WHERE 
			CHEQUE_ID IN (#cheque_list#)
	</cfquery>
	<!--- <cfset attributes.action_id = cheque_.cheque_id> --->
		<cf_grid_list>
			<thead>
				<th><cf_get_lang dictionary_id="50220.Çek No"></th>
				<th><cf_get_lang dictionary_id="57742.Tarih"></th>
				<th><cf_get_lang dictionary_id="63893.Şirket"></th>
				<th><cf_get_lang dictionary_id="57635.Miktar"></th>
				<th><cf_get_lang dictionary_id="57636.Birim"></th>
			</thead>
			<tbody>
				<cfoutput query="cheque_">
				<tr>
					<td>#CHEQUE_NO#</td>
				<td>IST #dateformat(cheque_duedate,dateformat_style)#</td>
				<td><cfif len(company_id)>
						 #get_par_info(company_id,1,1,0)# 
					<cfelse>
						<cf_get_lang dictionary_id='50291.Alım İade Faturası İşlem Kategorisi'>
					</cfif>
				</td>
				<td>#TLFormat(cheque_value)#</td>
				<td>
					<cfset txt_total_value = cheque_value>
					 <cfif txt_total_value gt 999999.99 and txt_total_value lt 2000000>Bir</cfif>
					<cf_n2txt number="txt_total_value"> #txt_total_value#
				</td>
				</tr>
			</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success"  onclick="window.open('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#cheque_list#</cfoutput>&print_type=110','print_page');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>"></i> <cf_get_lang dictionary_id="50111.Toplu Yazdır"></a>
		</cf_box_footer>
</cfif>
</cfif>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = document.cheque_print.form_type.selectedIndex;
	if (document.cheque_print.form_type[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id="57804.Baskı Formu Seçiniz!">");
		return false;
	}
	loadPopupBox('cheque_print' , '<cfoutput>#attributes.modal_id#</cfoutput>');
}
</script>
